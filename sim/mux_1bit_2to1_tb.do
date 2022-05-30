vcom ../src/mux_1bit_2to1.vhd
vcom ../src/mux_1bit_2to1_tb.vhd

vsim mux_1bit_2to1_tb
add wave mux_1bit_2to1_tb/DUT/*
run 40ns
wave zoom full