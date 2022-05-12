; JIMS DISASSEMBLER SOURCE CODE
; -----------------------------

; Note: This file was updated so I can place it in any memory location.  This is for the BMON project.
; For Full annotation please look at the PDF "disassembler_listing.pdf"

; Local Variables
DISFROM:    EQU     08C0H ;Dis String Start
DISMID:     EQU     08D2H ;Dis Second Line
DISEND:     EQU     08A0H ;Dis String End
DISFLAG:    EQU     08A2H ;Dis Flag for HL,IX,IY

TBL_PAGE:   EQU     0x37  ;Page of code where lookup tables start.  Change this to the last MSB of
                          ;the binary file.  IE: if ORG is 3000H, make this 0x37

; JMON Perimeter Varables
PERMJMP:    EQU     0044H ;Perimeter Entry Call
PERMENU:    EQU     0880H ;Menu Location
PERFROM:    EQU     0898H ;Start Address
PEREND:     EQU     089AH ;End Address

; LCD Ports
LCDCOM:     EQU     0x04 ;LCD Command Port (Port 4)
LCDDAT:     EQU     0x84 ;LCD Data Port (A7 + Port 4)

            ORG    3000H 
DIS_START:           
            LD      HL,DISFROM 
            XOR     A 
            LD      (DISFLAG),A 
            LD      (DISEND),HL 
            LD      HL,(PERFROM) 
            PUSH    HL 
            CALL    L0x318A 
            LD      B,0x20 
            CALL    L0x31B9 
            LD      A,0xC5 
            LD      (DISEND),A 
            POP     HL 
            LD      A,(HL) 
            PUSH    HL 
            LD      D,0x01 
            CALL    L0x351D 
            POP     HL 
            JR      NC,L0x302E 
            CALL    L0x3031 
            LD      C,(HL) 
            LD      A,(HL) 
            CALL    NC,L0x340E 
L0x302E:             
            JP      L0x359E 
L0x3031:             
            CP      0x40 
            JR      C,L0x304D 
            CP      0xC0 
            JR      C,L0x304F 
            CP      0xCB 
            JP      Z,L0x31DE 
            LD      C,0x00 
            CP      0xDD 
            JR      Z,L0x3049 
            CP      0xFD 
            JR      NZ,L0x304D 
            INC     C 
L0x3049:             
            INC     C 
            JP      L0x30D7 
L0x304D:             
            OR      A 
            RET      
L0x304F:             
            PUSH    AF 
            CALL    L0x3055 
            JR      L0x305A 
L0x3055:             
            LD      B,0x01 
            JP      L0x31FF 
L0x305A:             
            POP     AF 
L0x305B:             
            CP      0x80 
            JR      NC,L0x3073 
            PUSH    AF 
            CALL    L0x3205 
            POP     AF 
            CALL    L0x31AC 
            PUSH    AF 
            CALL    L0x3106 
            CALL    L0x3164 
            POP     AF 
            LD      C,A 
            JP      L0x3107 
L0x3073:             
            AND     0x3F 
            CALL    L0x31AC 
            PUSH    AF 
            LD      A,0x86 
            ADD     A,C 
            ADD     A,C 
            ADD     A,C 
            CALL    L0x3207 
            CALL    L0x3086 
            JR      L0x3092 
L0x3086:             
            CALL    L0x317B 
            RET     NZ 
            LD      C,0x07 
            CALL    L0x310B 
            JP      L0x3164 
L0x3092:             
            POP     AF 
            LD      C,A 
            JR      L0x3106 
L0x3096:             
            CP      0x40 
            JR      NC,L0x30B0 
            CALL    L0x31AC 
            PUSH    AF 
            LD      A,C 
            CP      0x07 
            JR      NZ,L0x30A4 
            DEC     C 
L0x30A4:             
            LD      A,0x9E 
            ADD     A,C 
            ADD     A,C 
            ADD     A,C 
            CALL    L0x3207 
            POP     AF 
            LD      C,A 
            JR      L0x3106 
L0x30B0:             
            SUB     0x40 
            PUSH    AF 
            LD      B,0xB3 
            CP      0x40 
            JR      C,L0x30C1 
            LD      B,0xB6 
            CP      0x80 
            JR      C,L0x30C1 
            LD      B,0xB9 
