library ieee;
use ieee.std_logic_1164.all;

entity pipelined_mips_tb is
end entity;

architecture sim of pipelined_mips_tb is

-- Constants declaration
	
	constant C_CLK_PRD : time := 10 ns;
	constant C_RST_TIME : time := 30 ns;

-- Component declaration

	component pipelined_mips is
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
	port map (
		CLK		=>	clk_sig,
		RST		=>	rst_sig
	);

end architecture;