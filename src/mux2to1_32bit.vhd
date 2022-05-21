library ieee;
use ieee.std_logic_1164.all;

entity mux2to1_32bit is
port(
	D_IN0	: in std_logic_vector(31 downto 0);
	D_IN1	: in std_logic_vector(31 downto 0);

	SEL		: in std_logic;	
	Q		: out std_logic_vector(31 downto 0)
);
end entity;

architecture behave of mux2to1_32bit is

begin

	Q <=	D_IN0 when SEL = '0' else
			D_IN1 when SEL = '1';

end architecture;