L0x30C1:             
            LD      A,B 
            CALL    L0x3207 
            POP     AF 
            AND     0x3F 
            CALL    L0x31AC 
            PUSH    AF 
            LD      A,C 
            CALL    L0x319A 
            CALL    L0x3164 
            POP     AF 
            LD      C,A 
            JR      L0x3106 
L0x30D7:             
            LD      HL,(PERFROM) 
            INC     HL 
            LD      A,(HL) 
            CP      0xCB 
            JR      Z,L0x30EA 
            CP      0xBF 
            DEC     HL 
            RET     NC 
            CP      0x40 
            JR      NC,L0x30ED 
            AND     A 
            RET      
L0x30EA:             
            SET     7,C 
            INC     HL 
L0x30ED:             
            INC     HL 
            LD      A,(HL) 
            PUSH    AF 
            LD      B,0x04 
            LD      A,C 
            LD      (DISFLAG),A 
            BIT     7,C 
            JR      NZ,L0x30FB 
            DEC     B 
L0x30FB:             
            CALL    L0x31FF 
            POP     AF 
            BIT     7,C 
            JR      NZ,L0x3096 
            JP      L0x305B 
L0x3106:             
            LD      A,C 
L0x3107:             
            CP      0x06 
            JR      Z,L0x3112 
L0x310B:             
            LD      A,0x01 
L0x310D:             
            LD      HL,TBL_REG 
            JR      L0x3145 
L0x3112:             
            LD      A,(DISFLAG) 
            OR      A 
            JR      NZ,L0x311E 
            LD      C,0x08 
            LD      A,0x04 
            JR      L0x310D 
L0x311E:             
            PUSH    AF 
            RRA      
            LD      C,0x0C 
            JR      C,L0x3126 
            LD      C,0x13 
L0x3126:             
            LD      A,0x07 
            CALL    L0x310D 
            POP     AF 
            RLA      
            LD      DE,(PERFROM) 
            JR      NC,L0x3134 
            DEC     DE 
L0x3134:             
            LD      A,(DISEND) 
            SUB     0x03 
            LD      (DISEND),A 
            LD      A,(DE) 
            CALL    L0x3191 
            INC     HL 
            LD      (DISEND),HL 
            RET      
L0x3145:             
            LD      DE,(DISEND) 
            ADD     HL,BC 
            LD      C,A 
            LDIR     
            LD      (DISEND),DE 
            SCF      
            RET      
L0x3153:             
            LD      H,TBL_PAGE
            LD      L,A 
            LD      DE,0xFE9E 
            ADD     HL,DE 
            EX      DE,HL 
            JR      L0x3169 
L0x315D:             
            LD      HL,DISMID 
            LD      (DISEND),HL 
            RET      
L0x3164:             
            LD      BC,0x0006 
            JR      L0x310B 
L0x3169:             
            LD      HL,(DISEND) 
            LD      A,(DE) 
            LD      (HL),A 
            RES     7,(HL) 
            INC     HL 
            LD      (DISEND),HL 
            INC     DE 
            OR      A 
            JP      M,L0x31B7 
            JR      L0x3169 
L0x317B:             
            LD      A,C 
            CP      0x04 
            JR      C,L0x3182 
            OR      A 
            RET      
L0x3182:             
            CP      0x02 
            JR      NZ,L0x3188 
            DEC     A 
            RET      
L0x3188:             
            XOR     A 
            RET      
L0x318A:             
            PUSH    HL 
            LD      A,H 
            CALL    L0x3191 
            POP     HL 
            LD      A,L 
L0x3191:             
            PUSH    AF 
            RRA      
            RRA      
            RRA      
            RRA      
            CALL    L0x319A 
            POP     AF 
L0x319A:             
            AND     0x0F 
            ADD     A,0x90 
            DAA      
            ADC     A,0x40 
            DAA      
            LD      HL,(DISEND) 
            LD      (HL),A 
            INC     HL 
            LD      (DISEND),HL 
            SCF      
            RET      
L0x31AC:             
            PUSH    AF 
            AND     0x38 
            RRA      
            RRA      
            RRA      
            LD      C,A 
            POP     AF 
            AND     0x07 
            RET      
L0x31B7:             
            LD      B,0x01 
L0x31B9:             
            LD      A,0x20 
            LD      HL,(DISEND) 
L0x31BE:             
            LD      (HL),A 
            INC     HL 
            DJNZ    L0x31BE 
            LD      (DISEND),HL 
            RET      
L0x31C6:             
            LD      DE,(PERFROM) 
