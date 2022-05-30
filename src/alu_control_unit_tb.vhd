library ieee;
use ieee.std_logic_1164.all;

entity alu_control_unit_tb is
end entity;

architecture sim of alu_control_unit_tb is
	
-- Component declaration

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

	signal funct_sig	: std_logic_vector(5 downto 0);
	signal alu_op_sig	: std_logic_vector(1 downto 0);
	
	signal a_invert_sig	: std_logic;
	signal b_invert_sig	: std_logic;
	signal c_in_sig		: std_logic;

	signal operation_sig	: std_logic_vector(1 downto 0);


	constant alu_op_lw_sw	: std_logic_vector(1 downto 0) := "00";
	constant alu_op_beq		: std_logic_vector(1 downto 0) := "01";
	constant alu_op_rtype	: std_logic_vector(1 downto 0) := "10";
	
	constant funct_add		: std_logic_vector(5 downto 0) := "100000";
	constant funct_sub		: std_logic_vector(5 downto 0) := "100010";
	constant funct_and		: std_logic_vector(5 downto 0) := "100100";
	constant funct_or		: std_logic_vector(5 downto 0) := "100101";
	constant funct_slt		: std_logic_vector(5 downto 0) := "101010";

begin
	
	process
	begin
		-- LW/SW => ADD
		alu_op_sig <= alu_op_lw_sw;
		funct_sig <= (others => '0');
		wait for 5 ns;
		funct_sig <= (others => '1');
		wait for 5 ns;
		funct_sig <= funct_sub;
		wait for 5 ns;
		
		-- R-TYPE --
		alu_op_sig <= alu_op_rtype;
		
		-- ADD
		funct_sig <= funct_add;
		wait for 5 ns;
		-- SUB
		funct_sig <= funct_sub;
		wait for 5 ns;
		-- AND
		funct_sig <= funct_and;
		wait for 5 ns;
		-- OR
		funct_sig <= funct_or;
		wait for 5 ns;
		-- SLT
		funct_sig <= funct_slt;
		wait for 5 ns;
		
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;

-- Components instantiations

DUT: alu_control_unit
	port map (
		FUNCT		=>	funct_sig,
		ALU_OP		=>	alu_op_sig,

		A_INVERT	=>	a_invert_sig,
		B_INVERT	=>	b_invert_sig,
		C_IN		=>	c_in_sig,
		OPERATION	=>	operation_sig
	);

end architecture;