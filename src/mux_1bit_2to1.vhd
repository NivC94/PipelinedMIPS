library ieee;
use ieee.std_logic_1164.all;

entity mux_1bit_2to1 is
port(
	D_IN0	: in std_logic;
	D_IN1	: in std_logic;

	SEL		: in std_logic;	
	Q		: out std_logic
);
end entity;

architecture behave of mux_1bit_2to1 is

begin

	Q <=	D_IN0 when SEL = '0' else
			D_IN1 when SEL = '1';

end architecture;