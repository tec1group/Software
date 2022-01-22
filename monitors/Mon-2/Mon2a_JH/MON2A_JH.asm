;***************************************
;*   MON2 for TEC-1 and compatibles    *
;***************************************
; Version A
; Written by Ken Stone
; Decompiled by John Hardy
; Commented and optimised by Mark Jelic

;Keyboard functions:
;Shift-Insert range 0900 - 4000 (03FF??)
;Shift-Delete range 0900 - 03FF (03FF is set to 00 on use of delete function).
;Shift-Address jumps to location stored at 08D2 and 08D3
;
;Info:
;Stack Start 08C0
;Stack Max Length C0
;User Code Start 0900
;KeyData location 08E0 (placed there by NMI routine)

STACKSTART:     EQU $08C0               ; Stack Max Length C0
VECTOR0:        EQU $08C0               ; user vector 0
VECTOR1:        EQU $08C2               ; user vector 1
VECTOR2:        EQU $08C4               ; user vector 2
VECTOR3:        EQU $08C6               ; user vector 3
VECTOR4:        EQU $08C8               ; user vector 4
VECTOR5:        EQU $08CA               ; user vector 5
VECTOR6:        EQU $08CC               ; Temporary holder of current address?
SHIFTINS:       EQU $08D2
SHIFTDEL:       EQU $08D4
TUNEADDR:       EQU $08D6
ADDRESS1:       EQU $08D8               ; current ADDRESS in nibbles over 4 bytes
ADDRESS2:       EQU $08D9               ; current ADDRESS - nibble #2
ADDRESS3:       EQU $08DA               ; current ADDRESS - nibble #3
ADDRESS4:       EQU $08DB               ; current ADDRESS - nibble #4
DATA1:          EQU $08DC               ; Current DATA in nibbles over two bytes
DATA2:          EQU $08DD               ; Current DATA - second nibble
MODE:           EQU $08DF               ; Monitor mode (0 = Address Mode, 1 = Data Mode)
KEYDATA:        EQU $08E0               ; Key data location updated by NMI routine
X3:             EQU $08E1
RAMSTART:       EQU $0900               ; User Code Start 0900


STARTROM:       .ORG $0000
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

                .ORG $066               ;NMI keyboard event
NMINT:          push af                 ;save af ;good idea! fixes Mon1
                push bc                 ;save BC
                push hl                 ;save HL (used in Keyboard Remap)
                IN A,($00)              ;a = key port
                LD B,A                  ;save A to B
                call KEYREMAP
                pop hl                  ;restore hl
                pop bc                  ;restore BC
                pop af                  ;restore af
                retn                    ;correct return. fixes Mon1

                .ORG $0080
SEVSEGDATA:     db $EB                  ; 0
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

                .ORG $00B0
INITADDR:       db $00                  ;0 inital address (start of RAM)
                db $09                  ;9
                db $00                  ;0
                db $00                  ;0

                .ORG $00C0              ; Data table for text message demo.
DEMOTEXT:       db $1b                  ; R
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
                db $0E
                db $ff                  ; (end text)
                db $FF
                db $FF
                db $FF
                db $FF
                db $FF
KEYPLUS:        call GETEDITADDR        ;+ key
                inc bc
                jr DATAMODE
KEYMINUS:       call GETEDITADDR        ;- key
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
.ORG $0100
FRQTBL:         db $09, $FE
                db $10, $FD
                db $11, $EF
                db $12, $E1
                db $13, $D4
                db $14, $C9
                db $15, $BE
                db $16, $B2
                db $17, $A9
                db $19, $9F
                db $1A, $96
                db $1C, $8E
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
                db $9F, $19
                db $A9, $17
                db $B2, $16
                db $BE, $15
                db $C9, $14
                db $D4, $13
                db $E1, $12
                db $EF, $11
                db $FD, $10
                db $FE, $09

                .ORG $0170              ; a is the tone number
PLAYTONE:       push bc                 ; save bc,de,hl,af
                push de
                push hl
                push af
                and a                   ; Set Zero flag if A is Zero
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

                .ORG $01A0              ; MUSIC routine.
