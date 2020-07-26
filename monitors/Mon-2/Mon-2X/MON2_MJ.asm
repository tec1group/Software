;***************************************
;*   MON2 for TEC-1 and compatibles    *
;***************************************
; Version 1.0
; Written by Ken Stone
; Decompiled by John Hardy
; Commented by Mark Jelic

;Keyboard functions:
;Shift-Insert range 0900 - 4000 (03FF??)
;Shift-Delete range 0900 - 03FF (03FF is set to 00 on use of delete
;function).
;Shift -Address jumps to location stored at 08D2 and 08D3


STACKSTART:     EQU $08C0               ; Stack Max Length C0
VECTOR0:        EQU $08C0               ; user vector 0
VECTOR1:        EQU $08C2               ; user vector 1
VECTOR2:        EQU $08C4               ; user vector 2
VECTOR3:        EQU $08C6               ; user vector 3
VECTOR4:        EQU $08C8               ; user vector 4
VECTOR5:        EQU $08CA               ; user vector 5
VECTOR6:        EQU $08CC               ; Temporary holder of current address?
X0:             EQU $08D0
SHIFTINS:       EQU $08D2
SHIFTDEL:       EQU $08D4
TUNEADDR:       EQU $08D6
MONADDRESS:     EQU $08D8               ; current address in nibbles over 4 bytes
ADDRESS0:       EQU $08D8
ADDRESS1:       EQU $08D9
ADDRESS2:       EQU $08DA
ADDRESS3:       EQU $08DB
DATA1:          EQU $08DC               ; Current byte in bibbles over two bytes
DATA2:          EQU $08DD               ; Current byte in nibblese to
MODE:           EQU $08DF               ; Monitor mode (0 = Address Mode, 1 = Data Mode)
KEYDATA:        EQU $08E0               ; Key data location updated by NMI routine
X3:             EQU $08E1                    
RAMSTART:       EQU $0900               ; User Code Start 0900


STARTROM:       ORG $0000
RESTART00:      jp STARTMON		         ; Jump to STARTMON @ $0200
                db $FF
                db $FF
                db $FF
                db $FF
                db $FF
RESTART08:      ld hl,(VECTOR0)          ;jump to vector stored at $08c0
                jp (hl)
                db $FF
                db $FF
                db $FF
                db $FF
RESTART10:      ld hl,(VECTOR1)          ;jump to vector stored at $08c2
                jp (hl)
                db $FF
                db $FF
                db $FF
                db $FF
RESTART18:      ld hl,(VECTOR2)          ;jump to vector stored at $08c4
                jp (hl)
                db $FF
                db $FF
                db $FF
                db $FF
RESTART20:      ld hl,(VECTOR3)         ;jump to vector stored at $08c6
                jp (hl)
                db $FF
                db $FF
                db $FF
                db $FF
RESTART28:      ld hl,(VECTOR4)         ;jump to vector stored at $08c8
                jp (hl)
                db $FF
                db $FF
                db $FF
                db $FF
RESTART30:      ld hl,(VECTOR5)         ;jump to vector stored at $08ca
                jp (hl)
                db $FF
                db $FF
                db $FF
                db $FF
RESTART38:      ld hl,(VECTOR6)         ;jump to vector stored at $08cc
                jp (hl)

NMINT:          ORG $066                ;NMI keyboard event
                push af                 ;save af ;good idea! fixes Mon1
                in a,($00)              ;a = key port
                ld (KEYDATA),a          ;save in ram
                pop af                  ;restore af
                retn                    ;correct return. fixes Mon1


