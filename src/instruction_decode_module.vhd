library ieee;
use ieee.std_logic_1164.all;

entity instruction_decode_module is
port (
		INSTRUCTION		: in std_logic_vector(31 downto 0);
		PC_PLUS4		: in std_logic_vector(31 downto 0);
		
		WRITE_DATA		: in std_logic_vector(31 downto 0);
		WRITE_REG		: in std_logic_vector(4 downto 0);		--register to be written to
		REG_WRITE_IN	: in std_logic;							--write enable of the regfile
		
		CLK				: in std_logic;
		
		--Jump controll signals
		BRANCH_EQUAL	: out std_logic;						--HIGH if branch and comparator outputs are HIGH
		JUMP			: out std_logic;
		
		--WB controll signals
		MEM_TO_REG		: out std_logic;
		REG_WRITE_OUT	: out std_logic;
		
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
		RT_REG			: out std_logic_vector(4 downto 0);
		RD_REG			: out std_logic_vector(4 downto 0);
		
		--branch addresses
		BRANCH_ADDRESS	: out std_logic_vector(31 downto 0);
		JUMP_ADDRESS	: out std_logic_vector(31 downto 0)
);
end entity;
	
architecture struct of instruction_decode_module is
	
-- Component declaration
	component control_unit is
	port (
			OPCODE			: in std_logic_vector(5 downto 0);
			
			--Jump controll signals
			BRANCH			: out std_logic;
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
			ALU_OP			: out std_logic_vector(1 downto 0)
	);
	end component;
	
	component comparator_nbits is
	generic(
		G_DATA_WIDTH	: integer := 32
	);
	port(
		A		: in std_logic_vector((G_DATA_WIDTH-1) downto 0);
		B		: in std_logic_vector((G_DATA_WIDTH-1) downto 0);
			
		EQUAL 	: out std_logic
	);
	end component;
	
	component adder_32bits is
	port(
		A		: in std_logic_vector (31 downto 0);
		B		: in std_logic_vector (31 downto 0);
		
		SUM		: out std_logic_vector (31 downto 0);
		C_OUT	: out std_logic
	);
	end component;
	
	component register_file is
	port(
		READ_REG_1		: in std_logic_vector (4 downto 0);
		READ_REG_2		: in std_logic_vector (4 downto 0);
		
		CLK				: in std_logic;
		
		REG_WRITE		: in std_logic;
		WRITE_REG		: in std_logic_vector (4 downto 0);
		WRITE_DATA		: in std_logic_vector (31 downto 0);
		
		READ_DATA_1		: out std_logic_vector (31 downto 0);
		READ_DATA_2		: out std_logic_vector (31 downto 0)
	);
	end component;
			
-- Signal declaration

	signal opcode_sig						: std_logic_vector(5 downto 0);
	
	signal branch_sig						: std_logic;
	signal equal_sig						: std_logic;
	
	signal read_data_out1_sig				: std_logic_vector(31 downto 0);
	signal read_data_out2_sig				: std_logic_vector(31 downto 0);
	
	signal sign_ext_immediate_sig			: std_logic_vector(31 downto 0);
	signal shifted_sign_ext_immediate_sig	: std_logic_vector(31 downto 0);

begin
-- Component instantiations
	--Control unit
CU: control_unit
	port map (
		OPCODE			=> opcode_sig,
                           
		BRANCH			=> branch_sig,		
		JUMP			=> JUMP,	
                           
		MEM_TO_REG		=> MEM_TO_REG,	
		REG_WRITE		=> REG_WRITE_OUT,
		                   
		MEM_READ		=> MEM_READ,	
		MEM_WRITE		=> MEM_WRITE,	
		                   
		ALU_SRC			=> ALU_SRC,	
		REG_DST			=> REG_DST,	
		ALU_OP			=> ALU_OP		
	);
	
	--Comparator for early branching
COMP: comparator_nbits
	port map (
		A		=> read_data_out1_sig,
		B		=> read_data_out2_sig,
		
		EQUAL	=>	equal_sig
	);
	
	--32bit adder for the brach address
ADDER1: adder_32bits
	port map(
		A		=> PC_PLUS4, 
		B		=> shifted_sign_ext_immediate_sig,
		
		SUM		=> BRANCH_ADDRESS,
		C_OUT	=> open
	);
	
REG_FILE: register_file
	port map(
		READ_REG_1		=> INSTRUCTION(25 downto 21),
	    READ_REG_2		=> INSTRUCTION(20 downto 16),
	    
	    CLK				=> CLK,
	    
	    REG_WRITE		=> REG_WRITE_IN,
	    WRITE_REG		=> WRITE_REG,
	    WRITE_DATA		=> WRITE_DATA,
	    
	    READ_DATA_1		=> read_data_out1_sig,
	    READ_DATA_2		=> read_data_out2_sig
	);
	
	--Extract opcode out of the INSTRUCTION
	opcode_sig <= INSTRUCTION(31 downto 26);
	
	--Extract RT and RD registers from the INSTRUCTION
	RD_REG <= INSTRUCTION(15 downto 11);
	RT_REG <= INSTRUCTION(20 downto 16);
	
	--Extract and extend immediate from INSTRUCTION
	sign_ext_immediate_sig(15 downto 0) <= INSTRUCTION(15 downto 0);
	sign_ext_immediate_sig(31 downto 16) <= (others => INSTRUCTION(15));
	
	shifted_sign_ext_immediate_sig <= sign_ext_immediate_sig(29 downto 0) & "00";
	
	--Connect the extended immediate to the output
	IMMEDIATE_OUT <= sign_ext_immediate_sig;
	
	--Create a controll signal for BEQ
	BRANCH_EQUAL <= equal_sig AND branch_sig;
	
	--Extract and create jump address
	JUMP_ADDRESS <= PC_PLUS4(31 downto 28) & INSTRUCTION(25 downto 0) & "00";
	
	--Extract fnuction from the INSTRUCTION
	FUNCT <= INSTRUCTION(5 downto 0);
	
	--Connect the read data from the reg file to the output
	READ_DATA_OUT1 <= read_data_out1_sig;
	READ_DATA_OUT2 <= read_data_out2_sig;
end architecture;
		