vcom ../src/mux_32bit_2to1.vhd
vcom ../src/mux_32bit_2to1_tb.vhd

vsim mux_32bit_2to1_tb
add wave -radix hexadecimal mux_32bit_2to1_tb/DUT/*
run 40ns
wave zoom full