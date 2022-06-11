
# TEC Games

## General Setup
To be run on the TEC-1D with any Monitor.  For the keyboard to work it requires EITHER a 4k7 (or 2k2 or lower) resistor between the NMI (pin 17 on Z-80) and D6 (pin 10 on the Z-80) OR the DAT (LCD) expanstion board fitted to port 3.  The current TEC-1D boards have the JMON MOD resitor connection already there.

The 8x8 LED board is fitted to ports 5 and 6 with the port select strobe of the left hand latch going to port 6.

If using an LCD, it is to be connected as per the DAT board schematics.
 
All ROM files are to be loaded at address **0x0900**.  If this doesn't suit then just complie the **.Z80** file and change the starting **.ORG** address.  They can be manually typed using the **.lst** file but I recommend using a serial loader.  See my  [SIO Transfer](https://github.com/bchiha/TEC-1D-Stuff/tree/master/sio_transfer) project.

## TEC Invaders (The Return)
This is my version of the TEC invaders that was originally writen by __Cameron Sheppard__

### To Play
Use '1' to move Left, '9' to move right and '+' to shoot.  10 Points for hitting an invader and 50 Points for the UFO on the top row.  Player has 3 lives and the game is over when all lives are lost.  You lose a life if the invaders land or you get hit by one of their bombs.  Invaders come in waves and get faster with less invaders alive.

## TEC Maze Treasure Hunt
### To Play
The aim is to move around the maze, and pick up all glowing orbs. Once all are found, get back to your starting spot.  To move use the following keys

         6
     1 < X > 9
         4

Your character is a 1x1 Steady LED.  Orbs are flashing (glistening!) 1x1 LED's.  The Seven Segments display your current location (Address) and the number of treasures to collect (Data).  You must find all orbs to win.  Just move over the orb to pick it up but only when you can see it!

The Maze has a total of 64 rooms on an 8x8 grid.  Rooms are represented vertically with A-H and horizontally with 0-7.  Top left is 'A0'.  Orbs and initially player positions are randomly placed at the start of the game.  The number of orbs to find is random for each game.

## Game Of Life
Game of Life is a cellular automation simulation created by John Conway.  It uses the 8x8 LED Matrix.  Each cell evolves based on the number of cells that surround it.  The basic cell rules are:

 1. Any live cell with two or three live neighbours survives.
 2. Any dead cell with three live neighbours becomes a live cell.
 3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.

### To Play
Just run the program and watch.  Use the keyboard to either select a random starting cell position or pre-defined cells.  To start a new animation, press a key at anytime.  The keyboard options are:
|Key|Object|Key|Object|Key|Object|Key|Object|
|:--:|--|:--:|--|:--:|--|:--:|--|
| 0 | Random | 5 | Glider | A | R-pentomino | F | Fumarole |
| 1 | Blinkers | 6 | Why Not | B | Carnival | + | Phoenix |
| 2 | Toad | 7 | Boat | C | Arrow | - | Pacman |
| 3 | Beacon | 8 | Barbers Pole | D | Square | GO | Octagon |
| 4 | Pulsar | 9 | Drummer | E | Face | AD | Heart |

## Magic Square
This game written by Jim Robinson uses the 8x8 LED matrix.  The aim of the game is to create a Hollow Square.  It's been modified to be played on a ROM.
### To Play
There are 9 Keys that change parts of the square by inverting certain LED's.   The Keys are:

    6	A	E
    5	9	D
    4	8	C
   The final Hollow Square should look something like this

       * * *
       *   *
       * * *
   If you can find the Magic Square, press 'GO' to play again.

