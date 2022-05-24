library ieee;
use ieee.std_logic_1164.all;

entity alu_1bit is
port(
	A			: in std_logic;
	B			: in std_logic;
	LESS		: in std_logic;
	C_IN		: in std_logic;
	
	A_INVERT	: in std_logic;
	B_INVERT	: in std_logic;
	
	OPERATION	: in std_logic_vector(1 downto 0);
	
	C_OUT		: out std_logic;
	SET			: out std_logic;
	RESULT		: out std_logic
);
end entity;

architecture behave of alu_1bit is

-- Component declaration
	
	component mux_1bit_2to1 is
	port(
		D_IN0	: in std_logic;
		D_IN1	: in std_logic;

		SEL		: in std_logic;	
		Q		: out std_logic
	);
	end component;
	
	component full_adder
		port(
			A		: in	std_logic;
			B		: in	std_logic;
			C_IN	: in	std_logic;
			
			SUM		: out	std_logic;
			C_OUT	: out	std_logic
		);
	end component;
	
	component mux_1bit_4_to_1 is
	port(
		D_IN0	: in std_logic;
		D_IN1	: in std_logic;
		D_IN2	: in std_logic;
		D_IN3	: in std_logic;

		SEL		: in std_logic_vector(1 downto 0);	
		Q		: out std_logic
	);
	end component;

-- Signals declaration

	signal a_inv	: std_logic;
	signal b_inv	: std_logic;
	
	signal selected_a	: std_logic;
	signal selected_b	: std_logic;
	
	signal a_and_b			: std_logic;
	signal a_or_b			: std_logic;
	signal a_b_sum			: std_logic;
	

begin

	a_inv <= not A;
	b_inv <= not B;
	
	a_and_b <= (selected_a and selected_b);
	a_and_b <= (selected_a or selected_b);
	
	SET <= a_b_sum;
	
-- Components instantiations
	
	A_SELECT_MUX: mux_1bit_2to1
	port map (
		D_IN0	=>	A,
		D_IN1	=>	A_INVERT,
		SEL		=>	a_inv,
		
		Q		=>	selected_a
	);
	
	B_SELECT_MUX: mux_1bit_2to1
	port map (
		D_IN0	=>	B,
		D_IN1	=>	B_INVERT,
		SEL		=>	b_inv,
		
		Q		=>	selected_b
	);
	
	FA: full_adder
	port map (
		A		=>	selected_a,
		B		=>	selected_b,
		C_IN	=>	C_IN,
		
		SUM		=>	a_b_sum,
		C_OUT	=>	C_OUT
	);
	
	RESULT_SELECT_MUX: mux_1bit_4_to_1
	port map (
		D_IN0	=>	a_and_b,
		D_IN1	=>	a_or_b,
		D_IN2	=>	a_b_sum,
		D_IN3	=>	LESS,
		
		SEL		=>	OPERATION,
		Q		=>	RESULT
	);
	
end architecture;