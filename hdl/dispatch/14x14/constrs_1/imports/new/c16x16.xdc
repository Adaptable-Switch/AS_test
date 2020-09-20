create_clock -period 7.125 -name clk -waveform {0.000 3.563} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]







