vcom ../src/full_adder.vhd
vcom ../src/full_adder_tb.vhd

vsim full_adder_tb
add wave full_adder_tb/DUT/*
run 40ns
wave zoom full