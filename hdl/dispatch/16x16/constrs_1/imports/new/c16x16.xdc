create_clock -period 7.563 -name clk -waveform {0.000 3.782} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]