L0x31CA:             
            PUSH    BC 
            LD      A,(DE) 
            PUSH    AF 
            CALL    L0x3191 
            CALL    L0x31B7 
            POP     AF 
            INC     DE 
            POP     BC 
            DJNZ    L0x31CA 
            DEC     DE 
            LD      (PERFROM),DE 
            RET      
L0x31DE:             
            LD      B,0x02 
            CALL    L0x31C6 
            CALL    L0x315D 
            JP      L0x3096 
L0x31E9:             
            AND     0xCF 
            CP      0x01 
            JR      NZ,L0x3236 
            CALL    L0x31FD 
            CALL    L0x3205 
            CALL    L0x320A 
            CALL    L0x3164 
            JR      L0x3221 
L0x31FD:             
            LD      B,0x03 
L0x31FF:             
            CALL    L0x31C6 
            JP      L0x315D 
L0x3205:             
            LD      A,0x83    
L0x3207:             
            JP      L0x3153    
L0x320A:             
            LD      A,C 
L0x320B:             
            PUSH    AF 
            AND     0x30 
            CALL    L0x35A6 
            ADD     A,0x1A 
            LD      B,0x00 
            LD      C,A 
            LD      A,0x02 
            LD      HL,TBL_REG 
            CALL    L0x3145 
            POP     AF 
            LD      C,A 
            RET      
L0x3221:             
            LD      HL,(PERFROM) 
            LD      A,(HL) 
            PUSH    HL 
            CALL    L0x3191 
            POP     HL 
            DEC     HL 
            LD      A,(HL) 
            PUSH    HL 
            CALL    L0x3191 
            POP     HL 
            INC     HL 
            LD      (PERFROM),HL 
            RET      
L0x3236:             
            AND     0xC7 
            CP      0x06 
            JR      NZ,L0x3254 
            LD      B,0x02 
            CALL    L0x32BE 
            LD      A,C 
            CALL    L0x31AC 
            LD      B,0x00 
            CALL    L0x35E7 
            CALL    L0x3164 
L0x324D:             
            LD      HL,(PERFROM) 
            LD      A,(HL) 
            JP      L0x3191 
L0x3254:             
            LD      A,C 
            PUSH    AF 
            AND     0xEF 
            CP      0x0A 
            JR      NZ,L0x327B 
            LD      B,0x01 
            CALL    L0x32BE 
            LD      A,C 
            LD      BC,0x0007 
            CALL    L0x310B 
            CALL    L0x3164 
L0x326B:             
            LD      BC,0x0008 
            CALL    L0x310B 
            POP     AF 
            CALL    L0x320B 
            LD      BC,0x000B 
            JP      L0x310B 
L0x327B:             
            CP      0x02 
            JR      NZ,L0x3290 
            LD      B,0x01 
            CALL    L0x32BE 
            CALL    L0x3603 
L0x3287:             
            CALL    L0x3164 
            LD      BC,0x0007 
            JP      L0x310B 
L0x3290:             
            CP      0x22 
            JR      NZ,L0x32C4 
            LD      B,0x03 
            CALL    L0x32BE 
            CALL    L0x32AF 
            CALL    L0x3164 
            POP     AF 
L0x32A0:             
            BIT     4,A 
            JR      NZ,L0x32A7 
L0x32A4:             
            JP      L0x35CD 
L0x32A7:             
            LD      A,0x01 
            LD      BC,0x0007 
            JP      L0x310D 
L0x32AF:             
            LD      BC,0x0008 
            CALL    L0x310B 
            CALL    L0x3221 
            LD      BC,0x000B 
            JP      L0x310B 
L0x32BE:             
            CALL    L0x31FF 
            JP      L0x3205 
L0x32C4:             
            CP      0x2A 
            JR      NZ,L0x32D6 
            LD      B,0x03 
            CALL    L0x32BE 
            POP     AF 
            CALL    L0x32A0 
            CALL    L0x3164 
            JR      L0x32AF
L0x32D6: 
            AND     0xCF 
            CP      0x03 
            JR      NZ,L0x32EB 
            CALL    L0x32E3 
            POP     AF 
            JP      L0x320B 
L0x32E3:             
            CALL    L0x3055 
            LD      A,0xBC 
L0x32E8:             
            JP      L0x3207 
L0x32EB:             
            CP      0x0B 
            JR      NZ,L0x32FB 
            CALL    L0x32F6 
            POP     AF 
            JP      L0x320B 
L0x32F6:             
            LD      A,0xBF 
            JP      L0x3511 
