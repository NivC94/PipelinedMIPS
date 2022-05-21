library ieee;
use ieee.std_logic_1164.all;

entity adder_32bits_tb is
end entity;

architecture sim of adder_32bits_tb is

-- Component declaration

	component adder_32bits
		port(
			A		: in std_logic_vector (31 downto 0);
			B		: in std_logic_vector (31 downto 0);
			
			SUM		: out std_logic_vector (31 downto 0);
			C_OUT	: out std_logic
		);
	end component;

-- Signals declaration
	signal a_sig		: std_logic_vector (31 downto 0);
	signal b_sig		: std_logic_vector (31 downto 0);

	signal sum_sig		: std_logic_vector (31 downto 0);
	signal c_out_sig	: std_logic;
	
begin
	
	a_sig		<= X"00000000", X"00000002" after 10 ns, X"FFFFFFFF" after 20 ns;
	b_sig		<= X"00000000", X"00000002" after 10 ns, X"FFFFFFFF" after 20 ns;

-- Components instantiations

DUT: adder_32bits
		port map(
			A		=> a_sig,
			B		=> b_sig,
			
			SUM		=> sum_sig,
			C_OUT	=> c_out_sig
		);
end architecture;