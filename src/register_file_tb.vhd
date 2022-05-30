library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity register_file_tb is
end entity;

architecture sim of register_file_tb is

-- Constants declaration

	constant C_CLK_PRD : time := 10 ns;

-- Components declaration

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
	
-- Signals declaration
	
	signal read_reg_1_sig	: std_logic_vector (4 downto 0):= (others => '0');
	signal read_reg_2_sig	: std_logic_vector (4 downto 0):= (others => '0');
	
	signal clk_sig			: std_logic := '1';
	
	signal reg_write_sig	: std_logic := '0';
	signal write_reg_sig	: std_logic_vector (4 downto 0):= (others => '0');
	signal write_data_sig	: std_logic_vector (31 downto 0):= (others => '0');
	
	signal read_data_1_sig	: std_logic_vector (31 downto 0):= (others => '0');
	signal read_data_2_sig	: std_logic_vector (31 downto 0):= (others => '0');
	
begin

-- Components instantiations

DUT: register_file
	port map (
		READ_REG_1		=>	read_reg_1_sig,	
        READ_REG_2	    =>  read_reg_2_sig,
		
        CLK			    =>  clk_sig,

		REG_WRITE	    =>  reg_write_sig,	
		WRITE_REG	    =>  write_reg_sig,		
		WRITE_DATA	    =>  write_data_sig,		

		READ_DATA_1	    =>  read_data_1_sig,		
	    READ_DATA_2	    =>  read_data_2_sig	
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
	begin
		wait for C_CLK_PRD;
		
		reg_write_sig <= '1';
		
		write_data_sig <= write_data_sig + '1';
		
		for i in 0 to 31 loop
			write_reg_sig <= std_logic_vector(to_unsigned(i,5));
			write_data_sig <= write_data_sig + 1;
			wait for C_CLK_PRD;
		end loop;
		
		reg_write_sig <='0';
		
		for i in 0 to 31 loop
			read_reg_1_sig <= std_logic_vector(to_unsigned(i,5));
			read_reg_2_sig <= std_logic_vector(to_unsigned(31-i,5));
			wait for C_CLK_PRD;
		end loop;
		
		read_reg_1_sig <= std_logic_vector(to_unsigned(3,5));
		write_reg_sig <= std_logic_vector(to_unsigned(3,5));
		write_data_sig <= std_logic_vector(to_unsigned(1087,32));
		reg_write_sig <= '1';
		wait for C_CLK_PRD;
		reg_write_sig <= '0';
		wait for C_CLK_PRD;
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;
	
end architecture;