# TEC-1F Data Transfer Tool

This directory contains a C++ file the can transfer Binary or Intel HEX files to the TEC-1F.

It is to be compiled on your own computer.  I am not the best with compiling c++ programs but there is nothing complicated with this build.  A __Makefile__ is supplied but will probably only work on a Mac OSX.  Modify it to work your own OS.

## Usage
Firstly, the TEC is to be ready to receive the file.  Start your bit-bang / intel receiver program on the TEC.  If using BMon Use `Shift-0` on the TEC and select `SIO-in` or `Intel`.  Then...

In a command terminal type something like this:
```
$ bin2tec -f program.bin
        or
$ bin2tec -f program.hex
```
where `program.bin` is the file you would like to transfer.  The file can be a compiled Z80 binary or an ASCII Intel HEX file.

To change the serial port or baud rate either change the values in the c++ prior to compiling or on the command line as an argument.

```
$ bin2tec -h                     

Bin2TEC - Send a binary file to the TEC-1F

Usage : Bin2TEC [arguments]

Arguments:
   -f       Filename (mandatory)
   -p       Serial Port (default: /dev/tty.usbserial-A50285BI)
   -b       Baud Rate (default: 4800)

```

## Installation
If you would like to use this program from any directory on your computer.  Copy the executable to ` /usr/local/bin`.  This directory should be in your PATH.
