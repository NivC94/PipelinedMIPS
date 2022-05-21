vcom ../src/full_adder.vhd
vcom ../src/adder_32bits.vhd
vcom ../src/adder_32bits_tb.vhd

vsim adder_32bits_tb
add wave -radix signed adder_32bits_tb/DUT/*
run 50ns
wave zoom full