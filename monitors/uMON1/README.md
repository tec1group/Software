# uMON1
Micro Monitor 1 (uMON1) V1.10 for the Talking Electronics TEC-1 SBC.
By Scott Gregory

======================================
Base uMON1 configuration and operation
======================================

uMON1 Special Keys
------------------
SHIFT-+  - Insert a byte at the current address.
           Everything from the current location to RAMTOP is moved up one
           byte.  The byte originally located at RAMTOP is lost. $00 is
           inserted at the current location.
SHIFT--  - Remove a byte at the current address.
           Everything from the current location to RAMTOP is moved down one
           byte.  The byte originally located at the current location is lost.
           $00 is inserted at RAMTOP.
SHIFT-GO - Jump to and start executing code at the location of the address
           which is stored in SHIFTGO.  The default address is the Random
           Number generator.  Record the address stored in SHIFTGO if you
           wish to use the Random Number generator in your own routines.
           The value here is restored to the random number generator on Power-On
           or Reset, unless it is changed in the code.

uMON1 Default Configurable Values
---------------------------------
STACKTOP = $08C0 - Stack position.
 ROMBASE = $0000 - Start of ROM.
  ROMTOP = $07FF - End of ROM.
 RAMBASE = $0900 - Start of user RAM and monitor start location.
  RAMTOP = $FFFF - End of user RAM.
 CATHDLY = $40 - LED Digit display time.
 KEYPORT = $00 - Keypad keyscan port.
CATHPORT = $01 - Display cathode select port.
 SEGPORT = $02 - Display segment select port.
 
 uMON1 Default Working Store Locations
 -------------------------------------
   ADDRESS = $08C0 - 2 Bytes - Current monitor address.
   SCRATCH = $08C2 - 3 Bytes - Display scratchpad space.
      MODE = $08C5 - 1 Byte - Mode flags.
   KEYDATA = $08C6 - 1 Byte - Current keyscan data store. $FF = No key scanned.
BEEPLENGTH = $08C7 - 2 Bytes - Next beep length store.
  BEEPFREQ = $08C9 - 1 Byte - Next beep frequency store.
  RNDSEEDA = $08CA - 2 Bytes - Random Seed A.
  RNDSEEDB = $08CC - 2 Bytes - Random Seed B.
    RANDOM = $08CE - 2 Bytes - Generated random number.
  GENERALA = $08D0 - 2 Bytes - General use Address / Data address A.
  GENERALB = $08D2 - 2 Bytes - General use Address / Data address B.
  GENERALC = $08D4 - 2 Bytes - General use Address / Data address C.
  GENERALD = $08D6 - 2 Bytes - General use Address / Data address D.
   SHIFTGO = $08D8 - 2 Bytes - Shift-GO destination address.

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

Pressing AD, + or - at any stage will reset the auto advance function to first
nibble entry.

Pressing the GO key (or SHIFT-GO) will execute user entered code based at
either the location displayed or the location stored in SHIFTGO.
The following will work provided that the executed code hasn't destroyed any
of the store locations (Stack, ADDRESS etc.).  If the executed code has a
return instruction (RET) at the end, then the monitor will return to where
the address location where the GO key was originally pressed.
If there is any HALT instructions in the executed code, this will behave as a
"Press any key (Except RESET or SHIFT) to continue." function.  Execution will
continue with the code after the HALT.

There is a random number generator included.  The call address is stored in
SHIFTGO by default.  Make note of this for later use if you use SHIFTGO for
something else.  RNDSEEDA and RNDSEEDB contain the random number seeds which are
continuously updated as the TEC runs.  These are restored to their defaults at
Power-On or Reset.

========================================================
Adding Modules And How To Configure uMON1 For Module Use
========================================================

How Add Modules To uMON1
------------------------
Module numbers can range from 00 to 0F which corresponds to the number key to
be pressed to activate it.  You can add more modules than this, but they would
need to be added manually at the bottom of uMON1.asm by adding a new section
to the include table.  These won't be able to be accessed by key functions.
Doing this is beyond the scope of this readme and is for the experienced coder.

In uMON1.asm, in the section:

    ; Begin included modules.
    ; #DEFINE INCLUDE_MODXX
    ; End included modules.

Add one or more lines, in the following manner, to have the module included at
compile time:

    ; Begin included modules.
    ; #DEFINE INCLUDE_MODXX
    #DEFINE INCLUDE_MODULE01
    #DEFINE INCLUDE_MODULE04
    ; End included modules.

