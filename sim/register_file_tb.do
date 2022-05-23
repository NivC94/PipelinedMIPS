vcom ../src/register_file.vhd
vcom ../src/register_file.vhd

vsim register_file_tb
add wave -radix hexadecimal register_file_tb/DUT/*
run -all