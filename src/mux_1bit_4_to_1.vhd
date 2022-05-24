library ieee;
use ieee.std_logic_1164.all;

entity mux_1bit_4_to_1 is
port(
	D_IN0	: in std_logic;
	D_IN1	: in std_logic;
	D_IN2	: in std_logic;
	D_IN3	: in std_logic;

	SEL		: in std_logic_vector(1 downto 0);	
	Q		: out std_logic
);
end entity;

architecture behave of mux_1bit_4_to_1 is

begin

	Q <=	D_IN0 when SEL = "00" else
			D_IN1 when SEL = "01" else
			D_IN2 when SEL = "10" else
			D_IN3 when SEL = "11";

end architecture;