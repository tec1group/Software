;-------------------
; CMON - CRAIG'S MON
;-------------------
;
; A CUT DOWN VERSION OF THE SOUTHERN CROSS MONITOR TO FIT 
; IN THE 2K EPROM OF THE UNMODIFIED TALKING ELECTRONICS TEC-1
;
; WRITTEN BY CRAIG R. S. JONES
; MELBOURNE, AUSTRALIA.
;
; VERSION : 1
;
; THE EMPHASIS HERE IS TO GET A SERIAL PORT GOING ON THE TEC-1 TO ALLOW FOR INTEL HEX DOWNLOAD
; VIA THE BIT BANGED SERIAL.
; IF A DAT BOARD OR 74HC74 IS WIRED IN FOR SINGLE STEPPING THE MONITOR 
; WILL PROVIDE SIMILAR REGISTER VIEWING TO JMON.
; THE SOUTHERN CROSS USER MANUAL PROVIDES FURTHER INFORMATION.
;
; YOU NEED:
; A CRYSTAL OSCILLATOR - THE BAUD RATE CONSTANTS FOR THE BIT BANGED SERIAL ARE
; SET-UP FOR A 4MHZ OSCILLATOR.
; A TRI-STATE BUFFER WIRED INTO BIT 7 OF THE KEYBOARD PORT FOR SERIAL INPUT
;
; SERIAL CONNECTIONS:
; BIT 7 OF THE KEYBOARD PORT IS THE SERIAL INPUT
; BIT 6 OF THE DISPLAY SCAN LATCH IS THE SERIAL OUTPUT
;
; IF TEC-1 IS DEFINED:
;
; USE THE TEC I/O PORTS
; MOVES THE RAM LOCATIONS TO TOP OF 2K RAM @ 0800H-0FFFH
; CHANGES THE 7 SEGMENT DISPLAY CODES
; CHANGES THE ORDER AND FUNCTION OF THE ADDITIONAL KEYS
; USES BIT 6 OF THE KEYBOARD PORT FOR THE DA CONNECTION TO THE 74C923
; COMPLETELY IGNORES THE SHIFT BUTTON
;
#DEFINE TEC-1   ;RUNNING ON A TEC-1

#IFDEF TEC-1 
; IF YOUR HARDWARE INVERTS DA FROM THE KEYBOARD ENCODER            
#DEFINE DA_ACTIVE_LOW 
#ENDIF
;-----------------
; SYSTEM VARIABLES
;-----------------
;
; RAM AND SYSTEM POINTER
;
#IFDEF TEC-1
RAMSRT      EQU 0800H           ;START OF USER RAM
RAMEND      EQU 0FFFH           ;END OF USER RAM
SYSTEM      EQU 0F00H           ;SYSTEM POINTER
#ELSE
RAMSRT      EQU 2000H           ;START OF USER RAM
RAMEND      EQU 3BFFH           ;END OF USER RAM
SYSTEM      EQU 3F00H           ;SYSTEM POINTER
#ENDIF
;
; BAUD RATE CONSTANTS
;
B300        EQU 0220H           ;300 BAUD
B1200       EQU 0080H           ;1200 BAUD
B2400       EQU 003FH           ;2400 BAUD
B4800       EQU 001BH           ;4800 BAUD
B9600       EQU 000BH           ;9600 BAUD
;
; I/O PORT ADDRESS
;
#IFDEF TEC-1
KEYBUF      EQU 00H             ;MM74C923N KEYBOARD ENCODER
SCAN        EQU 01H             ;DISPLAY SCAN LATCH
DISPLY      EQU 02H             ;DISPLAY LATCH
IO7         EQU 07H             ;ENABLE/DISABLE SINGLE STEPPER (IF INSTALLED)
#ELSE
IO0         EQU 80H             ;IO PORT 0
IO1         EQU 81H             ;IO PORT 1
IO2         EQU 82H             ;IO PORT 2
IO3         EQU 83H             ;IO PORT 3
DISPLY      EQU 84H             ;DISPLAY LATCH
SCAN        EQU 85H             ;DISPLAY SCAN LATCH
KEYBUF      EQU 86H             ;KEYBOARD BUFFER
IO7         EQU 87H             ;ENABLE/DISABLE SINGLE STEPPER (IF INSTALLED)
#ENDIF
;-------------------------
; MONITOR GLOBAL VARIABLES
;-------------------------
#IFDEF TEC-1
FUNTBL      EQU 0FB4H           ;FN TABLE ADDRESS
#ELSE
FUNTBL      EQU 3FB4H           ;FN TABLE ADDRESS
#ENDIF
;
; DALLAS SMARTWATCH REGISTERS
;
;CALMDE      EQU 3FB6H           ;CALENDAR MODE
;SWREG0      EQU 3FB8H           ;10THS, 100THS
;SWREG1      EQU 3FB9H           ;SECONDS
;SWREG2      EQU 3FBAH           ;MINUTES
;SWREG3      EQU 3FBBH           ;HOURS
;SWREG4      EQU 3FBCH           ;DAY
;SWREG5      EQU 3FBDH           ;DATE
;SWREG6      EQU 3FBEH           ;MONTH
;SWREG7      EQU 3FBFH           ;YEAR
;
;CALMDE      EQU 0FB6H           ;CALENDAR MODE
;SWREG0      EQU 0FB8H           ;10THS, 100THS
;SWREG1      EQU 0FB9H           ;SECONDS
;SWREG2      EQU 0FBAH           ;MINUTES
;SWREG3      EQU 0FBBH           ;HOURS
;SWREG4      EQU 0FBCH           ;DAY
;SWREG5      EQU 0FBDH           ;DATE
;SWREG6      EQU 0FBEH           ;MONTH
;SWREG7      EQU 0FBFH           ;YEAR
;

