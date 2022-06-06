library ieee;
use ieee.std_logic_1164.all;

entity pipelined_mips is
generic (
	G_IMEM_ADDR_WIDTH	: integer := 32; -- only for simulation purpose to limit memory size (due to simulation limits)
	G_IMEM_FILE_NAME	: string := "source.txt"; -- instructions file name
	G_ADDR_WIDTH		: integer := 32; -- only for simulation purpose (due to simulation limits)
	G_DMEM_FILE_NAME	: string := "source.txt"; -- data file name
	G_FILE_HEX_FORMAT	: boolean := true -- if false file is in decimal format
);
port (
	CLK		: in std_logic;
	RST		: in std_logic
);
end entity;

architecture struct of pipelined_mips is
	
-- Component declaration
	
	component instruction_fetch_module is
	generic (
		G_IMEM_ADDR_WIDTH	: integer := 32; -- only for simulation purpose to limit memory size (due to simulation limits)
		G_IMEM_FILE_NAME	: string := "source.txt" -- instructions file name
	);
	port (
		PC_BRANCH_ADDR	: in std_logic_vector(31 downto 0);
		PC_JUMP_ADDR	: in std_logic_vector(31 downto 0);
		
		BRANCH_SEL		: in std_logic;
		JUMP_SEL		: in std_logic;
		
		CLK				: in std_logic;
		RST				: in std_logic;
		
		PC_PLUS_4_ADDR	: out std_logic_vector(31 downto 0);
		INSTRUCTION		: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component instruction_decode_module is
	port (
		INSTRUCTION		: in std_logic_vector(31 downto 0);
		PC_PLUS4		: in std_logic_vector(31 downto 0);
		
		WRITE_DATA		: in std_logic_vector(31 downto 0);
		WRITE_REG		: in std_logic_vector(4 downto 0);		--register to be written to
		REG_WRITE_IN	: in std_logic;							--write enable of the regfile
		
		CLK				: in std_logic;
		
		--Jump control signals
		BRANCH_EQUAL	: out std_logic;						--HIGH if branch and comparator outputs are HIGH
		JUMP			: out std_logic;
		
		--WB control signals
		MEM_TO_REG		: out std_logic;
		REG_WRITE_OUT	: out std_logic;
		
		--MEM control signals
		MEM_READ		: out std_logic;
		MEM_WRITE		: out std_logic;
		
		--EX control signals
		ALU_SRC			: out std_logic;
		REG_DST			: out std_logic;
		ALU_OP			: out std_logic_vector(1 downto 0);
		
		--data output
		READ_DATA_OUT1	: out std_logic_vector(31 downto 0);
		READ_DATA_OUT2	: out std_logic_vector(31 downto 0);
		IMMEDIATE_OUT	: out std_logic_vector(31 downto 0);
		FUNCT			: out std_logic_vector(5 downto 0);
		RT_REG			: out std_logic_vector(4 downto 0);
		RD_REG			: out std_logic_vector(4 downto 0);
		
		--branch addresses
		BRANCH_ADDRESS	: out std_logic_vector(31 downto 0);
		JUMP_ADDRESS	: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component execution_module is
	port (
		REG_DATA_IN1	: in std_logic_vector(31 downto 0);
		REG_DATA_IN2	: in std_logic_vector(31 downto 0);
		IMMEDIATE_IN	: in std_logic_vector(31 downto 0);
		FUNCT			: in std_logic_vector(5 downto 0);
		
		RT_REG			: in std_logic_vector(4 downto 0); -- Ins[20:16]
		RD_REG			: in std_logic_vector(4 downto 0); -- Ins[15:11]
		
		ALU_SRC			: in std_logic;
		ALU_OP			: in std_logic_vector(1 downto 0);
		REG_DST			: in std_logic;
		
		ALU_RESULT		: out std_logic_vector(31 downto 0);
		REG_OUT			: out std_logic_vector(4 downto 0)
	);
	end component;
	
	component data_memory is
	generic (
		G_ADDR_WIDTH		: integer := 32; -- only for simulation purpose (due to simulation limits)
		G_DMEM_FILE_NAME	: string := "source.txt"; -- data file name
		G_FILE_HEX_FORMAT	: boolean := true -- if false file is in decimal format
	);
	port (
		ADDR		: in std_logic_vector(31 downto 0) := (others => '0');
		WR_DATA		: in std_logic_vector(31 downto 0); -- data input
		
		CLK			: in std_logic;
		MEM_WR		: in std_logic; -- write enable
		MEM_RD		: in std_logic; -- read enable
		
		RD_DATA		: out std_logic_vector(31 downto 0) := (others => '0') -- data output
	);
	end component;
	
	component mux_n_bit_2to1 is
	generic(
		G_NUM_OF_BITS	: integer := 32
	);
	port(
		D_IN0	: in std_logic_vector((G_NUM_OF_BITS-1) downto 0);
		D_IN1	: in std_logic_vector((G_NUM_OF_BITS-1) downto 0);

		SEL		: in std_logic;	
		Q		: out std_logic_vector((G_NUM_OF_BITS-1) downto 0)
	);
	end component;
	
	component if_id_reg is
	port (
		CLK		: in std_logic;
		RST		: in std_logic;
		
		INSTRUCTION_IN		: in std_logic_vector(31 downto 0);
		PC_PLUS4_IN			: in std_logic_vector(31 downto 0);
		
		INSTRUCTION_OUT		: out std_logic_vector(31 downto 0);
		PC_PLUS4_OUT		: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component id_ex_reg is
	port (
		CLK		: in std_logic;
		RST		: in std_logic;
		
		--WB control signals in
		MEM_TO_REG_IN		: in std_logic;
		REG_WRITE_IN		: in std_logic;
		
		--MEM control signals in
		MEM_READ_IN			: in std_logic;
		MEM_WRITE_IN		: in std_logic;
		
		--EX control signals in
		ALU_SRC_IN			: in std_logic;
		REG_DST_IN			: in std_logic;
		ALU_OP_IN			: in std_logic_vector(1 downto 0);
		
		--data input
		READ_DATA1_IN		: in std_logic_vector(31 downto 0);
		READ_DATA2_IN		: in std_logic_vector(31 downto 0);
		IMMEDIATE_IN		: in std_logic_vector(31 downto 0);
		FUNCT_IN			: in std_logic_vector(5 downto 0);
		RT_REG_IN			: in std_logic_vector(4 downto 0);
		RD_REG_IN			: in std_logic_vector(4 downto 0);
		
		--WB control signals out
		MEM_TO_REG_OUT		: out std_logic;
		REG_WRITE_OUT		: out std_logic;
		
		--MEM control signals out
		MEM_READ_OUT		: out std_logic;
		MEM_WRITE_OUT		: out std_logic;
		
		--EX control signals out
		ALU_SRC_OUT			: out std_logic;
		REG_DST_OUT			: out std_logic;
		ALU_OP_OUT			: out std_logic_vector(1 downto 0);
		
		--data output
		READ_DATA1_OUT		: out std_logic_vector(31 downto 0);
		READ_DATA2_OUT		: out std_logic_vector(31 downto 0);
		IMMEDIATE_OUT		: out std_logic_vector(31 downto 0);
		FUNCT_OUT			: out std_logic_vector(5 downto 0);
		RT_REG_OUT			: out std_logic_vector(4 downto 0);
		RD_REG_OUT			: out std_logic_vector(4 downto 0)
	);
	end component;
	
	component ex_mem_reg is
	port (
		CLK		: in std_logic;
		RST		: in std_logic;
		
		--WB control signals in
		MEM_TO_REG_IN		: in std_logic;
		REG_WRITE_IN		: in std_logic;
		
		--MEM control signals in
		MEM_READ_IN			: in std_logic;
		MEM_WRITE_IN		: in std_logic;
		
		--data input
		ALU_RES_IN			: in std_logic_vector(31 downto 0);
		READ_DATA2_IN		: in std_logic_vector(31 downto 0);
		DEST_REG_IN			: in std_logic_vector(4 downto 0);
		
		--WB control signals out
		MEM_TO_REG_OUT		: out std_logic;
		REG_WRITE_OUT		: out std_logic;
		
		--MEM control signals out
		MEM_READ_OUT		: out std_logic;
		MEM_WRITE_OUT		: out std_logic;
		
		--data output
		ALU_RES_OUT			: out std_logic_vector(31 downto 0);
		READ_DATA2_OUT		: out std_logic_vector(31 downto 0);
		DEST_REG_OUT		: out std_logic_vector(4 downto 0)
	);
	end component;
	
	component mem_wb_reg is
	port (
		CLK		: in std_logic;
		RST		: in std_logic;
		
		--WB control signals in
		MEM_TO_REG_IN		: in std_logic;
		REG_WRITE_IN		: in std_logic;
		
		--data input
		ALU_RES_IN			: in std_logic_vector(31 downto 0);
		READ_DATA_IN		: in std_logic_vector(31 downto 0);
		DST_REG_IN			: in std_logic_vector(4 downto 0);
		
		--WB control signals out
		MEM_TO_REG_OUT		: out std_logic;
		REG_WRITE_OUT		: out std_logic;
		
		--data output
		ALU_RES_OUT			: out std_logic_vector(31 downto 0);
		READ_DATA_OUT		: out std_logic_vector(31 downto 0);
		DST_REG_OUT			: out std_logic_vector(4 downto 0)
	);
	end component;
	
-- Signals declaration
	
	-- Branch/Jump signals
	signal pc_branch_addr_sig	: std_logic_vector(31 downto 0);
	signal pc_jump_addr_sig		: std_logic_vector(31 downto 0);
	
	signal branch_sel_sig		: std_logic;
	signal jump_sel_sig			: std_logic;
	
	-- IF/ID register signals
	signal instruction_reg_in_sig	: std_logic_vector(31 downto 0);
	signal pc_plus4_reg_in_sig	    : std_logic_vector(31 downto 0);

	signal instruction_reg_out_sig	: std_logic_vector(31 downto 0);
	signal pc_plus4_reg_out_sig	    : std_logic_vector(31 downto 0);
	
	-- ID/EX register signals
		-- WB
		signal mem_to_reg_reg_in_sig	: std_logic;
		signal reg_write_reg_in_sig		: std_logic;
		
		signal mem_to_reg_inter_sig1	: std_logic;
		signal reg_write_inter_sig1		: std_logic;
		
		-- MEM
		signal mem_read_reg_in_sig		: std_logic;
		signal mem_write_reg_in_sig     : std_logic;
		
		signal mem_read_inter_sig		: std_logic;
		signal mem_write_inter_sig    	: std_logic;
		
		-- EX
		signal alu_src_reg_in_sig	: std_logic;
	    signal reg_dst_reg_in_sig	: std_logic;
	    signal alu_op_reg_in_sig	: std_logic_vector(1 downto 0);
		
		signal alu_src_reg_out_sig	: std_logic;
	    signal reg_dst_reg_out_sig	: std_logic;
	    signal alu_op_reg_out_sig	: std_logic_vector(1 downto 0);
	
		--data input
	    signal read_data1_reg_in_sig	: std_logic_vector(31 downto 0);
	    signal read_data2_reg_in_sig	: std_logic_vector(31 downto 0);
	    signal immediate_reg_in_sig		: std_logic_vector(31 downto 0);
	    signal funct_reg_in_sig			: std_logic_vector(5 downto 0);
	    signal rt_reg_reg_in_sig		: std_logic_vector(4 downto 0);
	    signal rd_reg_reg_in_sig		: std_logic_vector(4 downto 0);
		
		--data output
		signal read_data1_reg_out_sig	: std_logic_vector(31 downto 0);
	    signal read_data2_reg_out_sig	: std_logic_vector(31 downto 0);
	    signal immediate_reg_out_sig	: std_logic_vector(31 downto 0);
	    signal funct_reg_out_sig		: std_logic_vector(5 downto 0);
	    signal rt_reg_reg_out_sig		: std_logic_vector(4 downto 0);
	    signal rd_reg_reg_out_sig		: std_logic_vector(4 downto 0);
		
	
	-- EX/MEM register signals
		-- WB
		signal mem_to_reg_inter_sig2	: std_logic;
		signal reg_write_inter_sig2		: std_logic;

		--MEM control signals
		signal mem_read_reg_out_sig		: std_logic;
		signal mem_write_reg_out_sig	: std_logic;

		--data input
		signal alu_result_reg_in_sig	: std_logic_vector(31 downto 0);
		signal dst_reg_out_reg_in_sig	: std_logic_vector(4 downto 0);
		
		--data output
		signal alu_result_reg_out_sig	: std_logic_vector(31 downto 0);
		signal d_mem_wr_data_sig		: std_logic_vector(31 downto 0);
		signal dst_reg_out_inter_sig	: std_logic_vector(4 downto 0);
	
	-- MEM/WB register signals
		--data input
		signal d_mem_rd_data_sig	:	std_logic_vector(31 downto 0);
		
		--WB control signals out
		signal mem_to_reg_sig	: std_logic;
		signal reg_write_sig	: std_logic;
		
		--data output
		signal alu_res_reg_out_sig		: std_logic_vector(31 downto 0);
		signal read_data_reg_out_sig	: std_logic_vector(31 downto 0);
		signal dst_reg_reg_out_sig		: std_logic_vector(4 downto 0);
	
	
	signal write_data_sig	: std_logic_vector(31 downto 0);
	
begin

-- For simulation purposes only!
	process(CLK)
	begin
		if rising_edge(CLK) then
			if instruction_reg_in_sig = X"ffffffff" then
			-- stopping the program
			report "end of program" severity failure;
			end if;
		end if;
	end process;


-- Components instantiations

INSTRUCTION_FETCH: instruction_fetch_module
	generic map (
		G_IMEM_ADDR_WIDTH	=>	G_IMEM_ADDR_WIDTH,
		G_IMEM_FILE_NAME	=>	G_IMEM_FILE_NAME
	)
	port map (
		PC_BRANCH_ADDR		=>	pc_branch_addr_sig,
		PC_JUMP_ADDR		=>	pc_jump_addr_sig,
		
		BRANCH_SEL			=>	branch_sel_sig,
		JUMP_SEL			=>	jump_sel_sig,
		
		CLK					=>	CLK,
		RST					=>	RST,
		
		PC_PLUS_4_ADDR		=>	pc_plus4_reg_in_sig,
		INSTRUCTION			=>	instruction_reg_in_sig
	);

IF_ID_REGISTER: if_id_reg
	port map (
		CLK				=>	CLK,
		RST				=>	RST,
		
		INSTRUCTION_IN	=>	instruction_reg_in_sig,
		PC_PLUS4_IN		=>	pc_plus4_reg_in_sig,
		
		INSTRUCTION_OUT	=>	instruction_reg_out_sig,
		PC_PLUS4_OUT	=>	pc_plus4_reg_out_sig
	);

INSTRUCTION_DECODE: instruction_decode_module
	port map (
		INSTRUCTION		=>	instruction_reg_out_sig,
		PC_PLUS4		=>	pc_plus4_reg_out_sig,
		
		WRITE_DATA		=>	write_data_sig,
		WRITE_REG		=>	dst_reg_reg_out_sig,
		REG_WRITE_IN	=>	reg_write_sig,
		
		CLK				=>	CLK,
		
		--Jump control signals
		BRANCH_EQUAL	=>	branch_sel_sig,
		JUMP			=>	jump_sel_sig,
		
		--WB control signals
		MEM_TO_REG		=>	mem_to_reg_reg_in_sig,
		REG_WRITE_OUT	=>	reg_write_reg_in_sig,
		
		--MEM control signals
		MEM_READ		=>	mem_read_reg_in_sig,
		MEM_WRITE		=>	mem_write_reg_in_sig,
		
		--EX control signals
		ALU_SRC			=>	alu_src_reg_in_sig,
		REG_DST			=>	reg_dst_reg_in_sig,
		ALU_OP			=>	alu_op_reg_in_sig,
		
		--data output
		READ_DATA_OUT1	=>	read_data1_reg_in_sig,
		READ_DATA_OUT2	=>	read_data2_reg_in_sig,
		IMMEDIATE_OUT	=>	immediate_reg_in_sig,
		FUNCT			=>	funct_reg_in_sig,
		RT_REG			=>	rt_reg_reg_in_sig,
		RD_REG			=>	rd_reg_reg_in_sig,
		
		--branch addresses
		BRANCH_ADDRESS	=>	pc_branch_addr_sig,
		JUMP_ADDRESS	=>	pc_jump_addr_sig
	);
	
ID_EX_REGISTER: id_ex_reg
	port map (
		CLK				=>	CLK,
		RST				=>	RST,
		
		--WB control signals in
		MEM_TO_REG_IN	=>	mem_to_reg_reg_in_sig,
		REG_WRITE_IN	=>	reg_write_reg_in_sig,
		
		--MEM control signals in
		MEM_READ_IN		=>	mem_read_reg_in_sig,
		MEM_WRITE_IN	=>	mem_write_reg_in_sig,
		
		--EX control signals in
		ALU_SRC_IN		=>	alu_src_reg_in_sig,
		REG_DST_IN		=>	reg_dst_reg_in_sig,
		ALU_OP_IN		=>	alu_op_reg_in_sig,
		
		--data input
		READ_DATA1_IN	=>	read_data1_reg_in_sig,
		READ_DATA2_IN	=>	read_data2_reg_in_sig,	
		IMMEDIATE_IN	=>	immediate_reg_in_sig,	
		FUNCT_IN		=>	funct_reg_in_sig,	
		RT_REG_IN		=>	rt_reg_reg_in_sig,	
		RD_REG_IN		=>	rd_reg_reg_in_sig,	
		
		--WB control signals out
		MEM_TO_REG_OUT	=>	mem_to_reg_inter_sig1,
		REG_WRITE_OUT	=>	reg_write_inter_sig1,
		
		--MEM control signals out
		MEM_READ_OUT	=>	mem_read_inter_sig,
		MEM_WRITE_OUT	=>	mem_write_inter_sig,
		
		--EX control signals out
		ALU_SRC_OUT		=>	alu_src_reg_out_sig,
		REG_DST_OUT		=>	reg_dst_reg_out_sig,
		ALU_OP_OUT		=>	alu_op_reg_out_sig,
		
		--data output
		READ_DATA1_OUT	=>	read_data1_reg_out_sig,
		READ_DATA2_OUT	=>	read_data2_reg_out_sig,
		IMMEDIATE_OUT	=>	immediate_reg_out_sig,
		FUNCT_OUT		=>	funct_reg_out_sig,
		RT_REG_OUT		=>	rt_reg_reg_out_sig,
		RD_REG_OUT		=>	rd_reg_reg_out_sig
	);

EXECUTION: execution_module
	port map (
		REG_DATA_IN1	=>	read_data1_reg_out_sig,
		REG_DATA_IN2	=>	read_data2_reg_out_sig,
		IMMEDIATE_IN	=>	immediate_reg_out_sig,
		FUNCT			=>	funct_reg_out_sig,
	
		RT_REG			=>	rt_reg_reg_out_sig,
		RD_REG			=>	rd_reg_reg_out_sig,

		ALU_SRC			=>	alu_src_reg_out_sig,
		ALU_OP			=>	alu_op_reg_out_sig,
		REG_DST			=>	reg_dst_reg_out_sig,

		ALU_RESULT		=>	alu_result_reg_in_sig,
		REG_OUT			=>	dst_reg_out_reg_in_sig
	);
	
EX_MEM_REGISTER: ex_mem_reg
	port map (
		CLK				=>	CLK,
		RST				=>	RST,
		
		--WB control signals in
		MEM_TO_REG_IN	=>	mem_to_reg_inter_sig1,
		REG_WRITE_IN	=>	reg_write_inter_sig1,
		
		--MEM control signals in
		MEM_READ_IN		=>	mem_read_inter_sig,
		MEM_WRITE_IN	=>	mem_write_inter_sig,
		
		--data input
		ALU_RES_IN		=>	alu_result_reg_in_sig,
		READ_DATA2_IN	=>	read_data2_reg_out_sig,
		DEST_REG_IN		=>	dst_reg_out_reg_in_sig,
		
		--WB control signals out
		MEM_TO_REG_OUT	=>	mem_to_reg_inter_sig2,
		REG_WRITE_OUT	=>	reg_write_inter_sig2,
		
		--MEM control signals out
		MEM_READ_OUT	=>	mem_read_reg_out_sig,
		MEM_WRITE_OUT	=>	mem_write_reg_out_sig,
		
		--data output
		ALU_RES_OUT		=>	alu_result_reg_out_sig,
		READ_DATA2_OUT	=>	d_mem_wr_data_sig,
		DEST_REG_OUT	=>	dst_reg_out_inter_sig
	);
	
DATA_MEM: data_memory
	generic map (
		G_ADDR_WIDTH		=>	G_ADDR_WIDTH,
		G_DMEM_FILE_NAME	=>	G_DMEM_FILE_NAME,
		G_FILE_HEX_FORMAT	=>	G_FILE_HEX_FORMAT
	)
	port map (
		ADDR		=>	alu_result_reg_out_sig,
		WR_DATA		=>	d_mem_wr_data_sig,
		
		CLK			=>	CLK,
		MEM_WR		=>	mem_write_reg_out_sig,
		MEM_RD		=>	mem_read_reg_out_sig,
		
		RD_DATA		=>	d_mem_rd_data_sig
	);

MEM_WB_REGISTER: mem_wb_reg
	port map (
		CLK		           	=>	CLK,
		RST		           	=>	RST,
		
		--WB control signals in
		MEM_TO_REG_IN		=>	mem_to_reg_inter_sig2,
		REG_WRITE_IN		=>  reg_write_inter_sig2,
		
		--data input
		ALU_RES_IN			=>	alu_result_reg_out_sig,
		READ_DATA_IN		=>	d_mem_rd_data_sig,
		DST_REG_IN			=>	dst_reg_out_inter_sig,
		
		--WB control signals out
		MEM_TO_REG_OUT		=>	mem_to_reg_sig,
		REG_WRITE_OUT		=>  reg_write_sig,
		
		--data output
		ALU_RES_OUT			=>	alu_res_reg_out_sig,
		READ_DATA_OUT		=>  read_data_reg_out_sig,
		DST_REG_OUT			=>  dst_reg_reg_out_sig
	);
	
WRITE_BACK: mux_n_bit_2to1
	generic map (
		G_NUM_OF_BITS	=> 32
	)
	port map (
		D_IN0	=>	alu_res_reg_out_sig,
		D_IN1	=>	read_data_reg_out_sig,
		
		SEL		=>	mem_to_reg_sig,
		Q		=>	write_data_sig
	);
	
end architecture;