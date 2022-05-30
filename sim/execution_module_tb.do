vcom ../src/mux_n_bit_2to1.vhd
vcom ../src/mux_1bit_2to1.vhd
vcom ../src/full_adder.vhd
vcom ../src/mux_1bit_4_to_1.vhd
vcom ../src/alu_1bit.vhd
vcom ../src/alu_32bit.vhd
vcom ../src/alu_control_unit.vhd
vcom ../src/execution_module.vhd
vcom ../src/execution_module_tb.vhd

vsim execution_module_tb
add wave execution_module_tb/DUT/*
run -all
wave zoom full