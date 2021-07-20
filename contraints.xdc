## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

##octave btns
set_property PACKAGE_PIN U17 [get_ports i_dn_btn]						
	set_property IOSTANDARD LVCMOS33 [get_ports i_dn_btn]
set_property PACKAGE_PIN T18 [get_ports i_up_btn]						
    set_property IOSTANDARD LVCMOS33 [get_ports i_up_btn]

## Switches for the notes
set_property PACKAGE_PIN W15 [get_ports {enables[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[11]}]
set_property PACKAGE_PIN V15 [get_ports {enables[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[10]}]
set_property PACKAGE_PIN W14 [get_ports {enables[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[9]}]
set_property PACKAGE_PIN W13 [get_ports {enables[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[8]}]
set_property PACKAGE_PIN V2 [get_ports {enables[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[7]}]
set_property PACKAGE_PIN T3 [get_ports {enables[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[6]}]
set_property PACKAGE_PIN T2 [get_ports {enables[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[5]}]
set_property PACKAGE_PIN R3 [get_ports {enables[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[4]}]
set_property PACKAGE_PIN W2 [get_ports {enables[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[3]}]
set_property PACKAGE_PIN U1 [get_ports {enables[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[2]}]
set_property PACKAGE_PIN T1 [get_ports {enables[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[1]}]
set_property PACKAGE_PIN R2 [get_ports {enables[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enables[0]}]
	
##enable preprogrammed songs
set_property PACKAGE_PIN V17 [get_ports {preprog_song_sel[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {preprog_song_sel[0]}]
set_property PACKAGE_PIN V16 [get_ports {preprog_song_sel[1]}]					
     set_property IOSTANDARD LVCMOS33 [get_ports {preprog_song_sel[1]}]	

##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports o_soundwave]
set_property IOSTANDARD LVCMOS33 [get_ports o_soundwave]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