L0x32FB:             
            AND     0xC7 
            CP      0x04 
            JR      NZ,L0x330B 
            CALL    L0x32E3 
            POP     AF 
L0x3305:             
            CALL    L0x31AC 
            JP      L0x3106 
L0x330B:             
            CP      0x05 
            JR      NZ,L0x3315 
            CALL    L0x32F6 
            POP     AF 
            JR      L0x3305 
L0x3315:             
            LD      A,C 
            AND     0xCF 
            CP      0x09 
            JR      NZ,L0x332B 
            LD      A,0x86 
            CALL    L0x3511 
            CALL    L0x32A4 
            CALL    L0x3164 
            POP     AF 
            JP      L0x320B 
L0x332B:             
            POP     AF 
            CP      0x10 
            JR      NZ,L0x334B 
            LD      A,0xD9 
L0x3332:             
            PUSH    AF 
            LD      B,0x02 
            CALL    L0x31FF 
            POP     AF 
            CALL    L0x3207 
            JP      L0x35F3 
            INC     HL 
            LD      (DISEND),HL 
            RET      
            LD      (HL),0x41 
            INC     HL 
            LD      (HL),0x46 
            INC     HL 
            RET      
L0x334B:             
            CP      0x18 
            JR      NZ,L0x3353 
            LD      A,0xD5 
            JR      L0x3332 
L0x3353:             
            LD      A,C 
            AND     0xC7 
            OR      A 
            JR      NZ,L0x3377 
            LD      A,C 
            PUSH    AF 
            LD      B,0x02 
            CALL    L0x31FF 
            LD      A,0xD5 
            CALL    L0x3207 
            POP     AF 
            CALL    L0x336C 
            JP      L0x35F3 
L0x336C:             
            AND     0x18 
L0x336E:             
            RRA      
            RRA      
            RRA      
            ADD     A,A 
            ADD     A,0xDD 
            JP      L0x3207 
L0x3377:             
            LD      A,C 
            CP      0xC3 
            JR      Z,L0x3391 
            CP      0xCD 
            JR      Z,L0x338D 
            CP      0xC9 
            JR      NZ,L0x33A7 
            LD      A,0xE5 
            JP      L0x3511 
L0x3389:             
            AND     0x38 
            JR      L0x336E 
L0x338D:             
            LD      A,0xC8 
            JR      L0x3393 
L0x3391:             
            LD      A,0xCC 
L0x3393:             
            LD      B,0x03 
            PUSH    AF 
            CALL    L0x31FF 
            POP     AF 
            CP      0xA6 
            JR      NZ,L0x33A1 
            JP      L0x3207 
L0x33A1:             
            CALL    L0x32E8 
            JP      L0x3221 
L0x33A7:             
            AND     0xC7 
            CP      0xC0 
            JR      NZ,L0x33C5 
            LD      A,0xC5 
            LD      B,0x01 
            CALL    L0x33B8 
            DEC     HL 
            LD      (HL),0x20 
            RET      
L0x33B8:             
            PUSH    BC 
            PUSH    AF 
            CALL    L0x31FF 
            POP     AF 
            CALL    L0x32E8 
            POP     BC 
            LD      A,C 
            JR      L0x3389 
L0x33C5:             
            LD      A,C 
            AND     0xC7 
            CP      0xC4 
            JR      NZ,L0x33D6 
            LD      A,0xC8 
L0x33CE:             
            LD      B,0x03 
            CALL    L0x33B8 
            JP      L0x3221 
L0x33D6:             
            CP      0xC2 
            JR      NZ,L0x33DE 
            LD      A,0xCC 
            JR      L0x33CE 
L0x33DE:             
            LD      A,C 
            AND     0xCF 
            CP      0xC1 
            JR      NZ,L0x33E9 
            LD      A,0xCE 
            JR      L0x33EE 
L0x33E9:             
            CP      0xC5 
            RET     NZ 
            LD      A,0xD1 
L0x33EE:             
            PUSH    BC 
            PUSH    AF 
            CALL    L0x3055 
            POP     AF 
            CALL    L0x32E8 
            POP     BC 
            LD      A,C 
            CP      0xF1 
            JR      Z,L0x3401 
            CP      0xF5 
            JR      NZ,L0x340B 
L0x3401:             
            LD      (HL),0x41 
            INC     HL 
            LD      (HL),0x46 
            INC     HL 
            LD      (DISEND),HL 
            RET      
