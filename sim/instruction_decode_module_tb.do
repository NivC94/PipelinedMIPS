vcom ../src/full_adder.vhd
vcom ../src/adder_32bits.vhd
vcom ../src/control_unit.vhd
vcom ../src/comparator_nbits.vhd
vcom ../src/register_file.vhd
vcom ../src/instruction_decode_module.vhd
vcom ../src/instruction_decode_module_tb.vhd

vsim instruction_decode_module_tb

add wave instruction_decode_module_tb/DUT/*
run -all