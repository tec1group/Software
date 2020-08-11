
# TEC Magazine Master ROM
This ROM is a collection of almost all of the code written for the Talking Electronics Computer.  It is a good starting point to learn Z80 assembler on the TEC.  

Compiled by Brian Chiha July 2020
### To use
Requires JMON Monitor for the Menu Selection and to be placed at 0x1000 in RAM (Or anywhere else if you compile the z80 file yourself and change the ORG directive).  

Simply go to address 0x1000 and press 'GO'.  Then use '+' or '-' to select the program to run and hit 'GO'. 

For **8x8 LED** programs, connect the 8x8 to ports **05** and **06**. 

To exit the programs press '**Shift-GO**'.  This will exit the current program and go back to the main menu #neat!

The directory has individual z80 source code for you to use and experiment with on your TEC.

## ROM Contents:
| #|Address|Name|Reference |
| :--:|--|:--|--|
|1|0x100E|Segment Move|Issue 11 P 26
|2|0x101D|Segment Cycle|Issue 11 P 20
|3|0x102E |Segment Flash|Issue 11 P 28
|4|0x1044 |Segment Move Around #1|Issue 11 P 29
|5.|0x109C|Segment Move Around #2|Issue 12 P 16
|6|0x10D3 |Segment Move Around #3|Issue 12 P 17
|7|0x1100|Segment Back and Forth|Issue 11 P 28
|8|0x1120|Segment Keyboard Move|Issue 12 P 17
|9|0x113C|Segment Keyboard Move w Run|Issue 12 P 18
|10|0x1161|Display two Segments at Once|Issue 12 P 18
|11|0x11B4|The Box Animation|Issue 14 P 14
|12|0x125C |Aussie Boomerang|Issue 14 P 14
|13|0x1297|8x8 LED Around|Issue 11 P 33
|14|0x12E9|8x8 LED Back and Forth|Issue 11 P 33
|15|0x1311|8x8 LED Fan Out #1|Issue 11 P 34
|16|0x1323 |8x8 LED Fan Out #2|Issue 12 P 26
|17|0x1345|8x8 LED Fan Out #3|Issue 14 P 15
|18|0x1366|8x8 LED Mystery Effect|Issue 11 P 34
|19.|0x13B3|8x8 LED Key Movement|Issue 11 P 36
|20|0x13E6|8x8 LED Ball Bounce|Issue 12 P 26
|21|0x1416|8x8 Animation Example|My variation    
|22|0x145F|Aliens Attack|Issue 11 P 36
|23|0x1497|Speaker Oscillator|Issue 12 P 22 
|24.|0x14AD|Frequency Sweep|Issue 12 P 22
|25|0x14D9|Space Invaders Sound|Issue 14 P 14
|26|0x1503 |Quick Draw|Issue 12 P 21
|27|0x152E|TEC Clock|Issue 12 P 23
|28|0x15C4|Counter #1|Issue 13 P 14
|29|0x15DD|Counter #2|Issue 13 P 15
|30|0x161A|Counter #3|Issue 13 P 16