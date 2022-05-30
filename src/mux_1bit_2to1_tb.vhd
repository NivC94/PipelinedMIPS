library ieee;
use ieee.std_logic_1164.all;

entity mux_1bit_2to1_tb is
end entity;

architecture sim of mux_1bit_2to1_tb is

-- Component declaration

	component mux_1bit_2to1
		port(
			D_IN0	: in std_logic;
			D_IN1	: in std_logic;
		    
			SEL		: in std_logic;	
			Q		: out std_logic
		);
	end component;

-- Signals declaration
	signal d_in0	: std_logic;
	signal d_in1	: std_logic;
	signal sel		: std_logic;

	signal q		: std_logic;
	
begin
	
	d_in0	<= '1', '0' after 20 ns;
	d_in1	<= '0', '1' after 20 ns;
	sel		<= '0',	'1' after 5 ns,'0' after 10 ns,'1' after 15 ns,'0' after 20 ns,'1' after 25 ns,'0' after 30 ns,'1' after 35 ns;

-- Components instantiations

DUT: mux_1bit_2to1
	port map (
		D_IN0	=>	d_in0,
		D_IN1	=>	d_in1,
		SEL		=>	sel,
		
		Q		=>	q
	);
	
end architecture;