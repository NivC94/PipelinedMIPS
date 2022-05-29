library ieee;
use ieee.std_logic_1164.all;

entity id_ex_reg is
port (
	CLK		: in std_logic;
	RST		: in std_logic;
	
	--WB controll signals in
	MEM_TO_REG_IN		: in std_logic;
	REG_WRITE_IN		: in std_logic;
	
	--MEM controll signals in
	MEM_READ_IN			: in std_logic;
	MEM_WRITE_IN		: in std_logic;
	
	--EX controll signals in
	ALU_SRC_IN			: in std_logic;
	REG_DST_IN			: in std_logic;
	ALU_OP_IN			: in std_logic_vector(1 downto 0);
	
	--data input
	READ_DATA1_IN		: in std_logic_vector(31 downto 0);
	READ_DATA2_IN		: in std_logic_vector(31 downto 0);
	IMMEDIATE_IN		: in std_logic_vector(31 downto 0);
	FUNCT_IN			: in std_logic_vector(5 downto 0);
	RT_REG_IN			: in std_logic_vector(4 downto 0);
	RD_REG_IN			: in std_logic_vector(4 downto 0);
	
	--WB controll signals out
	MEM_TO_REG_OUT		: out std_logic;
	REG_WRITE_OUT		: out std_logic;
	
	--MEM controll signals out
	MEM_READ_OUT		: out std_logic;
	MEM_WRITE_OUT		: out std_logic;
	
	--EX controll signals out
	ALU_SRC_OUT			: out std_logic;
	REG_DST_OUT			: out std_logic;
	ALU_OP_OUT			: out std_logic_vector(1 downto 0);
	
	--data output
	READ_DATA1_OUT		: out std_logic_vector(31 downto 0);
	READ_DATA2_OUT		: out std_logic_vector(31 downto 0);
	IMMEDIATE_OUT		: out std_logic_vector(31 downto 0);
	FUNCT_OUT			: out std_logic_vector(5 downto 0);
	RT_REG_OUT			: out std_logic_vector(4 downto 0);
	RD_REG_OUT			: out std_logic_vector(4 downto 0)
);
end entity;

architecture struct of id_ex_reg is		
	
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
	
--EX controll signals
ALU_SRC_REG: register_1bit
	port map(
		D_IN	=>	ALU_SRC_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	ALU_SRC_OUT
	);
	
REG_DST_REG: register_1bit
	port map(
		D_IN	=>	REG_DST_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	REG_DST_OUT
	);	
	
ALU_OP_REG: register_nbit
	generic map(
		G_N 	=>	ALU_OP_IN'length
	)
	port map(
		D_IN	=>	ALU_OP_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	ALU_OP_OUT
	);	
	
--DATA registers
READ_DATA1_REG: register_nbit
	generic map(
		G_N 	=>	READ_DATA1_IN'length
	)
	port map(
		D_IN	=>	READ_DATA1_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	READ_DATA1_OUT
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
	
IMMEDIATE_REG: register_nbit
	generic map(
		G_N 	=>	IMMEDIATE_IN'length
	)
	port map(
		D_IN	=>	IMMEDIATE_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	IMMEDIATE_OUT
	);

FUNCT_REG: register_nbit
	generic map(
		G_N 	=>	FUNCT_IN'length
	)
	port map(
		D_IN	=>	FUNCT_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	FUNCT_OUT
	);
	
RT_REG_REG: register_nbit
	generic map(
		G_N 	=>	RT_REG_IN'length
	)
	port map(
		D_IN	=>	RT_REG_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	RT_REG_OUT
	);	
	
RD_REG_REG: register_nbit
	generic map(
		G_N 	=>	RD_REG_IN'length
	)
	port map(
		D_IN	=>	RD_REG_IN,
		
		CLK		=>	CLK,
		RST		=>	RST,
		
		D_OUT	=>	RD_REG_OUT
	);	
end architecture;

