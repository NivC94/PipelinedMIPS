library ieee;
use ieee.std_logic_1164.all;

entity pipelined_mips_tb is
end entity;

architecture sim of pipelined_mips_tb is

-- Constants declaration
	
	constant C_CLK_PRD : time := 10 ns;
	constant C_RST_TIME : time := 30 ns;
	
	-- Instruction memory constants
	constant C_IMEM_ADDR_WIDTH	: integer := 20;
	constant C_IMEM_FILE_NAME	: string :=	"../ASM code/Insertion Sort hex instruction codes.txt";
	
	-- Data memory constants
	constant C_ADDR_WIDTH		: integer := 16;
	constant C_DMEM_FILE_NAME	: string := "../ASM code/Insertion Sort hex data.txt";
	constant C_FILE_HEX_FORMAT	: boolean := true;

-- Component declaration

	component pipelined_mips is
	generic (
		G_IMEM_ADDR_WIDTH	: integer := 32; -- only for simulation purpose to limit memory size (due to simulation limits)
		G_IMEM_FILE_NAME	: string := "source.txt"; -- instructions file name
		G_ADDR_WIDTH		: integer := 32; -- only for simulation purpose (due to simulation limits)
		G_DMEM_FILE_NAME	: string := "source.txt"; -- data file name
		G_FILE_HEX_FORMAT	: boolean := true -- if false file is in decimal format
	);
	port (
		CLK		: in std_logic;
		RST		: in std_logic
	);
	end component;

-- Signals declaration

	signal clk_sig : std_logic := '1';
	signal rst_sig : std_logic := '1';
	
begin
	
	rst_sig <= '1', '0' after C_RST_TIME;
	-- generate clock signal with period of C_CLK_PRD
	clk_sig <= not clk_sig after C_CLK_PRD/2;


-- Components instantiations

DUT: pipelined_mips
	generic map (
		G_IMEM_ADDR_WIDTH	=>	C_IMEM_ADDR_WIDTH,
		G_IMEM_FILE_NAME	=>	C_IMEM_FILE_NAME,
		G_ADDR_WIDTH		=>	C_ADDR_WIDTH,
		G_DMEM_FILE_NAME	=>	C_DMEM_FILE_NAME,
		G_FILE_HEX_FORMAT	=>	C_FILE_HEX_FORMAT
	)
	port map (
		CLK		=>	clk_sig,
		RST		=>	rst_sig
	);

end architecture;