This will include Modules 01 and 04.

The modules themselves are located in the Modules subfolder.
This included, but not activated by default, modules are:
    MOD00 - RAMTest (Shift-0)
    MOD01 - Serial Send (Shift-1)
    MOD02 - Serial Receive (Shift-2)
    MOD03 - Memory Copy (Shift-3)
    MOD0F - Serial Loopback (Shift-F)

There is also a uMON1 version supplied that has all modules activated.

There is a template in the modules folder that can be used to help create
your own modules.  The sections in the module are (Changing MODXX in all cases
to your own module name and/or number) MODXX_GLOBALS for global includes that
may be used by multiple modules.  MODXX_ASSIGNMENTS for includes for this module
only.  MODXX_CODE where the module code itself goes.  Use the included modules
and the template as a guide to set up your own modules.


===================================
Included Module Setup And Operation
===================================

======================
RAMTest Module - MOD00
======================
Setup
-----
Module Include: #DEFINE INCLUDE_MODULE00

Enter the test parameters into the following addresses:
	GENERALA - Start address.
	GENERALB - End address.
	GENERALC - The LSB is the test byte to be used.
               The MSB (GENERALC+1) is not used.

Running The Test
----------------
Key: SHIFT-0

Results
-------
The count of non-matching bytes found will be stored as a 16 bit number in
GENERALD.  No check is made to see if the end address is less than the start
address.  If the end address is less than the start, the test will wrap around
the memory. Eg. Start = 0900, end = 08FF.  This is 0900-08FF or 64K!!!  It has
exactly the same effect as saying 0000-FFFF.  The difference being that it
starts the fill and test from 0900 instead of 0000.  Memory location FFFF plus
1 is 0000.

Example
-------
Enter:
	RESET
	AD
	0 8 D 0   <--- GENERALA's location.
	AD
	1 0 0 0 F F 1 7 0 0  <--- Fills GENERALA, GENERALB, and GENERALC.
	SHIFT-0

The results are stored as:
	GENERALC   = E6
	GENERALC+1 = 07
		  = 07E6 errors found (HEX)
		  = 2022 errors found (DEC)

... oops, we must have a really faulty RAM chip in the TEC expansion socket.
The usual procedure would be to run one or more tests with different test bytes
To see if bits are stuck at 1's or 0's or both.

================================
Memory Block Copy Module - MOD03
================================
Setup
-----
Module Include: #DEFINE INCLUDE_MODULE03

Enter the required parameters into the following addresses:
	GENERALA - Source address.
	GENERALB - Destination address.
	GENERALC - Block size.

Running The Copy
----------------
Key: SHIFT-3

This will copy a RAM/ROM block of a give size from the source address to the
destination address.  Be careful that the source block isn't overlapped by the
destination block.

====================================
Serial Modules - MOD01, MOD02, MOD0F
====================================
The Serial Modules are deigned to work with a serial board that was designed
by Ben Grimmett and with custom CPLD firmware written by me.  It would be
easy enough to adapt the modules to your own serial board setup.  Instructions
on doing so are outside the scope of this readme.

Common Serial Module Setup
--------------------------
Module Include: #DEFINE INCLUDE_MODULE01
Module Include: #DEFINE INCLUDE_MODULE02
Module Include: #DEFINE INCLUDE_MODULE0F

Enter the test parameters into the following addresses (Except for MOD0F):
	GENERALA - Block Start address.
	GENERALB - Block End address or Block Size.
	GENERALC - GENERALB type flag.

If GENERALC = $00 then GENERALB is the Block End address.
If GENERALC is anything other than $00 then GENERALB is the Block Size.

Serial Send - MOD01
-----------
Key: SHIFT-1

With the Block Start and End / Size set, use the above key sequence
to start sending the block.  The TEC-1 will resume from where it left off
after sending all the data in the selected block.

Serial Receive - MOD02
--------------
Key: SHIFT-2

ith the Block Start and End / Size set, use the above key sequence
to start receiving data to the set block.  The TEC-1 will resume from where it
left off after receiving all the data to the selected block.

Serial Loopback Test - MOD0F
--------------------
Key: SHIFT-F

This module require no setup.  All it does is send back out any data received
over the serial port.  Press any key, other than shift, on the TEC or Reset the TEC to exit the test.
