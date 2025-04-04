# TEC-1G Software Collection

This is a detailed list of most of the publicly available software written for the TEC-1.

The following programs have been adapted for the TEC-1G.  Unless specified, code was written by Brian Chiha.

## Usage
Most of the files are in Intel HEX format.  When loaded via the **MON3** Intel HEX loader, the files will placed at  address `4000H`.  Any exceptions to this, are mentioned in the program details below

Binary files can be loaded using the Import Binary File menu routine.  A Start and end address is needed.  Each of these files have their file size displayed in their detail.

## Applications
### Tiny Basic
``TBASIC.HEX`` - Tiny Basic for the TEC-1G.

This is a TEC-1-specific version of Tiny Basic.  It requires a Serial Terminal connection to the FTDI.  Code and data entry are to be done through the serial terminal.

If Using ``Mon3 v1.5``  or greater and a Graphical LCD installed with full matrix keyboard.  "Toggle GLCD Term" can be selected from the Settings menu and Tiny Basic will work directly from the TEC, eliminating the serial connection.

See the latest ``Mon3 User Guide`` for more information.

### Terminal Monitor
``TMON.HEX`` - Terminal Monitor for the TEC-1G. Loads at address ``1000H``.  By Craig Hart.

A simple terminal based monitor program for the TEC-1G.  Uses the Serial Terminal connection to the FTDI.   

See the latest ``Mon3 User Guide`` for more information.

### MINT

``MINT.HEX`` - A stack-based Forth-like language specifically designed for the TEC-1 Z80 Computers.  Loads at address ``1000H``.  By Ken Boak, John Hardy and Craig Jones.

Uses the Serial Terminal connection to the FTDI.   

