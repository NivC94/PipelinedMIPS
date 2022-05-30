library ieee;
use ieee.std_logic_1164.all;

entity comparator_nbits_tb is
end entity;

architecture sim of comparator_nbits_tb is

	constant C_DATA_WIDTH	: integer := 32;

-- Component declaration

	component comparator_nbits is
	generic(
		G_DATA_WIDTH	: integer := 32
	);
	port(
		A		: in std_logic_vector((G_DATA_WIDTH-1) downto 0);
		B		: in std_logic_vector((G_DATA_WIDTH-1) downto 0);
			
		EQUAL 	: out std_logic
	);
	end component;

-- Signal declaration	

	signal a_sig	: std_logic_vector((C_DATA_WIDTH-1) downto 0) := (others => '0');
	signal b_sig	: std_logic_vector((C_DATA_WIDTH-1) downto 0) := (others => '0');
	
	signal equal_sig	: std_logic;
	
begin
	
-- Components instantiations

DUT: comparator_nbits
	generic map(
		G_DATA_WIDTH	=> C_DATA_WIDTH
	)
	port map (
		A		=> a_sig,
		B		=> b_sig,
		
		EQUAL	=> equal_sig	
	);
	
	process
	begin
		wait for 10 ns;
		
		a_sig <= ((C_DATA_WIDTH-1)|(C_DATA_WIDTH-2)|(C_DATA_WIDTH-3)=>'1', others => '0');
		b_sig <= ((C_DATA_WIDTH-1)|(C_DATA_WIDTH-2)|(C_DATA_WIDTH-3)=>'1', others => '0');
		wait for 50 ns;
		
		a_sig <= ((C_DATA_WIDTH-3)=>'1', others => '0');
		b_sig <= ((C_DATA_WIDTH-1)|(C_DATA_WIDTH-2)|(C_DATA_WIDTH-3)=>'1', others => '0');
		wait for 50 ns;
		
		a_sig <= (others => '0');
		b_sig <= (others => '0');
		wait for 50 ns;
		
		a_sig <= (others => '1');
		b_sig <= (others => '1');
		wait for 50 ns;
		
		a_sig <= ((C_DATA_WIDTH-2)|(C_DATA_WIDTH-4)=>'1', others => '0');
		b_sig <= ((C_DATA_WIDTH-1)|(C_DATA_WIDTH-3)=>'1', others => '0');
		wait for 50 ns;
		
		a_sig <= ((C_DATA_WIDTH-1)|(C_DATA_WIDTH-3)=>'1', others => '0');
		b_sig <= ((C_DATA_WIDTH-2)|(C_DATA_WIDTH-4)=>'1', others => '0');
		wait for 50 ns;

		report "end of simulation" severity failure;
		wait;
	end process;

end architecture;