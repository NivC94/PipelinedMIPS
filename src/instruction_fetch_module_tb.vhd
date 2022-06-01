library ieee;
use ieee.std_logic_1164.all;

entity instruction_fetch_module_tb is
end entity;

architecture sim of instruction_fetch_module_tb is
	
-- Constants declaration

	constant C_CLK_PRD : time := 10 ns;
	constant C_RST_TIME : time := 30 ns;
	
	constant C_IMEM_ADDR_WIDTH	: integer := 16;
	constant C_IMEM_FILE_NAME	: string := "../ASM code/Insertion Sort hex instruction codes.txt";
	
	constant C_BEQ_OPCODE : std_logic_vector(5 downto 0)	:= "000100"; -- 0x04
	constant C_J_OPCODE : std_logic_vector(5 downto 0)		:= "000010"; -- 0x02

-- Component declaration

	component instruction_fetch_module is
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
	end component;

-- Signals declaration

	signal	pc_branch_addr_sig	: std_logic_vector(31 downto 0) := (others => '0');
	signal	pc_jump_addr_sig	: std_logic_vector(31 downto 0) := (others => '0');

	signal	branch_sel_sig		: std_logic := '0';
	signal	jump_sel_sig		: std_logic := '0';
	
	signal	clk_sig				: std_logic := '1';
	signal	rst_sig				: std_logic := '1';
	
	signal	pc_plus_4_addr_sig	: std_logic_vector(31 downto 0);
	signal	instruction_sig		: std_logic_vector(31 downto 0);
	
begin
	
	rst_sig <= '1', '0' after C_RST_TIME;
	-- generate clock signal with period of C_CLK_PRD
	clk_sig <= not clk_sig after C_CLK_PRD/2;
	
	-- assumes that there is always a branch since it can't be checked in that block
	branch_sel_sig <=	'1' when (instruction_sig(31 downto 26) = C_BEQ_OPCODE) else
						'0';
						
	jump_sel_sig <=		'1' when (instruction_sig(31 downto 26) = C_J_OPCODE) else
						'0';
	
	process
	variable cnt : integer := 0;
	begin
		wait for C_RST_TIME;
		
		while ((cnt < 50) and (instruction_sig /= (instruction_sig'range => '0'))) loop
			wait for C_CLK_PRD;
			pc_branch_addr_sig	<= X"00000034";
			pc_jump_addr_sig	<= X"00000000";
			cnt := cnt + 1;
		end loop;
		
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;

-- Components instantiations

DUT: instruction_fetch_module
	generic map (
		G_IMEM_ADDR_WIDTH	=>	C_IMEM_ADDR_WIDTH,
		G_IMEM_FILE_NAME	=>	C_IMEM_FILE_NAME
	)
	port map (
		PC_BRANCH_ADDR		=>	pc_branch_addr_sig,
		PC_JUMP_ADDR		=>	pc_jump_addr_sig,
        
		BRANCH_SEL			=>	branch_sel_sig,
		JUMP_SEL            =>	jump_sel_sig,
		
		CLK					=>	clk_sig,
		RST					=>	rst_sig,
		
		PC_PLUS_4_ADDR		=>	pc_plus_4_addr_sig,
		INSTRUCTION			=>	instruction_sig
	);

end architecture;