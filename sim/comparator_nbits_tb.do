vcom ../src/comparator_nbits.vhd
vcom ../src/comparator_nbits_tb.vhd

vsim comparator_nbits_tb

add wave comparator_nbits_tb/DUT/*
run -all