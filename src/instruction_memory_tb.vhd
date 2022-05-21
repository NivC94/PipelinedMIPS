library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory_tb is
end entity;

architecture sim of instruction_memory_tb is

-- Constants declaration

	constant C_ADDR_WIDTH : integer := 25;
	constant C_IMEM_FILE_NAME	: string := "../src/Instructions.txt";

-- Components declaration

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
	
	signal read_addr_sig	: std_logic_vector(31 downto 0) := (others => '0');
	
	signal instruction_sig	: std_logic_vector(31 downto 0);
	
begin

-- Components instantiations

DUT: instruction_memory
	generic map (
		G_ADDR_WIDTH => C_ADDR_WIDTH,
		G_IMEM_FILE_NAME => C_IMEM_FILE_NAME
	)
	port map (
		READ_ADDR => read_addr_sig,
		
		INSTRUCTION => instruction_sig
	);
	
	process
	variable addr : std_logic_vector(31 downto 0) := (others => '0');
	begin
		-- read data in address 0 to 400
		for i in 1 to 100 loop
			read_addr_sig <= addr;
			addr := (std_logic_vector(to_unsigned(i*4,32)));
			wait for 10 ns;
		end loop;
		
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;
	
end architecture;