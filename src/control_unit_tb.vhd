library ieee;
use ieee.std_logic_1164.all;

entity control_unit_tb is
end entity;

architecture sim of control_unit_tb is

	constant r_type_opcode		: std_logic_vector(5 downto 0) := "000000";
	constant jump_opcode		: std_logic_vector(5 downto 0) := "000010";
	constant beq_opcode			: std_logic_vector(5 downto 0) := "000100";
	constant lw_opcode			: std_logic_vector(5 downto 0) := "100011";
	constant sw_opcode			: std_logic_vector(5 downto 0) := "101011";
	constant addi_opcode		: std_logic_vector(5 downto 0) := "001000";
-- Component declaration

	component control_unit is
	port (
			OPCODE			: in std_logic_vector(5 downto 0);
			
			--Jump controll signals
			BRANCH			: out std_logic;
			JUMP			: out std_logic;
			
			--WB controll signals
			MEM_TO_REG		: out std_logic;
			REG_WRITE		: out std_logic;
			
			--MEM controll signals
			MEM_READ		: out std_logic;
			MEM_WRITE		: out std_logic;
			
			--EX controll signals
			ALU_SRC			: out std_logic;
			REG_DST			: out std_logic;
			ALU_OP			: out std_logic_vector(1 downto 0)
	);
	end component;

-- Signal declaration	

	signal opcode_sig		: std_logic_vector(5 downto 0) := (others => '0');

	signal branch_sig		: std_logic;
	signal jump_sig			: std_logic;
	
	signal mem_to_reg_sig	: std_logic;
	signal reg_write_sig	: std_logic;
	
	signal mem_read_sig		: std_logic;
	signal mem_write_sig	: std_logic;
	
	signal alu_src_sig		: std_logic;
	signal reg_dst_sig		: std_logic;
	signal alu_op_sig		: std_logic_vector(1 downto 0);
	
begin
	
-- Components instantiations

DUT: control_unit
	port map (
		OPCODE			=> opcode_sig,
                           
		BRANCH			=> branch_sig,		
		JUMP			=> jump_sig,	
                           
		MEM_TO_REG		=> mem_to_reg_sig,	
		REG_WRITE		=> reg_write_sig,
		                   
		MEM_READ		=> mem_read_sig,	
		MEM_WRITE		=> mem_write_sig,	
		                   
		ALU_SRC			=> alu_src_sig,	
		REG_DST			=> reg_dst_sig,	
		ALU_OP			=> alu_op_sig		
	);
	
	process
	begin
		wait for 10 ns;
		
		opcode_sig <= r_type_opcode;
		wait for 50 ns;
		
		opcode_sig <= jump_opcode;
		wait for 50 ns;
		
		opcode_sig <= beq_opcode;
		wait for 50 ns;
		
		opcode_sig <= lw_opcode;
		wait for 50 ns;
		
		opcode_sig <= sw_opcode;
		wait for 50 ns;
		
		opcode_sig <= addi_opcode;
		wait for 50 ns;
		
		opcode_sig <= "101010"; --this opcode is not supported should give LOW on all the controll signals
		wait for 50 ns;
		
		opcode_sig <= "111111"; --this opcode is not supported should give LOW on all the controll signals
		wait for 50 ns;

		report "end of simulation" severity failure;
		wait;
	end process;

end architecture;

