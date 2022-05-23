library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
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
end entity;

architecture behave of register_file is
	
	type registers is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal register_data	: registers := (others => (others => '0'));
	
	begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			if REG_WRITE = '1' then
				if WRITE_REG /= "00000" then	-- Zero reg write is discarded - allways stays zero
					register_data(to_integer(unsigned(WRITE_REG))) <= WRITE_DATA;
				end if;
			end if;
			
			READ_DATA_1 <= register_data(to_integer(unsigned(READ_REG_1)));
			READ_DATA_2 <= register_data(to_integer(unsigned(READ_REG_2)));
		end if;
	end process;
end architecture;
			