#IFDEF TEC-1
BAUD        EQU 0FC0H           ;BAUD RATE
KEYTIM      EQU 0FC2H           ;BEEP DELAY
SPTEMP      EQU 0FC4H           ;TEMP SYSTEM CALL SP
#ELSE
BAUD        EQU 3FC0H           ;BAUD RATE
KEYTIM      EQU 3FC2H           ;BEEP DELAY
SPTEMP      EQU 3FC4H           ;TEMP SYSTEM CALL SP
#ENDIF
;
; BLOCK FUNCTIONS
;
;COUNT       EQU 3FC6H           ;NUMBER OF BYTES TO MOVE
;BLKSRT      EQU 3FC8H           ;BLOCK START ADDRESS
;BLKEND      EQU 3FCAH           ;BLOCK END ADDRESS
;BLKDST      EQU 3FCCH           ;DESTINATION ADDRESS
;COUNT       EQU 0FC6H           ;NUMBER OF BYTES TO MOVE
;BLKSRT      EQU 0FC8H           ;BLOCK START ADDRESS
;BLKEND      EQU 0FCAH           ;BLOCK END ADDRESS
;BLKDST      EQU 0FCCH           ;DESTINATION ADDRESS
;
;FUNJMP      EQU 3FCEH           ;FN FN KEY JUMP ADDRESS
;FUNJMP      EQU 0FCEH           ;FN FN KEY JUMP ADDRESS
;
; DISPLAY SCAN REGISTERS
;
#IFDEF TEC-1
DISBUF      EQU 0FD0H           ;DISPLAY BUFFER
ONTIM       EQU 0FD6H           ;DISPLAY SCAN ON TIME
OFTIM       EQU 0FD7H           ;DISPLAY SCAN OFF TIME
#ELSE
DISBUF      EQU 3FD0H           ;DISPLAY BUFFER
ONTIM       EQU 3FD6H           ;DISPLAY SCAN ON TIME
OFTIM       EQU 3FD7H           ;DISPLAY SCAN OFF TIME
#ENDIF
;
; MONITOR VARIABLES
;
#IFDEF TEC-1
MODE        EQU 0FD8H           ;DISPLAY MODE
ADRESS      EQU 0FDAH           ;USER ADDRESS
KEYDEL      EQU 0FDCH           ;KEYPRESS AUTO INC/DEC DELAY
#ELSE
MODE        EQU 3FD8H           ;DISPLAY MODE
ADRESS      EQU 3FDAH           ;USER ADDRESS
KEYDEL      EQU 3FDCH           ;KEYPRESS AUTO INC/DEC DELAY
#ENDIF
;
; TEMPORARY REGISTER STORAGE
;
#IFDEF TEC-1
REGPNT      EQU 0FDEH           ;REGISTER POINTER
PC_REG      EQU 0FE0H           ;PROGRAM COUNTER
AF_REG      EQU 0FE2H           ;ACCUMULATOR,FLAG
BC_REG      EQU 0FE4H           ;BC REGISTER PAIR
DE_REG      EQU 0FE6H           ;DE REGISTER PAIR
HL_REG      EQU 0FE8H           ;HL REGISTER PAIR
IX_REG      EQU 0FEAH           ;INDEX REGISTER X
IY_REG      EQU 0FECH           ;INDEX REGISTER Y
SP_REG      EQU 0FEEH           ;STACK POINTER
#ELSE
REGPNT	EQU	    3FDEH	        ;REGISTER POINTER
PC_REG	EQU	    3FE0H	        ;PROGRAM COUNTER
AF_REG	EQU	    3FE2H	        ;ACCUMULATOR,FLAG
BC_REG	EQU	    3FE4H           ;BC REGISTER PAIR
DE_REG	EQU	    3FE6H           ;DE REGISTER PAIR
HL_REG	EQU	    3FE8H           ;HL REGISTER PAIR
IX_REG	EQU	    3FEAH           ;INDEX REGISTER X
IY_REG	EQU	    3FECH           ;INDEX REGISTER Y
SP_REG	EQU	    3FEEH           ;STACK POINTER
#ENDIF
;
; RESTART JUMP TABLE AND HARWARE TEST
;
#IFDEF TEC-1
RST08       EQU 0FF0H           ;RESTART 08H JUMP
RST10       EQU 0FF2H           ;RESTART 10H JUMP
RST18       EQU 0FF4H           ;RESTART 18H JUMP
RST20       EQU 0FF6H           ;RESTART 20H JUMP
RST28       EQU 0FF8H           ;RESTART 28H JUMP
RST38       EQU 0FFAH           ;INT INTERRUPT JUMP
RST66       EQU 0FFCH           ;NMI INTERRUPT JUMP
RAMSUM      EQU 0FFEH           ;USER RAM CHECKSUM
DALLAS      EQU 0FFFH           ;RAM TEST LOCATION
#ELSE
RST08       EQU 3FF0H           ;RESTART 08H JUMP
RST10       EQU 3FF2H           ;RESTART 10H JUMP
RST18       EQU 3FF4H           ;RESTART 18H JUMP
RST20       EQU 3FF6H           ;RESTART 20H JUMP
RST28       EQU 3FF8H           ;RESTART 28H JUMP
RST38       EQU 3FFAH           ;INT INTERRUPT JUMP
RST66       EQU 3FFCH           ;NMI INTERRUPT JUMP
RAMSUM      EQU 3FFEH           ;USER RAM CHECKSUM
DALLAS      EQU 3FFFH           ;RAM TEST LOCATION
#ENDIF
;----------------
; RESTART VECTORS
;----------------
;
;  RESTART 00H - RST 0
;WHEN POWER IS APPLIED TO THE SOUTHERN CROSS
;THE Z80 STARTS EXECUTING INSTRUCTIONS FROM HERE
;
            ORG 0000H
RSTVEC      JP RESET
;
; RESTART 08H - RST 1
;
            ORG 0008H
            PUSH HL
            LD HL,(RST08)
            JP (HL)
;
; RESTART 10H - RST 2
;
            ORG 0010H
            PUSH HL
            LD HL,(RST10)
            JP (HL)
;
; RESTART 18H - RST 3
;
            ORG 0018H
            PUSH HL
            LD HL,(RST18)
            JP (HL)
;
; RESTART 20H - RST 4
;
            ORG 0020H
            PUSH HL
            LD HL,(RST20)
            JP (HL)
;
; RESTART 28H - RST 5
;
            ORG 0028H
            PUSH HL
            LD HL,(RST28)
            JP (HL)
;
; RESTART 30H - RST 6 - MONITOR ROUTINES ENTRY POINT
;
            ORG 0030H
RST30       JP SYSCALL
;
; RESTART 38H - RST 7     BREAKPOINT HANDLER
;IF INTERRUPTS ARE ENABLED,AND AN
;INT OCCURS- FURTHER INTERRUPTS
;ARE DISABLED, THE PROGRAM COUNTER
;IS PUSHED ONTO THE STACK, AND EXECUTION
;STARTS HERE
;
            ORG 0038H
            PUSH HL
            LD HL,(RST38)
            JP (HL)
;
; RESTART 66H NMI VECTOR
; SAME AS ABOVE BUT NMI CANNOT BE DISABLED.
;
            ORG 0066H
            PUSH HL
            LD HL,(RST66)
            JP (HL)
                     
IGNORE      POP HL            ;DON'T FORGET TO DO THIS, DUMMY!
                              ;OTHERWISE THE WRONG RETURN ADDRESS WILL BE ON THE STACK.
            RETN
;--------------------
; SYSTEM CALL HANDLER
;--------------------
;CALLS TO BASIC I/O AND OTHER ROUTINES
;WITHIN THE MONITOR HAVE BEEN ASSIGNED
;SYSTEM CALL NUMBERS TO AVOID RE-WRITING
;USER SOFTWARE IF MONITOR ABSOLUTE ADDRESSES
;CHANGE IN SUBSEQUENT MONITORS
;
;ENTRY : C = CALL NUMBER
;SEE ROUTINES FOR ENTRY AND EXIT
;PARAMETERS
;
SYSCALL     DEC SP
            DEC SP              ;LEAVE SPACE FOR SYSCALL
            LD (SPTEMP),SP      ;POINTS TO SYSCALL LO
            PUSH AF
            PUSH DE
            PUSH HL             ;SAVE REGISTERS
            LD A,C              ;GET CALL NUMBER
            AND 127             ;ENSURE IN LIMITS
            SLA A               ;MULTIPLY BY TWO
            LD H,1              ;LOAD JUMP TABLE HIGH BYTE
            LD L,A              ;LOAD INDEX
            LD A,(HL)
            INC HL
            LD D,(HL)           ;GET JUMP ADDRESS
            LD HL,(SPTEMP)      ;POINT TO SYSCALL LO
            LD (HL),A           ;PUT SYSCALL LO ON STACK
            INC HL
            LD A,D
            LD (HL),A           ;PUT SYSCALL HI ON STACK
            POP HL
            POP DE
            POP AF              ;RESTORE REGISTERS
            RET                 ;JUMPS TO SYSTEM CALL
