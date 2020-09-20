create_clock -period 5.450 -name clk -waveform {0.000 2.725} -add [get_ports -filter { NAME =~  "*clk*" && DIRECTION == "IN" }]






