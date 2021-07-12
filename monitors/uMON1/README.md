# uMON1
Micro Monitor 1 (uMON1) V1.03 for the Talking Electronics TEC-1 SBC.
By Scott Gregory

uMON1 Special Keys
------------------
SHIFT-+ - Insert a byte at the current address.
SHIFT-- - Delete a byte at the current address.

uMON1 Default Configurables
---------------------------
STACKTOP = $08C0 - Stack position.
 ROMBASE = $0000 - Start of ROM.
  ROMTOP = $07FF - End of ROM.
 RAMBASE = $0900 - Start of user RAM.
  RAMTOP = $FFFF - End of user RAM.
 CATHDLY = $20 - Digit display delay.
 KEYPORT = $00 - Keypad port.
CATHPORT = $01 - Display catchode port.
 SEGPORT = $02 - Display segment port.

General Operation
-----------------
Data entry or Address entry mode is signified by dots under the Data display
or Address display.  The AD key toggles between modes.
The data mode has automatic address advance.  On the 3rd digit key pressed,
the address will advance and the first nibble entered into the new location.
Eg. the following key press sequence displays the following:

KEY		TEC
PRESS	DISPLAY
		0900 FF
9		0900 09
6		0900 96
3		0901 03
2		0901 32
1		0902 01
8		0903 18

Module Description and Setup
----------------------------

RAMTest Module Setup (MOD-01)
--------------------
Enter the test parameters into the following addresses:
	$08F0 - Start address LSB.
	$08F1 - Start address MSB.
	$08F2 - End address LSB.
	$08F3 - End address MSB.
	$08F4 - Not used.
	$08F5 - Test byte.

Running The Test
----------------
Enter:
	SHIFT-0

Results
-------
The ammount of error bytes found will be stored as a 16 bit number in:
	$08F0 - Error count result LSB.
	$08F1 - Error count result MSB.

Example
-------
Enter:
	RESET
	AD
	08F0
	00+00+FF+07+00+10
	SHIFT-0

The results are stored as:
	$08F0 = E6
	$08F1 = 07
		  = 07E6 errors found
		  = 2022 errors found

... because this is the TEC-1 ROM location.


Serial Modules Setup
--------------------
The Serial Modules are deigned to work with a serial board that was designed
by Ben Grimmett and with custom CPLD firmware written by me.  It would be
easy enough to adapt the modules to your serial setup.  Instructions on doing
so is outside the scope of this readme.

Common Serial Module Setup
--------------------------
Enter the test parameters into the following addresses:
	$08F6 - Block Start address LSB.
	$08F7 - Block Start address MSB.
	$08F8 - Block End address LSB.
	$08F9 - Block End address MSB.

Serial Send (MOD-02)
-----------
Enter:
	SHIFT-1

With the common Block Start and End addresses set, use the above key sequence
to start sending the block.  The TEC-1 will resume from where it left off
after sending all the data in the selected block.

Serial Receive (MOD-03)
--------------
Enter:
	SHIFT-2

With the common Block Start and End addresses set, use the above key sequence
to start receiving data to the set block.  The TEC-1 will resume from where it
left off after receiving all the data to the selected block.

Serial Loopback Test (MOD-10)
--------------------
Enter:
	SHIFT-F

This module require no setup.  All it does is send back out any data received
over serial.  Reset the TEC-1 to exit the test.