L0x340B:             
            JP      L0x320B 
L0x340E:             
            AND     0xC7 
            CP      0xC7 
            JR      NZ,L0x3421 
            LD      A,C 
            PUSH    AF 
            LD      A,0xC2 
            CALL    L0x3511 
            POP     AF 
            AND     0x38 
            JP      L0x3191 
L0x3421:             
            AND     0xC6 
            CP      0xC6 
            LD      A,C 
            JR      NZ,L0x3440 
            XOR     A 
            CALL    L0x34F7 
            LD      A,C 
            PUSH    BC 
            CALL    L0x31AC 
            LD      A,0x86 
            ADD     A,C 
            ADD     A,C 
            ADD     A,C 
            CALL    L0x3207 
L0x3439:             
            CALL    L0x3086 
            POP     BC 
            JP      L0x324D 
L0x3440:             
            CP      0xED 
            JP      NZ,L0x34E8 
            LD      HL,(PERFROM) 
            INC     HL 
            LD      A,(HL) 
            LD      C,A 
            AND     0xC7 
            CP      0x43 
            JR      NZ,L0x3471 
            LD      B,0x04 
            CALL    L0x31FF 
            CALL    L0x3205 
            BIT     3,C 
            JR      NZ,L0x3468 
            PUSH    BC 
            CALL    L0x32AF 
            CALL    L0x3164 
            POP     BC 
            JP      L0x320A 
L0x3468:             
            CALL    L0x320A 
            CALL    L0x3164 
            JP      L0x32AF 
L0x3471:             
            LD      B,0x02 
            JR      L0x34DF 
L0x3475:             
            LD      A,C 
            AND     0xC7 
            CP      0x40 
            JR      NZ,L0x3496 
            PUSH    BC 
            LD      A,0xF0 
            CALL    L0x3207 
            POP     BC 
            LD      A,C 
            CALL    L0x31AC 
            LD      A,C 
            CALL    L0x310B 
            CALL    L0x3164 
L0x348E:             
            LD      BC,0x0022 
            LD      A,0x03 
            JP      L0x310D 
L0x3496:             
            CP      0x41 
            JR      NZ,L0x34AF 
            PUSH    BC 
            LD      A,0xED 
            CALL    L0x3207 
            CALL    L0x348E 
            CALL    L0x3164 
            POP     BC 
            LD      A,C 
            CALL    L0x31AC 
            LD      A,C 
            JP      L0x310B 
L0x34AF:             
            CP      0x42 
            JR      NZ,L0x34E8 
            PUSH    BC 
            LD      A,C 
            BIT     3,A 
            JR      NZ,L0x34C0 
            LD      A,0x8F 
            CALL    L0x3207 
            JR      L0x34C5 
L0x34C0:             
            LD      A,0x89 
            CALL    L0x3207 
L0x34C5:             
            CALL    L0x32A4 
            CALL    L0x3164 
            POP     BC 
            JP      L0x320A 
L0x34CF:             
            LD      B,0x1C 
            LD      HL,(PERFROM) 
            INC     HL 
            LD      A,(HL) 
            LD      HL,TBL_EXC 
            LD      B,0x1C 
            LD      D,0x02 
            JR      L0x3522 
L0x34DF:             
            AND     0x84 
            JR      NZ,L0x34CF 
            CALL    L0x31FF 
            JR      L0x3475 
L0x34E8:             
            CP      0xD3 
            JR      NZ,L0x3502 
            LD      A,0xED 
            CALL    L0x34F7 
            CALL    L0x34FB 
            JP      L0x3287 
L0x34F7:             
            LD      B,0x02 
            JR      L0x3513 
L0x34FB:             
            LD      HL,(PERFROM) 
            LD      A,(HL) 
            JP      L0x3191 
L0x3502:             
            CP      0xDB 
            JR      NZ,L0x354B 
            LD      A,0xF0 
            CALL    L0x34F7 
            LD      C,0x00 
            PUSH    BC 
            JP      L0x3439 
L0x3511:             
            LD      B,0x01 
L0x3513:             
            PUSH    AF 
            CALL    L0x31FF 
            POP     AF 
            OR      A 
            JP      NZ,L0x3207 
            RET      
L0x351D:             
            LD      B,0x13 
            LD      HL,TBL_OBT 
L0x3522:             
            CP      (HL) 
            JR      Z,L0x352F 
