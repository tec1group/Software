; ######################
; #                    #
; # SMON1 Version 1.00 #
; # by Scott Gregory   #
; # 06/04/2020         #
; #                    #
; ######################
; 
            .CPU    Z80 
            .BINFROM $0000 
            .BINTO  $0800 
; 
STACKBASE   EQU     $08C0 ; Stack position.
ROMBASE     EQU     $0000 ; Start of ROM.
RAMBASE     EQU     $0900 ; Start of user RAM.
RAMTOP      EQU     $17FF ; End of user RAM.
CATHDLY     EQU     $20 ; Digit display delay.
KEYPORT     EQU     $00 ; Keypad port.
CATHPORT    EQU     $01 ; Display catchode port.
SEGPORT     EQU     $02 ; Display segment port.
; 
ADDRESS     EQU     $08C1 
DATA        EQU     $08C3 
SCRATCH     EQU     $08C5 
MODE        EQU     $08C7 
KEYDATA     EQU     $08C9 
; 
; Begin MOD-01 assignments.
M01START    EQU     $08F0 
M01FINISH   EQU     $08F2 
M01PATTERN  EQU     $08F4 
; End MOD-01 assignments.
; 
            .ORG    $0000 
RESET_00:   JP      SETUP 
; 
            .ORG    $0008 
RESET_08:   JP      SETUP 
; 
            .ORG    $0010 
RESET_10:   JP      SETUP 
; 
            .ORG    $0018 
RESET_18:   JP      SETUP 
; 
            .ORG    $0020 
RESET_20:   JP      SETUP 
; 
            .ORG    $0028 
RESET_28:   JP      SETUP 
; 
            .ORG    $0030 
RESET_30:   JP      SETUP 
; 
            .ORG    $0038 
RESET_38:   JP      SETUP 
; 
            .ORG    $0040 
VERSION:    DB      $53,$4D,$4F,$4E,$20,$56,$31,$2E 
            DB      $30,$30,$20,$62,$79,$20,$53,$63 
            DB      $6F,$74,$74,$20,$47,$72,$65,$67 
            DB      $6F,$72,$79 
; 
            .ORG    $0066 
NMISERVICE: PUSH    af ; Keyboard service routine.
            IN      a,(KEYPORT) 
            LD      (KEYDATA),a 
            POP     af 
            RETN     
; 
            .ORG    $0080 
DISPLAY:    XOR     a ; Display update routine.
            OUT     (CATHPORT),a 
            OUT     (SEGPORT),a 
            LD      c,a 
            SET     5,c 
            LD      de,(ADDRESS) 
            LD      a,d 
            LD      (SCRATCH),a 
            XOR     a 
            LD      hl,SCRATCH 
            RLD      
            LD      ix,HEX2SEG 
            LD      d,$00 
            LD      e,a 
            ADD     ix,de 
            LD      a,(ix) 
            PUSH    hl 
            LD      hl,MODE 
            BIT     0,(hl) 
            JP      z,DISL00 
            OR      $10 
DISL00:     POP     hl 
            OUT     (SEGPORT),a 
            LD      a,c 
            OUT     (CATHPORT),a 
            LD      b,CATHDLY 
DISL01:     DJNZ    DISL01 
            XOR     a 
            OUT     (CATHPORT),a 
            OUT     (SEGPORT),a 
            RR      c 
            RLD      
            LD      ix,HEX2SEG 
            LD      d,$00 
            LD      e,a 
            ADD     ix,de 
            LD      a,(ix) 
            PUSH    hl 
            LD      hl,MODE 
            BIT     0,(hl) 
            JP      z,DISL02 
            OR      $10 
DISL02:     POP     hl 
            OUT     (SEGPORT),a 
            LD      a,c 
            OUT     (CATHPORT),a 
            LD      b,CATHDLY 
DISL03:     DJNZ    DISL03 
            XOR     a 
            OUT     (CATHPORT),a 
            OUT     (SEGPORT),a 
            RR      c 
            LD      de,(ADDRESS) 
            LD      a,e 
            LD      (SCRATCH),a 
            XOR     a 
            LD      hl,SCRATCH 
            RLD      
            LD      ix,HEX2SEG 
            LD      d,$00 
            LD      e,a 
            ADD     ix,de 
            LD      a,(ix) 
            PUSH    hl 
            LD      hl,MODE 
            BIT     0,(hl) 
            JP      z,DISL04 
            OR      $10 
DISL04:     POP     hl 
            OUT     (SEGPORT),a 
            LD      a,c 
            OUT     (CATHPORT),a 
            LD      b,CATHDLY 
