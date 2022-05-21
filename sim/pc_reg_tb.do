vcom ../src/pc_reg.vhd
vcom ../src/pc_reg_tb.vhd

vsim pc_reg_tb
add wave -radix hexadecimal pc_reg_tb/DUT/*
run -all