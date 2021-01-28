;Fast Forward by J Robinson
;
;Modified by Brian Chiha to work on all MONS provided you have the 4k7 NMI to D7 hardware fix
;Set HL on line 0F01-02 to your start address
;Enjoy...
;
            ORG    0F00H 
SETUP:
            LD     HL,0000H		;Put start address to look at here
            XOR    A            ;Initial Key = 0
            PUSH   AF           ;Save Previous key

START:
            CALL   CON_HL_A		;Convert HL and its contents to screen display
            CALL   KEY_TONE		;Play a Beep
            LD     DE,0400H		;Default Speed
            
            IN     A,(03)		;Check if key is pressed
            BIT    6,A
            JR     NZ,GET_PREV  ;No key pressed
            IN     A,(00)		;Get actual key
            AND    1FH			;Mask upper bits

CHK_INP:						;Check input if any
            CP     0AH 			;Fast Foward
           	JP     NZ,FASTR		;Check Fast Reverse
           	LD     DE,0100H		;Go Forward fast
           	INC    HL
           	JR     DO_SCAN
            
FASTR:
           	CP     0BH         	;Fast Reverse
           	JP     NZ,SLOWR		;Check Slow Reverse
           	LD     DE,0100H		;Go Backward fast
            DEC    HL
           	JR     DO_SCAN

SLOWR:
           	CP     0DH 			;Slow Reverse
           	JP     NZ,STOP		;Check Stop
           	LD     DE,0400H		;Go Backward slow
            DEC    HL
           	JR     DO_SCAN

STOP:
           	CP     0CH 			;Stop
           	JP     NZ,SLOWF 	;Just move forward
           	JR     DO_SCAN

SLOWF:
            INC    HL           ;Move default speed forward

DO_SCAN:
            LD     B,A 			;Save current key
            POP    AF
            LD     A,B
            PUSH   AF
            ;LD     DE,(SPEED)	;Display HL and A with Speed delay
            PUSH   HL
RESCAN:
            CALL   SCAN 		;Display the screen
            DEC    DE
            LD     A,D
            OR     E
            JR     NZ,RESCAN 
            POP    HL
            JR     START

GET_PREV:						;Retrive the prevoius key and re save it
            POP    AF
            PUSH   AF
            JR     CHK_INP

SCAN:                                   ;Multiplex the displays
            LD      B,20H               ;Segment Reference
            LD      HL,DISP_BUFF        ;Set HL to Display Buffer

SCAN_LOOP:
            LD      A,(HL)              ;Get Segment Value at HL
            OUT     (02),A              ;Set on Segment
            LD      A,B                 ;Get Segment reference
            OUT     (01),A              ;Activate segment
            LD      B,80H               ;Segment delay
D_LOOP:     DJNZ    D_LOOP
            INC     HL                  ;move to next location
            LD      B,A                 ;Save Segment reference
            XOR     A                   ;Clear A
            OUT     (01),A              ;Deactivate Segment
            RRC     B                   ;Move Segment Reference on to the Right
            JR      NC,SCAN_LOOP        ;If not passed the last segment, scan next segment
            OUT     (02),A              ;Clear port 2
            RET

;Convert HL and A to Seven Segment Display
CON_HL_A:
            LD      BC,DISP_BUFF        ;Location of display buffer 
            LD      A,H                 ;Get high byte of Address
            CALL    CON_A               ;Convert A to Segment Hex
            LD      A,L                 ;Get low byte of Address
            CALL    CON_A               ;Convert A to Segment Hex
            LD      A,(HL)              ;Now get value at HL to convert (Data)

CON_A:
            PUSH    AF                  ;Save A to keep original value
            RLCA                        ;Shift upper nibble to lower for masking
            RLCA
            RLCA
            RLCA
            CALL    CON_NIBBLE          ;Convert Lower nibble to segment hex
            POP     AF                  ;Restore A

CON_NIBBLE:
            AND     0FH                 ;Only look at lower nibble for indexing
            LD      DE,DISP_COD_TAB     ;Reference Segment convert table
            ADD     A,E                 ;Index table with A
            LD      E,A                 ;Update DE with index
            LD      A,(DE)              ;Look up table
            LD      (BC),A              ;Save it to display buffer
            INC     BC                  ;Increment buffer location
            RET

KEY_TONE:
            LD      C,40H               ;Half cycle count
            XOR     A                   ;Clear A
TONE_LOOP:
            OUT     (01),A              ;Set or unset speaker bit
            LD      B,40H               ;Set delay
TONE_DELAY: DJNZ    TONE_DELAY
            XOR     80H                 ;Toggle speaker bit
            DEC     C                   ;Count down cycle
            JR      NZ,TONE_LOOP        ;Do more toning
            RET

DISP_COD_TAB:
            DB     0EBH,28H,0CDH,0ADH,2EH,0A7H,0E7H,29H
            DB     0EFH,0AFH,6FH,0E6H,0C3H,0ECH,0C7H,47H

DISP_BUFF:  EQU    0D00H      		;Display buffer

