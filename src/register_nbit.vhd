library ieee;
use ieee.std_logic_1164.all;

entity register_nbit is
generic(
	G_N		: integer := 32
);
port (
	D_IN	: in std_logic_vector((G_N-1) downto 0) := (others => '0');
	
	CLK		: in std_logic;
	RST		: in std_logic;
	
	D_OUT	: out std_logic_vector((G_N-1) downto 0)
);
end entity;

architecture behave of register_nbit is

begin

	process(CLK, RST)
	begin
		if RST = '1' then
			D_OUT <= (others => '0');
		elsif rising_edge(CLK) then
			D_OUT <= D_IN;
		end if;
	end process;

end architecture;