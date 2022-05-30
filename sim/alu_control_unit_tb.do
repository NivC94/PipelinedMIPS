vcom ../src/alu_control_unit.vhd
vcom ../src/alu_control_unit_tb.vhd

vsim alu_control_unit_tb
add wave alu_control_unit_tb/DUT/*
run -all
wave zoom full