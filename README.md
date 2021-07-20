# FPGA Music Box
A simple music box written in VHDL for the Basys 3 FPGA board. It is capable of playing all 12 notes in different octaves, with up to 3 notes at once. It can also play 2 preprogrammed songs that are loaded into the ROM upon startup. 

## Usage:
For each preprogrammed song, use the Xilinx Vivado IP to generate a single port BRAM with width 8 and depth equal to the number of bytes in the .coe file describing the song (704 for The Office theme, 1120 for Beethoven Virus). Load the .coe files with the song information into the BRAMs. Now it should be ready to load onto a Basys 3 FPGA. 

The switches are use to play individual notes, buttons are used to switch between octaves, and two separate switches are used for playing the programmed songs. 
* Notes are mapped to switches SW15 to SW4 of Basys 3 board, starting on C and going up the chromatic scale to end on B.
* Switch SW0 plays The Office theme song and switch SW1 plays Beethoven Virus.
* BTNU will increase the octave of all the note switches by 1 and BTND will decrease the octave by 1.

Video of operation: https://www.youtube.com/watch?v=tGXB9UTLiLU

## Dependencies: 
* [Basys 3 FPGA board](https://reference.digilentinc.com/programmable-logic/basys-3/start)
* [Xilinx Vivado IP core](https://www.xilinx.com/support/documentation-navigation/design-hubs/dh0003-vivado-designing-with-ip-hub.html)