;-----------------------
; SYSTEM CALL JUMP TABLE
;-----------------------
            ORG 0100H
SYSJMP      .DW MAIN,VERS
            .DW DISADD,DISBYT,CLRBUF,SCAND
            .DW CONBYT,CONVHI,CONVLO
            .DW SKEYIN,SKEYRL,KEYIN,KEYREL
            .DW MENU,CHKSUM
;            .DW MUL16
            .DW MAIN
;            .DW RAND
            .DW MAIN
            .DW INDEXB,INDEXW
;            .DW MUSIC
            .DW MAIN
            .DW TONE,BEEP
;            .DW SKATE
            .DW MAIN
            .DW TXDATA,RXDATA,ASCHEX
;            .DW WWATCH
            .DW MAIN
;            .DW RWATCH
            .DW MAIN 
;            .DW ONESEC
            .DW MAIN
;            .DW RLSTEP
            .DW MAIN
            .DW DELONE
            .DW SPLIT
;------------------------------
; POWER UP RESET / MANUAL RESET
;------------------------------
            ORG 0200H
;
; WAIT FOR SMART SOCKET
; TO RECOVER FROM POWER DOWN
;
RESET       LD A,55H
            LD (DALLAS),A       ;WRITE TO RAM
            XOR A
            OUT (DISPLY),A      ;WRITE NOTHING TO
            OUT (SCAN),A        ;ON BOARD I/O
            IN A,(KEYBUF)       ;TO HELP DEBUGGING
            LD A,(DALLAS)       ;READ FROM RAM
            CP 55H              ;IS IT READY?
            JP NZ,RESET         ;KEEP TRYING
;
; LOAD STACK POINTER
;
RESET1      LD SP,SYSTEM
;
; SET UP RESTART VECTORS
;
            LD HL,RESET1
            LD (RST08),HL
            LD (RST10),HL
            LD (RST18),HL
            LD (RST20),HL
            LD (RST28),HL
            LD HL,IGNORE
            LD (RST66),HL       ;NMI INTERRUPT
            LD HL,SSTEP
            LD (RST38),HL       ;SINGLE STEPPER
;
; SET INTERRUPT MODE 1 - USE THE AUTOMATED INTERRUPT
;
            IM 1
            EI                  ;ENABLE INTERRUPTS
;
; PERFORM CHECKSUM ON USER RAM
;
            LD HL,RAMSRT        ;START OF USER RAM
            LD DE,RAMEND        ;END OF USER RAM
            CALL CHKSUM
            LD (RAMSUM),A       ;RAM CHECKSUM
;
; SET UP DEFAULT VARIABLES
;
            LD HL,FUNLST
            LD (FUNTBL),HL      ;FUNCTION KEY TABLE
            LD HL,CANCEL
;            LD (FUNJMP),HL      ;FN FN JUMP
            LD A,00H
            LD (REGPNT),A       ;INIT SINGLE STEPPER
            LD HL,B4800
            LD (BAUD),HL        ;DEFAULT SERIAL=4800 BAUD
            LD HL,0200H
            LD (KEYDEL),HL      ;INSTEAD OF BEEP DELAY IN AUTO INC/DEC
            LD A,07H
            LD (ONTIM),A        ;DISPLAY ON TIME
            LD A,0AH
            LD (OFTIM),A        ;DISPLAY OFF TIME
            CALL BEEP
            CALL BEEP
;-----------------
; SET UP MAIN LOOP
;-----------------
MAIN        LD SP,SYSTEM        ;SET STACK
            LD HL,RAMSRT
            LD (ADRESS),HL      ;DEFAULT ADDRESS
            LD A,(MODE)
            OR 80H              ;START OFF IN DATA MODE
            LD (MODE),A
;
; SCAN THE DISPLAYS UNTIL A KEY IS PRESSED
;
MAIN1       CALL UPDATE
MAIN2       CALL SKEYIN         ;WAIT FOR A KEY
            LD HL,MENLST        ;USE THE MENU HANDLER
            CALL MENU           ;ROUTINE FOR EACH KEY
            CALL UPDATE         ;UPDATE BUFFER AND
            CALL SKEYRL         ;WAIT FOR KEY RELEASE
            JP MAIN2
;
; MAIN MENU KEY TABLE
;
MENLST      .DB 20
            .DB 00H,01H,02H,03H,04H,05H,06H,07H
            .DB 08H,09H,0AH,0BH,0CH,0DH,0EH,0FH
            .DB 10H,11H,12H,13H
            .DW HEXKEY,HEXKEY,HEXKEY,HEXKEY
            .DW HEXKEY,HEXKEY,HEXKEY,HEXKEY
            .DW HEXKEY,HEXKEY,HEXKEY,HEXKEY
            .DW HEXKEY,HEXKEY,HEXKEY,HEXKEY
#IFDEF TEC-1           
            .DW INCKEY,DECKEY,FUNKEY,ADDKEY    ;TEC KEYS    +  -  GO  AD        
#ELSE                   
            .DW FUNKEY,ADDKEY,INCKEY,DECKEY    ;SC-1 KEYS  FN  AD  +  -
#ENDIF
;---------------------------------------------------
; ENTER HEX KEY AS LEAST SIGNIFICANT ADDRESS OR DATA
;---------------------------------------------------
HEXKEY      CALL BEEP
            LD HL,MODE
            BIT 7,(HL)          ;ADDR OR DATA MODE?
            JP Z,HEXKY2         ;IN ADDR MODE
;
; IN DATA MODE
;
HEXKY1      LD HL,(ADRESS)
            SLA (HL)            ;FROM THE CURRENT
            SLA (HL)            ;ADDRESS,MOVE THE
            SLA (HL)            ;LSN TO THE MSN.
            SLA (HL)            ;PUT THE KEY IN
            OR (HL)             ;THE NEW DATA BACK AT
            LD (HL),A           ;THE CURRENT ADDRESS.
            RET
;
; IN ADDRESS MODE
;
HEXKY2      LD HL,(ADRESS)
            SLA L               ;CURRENT ADDRESS
            RL H                ;AND DO A 16 BIT
            SLA L               ;LEFT SHIFT 4 TIMES
            RL H                ;TO MAKE  ROOM
            SLA L               ;FOR THE NEW KEY
            RL H
            SLA L
            RL H
            OR L                ;IT IN THE LEAST
            LD L,A              ;SIGNIFICANT NYBBLE
            LD (ADRESS),HL      ;SAVE CURRENT ADDRESS
            RET
;-------------
; CHANGE MODES
;-------------
ADDKEY      CALL BEEP
            LD A,(MODE)
            XOR 80H             ;TOGGLE MODE
            LD (MODE),A
            RET
;------------------
; INCREMENT ADDRESS
;------------------
INCKEY      CALL BEEP
INCKY1      LD HL,(ADRESS)
            INC HL              ;INC ADDRESS
            LD (ADRESS),HL
            CALL UPDATE
            LD HL,(KEYDEL)      ;AUTO REPEAT DELAY
INCKY2      CALL SCAND
            IN A,(KEYBUF)
#IFDEF  TEC-1
            BIT 6,A
#ELSE
            BIT 5,A
#ENDIF                
#IFDEF DA_ACTIVE_LOW
            JR NZ,INCKY3        ;KEY RELEASED
