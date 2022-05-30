library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity instruction_decode_module_tb is
end entity;

architecture sim of instruction_decode_module_tb is

-- Constants declaration

	constant C_CLK_PRD : time := 10 ns;
	
	component instruction_decode_module is
	port (
		INSTRUCTION		: in std_logic_vector(31 downto 0);
		PC_PLUS4		: in std_logic_vector(31 downto 0);
		
		WRITE_DATA		: in std_logic_vector(31 downto 0);
		WRITE_REG		: in std_logic_vector(4 downto 0);		--register to be written to
		REG_WRITE_IN	: in std_logic;							--write enable of the regfile
		
		CLK				: in std_logic;
		
		--Jump controll signals
		BRANCH_EQUAL	: out std_logic;						--HIGH if branch and comparator outputs are HIGH
		JUMP			: out std_logic;
		
		--WB controll signals
		MEM_TO_REG		: out std_logic;
		REG_WRITE_OUT	: out std_logic;
		
		--MEM controll signals
		MEM_READ		: out std_logic;
		MEM_WRITE		: out std_logic;
		
		--EX controll signals
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
	
-- Signals declaration
	
	signal instruction_sig		: std_logic_vector (31 downto 0):=(others => '0');
	signal pc_plus4_sig			: std_logic_vector (31 downto 0):=(others => '0');
	
	signal write_data_sig		: std_logic_vector (31 downto 0):=(others => '0');
	signal write_reg_sig		: std_logic_vector (4 downto 0):=(others => '0');
	signal reg_write_in_sig		: std_logic := '0';
	
	signal clk_sig				: std_logic := '1';
	
	signal branch_equal_sig		: std_logic := '0';
	signal jump_sig				: std_logic := '0';
	
	signal mem_to_reg_sig		: std_logic := '0';
	signal reg_write_out_sig	: std_logic := '0';
	
	signal mem_read_sig			: std_logic := '0';
	signal mem_write_sig		: std_logic := '0';
	
	signal alu_src_sig			: std_logic := '0';
	signal reg_dst_sig			: std_logic := '0';
	signal alu_op_sig			: std_logic_vector (1 downto 0):= (others => '0');
	
	signal read_data_out1_sig	: std_logic_vector (31 downto 0):= (others => '0');
	signal read_data_out2_sig	: std_logic_vector (31 downto 0):= (others => '0');
	signal immediate_out_sig	: std_logic_vector (31 downto 0):= (others => '0');
	signal funct_sig			: std_logic_vector (5 downto 0):= (others => '0');
	signal rt_reg_sig			: std_logic_vector (4 downto 0):= (others => '0');
	signal rd_reg_sig			: std_logic_vector (4 downto 0):= (others => '0');
	
	signal branch_address_sig	: std_logic_vector (31 downto 0):= (others => '0');
	signal jump_address_sig		: std_logic_vector (31 downto 0):= (others => '0');
	
begin

-- Components instantiations

DUT: instruction_decode_module
	port map(
		INSTRUCTION		=>	instruction_sig,		 
		PC_PLUS4		=>	pc_plus4_sig,			
		                    
		WRITE_DATA		=>	write_data_sig,		
		WRITE_REG		=>	write_reg_sig,
		REG_WRITE_IN	=>	reg_write_in_sig,		
							
		CLK 			=>	clk_sig,		
							
		BRANCH_EQUAL	=>	branch_equal_sig,	
		JUMP			=>	jump_sig,			
							
		MEM_TO_REG		=>	mem_to_reg_sig,	
		REG_WRITE_OUT	=>	reg_write_out_sig,
							
		MEM_READ		=>	mem_read_sig,		
		MEM_WRITE		=>	mem_write_sig,
							
		ALU_SRC			=>	alu_src_sig,		
		REG_DST			=>	reg_dst_sig,	
		ALU_OP			=>	alu_op_sig,	
							
		READ_DATA_OUT1	=>	read_data_out1_sig,
		READ_DATA_OUT2	=>	read_data_out2_sig,
		IMMEDIATE_OUT	=>	immediate_out_sig,
		FUNCT			=>	funct_sig,
		RT_REG			=>	rt_reg_sig,
		RD_REG			=>	rd_reg_sig,
							
		BRANCH_ADDRESS	=>	branch_address_sig,
		JUMP_ADDRESS	=>	jump_address_sig	
	);
	
	-- generate clock signal with period of C_CLK_PRD
	process
    begin
        clk_sig <= '1';
        wait for C_CLK_PRD / 2;
        clk_sig <= '0';
        wait for C_CLK_PRD / 2;
    end process;
	
	process
	begin
		
		reg_write_in_sig <= '1';
		
		for i in 0 to 31 loop
			write_reg_sig <= std_logic_vector(to_unsigned(i,5));
			write_data_sig <= write_data_sig + 1;
			wait for C_CLK_PRD;
		end loop;
		
		reg_write_in_sig <= '0';
		
		wait for C_CLK_PRD;
		instruction_sig	<=	"10001100000010000000000001010000";	--lw $8,80($0)
		wait for C_CLK_PRD;	
		instruction_sig	<=	"00100000000010010000000000000100"; --addi $9,$0,4 
		wait for C_CLK_PRD;
		instruction_sig	<=	"00000001001010000101000000101010"; --slt $10,$9,$8  
		wait for C_CLK_PRD;
		instruction_sig	<=	"00010001010000000000000000010001"; --beq $10,$0,17
		wait for C_CLK_PRD;
		instruction_sig	<=	"00100000000000010000000000000100"; --addi $1,$0,4 
		wait for C_CLK_PRD;
		instruction_sig	<=	"00000001001000010101000000100010"; --sub $10,$9,$1
		wait for C_CLK_PRD;
		instruction_sig	<=	"10001101001010110000000000000000";	--lw $11,0($9) 
		wait for C_CLK_PRD;
		instruction_sig	<=	"10001101010011000000000000000000"; --lw $12,0($10)
		wait for C_CLK_PRD;
		instruction_sig	<=	"00000001011011000110100000101010"; --slt $13,$11,$12 
		wait for C_CLK_PRD;
		instruction_sig	<=	"00010001101000000000000000000110"; --beq $13,$0,6 
		wait for C_CLK_PRD;
		instruction_sig	<=	"10101101010011000000000000000100";	--sw $12,4($10)
		wait for C_CLK_PRD;
		instruction_sig	<=	"00000000000010100110000000101010"; --slt $12,$0,$10
		wait for C_CLK_PRD;
		instruction_sig	<=	"00010001100000000000000000000101"; --beq $12,$0,5
		wait for C_CLK_PRD;
		instruction_sig	<=	"00100000000000010000000000000100"; --addi $1,$0,4 
		wait for C_CLK_PRD;
		instruction_sig	<=	"00000001010000010101000000100010"; --sub $10,$10,$1
		wait for C_CLK_PRD;
		instruction_sig	<=	"00001000000000000000110000000111"; --j 0x0000301c
		wait for C_CLK_PRD;
		instruction_sig	<=	"10101101010010110000000000000100"; --sw $11,4($10)
		wait for C_CLK_PRD;
		instruction_sig	<=	"00001000000000000000110000010011"; --j 0x0000304c 
		wait for C_CLK_PRD;
		instruction_sig	<=	"10101101010010110000000000000000"; --sw $11,0($10)
		wait for C_CLK_PRD;
		instruction_sig	<=	"00100001001010010000000000000100"; --addi $9,$9,4
		wait for C_CLK_PRD;
		instruction_sig	<=	"00001000000000000000110000000010"; --j 0x00003008
		wait for C_CLK_PRD;
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;
	
end architecture;	