library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity instruction_memory is
generic(
	G_ADDR_WIDTH		: integer := 32; -- only for simulation purpose to limit memory size (due to simulation limits)
	G_IMEM_FILE_NAME	: string := "source.txt" -- instructions file name
);
port (
	READ_ADDR		: in std_logic_vector(31 downto 0) := (others => '0');
	
	INSTRUCTION		: out std_logic_vector(31 downto 0)
);
end entity;

architecture behave of instruction_memory is
	
	file i_mem_file	: text;
	
	signal is_startup : std_logic := '1'; -- startup indicator flag
	
	type memory is array(0 to ((2**G_ADDR_WIDTH)-1)) of std_logic_vector(7 downto 0); -- define new type called memory
	
begin

	process(is_startup, READ_ADDR)
	variable addr		: integer := 0;
	variable data_line	: line; -- auxiliary variable of type line to save the raw line
	variable data		: std_logic_vector(31 downto 0); -- auxiliary variable to save the data
	variable i_mem		: memory := (others => (others => '0')); -- initialize instruction memory with zeros
	begin
		-- on startup, reading the given text file into the memory
		if is_startup = '1' then
			file_open(i_mem_file, G_IMEM_FILE_NAME, read_mode);
			
			-- read each line until the end of file
			while (not endfile(i_mem_file)) loop
				-- read one line from the file in hex format into the data variable
				readline (i_mem_file, data_line);
				hread (data_line, data);
				
				-- save each byte of the data to the memory and increment the address by 4
				i_mem(addr)		:= data(31 downto 24);
				i_mem(addr+1)	:= data(23 downto 16);
				i_mem(addr+2)	:= data(15 downto 8);
				i_mem(addr+3)	:= data(7 downto 0);
				
				addr := addr + 4;
			end loop;
			-- finish startup initialization 
			file_close(i_mem_file);
			is_startup <= '0';
		else -- if is_startup = '0'
			-- output the data of the 4 bytes following the given address concatenated together
			INSTRUCTION <=	i_mem(to_integer(unsigned(READ_ADDR)))		&	i_mem(to_integer(unsigned(READ_ADDR))+1) &
							i_mem(to_integer(unsigned(READ_ADDR))+2)	&	i_mem(to_integer(unsigned(READ_ADDR))+3);
		end if;
	end process;

end architecture;