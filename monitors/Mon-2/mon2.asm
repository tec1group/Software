;Keyboard functions:
;Shift-Insert range 0900 - 4000 (03FF??)
;Shift-Delete range 0900 - 03FF (03FF is set to 00 on use of delete
;function).
;Shift -Address jumps to location stored at 08D2 and 08D3
;
;Info:
;Stack Start 08C0
;Stack Max Length C0
;User Code Start 0900
;KeyData location 08E0 (placed there by NMI routine)

STARTSTACK:     EQU $08C0               ; Stack Max Length C0
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
ADDRESS:        EQU $08D8               ; current address in nibbles over 4 bytes
ADDRESS0:       EQU $08D8
ADDRESS1:       EQU $08D9
ADDRESS2:       EQU $08DA
ADDRESS3:       EQU $08DB
X1:             EQU $08DC
X2:             EQU $08DD
MODE:           EQU $08DF               ; Monitor mode (0 = Address Mode, 1 = Data Mode)
KEYDATA:        EQU $08E0               ; Key data location updated by NMI routine
X3:             EQU $08E1
STARTRAM:       EQU $0900               ; User Code Start 0900


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
                db $FF                  ;
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


FRQTBL:         dw $fd  $10               ;(division table for frequencies)
                db $10, $FD
                db $11, $EF
                db $12, $E1
                db $13, $54
                db $14, $C9
                db $10, $BE
                db $10, $B2
                db $10, $A9
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
                db $FF, $FF

PLAYTONE:       org $0170               ; a is the tone number          
                push bc                 ; save bc,de,hl,af
                push de
                push hl
                push af
                and a                   ; Set Z Flag
                jr nz,ptAisnotzero      ; If not zero, Jump Rel to ptAisnotzero
                ld e,a                  ; Clear E
                jr ptAiszero            ; Jump Rel to ptzero
ptAisnotzero:   ld e,$80                ; Load E with 80h; high bit is speaker
ptAiszero:      ld hl,FRQTBL            ; (^division table for frequencies)
                add a,a                 ; offset a words into table
                add a,l                 ; l += a * 2
                ld l,a                  ;
                ld c,(hl)               ; bc = (hl) ;freq division
                inc hl                  ;
LENGTHLOOP:     ld b,(hl)               ;
                ld a,e                  ; a = e
                out ($01),a             ; speaker bit = 1
TONELOOP:       djnz TONELOOP           ; repeat while (--b > 0)
                ld b,(hl)               ; restore b
                xor a                   ; a = 0
                out ($01),a             ; speaker bit = 0
TONELOOP2:      djnz TONELOOP2          ; repeat while (--b > 0)
                dec c                   ; c--
                jr nz,LENGTHLOOP        ; if (c != 0) goto lengthloop
                pop af                  ; restore bc,de,hl,af
                pop hl
                pop de
                pop bc
                ret                     ; return

PLAYTUNE:       org $01A0               ; MUSIC routine.
                push af
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
                ld hl,MODE              ; If currently in ADDRESS mode
                bit 0,(hl)              ; then change the MODE bits to
                jr nz,FLIPON            ; turn it into DATA mode.
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
                djnz MPDISPLAY          ; Repeat for each digit
                pop bc                  ; Restore BC
                ret

KEYSHPLUS:      ld bc,(SHIFTINS)
                call SETEDITADDR
                call GETADDRDATA
                jp POP_HLAF

KEYSHMINUS :    ld bc,(SHIFTDEL)        ; Seems to be the same thing as above ???
                call SETEDITADDR
                call GETADDRDATA
                jp POP_HLAF

STARTMON:       ORG $0200               ; Main monitor program entry point.
                ld (STORESP),sp         ; save stack point
                ld sp,RAMSTART          ; sp = RAMSTART
                push af                 ; save registers
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
                ld de,ADDRESS               ; Load DE with the display address pointer
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

GETADDRDATA:    .org $0270                  ; 
                push af                     ; save registers
                push hl
                push bc
                call GETEDITADDR
                and $f0
                rrca
                rrca
                rrca
                rrca
                ld (X1),a                   ; X1 and X2... Are they the DATA display buffers?
                ld a,(bc)
                and $0f
                ld (X2),a
                pop bc
                pop hl
                pop af
                ret
