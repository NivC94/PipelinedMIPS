library ieee;
use ieee.std_logic_1164.all;

entity mux_n_bit_2to1_tb is
end entity;

architecture sim of mux_n_bit_2to1_tb is

-- Constants declaration

	constant C_NUM_OF_BITS : integer := 32;

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

-- Signals declaration
	signal d_in0	: std_logic_vector(31 downto 0);
	signal d_in1	: std_logic_vector(31 downto 0);
	signal sel		: std_logic;

	signal q		: std_logic_vector(31 downto 0);
	
begin
	
	d_in0	<= X"0000B000", X"FFFFFFFF" after 20 ns;
	d_in1	<= X"FFAFFFFF", X"00000000" after 20 ns;
	sel		<= '0',	'1' after 5 ns,'0' after 10 ns,'1' after 15 ns,'0' after 20 ns,'1' after 25 ns,'0' after 30 ns,'1' after 35 ns;

-- Components instantiations

DUT: mux_n_bit_2to1
	generic map (
		G_NUM_OF_BITS => C_NUM_OF_BITS
	)
	port map (
		D_IN0	=>	d_in0,
		D_IN1	=>	d_in1,
		SEL		=>	sel,
		
		Q		=>	q
	);
	
end architecture;