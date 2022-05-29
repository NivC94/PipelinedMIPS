library ieee;
use ieee.std_logic_1164.all;

entity alu_control_unit is
port(
	FUNCT			: in std_logic_vector(5 downto 0);
	ALU_OP			: in std_logic_vector(1 downto 0);
	
	A_INVERT		: out std_logic := '0';
	B_INVERT		: out std_logic;
	C_IN			: out std_logic;
	OPERATION		: out std_logic_vector(1 downto 0)
);
end entity;

architecture behave of alu_control_unit is

	constant alu_op_lw_sw	: std_logic_vector(1 downto 0) := "00";
	constant alu_op_beq		: std_logic_vector(1 downto 0) := "01";
	constant alu_op_rtype	: std_logic_vector(1 downto 0) := "10";
	
	constant funct_add		: std_logic_vector(5 downto 0) := "100000";
	constant funct_sub		: std_logic_vector(5 downto 0) := "100010";
	constant funct_and		: std_logic_vector(5 downto 0) := "100100";
	constant funct_or		: std_logic_vector(5 downto 0) := "100101";
	constant funct_slt		: std_logic_vector(5 downto 0) := "101010";
	
	constant operation_and	: std_logic_vector(1 downto 0) := "00";
	constant operation_or	: std_logic_vector(1 downto 0) := "01";
	constant operation_sum	: std_logic_vector(1 downto 0) := "10";
	constant operation_slt	: std_logic_vector(1 downto 0) := "11";
	
	-- TODO: temp
	signal error_sig		: std_logic;

begin

	process(FUNCT, ALU_OP)
	begin
		error_sig <= '0';
		B_INVERT	<=	'0';
		C_IN	    <=	'0';
		OPERATION   <=	operation_sum;
		case ALU_OP is
			when alu_op_lw_sw	=>	-- ADD
									B_INVERT	<=	'0';
									C_IN		<=	'0';
									OPERATION	<=	operation_sum;
			when alu_op_beq		=>	-- SUB
									B_INVERT	<=	'1';
									C_IN	    <=	'1';
									OPERATION   <=	operation_sum;
			when alu_op_rtype	=>	
									case FUNCT is
										when funct_add	=>	-- ADD
															B_INVERT	<=	'0';
											                C_IN	    <=	'0';
											                OPERATION   <=	operation_sum;
										when funct_sub	=>	-- SUB
															B_INVERT	<=	'1';
											                C_IN	    <=	'1';
											                OPERATION   <=	operation_sum;
										when funct_and	=>	-- AND
															B_INVERT	<=	'0';
											                C_IN	    <=	'0';
											                OPERATION   <=	operation_and;
										when funct_or	=>	-- OR
															B_INVERT	<=	'0';
											                C_IN	    <=	'0';
											                OPERATION   <=	operation_or;
										when funct_slt	=>	-- SLT
															B_INVERT	<=	'1';
											                C_IN	    <=	'1';
											                OPERATION   <=	operation_slt;
										when others		=>
															error_sig	<=	'1';
									end case;
			when others 		=>
									error_sig	<=	'1';
		end case;
		
	end process;
	
	
end architecture;