SEVSEGDATA:     org $0080
                db $EB                  ; 0
                db $28                  ; 1
                db $CD                  ; 2
                db $AD                  ; 3
                db $2E                  ; 4
                db $A7                  ; 5
                db $E7                  ; 6
                db $29                  ; 7
                db $EF                  ; 8
                db $2F                  ; 9
                db $6F                  ; A
                db $E6                  ; B
                db $C3                  ; C
                db $EC                  ; D
                db $C7                  ; E
                db $47                  ; F
                db $E3                  ; G
                db $66                  ; H
                db $28                  ; I
                db $E8                  ; J
                db $4E                  ; K
                db $C2                  ; L
                db $2D                  ; M
                db $6B                  ; N
                db $EB                  ; O
                db $4F                  ; P
                db $2F                  ; Q
                db $4B                  ; R
                db $A7                  ; S
                db $46                  ; T
                db $EA                  ; U
                db $E0                  ; V
                db $AC                  ; W
                db $A4                  ; X
                db $AE                  ; Y
                db $C9                  ; Z
                db $10                  ; .
                db $08                  ; i
                db $18                  ; !
                db $04                  ; -
                db $2C                  ; 
                db $00                  ; space
                db $6E                  ; h
                db $CD                  ; Z
                db $FF
                db $FF
                db $FF
                db $FF

INITADDR:       db $00                  ;inital address (start of RAM)
                db $00                  ;0
                db $09                  ;9
                db $00                  ;0
                db $00                  ;0
                db $FF
                db $FF
                db $FF
                db $FF
                db $FF
                db $FF
                db $FF
                db $FF                

                db $f8                  ; An address?
                db $FF                  ; Not sure what this does.
                db $00                  ;
                db $00                  ;

