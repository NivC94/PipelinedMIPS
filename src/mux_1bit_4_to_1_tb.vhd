library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";
use ieee.numeric_std.all;

entity mux_1bit_4_to_1_tb is
end entity;

architecture sim of mux_1bit_4_to_1_tb is

-- Component declaration

	component mux_1bit_4_to_1 is
	port(
		D_IN0	: in std_logic;
		D_IN1	: in std_logic;
		D_IN2	: in std_logic;
		D_IN3	: in std_logic;

		SEL		: in std_logic_vector(1 downto 0);	
		Q		: out std_logic
	);
	end component;

-- Signals declaration
	signal d_in0_sig	: std_logic;
	signal d_in1_sig	: std_logic;
	signal d_in2_sig	: std_logic;
	signal d_in3_sig	: std_logic;
	
	signal sel_sig		: std_logic_vector(1 downto 0);
	signal q_sig		: std_logic;

begin

	d_in0_sig <=	'0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
	d_in1_sig <=	'1', '0' after 40 ns, '1' after 60 ns;
	d_in2_sig <=	'1', '0' after 20 ns, '0' after 40 ns, '1' after 60 ns;
	d_in3_sig <=	'0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
	
	d_in_sig <= "01", "10" after 20 ns, "00" after 40 ns, "11" after 60 ns;
	sel_sig	<= "0", "1" after 20 ns, "0" after 40 ns, "1" after 60 ns;

-- Components instantiations

	DUT: mux_1bit_4_to_1
	port map (
		D_IN0	=>	d_in0_sig,
		D_IN1	=>	d_in1_sig,
		D_IN2	=>	d_in2_sig,
		D_IN3	=>	d_in3_sig,
		
		SEL		=>	sel_sig,
		Q		=>	q_sig
	);

end architecture;