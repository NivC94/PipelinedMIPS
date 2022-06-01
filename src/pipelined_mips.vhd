library ieee;
use ieee.std_logic_1164.all;

entity pipelined_mips is
port (
	CLK		: in std_logic;
	RST		: in std_logic;
);
end entity;

architecture struct of pipelined_mips is
	
-- Component declaration
	
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
	
	component alu_32bit is
	port(
		A			: in std_logic_vector(31 downto 0);
		B			: in std_logic_vector(31 downto 0);
		C_IN		: in std_logic;
		
		A_INVERT	: in std_logic;
		B_INVERT	: in std_logic;
		
		OPERATION	: in std_logic_vector(1 downto 0);
		
		RESULT		: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component alu_control_unit is
	port(
		FUNCT			: in std_logic_vector(5 downto 0);
		ALU_OP			: in std_logic_vector(1 downto 0);
		
		A_INVERT		: out std_logic := '0';
		B_INVERT		: out std_logic;
		C_IN			: out std_logic;
		OPERATION		: out std_logic_vector(1 downto 0)
	);
	end component;
	
-- Signals declaration
	
	signal alu_b_in_sig		: std_logic_vector(31 downto 0);
	
	signal alu_a_invert_sig	: std_logic;
	signal alu_b_invert_sig	: std_logic;
	signal alu_c_in_sig		: std_logic;

	signal alu_operation_sig	: std_logic_vector(1 downto 0);
	
begin

-- Components instantiations

ALU_SRC_MUX: mux_n_bit_2to1
	generic map (
		G_NUM_OF_BITS => 32
	)
	port map (
		D_IN0	=>	REG_DATA_IN2,
		D_IN1	=>	IMMEDIATE_IN,
		SEL		=>	ALU_SRC,
		
		Q		=>	alu_b_in_sig
	);
	
REG_DST_MUX: mux_n_bit_2to1
	generic map (
		G_NUM_OF_BITS => 5
	)
	port map (
		D_IN0	=>	RT_REG,
		D_IN1	=>	RD_REG,
		SEL		=>	REG_DST,
		
		Q		=>	REG_OUT
	);

ALU: alu_32bit
	port map (
		A			=>	REG_DATA_IN1,
		B			=>	alu_b_in_sig,
		C_IN		=>	alu_c_in_sig,
		
		A_INVERT	=>	alu_a_invert_sig,
		B_INVERT	=>	alu_b_invert_sig,
		
		OPERATION	=>	alu_operation_sig,
		
		RESULT		=>	ALU_RESULT
	);

ALU_CONTROL: alu_control_unit
	port map (
		FUNCT		=>	FUNCT,
		ALU_OP		=>	ALU_OP,

		A_INVERT	=>	alu_a_invert_sig,
		B_INVERT	=>	alu_b_invert_sig,
		C_IN		=>	alu_c_in_sig,
		OPERATION	=>	alu_operation_sig
	);
	
end architecture;