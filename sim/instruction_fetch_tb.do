vcom ../src/mux_1bit_2to1.vhd
vcom ../src/mux_n_bit_2to1.vhd
vcom ../src/full_adder.vhd
vcom ../src/adder_32bits.vhd
vcom ../src/pc_reg.vhd
vcom ../src/instruction_memory.vhd
vcom ../src/instruction_fetch_module.vhd
vcom ../src/instruction_fetch_module_tb.vhd

vsim instruction_fetch_module_tb
add wave -radix hexadecimal instruction_fetch_module_tb/DUT/*
run -all
