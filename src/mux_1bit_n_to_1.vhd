library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity mux_1bit_n_to_1 is
generic(
	G_NUM_OF_INPUTS		: integer := 4
);
port(
	D_IN	: in std_logic_vector(G_NUM_OF_INPUTS-1 downto 0);

	SEL		: in std_logic_vector((ceil(log2(real(G_NUM_OF_INPUTS))))-1 downto 0);	
	Q		: out std_logic
);
end entity;

architecture behave of mux2to1_32bit is

begin

	Q <=	D_IN(0) when to_integer(unsigned(SEL)) >= G_NUM_OF_INPUTS else
			D_IN(to_integer(unsigned(SEL)));

end architecture;