L0x3525:             
            INC     HL 
            BIT     7,(HL) 
            JR      Z,L0x3525 
            INC     HL 
            DJNZ    L0x3522 
            SCF      
            RET      
L0x352F:             
            PUSH    HL 
            LD      B,D 
            CALL    L0x31FF 
            POP     HL 
            LD      DE,(DISEND) 
L0x3539:             
            INC     HL 
            LD      A,(HL) 
            LD      (DE),A 
            INC     DE 
            BIT     7,A 
            JR      Z,L0x3539 
            EX      DE,HL 
            DEC     HL 
            RES     7,(HL) 
            INC     HL 
            LD      (DISEND),HL 
            OR      A 
            RET      
L0x354B:             
            LD      HL,(DISEND) 
            CP      0xDD 
            JR      NZ,L0x3559 
            LD      (HL),0x44 
            INC     HL 
            LD      A,0x11 
            JR      L0x3562 
L0x3559:             
            CP      0xFD 
            JR      NZ,L0x3590 
            LD      (HL),0x46 
            INC     HL 
            LD      A,0x22 
L0x3562:             
            LD      (DISFLAG),A 
            LD      (HL),0x44 
            INC     HL 
            INC     HL 
            LD      (DISEND),HL 
            LD      HL,(PERFROM) 
            INC     HL 
            LD      C,(HL) 
            LD      A,(HL) 
            LD      (PERFROM),HL 
            CP      0x36 
            PUSH    HL 
            CALL    Z,L0x31FD 
            LD      A,C 
            AND     0xFE 
            CP      0x34 
            LD      B,0x02 
            CALL    Z,L0x31FF 
            POP     HL 
            LD      A,(HL) 
            CP      0xE9 
            JR      Z,L0x358D 
            CP      0xE3 
L0x358D:             
            JR      Z,L0x360A 
            LD      A,C 
L0x3590:             
            JP      L0x31E9 
L0x3593:             
            LD      HL,(PERFROM) 
            DEC     HL 
            DEC     HL 
            LD      (PERFROM),HL 
            CALL    L0x3106 
L0x359E:             
            LD      HL,(PERFROM) 
            INC     HL 
            LD      (PERFROM),HL 
            RET      
L0x35A6:             
            RRA      
            RRA      
            RRA      
            CP      0x04 
            RET     NZ 
            LD      A,(DISFLAG) 
            RRCA     
            JR      NC,L0x35B5 
            LD      A,0xF3 
            RET      
L0x35B5:             
            RRCA     
            JR      NC,L0x35BB 
            LD      A,0xFA 
            RET      
L0x35BB:             
            LD      A,0x04 
            RET      
            LD      BC,0x0008 
            CALL    L0x310B 
            CALL    L0x35CD 
            LD      BC,0x000B 
            JP      L0x310B 
L0x35CD:             
            LD      A,(DISFLAG) 
            LD      B,0x00 
            RRCA     
            JR      NC,L0x35D9 
            LD      C,0x0D 
            JR      L0x35E2 
L0x35D9:             
            RRCA     
            JR      NC,L0x35E0 
            LD      C,0x14 
            JR      L0x35E2 
L0x35E0:             
            LD      C,0x04 
L0x35E2:             
            LD      A,0x02 
            JP      L0x310D 
L0x35E7:             
            LD      A,(DISFLAG) 
            RRCA     
L0x35EB:             
            JR      C,L0x3593 
            RRCA     
            JR      C,L0x35EB 
            JP      L0x3106 
L0x35F3:             
            LD      HL,(PERFROM) 
            LD      E,(HL) 
            XOR     A 
            BIT     7,E 
            JR      Z,L0x35FD 
            CPL      
L0x35FD:             
            LD      D,A 
            INC     HL 
            ADD     HL,DE 
            JP      L0x318A 
L0x3603:             
            POP     HL 
            POP     AF 
            PUSH    HL 
            PUSH    AF 
            JP      L0x326B 
L0x360A:             
            LD      A,C 
            CALL    L0x351D 
L0x360E:             
            DEC     HL 
            LD      A,(HL) 
            CP      0x48 
            JR      NZ,L0x360E 
            LD      (HL),0x49 
            INC     HL 
            LD      (HL),0x58 
            LD      A,(DISFLAG) 
            RRCA     
            RET     C 
            INC     (HL) 
            RET      

