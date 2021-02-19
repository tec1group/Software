;
;    Bealach An Doirín
;
; programmed by John Hardy and Ken Stone for the TEC-1 Computer 
; 
;
PORTSEGS        EQU    0x02
PORTDIGIT       EQU    0x01

MAIN            EQU    0x00

                ORG     0x0800

PLAYTUNE:       
                LD      de,TUNE       ;de = address of tune

PTLOOP1:        LD      a,(de)          ;a = (de); a = note
                AND     0x1f            ;mask lower 5 bits
                CP      0x1f            ;if (a == ENDOFTUNE)
                JP      nz,CPTLOOP
                ld      c,MAIN          ;use the system call back to main
                RST     30h             ;    return  
                                        
CPTLOOP:        CP      0x1e            ;if (a == REPEATTUNE)
                JP      z,PLAYTUNE      ;  goto PLAYTUNE
                CP      0x00            ;if (a == SILENCE)
                JP      z,PTSILENCE     ;  goto PTSILENCE
                LD      b,a             ;b = note
                INC     de              ;de++
                PUSH    de              ;save de
                LD      hl,FREQWL       ;hl = frequency wave length
                CALL    TBLOOKUP        ;a = lookup note
                PUSH    af              ;save a
                LD      a,b             ;a = note
                LD      hl,FREQNC       ;h1 = frequency num cycles
                CALL    TBLOOKUP        ;a = lookup note
                LD      l,a
                LD      h,0x00          ;hl = num cycles
                POP     af              ;restore a
                LD      c,a             ;c = wave length
                CALL    PLAYTONE        ;c and hl
                POP     de              ;save de
                JP      PTLOOP1         ;play next note
;subroutine: lookup offset in table
;a = offset
;hl = table
;result in a
;destroys e, d
TBLOOKUP:       LD      e,a             ;e = offset
                LD      d,0x00          ;d = 0
                ADD     hl,de           ;hl = hl + de
                LD      a,(hl)          ;a = table + offset
                RET                     ;return
PTSILENCE:      PUSH    de              ;save de
                LD      de,0x1000       ;delay count = 1000
PTLOOP2:        DEC     de              ;de--
                LD      a,d
                OR      e               ;if (de != 0)
                JP      nz,PTLOOP2      ;  goto PTLOOP2
                POP     de              ;restore de
                INC     de              ;de++
                JP      PTLOOP1         ;play next note     
;subroutine: play tone, freq c, duration h1
;destroys: hl, de, a, b
PLAYTONE:       ADD     hl,hl           ;hl = hl + h1
                LD      de,0x0001       ;de = 1
                XOR     a               ;a = 0
                OUT     (PORTSEGS),a    ;clear segments
                DEC     a               ;a = FF
MTLOOP:         OUT     (PORTDIGIT),a   ;all digitis on?
                LD      b,c             ;b = c
MTDELAY:        DJNZ    MTDELAY         ;delay?
                XOR     0x80            ;invert bit 7 of a (clear carry?)
                SBC     hl,de           ;hl = hl - 1
                JR      nz,MTLOOP
                RET

FREQWL	DB	8CH,83H,7CH,75H,70H,67H,62H,5CH
	    DB	57H,52H,4EH,48H,45H,41H,3CH,39H
	    DB	36H,32H,2FH,2CH,2AH,27H,25H,23H

FREQNC	DB	19H,1AH,1CH,1DH,1EH,20H,23H,25H
	    DB	27H,29H,2CH,2EH,31H,33H,37H,3AH
	    DB	3DH,41H,45H,49H,4DH,52H,57H,5CH
	    DB	10H

TUNE    DB      0x0B            ;Bealach An Doirín
        DB      0x0A
        DB      0x08
        DB      0x0A
        DB      0x0A
        DB      0x0A
        DB      0x06
        DB      0x06
        DB      0x06
        DB      0x0B
        DB      0x0A
        DB      0x08
        DB      0x0A
        DB      0x0A
        DB      0x0A
        DB      0x0A
        DB      0x0A
        DB      0x0A
        DB      0x0B
        DB      0x0A
        DB      0x08
        DB      0x0A
        DB      0x0A
        DB      0x0A
        DB      0x06,0x06
        DB      0x06,0x0A
        DB      0x08
        DB      0x0A
        DB      0x0D
        DB      0x0D
        DB      0x0D
        DB      0x0D
        DB      0x0D
        DB      0x00
        DB      0x0D
        DB      0x05
        DB      0x08
        DB      0x0B
        DB      0x0B
        DB      0x0B
        DB      0x06,0x06
        DB      0x06,0x0B
        DB      0x0A
        DB      0x08
        DB      0x0A
        DB      0x0A
        DB      0x0A
        DB      0x06,0x06
        DB      0x06,0x0B
        DB      0x0A
        DB      0x06,0x08
        DB      0x08
        DB      0x08
        DB      0x08
        DB      0x08
        DB      0x0A
        DB      0x0B
        DB      0x0A
        DB      0x08
        DB      0x06,0x06
        DB      0x06,0x06
        DB      0x06,0x06
        DB      0x00
        DB      0x00
        DB      0x00
        DB      0x1F
        END
      