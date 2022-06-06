library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
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
end entity;

architecture behave of control_unit is

	constant r_type_opcode		: std_logic_vector(5 downto 0) := "000000";
	constant jump_opcode		: std_logic_vector(5 downto 0) := "000010";
	constant beq_opcode			: std_logic_vector(5 downto 0) := "000100";
	constant lw_opcode			: std_logic_vector(5 downto 0) := "100011";
	constant sw_opcode			: std_logic_vector(5 downto 0) := "101011";
	constant addi_opcode		: std_logic_vector(5 downto 0) := "001000";
	
begin
	
	process(OPCODE)
	begin
		BRANCH	<= '0';
		JUMP	<= '0';
		
		MEM_TO_REG	<=	'0';
		REG_WRITE	<=	'0';
		
		MEM_READ	<= '0';
		MEM_WRITE	<= '0';
		
		ALU_SRC		<=	'0';
		REG_DST		<=	'0';
		ALU_OP		<=	"00";
		
		case OPCODE is
			when r_type_opcode	=>	-- R-Type
									REG_WRITE	<=	'1';
									ALU_OP		<=	"10";
									REG_DST		<=	'1';
									
			when jump_opcode	=>	-- Jump
									JUMP	<=	'1';
									
			when beq_opcode		=>	-- BEQ
									BRANCH	<=	'1';
									ALU_OP	<=	"01";
									
			when lw_opcode		=>	-- LW
									MEM_TO_REG	<=	'1';
									REG_WRITE	<=	'1';
									MEM_READ	<=	'1';
									ALU_SRC		<=	'1';
									
			when sw_opcode		=>	-- SW
									MEM_WRITE	<=	'1';
									ALU_SRC		<=	'1';
			
			when addi_opcode	=>	-- ADDI
									REG_WRITE	<=	'1';
									ALU_SRC		<=	'1';
									
			when others 		=>	-- ERROR
		end case;
	
	end process;

end architecture;

