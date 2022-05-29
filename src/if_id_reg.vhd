library ieee;
use ieee.std_logic_1164.all;

entity if_id_reg is
port (
	CLK		: in std_logic;
	RST		: in std_logic;
	
	INSTRUCTION_IN		: in std_logic_vector(31 downto 0);
	PC_PLUS4_IN			: in std_logic_vector(31 downto 0);
	
	INSTRUCTION_OUT		: out std_logic_vector(31 downto 0);
	PC_PLUS4_OUT		: out std_logic_vector(31 downto 0)
);
end entity;

architecture struct of if_id_reg is		
	
-- Component declaration
	component register_nbit is
	generic(
		G_N		: integer := 32
	);
	port (
		D_IN	: in std_logic_vector((G_N-1) downto 0) := (others => '0');
		
		CLK		: in std_logic;
		RST		: in std_logic;
		
		D_OUT	: out std_logic_vector((G_N-1) downto 0)
	);
	end component;
	
begin
-- Component instantiations
INSTRUCTION_REG: register_nbit
	generic map(
		G_N 	=>	INSTRUCTION_IN'length
	)
	port map(
		D_IN	=>	INSTRUCTION_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	INSTRUCTION_OUT
	);
	
PC_PLUS4_REG: register_nbit
	generic map(
		G_N 	=>	PC_PLUS4_IN'length
	)
	port map(
		D_IN	=>	PC_PLUS4_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	PC_PLUS4_OUT
	);
	
end architecture;

