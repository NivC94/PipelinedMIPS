vcom ../src/mux_1bit_2to1.vhd
vcom ../src/full_adder.vhd
vcom ../src/mux_1bit_4_to_1.vhd
vcom ../src/alu_1bit.vhd
vcom ../src/alu_1bit_tb.vhd

vsim alu_1bit_tb
add wave alu_1bit_tb/DUT/*
run -all
wave zoom full