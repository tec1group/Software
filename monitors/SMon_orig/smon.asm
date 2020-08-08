;SMON - Simple Monitor - Written by J Robinson
;---------------------------------------------

; The S(imple)MON as its name suggests, is a very simple monitor. In fact it is only
; just enough to allow you to view, alter, and run your own programs.
; 
; SMON VARIBLES
; SMON has only two varibles. They are the CONTROL BYTE and the RAM pointer.
; The control byte flags between the two operating modes, ADDRESS and DATA,
; by the state of bit 4. If bit 4 is a logic 1 then SMON is in the ADDRESS mode.
; If it is a zero then SMON is in the DATA mode. No other bits are used in the
; control byte. The control byte is stored at 0x0F08.
; The RAM pointer holds the address of the RAM location the SMON is currently
; displaying. The RAM pointer is stored at 0x0F06.
;
; Designed for the TEC and to be placed in ROM at 0x0000
;
;Main Code

            ORG     0000H 
START:
            LD      SP,1000H			;Set stack pointer
            LD      HL,0800H			;Set RAM address
            LD      (PTR_BUFF),HL 		;Point to RAM
            CALL    RESET_TONES 		;Make a double tone for RESET

CLR_CON_BYT:
            XOR     A 			    ;Clear Control Byte

STR_CON_BYT:
            LD      (CONT_BUFF),A       ;Store Control Byte

CLR_KEY_FLG:
            LD      A,0FFH              ;Clears interrupt register
            LD      I,A                 ;Key stored address
            LD      HL,(PTR_BUFF)       ;Load current address
            CALL    CON_HL_A            ;Convert HL to Segment Display 
            CALL    SET_DOTS            ;Set Control Byte Dots

KEY_LOOP:
            CALL    SCAN                ;Multiplex the display
            LD      A,I                 ;See if key hit
            CP      0FFH                ;If not FF then a key has been pressed
            JR      Z,KEY_LOOP
            PUSH    AF                  ;Save Key hit to play tone
            CALL    KEY_TONE
            POP     AF
            LD      HL,(PTR_BUFF)       ;Load current address
            BIT     4,A                 ;Check if key pressed in +,-,GO or AD
            JR      Z,DAT_KEY_PROC      ;Process keys 0-F

CP_PLUS:
            CP      10H                 ;Check '+' Key
            JR      NZ,CP_MINUS
            INC     HL                  ;Increment next adddress

PTR_UPDATE:
            LD      (PTR_BUFF),HL       ;Save new address in buffer
            JR      CLR_KEY_FLG         ;Redisplay and Key check

CP_MINUS:
            CP      11H                 ;Check '-' Key
            JR      NZ,CP_GO
            DEC     HL                  ;Increment next adddress
            JR      PTR_UPDATE          ;Save HL and return

CP_GO:
            CP      12H                 ;Check 'GO' Key
            JR      NZ,AD_KEY
            JP      (HL)                ;Set PC to value at HL (Run it)

AD_KEY:                                 ;If here must be AD key pressed
            LD      A,(CONT_BUFF)       ;Check the state of the Control Byte
            XOR     10H                  ;Flip Bit 4 to change state
            JR      STR_CON_BYT         ;Store control byte and redisplay

DAT_KEY_PROC:                           ;Process Data keys based on control byte
            LD      B,A                 ;Save Key pressed
            LD      A,(CONT_BUFF)       ;load control byte into A
            BIT     4,A                 ;Is bit 4 set
            LD      A,B                 ;Restore Key pressed
            JR      NZ,D_KEY_AD_MD      ;If set Jump for ADDRESS Mode
            RLD                         ;Shift A (key) into Lower Nibble of RAM
            JR      CLR_KEY_FLG         ;Redisplay and Key check

D_KEY_AD_MD:                            ;Process Address
            LD      HL,PTR_BUFF         ;Move HL to RAM address
            RLD                         ;Shift A (key) into Lower Nibble of RAM
            INC     HL
            RLD                         ;Shift Carry bit out nibble into second
            JR      CLR_KEY_FLG         ;Redisplay and Key check

NMI_HANDLER:                            ;NMI at Address 0x0066
            PUSH    AF                  ;Save previous A
            IN      A,(00)              ;Read Keyboard port
            AND     1FH                 ;Mask unwanted bits
            LD      I,A                 ;Store Key in Interrup Register
            POP     AF                  ;Restore A
            RETN                        ;Go back to previous code before interrupt

;Subroutines
;Multiplex the Display
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

;Set the mode dots to address or data
SET_DOTS:                               ;Set indicator dots to Addr or Data
            LD      HL,DISP_BUFF_END    ;Point to end of display buffer
            LD      B,02H               ;2 Dots
            LD      A,(CONT_BUFF)       ;Get control buffer
            BIT     4,A                 ;Check mode
            JR      Z,DOT_SET           ;Jump if in Data mode
            DEC     HL                  ;Move to Address segments
            DEC     HL
            LD      B,04H               ;4 Dots

DOT_SET:
            SET     4,(HL)              ;Set Bit 4 (0x10) on existing segment
            DEC     HL                  ;Move to next address
            DJNZ    DOT_SET             ;Loop until done
            RET

;Make a beep (or 2)
RESET_TONES:
            CALL    KEY_TONE            ;For Reset, call KEY TONE twice

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

;Hex to Seven Segment lookup table
DISP_COD_TAB:
            DB      0EBH,28H,0CDH,0ADH,2EH,0A7H,0E7H,29H
            DB      0EFH,0AFH,6FH,0E6H,0C3H,0ECH,0C7H,47H

PTR_BUFF:   	EQU     0F06H      	;RAM location
CONT_BUFF:  	EQU     0F08H      	;Control byte
DISP_BUFF:  	EQU     0F00H      	;Display buffer
DISP_BUFF_END:	EQU     DISP_BUFF+5     ;Display buffer
