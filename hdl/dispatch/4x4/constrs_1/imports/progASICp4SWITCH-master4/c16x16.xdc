create_clock -period 5.000 -name clk -waveform {0.000 2.500} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]


