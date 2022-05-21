library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_reg_tb is
end entity;

architecture sim of pc_reg_tb is

-- Constants declaration
	
	constant C_CLK_PRD : time := 10 ns;
	constant C_RST_TIME : time := 35 ns;

-- Components declaration

	component pc_reg is
	port (
		PC_IN	: in std_logic_vector(31 downto 0) := (others => '0');
		
		CLK		: in std_logic;
		RST		: in std_logic;
		
		PC_OUT	: out std_logic_vector(31 downto 0)
	);
	end component;
	
-- Signals declaration

	signal pc_in_sig	: std_logic_vector(31 downto 0) := (others => '0');
	
	signal clk_sig : std_logic := '1';
	signal rst_sig : std_logic := '1';
	
	signal pc_out_sig	: std_logic_vector(31 downto 0);
	
begin

-- Components instantiations

DUT: pc_reg
	port map (
		PC_IN	=> pc_in_sig,
		
        CLK		=> clk_sig,
		RST		=> rst_sig,
		
		PC_OUT	=> pc_out_sig
	);
	
	rst_sig <= '1', '0' after C_RST_TIME;
	-- generate clock signal with period of C_CLK_PRD
	clk_sig <= not clk_sig after C_CLK_PRD/2;
	
	process
	begin
		
		for i in 1 to 30 loop
			pc_in_sig <= std_logic_vector(to_unsigned(i*3,32));
			wait for C_CLK_PRD;
		end loop;
		
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;
	
end architecture;