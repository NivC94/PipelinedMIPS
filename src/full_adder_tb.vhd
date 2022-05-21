library ieee;
use ieee.std_logic_1164.all;

entity full_adder_tb is
end entity;

architecture sim of full_adder_tb is
	
-- Component declaration

	component full_adder
		port(
			A		: in	std_logic;
			B		: in	std_logic;
			C_IN	: in	std_logic;
			
			SUM		: out	std_logic;
			C_OUT	: out	std_logic
		);
	end component;

-- Signals declaration

	signal a		: std_logic;
	signal b		: std_logic;
	signal c_in		: std_logic;

	signal sum		: std_logic;
	signal c_out	: std_logic;
begin
	
	a		<= '0', '1' after 20 ns;
	b		<= '0', '1' after 10 ns,'0' after 20 ns, '1' after 30 ns;
	c_in	<= '0',	'1' after 5 ns,'0' after 10 ns,'1' after 15 ns,'0' after 20 ns,'1' after 25 ns,'0' after 30 ns,'1' after 35 ns;

-- Components instantiations

DUT: full_adder
	port map (
		A		=>	a,
		B		=>	b,
		C_IN	=>	c_in,
		
		SUM		=>	sum,
		C_OUT	=>	c_out
	);
	
end architecture;