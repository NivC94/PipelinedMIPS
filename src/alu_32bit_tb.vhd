library ieee;
use ieee.std_logic_1164.all;

entity alu_32bit_tb is
end entity;

architecture sim of alu_32bit_tb is
	
-- Component declaration

	component alu_32bit is
	port(
		A			: in std_logic_vector(31 downto 0);
		B			: in std_logic_vector(31 downto 0);
		C_IN		: in std_logic;
		
		A_INVERT	: in std_logic;
		B_INVERT	: in std_logic;
		
		OPERATION	: in std_logic_vector(1 downto 0);
		
		RESULT		: out std_logic_vector(31 downto 0)
	);
	end component;

-- Signals declaration

	signal a_sig			: std_logic_vector(31 downto 0) := (others => '0');
	signal b_sig			: std_logic_vector(31 downto 0) := (others => '0');
	signal c_in_sig			: std_logic := '0';
	
	signal a_invert_sig		: std_logic := '0';
	signal b_invert_sig		: std_logic := '0';

	signal operation_sig	: std_logic_vector(1 downto 0) := "00";
	
	signal result_sig		: 	std_logic_vector(31 downto 0);
	
begin
	
	process
	begin
		-- A and B
		operation_sig <= "00";
		a_sig <= (others => '0');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '0');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= "01010101010101010101010101010101";
		b_sig <= "10101010101010101010101010101010";
		wait for 5 ns;
		
		
		-- A and not B
		b_invert_sig <= '1';
		operation_sig <= "00";
		a_sig <= (others => '0');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '0');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= "01010101010101010101010101010101";
		b_sig <= "10101010101010101010101010101010";
		wait for 5 ns;
		b_invert_sig <= '0';
		
		-- A or B
		operation_sig <= "01";
		a_sig <= (others => '0');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '0');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= "01010101010101010101010101010101";
		b_sig <= "10101010101010101010101010101010";
		wait for 5 ns;
		
		-- not A or B
		a_invert_sig <= '1';
		operation_sig <= "01";
		a_sig <= (others => '0');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '0');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= "01010101010101010101010101010101";
		b_sig <= "10101010101010101010101010101010";
		wait for 5 ns;
		a_invert_sig <= '0';
		
		-- A + B
		operation_sig <= "10";
		a_sig <= (others => '0');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '0');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= "00000000000000000000000000000100";
		b_sig <= "00000000000000000000000000000101";
		wait for 5 ns;
		
		-- A - B
		c_in_sig <= '1';
		b_invert_sig <= '1';
		operation_sig <= "10";
		a_sig <= (others => '0');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '0');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= "00000000000000000000000000000100";
		b_sig <= "00000000000000000000000000000101";
		wait for 5 ns;
		a_sig <= "00000000000000000000000000000101";
		b_sig <= "00000000000000000000000000000100";
		wait for 5 ns;
		c_in_sig <= '0';
		b_invert_sig <= '0';
		
		-- SLT
		c_in_sig <= '1';
		b_invert_sig <= '1';
		operation_sig <= "11";
		a_sig <= (others => '0');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '0');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '0');
		wait for 5 ns;
		a_sig <= (others => '1');
		b_sig <= (others => '1');
		wait for 5 ns;
		a_sig <= "00000000000000000000000000000100";
		b_sig <= "00000000000000000000000000000101";
		wait for 5 ns;
		a_sig <= "00000000000000000000000000000101";
		b_sig <= "00000000000000000000000000000100";
		wait for 5 ns;
		c_in_sig <= '0';
		b_invert_sig <= '0';
		
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;

-- Components instantiations

DUT: alu_32bit
	port map (
		A			=>	a_sig,
		B			=>	b_sig,
		C_IN		=>	c_in_sig,
		
		A_INVERT	=>	a_invert_sig,
		B_INVERT	=>	b_invert_sig,
		
		OPERATION	=>	operation_sig,
		
		RESULT		=>	result_sig
	);
	
end architecture;