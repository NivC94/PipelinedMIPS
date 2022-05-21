library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity data_memory is
generic(
	G_ADDR_WIDTH		: integer := 32; -- only for simulation purpose (due to simulation limits)
	G_DMEM_FILE_NAME	: string := "source.txt"; -- data file name
	G_FILE_HEX_FORMAT	: boolean := true -- if false file is in decimal format
);
port (
	ADDR		: in std_logic_vector(31 downto 0) := (others => '0');
	WR_DATA		: in std_logic_vector(31 downto 0); -- data input
	
	CLK			: in std_logic;
	MEM_WR		: in std_logic; -- write enable
	MEM_RD		: in std_logic; -- read enable
	
	RD_DATA		: out std_logic_vector(31 downto 0) := (others => '0') -- data output
);
end entity;

architecture behave of data_memory is
	
	file d_mem_file	: text;
	
	signal is_startup : std_logic := '1'; -- startup indicator flag
	
	type memory is array(0 to ((2**G_ADDR_WIDTH)-1)) of std_logic_vector(7 downto 0); -- define new type called memory
	
begin

	process(is_startup, CLK)
	variable addr_aux : integer := 0;
	variable data_line : line; -- auxiliary variable of type line to save the raw line
	variable data	: std_logic_vector(31 downto 0); -- auxiliary variable to save the data
	variable data_int : integer; -- auxiliary variable to save the data if the file is in decimal format
	variable d_mem	: memory := (others => (others => '0')); -- initialize data memory with zeros
	begin
		
		if is_startup = '0' then
			if rising_edge(CLK) then
				if MEM_WR = '1' then
					-- write the input data divided to the 4 bytes following the given address
					d_mem(to_integer(unsigned(ADDR))) 	:= WR_DATA(31 downto 24);
					d_mem(to_integer(unsigned(ADDR))+1) := WR_DATA(23 downto 16);
					d_mem(to_integer(unsigned(ADDR))+2) := WR_DATA(15 downto 8);
					d_mem(to_integer(unsigned(ADDR))+3) := WR_DATA(7 downto 0);
				elsif MEM_RD = '1' then
					-- output the data of the 4 bytes following the given address concatenated together 
					RD_DATA <=	d_mem(to_integer(unsigned(ADDR)))	&	d_mem(to_integer(unsigned(ADDR))+1) &
								d_mem(to_integer(unsigned(ADDR))+2)	&	d_mem(to_integer(unsigned(ADDR))+3);
				end if;
			end if;
		-- on startup, reading the given text file into the memory
		else -- if is_startup = '1'
			file_open(d_mem_file, G_DMEM_FILE_NAME, read_mode);
			
			-- read each line until the end of file
			while (not endfile(d_mem_file)) loop
				readline (d_mem_file, data_line); -- read one line from the file
				
				if G_FILE_HEX_FORMAT then -- the data in the file is in hex format
					-- read the line in hex format
					hread (data_line, data);
				else -- the data in the file is in decimal format
					-- read the line in decimal format and convert to std_logic_vector
					read (data_line, data_int);
					data := std_logic_vector(to_unsigned(data_int,32));
				end if;
				
				-- save each byte of the data to the memory and increment the address by 4
				d_mem(addr_aux)		:= data(31 downto 24);
				d_mem(addr_aux+1)	:= data(23 downto 16);
				d_mem(addr_aux+2)	:= data(15 downto 8);
				d_mem(addr_aux+3)	:= data(7 downto 0);
				
				addr_aux := addr_aux + 4;
			end loop;
			-- finish startup initialization 
			file_close(d_mem_file);
			is_startup <= '0';
		end if;
	end process;
	
end architecture;