;START OF Loopup tables
;ORG 3620
TBL_OPS:             
            DB      0x49 ;I 82 < WHERE "82H" IS THE INDEX HERE
            DB      0x4C,0xC4,0x00 ;LD 83
            DB      0x41,0x44,0xC4 ;ADD 86
            DB      0x41,0x44,0xC3 ;ADC 89
            DB      0x53,0x55,0xC2 ;SUB 8C
            DB      0x53,0x42,0xC3 ;SBC 8F
            DB      0x41,0x4E,0xC4 ;AND 92
            DB      0x58,0x4F,0xD2 ;XOR 95
            DB      0x4F,0xD2,0x00 ;OR 98
            DB      0x43,0xD0,0x00 ;CP 9B
            DB      0x52,0x4C,0xC3 ;RLC 9E
            DB      0x52,0x52,0xC3 ;RRC A1
            DB      0x52,0xCC,0x00 ;RL A4
            DB      0x52,0xD2,0x00 ;RR A7
            DB      0x53,0x4C,0xC1 ;SLA AA
            DB      0x53,0x52,0xC1 ;SRA AD
            DB      0x53,0x52,0xCC ;SRL B0
            DB      0x42,0x49,0xD4 ;BIT B3
            DB      0x52,0x45,0xD3 ;RES B6
            DB      0x53,0x45,0xD4 ;SET B9
            DB      0x49,0x4E,0xC3 ;INC BC
            DB      0x44,0x45,0xC3 ;DEC BF
            DB      0x52,0x53,0xD4 ;RST C2
            DB      0x52,0x45,0xD4 ;RET C5
            DB      0x43,0x41,0x4C,0xCC ;CALL C8
            DB      0x4A,0xD0 ;JP CC
            DB      0x50,0x4F,0xD0 ;POP CE
            DB      0x50,0x55,0x53,0xC8 ;PUSH D1
            DB      0x4A,0xD2 ;JR D5
            DB      0x45,0xD8 ;EX D7
            DB      0x44,0x4A,0x4E,0xDA ;DJNZ D9

TBL_FLG:             
            DB      0x4E,0xDA ;NZ DD
            DB      0xDA,0x20 ;Z_ DF
            DB      0x4E,0xC3 ;NC E1
            DB      0xC3,0x00 ;C_E3
            DB      0x50,0xCF ;PO E5
            DB      0x50,0xC5 ;PE E7
            DB      0xD0,0x00 ;P_ E9
            DB      0xCD,0x00 ;M_ EB
            DB      0x4F,0x55,0xD4 ;OUT ED
            DB      0x49,0xCE ;IN F0

TBL_OBT:             
            DB      0x00,0x4E,0x4F,0xD0 ;NOP
            DB      0x07,0x52,0x4C,0x43,0xC1 ;RLCA
            DB      0x08,0x45,0x58,0x20,0x41,0x46,0x2C,0x41,0x46,0xA7 ;EX AF,AF'
            DB      0x0F,0x52,0x52,0x43,0xC1 ;RRCA
            DB      0x17,0x52,0x4C,0xC1 ;RLA
            DB      0x1F,0x52,0x52,0xC1 ;RRA
            DB      0x27,0x44,0x41,0xC1 ;DAA
            DB      0x2F,0x43,0x50,0xCC ;CPL
            DB      0x37,0x53,0x43,0xC6 ;SCF
            DB      0x3F,0x43,0x43,0xC6 ;CCF
            DB      0x76,0x48,0x41,0x4C,0xD4 ;HALT
            DB      0xC9,0x52,0x45,0xD4 ;RET
            DB      0xD9,0x45,0x58,0xD8 ;EXX
            DB      0xE3,0x45,0x58,0x20,0x28,0x53,0x50,0x29,0x2C,0x48,0xCC ;EX (SP),HL
            DB      0xE9,0x4A,0x50,0x20,0x28,0x48,0x4C,0xA9 ;JP (HL)
            DB      0xEB,0x45,0x58,0x20,0x44,0x45,0x2C,0x48,0xCC ;EX DE,HL
            DB      0xF3,0x44,0xC9 ;DI
            DB      0xF9,0x4C,0x44,0x20,0x53,0x50,0x2C,0x48,0xCC ;LD SP,HL
            DB      0xFB,0x45,0xC9 ;EI

