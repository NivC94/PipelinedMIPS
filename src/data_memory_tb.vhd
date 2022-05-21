library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory_tb is
end entity;

architecture sim of data_memory_tb is

-- Constants declaration

	constant C_ADDR_WIDTH : integer := 27;
	constant C_DMEM_FILE_NAME	: string := "../src/Data_deci.txt";
	constant C_FILE_HEX_FORMAT : boolean := false;
	
	constant C_CLK_PRD : time := 10 ns;

-- Components declaration

	component data_memory is
	generic(
		G_ADDR_WIDTH		: integer := 32; -- only for simulation purpose to limit memory size (due to simulation limits)
		G_DMEM_FILE_NAME	: string := "source.txt"; -- data file name
		G_FILE_HEX_FORMAT	: boolean := true -- if false file is in decimal format
	);
	port (
		ADDR		: in std_logic_vector(31 downto 0) := (others => '0');
		WR_DATA		: in std_logic_vector(31 downto 0);
		
		CLK			: in std_logic;
		MEM_WR		: in std_logic;
		MEM_RD		: in std_logic;
		
		RD_DATA		: out std_logic_vector(31 downto 0)
	);
	end component;
	
-- Signals declaration
	
	signal addr_sig	: std_logic_vector(31 downto 0) := (others => '0');
	signal wr_data_sig : std_logic_vector(31 downto 0) := (others => '0');
	
	signal clk_sig : std_logic := '1';
	signal mem_wr_sig : std_logic := '0';
	signal mem_rd_sig : std_logic := '0';
	
	signal rd_data_sig	: std_logic_vector(31 downto 0);
	
begin

-- Components instantiations

DUT: data_memory
	generic map (
		G_ADDR_WIDTH		=>	C_ADDR_WIDTH,
		G_DMEM_FILE_NAME	=>	C_DMEM_FILE_NAME,
		G_FILE_HEX_FORMAT	=>	C_FILE_HEX_FORMAT
	)
	port map (
		ADDR		=> addr_sig,
		WR_DATA		=> wr_data_sig,

		CLK			=> clk_sig,
		MEM_WR		=> mem_wr_sig,
		MEM_RD		=> mem_rd_sig,
		
		RD_DATA		=> rd_data_sig
	);
	
	-- generate clock signal with period of C_CLK_PRD
	process
    begin
        clk_sig <= '1';
        wait for C_CLK_PRD / 2;
        clk_sig <= '0';
        wait for C_CLK_PRD / 2;
    end process;
	
	process
	variable addr : std_logic_vector(31 downto 0) := (others => '0');
	begin
		wait for C_CLK_PRD;
		-- read data in address 0 to 100
		mem_rd_sig <= '1';
		for i in 0 to 25 loop
			addr := std_logic_vector(to_unsigned(i*4,32));
			addr_sig <= addr;
			wait for C_CLK_PRD;
		end loop;
		mem_rd_sig <= '0';
		
		-- write data (2, 4, 6, ..., 20) in address 4 to 40
		mem_wr_sig <= '1';
		for i in 1 to 10 loop
			wr_data_sig <= std_logic_vector(to_unsigned(i*2,32));
			addr := std_logic_vector(to_unsigned(i*4,32));
			addr_sig <= addr;
			wait for C_CLK_PRD;
		end loop;
		mem_wr_sig <= '0';
		
		-- reading the written data in address 4 to 40
		mem_rd_sig <= '1';
		for i in 1 to 10 loop
			addr := std_logic_vector(to_unsigned(i*4,32));
			addr_sig <= addr;
			wait for C_CLK_PRD;
		end loop;
		mem_rd_sig <= '0';
		
		-- RD and WR are both disabled
		wait for 2*C_CLK_PRD;
		
		-- RD and WR are both enabled
		mem_wr_sig <= '1';
		mem_rd_sig <= '1';
		-- write data (3, 6, 9, ..., 30) in address 4 to 40
		for i in 1 to 10 loop
			wr_data_sig <= std_logic_vector(to_unsigned(i*3,32));
			addr := std_logic_vector(to_unsigned(i*4,32));
			addr_sig <= addr;
			wait for C_CLK_PRD;
		end loop;
		mem_wr_sig <= '0';
		
		-- reading the written data in address 4 to 40
		for i in 1 to 10 loop
			addr := std_logic_vector(to_unsigned(i*4,32));
			addr_sig <= addr;
			wait for C_CLK_PRD;
		end loop;
		mem_rd_sig <= '0';
		
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;
	
end architecture;