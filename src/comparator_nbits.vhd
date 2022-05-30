library ieee;
use ieee.std_logic_1164.all;

entity comparator_nbits is
generic(
	G_DATA_WIDTH	: integer := 32
);
port(
	A		: in std_logic_vector((G_DATA_WIDTH-1) downto 0);
	B		: in std_logic_vector((G_DATA_WIDTH-1) downto 0);
		
	EQUAL 	: out std_logic
);
end entity;

architecture struct of comparator_nbits is
	
	constant c_ones_vector	: std_logic_vector((G_DATA_WIDTH-1) downto 0) := (others => '1');

	begin	
	
	process(A, B)
	variable intermediate_calc	: std_logic_vector((G_DATA_WIDTH-1) downto 0);
	begin
		intermediate_calc := A xnor B;
		if intermediate_calc = c_ones_vector then
			EQUAL <= '1';
		else
			EQUAL <= '0';
		end if;
	end process;
	
end architecture;