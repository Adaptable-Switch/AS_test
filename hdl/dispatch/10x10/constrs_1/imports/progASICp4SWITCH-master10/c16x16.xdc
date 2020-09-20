create_clock -period 6.025 -name clk -waveform {0.000 3.013} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]








