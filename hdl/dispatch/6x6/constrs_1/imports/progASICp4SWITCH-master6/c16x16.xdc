create_clock -period 5.225 -name clk -waveform {0.000 2.612} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]






