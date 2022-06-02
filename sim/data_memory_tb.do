vcom ../src/data_memory.vhd
vcom ../src/data_memory_tb.vhd

vsim data_memory_tb
add wave -radix hexadecimal data_memory_tb/DUT/*
add wave -radix hexadecimal data_memory_tb/DUT/line__36/d_mem(8192:8272)
add wave -radix decimal data_memory_tb/DUT/RD_DATA
run -all