The MINT version included is v1.1.  There is extensive documentation on MINT on its own GitHub [(https://github.com/orgMINT)](https://github.com/orgMINT) page.

## 20x4 LCD and Seven Segment Games
### Game Collection
``GAMES.HEX`` - various games developed for the seven segment display and LCD screen.

Games can be selected via a menu.  The games are:
    
- **Segment Target Game**. By S Clarke. Moving segment winds around the display.  When it is at the fourth display segment from the left and the bottom segment is lit, Press any key.  If successful, a number will briefly be displayed showing the number of rounds passed...  Try to get to 50 rounds!
  
- **Simon**.  By J. Robertson.  This is a game of Simon Says.  The bottom of four segments will light up and make a tone.  The segments correspond to the keys 0,4,8 and C on the keypad.  Each round the sequence gets longer.  Try to make 7 rounds.  Press `GO` to play another game.
  
- **Dodgy**.  This game's mission is to avoid objects that are being fired at the player.  The player is on the left-most display segment as a single dash.  Use the `3` key to move down and the `7` key to move up.  If an object is struck, its game over and the distance traveled is displayed.
  
- **Spiroid Aliens**. By M Allison.  This is a full re-write of the Spiroid Aliens game published in TE Magazine issue 12.  Try to match the Alien character to a number 0,1,2 or 3 to destroy it.  At least 11 of the 16 Aliens must be destroyed to win.

- **NIM**. Classic match pick up game.  Start with 23 Matches.  Press either 1, 2 or 3 to pick the required number of matches.  The game alternates between the Player and the Computer.  The aim is not to pick up the last match.

- **Lunar Lander**.  Land the lander safely.  The Segments display the Amount of Fuel remaining on the Left and the Landers Altitude on the Right.  To burn fuel and slow the descent, press the `+` key.  The middle segments indicate how close the lunar surface is.

- **Master Mind**.  This is a classic game of Mastermind.  Except, instead of using colours, a series of four numbers is to be worked out.  Press any key to set the answer.  Next, enter 4 numbers between `0-9`.  When all four numbers have been entered, the computer will check these numbers against the correct sequence.  The right two segments will display the result.  The left-most digit is the number of correct numbers in the correct spot.  The right-most digit is the number of correct numbers but in the incorrect spot.

### Lunar Lander
``LANDER.HEX`` - Classic Lunar Lander game.  By Fred Nichols

Uses the LCD screen.  Instructions to play the game are given in the game.

### TEC Runner
``LCDRUN.HEX`` - Load running Jumping game.

The runner is on the left, coming towards the runner from the right are walls.  By pressing the `Plus` button, the runner will attempt to jump on a wall.  Timing is everything.  Every time the runner jumps, the game gets faster.  How far you can travel without loosing your head.

## Graphical LCD (GLCD) Programs
### Terminal Emulator
``GLCDTERM.HEX`` - Terminal Emulator for the GLCD.  Requires full matrix keyboard.  Type characters on the GLCD using the keyboard.  Use Arrows to scroll up to 10 lines.  Ctrl-A to turn cursor on, Ctrl-B to turn cursor off, Ctrl-C to toggle inverse text and Ctrl-D to Exit.

### GLCD Library demo programs.
``GLCD_PRG.HEX`` - Three great GLCD programs.
- ``2000H`` - Maze generation.  Watch as a little bot generates a maze using the recursive backtracking algorithm.
- ``3000H`` - 3D Rotation demo.  Select the model to rotate, and use keys 4,8,C to rotate along the (x,y,z) axis.  +/- to zoom and 0 to return.
- ``4000H`` - Line Drawing Alfred E. Neuman, Quick load at ``4022H``

### Frogger for the TEC

``FROGGER.HEX`` - Classic Frogger remake.

Instructions are within the game.  Can use HexPad, Matrix Keyboard or Joystick.

### Elementary Cellular Automation
``CELLULAR.HEX`` - One Dimensional array cell repetition.

Based a particular Bit rule, the cells neighbors are viewed and then determined if the cell exists or not in the next cycle.  Cycles are displayed downwards.

Use the Plus or Minus keys to cycle through the different rules.  Rule number is displayed on the seven segments.  Initial rule number can be set at address ``4001H``.

## 8x8 LED Matrix Games
### Conway's Game of Life
``GOL.HEX`` - Cellular Automata Game of Life.

This demonstrates Conways Game of Life on the 8x8.  19 Set patterns are provided and can be selected by pressing different keys on the keypad.  Key 0 will generated a random starting pattern.

### Space Invaders 1
``INVADER.HEX`` - Original TAPE game by Cameron Sheppard

Game published on issue 15 of the TE Magazine.  Follows the standard Space Invaders game.  Player is on the bottom row.  Group of 3x4 aliens hover above and can drop bombs.  Top row contains a flying saucer.

Use keys 4 and 6 to move left and right and Plus to shoot.  Score is displayed on the seven segments and number of lives left.

### Space Invaders 2
``INVADERS.HEX`` - My version of the game

I reversed engineered the Invaders game based off its documentation.  I did this because only recently the original game has been retrieved off the tape.  This is what I came up with.  It uses similar controls as the original.

### Maze Game 1
``MAZE.HEX`` - Original TAPE game by Cameron Sheppard.

Move around the maze using keys 1,6,4 and 9.  X and Y coordinates are shown on the seven segments.  To win reach to location `U-1`.

### Maze Game 2
``MAZEMAN.HEX`` - My version of the game

This was my interpretation of the Maze game.  Move your character around the maze, picking up glowing orbs.  Map coordinates and orbs left are shown on the seven segments.  To win pick up all orbs and return to the starting position.  Note: orbs flash on and off.

### Magic Square
``MAGICSQ.HEX`` - Create a magic square, by Jim Robertson.

Using the 8x8, create a hollow square.  Using keys 4,5,6,8,9,A,C,D and E, manipulate the lights.  The keys will flip multiple lights on and off at the same time.  Learn how the keys work to win the game.

### Snake
``SNAKE.HEX`` - Classic Snake game by Ben Grimmett

Move your snake and eat food.  Food makes you grow and don't run into yourself.  Use keys 0,2,5 and 1.

## Music Files
### TEC Music Demo
``TUNE_1.BIN``, ``TUNE_2.BIN``, ``TUNE_3.BIN``, ``TUNE_4.BIN``, ``TUNE_5.BIN`` - Tune data files

Load these files into any RAM location.  Then from the Main Menu, select 'Music Routine'.  Then enter the address that the file was loaded at.

### Banger
``BANGER.BIN`` - Techno beats

This small program (26 bytes) can make some impressing beats.

## Interactive Fiction

These are text adventure games that require the GLCD and the Matrix Keyboard.  All games load at ``2000H``.

### The Inform7 Games
- ``IF_CATS.HEX`` - Catseye
- ``IF_DT.HEX`` - Dragon and the Troll
- ``IF_WUMP.HEX`` - Hunt the Wumpus
- ``IF_AL1.HEX`` - Adventureland Disk 1 (Requires Expansion RAM with 32K RAM Memory).  Load into lower RAM memory. 
- ``IF_AL2.HEX`` - Adventureland Disk 2 (Requires Expansion RAM with 32K RAM Memory) **Must** be loaded to upper RAM.  Press ``Fn-E`` and load file.  Once loaded Press ``Fn-E`` to set RAM to lower memory.

## Other Programs
### Monitor 3 Code Examples
``MON3CODE.HEX`` - All example key in code found in the Monitor 3 User Guide.

Uses a menu to select the program.  AD key to exit.

### TEC Magazine Code
``TECMAG.HEX`` - Most example code from issues 10-15 of the Talking Electronics Magazine.  

Uses a menu to select the program.  Press `Fn-GO` to exit the program and return back to the menu.

### Fast Forward
``FASTFORW.HEX`` - A Code stepper by Jim Robertson

This program loads at ``1000H``.  When running, the program will step through addresses displaying the contents of the address.  It was used to hand write down code without pressing +/-.  Keys A-F change various speeds and directions and 0-9 continues at slow speed forward.  Change lines ``1001H-1002H`` to the first address you want displayed.  IE: `00, 40` will start at address `4000H`.