PLAYTUNE:       push af
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

                .ORG $01C0              ; The ADDRESS Key routine:
KEYADDRESS:     ld hl,MODE              ; If currently in ADDRESS mode
                bit 0,(hl)              ; then change the MODE bits to
                jr nz,FLIPON            ; turn it into DATA mode.
                set 0,(hl)              ; If not in ADDRESS mode, then make it so.
                res 1,(hl)
                jp POP_HLAF
FLIPON:         res 0,(hl)
                set 1,(hl)
                jp POP_HLAF             ; Restore HL and AF then return to calling function.

                .ORG $01d8              ; MULTIPASS DISPLAY
                push bc                 ; Save BC
                ld b,$80                ; B is used as the digit selector
MPDISPLAY:      call DISPLAY            ; DISPLAY routine sets the segments according to the data and then lights them up
                djnz MPDISPLAY          ; Repeat for each digit
                pop bc                  ; Restore BC
                ret
                db $FF
                db $FF

KEYSHPLUS:      ld bc,(SHIFTINS)
                call SETEDITADDR
                call GETADDRDATA
                jp POP_HLAF
                db $FF

KEYSHMINUS:     ld bc,(SHIFTDEL)        ; Delete and shift down routine
                call SETEDITADDR
                call GETADDRDATA
                jp POP_HLAF

.ORG $0200                              ; Main monitor program entry point.
STARTMON:
                ld HL,$0000             ; Clear the data in VECTOR6
                Ld (VECTOR6), HL
                ld a,$ff
                ld (KEYDATA),a          ; Set the KEY buffer = $FF
                ld sp,STACKSTART        ; Set stack pointer to $08C0
                xor a                   ; Clear A
                out ($01),a             ; Blank the Diplays
                out ($02),a             ; (Do this to ALL ports to clear the 8x8 as well)
                out ($03),a
                out ($04),a
                out ($05),a
                out ($06),a
                out ($07),a
                ld hl,INITADDR          ; Load HL with $0900, the initial start address
                ld de,ADDRESS1          ; Load DE with the display address pointer
                ld bc,$0005             ; Load BC with 5
                ldir                    ; Copies the 5 (why 5??) bytes from HL to DEMOTEXT
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

GETADDRDATA:    push af                 ; Loads the data at the current Monitor pointed address
                push hl                 ; and places it into the Display Buffer bytes for digits 1 and 0
                push bc                 ; save registers
                call GETEDITADDR        ; Loads current address into BC (but is lost, later)
                and $f0                 ; Mask off the upper nibble. Rotate the byte to move the upper nibble to the lower nibble
                rrca
                rrca
                rrca
                rrca
                ld (DATA1),a            ; Load the left (high) nibble into DATA1 location
                ld a,(bc)
                and $0f
                ld (DATA2),a            ; Load the right (low) nibble into DATA2 location
                pop bc
                pop hl
                pop af
                ret

;GetEditorAddress
;The address used by editor and shown on the 7 segment display is stored in one
;location only, to prevent a situation where displayed address and real address
;could differ. In a trade off in processing time, it was more efficient to store
;the address in the optimal form for the display routine. As such it needs
;converting to and from this format when used by the monitor program.
;The chosen location is the display buffer, where the address is broken into
;nibbles and spread across four bytes, 08D8, 08D9, 08DA, 08db, MSN to LSN.
;GetEditorAddress is used to retrieve this address.
;The data held here is only valid while the monitor program is running. As soon as
;something else is written to the display it is lost. Resetting the computer
;restores it to the default 0900h.
;
;GetEditorAddress, when called, loads BC with the address currently held In the
;display buffer. It also loads A with the data held at the location addressed by BC.
;
; E.G. If the LED display shows 0900 CD, calling GETEDITADDR will load BC with 0900 (B is
;the MSB) and loads A with CD. This routine is not transparent. HL is destroyed. BC
;and A hold the results. If this routine is called during a user program that is not
;an extension to the monitor, the result will have no meaning.
GETEDITADDR:    ld hl,ADDRESS1
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

                .ORG $02A0