#ELSE
            JR Z,INCKY3         ;KEY RELEASED
#ENDIF              
            LD DE,0001H
            SBC HL,DE
            JP NC,INCKY2
            JP INCKY1
INCKY3      RET
;------------------
; DECREMENT ADDRESS
;------------------
DECKEY      CALL BEEP
DECKY1      LD HL,(ADRESS)
            DEC HL              ;DEC ADDRESS
            LD (ADRESS),HL
            CALL UPDATE
            LD HL,(KEYDEL)      ;AUTO REPEAT DELAY
DECKY2      CALL SCAND
            IN A,(KEYBUF)       ;READ KEYBOARD
#IFDEF  TEC-1
            BIT 6,A
#ELSE
            BIT 5,A
#ENDIF            
#IFDEF DA_ACTIVE_LOW           
            JR NZ,DECKY3         ; - KEY RELEASED
#ELSE         
            JR Z,DECKY3         ; - KEY RELEASED
#ENDIF
            LD DE,0001H
            SBC HL,DE
            JP NC,DECKY2
            JP DECKY1
DECKY3      RET
;-----------------------------------------
; UPDATE DISPLAY BUFFER TO CURRENT ADDRESS
;-----------------------------------------
UPDATE      LD HL,(ADRESS)
            CALL DISADD         ;AND DATA, PUT IN
            LD A,(HL)
            CALL DISBYT         ;DISPLAY BUFFER
;
; IN ADDRESS OR DATA MODE?
;
            LD HL,MODE
            BIT 7,(HL)          ;DATA OR ADDR MODE?
            JP Z,ADMODE         ;ADDRESS MODE
;
; SHOW DATA MODE
;
            LD HL,DISBUF        ;SET THE DP'S 
            LD B,2              ;IN THE DATA
            JP SETDP            ;DISPLAY
;
; SHOW ADDRESS MODE
;
ADMODE      LD HL,DISBUF+2
            LD B,4              ;SET THE DP'S IN THE ADDRESS DISPLAY
;
; SET DECIMAL POINT
;
;SET DP IN THE BYTE POINTED TO BY HL
;
#IFDEF TEC-1
SETDP       SET 4,(HL)          ;SET BIT 4 FOR DP ON TEC-1 DISPLAY
#ELSE
SETDP       SET 7,(HL)          ;SET BIT 7 FOR DP ON SC-1 DISPLAY
#ENDIF
            INC HL              ;POINT TO NEXT BYTE
            DJNZ SETDP          ;MORE BITS TO SET
            RET
;---------------
; VERSION NUMBER
;---------------
;RETURNS THE SOFTWARE VERSION NUMBER
;SHOULD FUTURE MONITORS EXHIBIT DIFFERENCES
;THE VERSION NUMBER CAN BE USED
;
;           ENTRY : NONE
; EXIT : H = ASCII MINOR VERSION NUMBER
;        L = ASCII MAJOR VERSION NUMBER
;
VERS        LD HL,3031H ; '01'
            RET
;-------------------------
; ADDRESS > DISPLAY BUFFER
;-------------------------
;CONVERT HL TO SEVEN SEGMENT CODE
;AND PUT IN ADDRESS DISPLAY BUFFER.
;
; ENTRY : HL = ADDRESS TO BE DISPLAYED
;
; EXIT  : NO REGISTERS MODIFIED
;
DISADD      PUSH AF
            PUSH HL
            PUSH  HL
            LD A,H
            CALL CONBYT
            LD (DISBUF+4),HL
            POP HL
            LD A,L
            CALL CONBYT
            LD (DISBUF+2),HL
            POP HL
            POP AF
            RET
;---------------------------
; DATA BYTE > DISPLAY BUFFER
;---------------------------
;CONVERT THE ACC TO SEVEN SEGMENT CODE
;AND PUT IN DATA DISPLAY BUFFER.
;
; ENTRY :  A = DATA DISPLAY BYTE
;
; EXIT  : NO REGISTERS MODIFIED
;
DISBYT      PUSH HL
            CALL CONBYT
            LD (DISBUF),HL
            POP HL
            RET
;---------------------------------------
; CONVERT BYTE TO 7 SEGMENT DISPLAY CODE
;---------------------------------------
; CONVERTS BYTE IN ACC TO SEVEN SEGMENT CODE
; FOR DISPLAY
; ENTRY : A = BYTE TO BE CONVERTED
; EXIT  : H = HI NYBBLE SEVEN SEGMENT CODE
;         L = LO NYBBLE SEVEN SEGMENT CODE
;         A = NOT MODIFIED
CONBYT      PUSH AF
            PUSH AF
            CALL CONVHI         ;CONVERT HI NYBBLE
            LD H,A
            POP AF
            CALL CONVLO         ;CONVERT LO NYBBLE
            LD L,A
            POP AF
            RET
;---------------------------------------------
; HEXADECIMAL TO SEVEN SEGMENT CODE CONVERSION
;---------------------------------------------
; CONVERTS NYBBLE IN ACC TO SEVEN SEGMENT CODE
; FOR SEVEN SEGMENT DISPLAYS
; CONVHI = CONVERTS HIGH NYBBLE
; CONVLO = CONVERTS LO NYBBLE
;
; ENTRY : A = NYBBLE TO BE CONVERTED
; EXIT  : A = SEVEN SEGMENT CODE
;
CONVHI      RLCA
            RLCA
            RLCA                ;MOVE TO LO NYBBLE
            RLCA                ;FOR CONVERSION
CONVLO      PUSH BC
            PUSH HL
            LD HL,SEGMNT        ;USE THE HEX VALUE
            AND 0FH             ;TO INDEX TO THE
            LD C,A              ;THE SEVEN SEGMENT
            LD B,00H            ;CODE FOR THAT VALUE
            ADD HL,BC           ;AND RETURN WITH
            LD A,(HL)           ;CODE IN A
            POP HL
            POP BC
            RET
;
; HEXADECIMAL TO 7 SEGMENT DISPLAY CODE TABLE
#IFDEF TEC-1
SEGMNT      .DB 0xEB,0x28,0xCD,0xAD ;0,1,2,3
            .DB 0x2E,0xA7,0xE7,0x29 ;4,5,6,7
            .DB 0xEF,0x2F,0x6F,0xE6 ;8,9,A,B
            .DB 0xC3,0xEC,0xC7,0x47 ;C,D,E,F
#ELSE
SEGMNT      .DB 3FH,06H,5BH,4FH ;0,1,2,3
            .DB 66H,6DH,7DH,07H ;4,5,6,7
            .DB 7FH,6FH,77H,7CH ;8,9,A,B
            .DB 39H,5EH,79H,71H ;C,D,E,F
#ENDIF
;-------------
; SCAN DISPLAY
;-------------
;AS THE DISPLAYS ARE MULTIPLEXED, THE DATA FOR EACH
;DISPLAY MUST BE LATCHED INTO THE DISPLAY SEGMENT
;LATCH IN TURN AND THE CORRESPONDING BIT IN THE DISPLAY
;SCAN LATCH TURNED ON TO DISPLAY THE DATA.
;TWO SHORT DELAYS ARE USED TO ADJUST THE DUTY
;CYCLE AND HENCE DISPLAY BRIGHTNESS.
;
; ENTRY : NONE
; EXIT  : NO REGISTERS MODIFIED
;
SCAND       PUSH    AF
            PUSH BC
            PUSH HL             ;SAVE REGISTERS
            LD HL,DISBUF+5
            LD C,20H
