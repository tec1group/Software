                                        ;Keyboard functions:
                                        ;Shift-Insert range 0900 - 4000 (03FF??)
                                        ;Shift-Delete range 0900 - 03FF (03FF is set to 00 on use of delete
                                        ;function).
                                        ;Shift -Address jumps to location stored at 08D2 and 08D3
                                        ;Info:
                                        ;Stack Start 08C0
                                        ;Stack Max Length C0
                                        ;User Code Start 0900
                                        ;KeyData location 08E0 (placed there by NMI routine)
STARTROM:       ORG 0x0000
                jp 0x0200		        ;Jump to MONSTART
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld hl,(0x08c0)
                jp (hl)
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld hl,(0x08c2)
                jp (hl)
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld hl,(0x08c4)
                jp (hl)
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld hl,(0x08c6)
                jp (hl)
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld hl,(0x08c8)
                jp (hl)
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld hl,(0x08ca)
                jp (hl)
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
RESTART38:      ld hl,(0x08cc)
                jp (hl)
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                push af
                in a,(0x00)
                ld (0x08e0),a
                pop af
                retn
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
SEVSEGDATA:     org 0x0080
                ex de,hl
                jr z,0x0050
                xor l
                ld l,0xa7
                rst 0x20
                add hl,hl
                rst 0x28
                cpl
                ld l,a
                and 0xc3
                call pe,0x47c7
                ex (sp),hl
                ld h,(hl)
                jr z,0x007c
                ld c,(hl)
                jp nz,0x6b2d
                ex de,hl
                ld c,a
                cpl
                ld c,e
                and a
                ld b,(hl)
                jp pe,0xace0
                and h
                xor (hl)
                ret
                djnz 0x00ae
                jr 0x00ac
                inc l
                nop
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                nop
                add hl,bc
                nop
                nop
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ret m
                db 0xFF
                nop
                nop
