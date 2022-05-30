library ieee;
use ieee.std_logic_1164.all;

entity execution_module_tb is
end entity;

architecture sim of execution_module_tb is
	
	-- Constants declaration

	constant alu_op_lw_sw	: std_logic_vector(1 downto 0) := "00";
	constant alu_op_beq		: std_logic_vector(1 downto 0) := "01";
	constant alu_op_rtype	: std_logic_vector(1 downto 0) := "10";
	
	constant funct_add		: std_logic_vector(5 downto 0) := "100000";
	constant funct_sub		: std_logic_vector(5 downto 0) := "100010";
	constant funct_and		: std_logic_vector(5 downto 0) := "100100";
	constant funct_or		: std_logic_vector(5 downto 0) := "100101";
	constant funct_slt		: std_logic_vector(5 downto 0) := "101010";
	
-- Component declaration

	component execution_module is
	port (
		REG_DATA_IN1	: in std_logic_vector(31 downto 0);
		REG_DATA_IN2	: in std_logic_vector(31 downto 0);
		IMMEDIATE_IN	: in std_logic_vector(31 downto 0);
		FUNCT			: in std_logic_vector(5 downto 0);
		
		RT_REG			: in std_logic_vector(4 downto 0); -- Ins[20:16]
		RD_REG			: in std_logic_vector(4 downto 0); -- Ins[15:11]
		
		ALU_SRC			: in std_logic;
		ALU_OP			: in std_logic_vector(1 downto 0);
		REG_DST			: in std_logic;
		
		ALU_RESULT		: out std_logic_vector(31 downto 0);
		REG_OUT			: out std_logic_vector(4 downto 0)
	);
	end component;

-- Signals declaration

	signal reg_data_in1_sig		: std_logic_vector(31 downto 0) := (others => '0');
	signal reg_data_in2_sig     : std_logic_vector(31 downto 0) := (others => '0');
	signal immediate_in_sig     : std_logic_vector(31 downto 0) := (others => '0');
	signal funct_sig		    : std_logic_vector(5 downto 0) := (others => '0');
	
	signal rt_reg_sig		    : std_logic_vector(4 downto 0) := (others => '0');
	signal rd_reg_sig		    : std_logic_vector(4 downto 0) := (others => '0');
	
	signal alu_src_sig		    : std_logic := '0';
	signal alu_op_sig		    : std_logic_vector(1 downto 0) := "00";
	signal reg_dst_sig		    : std_logic := '0';
	
	signal alu_result_sig	    : std_logic_vector(31 downto 0);
	signal reg_out_sig		    : std_logic_vector(4 downto 0);
	
