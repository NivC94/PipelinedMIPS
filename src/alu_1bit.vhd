library ieee;
use ieee.std_logic_1164.all;

entity alu_1bit is
port(
	FUNCT			: in std_logic_vector(5 downto 0);
	ALU_OP			: in std_logic_vector(1 downto 0);
	
	ALU_CONTROL		: out std_logic_vector(2 downto 0)
);
end entity;

architecture behave of alu_1bit is

	constant alu_op_lw_sw		: std_logic_vector(1 downto 0) := "00";
	constant alu_op_beq			: std_logic_vector(1 downto 0) := "01";
	constant alu_op_rtype		: std_logic_vector(1 downto 0) := "10";
	
	constant funct_add		: std_logic_vector(5 downto 0) := "100000";
	constant funct_sub		: std_logic_vector(5 downto 0) := "100010";
	constant funct_and		: std_logic_vector(5 downto 0) := "100100";
	constant funct_or		: std_logic_vector(5 downto 0) := "100101";
	constant funct_slt		: std_logic_vector(5 downto 0) := "101010";

begin

	
	
end architecture;