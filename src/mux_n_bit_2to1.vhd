library ieee;
use ieee.std_logic_1164.all;

entity mux_n_bit_2to1 is
generic(
	G_NUM_OF_BITS	: integer := 32
);
port(
	D_IN0	: in std_logic_vector((G_NUM_OF_BITS-1) downto 0);
	D_IN1	: in std_logic_vector((G_NUM_OF_BITS-1) downto 0);

	SEL		: in std_logic;	
	Q		: out std_logic_vector((G_NUM_OF_BITS-1) downto 0)
);
end entity;

architecture behave of mux_n_bit_2to1 is

	component mux_1bit_2to1 is
	port(
		D_IN0	: in std_logic;
		D_IN1	: in std_logic;

		SEL		: in std_logic;	
		Q		: out std_logic
	);
	end component;

begin

	GEN_MUX: for i in 0 to (G_NUM_OF_BITS-1) generate
				MUX: mux_1bit_2to1
					port map (
						D_IN0	=>	d_in0(i),
						D_IN1	=>	d_in1(i),
						SEL		=>	sel,
						
						Q		=>	q(i)
					);
			end generate GEN_MUX;

end architecture;