library ieee;
use ieee.std_logic_1164.all;

entity execution_module is
port (
	REG_DATA_IN1	: in std_logic_vector(31 downto 0);
	REG_DATA_IN2	: in std_logic_vector(31 downto 0);
	IMMEDIATE_IN	: in std_logic_vector(31 downto 0);
	FUNCT			: in std_logic_vector(31 downto 0);
	
	RT_REG			: in std_logic_vector(4 downto 0); -- Ins[20:16]
	RD_REG			: in std_logic_vector(4 downto 0); -- Ins[15:11]
	
	ALU_SRC			: in std_logic;
	ALU_OP			: in std_logic_vector(1 downto 0);
	REG_DST			: in std_logic;
	
	ALU_RESULT		: out std_logic_vector(31 downto 0);
	REG_OUT			: out std_logic_vector(4 downto 0)
);
end entity;

architecture struct of execution_module is
	
-- Component declaration
	
	component mux2to1_32bit is
	port(
		D_IN0	: in std_logic_vector(31 downto 0);
		D_IN1	: in std_logic_vector(31 downto 0);

		SEL		: in std_logic;	
		Q		: out std_logic_vector(31 downto 0)
	);
	end component;
	
-- Signals declaration
	
	signal pc_in_sig					: std_logic_vector(31 downto 0);
	signal pc_out_sig					: std_logic_vector(31 downto 0);
	
	signal pc_plus_4_sig				: std_logic_vector(31 downto 0);
	signal branch_addition_sig			: std_logic_vector(31 downto 0);
	signal pc_branch_sig				: std_logic_vector(31 downto 0);
	signal pc_jump_sig					: std_logic_vector(31 downto 0);
	
	signal branch_mux_to_jump_mux		: std_logic_vector(31 downto 0);
	
	signal instruction_sig				: std_logic_vector(31 downto 0);
	signal instruction_imm_sign_ext_sig	: std_logic_vector(13 downto 0); -- signal for instruction immediate sign extension
	
begin

-- Components instantiations

I_MEM: instruction_memory
	generic map (
		G_ADDR_WIDTH		=>	g_addr_width,
		G_IMEM_FILE_NAME	=>	g_imem_file_name
	)
	port map (
		READ_ADDR	=>	pc_out_sig,
		
		INSTRUCTION	=> instruction_sig
	);
	
PC: pc_reg
	port map (
		PC_IN	=>	pc_in_sig,
	    
	    CLK		=>	clk,
	    RST		=>	rst,
	    
		PC_OUT	=>	pc_out_sig
	);
	
ADDER_PLUS_4: adder_32bits
	port map (
		A		=>	pc_out_sig,
	    B		=>	CONST_4,
	    
	    SUM		=>	pc_plus_4_sig
	);
	
ADDER_BRANCH: adder_32bits
	port map (
		A		=>	pc_plus_4_sig,
	    B		=>	branch_addition_sig,
	    
	    SUM		=>	pc_branch_sig
	);
	
BRANCH_MUX: mux2to1_32bit
	port map (
		D_IN0	=>	pc_plus_4_sig,
		D_IN1	=>	pc_branch_sig,
		
		SEL		=>	BRANCH_SEL,
		Q		=>	branch_mux_to_jump_mux
	);
	
JUMP_MUX: mux2to1_32bit
	port map (
		D_IN0	=>	branch_mux_to_jump_mux,
		D_IN1	=>	pc_jump_sig,
		
		SEL		=>	JUMP_SEL,
		Q		=>	pc_in_sig
	);
	
	-- duplicate the sign bit
	instruction_imm_sign_ext_sig <= (others => instruction_sig(15));
	-- sign extension an shift 2 left of the instruction immediate using concatenation
	branch_addition_sig <= instruction_imm_sign_ext_sig & instruction_sig(15 downto 0) & "00";
	-- concatenation the upper 4 bits of PC+4 and 26 bit of the instruction with shift 2 left
	pc_jump_sig <= pc_plus_4_sig(31 downto 28) & instruction_sig(25 downto 0) & "00";
	
	INSTRUCTION <= instruction_sig;
	
end architecture;