begin
	
	
	rt_reg_sig	<= "01000", "11111" after 20 ns;
	rd_reg_sig	<= "10111", "00000" after 20 ns;
	reg_dst_sig	<= '0',	'1' after 5 ns,'0' after 10 ns,'1' after 15 ns,'0' after 20 ns,'1' after 25 ns,'0' after 30 ns,'1' after 35 ns;
	
	
	process
	begin
	
		-- LW/SW => ADD
		alu_op_sig <= alu_op_lw_sw;
		alu_src_sig <= '1';
		funct_sig <= (others => '0');
		reg_data_in1_sig <= "00000000000000000000000000000100";
		immediate_in_sig <= "00000000000000000000000000001101";
		wait for 5 ns;
		funct_sig <= (others => '1');
		reg_data_in1_sig <= "00000000000000000000000000000111";
		immediate_in_sig <= "00000000000000000000000000001001";
		wait for 5 ns;
		funct_sig <= funct_sub;
		reg_data_in1_sig <= "00000000000000000000000000000111";
		immediate_in_sig <= "00000000000000000000000000001001";
		wait for 5 ns;
		
		-- R-TYPE --
		alu_op_sig <= alu_op_rtype;
		alu_src_sig <= '0';
		
		-- ADD
		funct_sig <= funct_add;
		reg_data_in1_sig <= "00000000000000000000000000000100";
		reg_data_in2_sig <= "00000000000000000000000000001101";
		wait for 5 ns;
		reg_data_in1_sig <= "00000000000000000000000000000111";
		reg_data_in2_sig <= "00000000000000000000000000001001";
		wait for 5 ns;
		
		-- SUB
		funct_sig <= funct_sub;
		reg_data_in1_sig <= "00000000000000000000000000000100";
		reg_data_in2_sig <= "00000000000000000000000000001101";
		wait for 5 ns;
		reg_data_in1_sig <= "00000000000000000000000000000111";
		reg_data_in2_sig <= "00000000000000000000000000001001";
		wait for 5 ns;
		reg_data_in1_sig <= "00000000000000000000000000001111";
		reg_data_in2_sig <= "00000000000000000000000000000101";
		wait for 5 ns;

		-- AND
		funct_sig <= funct_and;
		reg_data_in1_sig <= (others => '0');
		reg_data_in2_sig <= (others => '0');
		wait for 5 ns;
		reg_data_in1_sig <= (others => '0');
		reg_data_in2_sig <= (others => '1');
		wait for 5 ns;
		reg_data_in1_sig <= (others => '1');
		reg_data_in2_sig <= (others => '0');
		wait for 5 ns;
		reg_data_in1_sig <= (others => '1');
		reg_data_in2_sig <= (others => '1');
		wait for 5 ns;
		reg_data_in1_sig <= "01010101010101010101010101010101";
		reg_data_in2_sig <= "10101010101010101010101010101010";
		wait for 5 ns;
		-- OR
		funct_sig <= funct_or;
		reg_data_in1_sig <= (others => '0');
		reg_data_in2_sig <= (others => '0');
		wait for 5 ns;
		reg_data_in1_sig <= (others => '0');
		reg_data_in2_sig <= (others => '1');
		wait for 5 ns;
		reg_data_in1_sig <= (others => '1');
		reg_data_in2_sig <= (others => '0');
		wait for 5 ns;
		reg_data_in1_sig <= (others => '1');
		reg_data_in2_sig <= (others => '1');
		wait for 5 ns;
		reg_data_in1_sig <= "01010101010101010101010101010101";
		reg_data_in2_sig <= "10101010101010101010101010101010";
		wait for 5 ns;
		-- SLT
		funct_sig <= funct_slt;
		reg_data_in1_sig <= "00000000000000000000000000000100";
		reg_data_in2_sig <= "00000000000000000000000000001101";
		wait for 5 ns;
		reg_data_in1_sig <= "00000000000000000000000000000111";
		reg_data_in2_sig <= "00000000000000000000000000001001";
		wait for 5 ns;
		reg_data_in1_sig <= "00000000000000000000000000001111";
		reg_data_in2_sig <= "00000000000000000000000000000101";
		wait for 5 ns;
		
		-- I-TYPE --
		alu_src_sig <= '1';
		
		-- ADDI
		alu_op_sig <= alu_op_lw_sw;
		
		reg_data_in1_sig <= "00000000000000000000000000000100";
		immediate_in_sig <= "00000000000000000000000000001101";
		wait for 5 ns;
		reg_data_in1_sig <= "00000000000000000000000000000111";
		immediate_in_sig <= "00000000000000000000000000001001";
		wait for 5 ns;
		
		-- SUBI
		alu_op_sig <= alu_op_beq;
		
		reg_data_in1_sig <= "00000000000000000000000000000100";
		immediate_in_sig <= "00000000000000000000000000001101";
		wait for 5 ns;
		reg_data_in1_sig <= "00000000000000000000000000000111";
		immediate_in_sig <= "00000000000000000000000000001001";
		wait for 5 ns;
		
		-- stopping the simulation
		report "end of simulation" severity failure;
		wait;
	end process;

-- Components instantiations

DUT: execution_module
	port map (
		REG_DATA_IN1	=>	reg_data_in1_sig,
		REG_DATA_IN2    =>	reg_data_in2_sig,
		IMMEDIATE_IN    =>	immediate_in_sig,
		FUNCT		    =>	funct_sig,
		                    
		RT_REG		    =>	rt_reg_sig,
		RD_REG		    =>	rd_reg_sig,
		                    
		ALU_SRC		    =>	alu_src_sig,
		ALU_OP		    =>	alu_op_sig,
		REG_DST		    =>	reg_dst_sig,
		                    
		ALU_RESULT	    =>	alu_result_sig,
		REG_OUT		    =>	reg_out_sig
	);

end architecture;