library ieee;
use ieee.std_logic_1164.all;

entity ex_mem_reg is
port (
	CLK		: in std_logic;
	RST		: in std_logic;
	
	--WB control signals in
	MEM_TO_REG_IN		: in std_logic;
	REG_WRITE_IN		: in std_logic;
	
	--MEM control signals in
	MEM_READ_IN			: in std_logic;
	MEM_WRITE_IN		: in std_logic;
	
	--data input
	ALU_RES_IN			: in std_logic_vector(31 downto 0);
	READ_DATA2_IN		: in std_logic_vector(31 downto 0);
	DEST_REG_IN			: in std_logic_vector(4 downto 0);
	
	--WB control signals out
	MEM_TO_REG_OUT		: out std_logic;
	REG_WRITE_OUT		: out std_logic;
	
	--MEM control signals out
	MEM_READ_OUT		: out std_logic;
	MEM_WRITE_OUT		: out std_logic;
	
	--data output
	ALU_RES_OUT			: out std_logic_vector(31 downto 0);
	READ_DATA2_OUT		: out std_logic_vector(31 downto 0);
	DEST_REG_OUT		: out std_logic_vector(4 downto 0)
);
end entity;

architecture struct of ex_mem_reg is		
	
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
	
	component register_1bit is
	port (
		D_IN	: in std_logic;
		
		CLK		: in std_logic;
		RST		: in std_logic;
		
		D_OUT	: out std_logic
	);
	end component;
	
begin
-- Component instantiations
--WB controll signals
MEM_TO_REG_REG: register_1bit
	port map(
		D_IN	=>	MEM_TO_REG_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	MEM_TO_REG_OUT
	);
	
REG_WRITE_REG: register_1bit
	port map(
		D_IN	=>	REG_WRITE_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	REG_WRITE_OUT
	);
	
--MEM controll signals
MEM_READ_REG: register_1bit
	port map(
		D_IN	=>	MEM_READ_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	MEM_READ_OUT
	);
	
MEM_WRITE_REG: register_1bit
	port map(
		D_IN	=>	MEM_WRITE_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	MEM_WRITE_OUT
	);	
	
--DATA registers
ALU_RES_REG: register_nbit
	generic map(
		G_N 	=>	ALU_RES_IN'length
	)
	port map(
		D_IN	=>	ALU_RES_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	ALU_RES_OUT
	);
	
DEST_REG_REG: register_nbit
	generic map(
		G_N 	=>	DEST_REG_IN'length
	)
	port map(
		D_IN	=>	DEST_REG_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	DEST_REG_OUT
	);
	
READ_DATA2_REG: register_nbit
	generic map(
		G_N 	=>	READ_DATA2_IN'length
	)
	port map(
		D_IN	=>	READ_DATA2_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	READ_DATA2_OUT
	);

end architecture;