;
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
; E.G. If the LED display shows 0900 CD, calling 0289 will load BC with 0900 (B is
;the MSB) and loads A with CD. This routine is not transparent. HL is destroyed. BC
;and A hold the results. If this routine is called during a user program that is not
;an extension to the monitor, the result will have no meaning.
;
GETEDITADDR:    ORG $0289
                ld hl,ADDRESS
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
                push af                 ;save registers
                push hl
                push de
                push bc
                ld de,ADDRESS           ;de = ADDRESS buffer
                xor a                   ;a = 0
                out ($01),a            ;clear digit port
                call HEX2SEG            ;convert (de) to segments -> a
                bit 1,(hl)              ;check mode bit 1
                jr z,L2B3               ;if set
                set 4,a                 ;  set segment 4 of digit (decimal point)
L2B3:           out ($02),a            ;output a to segment port
                ld a,$20               ;digit 020
                out ($01),a            ;output a to digit port
                ld b,$20               ;
L2BB:           djnz L2BB               ;delay by 20
                xor a                   ;
                out ($01),a            ;clear digit port
                call HEX2SEG            ;
                bit 1,(hl)              ;
                jr z,L2C9               ;
                set 4,a                 ;
L2C9:           out ($02),a            ;output a to segment port
                ld a,$10               ;digit 010
                out ($01),a            ;output a to digit port
                ld b,$20               ;
L2D1:           djnz L2D1               ;delay by 20
                xor a                   ;
                out ($01),a            ;clear digit port
                call HEX2SEG            ;
                bit 1,(hl)              ;
                jr z,L2DF               ;
                set 4,a                 ;
L2DF:           out ($02),a            ;output a to segment port
                ld a,$08               ;digit 080
                out ($01),a            ;output a to digit port
                ld b,$20               ;
L2E7:           djnz L2E7               ;delay by 20
                xor a                   ;
                out ($01),a            ;clear digit port
                call HEX2SEG            ;
                bit 1,(hl)              ;
                jr z,L2F5               ;
                set 4,a   
                                        ;
L2F5:           out ($02),a            ;output a to segment port
                ld a,$04               ;digit 040
                out ($01),a            ;output a to digit port
                ld b,$20  
                                        ;
L2FD:           djnz L2FD               ;delay by 20
                xor a                   ;
                out ($01),a            ;clear digit port
                nop                     ;
                jp DISPLAY2

GOADDR:         call GETEDITADDR        ;go to current address
                push bc
                pop hl
                ld sp,STACKSTART
                jp (hl)

DISPLAY2:       call HEX2SEG
                bit 0,(hl)
                jr z,$0321
                set 4,a
                out ($02),a
                ld a,$02               ;digit 020
                out ($01),a            ;output a to digit port
                ld b,$20
                djnz $0329             ;delay by 20
                xor a
                out ($01),a            ;clear digit port
                call HEX2SEG
                bit 0,(hl)
                jr z,$0337
                set 4,a
                out ($02),a
                ld a,$01               ;digit 040
                out ($01),a            ;output a to digit port
                ld b,$20
                djnz $033f             ;delay by 20
                xor a
                out ($01),a            ;clear digit port
                pop bc                  ;restore registers
                pop de
                pop hl
                pop af
                ret                     ;return
 
;Hex2SevenSeg converts the Hex value (0 to 29) into the ;
;corresponding seven-segment data. It is part of the display ;
;destroyed, DE is incremented, A is converted from the value to its
;7 segment form.

HEX2SEG:        org $0350              ;Hex2SevenSeg
                ld hl,SEVSEGDATA        ;hl = 7seg table
                ld a,(de)               ;a = (de)
                add a,l                 ;hl += a
                ld l,a
                ld a,(hl)               ;a = (hl + a)
                inc de                  ;de++
                ld hl,MODE              ;hl = mode
                ret                     ;return

GETKEY:         push af                 ;save af, hl
                push hl
                ld hl,KEYDATA           ;hl = KEYDATA
                ld a,$ff
                cp (hl)
                jr z,POP_HLAF           ;if (key)
                ld a,(hl)               ;  a = (KEYDATA)
                and $1f                ;  a = a & 1f
                bit 5,(hl)              ;  test shift bit
                jr nz,L373              ;  if (shift)
                add a,$14              ;    a += $0014
