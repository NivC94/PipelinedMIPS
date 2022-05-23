vcom ../src/control_unit.vhd
vcom ../src/control_unit_tb.vhd

vsim control_unit_tb

add wave control_unit_tb/DUT/*
run -all