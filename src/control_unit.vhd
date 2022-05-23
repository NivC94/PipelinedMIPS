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
	
begin
	
with OPCODE select
	BRANCH 		<=	'0' when r_type_opcode,
					'0' when jump_opcode,
					'1' when beq_opcode,
					'0' when lw_opcode,
					'0' when sw_opcode,
					'0' when others;

with OPCODE select				
	JUMP	 	<=	'0' when r_type_opcode,
					'1' when jump_opcode,
					'0' when beq_opcode,
					'0' when lw_opcode,
					'0' when sw_opcode,
					'0' when others;
				
with OPCODE select				
	MEM_TO_REG	<=	'0' when r_type_opcode,
					'0' when jump_opcode,
					'0' when beq_opcode,
					'1' when lw_opcode,
					'0' when sw_opcode,
					'0' when others;

with OPCODE select
	REG_WRITE 	<=	'1' when r_type_opcode,
					'0' when jump_opcode,
					'0' when beq_opcode,
					'1' when lw_opcode,
					'0' when sw_opcode,
					'0' when others;

with OPCODE select			
	MEM_READ 	<=	'0' when r_type_opcode,
					'0' when jump_opcode,
					'0' when beq_opcode,
					'1' when lw_opcode,
					'0' when sw_opcode,
					'0' when others;

with OPCODE select			
	MEM_WRITE	 <=	'0' when r_type_opcode,
					'0' when jump_opcode,
					'0' when beq_opcode,
					'0' when lw_opcode,
					'1' when sw_opcode,
					'0' when others;

with OPCODE select			
	ALU_SRC		 <=	'0' when r_type_opcode,
					'0' when jump_opcode,
					'0' when beq_opcode,
					'1' when lw_opcode,
					'1' when sw_opcode,
					'0' when others;
					
with OPCODE select
	REG_DST		 <=	'1' when r_type_opcode,
					'0' when jump_opcode,
					'0' when beq_opcode,
					'0' when lw_opcode,
					'0' when sw_opcode,
					'0' when others;
					
with OPCODE select					
	ALU_OP		 <=	"10" when r_type_opcode,
					"00" when jump_opcode,
					"01" when beq_opcode,
					"00" when lw_opcode,
					"00" when sw_opcode,
					"00" when others;

end architecture;