SCAND1      LD A,(HL)
            OUT (DISPLY),A      ;OUTPUT CHARACTER
            LD A,C
            OUT (SCAN),A        ;TURN ON DISPLAY
            LD A,(ONTIM)        ;DO A SHORT DELAY
            LD B,A              ;TO ADJUST ON TIME
SCAND2      DJNZ SCAND2         ;OF DISPLAY
            LD A,B              ;B IS NOW CLEAR, USE
            OUT (SCAN),A        ;IT TO TURN OFF SCAN
            LD A,(OFTIM)        ;DO A SHORT DELAY
            LD B,A              ;TO ADJUST OFF TIME
SCAND3      DJNZ SCAND3         ;OF DISPLAY
            DEC HL              ;POINT TO NEXT
            RRC C               ;ELEMENT IN BUFFER
            JR NC,SCAND1        ;DISPLAY NEXT ELEMENT
            LD A,B              ;B IS NOW CLEAR, USE
            OUT (SCAN),A        ;IT TO TURN OFF SCAN
            OUT (DISPLY),A      ;AND CLEAR DISPLAY LATCH
            POP HL
            POP BC
            POP AF              ;RESTORE REGISTERS
            RET
;---------------------
; CLEAR DISPLAY BUFFER
;---------------------
CLRBUF      PUSH HL
            PUSH BC
            LD HL,DISBUF
            LD B,6
CLRBF1      LD (HL),00H         ;PUT ZERO IN 6
            INC HL              ;LOCATIONS POINTED
            DJNZ CLRBF1         ;TO BY HL
            POP BC
            POP HL
            RET
;------------------
; KEYBOARD ROUTINES
;------------------
;-----------------------------
; SCAN DISPLAY UNTIL KEY PRESS
;-----------------------------
; ENTRY : NONE
; EXIT  : A = KEY VALUE 00H TO 1FH
;         FLAG REGISTER MODIFIED
;
SKEYIN      CALL SCAND          ;SCAN DISPLAY
            IN A,(KEYBUF)       ;READ KEYBOARD
#IFDEF  TEC-1
            BIT 6,A
#ELSE
            BIT 5,A
#ENDIF       
            
#IFDEF DA_ACTIVE_LOW
            JR NZ,SKEYIN         ;NO KEY PRESS
#ELSE
            JR Z,SKEYIN         ;NO KEY PRESS
#ENDIF
            AND 1FH             ;STRIP UNUSED BITS
            RET
;-------------------------------
; SCAN DISPLAY UNTIL KEY RELEASE
;-------------------------------
; ENTRY : NONE
; EXIT  : NONE
;
SKEYRL      PUSH AF
SKEYL1      CALL SCAND          ;SCAN DISPLAY
            IN A,(KEYBUF)       ;READ KEYBOARD
#IFDEF  TEC-1
            BIT 6,A
#ELSE
            BIT 5,A
#ENDIF       
            
#IFDEF DA_ACTIVE_LOW
            JR Z,SKEYL1        ;KEY NOT RELEASED
#ELSE 
            JR NZ,SKEYL1        ;KEY NOT RELEASED
#ENDIF
            POP AF
            RET
;-------------------
; WAIT FOR KEY PRESS
;-------------------
; ENTRY : NONE
; EXIT  : A = KEY VALUE 00H TO 1FH
;         FLAG REGISTER MODIFIED
;
KEYIN       IN A,(KEYBUF)       ;READ KEYBOARD
#IFDEF  TEC-1
            BIT 6,A
#ELSE
            BIT 5,A
#ENDIF       
#IFDEF DA_ACTIVE_LOW
            JR NZ,KEYIN          ;NO KEY PRESS
#ELSE
            JR Z,KEYIN          ;NO KEY PRESS
#ENDIF
            AND 1FH             ;STRIP UNUSED BITS
            RET
;---------------------
; WAIT FOR KEY RELEASE
;---------------------
; ENTRY : NONE
; EXIT  : NONE
;
KEYREL      PUSH AF
KEYRL1      IN A,(KEYBUF)
#IFDEF  TEC-1
            BIT 6,A
#ELSE
            BIT 5,A
#ENDIF       
#IFDEF DA_ACTIVE_LOW
            JR Z,KEYRL1
#ELSE           
            JR NZ,KEYRL1
#ENDIF
            POP AF
            RET
;-----------------
; KEY MENU HANDLER
;-----------------
; COMPARES ACC AGAINST TABLE OF ELEMENTS,
; IF FOUND JUMP TO ADDRESS CORRESPONDING TO
; THAT ELEMENT, RETURNS IF ELEMENT NOT FOUND.
; ENTRY :  A = ELEMENT TO LOOK FOR
;         HL = POINTS TO TABLE
; EXIT  :  ELEMENT NOT FOUND
;           HL HOLDS ADDRESS OF LAST ELEMENT
;          ELEMENT FOUND
;           CONTROL PASSES TO JUMP ADDRESS WITH
;          RETURN ADDRESS OF MENU CALL ON STACK
;
MENU        PUSH AF
            PUSH BC
            PUSH DE             ;SAVE REGISTERS
            PUSH HL             ;CALCULATE ADDRESS
            LD D,00H            ;OF THE JUMP TABLE BY
            LD E,(HL)           ;ADDING THE INDEX TO
            INC HL              ;THE ELEMENTS
            ADD HL,DE           ;TO THE ADDR OF THE
            LD D,H              ;TABLE
            LD E,L
            POP HL
            LD B,(HL)           ;GET NUMBER OF ENTRIES
            INC HL              ;POINT TO LIST OF ENTRIES
MENU1       CP (HL)             ;COMPARE WITH ENTRY
            JR Z,MENU2          ;FOUND VALUE IN TABLE
            INC HL              ;NEXT ENTRY IN LIST
            INC DE              ;NEXT ENTRY IN
            INC DE              ;JUMP TABLE
            DJNZ MENU1          ;CHECK MORE ENTRIES
            POP DE
            POP BC
            POP AF
            RET                 ;NOT IN TABLE
;
; FOUND ELEMENT IN THE TABLE
; PASS CONTROL TO THE JUMP HANDLER
;
MENU2       LD A,(DE)           ;GET THE JUMP ADDR
            LD L,A              ;FROM THE TABLE
            INC DE              ;AND JUMP TO
            LD A,(DE)           ;THE JUMP ADDRESS
            LD H,A              ;FOR THAT ENTRY
            POP DE
            POP BC
            POP AF              ;RESTORE REGISTERS
            JP (HL)
;-------------------
; CALCULATE CHECKSUM
;-------------------
;CALCULATES CHECKSUM BETWEEN START AND END (INCLUSIVE)
;
; ENTRY : HL = START OF BLOCK TO SUM
;         DE = END OF BLOCK TO SUM
; EXIT  : A =  CHECKSUM
;         FLAG REGISTER MODIFIED
;
CHKSUM      PUSH HL
            PUSH DE
            INC DE              ;END OF BLOCK+1
            XOR A               ;CLEAR CHECKSUM
CHKSM1      ADD A,(HL)          ;COMPUTE CHEKSUM
            INC HL              ;POINT TO NEXT ELEMENT
            AND A               ;SET CARRY
            PUSH HL
            SBC HL,DE           ;SUBTRACT
            POP HL
            JR C,CHKSM1         ;MORE ELEMENTS
            POP DE
            POP HL
            RET
