library ieee;
use ieee.std_logic_1164.all;

entity pc_reg is
port (
	PC_IN	: in std_logic_vector(31 downto 0) := (others => '0');
	
	CLK		: in std_logic;
	RST		: in std_logic;
	
	PC_OUT	: out std_logic_vector(31 downto 0)
);
end entity;

architecture behave of pc_reg is

begin

	process(CLK, RST)
	begin
		if RST = '1' then
			PC_OUT <= (others => '0');
		elsif rising_edge(CLK) then
			PC_OUT <= PC_IN;
		end if;
	end process;

end architecture;