DISPLAY:        push af                 ;save registers
                push hl
                push de
                push bc                 ;DE is loaded with the start of the 4 bytes holding
                ld de,ADDRESS1          ;the current Monitor Address being displayed
                xor a                   ;a = 0
                out ($01),a             ;clear digit port
                call HEX2SEG            ;Convert the nibble located at DE to into segments and store in A
                bit 1,(hl)              ;Check Bit 1 of the MODE register (Address mode)
                jr z,NODOT1             ;If we are in Address mode...
                set 4,a                 ;set segment 4 of digit (decimal point indicating Address mode)
NODOT1:         out ($02),a             ;output a to segment port
                ld a,$20                ;digit 020 (the left-most digit)
                out ($01),a             ;output a to digit port
                ld b,$20                ;loop count of 20
DELAY1:         djnz DELAY1             ;Allow a count of 20 to show display
                xor a                   ;Repeat for 2nd address Digit
                out ($01),a             ;clear digit port
                call HEX2SEG            ;
                bit 1,(hl)              ;
                jr z,NODOT2             ;
                set 4,a                 ;
NODOT2:         out ($02),a             ;output a to segment port
                ld a,$10                ;digit 010
                out ($01),a             ;output a to digit port
                ld b,$20                ;
DELAY2:         djnz DELAY2             ;delay by 20
                xor a                   ;
                out ($01),a             ;clear digit port
                call HEX2SEG            ;
                bit 1,(hl)              ;
                jr z,NODOT3             ;
                set 4,a                 ;
NODOT3:         out ($02),a             ;output a to segment port
                ld a,$08                ;digit 080
                out ($01),a             ;output a to digit port
                ld b,$20                ;
DELAY3:         djnz DELAY3               ;delay by 20
                xor a                   ;
                out ($01),a             ;clear digit port
                call HEX2SEG            ;
                bit 1,(hl)              ;
                jr z,NODOT4             ;
                set 4,a
NODOT4:         out ($02),a             ;output a to segment port
                ld a,$04                ;digit 040
                out ($01),a             ;output a to digit port
                ld b,$20
DELAY4:         djnz DELAY4             ;delay by 20
                xor a                   ;
                out ($01),a             ;clear digit port
                nop                     ;
                jp DISPLAY2

KEYGO:          call GETEDITADDR        ; GO button has been pressed
                push bc                 ; Use the stack to
                pop hl                  ; LD HL with BC
                ld sp,STACKSTART
                jp (hl)                 ; Start executing code from the address loaded in HL

                .ORG $0318              ;
DISPLAY2:       call HEX2SEG            ; DISPLAY2 displays the two Data Digits (5th & 6th)
                bit 0,(hl)              ; Check if we are in DATA mode
                jr z,$0321              ; If we are then...
                set 4,a                 ; Set the dot to indicate DATA mode.
NODOT5:         out ($02),a
                ld a,$02                ;digit 020
                out ($01),a             ;output a to digit port
                ld b,$20
DELAY5:         djnz DELAY5             ;delay by 20
                xor a
                out ($01),a             ;clear digit port
                call HEX2SEG
                bit 0,(hl)
                jr z,NODOT6
                set 4,a
NODOT6:         out ($02),a
                ld a,$01                ;digit 040
                out ($01),a             ;output a to digit port
                ld b,$20
DELAY6:         djnz DELAY6             ;delay by 20
                xor a
                out ($01),a             ;clear digit port
                pop bc                  ;restore registers
                pop de
                pop hl
                pop af
                ret                     ;return

;Hex2SevenSeg converts the Hex value (0 to 29) into the
;corresponding seven-segment data. It is part of the display routine.
;HL is destroyed, DE is incremented, A is converted from the value to its
;7 segment form.
                .ORG $0350              ;Hex2SevenSeg
HEX2SEG:        ld hl,SEVSEGDATA        ;HL pointing to start of 7seg data
                ld a,(de)               ;Load A with the contents of (de) - but what is at (de)?
                add a,l                 ;Add L to the contents of A
                ld l,a                  ;Then load A back into L
                ld a,(hl)               ;a = (hl + a)
                inc de                  ;de++
                ld hl,MODE              ;hl = mode
                ret                     ;return

