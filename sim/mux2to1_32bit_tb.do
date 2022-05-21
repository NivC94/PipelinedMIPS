vcom ../src/mux2to1_32bit.vhd
vcom ../src/mux2to1_32bit_tb.vhd

vsim mux2to1_32bit_tb
add wave -radix hexadecimal mux2to1_32bit_tb/DUT/*
run 40ns
wave zoom full