;--------------------------
; ACCESS BYTE LOOK UP TABLE
;--------------------------
; USE 8 BIT INDEX TO ACCESS BYTE LOOK
; UP TABLE
; ENTRY :  A = NUMBER OF ELEMENT IN TABLE
;         HL = ADDRESS OF LOOK UP TABLE
; EXIT : HL = ADDRESS OF ELEMENT A
;
INDEXB      PUSH DE
            LD E,A              ;USE DE AS INDEX
            LD D,0              ;TO ELEMENT IN TABLE
            ADD HL,DE           ;BY ADDING TO HL
            POP DE
            RET
;--------------------------
; ACCESS WORD LOOK UP TABLE
;--------------------------
; USE 8 BIT INDEX TO ACCESS WORD LOOK
; UP TABLE
; ENTRY :  A = NUMBER OF ELEMENT IN TABLE
;         HL = ADDRESS OF LOOK UP TABLE
; EXIT : HL = ADDRESS OF 2 BYTE ELEMENT A
;
INDEXW      PUSH DE
            LD E,A
            SLA E               ;MULTIPLY BY TWO
            LD D,0
            ADD HL,DE
            POP DE
            RET
;--------------
; OUTPUT A TONE
;--------------
;
; ENTRY : A = PERIOD/2 OF NOTE
;         HL = DURATION/2 OF NOTE
; EXIT NO REGISTERS MODIFIED
TONE        PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            LD DE,0001H
            LD C,A
            ADD HL,HL           ;DOUBLE DURATION
            XOR A
TONE1       XOR 80H             ;TOGGLE SPEAKER BIT
            OUT (SCAN),A        ;OUTPUT SPEAKER BIT
            LD B,C
TONE2       PUSH BC
            LD B,02H
TONE3       DJNZ TONE3          ;DELAY FOR PERIOD/2
            POP BC
            DJNZ TONE2          ; DELAY FOR PERIOD/2
            SBC HL,DE           ;END OF NOTE?
            JR NZ,TONE1         ;DO AGAIN
            POP HL
            POP DE
            POP BC
            POP AF
            RET
;---------------
; KEY ENTRY BEEP
;---------------
BEEP        PUSH HL
            PUSH AF
            LD HL,MODE
            BIT 6,(HL)          ;BEEP ENABLED?
            JR Z,BEEP2          ;BEEP IS ENABLED
;
; DO KEYPRESS DELAY
;
            PUSH DE             ;DO A SHORT
            LD DE,0001H         ;DELAY TO PREVENT
            LD HL,(KEYTIM)      ;RECOGNITION
BEEP1       SBC HL,DE           ;OF DOUBLE
            JR NC,BEEP1         ;KEY STROKES
            POP     DE
            JR BEEP3
;
; OUTPUT KEYPRESS TONES
;
BEEP2       LD A,24H
            LD HL,0030H
            CALL TONE           ;DO FIRST TONE
            LD A,0EH
            LD HL,0050H
            CALL TONE           ;DO SECOND TONE
BEEP3       POP AF
            POP HL
            RET
;----------------------------------------
; BREAKPOINT AND SINGLE STEPPING ROUTINES
;----------------------------------------
;DISPLAYS AND MODIFIES REGISTERS AFTER BREAKPOINT
; (RST 38H) OR SINGLE STEP INTERRUPT (IF HARDWARE
; ATTACHED).
;INSERT RST 38H (FFH) IN PROGRAM TO EXAMINE
; AND MODIFY REGISTERS.
;
SSTEP       POP HL              ;GET HL BACK
            PUSH AF             ;SAVE AF FOR LATER
            LD (HL_REG),HL
            LD (DE_REG),DE
            LD (BC_REG),BC
            LD (IX_REG),IX
            LD (IY_REG),IY      ;SAVE REGISTERS
            POP HL              ;GET AF BACK
            LD (AF_REG),HL      ;SAVE AF
            POP HL              ;GET PC RETURN ADDRESS
            LD (PC_REG),HL      ;SAVE PC
            LD (SP_REG),SP      ;SAVE STACK POINTER
;
; STEP THROUGH,DISPLAY AND EDIT REGISTERS
;
            CALL BEEP
            LD A,(REGPNT)       ;GET CURRENT REG
            AND 7               ;MAKE SURE IN LIMITS
            LD (REGPNT),A       ;SAVE IT
DISREG      CALL SETREG         ;SET UP DISPLAY BUFFER
            CALL SKEYRL         ;WAIT FOR A KEY
            CALL SKEYIN         ;WAIT FOR KEY RELEASE
            LD HL,REGTBL        ;HANDLE THE KEY
            CALL MENU           ;AND UPDATE DISPLAY
            JP DISREG           ;BEFORE RETURNING TO LOOP
;
; REGISTER DISPLAY KEY TABLE
;
REGTBL      .DB 14H
            .DB 00H,01H,02H,03H,04H,05H,06H,07H
            .DB 08H,09H,0AH,0BH,0CH,0DH,0EH,0FH
            .DB 10H,11H,12H,13H
            .DW REGKEY,REGKEY,REGKEY,REGKEY
            .DW REGKEY,REGKEY,REGKEY,REGKEY
            .DW REGKEY,REGKEY,REGKEY,REGKEY
            .DW REGKEY,REGKEY,REGKEY,REGKEY
#IFDEF TEC-1
            .DW INCSTP,DECSTP,RETPGM,RETMON         
#ELSE           
            .DW RETMON,RETPGM,INCSTP,DECSTP
#ENDIF
;
; REGISTER NAME CHARACTERS
;
#IFDEF TEC-1
REGNAM      .DW 0x4FC3
            .DW 0x6F47,0xE6C3,0xECC7
            .DW 0x66C2,0x286E,0x28AE
            .DW 0xA74F
#ELSE
REGNAM      .DW 7339H
            .DW 7771H,7C39H,5E79H
            .DW 7438H,0676H,066EH
            .DW 6D73H
#ENDIF
;--------------
; EDIT REGISTER
;--------------
REGKEY      CALL BEEP
            PUSH AF             ;SAVE KEY FOR LATER
            LD A,(REGPNT)
;
; EDIT REGISTER
;
            LD HL,PC_REG
            CALL INDEXW
            LD C,(HL)
            INC HL
            LD B,(HL)           ;GET REG CONTENTS
            SLA C
            RL B
            SLA C
            RL B
            SLA C
            RL B                ;SHIFT REGISTER
            SLA C               ;FOUR BITS
            RL B                ;LEFT AND
            POP AF              ;PUT THE KEY
            OR C                ;INTO THE LSN
            LD C,A              ;AND PUT THE
            LD (HL),B           ;REGISTER BACK
            DEC HL              ;WHERE IT BELONGS
            LD (HL),C
            RET
;------------------
; RETURN TO MONITOR
;------------------
RETMON      CALL BEEP
            CALL SKEYRL
            EI                  ;ENABLE INTERRUPTS AGAIN
            JP MAIN