TBL_EXC:             
            DB      0x44,0x4E,0x45,0xC7 ;NEG
            DB      0x45,0x52,0x45,0x54,0xCE ;RETN
            DB      0x46,0x49,0x4D,0x20,0xB0 ;IM 0
            DB      0x47,0x4C,0x44,0x20,0x49,0x2C,0xC1 ;LD I,A
            DB      0x4D,0x52,0x45,0x54,0xC9 ;RETI
            DB      0x4F,0x4C,0x44,0x20,0x52,0x2C,0xC1 ;LD R,A
            DB      0x56,0x49,0x4D,0x20,0xB1 ;IM 1
            DB      0x57,0x4C,0x44,0x20,0x41,0x2C,0xC9 ;LD A,I
            DB      0x5E,0x49,0x4D,0x20,0xB2 ;IM 2
            DB      0x5F,0x4C,0x44,0x20,0x41,0x2C,0xD2 ;LD A,R
            DB      0x67,0x52,0x52,0xC4 ;RRD
            DB      0x6F,0x52,0x4C,0xC4 ;RLD
            DB      0xA0,0x4C,0x44,0xC9 ;LDI
            DB      0xA1,0x43,0x50,0xC9 ;CPI
            DB      0xA2,0x49,0x4E,0xC9 ;INI
            DB      0xA3,0x4F,0x55,0x54,0xC9 ;OUTI
            DB      0xA8,0x4C,0x44,0xC4 ;LDD
            DB      0xA9,0x43,0x50,0xC4 ;CPD
            DB      0xAA,0x49,0x4E,0xC4 ;IND
            DB      0xAB,0x4F,0x55,0x54,0xC4 ;OUTD
            DB      0xB0,0x4C,0x44,0x49,0xD2 ;LDIR
            DB      0xB1,0x43,0x50,0x49,0xD2 ;CPIR
            DB      0xB2,0x49,0x4E,0x49,0xD2 ;INIR
            DB      0xB3,0x4F,0x54,0x49,0xD2 ;OTIR
            DB      0xB8,0x4C,0x44,0x44,0xD2 ;LDDR
            DB      0xB9,0x43,0x50,0x44,0xD2 ;CPDR
            DB      0xBA,0x49,0x4E,0x44,0xD2 ;INDR
            DB      0xBB,0x4F,0x54,0x44,0xD2 ;OTDR

TBL_REG:             
            DB      0x42,0x43 ;BC
            DB      0x44,0x45 ;DE
            DB      0x48,0x4C ;HL
            DB      0x2C,0x41 ;,A
            DB      0x28,0x48,0x4C,0x29 ;(HL)
            DB      0x28,0x49,0x58,0x2B,0x20,0x1F,0x29 ;(IX+__)
            DB      0x28,0x49,0x59,0x2B,0x20,0x1F,0x29 ;(IY+__)

TBL_SREG:            
            DB      0x42 ;B
            DB      0x43 ;C
            DB      0x44 ;D
            DB      0x45 ;E
            DB      0x48 ;H
            DB      0x4C ;L
            DB      0x53 ;S
            DB      0x50 ;P
            DB      0x28,0x43,0x29 ;(C)

            DB      0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF ;FILL

;Entry Point to Disassembler if using JMON Perimeter Handler
L0x37B0:             
            LD      HL,TBL_PERM-2 
            LD      DE,PERMENU 
            LD      BC,0x000A 
            LDIR     
            JP      PERMJMP 
L0x37BE:             
            CALL    DIS_START 
            RST     0x30 
            LD      A,0x01 
            OUT     (LCDCOM),A 
            LD      HL,DISFROM 
            LD      B,0x10 
L0x37CB:             
            RST     0x30 
            LD      A,(HL) 
            OUT     (LCDDAT),A 
            INC     HL 
            DJNZ    L0x37CB 
            RST     0x30 
            LD      A,0xC3 
            OUT     (LCDCOM),A 
            LD      B,0x10 
            LD      HL,DISMID 
L0x37DC:             
            RST     0x30 
            LD      A,(HL) 
            OUT     (LCDDAT),A 
            INC     HL 
            DJNZ    L0x37DC 
            HALT     
            JR      L0x37BE 
L0x37E6:             
            IN      A,(LCDCOM) 
            BIT     7,A 
            JR      NZ,L0x37E6 
            RET      
TBL_PERM:            
            DB      0xF7,0x37,0x99,0x08,0x00,0x01,0xBE,0x37 
            DB      0xFF,0xFF 
            DB      0x04,0xA7 ; "-S" ;START ADDRESS
            DB      0x04,0xC7 ;"-E" ;END ADDRESS

            DB      0xC9,0xC9,0x06,0x06,0xE6 