DISL05:     DJNZ    DISL05 
            XOR     a 
            OUT     (CATHPORT),a 
            OUT     (SEGPORT),a 
            RR      c 
            RLD      
            LD      ix,HEX2SEG 
            LD      d,$00 
            LD      e,a 
            ADD     ix,de 
            LD      a,(ix) 
            PUSH    hl 
            LD      hl,MODE 
            BIT     0,(hl) 
            JP      z,DISL06 
            OR      $10 
DISL06:     POP     hl 
            OUT     (SEGPORT),a 
            LD      a,c 
            OUT     (CATHPORT),a 
            LD      b,CATHDLY 
DISL07:     DJNZ    DISL07 
            XOR     a 
            OUT     (SEGPORT),a 
            OUT     (CATHPORT),a 
            RR      c 
            LD      hl,(ADDRESS) 
            LD      a,(hl) 
            LD      (SCRATCH),a 
            XOR     a 
            LD      hl,SCRATCH 
            RLD      
            LD      ix,HEX2SEG 
            LD      d,$00 
            LD      e,a 
            ADD     ix,de 
            LD      a,(ix) 
            PUSH    hl 
            LD      hl,MODE 
            BIT     0,(hl) 
            JP      nz,DISL08 
            OR      $10 
DISL08:     POP     hl 
            OUT     (SEGPORT),a 
            LD      a,c 
            OUT     (CATHPORT),a 
            LD      b,CATHDLY 
DISL09:     DJNZ    DISL09 
            XOR     a 
            OUT     (SEGPORT),a 
            OUT     (CATHPORT),a 
            RR      c 
            RLD      
            LD      ix,HEX2SEG 
            LD      d,$00 
            LD      e,a 
            ADD     ix,de 
            LD      a,(ix) 
            PUSH    hl 
            LD      hl,MODE 
            BIT     0,(hl) 
            JP      nz,DISL0A 
            OR      $10 
DISL0A:     POP     hl 
            OUT     (0x02),a 
            LD      a,c 
            OUT     (0x01),a 
            LD      b,CATHDLY 
DISL0B:     DJNZ    DISL0B 
            RET      
; 
KEYBOARD:   PUSH    hl ; Key decoder routine.
            PUSH    af 
            LD      hl,KEYDATA 
            LD      a,$FF 
            CP      (hl) 
            JP      z,KEYLXX 
            LD      a,(hl) 
            AND     $3f 
            XOR     $20 
; 
            CP      $10 ; + key.
            JP      nz,KEYL00 
            LD      hl,(ADDRESS) 
            INC     hl 
            LD      (ADDRESS),hl 
            LD      hl,MODE 
            RES     0,(hl) 
            RES     1,(hl) 
            JP      KEYLXX 
; 
KEYL00:     CP      $11 ; - key.
            JP      nz,KEYL01 
            LD      hl,(ADDRESS) 
            DEC     hl 
            LD      (ADDRESS),hl 
            LD      hl,MODE 
            RES     0,(hl) 
            RES     1,(hl) 
            JP      KEYLXX 
; 
KEYL01:     CP      $12 ; GO key.
            JP      nz,KEYL02 
            LD      sp,STACKBASE 
            LD      hl,(ADDRESS) 
            JP      (hl) 
; 
KEYL02:     CP      $13 ; AD key.
            JP      nz,KEYL03 
            LD      b,a 
            LD      a,(MODE) 
            XOR     $01 
            RES     1,a 
            LD      (MODE),a 
            LD      a,b 
            JP      KEYLXX 
; 
KEYL03:     CP      $20 ; Shift-0 key - MOD-01
            JP      nz,KEYL04 
            PUSH    af 
            PUSH    hl 
            CALL    MOD01 
            POP     hl 
            POP     af 
            JP      KEYLXX 
; 
KEYL04:     CP      $21 ; Shift-1 key.
            JP      z,KEYLXX 
KEYL05:     CP      $22 ; Shift-2 key.
            JP      z,KEYLXX 
KEYL06:     CP      $23 ; Shift-3 key.
            JP      z,KEYLXX 
KEYL07:     CP      $24 ; Shift-4 key.
            JP      z,KEYLXX 
KEYL08:     CP      $25 ; Shift-5 key.
            JP      z,KEYLXX 
KEYL09:     CP      $26 ; Shift-6 key.
            JP      z,KEYLXX 
KEYL0A:     CP      $27 ; Shift-7 key.
            JP      z,KEYLXX 
KEYL0B:     CP      $28 ; Shift-8 key.
            JP      z,KEYLXX 
KEYL0C:     CP      $29 ; Shift-9 key.
            JP      z,KEYLXX 
KEYL0D:     CP      $2A ; Shift-A key.
            JP      z,KEYLXX 