## Segment Game
This game  by Jim Robinson is a game of good timing and a quick reaction.
### To Play
The player is to press **any key** when a moving target is in the bottom segment on the 3rd LED segment from the right.  On each hit the moving segment restarts and moves faster.  When a sucessful hit occurs, the current hit count is displayed (modification by me).  Can you hit the target more than 30 times in a row??  If you miss one target, it's game over.

        A D D R E S S       D A T A
      --   --   --   --     --   --
     |  | |  | |  | |  |   |  | |  |
      --   --   --   --     --   --
     |  | |  | |  | |  |   |  | |  |
      --   --   --   --     --   --
                     ^^
                     ||
              This segment lit up

## SIMON
This is a game of "*Simple*" Simon. written by Jim Robertson.
### To Play
The 4 LED Segments from the right represent keys **0**,**4**,**8** and **C**.  The segments light up and the order they light up represents the keys to press.  An audible tone also represents a lit segment.   Once the keys are hit in the correct order, another segment is added to the sequence.  A score is shown on the total correct segments matched when the game is over.  
I have modified the game to auto populate random numbers at startup.

## Spiroid Aliens
A segment game written by M Allison.

I have optimised and fixed some of the code.

**Note:  Can only be used on MON1/1A/1B with the 4049 (approx. 500kHz) clock.**  Also must be put into RAM as code is self modifying!

### Notes from Issue #12
This is quite a long program and shows the length of listing required to achieve a degree of realism. The game uses all of page 0800 and portions of 0900, 0A00, 0B00 and 0D00.
The main program is at 0800 *(Should be called from 0803)* with calls at the other pages.  The game consists of unusual- shaped aliens passing across the display. Each game consists of 16 passes and you must shoot down the arrivals by pressing buttons 1, 2 or 3. To win you must shoot down at least 11.
In the initial stages of the game, you must acquaint yourself with the connection between the spiroid shapes and buttons 1, 2, 3. After this you will be ready to launch an attack.

**Side Note:** It's not a bad game but the code is a bit messy and uses probably too many registers than are needed.  It also directly calls the music features of MON1 which ties it to that Monitor only.
I had problems actually running this on my TEC as I had to change the clock from my Crystal 3.86Mhz to the original CD4049 **≈** 500kHz while the game was loaded in RAM.  This involved pulling out IC's while holding Reset down at the same time.  I also had to move it to RAM as the code is self modifying.  I can probably re-write this game to play on ROM and reduce the line count.  If you hit an Alien, it does have a cool success animation.

The easiest way to play this game is to create a HEX file (use https://www.asm80.com/) and play in the TEC Emulator (https://jhlagado.github.io/wicked-tec1/).


## TEC Runner
A game using a 2x16 Liquid Crystal Display (LCD) by Brian Chiha.  This is not an original game but is based off an Arduino game.

From what I know, this is the First LCD game published for the TEC.  

### Setup
This game uses an LCD works on JMON.  If using another Monitor, the JMON keyboard mod is required.  It is to be set up similar to the LCD that is on the DAT board.  In summary the connections from the TEC to the LCD are: D0-D7 -> D0-D2, A7 -> RS, Port 4 -> E (inverted), R/W -> R/W with RC circuit.  Please see TE Issue 15 for more details.  Code for the LCD is to be loaded at address **0xA00**.  This is due to how JMON uses the Soft Reset feature.  See Issue 15.

### To Play
Try to avoid obstacles by jumping over them as they get near.  Press the '**4**' button to jump.  You need to time the jump to make it over the obstacle.  The player automatically jumps off the obstacle.  Every time you jump, the speed of the game gets faster.  The counter records the distance travelled.

How far can you make it!.

**Note**: I've included a 512 byte version if you just want the game minus start screen.  *PS: The code includes a secret flag that does something special....*


## Dodgy
A game of skill, try to dodge past obsticles.  The Player is on the left hand side of the Seven Segments.  You are a '-' character.  Coming towards you are three types of obsticles.  You wil need to dodge them to survive.  Use the '7' key to move up and the '4' key to move down.  The longer you survive the faster the obsticles come.  When you die (you will die!), your distance travelled will be displayed.  Press 'GO' to start the dodgy game again!.