GETKEY:         push af                 ; KEYDATA is the keyboard buffer address
                push hl                 ; which is filled with $FF after the key data is read
                ld hl,KEYDATA           ;hl = KEYDATA
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

                                        ; Routine used to effectively delete a byte of data
SHIFTMEMDN:     call GETEDITADDR        ; by shifting all data above current address down one byte.
                                        ; BC has the current memory address.
                push bc                 ; Using the stack...
                pop ix                  ; Load IX with the contents of BC
LOOPDOWN:       inc ix                  ; Increment IX (so it points to Current+1)
                push ix                 ; Use stack to copy IX...
                pop hl                  ; and load it into HL
                ld a,h
                cp $40                  ; Check if we are at max memory address of $4000
                jr z,MAXMEM             ; if so, then jump... else...
                ld a,(ix+0)             ; Load A with data at (IX) which is Current+1
                ld (ix-1),a             ; Save the data to the current memory location
                jr LOOPDOWN             ; Loop back and do it again

MAXMEM:         ld a,$00                ; Clear A
                ld ($3fff),a            ; Load $00 into the top memory location.
                call GETADDRDATA
                jp POP_HLAF

KEYBLIP:        add a,$01               ; Not sure why $01 is added... Makes it a higher tone?
                call PLAYTONE           ; Key blip that goes higher for each key - Which is annoying, TBH
                jp WHICHKEY

SHIFTMEMUP:     call GETEDITADDR
                dec bc
                ld ix,$3ffe             ; Select the 2nd to last byte and then
LOOPUP:         ld a,(ix+0)             ; Copy it into the highest byte
                ld (ix+1),a             ; then repeat until the BC = HL
                dec ix
                push ix
                pop hl
                ld a,c
                cp l
                jr nz,LOOPUP            ; Repeat until C = L
                ld a,b
                cp h
                jr nz,LOOPUP            ; Repeat until B = H
                ld (ix+1),$00
                call GETADDRDATA
                jp POP_HLAF

                .ORG $03d8              ; RUNNING WRITING
RUNWRITING:     push hl                 ; Save registers
                push af
                push ix
                push bc
                xor a                   ; Clear A
                ld (MODE),a             ; Set MODE to 0
                ld b,$06                ; Load B with 6 (number of display digits)
                ld hl,ADDRESS1          ; load HL with the current user memory address
                ld a,$29                ; not sure why you'd load A with 29H ??
LOAD29H:        ld (hl),a               ; Put A (with 29H) into (HL)
                inc hl                  ;
                djnz LOAD29H            ; Loop 6 times
REPEATMSG:      ld hl,(DATA1)           ;
LOADCHAR:       ld a,(hl)               ;
                cp $ff                  ; Is the character just loaded an $FF (signifies end of string)
                jr nz,STARTMSG          ;    If not, then JUMP to...
                pop BC                  ; otherwise restore the registers
                pop ix
                pop af
                pop hl
                ret                     ; and end the routine
STARTMSG:       cp $fe                  ; org $3FA
                jr z,REPEATMSG          ; if the character is $FE, this marks it as the Repeat message
                ld ix,ADDRESS1
                ld b,$05                ; Loop count $05
DISROTL:        ld a,(ix+1)             ; Rotate right 5 digits to the left
                ld (ix+0),a
                inc ix
                djnz DISROTL            ; Loop back till 5 digits done
                ld a,(hl)
                ld (DATA2),a
                inc hl
                ld b,$40                ; Loop count $40
DISLOOP:        call DISPLAY            ; org $0415
                djnz DISLOOP            ; Multiplex the Display $40 times
                jr LOADCHAR

WHICHKEY:       sub $01                 ; Subtract the $01 that was added for the Key Blip
                ld (hl),$ff             ; Reset the Keyboard buffer back to $FF
                bit 4,a                 ; Test if bit 4 (the control keys) is set
                jp nz,CTRLKEY           ;   If so, jumpt to the routine handling non-data keys
                bit 5,a                 ; Test if the SHIFT key is pressed
                jp nz,CTRLKEY           ;   If so, jumpt to the routine handling non-data keys
                ld hl,MODE
                bit 0,(hl)              ; Check MODE-0
                jp z,MODE0OFF           ;   Jump if MODE-0 is off
                ld d,a
                call GETEDITADDR
                ld hl,MODE
                bit 3,(hl)              ; Is MODE-3 on?
                jr nz,MODE3ON           ; If so, then jump
                xor a                   ; Set A to 0
                set 3,(hl)              ; Set MODE-3 to ON
