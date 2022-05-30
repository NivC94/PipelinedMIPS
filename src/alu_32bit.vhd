library ieee;
use ieee.std_logic_1164.all;

entity alu_32bit is
port(
	A			: in std_logic_vector(31 downto 0);
	B			: in std_logic_vector(31 downto 0);
	C_IN		: in std_logic;
	
	A_INVERT	: in std_logic;
	B_INVERT	: in std_logic;
	
	OPERATION	: in std_logic_vector(1 downto 0);
	
	RESULT		: out std_logic_vector(31 downto 0)
);
end entity;

architecture struct of alu_32bit is

-- Component declaration
	
	component alu_1bit is
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
	end component;
	

-- Signals declaration

	signal less		: std_logic_vector(31 downto 0);
	signal set		: std_logic_vector(31 downto 0);
	signal carry	: std_logic_vector(32 downto 0);

begin

	carry(0) <= C_IN;
	
	less(0) <= set(31);
	less(31 downto 1) <= (others => '0');
	
-- Components instantiations
	
	GEN_ALU: for i in 0 to 31 generate
				ALU: alu_1bit
					port map (
						A			=>	A(i),
						B			=>	B(i),
						LESS		=>	less(i),
						C_IN		=>	carry(i),
						
						A_INVERT	=>	A_INVERT,
						B_INVERT	=>	B_INVERT,
						
						OPERATION	=>	OPERATION,
						
						C_OUT		=>	carry(i+1),
						SET			=>	set(i),
						RESULT		=>	RESULT(i)
					);
			end generate GEN_ALU;
	
end architecture;