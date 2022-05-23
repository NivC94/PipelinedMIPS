library ieee;
use ieee.std_logic_1164.all;

entity instruction_decode_module is
port (
		INSTRUCTION		: in std_logic_vector(31 downto 0);
		PC_PLUS4		: in std_logic_vector(31 downto 0);
		
		WRITE_DATA		: in std_logic_vector(31 downto 0);
		WRITE_REG		: in std_logic_vector(4 downto 0);		--register to be written to
		REG_WRITE		: in std_logic;							--write enable of the regfile
		
		--Jump controll signals
		BRANCH_EQUAL	: out std_logic;						--HIGH if branch and comperator outputs are HIGH
		JUMP			: out std_logic;
		
		--WB controll signals
		MEM_TO_REG		: out std_logic;
		REG_WRITE		: out std_logic;
		
		--MEM controll signals
		MEM_READ		: out std_logic;
		MEM_WRITE		: out std_logic;
		
		--EX controll signals
		ALU_SRC			: out std_logic;
		REG_DST			: out std_logic;
		ALU_OP			: out std_logic_vector(1 downto 0);
		
		--data output
		READ_DATA_OUT1	: out std_logic_vector(31 downto 0);
		READ_DATA_OUT2	: out std_logic_vector(31 downto 0);
		IMMEDIATE_OUT	: out std_logic_vector(31 downto 0);
		FUNCT			: out std_logic_vector(5 downto 0);
		RS_REG			: out std_logic_vector(4 downto 0);
		RT_REG			: out std_logic_vector(4 downto 0);
		RD_REG			: out std_logic_vector(4 downto 0)
);
end entity;
	
architecture struct of instruction_decode_module is
	
-- Component declaration
	
		
-- Signal declaration


begin
	
-- Component instantiations
	
	
	
end architecture;
		