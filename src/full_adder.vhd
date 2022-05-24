library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
	port(
		A		: in	std_logic;
		B		: in	std_logic;
		C_IN	: in	std_logic;
		
		SUM		: out	std_logic;
		C_OUT	: out	std_logic
	);
end entity;

architecture behave of full_adder is
begin

	SUM		<= (A xor B) xor C_IN;
	C_OUT	<= (A and B) or (A and C_IN) or (B and C_IN);
	
end architecture;