DEMOTEXT:       ORG $00C0               ; Data table for text message demo.
                db $1b                  ; R
                db $18                  ; O
                db $1e                  ; U  
                db $1d                  ; T
                db $12                  ; I
                db $17                  ; N
                db $0e                  ; E
                db $29                  ; [space]
                db $0b                  ; B
                db $22                  ; Y
                db $29                  ; [space]
                db $17                  ; N   (Nic. Enots - Ken Stone's old programming pseudonym))
                db $12                  ; I
                db $0C                  ; C
                db $24                  ; .
                db $29                  ; [space]
                db $29                  ; [space]
                db $29                  ; [space]
                db $29                  ; [space]
                db $29                  ; [space]
                db $fe                  ; (repeat text)
                db $1c                  ; STONE  (Text for real surname hidden in code)
                db $1d
                db $18
                db $17
                db $0a
                db $ff                  ; (end text)
                db $FF
                db $FF
                db $FF
                db $FF
                db $FF
KEYPLUS:        call GETEDITADDR        ; PLUS key has been pressed
                inc bc
                jr DATAMODE
KEYMINUS:       call GETEDITADDR        ; MINUS key has been pressed
                dec bc
DATAMODE:       call SETEDITADDR
                call GETADDRDATA
                ld hl,MODE              ; Load HL with the MODE indicator address 
                set 0,(hl)              ; Sets bit 0 of the MODE indicator address to 1, indicating it IS in DATA mode
                res 1,(hl)              ; Sets bit 1 of the MODE indicator address to 0, indicating it is NOT in ADDRESS mode
                jp POP_HLAF             ; POPs registers HL and AF and Returns

                                        ; Division table for frequencies starts here
                                        ; First byte is the Length of the Tone, the second is the Frequency
                                        ; Higher Frequency tones loop/finish faster, so the Duration needs to be longer.
FRQTBL:         org $0100
                db $FD, $10
                db $10, $FD
                db $11, $EF
                db $12, $E1
                db $13, $D4                ; Changed from $1354 to $13D4 - MJ
                db $14, $C9
                db $15, $BE                ; Changed from $10BE to $15BE - MJ
                db $16, $B2                ; Changed from $10B2 to $16B2 - MJ
                db $17, $A9                ; Changed from $10A9 to $17A9 - MJ
                db $19, $9F
                db $1A, $96
                db $1C, $80
                db $1E, $86
                db $20, $7F
                db $22, $77
                db $24, $71
                db $26, $6A
                db $28, $64
                db $2A, $5F
                db $2D, $59
                db $2F, $54
                db $32, $50
                db $35, $4B
                db $38, $47
                db $3C, $43
                db $3F, $3F
                db $43, $3C
                db $47, $38
                db $4B, $35
                db $50, $32
                db $54, $2F
                db $59, $2D
                db $5F, $2A
                db $64, $28
                db $6A, $26
                db $71, $24
                db $77, $22
                db $7F, $20
                db $86, $1E
                db $8E, $1C
                db $96, $1A
                db $94, $19
                db $A9, $18
                db $B3, $16
                db $BE, $15
                db $C9, $14
                db $D5, $13
                db $E1, $12
                db $EF, $11
                db $FD, $10
                db $FF, $01                ; Changed from $FFFF to $FF01 - MJ

PLAYTONE:       org $0170               ; Subroutine that plays the note loaded in A         
                push bc                 ; save bc,de,hl,af
                push de
                push hl
                push af
                and a                   ; Set Z flag if A is Zero
                jr nz,PTnotZero         ; If the tone in A is 0,
                ld e,a                  ;   then Load E with A (which is Zero)
                jr PTZero               ;   and Jump Rel to PTZero
PTnotZero:      ld e,$80                ; Else Load E with 80h; high bit is speaker
PTZero:         ld hl,FRQTBL            ; Load HL with the base address of the division table for frequencies
                add a,a                 ; Frequencies are 2 bytes long, so multiply A (tone offset) by 2
                add a,l                 ; Add the now duplicated offset into L
                ld l,a                  ; Load the result of the addition in L, back into A
                ld c,(hl)               ; Load the duration of the Tone into C
                inc hl                  ; Point HL to the second byte of the freq divisor
LENGTHLOOP:     ld b,(hl)               ; Load the Frequency of the Tone into B
                ld a,e                  ; Load A with E (which is either $00 or $80)
                out ($01),a             ; Output A to Port 01
HIGHWAVE:       djnz HIGHWAVE           ; repeat while (--b > 0) - Length of high part of "waveform"
                ld b,(hl)               ; restore b
                xor a                   ; a = 0
                out ($01),a             ; speaker bit = 0
LOWWAVE:        djnz LOWWAVE            ; repeat while (--b > 0) - Length of low part of "waveform"
                dec c                   ; c--
                jr nz,LENGTHLOOP        ; if (c != 0) goto lengthloop
                pop af                  ; restore bc,de,hl,af
                pop hl
                pop de
                pop bc
                ret                     ; return

PLAYTUNE:       org $01A0               ; MUSIC routine.
                push af                 ; Save AF and HL registers
                push hl
STARTTUNE:      ld hl,(TUNEADDR)
LOADNOTE:       ld a,(hl)
                cp $FF                  ; If the tune loads a value of FF, signifies end of Tune
                jr nz,PLAYNOTE
                pop hl
                pop af
                ret
PLAYNOTE        cp $FE                  ; If the tune loads a value of FE, signifies to Repeat the Tune
                jr z,STARTTUNE
                inc hl
                call PLAYTONE           ; Subroutine that plays the note loaded in A
                jr LOADNOTE

KEYADDRESS:     org $01C0               ; The ADDRESS Key routine:
                ld hl,MODE              ; 
                bit 0,(hl)              ; Check if MODE-0 is ON
                jr nz,FLIPON            ;    turn it into DATA mode.
                set 0,(hl)              ; If not in ADDRESS mode, then make it so.
                res 1,(hl)
                jp POP_HLAF
FLIPON:         res 0,(hl)
                set 1,(hl)
                jp POP_HLAF             ; Restore HL and AF then return to calling function.

MPDISPLAY:      ORG $01d8               ; MULTIPASS DISPLAY
                push bc                 ; Save BC
                ld b,$80                ; B is used as the digit selector
                call DISPLAY            ; DISPLAY routine sets the segments according to the data and then lights them up
                djnz MPDISPLAY          ; Repeat $80 times
                pop bc                  ; Restore BC
                ret

KEYSHPLUS:      ld bc,(SHIFTINS)        ; Insert byte and shift up routine
                call SETEDITADDR
                call GETADDRDATA
                jp POP_HLAF

KEYSHMINUS:     ld bc,(SHIFTDEL)        ; Delete and shift down routine
                call SETEDITADDR
                call GETADDRDATA
                jp POP_HLAF

STARTMON:       ORG $0200                   ; Main monitor program entry point.
                ld (STACKSTART),sp          ; save stack point
                ld sp,RAMSTART              ; sp = RAMSTART
                push af                     ; save registers
                push bc
                push de
                push hl
                push ix
                push iy
                ex af,af'
                exx
                push af
                push bc
                push de
                push hl
                ld a,i
                push af
                xor a                       ; Clear A
                ld (VECTOR6),a              ; Load VECTOR6 with $0000
                ld (VECTOR6+1),a
                ld a,$ff
                ld (KEYDATA),a              ; Set the KEY buffer = $FF
                jp STARTMON2

STARTMON2       ld sp,STACKSTART            ; STACKSTART is at $08C0
                xor a                       ; Clear A
                out ($01),a                 ; Blank the Diplays
                out ($02),a                 ; (Should do this to ports 3 & 4 to clear the 8x8 as well)
                ld hl,INITADDR              ; Load HL with $0900, the initial start address
                ld de,MONADDRESS            ; Load DE with the display address pointer
                ld bc,$0005                 ; Load BC with 5
                ldir                        ; Copies the 5 (why 5??) bytes from HL to DEMOTEXT
BEEPMON:        call GETADDRDATA
                ld a,$08
                call PLAYTONE
                ld a,$0f
                call PLAYTONE
                ld a,$01
                ld (MODE),a
MAINLOOP:       call DISPLAY
                call GETKEY
                jr MAINLOOP

GETADDRDATA:    .org $0270                      ; Loads the data at the current Monitor pointed address
                                                ; and places it into the Display Buffer bytes for digits 1 and 0
                push af                         ; save registers
                push hl
                push bc
                call GETEDITADDR                ; Loads current address into BC (but is lost, later)
                and $f0                         ; Mask off the upper nibble
                rrca                            ; Rotate the byte to
                rrca                            ; move the upper nibble
                rrca                            ; to the lower nibble
                rrca
                ld (DATA1),a                    ; Load the left (high) nibble into DATA1 location
                ld a,(bc)
                and $0f                         
                ld (DATA2),a                    ; Load the right (low) nibble into DATA2 location
                pop bc
                pop hl
                pop af
                ret
;
; GETEDITADDR
; The address used by editor and shown on the 7 segment display is stored in one
; location only, to prevent a situation where displayed address and real address
; could differ. In a trade off in processing time, it was more efficient to store
; the address in the optimal form for the display routine. As such it needs
; converting to and from this format when used by the monitor program.
; The chosen location is the display buffer, where the address is broken into
; nibbles and spread accross four bytes, 08D8, 08D9, 08DA, 08db, MSN to LSN.
; GetEditorAddress (GETEDITADDR) is used to retrieve this address.
; The data held here is only valid while the monitor program is running. As soon as
; something else is written to the display it is lost. Resetting the computer
; restores it to the default 0900h.
;
; GetEditorAddress, when called, loads BC with the address currently held In the
; display buffer. It also loads A with the data held at the location addressed by BC.
;
; E.G. If the LED display shows 0900 CD, calling GETEDITADDR will load BC with 0900 (B is
; the MSB) and loads A with CD. This routine is not transparent. HL is destroyed. BC
; and A hold the results. If this routine is called during a user program that is not
; an extension to the monitor, the result will have no meaning.
;
GETEDITADDR:    ORG $0289
                ld hl,MONADDRESS
                ld a,(hl)
                rlca
                rlca
                rlca
                rlca
                inc hl
                add a,(hl)
                ld b,a
                inc hl
                ld a,(hl)
                rlca
                rlca
                rlca
                rlca
                inc hl
                add a,(hl)
                ld c,a
                ld a,(bc)
                ret

DISPLAY:        org $02A0
                push af                     ; Save the registers
                push hl
                push de
                push bc                     ; DE is loaded with the start of the 4 bytes holding
                ld de,MONADDRESS            ; the current Monitor Address being displayed
                xor a                       ; This code is repeated for each Digit
                out ($01),a                 ; Blank the display
                call HEX2SEG                ; Convert the nibble located at DE to into segments and store in A
                bit 1,(hl)                  ; Check Bit 1 of the MODE register (Address mode)
                jr z,NODOT1                 ; If we are in Address mode...
                set 4,a                     ;   Set segment 4 of the digit (decimal point indicating Address mode)
NODOT1:         out ($02),a                 ; Output A to the Segment port
                ld a,$20                    ; digit 020 (the left-most digit)
                out ($01),a                 ; output A to digit port
                ld b,$20
DELAY1:         djnz DELAY1
                xor a                       ; Repeat for 2nd address Digit
                out ($01),a
                call HEX2SEG
                bit 1,(hl)
                jr z,NODOT2
                set 4,a
NODOT2:         out ($02),a
                ld a,$10
                out ($01),a
                ld b,$20
DELAY2:         djnz DELAY2
                xor a                       ; Repeat for 3rd address Digit
                out ($01),a
                call HEX2SEG
                bit 1,(hl)
                jr z,NODOT3
                set 4,a
NODOT3:         out ($02),a
                ld a,$08
                out ($01),a
                ld b,$20
DELAY3:         djnz DELAY3
                xor a                       ; Repeat for 4th address Digit
                out ($01),a
                call HEX2SEG
                bit 1,(hl)
                jr z,NODOT4
                set 4,a   
NODOT4:         out ($02),a
                ld a,$04
                out ($01),a
                ld b,$20
DELAY4:         djnz DELAY4
                xor a                       ; Blank the displays one last time
                out ($01),a
                nop
                jp DISPLAY2

KEYGO:          call GETEDITADDR            ; GO button has been pressed
                push bc                     ; Use the stack to
                pop hl                      ; LD HL,BC
                ld sp,STACKSTART            ; Restart the stack
                jp (hl)                     ; Start executing code from the address loaded in HL

DISPLAY2:       call HEX2SEG                ; DISPLAY2 displays the two Data Digits (5th & 6th)
                bit 0,(hl)                  ; Check if we are in DATA mode
                jr z,$0321                  ; If we are then...
                set 4,a                     ; Set the dot to indicate DATA mode.
NODOT5:         out ($02),a                  
                ld a,$02
                out ($01),a
                ld b,$20
DELAY5:         djnz DELAY5
                xor A                       ; Repeat for 6th (2nd data) Digit
                out ($01),a
                call HEX2SEG
                bit 0,(hl)
                jr z,NODOT6
                set 4,a
NODOT6:         out ($02),a
                ld a,$01
                out ($01),a
                ld b,$20
DELAY6:         djnz DELAY6
                xor a
                out ($01),a                 ; Turn off the diplays
                pop bc                      ; restore registers
                pop de
                pop hl
                pop af
                ret                         ;return
 
; Hex2SevenSeg converts the Hex value (0 to 29) into the
; corresponding seven-segment data. It is part of the display routine.
; HL is destroyed, DE is incremented, A is converted from the value to its
; 7 segment form.

HEX2SEG:        org $0350               ; Hex2SevenSeg
                ld hl,SEVSEGDATA        ; HL pointing to start of 7seg data
                ld a,(de)               ; Load A with the contents of (de) - but what is at (de)?
                add a,l                 ; Add L to the contents of A
                ld l,a                  ; Then load A back into L
                ld a,(hl)               ; a = (hl + a)
                inc de                  ; de++
                ld hl,MODE              ; hl = mode
                ret                     ; return

GETKEY:         push af                 ; KEYDATA is the keyboard buffer address
                push hl                 ; which is filled with $FF after the key data is read
                ld hl,KEYDATA
                ld a,$ff                    
                cp (hl)                 ; if the buffer still holds $FF, 
                jr z,POP_HLAF           ; no key pressed and return
                ld a,(hl)               ;  a = (KEYDATA)
                and $1f                 ;  Mask off the high 3 bits
                bit 5,(hl)              ;  test if the Shift bit 5 is on
                jr nz,NOSHIFT           ;  if (shift) is on, then
                add a,$14               ;    add $14 to the contents of A
NOSHIFT:        jp KEYBLIP

POP_HLAF:       pop hl                  ;restore hl, af
                pop af
                ret

POP_HLAF2:      pop hl                  ; not sure why the above routine needs repeating; a JR correction?
                pop af
                ret
                                            ; Routine used to effectively delete a byte of data
SHIFTMEMDN:     call GETEDITADDR            ; by shifting all data above current address down one byte.
                                            ; BC has the current memory address.
                push bc                     ; Using the stack...
                pop ix                      ; Load IX with the contents of BC
LOOPDOWN:       inc ix                      ; Increment IX (so it points to Current+1)
                push ix                     ; Use stack to copy IX...
                pop hl                      ; and load it into HL
                ld a,h
                cp $40                      ; Check if we are at max memory address of $4000
                jr z,MAXMEM                 ; if so, then jump... else...
                ld a,(ix+0)                 ; Load A with data at (IX) which is Current+1
                ld (ix-1),a                 ; Save the data to the current memory location
                jr LOOPDOWN                 ; Loop back and do it again
MAXMEM:         ld a,$00                    ; Clear A
                ld ($3fff),a                ; Load $00 into the top memory location.
                call GETADDRDATA
                jp POP_HLAF

KEYBLIP:        add a,$01                   ; Not sure why $01 is added... Makes it a higher tone?
                call PLAYTONE               ; Key blip that goes higher for each key - Which is annoying, TBH
                jp WHICHKEY
                
SHIFTMEMUP:     call GETEDITADDR
                dec bc
                ld ix,$3ffe                 ; Select the 2nd to last byte and then
LOOPUP:         ld a,(ix+0)                 ; Copy it into the highest byte 
                ld (ix+1),a                 ; then repeat until the BC = HL
                dec ix
                push ix
                pop hl
                ld a,c
                cp l
                jr nz,LOOPUP                ; Repeat until C = L
                ld a,b
                cp h
                jr nz,LOOPUP                ; Repeat until B = H
                ld (ix+1),$00
                call GETADDRDATA
                jp POP_HLAF

RUNWRITING:     org $03d8;                  ; RUNNING WRITING
                push hl                     ; Save registers
                push af
                push ix
                push bc
                xor a                       ; Clear A
                ld (MODE),a                 ; Set MODE to 0
                ld b,$06                    ; Load B with 6 (number of display digits)
                ld hl,MONADDRESS            ; load HL with the current address pointer
                ld a,$29                    ; not sure why you'd load A with 29H ??
LOAD29H:        ld (hl),a                   ; Put A (with 29H) into (HL)
                inc hl                      ; 
                djnz LOAD29H                ; Loop 6 times
REPEATMSG:      ld hl,(DATA1)               ; org $3EC
LOADCHAR:       ld a,(hl)                   ; org $3EF
                cp $ff                      ; Is the character just loaded an $FF (signifies end of string)
                jr nz,STARTMSG              ;    If not, then JUMP to...
                pop BC                      ; otherwise restore the registers
                pop ix
                pop af
                pop hl
                ret                         ; and end the routine
STARTMSG:       cp $fe                      ; org $3FA
                jr z,REPEATMSG              ; if the character is $FE, this marks it as the Repeat message
                ld ix,MONADDRESS
                ld b,$05                    ; Loop count $05
DISROTL:        ld a,(ix+1)                 ; Rotate right 5 digits to the left
                ld (ix+0),a
                inc ix
                djnz DISROTL                ; Loop back till 5 digits done
                ld a,(hl)
                ld (DATA2),a
                inc hl
                ld b,$40                    ; Loop count $40
DISLOOP:        call DISPLAY                ; org $0415
                djnz DISLOOP                ; Multiplex the Display $40 times
                jr LOADCHAR

WHICHKEY:       sub $01                     ; Subtract the $01 that was added for the Key Blip
                ld (hl),$ff                 ; Reset the Keyboard buffer back to $FF
                bit 4,a                     ; Test if bit 4 (the control keys) is set
                jp nz,CTRLKEY               ;   If so, jumpt to the routine handling non-data keys
                bit 5,a                     ; Test if the SHIFT key is pressed
                jp nz,CTRLKEY               ;   If so, jumpt to the routine handling non-data keys
                ld hl,MODE
                bit 0,(hl)                  ; Check MODE-0
                jp z,MODE0OFF                   ;   Jump if MODE-0 is off
                ld d,a
                call GETEDITADDR
                ld hl,MODE
                bit 3,(hl)                  ; Is MODE-3 on?
                jr nz,MODE3ON               ; If so, then jump
                xor a                       ; Set A to 0
                set 3,(hl)                  ; Set MODE-3 to ON

MODE3ON:        rlca                        ; Rotate lower nibble to top
                rlca
                rlca
                rlca
                and $f0                     ; Mask off the lower data
                add a,d
                ld (bc),a
                call GETADDRDATA
                jp POP_HLAF

MODE0OFF:       ld d,a
                ld hl,MODE
                res 3,(hl)
                bit 4,(hl)
                jr nz,$0467
                ld bc,$0000
                call SETEDITADDR
                set 4,(hl)
                call GETEDITADDR
                ld a,b
                rlca
                rlca
                rlca
                rlca
                and $f0
                ld e,a
                ld a,c
                rlca
                rlca
                rlca
                rlca
                and $0f
                add a,e
                ld b,a
                ld a,c
                rlca
                rlca
                rlca
                rlca
                and $f0
                add a,d
                ld c,a
                call SETEDITADDR
                call GETADDRDATA
                jp POP_HLAF2                ; Jump to $037D

; SetEditorAddress 0490 is the opposite of the GetEditorAddress 0289 routine.
; It loads the display buffer (ADDRESS0, ADDRESS1, ADDRESS2, ADDRESS3) with the
; value held in BC. No registers affected.

SETEDITADDR:    org $0490                   ; SetEditorAddress
                push af                     ; save AF and HL
                push hl
                ld hl,MONADDRESS               ; HL points to ADDRESS buffer
                ld a,b                      ; a = b
                and $f0                     ; mask out lower nibble
                rlca                        ; rotate upper nibble into lower nibble
                rlca
                rlca
                rlca
                ld (hl),a                   ; (hl) = a
                inc hl                      ; hl++
                ld a,b                      ; a = b
                and $0f                     ; mask lower nibble
                ld (hl),a                   ; (hl) = a
                inc hl                      ; hl++
                ld a,c                      ; a = c
                and $f0                     ; mask upper nibble
                rlca                        ; rotate upper nibble into lower nibble
                rlca
                rlca
                rlca
                ld (hl),a                   ; (hl) = a
                inc hl                      ; hl++
                ld a,c                      ; a = c
                and $0f                     ; mask lower nibble
                ld (hl),a                   ; Save A into location (HL)
                pop hl                      ; restore hl, af
                pop af
                ret                         ; return

CTRLKEY:        org  $04c0                  ; A big CASE routine to determine which control key is pressed
                ld hl,MODE                  
                res 3,(hl)                  ; This modifies the MODE setting.
                res 4,(hl)
                cp $10
                jp z,KEYPLUS                ; The PLUS key was pressed
                cp $11
                jp z,KEYMINUS               ; The MINUS key was pressed
                cp $12
                jp z,KEYGO                  ; The GO button was pressed
                cp $13
                jp z,KEYADDRESS             ; The ADdress button was pressed
                cp $14
                jp z,SHIFTJUMP              ; The SHIFT and ADdress key is pressed
                cp $15
                jp z,$ffff
                cp $16
                jp z,$ffff
                cp $17
                jp z,KEYSHMINUS
                cp $18
                jp z,USERPOSTBURN            ; USER burnt routine in EPROM after release.
                cp $19
                jp z,$ffff
                cp $1a
                jp z,$ffff
                cp $1b
                jp z,$ffff
                cp $1c
                jp z,$0660
                cp $1d
                jp z,$ffff
                cp $1e
                jp z,$ffff
                cp $1f
                jp z,$ffff
                cp $20
                jp z,$ffff
                cp $21
                jp z,$ffff
                cp $22
                jp z,$ffff
                cp $23
                jp z,$ffff
                cp $24
                jp z,SHIFTMEMUP             ; The SHIFT and PLUS keys
                cp $25
                jp z,SHIFTMEMDN             ; The SHIFT and MINUS keys
                cp $26
                jp z,$ffff
                cp $27
                jp z,KEYSHPLUS
                jp POP_HLAF
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
                RST   $38
SHIFTJUMP:      call GETEDITADDR
                ld h,b
                ld l,c
                ld a,(X3)
LOOPJUMP:       inc hl
                cp (hl)
                jr nz,LOOPJUMP
                ld b,h
                ld c,l
                call SETEDITADDR
                jp BEEPMON

USERPOSTBURN:   org $0570
                db $00