;------------------
; RETURN TO PROGRAM
;------------------
RETPGM      LD SP,(SP_REG)      ;PUT STACK POINTER BACK
            LD HL,(PC_REG)      ;PUT RETURN
            PUSH HL             ;ADDRESS BACK ON STACK
            LD HL,(AF_REG)
            PUSH HL             ;SAVE AF REG FOR LATER
            LD IY,(IY_REG)
            LD IX,(IX_REG)
            LD BC,(BC_REG)
            LD DE,(DE_REG)      ;RESTORE REGISTERS
            POP AF              ;RESTORE AF
            LD HL,(HL_REG)      ;RETORE HL
            EI                  ;ENABLE INTERRUPTS
            RET                 ;AND RETURN TO PROGRAM
;----------------------
; DISPLAY NEXT REGISTER
;----------------------
INCSTP      CALL BEEP
            LD A,(REGPNT)
            CP A,7              ;END OF REG TABLE?
            JP Z,INCSP1
            INC A
            LD (REGPNT),A
            RET
INCSP1      XOR A
            LD (REGPNT),A
            RET
;--------------------------
; DISPLAY PREVIOUS REGISTER
;--------------------------
DECSTP      CALL BEEP
            LD A,(REGPNT)
            CP A,0              ;START OF REG TABLE?
            JP Z,DECSP1
            DEC A
            LD (REGPNT),A
            RET
DECSP1      LD A,7
            LD (REGPNT),A
            RET
;-----------------
; DISPLAY REGISTER
;-----------------
SETREG      LD A,(REGPNT)
            LD HL,PC_REG        ;START OF TABLE
            CALL INDEXW         ;GET ELEMENT ADDRESS
            LD E,(HL)
            INC HL
            LD D,(HL)
            EX DE,HL            ;LOAD REGISTER CONTENTS
            CALL DISADD
;
; DISPLAY REGISTER NAME
;
            LD HL,REGNAM
            CALL INDEXW
            LD A,(HL)
            LD (DISBUF+0),A
            INC HL
            LD A,(HL)
            LD (DISBUF+1),A
            RET
;------------------
; FUNCTION KEY MENU
;------------------
; WHEN THE FN KEY IS PRESSED, Fn IS DISPLAYED IN THE
; DATA DISPLAYS, THE CURRENT ADDRESS REMAINS IN THE
; ADDRESS DISPLAYS THE PROGRAM THEN WAITS FOR A
; KEYPRESS WHICH WILL SELECT 1 OF 16 ROUTINES.
;
FUNKEY      POP HL              ;REMOVE RETURN ADDRESS
            CALL BEEP
FUNKY1      LD HL,(ADRESS)
            CALL DISADD         ;DISP ADDR TO REMOVE DP'S
#IFDEF TEC-1              
;            LD HL,4764H        ;THIS IS Fn
             LD HL,0xAF0F       ;USE THE GO KEY IN THE TEC
#ELSE            
            LD HL,7154H
#ENDIF
            LD (DISBUF),HL      ;DISPLAY FN
            CALL SKEYRL         ;WAIT FOR KEY RELEASE
FUNKY2      CALL SKEYIN
            LD HL,(FUNTBL)      ;USE THE MENU HANDLER
            CALL MENU           ;ROUTINE FOR EACH KEY
            JP FUNKY2           ;TRY AGAIN
;
; RETURN TO MAIN
;
CANCEL      CALL BEEP
CANCL1      CALL UPDATE         ;UPDATE DISPLAY BUFFER
            CALL SKEYRL         ;WAIT FOR KEY RELEASE
            POP HL              ;REMOVE MENU RETURN
            JP MAIN2
;
; FUNCTION MENU KEY TABLE
;
FUNLST      .DB 05H    
            .DB 00H,01H,07H,0BH,12H
            .DW GOEXEC
            .DW INTELH
            .DW TRACE
            .DW SWBEEP
            .DW CANCEL
;--------------------------
; JUMP TO FUNCTION FUNCTION
;--------------------------
;FUNFUN      LD HL,(FUNJMP)
;            JP (HL)
;------------------------------------------
; FUNCTION 0 - EXECUTE FROM CURRENT ADDRESS
;------------------------------------------
GOEXEC      CALL BEEP
            CALL KEYREL
            POP HL              ;REMOVE EXEC RETURN
            LD HL,(ADRESS)
            JP (HL)             ;START EXECUCTION
;------------------------------------
; FUNCTION 1 RECEIVE INTEL HEX FORMAT
;------------------------------------
INTELH      CALL BEEP
            CALL KEYREL
            LD IX,SYSTEM        ;POINT TO SYSTEM VARIABLES
;
; WAIT FOR RECORD MARK
;
INTEL1      XOR A
            LD (IX+3),A         ;CLEAR CHECKSUM
            CALL RXDATA         ;WAIT FOR THE
            JR C,INTEL5         ;RECORD MARK
            CP ':'              ;TO BE TRANSMITTED
            JR NZ,INTEL1        ;NOT RECORD MARK
;
; GET RECORD LENGTH
;
            CALL GETBYT
            JR C,INTEL5
            LD (IX+0),A         ;NUMBER OF DATA BYTES
;
; GET ADDRESS FIELD
;
            CALL GETBYT
            JR C,INTEL5
            LD (IX+2),A         ;LOAD ADDRESS HIGH BYTE
            CALL GETBYT
            JR C,INTEL5
            LD (IX+1),A         ;LOAD ADDRESS LOW BYTE
;
; GET RECORD TYPE
;
            CALL GETBYT
            JR C,INTEL5
            JR NZ,INTEL4        ;END OF FILE RECORD
;
; READ IN THE DATA
;
            LD B,(IX+0)         ;NUMBER OF DATA BYTES
            LD H,(IX+2)         ;LOAD ADDRESS HIGH BYTE
            LD L,(IX+1)         ;LOAD ADDRESS LOW BYTE

INTEL2      CALL GETBYT         ;GET DATA BYTE
            JR C,INTEL5
            LD (HL),A           ;STORE DATA BYTE
            INC HL
            DJNZ INTEL2         ;LOAD MORE BYTES
;
; GET CHECKSUM AND COMPARE
;
            LD A,(IX+3)         ;CONVERT CHECKSUM TO
            NEG                 ;TWO'S COMPLEMENT
            LD (IX+4),A         ;SAVE COMPUTED CHECKSUM
            CALL GETBYT
            JR C,INTEL5
            LD (IX+3),A         ;SAVE RECORD CHECKSUM
            CP (IX+4)           ;COMPARE CHECKSUM
            JR Z,INTEL1         ;CHECKSUM OK,NEXT RECORD
;
; CHECKSUM ERROR
;
INTEL3      JP BLKMV1
;
; END OF FILE RECORD
;
INTEL4      LD A,(IX+3)         ;CONVERT CHECKSUM TO
            NEG                 ;TWO'S COMPLEMENT
            LD (IX+4),A         ;SAVE COMPUTED CHECKSUM
            CALL GETBYT
            JR C,INTEL5
            LD (IX+3),A         ;SAVE EOF CHECKSUM
            CP (IX+4)           ;COMPARE CHECKSUM
            JR NZ,INTEL3        ;CHECKSUM ERROR
;
; LOAD COMPLETE
;
#IFDEF TEC-1
            LD HL,00C3H         ;SHOW C FOR COMPLETE
#ELSE
            LD HL,0039H         ;SHOW C FOR COMPLETE
#ENDIF
            JP BLKMV2
;
; INTERRUPTED BY KEYBOARD
;
#IFDEF TEC-1
INTEL5      LD HL,006FH         ;SHOW A FOR ABORT
#ELSE
INTEL5      LD HL,0077H         ;SHOW A FOR ABORT
#ENDIF
            JP BLKMV2        
