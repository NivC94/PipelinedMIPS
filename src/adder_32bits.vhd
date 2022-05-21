library ieee;
use ieee.std_logic_1164.all;

entity adder_32bits is
port(
	A		: in std_logic_vector (31 downto 0);
	B		: in std_logic_vector (31 downto 0);
	
	SUM		: out std_logic_vector (31 downto 0);
	C_OUT	: out std_logic
);
end entity;

architecture struct of adder_32bits is

-- Components declaration

	component full_adder
		port(
			A		: in	std_logic;
			B		: in	std_logic;
			C_IN	: in	std_logic;
			
			SUM		: out	std_logic;
			C_OUT	: out	std_logic
			
		);
	end component;
	
-- Signals declaration
	
	signal s		: std_logic_vector (32 downto 0);
	
begin

	s(0) <= '0';
	C_OUT <= s(32);

-- Components instantiations

GL: for i in 0 to 31 generate
	UI: full_adder port map(
						A		=>	a(i),
						B		=>	b(i),
						C_IN	=>	s(i),
						
						SUM		=>	sum(i),
						C_OUT	=>	s(i+1)
					);
	end generate;

end architecture;