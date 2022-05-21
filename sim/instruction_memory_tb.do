vcom ../src/instruction_memory.vhd
vcom ../src/instruction_memory_tb.vhd

vsim instruction_memory_tb
add wave -radix hexadecimal instruction_memory_tb/DUT/*
run -all
