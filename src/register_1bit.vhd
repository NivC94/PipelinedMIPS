library ieee;
use ieee.std_logic_1164.all;

entity register_1bit is
port (
	D_IN	: in std_logic;
	
	CLK		: in std_logic;
	RST		: in std_logic;
	
	D_OUT	: out std_logic
);
end entity;

architecture behave of register_1bit is

begin

	process(CLK, RST)
	begin
		if RST = '1' then
			D_OUT <= '0';
		elsif rising_edge(CLK) then
			D_OUT <= D_IN;
		end if;
	end process;

end architecture;