library ieee;
use ieee.std_logic_1164.all;

entity alu_1bit_tb is
end entity;

architecture sim of alu_1bit_tb is
	
-- Component declaration

	component alu_1bit is
	port(
		A			: in std_logic;
		B			: in std_logic;
		LESS		: in std_logic;
		C_IN		: in std_logic;		
		
		A_INVERT	: in std_logic;
		B_INVERT	: in std_logic;
		
		OPERATION	: in std_logic_vector(1 downto 0);
		
		C_OUT		: out std_logic;
		SET			: out std_logic;
		RESULT		: out std_logic
	);
	end component;

-- Signals declaration

	signal a_sig		: std_logic := '0';
	signal b_sig		: std_logic := '0';
	signal less_sig		: std_logic := '0';
	signal c_in_sig		: std_logic := '0';
	
	signal a_invert_sig	: std_logic := '0';
	signal b_invert_sig	: std_logic := '0';

	signal operation_sig	: std_logic_vector(1 downto 0) := "00";

	signal c_out_sig	: std_logic;
	signal set_sig		: std_logic;
	signal result_sig	: std_logic;
	
begin
	
	process
	begin
		-- A and B
		operation_sig <= "00";
		a_sig <= '0';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '0';
		b_sig <= '1';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '1';
		wait for 5 ns;
		
		-- A and not B
		b_invert_sig <= '1';
		operation_sig <= "00";
		a_sig <= '0';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '0';
		b_sig <= '1';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '1';
		wait for 5 ns;
		b_invert_sig <= '0';
		
		-- A or B
		operation_sig <= "01";
		a_sig <= '0';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '0';
		b_sig <= '1';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '1';
		wait for 5 ns;
		
		-- not A or B
		a_invert_sig <= '1';
		operation_sig <= "01";
		a_sig <= '0';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '0';
		b_sig <= '1';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '1';
		wait for 5 ns;
		a_invert_sig <= '0';
		
		-- A + B
		operation_sig <= "10";
		a_sig <= '0';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '0';
		b_sig <= '1';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '1';
		wait for 5 ns;
		
		-- A - B
		c_in_sig <= '1';
		b_invert_sig <= '1';
		operation_sig <= "10";
		a_sig <= '0';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '0';
		wait for 5 ns;
		a_sig <= '0';
		b_sig <= '1';
		wait for 5 ns;
		a_sig <= '1';
		b_sig <= '1';
		wait for 5 ns;
		c_in_sig <= '0';
		b_invert_sig <= '0';
		
		-- pass LESS
		operation_sig <= "11";
		less_sig <= '0';
		wait for 5 ns;
		less_sig <= '1';
		wait for 5 ns;
		
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;

-- Components instantiations

DUT: alu_1bit
	port map (
		A			=>	a_sig,
		B			=>	b_sig,
		LESS		=>	less_sig,
		C_IN		=>	c_in_sig,
		
		A_INVERT	=>	a_invert_sig,
		B_INVERT	=>	b_invert_sig,
		
		OPERATION	=>	operation_sig,
		
		C_OUT		=>	c_out_sig,
		SET			=>	set_sig,
		RESULT		=>	result_sig
	);
	
end architecture;