L373:           jp L3A8

POP_HLAF:       pop hl                  ;restore hl, af
                pop af
                ret

L37D:           pop hl                  ; not sure why the above routine needs repeating
                pop af
                ret

L384:           call GETEDITADDR
                push bc
                pop ix
L38A:           inc ix
                push ix
                pop hl
                ld a,h
                cp $40
                jr z,MAXMEM
                ld a,(ix+0)
                ld (ix-1),a
                jr L38A
                
MAXMEM:         ld a,$00
                ld ($3fff),a           ; Testing how much memory is installed?
                call GETADDRDATA
                jp POP_HLAF

L3A8:           add a,$01
                call PLAYTONE
                jp L421
                
L3B0:           call GETEDITADDR
                dec bc
                ld ix,$3ffe             ; strange address to load from, if you don't have max memory

L3B8:           ld a,(ix+0)
                ld (ix+1),a
                dec ix
                push ix
                pop hl
                ld a,c
                cp l
                jr nz,L3B8
                ld a,b
                cp h
                jr nz,L3B8
                ld (ix+1),$00
                call GETADDRDATA
                jp POP_HLAF

RUNWRITING:     org $03d8;             RUNNING WRITING
                push hl                 ; Save registers
                push af
                push ix
                push bc
                xor a                   ; Clear contents of A
                ld (MODE),a             ; Set MODE to 0
                ld b,$06                ; 6 display digits
                ld hl,ADDRESS           ; load HL with the current user memory address
                ld a,$29                ; not sure why you'd load A with 29H ??
LOAD29H:        ld (hl),a               ; Put A (with 29H) into (HL) that points to the 
                inc hl                  ; 
                djnz LOAD29H            ; Loop 6 times
L3EC:           ld hl,(X1)
L3EF:           ld a,(hl)
                cp $ff                  ; Is the character just loaded an $FF ?
                jr nz,L3FA              ; If not, then JUMP to...
                pop BC                  ; otherwise restore the registers
                pop ix
                pop af
                pop hl
                ret
L3FA:           cp $fe
                jr z,L3EC
                ld ix,ADDRESS
                ld b,$05
                ld a,(ix+1)
                ld (ix+0),a
                inc ix
                djnz $0404
                ld a,(hl)
                ld (X2),a
                inc hl
                ld b,$40
L415:           call DISPLAY
                djnz L415
                jr L3EF

 L421:          sub $01
                ld (hl),$ff
                bit 4,a
                jp nz,$04c0
                bit 5,a
                jp nz,$04c0
                ld hl,MODE
                bit 0,(hl)
                jp z,L455
                ld d,a
                call GETEDITADDR
                ld hl,MODE
                bit 3,(hl)
                jr nz,L445
                xor a
                set 3,(hl)

L445:           rlca
                rlca
                rlca
                rlca
                and $f0
                add a,d
                ld (bc),a
                call GETADDRDATA
                jp POP_HLAF2

L455:           ld d,a
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
                jp L37D

;SetEditorAddress 0490 is the opposite of the GetEditorAddress 0289 routine.
;It loads the display buffer (ADDRESS0, ADDRESS1, ADDRESS2, ADDRESS3) with the
;value held in BC. No registers affected.

SETEDITADDR:    org $0490               ;SetEditorAddress
                push af                 ;save af, hl
                push hl
                ld hl,ADDRESS           ;hl points to ADDRESS buffer
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
                ld (hl),a               ;(hl) = a
                pop hl                  ;restore hl, af
                pop af
                ret                     ;return

                ld hl,MODE
                res 3,(hl)
                res 4,(hl)
                cp $10
                jp z,KEYPLUS
                cp $11
                jp z,KEYMINUS
                cp $12
                jp z,GOADDR
                cp $13
                jp z,KEYADDRESS
                cp $14
                jp z,L550
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
                jp z,L3B0
                cp $25
                jp z,L384
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
L550:           call GETEDITADDR
                ld h,b
                ld l,c
                ld a,(X3)
L558:           inc hl
                cp (hl)
                jr nz,L558
                ld b,h
                ld c,l
                call SETEDITADDR
                jp BEEPMON

USERPOSTBURN:   org $0570
                db $00