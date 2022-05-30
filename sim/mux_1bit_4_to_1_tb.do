vcom ../src/mux_1bit_4_to_1.vhd
vcom ../src/mux_1bit_4_to_1_tb.vhd

vsim mux_1bit_4_to_1_tb
add wave mux_1bit_4_to_1_tb/DUT/*
run 80ns
wave zoom full