DEMOTEXT:       ORG 0x00c0              ;Data table for text message demo.
                db 0x1b                 ;ROUTINE
                db 0x18
                db 0x1e
                db 0x1d
                db 0x12
                db 0x17
                db 0x0e
                db 0x29                 ;[space]
                db 0x0b                 ;BY
                db 0x22
                db 0x29                 ;[space]
                db 0x17                 ;NIC.   (Nic Enots - Ken Stone's old programming pseudonym))
                db 0x12
                db 0x0c
                db 0x24
                db 0x29                 ;[space]
                db 0x29                 ;[space]
                db 0x29                 ;[space]
                db 0x29                 ;[space]
                db 0x29                 ;[space]
                db 0xfe                 ;(repeat text)
                db 0x1c                 ;STONE  (Text for real surname hidden in code)
                db 0x1d
                db 0x18
                db 0x17
                db 0x0a
                db 0xff                 ;(end text)
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                call 0x0289
                inc bc
                jr 0x00ea
                call 0x0289
                dec bc
                call 0x0490
                call 0x0270
                ld hl,0x08df
                set 0,(hl)
                res 1,(hl)
                jp 0x0378
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
TABLES:         ORG 0x0100              ;tables
FRQTBL:         defb 0xfd               ;(division table for frequencies)
                djnz 0x0113
                defb 0xfd
                ld de,0x12ef
                pop hl
                inc de
                ld d,h
                inc d
                ret
                djnz 0x00cc
                djnz 0x00c2
                djnz 0x00bb
                add hl,de
                sbc a,a
                ld a,(de)
                sub (hl)
                inc e
                add a,b
                ld e,0x86
                jr nz,0x019b
                ld (0x2477),hl
                ld (hl),c
                ld h,0x6a
                jr z,0x0188
                ld hl,(0x2d5f)
                ld e,c
                cpl
                ld d,h
                ld (0x3550),a
                ld c,e
                jr c,0x0177
                inc a
                ld b,e
                ccf
                ccf
                ld b,e
                inc a
                ld b,a
                jr c,0x0184
                dec (hl)
                ld d,b
                ld (0x2f54),a
                ld e,c
                dec l
                ld e,a
                ld hl,(0x2864)
                ld l,d
                ld h,0x71
                inc h
                ld (hl),a
                ld (0x207f),hl
                add a,(hl)
                ld e,0x8e
                inc e
                sub (hl)
                ld a,(de)
                sub h
                add hl,de
                xor c
                jr 0x010a
                ld d,0xbe
                dec d
                ret
                inc d
                push de
                inc de
                pop hl
                ld (de),a
                rst 0x28
                ld de,0x10fd
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
PLAYTONE:       org 0x0170          ;TONE routine. 0170
                push bc
                push de
                push hl
                push af
                and a               ;Set Z Flag
                jr nz,0x017a        ;If not zero, Jump Rel to ptnotzero
                ld e,a              ;Clear E
                jr 0x017c           ;Jump Rel to ptzero
ptAisnotzero:   ld e,0x80           ;Load E with 80h
ptAiszero:      ld hl,0x0100        ;(^division table for frequencies)
                add a,a
                add a,l
                ld l,a
                ld c,(hl)
                inc hl
lengthloop:     ld b,(hl)
                ld a,e
                out (0x01),a
toneloop:       djnz 0x0188
                ld b,(hl)
                xor a
                out (0x01),a
                djnz 0x018e
                dec c
                jr nz,0x0184
                pop af
                pop hl
                pop de
                pop bc
                ret
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
PLAYTUNE:       org 0x01a0  ;MUSIC routine.
                push af
                push hl
                ld hl,(0x08d6)
                ld a,(hl)
                cp 0xff
                jr nz,0x01ad
                pop hl
                pop af
                ret
                cp 0xfe
                jr z,0x01a2
                inc hl
                call 0x0170         ;Call PlayTone
                jr 0x01a5
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld hl,0x08df
                bit 0,(hl)
                jr nz,0x01ce
                set 0,(hl)
                res 1,(hl)
                jp 0x0378
                res 0,(hl)
                set 1,(hl)
                jp 0x0378
                db 0xFF
                db 0xFF
                db 0xFF
MPDISPLAY:      ORG 0x01d8              ;MULTIPASS DISPLAY
                push bc
                ld b,0x80
                call 0x02a0             ;Call DISPLAY
                djnz 0x01db
                pop bc
                ret
                db 0xFF
                db 0xFF
                ld bc,(0x08d2)
                call 0x0490
                call 0x0270
                jp 0x0378
                db 0xFF
                ld bc,(0x08d4)
                call 0x0490
                call 0x0270
                jp 0x0378
                db 0xFF
MONSTART:       ORG 0x0200              ;Main monitor program entry point.
                ld (0x08e8),sp
                ld sp,0x0900
                push af
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
                xor a
                ld (0x08cc),a
                ld (0x08cd),a
                ld a,0xff
                ld (0x08e0),a
                jp 0x0240
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld sp,0x08c0
                xor a
                out (0x01),a
                out (0x02),a
                ld hl,0x00b0
                ld de,0x08d8
                ld bc,0x0005
                ldir
                call 0x0270
                ld a,0x08
                call 0x0170
                ld a,0x0f
                call 0x0170
                ld a,0x01
                ld (0x08df),a
                call 0x02a0
                call 0x0360
                jr 0x0265
                db 0xFF
                db 0xFF
                db 0xFF
GETADDRDATA:    org  0x0270             ;GetAddressedData
                push af
                push hl
                push bc
                call 0x0289
                and 0xf0
                rrca
                rrca
                rrca
                rrca
                ld (0x08dc),a
                ld a,(bc)
                and 0x0f
                ld (0x08dd),a
                pop bc
                pop hl
                pop af
                ret
                                        ;GetEditorAddress
                                        ;The address used by editor and shown on the 7 segment display is
                                        ;stored in one location only, to prevent a situation where dislayed
                                        ;address and real address could differ. In a trade off in
                                        ;processing
                                        ;time, it was more efficient to store the address in the optimal
                                        ;from for the display routine. As such it needs converting to and
                                        ;from this format when used by the monitor program.
                                        ;The chosen location is the display buffer, where the address is
                                        ;broken into nibbles and spread across four bytes, 08D8, 08D9,
                                        ;08DA,
                                        ;08DB, MSN to LSN. GetEditorAddress is used to retrieve this
                                        ;address.
                                        ;The data held here is only valid while the monitor program is
                                        ;running. As soon as something else is written to the display it is
                                        ;lost. Resetting the computer restores it to the default 0900h.
                                        ;GetEditorAddress, when called, loads BC with the address currently
                                        ;held In the display buffer. It also loads A with the data held at
                                        ;the location addressed by BC.
                                        ;E.G. If the LED display shows 0900 CD, calling 0289 will load BC
                                        ;with 0900 (B is the MSB) and loads A with CD. This routine is not
                                        ;transparent. HL is destroyed. BC and A hold the results. If this
                                        ;routine is called during a user program that is not an extension ;;to
                                        ;the monitor, the result will have no meaning.
GETEDITADDR:    ORG 0x0289              ;GetEditorAddress
                ld hl,0x08d8
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
                db 0xFF
DISPLAY:        org 0x02a0
                push af
                push hl
                push de
                push bc
                ld de,0x08d8
                xor a
                out (0x01),a
                call 0x0350
                bit 1,(hl)
                jr z,0x02b3
                set 4,a
                out (0x02),a
                ld a,0x20
                out (0x01),a
                ld b,0x20
                djnz 0x02bb
                xor a
                out (0x01),a
                call 0x0350
                bit 1,(hl)
                jr z,0x02c9
                set 4,a
                out (0x02),a
                ld a,0x10
                out (0x01),a
                ld b,0x20
                djnz 0x02d1
                xor a
                out (0x01),a
                call 0x0350
                bit 1,(hl)
                jr z,0x02df
                set 4,a
                out (0x02),a
                ld a,0x08
                out (0x01),a
                ld b,0x20
                djnz 0x02e7
                xor a
                out (0x01),a
                call 0x0350
                bit 1,(hl)
                jr z,0x02f5
                set 4,a
                out (0x02),a
                ld a,0x04
                out (0x01),a
                ld b,0x20
                djnz 0x02fd
                xor a
                out (0x01),a
                nop
                jp 0x0318
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                call 0x0289
                push bc
                pop hl
                ld sp,0x08c0
                jp (hl)
                db 0xFF
                db 0xFF
                db 0xFF
                call 0x0350
                bit 0,(hl)
                jr z,0x0321
                set 4,a
                out (0x02),a
                ld a,0x02
                out (0x01),a
                ld b,0x20
                djnz 0x0329
                xor a
                out (0x01),a
                call 0x0350
                bit 0,(hl)
                jr z,0x0337
                set 4,a
                out (0x02),a
                ld a,0x01
                out (0x01),a
                ld b,0x20
                djnz 0x033f
                xor a
                out (0x01),a
                pop bc
                pop de
                pop hl
                pop af
                ret
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                                        ;Hex2SevenSeg converts the Hex value (0 to29) into the ;
                                        ;corresponding seven-segment data. It is part of the display ;
                                        ;destroyed, DE is incremented, A is converted from the value to its
                                        ;7 segment form.
HEX2SEG:        org 0x0350              ;Hex2SevenSeg
                ld hl,0x0080
                ld a,(de)
                add a,l
                ld l,a
                ld a,(hl)
                inc de
                ld hl,0x08df
                ret
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                push af
                push hl
                ld hl,0x08e0
                ld a,0xff
                cp (hl)
                jr z,0x0378
                ld a,(hl)
                and 0x1f
                bit 5,(hl)
                jr nz,0x0373
                add a,0x14
                jp 0x03a8
                db 0xFF
                db 0xFF
                pop hl
                pop af
                ret
                db 0xFF
                db 0xFF
                pop hl
                pop af
                ret
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                call 0x0289
                push bc
                pop ix
                inc ix
                push ix
                pop hl
                ld a,h
                cp 0x40
                jr z,0x039c
                ld a,(ix+0)
                ld (ix-1),a
                jr 0x038a
                ld a,0x00
                ld (0x3fff),a
                call 0x0270
                jp 0x0378
                db 0xFF
                add a,0x01
                call 0x0170
                jp 0x0421
                call 0x0289
                dec bc
                ld ix,0x3ffe
                ld a,(ix+0)
                ld (ix+1),a
                dec ix
                push ix
                pop hl
                ld a,c
                cp l
                jr nz,0x03b8
                ld a,b
                cp h
                jr nz,0x03b8
                ld (ix+1),0x00
                call 0x0270
                jp 0x0378
                db 0xFF
                db 0xFF
                db 0xFF
RUNWRITING:     org 0x03d8;             RUNNING WRITING
                push hl
                push af
                push ix
                push bc
                xor a
                ld (0x08df),a
                ld b,0x06
                ld hl,0x08d8
                ld a,0x29
                ld (hl),a
                inc hl
                djnz 0x03e8
                ld hl,(0x08d0)
                ld a,(hl)
                cp 0xff
                jr nz,0x03fa
                pop bc
                pop ix
                pop af
                pop hl
                ret
                cp 0xfe
                jr z,0x03ec
                ld ix,0x08d8
                ld b,0x05
                ld a,(ix+1)
                ld (ix+0),a
                inc ix
                djnz 0x0404
                ld a,(hl)
                ld (0x08dd),a
                inc hl
                ld b,0x40
                call 0x02a0
                djnz 0x0415
                jr 0x03ef
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                sub 0x01
                ld (hl),0xff
                bit 4,a
                jp nz,0x04c0
                bit 5,a
                jp nz,0x04c0
                ld hl,0x08df
                bit 0,(hl)
                jp z,0x0455
                ld d,a
                call 0x0289
                ld hl,0x08df
                bit 3,(hl)
                jr nz,0x0445
                xor a
                set 3,(hl)
                rlca
                rlca
                rlca
                rlca
                and 0xf0
                add a,d
                ld (bc),a
                call 0x0270
                jp 0x037d
                db 0xFF
                db 0xFF
                ld d,a
                ld hl,0x08df
                res 3,(hl)
                bit 4,(hl)
                jr nz,0x0467
                ld bc,0x0000
                call 0x0490
                set 4,(hl)
                call 0x0289
                ld a,b
                rlca
                rlca
                rlca
                rlca
                and 0xf0
                ld e,a
                ld a,c
                rlca
                rlca
                rlca
                rlca
                and 0x0f
                add a,e
                ld b,a
                ld a,c
                rlca
                rlca
                rlca
                rlca
                and 0xf0
                add a,d
                ld c,a
                call 0x0490
                call 0x0270
                jp 0x037d
                db 0xFF
                db 0xFF
                db 0xFF
                                        ;SetEditorAddress 0490 is the opposite of the GetEditorAddress
                                        ;0289 routine.
                                        ;It loads the display buffer (08D8, 08D9, 08DA, 08DB) with the
                                        ;value held in BC.
                                        ;AThis routine is transparent.
SETEDITADDR:    org 0x0490              ;SetEditorAddress
                push af
                push hl
                ld hl,0x08d8
                ld a,b
                and 0xf0
                rlca
                rlca
                rlca
                rlca
                ld (hl),a
                inc hl
                ld a,b
                and 0x0f
                ld (hl),a
                inc hl
                ld a,c
                and 0xf0
                rlca
                rlca
                rlca
                rlca
                ld (hl),a
                inc hl
                ld a,c
                and 0x0f
                ld (hl),a
                pop hl
                pop af
                ret
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                ld hl,0x08df
                res 3,(hl)
                res 4,(hl)
                cp 0x10
                jp z,0x00e0
                cp 0x11
                jp z,0x00e6
                cp 0x12
                jp z,0x030c
                cp 0x13
                jp z,0x01c0
                cp 0x14
                jp z,0x0550
                cp 0x15
                jp z,0xffff
                cp 0x16
                jp z,0xffff
                cp 0x17
                jp z,0x01f2
                cp 0x18
                jp z,0x0570
                cp 0x19
                jp z,0xffff
                cp 0x1a
                jp z,0xffff
                cp 0x1b
                jp z,0xffff
                cp 0x1c
                jp z,0x0660
                cp 0x1d
                jp z,0xffff
                cp 0x1e
                jp z,0xffff
                cp 0x1f
                jp z,0xffff
                cp 0x20
                jp z,0xffff
                cp 0x21
                jp z,0xffff
                cp 0x22
                jp z,0xffff
                cp 0x23
                jp z,0xffff
                cp 0x24
                jp z,0x03b0
                cp 0x25
                jp z,0x0384
                cp 0x26
                jp z,0xffff
                cp 0x27
                jp z,0x01e4
                jp 0x0378
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                RST   0x38
                call 0x0289
                ld h,b
                ld l,c
                ld a,(0x08e1)
                inc hl
                cp (hl)
                jr nz,0x0558
                ld b,h
                ld c,l
                call 0x0490
                jp 0x0253
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
                db 0xFF
