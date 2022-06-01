library ieee;
use ieee.std_logic_1164.all;

entity instruction_fetch_module is
generic(
	G_IMEM_ADDR_WIDTH	: integer := 32; -- only for simulation purpose to limit memory size (due to simulation limits)
	G_IMEM_FILE_NAME	: string := "source.txt" -- instructions file name
);
port (
	PC_BRANCH_ADDR	: in std_logic_vector(31 downto 0);
	PC_JUMP_ADDR	: in std_logic_vector(31 downto 0);
	
	BRANCH_SEL		: in std_logic;
	JUMP_SEL		: in std_logic;
	
	CLK				: in std_logic;
	RST				: in std_logic;
	
	PC_PLUS_4_ADDR	: out std_logic_vector(31 downto 0);
	INSTRUCTION		: out std_logic_vector(31 downto 0)
);
end entity;

architecture struct of instruction_fetch_module is
	
-- Constant declaration

	constant CONST_4	: std_logic_vector(31 downto 0) := X"00000004";
	
-- Component declaration
	
	component mux_n_bit_2to1 is
	generic(
		G_NUM_OF_BITS	: integer := 32
	);
	port(
		D_IN0	: in std_logic_vector((G_NUM_OF_BITS-1) downto 0);
		D_IN1	: in std_logic_vector((G_NUM_OF_BITS-1) downto 0);

		SEL		: in std_logic;	
		Q		: out std_logic_vector((G_NUM_OF_BITS-1) downto 0)
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
	
	component pc_reg is
	port (
		PC_IN	: in std_logic_vector(31 downto 0) := (others => '0');
		
		CLK		: in std_logic;
		RST		: in std_logic;
		
		PC_OUT	: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component instruction_memory is
	generic(
		G_ADDR_WIDTH		: integer := 32; -- only for simulation purpose to limit memory size (due to simulation limits)
		G_IMEM_FILE_NAME	: string := "source.txt" -- instructions file name
	);
	port (
		READ_ADDR		: in std_logic_vector(31 downto 0) := (others => '0');
		
		INSTRUCTION		: out std_logic_vector(31 downto 0)
	);
	end component;
	
-- Signals declaration
	
	signal pc_plus_4_addr_sig			: std_logic_vector(31 downto 0);
	
	signal pc_branch_addr_selected_sig	: std_logic_vector(31 downto 0);
	signal pc_in_sig					: std_logic_vector(31 downto 0);
	signal pc_out_sig					: std_logic_vector(31 downto 0);
	
begin

	PC_PLUS_4_ADDR <= pc_plus_4_addr_sig;

-- Components instantiations

BRANCH_MUX: mux_n_bit_2to1
	generic map (
		G_NUM_OF_BITS => 32
	)
	port map (
		D_IN0	=>	pc_plus_4_addr_sig,
		D_IN1	=>	PC_BRANCH_ADDR,
		SEL		=>	BRANCH_SEL,
		
		Q		=>	pc_branch_addr_selected_sig
	);
	
JUMP_MUX: mux_n_bit_2to1
	generic map (
		G_NUM_OF_BITS => 32
	)
	port map (
		D_IN0	=>	pc_branch_addr_selected_sig,
		D_IN1	=>	PC_JUMP_ADDR,
		SEL		=>	JUMP_SEL,
		
		Q		=>	pc_in_sig
	);

PC_PLUS_4_ADDR_ADDER: adder_32bits
	port map (
		A		=>	pc_out_sig,
		B		=>	CONST_4,
		
		SUM		=>	pc_plus_4_addr_sig
	);

PC: pc_reg
	port map (
		PC_IN	=>	pc_in_sig,

		CLK		=>	CLK,
		RST		=>	RST,
		
		PC_OUT	=>	pc_out_sig
	);

I_MEM: instruction_memory
	generic map (
		G_ADDR_WIDTH		=>	G_IMEM_ADDR_WIDTH,
		G_IMEM_FILE_NAME	=>	G_IMEM_FILE_NAME
	)
	port map (
		READ_ADDR		=>	pc_out_sig,
			
		INSTRUCTION		=>	INSTRUCTION
	);

end architecture;