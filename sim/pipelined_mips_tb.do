# general
vcom ../src/mux_1bit_2to1.vhd
vcom ../src/mux_n_bit_2to1.vhd
vcom ../src/full_adder.vhd
vcom ../src/adder_32bits.vhd
vcom ../src/mux_1bit_4_to_1.vhd
vcom ../src/register_1bit.vhd
vcom ../src/register_nbit.vhd

# IF module
vcom ../src/pc_reg.vhd
vcom ../src/instruction_memory.vhd
vcom ../src/instruction_fetch_module.vhd

# IF/ID reg
vcom ../src/if_id_reg.vhd

# ID module
vcom ../src/control_unit.vhd
vcom ../src/comparator_nbits.vhd
vcom ../src/register_file.vhd
vcom ../src/instruction_decode_module.vhd

# ID/EX reg
vcom ../src/id_ex_reg.vhd

# EX module
vcom ../src/alu_1bit.vhd
vcom ../src/alu_32bit.vhd
vcom ../src/alu_control_unit.vhd
vcom ../src/execution_module.vhd

# EX/MEM reg
vcom ../src/ex_mem_reg.vhd

# MEM module
vcom ../src/data_memory.vhd

# MEM/WB reg
vcom ../src/mem_wb_reg.vhd

vcom ../src/pipelined_mips.vhd
vcom ../src/pipelined_mips_tb.vhd

vsim pipelined_mips_tb
add wave -radix hexadecimal pipelined_mips_tb/DUT/*
add wave -radix hexadecimal pipelined_mips_tb/DUT/DATA_MEM/line__36/d_mem(8192:8512)

add wave -radix hexadecimal pipelined_mips_tb/DUT/INSTRUCTION_DECODE/CU/BRANCH
add wave -radix hexadecimal pipelined_mips_tb/DUT/INSTRUCTION_DECODE/CU/JUMP
add wave -radix hexadecimal pipelined_mips_tb/DUT/INSTRUCTION_DECODE/REG_FILE/register_data

run -all
wave zoom full