MODE3ON:        rlca                    ; Rotate lower nibble to top
                rlca
                rlca
                rlca
                and $f0                 ; Mask off the lower data
                add a,d
                ld (bc),a
                call GETADDRDATA
                jp POP_HLAF

                .ORG $0455              ;
MODE0OFF:       ld d,a
                ld hl,MODE
                res 3,(hl)
                bit 4,(hl)
                jr nz,MODEJUMP
                ld bc,$0000
                call SETEDITADDR
                set 4,(hl)
MODEJUMP:       call GETEDITADDR
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
                jp POP_HLAF

;SetEditorAddress is the opposite of the GetEditorAddress routine.
;It loads the display buffer (ADDRESS1 - ADDRESS4) with the
;value held in BC. No registers affected.

                .ORG $0490               ;SetEditorAddress
SETEDITADDR:    push af                 ;save af, hl
                push hl
                ld hl,ADDRESS1          ;hl points to ADDRESS buffer
                ld a,b                  ;a = b
                and $f0                 ;mask out lower nibble
                rlca                    ;rotate upper nibble into lower nibble
                rlca
                rlca
                rlca
                ld (hl),a               ;(hl) = a
                inc hl                  ;hl++
                ld a,b                  ;a = b
                and $0f                 ;mask lower nibble
                ld (hl),a               ;(hl) = a
                inc hl                  ;hl++
                ld a,c                  ;a = c
                and $f0                 ;mask upper nibble
                rlca                    ;rotate upper nibble into lower nibble
                rlca
                rlca
                rlca
                ld (hl),a               ;(hl) = a
                inc hl                  ;hl++
                ld a,c                  ;a = c
                and $0f                 ;mask lower nibble
                ld (hl),a               ;Save A into location (HL)
                pop hl                  ;restore hl, af
                pop af
                ret                     ;return

                .ORG $04C0               ;
CTRLKEY:        ld hl,MODE                  ; A big CASE routine to determine which control key is pressed
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

                .ORG $0570
USERPOSTBURN:   db $00

.ORG $0700                              ;Keyboard Remap Data
                DB $00, $01, $02, $03   ;This key map is the original TEC-1 layout.
                DB $04, $05, $06, $07   ;Keep the same data structure, but change the
                DB $08, $09, $0A, $0B   ;values to REMAP the data read from the 74C923
                DB $0C, $0D, $0E, $0F   ;to any keyboard layout you wish.
                DB $10                  ;Plus Key
                DB $11                  ;Minus Key
                DB $12                  ;Go Key
                DB $13                  ;Address Key

;.ORG $0700                              ;An Alternative Keyboard Map with Monitor Keys on the right.
;                DB $0F, $02, $05, $08   ;
;                DB $0E, $03, $06, $09   ;
;                DB $0D, $0C, $0B, $0A   ;
;                DB $10, $11, $12, $13   ;
;                DB $00                  ;Plus Key
;                DB $01                  ;Minus Key
;                DB $04                  ;Go Key
;                DB $07                  ;Address Key

.ORG $0720                              ;Remap keys to Table specified @ $0700
KEYREMAP:       AND $1f                 ;mask lower 5 bits
                LD H, $07               ;Use the table at $0700 to load A with a key value
                LD L, A
                LD A, (HL)
                BIT 5,B                 ;Test if Shift Key was pressed
                JR Z, SAVEKEY           ;Shift is pressed - Skip next line
                SET 5,A                 ;Set Bit 5 High to avoid Shift processing
SAVEKEY:        ld (KEYDATA),a          ;save A into ram
                ret

.ORG $07F0                              ;VERSION DATA
VERSION:        .DB     "MON2.A1 "
                .DB     "2022.MJ "