;
; SHOW ERROR
;
#IFDEF TEC-1
BLKMV1      LD HL,00C7H         ;SHOW ERROR
#ELSE
BLKMV1      LD HL,0079H         ;SHOW ERROR
#ENDIF
BLKMV2      CALL BEEP
            LD (DISBUF),HL      ;AND WAIT
            CALL SKEYIN         ;FOR KEYPRESS
            CALL BEEP
            CALL SKEYRL
            JP CANCL1         
;--------------------------
; GET BYTE FROM SERIAL PORT
;--------------------------
GETBYT      PUSH BC
            CALL RXDATA
            JR C,GETBT3
            BIT 6,A
            JR Z,GETBT1
            ADD A,09H
GETBT1      AND 0FH
            SLA  A
            SLA A
            SLA A
            SLA A
            LD C,A
;
; GET LOW NYBBLE
;
            CALL RXDATA
            JR C,GETBT3
            BIT 6,A
            JR Z,GETBT2
            ADD A,09H
GETBT2      AND 0FH
            OR C
            LD B,A
            ADD A,(IX+3)
            LD (IX+3),A         ;ADD TO CHECKSUM
            LD A,B
            AND A               ;CLEAR CARRY
GETBT3      POP BC
            RET
;-------------------------------
; CONVERT ASCII CHARACTER TO HEX
;-------------------------------
;CONVERTS ASCII 0-9,A-F INTO HEX LSN
;ENTRY : A= ASCII 0-9,A-F
;EXIT  : A= HEX 0-F IN LSN
; A AND F REGISTERS MODIFIED
;
ASCHEX      BIT 6,A
            JR Z,ASCHX1
            ADD A,09H
ASCHX1      AND 0FH
            RET
;------------------------
; SERIAL TRANSMIT ROUTINE
;------------------------
;TRANSMIT BYTE SERIALLY ON DOUT
;
; ENTRY : A = BYTE TO TRANSMIT
;  EXIT : NO REGISTERS MODIFIED
;
TXDATA	PUSH	AF
	PUSH	BC
	PUSH	HL
	LD	HL,(BAUD)
	LD	C,A
;
; TRANSMIT START BIT
;
	XOR	A
	OUT	(SCAN),A
	CALL	BITIME
;
; TRANSMIT DATA
;
	LD	B,08H
	RRC	C
NXTBIT	RRC	C	;SHIFT BITS TO D6,
	LD	A,C	;LSB FIRST AND OUTPUT
	AND	40H	;THEM FOR ONE BIT TIME.
	OUT	(SCAN),A
	CALL	BITIME
	DJNZ	NXTBIT
;
; SEND STOP BITS
;
	LD	A,40H
	OUT	(SCAN),A
	CALL	BITIME
	CALL	BITIME
	POP	HL
	POP	BC
	POP	AF
	RET
;-----------------------
; SERIAL RECEIVE ROUTINE
;-----------------------
;RECEIVE SERIAL BYTE FROM DIN
;
; ENTRY : NONE
;  EXIT : A= RECEIVED BYTE IF CARRY CLEAR
;         A= KEYBUF, CARRY SET IF KEY PRESSED
; REGISTERS MODIFIED A AND F
;
RXDATA	PUSH	BC
	    PUSH    HL
;
; WAIT FOR START BIT OR EXIT IF KEY PRESS.
;
RXDAT1	IN	A,(KEYBUF)

#IFDEF  TEC-1
            BIT 6,A
#ELSE
            BIT 5,A
#ENDIF         
	    SCF
#IFDEF DA_ACTIVE_LOW
            JR Z,RXDAT3        ;KEY PRESS SO EXIT 
#ELSE
            JR NZ,RXDAT3        ;KEY PRESS SO EXIT 
#ENDIF    
  
	BIT	7,A
	JR	NZ,RXDAT1	;NO START BIT
;
; DETECTED START BIT
;
	LD	HL,(BAUD)
	SRL	H
	RR	L 	;DELAY FOR HALF BIT TIME
	CALL 	BITIME
	IN	A,(KEYBUF)
	BIT	7,A
	JR	NZ,RXDAT1	;START BIT NOT VALID
;
; DETECTED VALID START BIT,READ IN DATA
;
	LD	B,08H
RXDAT2	LD	HL,(BAUD)
	CALL	BITIME	;DELAY ONE BIT TIME
	IN	A,(KEYBUF)
	RL	A
	RR	C	;SHIFT BIT INTO DATA REG
	DJNZ	RXDAT2
	LD	A,C
	OR	A	;CLEAR CARRY FLAG
RXDAT3	POP	HL
	POP	BC
	RET
;---------------
; BIT TIME DELAY
;---------------
;DELAY FOR ONE SERIAL BIT TIME
;ENTRY : HL = DELAY TIME
; NO REGISTERS MODIFIED
;
BITIME      PUSH HL
            PUSH DE
            LD DE,0001H
BITIM1      SBC HL,DE
            JP NC,BITIM1
            POP DE
            POP HL
            RET
;-------------------------------
; SCAN DISPLAY UNTIL KEY RELEASE
;-------------------------------
SDELAY      LD (DISBUF),HL      ;SHOW HL
            LD B,255            ;IN DATA DISPLAYS
SDELY1      CALL SCAND          ;UNTIL KEY
            DJNZ SDELY1         ;IS RELEASED
            CALL SKEYRL
            RET
;-----------------------------------------
; FUNCTION 7 - TOGGLE HARDWARE SINGLE STEP
;-----------------------------------------
TRACE       CALL BEEP
            OUT (IO7),A         ;TOGGLE HARDWARE SINGLE STEP LATCH
#IFDEF TEC-1       
            LD HL,0046H         ;SHOW T
#ELSE
            LD	HL,0070H	    ;SHOW T
#ENDIF
            CALL SDELAY
            JP CANCL1
;-----------------------------
; FUNCTION B - TOGGLE KEY BEEP
;-----------------------------
SWBEEP      CALL BEEP
            LD A,(MODE)
            XOR 40H
            LD (MODE),A
            JP CANCL1
;-------------------------------
; SEPARATE BYTE INTO TWO NYBBLES
;-------------------------------
;SEPARATES A BYTE INTO TWO
;RIGHT JUSTIFIED NYBBLES
; ENTRY : A = BYTE TO BE SEPARATED
; EXIT  : H = MSN
;         L = LSN
;
SPLIT       PUSH AF
            PUSH BC
            LD B,A              ;SAVE BYTE
            AND 0FH             ;STRIP BITS LSN
            LD L,A              ;RETURN LSN IN L
            LD A,B
            SRL A
            SRL A
            SRL A               ;MOVE MSN
            SRL A               ;INTO LSN
            LD H,A              ;RETURN MSN IN H
            POP BC
            POP AF
            RET
;-----------------
; ONE SECOND DELAY
;-----------------
; MUST BE AT 4MHZ I GUESS
; ENTRY : NONE
; EXIT : FLAG REGISTER MODIFIED
;
DELONE      PUSH BC
            PUSH DE
            PUSH HL
            LD DE,0001H
            LD HL,0870H
DELON1      LD B,92H
DELON2      DJNZ DELON2         ;INNER LOOP
            SBC HL,DE
            JP NC,DELON1        ;OUTER LOOP
            POP HL
            POP DE
            POP BC
            RET
            END