KEYL0E:     CP      $2B ; Shift-B key.
            JP      z,KEYLXX 
KEYL0F:     CP      $2C ; Shift-C key.
            JP      z,KEYLXX 
KEYL10:     CP      $2D ; Shift-D key.
            JP      z,KEYLXX 
KEYL11:     CP      $2E ; Shift-E key.
            JP      z,KEYLXX 
KEYL12:     CP      $2F ; Shift-F key.
            JP      z,KEYLXX 
; 
KEYL13:     CP      $30 ; SHift-+ key.
            JP      nz,KEYL14 
            LD      hl,RAMTOP 
            LD      de,(ADDRESS) 
            SBC     hl,de 
            LD      bc,hl 
            LD      hl,RAMTOP 
            LD      de,hl 
            DEC     hl 
            LDDR     
            LD      hl,de 
            LD      (hl),$00 
            JP      KEYLXX 
; 
KEYL14:     CP      $31 ; Shift-- key.
            JP      nz,KEYL15 
            LD      hl,RAMTOP 
            LD      de,(ADDRESS) 
            SBC     hl,de 
            LD      bc,hl 
            LD      hl,(ADDRESS) 
            LD      de,hl 
            INC     hl 
            LDIR     
            LD      hl,de 
            LD      (hl),$00 
            JP      KEYLXX 
; 
KEYL15:     CP      $32 ; Shift-GO key.
            JP      z,KEYLXX 
KEYL16:     CP      $33 ; Shift-AD key.
            JP      z,KEYLXX 
; 
KEYL17:     LD      hl,MODE ; No shifted digit keys entry.
            BIT     0,(hl) 
            JP      nz,KEYL19 
            BIT     1,(hl) 
            JP      nz,KEYL18 
            SET     1,(hl) 
            LD      hl,(ADDRESS) 
            LD      (hl),$00 
; 
KEYL18:     LD      hl,(ADDRESS) 
            RLD      
            JP      KEYLXX 
; 
KEYL19:     BIT     1,(hl) 
            JP      nz,KEYL1A 
            SET     1,(hl) 
            LD      hl,$0000 
            LD      (ADDRESS),hl 
; 
KEYL1A:     LD      hl,ADDRESS 
            RLD      
            LD      hl,(ADDRESS) 
            SLA     h 
            SLA     h 
            SLA     h 
            SLA     h 
            LD      b,a 
            XOR     a 
            OR      h 
            OR      b 
            LD      h,a 
            LD      (ADDRESS),hl 
; 
KEYLXX:     LD      hl,KEYDATA ; Done with the key decoder.
            LD      (hl),$FF 
            POP     af 
            POP     hl 
            RET      
; 
SETUP:      LD      sp,STACKBASE ; Post reset/power up setup.
            LD      hl,RAMBASE 
            LD      (ADDRESS),hl 
            XOR     a 
            LD      (MODE),a 
            LD      a,$FF 
            LD      (KEYDATA),a 
; 
MAIN:       CALL    DISPLAY 
            CALL    KEYBOARD 
            JP      MAIN 
; 
HEX2SEG:    DB      $EB,$28,$CD,$AD,$2E,$A7,$E7,$29 
            DB      $EF,$2F,$6F,$E6,$C3,$EC,$C7,$47 
; 
; BEGIN MODULES.
; START MOD-01
MOD01:      LD      hl,(M01FINISH) 
            INC     hl 
            LD      de,(M01START) 
            XOR     a 
            SBC     hl,de 
            LD      b,h 
            LD      c,l 
            LD      (M01FINISH),bc 
            LD      hl,(M01START) 
            LD      de,(M01PATTERN) 
            EXX      
            LD      hl,(M01START) 
            LD      bc,(M01FINISH) 
            LD      de,(M01PATTERN) 
; 
M01LDBLK:   LD      (hl),d 
            INC     hl 
            DEC     bc 
            LD      a,b 
            OR      c 
            JP      nz,M01LDBLK 
            LD      de,$0000 
; 
M01DELAY:   DEC     de 
            LD      a,d 
            OR      e 
            JP      nz,M01DELAY 
            LD      de,$0000 
            EXX      
; 
M01TSTBLK:  JP      M01TEST01 
M01TEST00:  EXX      
            INC     de 
            EXX      
            JP      M01TEST02 
M01TEST01:  LD      a,(hl) 
            CP      d 
            JP      nz,M01TEST00 
M01TEST02:  INC     hl 
            DEC     bc 
            LD      a,b 
            OR      c 
            JP      nz,M01TEST01 
; 
M01STORE:   EXX      
            LD      (M01START),de 
            RET      
; END MOD-01
; END MODULES.
; 
            .END     
