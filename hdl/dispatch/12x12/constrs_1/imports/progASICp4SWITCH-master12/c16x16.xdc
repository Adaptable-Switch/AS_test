create_clock -period 6.600 -name clk -waveform {0.000 3.300} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]








