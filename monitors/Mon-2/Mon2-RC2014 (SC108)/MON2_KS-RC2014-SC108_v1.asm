              jp 0x0200
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,(0x9Fc0)
              jp (hl)
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,(0x9Fc2)
              jp (hl)
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,(0x9Fc4)
              jp (hl)
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,(0x9Fc6)
              jp (hl)
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,(0x9Fc8)
              jp (hl)
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,(0x9Fca)
              jp (hl)
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,(0x9Fcc)
              jp (hl)
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              push af
              in a,(0x00)
              ld (0x9Fe0),a
              pop af
              retn
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
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
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38

INITADDR:     db $0A                  ;A        Inital address (start of RAM)
              db $00                  ;0        A000 being suitable for the SC108
              db $00                  ;0        having 32k ROM and then 32k RAM
              db $00                  ;0
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38

              .ORG $00C0              ; Data table for text message demo.
DEMOTEXT:     db $1b                  ; R
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

              call 0x0289
              inc bc
              jr 0x00ea
              call 0x0289
              dec bc
              call 0x0490
              call 0x0270
              ld hl,0x9Fdf
              set 0,(hl)
              res 1,(hl)
              jp 0x0378
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              defb 0xfd
              djnz 0x0113
              defb 0xfd
              ld de,0x12ef
              pop hl
              inc de
              push de
              inc d
              ret
              dec d
              cp (hl)
              ld d,0xb3
              jr 0x00bb
              add hl,de
              sbc a,a
              ld a,(de)
              sub (hl)
              inc e
              adc a,(hl)
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
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              push bc
              push de
              push hl
              push af
              and a
              jr nz,0x017a
              ld e,a
              jr 0x017c
              ld e,0x80
              ld hl,0x0100
              add a,a
              add a,l
              ld l,a
              ld c,(hl)
              inc hl
              ld b,(hl)
              ld a,e
              out (0x01),a
              djnz 0x0188
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
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              push af
              push hl
              ld hl,(0x9Fd6)
              ld a,(hl)
              cp 0xff
              jr nz,0x01ad
              pop hl
              pop af
              ret
              cp 0xfe
              jr z,0x01a2
              inc hl
              call 0x0170
              jr 0x01a5
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,0x9Fdf
              bit 0,(hl)
              jr nz,0x01ce
              set 0,(hl)
              res 1,(hl)
              jp 0x0378
              res 0,(hl)
              set 1,(hl)
              jp 0x0378
              rst 0x38
              rst 0x38
              rst 0x38
              push bc
              ld b,0x80
              call 0x02a0
              djnz 0x01db
              pop bc
              ret
              rst 0x38
              rst 0x38
              ld bc,(0x9Fd2)
              call 0x0490
              call 0x0270
              jp 0x0378
              rst 0x38
              ld bc,(0x9Fd4)
              call 0x0490
              call 0x0270
              jp 0x0378
              rst 0x38
              ld (0x9Fe8),sp
              ld sp,0xA000          ; Start of user RAM in the SC108
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
              ld (0x9Fcc),a          ; 
              ld (0x9Fcd),a
              ld a,0xff
              ld (0x9Fe0),a
              jp 0x0240
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld sp,0x9Fc0            ; Final location of the Stack
              xor a
              out (0x01),a
              out (0x02),a
              ld hl,0x00b0
              ld de,0x9Fd8
              ld bc,0x0005
              ldir
              call 0x0270
              ld a,0x08
              call 0x0170
              ld a,0x0f
              call 0x0170
              ld a,0x01
              ld (0x9Fdf),a
              call 0x02a0
              call 0x0360
              jr 0x0265
              rst 0x38
              rst 0x38
              rst 0x38
              push af
              push hl
              push bc
              call 0x0289
              and 0xf0
              rrca
              rrca
              rrca
              rrca
              ld (0x9Fdc),a
              ld a,(bc)
              and 0x0f
              ld (0x9Fdd),a
              pop bc
              pop hl
              pop af
              ret
              ld hl,0x9Fd8
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
              rst 0x38
              push af
              push hl
              push de
              push bc
              ld de,0x9Fd8
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
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              call 0x0289
              push bc
              pop hl
              ld sp,0x9Fc0          ; PLaying with the Stack pointer
              jp (hl)
              rst 0x38
              rst 0x38
              rst 0x38
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
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,0x0080
              ld a,(de)
              add a,l
              ld l,a
              ld a,(hl)
              inc de
              ld hl,0x9Fdf
              ret
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              push af
              push hl
              ld hl,0x9Fe0
              ld a,0xff
              cp (hl)
              jr z,0x0378
              ld a,(hl)
              and 0x1f
              bit 5,(hl)
              jr nz,0x0373
              add a,0x14
              jp 0x03a8
              rst 0x38
              rst 0x38
              pop hl
              pop af
              ret
              rst 0x38
              rst 0x38
              pop hl
              pop af
              ret
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
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
              rst 0x38
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
              rst 0x38
              rst 0x38
              rst 0x38
              push hl
              push af
              push ix
              push bc
              xor a
              ld (0x9Fdf),a
              ld b,0x06
              ld hl,0x9Fd8
              ld a,0x29
              ld (hl),a
              inc hl
              djnz 0x03e8
              ld hl,(0x9Fd0)
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
              ld ix,0x9Fd8
              ld b,0x05
              ld a,(ix+1)
              ld (ix+0),a
              inc ix
              djnz 0x0404
              ld a,(hl)
              ld (0x9Fdd),a
              inc hl
              ld b,0x40
              call 0x02a0
              djnz 0x0415
              jr 0x03ef
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              sub 0x01
              ld (hl),0xff
              bit 4,a
              jp nz,0x04c0
              bit 5,a
              jp nz,0x04c0
              ld hl,0x9Fdf
              bit 0,(hl)
              jp z,0x0455
              ld d,a
              call 0x0289
              ld hl,0x9Fdf
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
              rst 0x38
              rst 0x38
              ld d,a
              ld hl,0x9Fdf
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
              rst 0x38
              rst 0x38
              rst 0x38
              push af
              push hl
              ld hl,0x9Fd8
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
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              ld hl,0x9Fdf
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
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              rst 0x38
              call 0x0289
              ld h,b
              ld l,c
              ld a,(0x9Fe1)
              inc hl
              cp (hl)
              jr nz,0x0558
              ld b,h
              ld c,l
              call 0x0490
              jp 0x0253

            .org $7F8
VERSION:    db $56, $65, $72, $3A           ; VER:
            db $31, $2E, $30, $4D           ; 1.0M