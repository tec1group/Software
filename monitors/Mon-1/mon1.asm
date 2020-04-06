0000                ;
0000                ; TEC-1 Monitor ROM v1 (c) John Hardy 1983 - 2018
0000                ; Released under the GNU GENERAL PUBLIC LICENSE 3.0
0000                ;
0000                STARTRAM:       EQU     0x800
0000                STARTSTACK:     EQU     0x0ff0
0000                DISPLAY:        EQU     0x0ff1          ;display start (data part)
0000                DISPLAY2:       EQU     0x0ff3          ;display address part offset
0000                DISPLAY3:       EQU     0x0ff4          ;display address part offset
0000                DISPLAY4:       EQU     0x0ff5          ;second last display digit
0000                DISPLAY5:       EQU     0x0ff6          ;second last display digit
0000                DISPLAY6:       EQU     0x0ff7          ;last display digit
0000                ADDRESS:        EQU     0x0ff7          ;stores the address pointer
0000                MODE:           EQU     0x0ff9          ;0 = ADDR_MODE, 67 = DATA_MODE
0000                KEYFLAG:        EQU     0x0ffa          ;boolean, if false then it's the
0000                                                        ;first key press after a mode change
0000                INV_SCORE:      EQU     0x0ffa          ;variable 1 used in INVADERS
0000                INV_GUN:        EQU     0x0ffb          ;variable 2 used in INVADERS
0000                PORTKEYB:       EQU     0x00            ;keyboard value
0000                PORTDIGIT:      EQU     0x01            ;bits 0-5 select display digit
0000                PORTSPKR:       EQU     0x01            ;bit 7 selects speaker
0000                PORTSEGS:       EQU     0x02            ;bits 0-8 select display segments
0000                PORTSLOW:       EQU     0x03            ;output port for slow sequencer
0000                PORTFAST:       EQU     0x04            ;output port for fast sequencer
0000                SLOWSEQ:        EQU     0x0800          ;fast and slow sequencer data
0000                FASTSEQ:        EQU     0x0b00          ;see SEQUENCER code
0000                ENDOFSEQ:       EQU     0xFF            ;end of sequence
0000                REPEATTEXT:     EQU     0x1E            ;repeat showing banner
0000                ENDOFTEXT:      EQU     0x1F            ;end of banner
0000                REPEATTUNE:     EQU     0x1E            ;repeat playing tune
0000                ENDOFTUNE:      EQU     0x1F            ;end of tune
0000                NIMMATCHES:     EQU     0x0ffa          ;nim: number of matches
0000                                ORG     0x0000
0000   C3 80 05                     JP      STARTMON
0003   FF                           DB      0xFF
0004   FF                           DB      0xFF
0005   FF                           DB      0xFF
0006   FF                           DB      0xFF
0007   FF                           DB      0xFF
0008   C3 20 03                     JP      INVADERS        ;RST  not needed
000B   FF                           DB      0xFF
000C   FF                           DB      0xFF
000D   FF                           DB      0xFF
000E   FF                           DB      0xFF
000F   FF                           DB      0xFF
0010   C3 E0 03                     JP      NIM             ;RST  not needed
0013   FF                           DB      0xFF
0014   FF                           DB      0xFF
0015   FF                           DB      0xFF
0016   FF                           DB      0xFF
0017   FF                           DB      0xFF
0018   C3 90 04                     JP      LUNALANDER      ;RST  not needed
001B   FF                           DB      0xFF
001C   FF                           DB      0xFF
001D   FF                           DB      0xFF
001E   FF                           DB      0xFF
001F   FF                           DB      0xFF
0020   FF                           DB      0xFF
0021   FF                           DB      0xFF
0022   FF                           DB      0xFF
0023   FF                           DB      0xFF
0024   FF                           DB      0xFF
0025   FF                           DB      0xFF
0026   FF                           DB      0xFF
0027   FF                           DB      0xFF
0028   21 30 02                     LD      hl,TUNE1        ;BAD IDEA! not needed
002B   C3 41 00                     JP      STARTTUNE
002E   FF                           DB      0xFF
002F   FF                           DB      0xFF
0030   21 30 05                     LD      hl,TUNE2        ;BAD IDEA! not needed
0033   C3 41 00                     JP      STARTTUNE
0036   FF                           DB      0xFF
0037   FF                           DB      0xFF
0038   21 D1 02                     LD      hl,0x02d1
003B   22 00 08                     LD      (0x0800),hl
003E   C3 70 02                     JP      0x0270
0041   22 00 08     STARTTUNE:      LD      (STARTRAM),hl   ;load address of tune from STARTRAMAM
0044   C3 B0 01                     JP      PLAYTUNE
0047   FF                           DB      0xFF
0048   FF                           DB      0xFF
0049   FF                           DB      0xFF
004A   FF                           DB      0xFF
004B   FF                           DB      0xFF
004C   FF                           DB      0xFF
004D   FF                           DB      0xFF
004E   FF                           DB      0xFF
004F   FF                           DB      0xFF
0050   FF                           DB      0xFF
0051   FF                           DB      0xFF
0052   FF                           DB      0xFF
0053   FF                           DB      0xFF
0054   FF                           DB      0xFF
0055   FF                           DB      0xFF
0056   FF                           DB      0xFF
0057   FF                           DB      0xFF
0058   FF                           DB      0xFF
0059   FF                           DB      0xFF
005A   FF                           DB      0xFF
005B   FF                           DB      0xFF
005C   FF                           DB      0xFF
005D   FF                           DB      0xFF
005E   FF                           DB      0xFF
005F   FF                           DB      0xFF
0060   FF                           DB      0xFF
0061   FF                           DB      0xFF
0062   FF                           DB      0xFF
0063   FF                           DB      0xFF
0064   FF                           DB      0xFF
0065   FF                           DB      0xFF
0066                                                        ;non-maskable interrupt: read key from keyboard into i
0066                                                        ;destroys a    BUG: fix bug to save a
0066                NMINT:          ORG     0x0066
0066   DB 00                        IN      a,(0x00)        ;input a from keyboard
0068   E6 1F                        AND     0x1f            ;mask lower 5 bits
006A   ED 47                        LD      i,a             ;move to i register
006C   C9                           RET                     ;BUG: should be RETN
006D                                                        ;b   ranches here after WRITEDISP
006D   31 D0 0F     WRITEDISP2:     LD      sp,STARTSTACK
0070   CD 31 01                     CALL    GETKEY          ;(blocking) get key
0073   CD 8E 01                     CALL    BEEP            ;beep
0076   3A F9 0F                     LD      a,(MODE)        ;a = addr/data
0079   FE 00                        CP      0x00            ;z = (MODE == ADDR_MODE)
007B   C2 96 00                     JP      nz,WRITEDISP3
007E                                                        ;i   s ADDR_MODE
007E   ED 57                        LD      a,i             ;a = key
0080   FE 10                        CP      0x10
0082   DA 88 00                     JP      c,ADDRKEY       ;key is numeric
0085   C3 E3 00                     JP      DATADISP        ;change to DATA_MODE
0088   21 F7 0F     ADDRKEY:        LD      hl,ADDRESS
008B   CD 6F 01                     CALL    GETADDRKEY      ;getkey and clear 16 bits if !KEYFLAG
008E   ED 6F                        RLD                     ;rotate left nibble (hl) <- a
0090   23                           INC     hl              ;point to upper byte
0091   ED 6F                        RLD                     ;rotate left nibble (hl) <- a
0093   C3 DA 00                     JP      ADDRDISP        ;change to ADDR_MODE,
0096   ED 57        WRITEDISP3:     LD      a,i             ;is DATA_MODE
0098   FE 10                        CP      0x10
009A   DA B7 00                     JP      c,DATAKEY       ;key is numeric
009D   AF                           XOR     a               ;is function key
009E   32 FA 0F                     LD      (KEYFLAG),a     ;(KEYFLAG)=false init key after mode changehange
00A1   ED 57                        LD      a,i             ;a = key value
00A3   FE 13                        CP      0x13            ;(AD) MODE key
00A5   CA DA 00                     JP      z,ADDRDISP
00A8   FE 12                        CP      0x12            ;(GO) KEY
00AA   CA C2 00                     JP      z,GOADDR
00AD   FE 11                        CP      0x11            ;(-) KEY
00AF   CA C6 00                     JP      z,DECADDR
00B2   FE 10                        CP      0x10            ;(+) KEY
00B4   CA D0 00                     JP      z,INCADDR
00B7   2A F7 0F     DATAKEY:        LD      hl,(ADDRESS)
00BA   CD 7B 01                     CALL    GETDATAKEY      ;getkey and clear 16 bits if !KEYFLAG
00BD   ED 6F                        RLD                     ;rotate left nibble (hl) <- a
00BF   C3 E3 00                     JP      DATADISP
00C2   2A F7 0F     GOADDR:         LD      hl,(ADDRESS)
00C5   E9                           JP      (hl)            ;jump (ADDRESS)
00C6   2A F7 0F     DECADDR:        LD      hl,(ADDRESS)    ;(ADDRESS)--
00C9   2B                           DEC     hl
00CA   22 F7 0F                     LD      (ADDRESS),hl
00CD   C3 E3 00                     JP      DATADISP
00D0   2A F7 0F     INCADDR:        LD      hl,(ADDRESS)    ;(ADDRESS)++
00D3   23                           INC     hl
00D4   22 F7 0F                     LD      (ADDRESS),hl
00D7   C3 E3 00                     JP      DATADISP
00DA   3E 00        ADDRDISP:       LD      a,0x00          ;0
00DC   06 04                        LD      b,0x04          ;4 digits
00DE   21 F3 0F                     LD      hl,DISPLAY2     ;display+2 offset for address
00E1   18 07                        JR      WRITEDISP
00E3   3E 67        DATADISP:       LD      a,0x67          ;01100111
00E5   06 02                        LD      b,0x02          ;two digits
00E7   21 F1 0F                     LD      hl,DISPLAY      ;display+0 offset for data
00EA                                                        ;goto WRITEDISP (fall-thru)
00EA                                                        ;subroutine: write HEX values for ADDRESS and (ADDRESS))
00EA                                                        ;updates mode i.e. data or address
00EA                                                        ;show focus for mode with decimal points
00EA                                                        ;a = mode data (67) or address (0)
00EA                                                        ;b = num decimal points to focus
00EA                                                        ;hl = offset into display to focus
00EA   32 F9 0F     WRITEDISP:      LD      (MODE),a
00ED   D9                           EXX
00EE   ED 5B F7 0F                  LD      de,(ADDRESS)    ;de = ADDRESS value
00F2   CD 02 01                     CALL    WRITEADDR
00F5   1A                           LD      a,(de)          ;a = (ADDRESS) value
00F6   CD 0E 01                     CALL    WRITEDATA
00F9   D9                           EXX
00FA   CB E6        DPLOOP:         SET     4,(hl)          ; set decimal point
00FC   23                           INC     hl
00FD   10 FB                        DJNZ    DPLOOP
00FF   C3 6D 00                     JP      WRITEDISP2
0102                                                        ;subroutine: write HEX value of de to DISPLAY+2
0102                                                        ;destroys a, hl
0102   21 F3 0F     WRITEADDR:      LD      hl,DISPLAY2
0105   7B                           LD      a,e
0106   CD 15 01                     CALL    WRITEHEX
0109   7A                           LD      a,d
010A   CD 15 01                     CALL    WRITEHEX
010D   C9                           RET
010E                                                        ;subroutine: write HEX value of a to DISPLAY
010E                                                        ;destroys a, hl
010E   21 F1 0F     WRITEDATA:      LD      hl,DISPLAY      ;hl = DISPLAY
0111   CD 15 01                     CALL    WRITEHEX        ;write a to (hl)
0114   C9                           RET
0115                                                        ;subroutine: write HEX value of a to (hl)
0115                                                        ;destroys a
0115                                                        ;hl = h1 + 2
0115   F5           WRITEHEX:       PUSH    af              ;save a
0116   CD 26 01                     CALL    HEX2SEGS        ;convert lower HEX nibble to segments
0119   77                           LD      (hl),a          ;write a to (hl)
011A   23                           INC     hl              ;hl++
011B   F1                           POP     af              ;restore a
011C   0F                           RRCA                    ;shift upper HEX nibble to lower
011D   0F                           RRCA
011E   0F                           RRCA
011F   0F                           RRCA
0120   CD 26 01                     CALL    HEX2SEGS        ;convert lower HEX nibble to segments
0123   77                           LD      (hl),a          ;write to (hl)
0124   23                           INC     hl              ;hl++
0125   C9                           RET                     ;return
0126                                                        ;subroutine: convert number in a to segments
0126                                                        ;a    = HEXSEGTBL[a]
0126   E5           HEX2SEGS:       PUSH    hl              ;save hl
0127   21 5F 01                     LD      hl,HEXSEGTBL    ;hl = HEXSEGTBL
012A   E6 0F                        AND     0x0f            ; a && 0xF
012C   85                           ADD     a,l             ; hl = hl + a
012D   6F                           LD      l,a
012E   7E                           LD      a,(hl)          ;HEXSEGTBL[a]
012F   E1                           POP     hl              ;restore hl
0130   C9                           RET                     ;return
0131                                                        ;subroutine: scan display while watching for keypress
0131                                                        ;i = key
0131                                                        ;destroys a
0131   3E FF        GETKEY:         LD      a,0xff
0133   ED 47                        LD      i,a             ;i == FF ie. NOKEY
0135   CD 40 01                     CALL    SCANDISP        ;scan the display
0138   ED 57                        LD      a,i
013A   FE FF                        CP      0xff
013C   C0                           RET     nz              ;if (i != NOKEY) return i
013D   C3 31 01                     JP      GETKEY
0140                                                        ;subroutine: display each digit in turn
0140                                                        ;destroys b, c, a
0140   DD E5        SCANDISP:       PUSH    ix              ;save ix, ix == DISPLAY???
0142   01 01 06                     LD      bc,0x0601       ;b = numdigits, c = 1
0145   DD 7E 00     L145:           LD      a,(ix+0)        ;a = (ix)
0148   D3 02                        OUT     (PORTSEGS),a    ;out segments
014A   DD 23                        INC     ix              ;ix++
014C   79                           LD      a,c             ;a = c
014D   D3 01                        OUT     (PORTDIGIT),a   ;out digit
014F   CB 27                        SLA     a               ;shift left to next digit
0151   4F                           LD      c,a             ;c = a
0152   3E 0A                        LD      a,0x0a          ;a = 0A (10)
0154   3D           SDDELAY:        DEC     a               ;a--
0155   C2 54 01                     JP      nz,SDDELAY      ;loop delay???
0158   D3 01                        OUT     (PORTDIGIT),a   ;a = 0, turn off digits?
015A   10 E9                        DJNZ    L145            ;loop until b == 0
015C   DD E1                        POP     ix              ;restore ix
015E   C9                           RET                     ;return
015F   EB           HEXSEGTBL:      DB      0xEB            ;0 7 SEGMENTS FOR NUMBERS
0160   28                           DB      0x28            ;1
0161   CD                           DB      0xCD            ;2
0162   AD                           DB      0xAD            ;3
0163   2E                           DB      0x2E            ;4
0164   A7                           DB      0xA7            ;5
0165   E7                           DB      0xE7            ;6
0166   29                           DB      0x29            ;7
0167   EF                           DB      0xEF            ;8
0168   2F                           DB      0x2F            ;9
0169   6F                           DB      0x6F            ;A
016A   E6                           DB      0xE6            ;B
016B   C3                           DB      0xC3            ;C
016C   EC                           DB      0xEC            ;D
016D   C7                           DB      0xC7            ;E
016E   47                           DB      0x47            ;F
016F                                                        ;subroutine: getkey, check KEYFLAG
016F                                                        ;if !(KEYFLAG) then blanks (hl) and (hl+1)
016F                                                        ;returns key in a
016F                                                        ;destroys: b
016F   CD 7B 01     GETADDRKEY:     CALL    GETDATAKEY      ;get key
0172   C0                           RET     nz              ; if ((KEYFLAG) == false) {
0173   23                           INC     hl              ;
0174   3E 00                        LD      a,0x00          ;
0176   77                           LD      (hl),a          ;   (hl+1) = 0
0177   2B                           DEC     hl
0178                                                        ; }
0178   ED 57                        LD      a,i             ;
017A   C9                           RET                     ;return (a=key)
017B                                                        ;subroutine: getkey, check KEYFLAG
017B                                                        ;if !(KEYFLAG) then blanks (hl)
017B                                                        ;returns key in a
017B                                                        ;destroys: b
017B   ED 57        GETDATAKEY:     LD      a,i
017D   47                           LD      b,a             ;b = key
017E   3A FA 0F                     LD      a,(KEYFLAG)
0181   FE 00                        CP      0x00
0183   78                           LD      a,b
0184   C0                           RET     nz              ; if ((KEYFLAG) == false){
0185   AF                           XOR     a               ;
0186   77                           LD      (hl),a          ;   (hl) = 0
0187   3D                           DEC     a
0188   32 FA 0F                     LD      (KEYFLAG),a     ;   (KEYFLAG) = true
018B                                                        ; }
018B   78                           LD      a,b             ;
018C   C9                           RET                     ;return a=key
018D   00                           NOP
018E   0E 0A        BEEP:           LD      c,0x0a          ;c = 0A (10)
0190   21 50 00                     LD      hl,0x0050       ;hl = 50 (80)
0193                                                        ;fall thru to PLAYTONE
0193                                                        ;subroutine: play tone, freq c, duration h1
0193                                                        ;destroys: hl, de, a, b
0193   29           PLAYTONE:       ADD     hl,hl           ;hl = hl + h1
0194   11 01 00                     LD      de,0x0001       ;de = 1
0197   AF                           XOR     a               ;a = 0
0198   D3 02                        OUT     (PORTSEGS),a    ;clear segments
019A   3D                           DEC     a               ;a = FF
019B   D3 01        MTLOOP:         OUT     (PORTDIGIT),a   ;all digitis on?
019D   41                           LD      b,c             ;b = c
019E   10 FE        MTDELAY:        DJNZ    MTDELAY         ;delay?
01A0   EE 80                        XOR     0x80            ;invert bit 7 of a (clear carry?)
01A2   ED 52                        SBC     hl,de           ;hl = hl - 1
01A4   20 F5                        JR      nz,MTLOOP
01A6   C9                           RET
01A7   FF                           DB      0xFF
01A8   FF                           DB      0xFF
01A9   FF                           DB      0xFF
01AA   FF                           DB      0xFF
01AB   FF                           DB      0xFF
01AC   FF                           DB      0xFF
01AD   FF                           DB      0xFF
01AE   FF                           DB      0xFF
01AF   FF                           DB      0xFF
01B0                PLAYTUNE:       ORG     0x01B0
01B0   ED 5B 00 08                  LD      de,(STARTRAM)   ;de = address of tune
01B4   1A           PTLOOP1:        LD      a,(de)          ;a = (de); a = note
01B5   E6 1F                        AND     0x1f            ;mask lower 5 bits
01B7   FE 1F                        CP      0x1f            ;if (a == ENDOFTUNE)
01B9   C8                           RET     z               ;    return
01BA   00                           NOP
01BB   00                           NOP
01BC   FE 1E                        CP      0x1e            ;if (a == REPEATTUNE)
01BE   CA B0 01                     JP      z,PLAYTUNE      ;  goto PLAYTUNE
01C1   FE 00                        CP      0x00            ;if (a == SILENCE)
01C3   CA E9 01                     JP      z,PTSILENCE     ;  goto PTSILENCE
01C6   47                           LD      b,a             ;b = note
01C7   13                           INC     de              ;de++
01C8   D5                           PUSH    de              ;save de
01C9   21 F8 01                     LD      hl,FREQWL       ;hl = frequency wave length
01CC   CD E3 01                     CALL    TBLOOKUP        ;a = lookup note
01CF   F5                           PUSH    af              ;save a
01D0   78                           LD      a,b             ;a = note
01D1   21 10 02                     LD      hl,FREQNC       ;h1 = frequency num cycles
01D4   CD E3 01                     CALL    TBLOOKUP        ;a = lookup note
01D7   6F                           LD      l,a
01D8   26 00                        LD      h,0x00          ;hl = num cycles
01DA   F1                           POP     af              ;restore a
01DB   4F                           LD      c,a             ;c = wave length
01DC   CD 93 01                     CALL    PLAYTONE        ;c and hl
01DF   D1                           POP     de              ;save de
01E0   C3 B4 01                     JP      PTLOOP1         ;play next note
01E3                                                        ;subroutine: lookup offset in table
01E3                                                        ;a = offset
01E3                                                        ;hl = table
01E3                                                        ;result in a
01E3                                                        ;destroys e, d
01E3   5F           TBLOOKUP:       LD      e,a             ;e = offset
01E4   16 00                        LD      d,0x00          ;d = 0
01E6   19                           ADD     hl,de           ;hl = hl + de
01E7   7E                           LD      a,(hl)          ;a = table + offset
01E8   C9                           RET                     ;return
01E9   D5           PTSILENCE:      PUSH    de              ;save de
01EA   11 00 10                     LD      de,0x1000       ;delay count = 1000
01ED   1B           PTLOOP2:        DEC     de              ;de--
01EE   7A                           LD      a,d
01EF   B3                           OR      e               ;if (de != 0)
01F0   C2 ED 01                     JP      nz,PTLOOP2      ;  goto PTLOOP2
01F3   D1                           POP     de              ;restore de
01F4   13                           INC     de              ;de++
01F5   C3 B4 01                     JP      PTLOOP1         ;play next note
01F8   8C           FREQWL:         ADC     a,h
01F9   83                           ADD     a,e
01FA   7C                           LD      a,h
01FB   75                           LD      (hl),l
01FC   70                           LD      (hl),b
01FD   67                           LD      h,a
01FE   62                           LD      h,d
01FF   5C                           LD      e,h
0200   57                           LD      d,a
0201   52                           LD      d,d
0202   4E                           LD      c,(hl)
0203   48                           LD      c,b
0204   45                           LD      b,l
0205   41                           LD      b,c
0206   3C                           INC     a
0207   39                           ADD     hl,sp
0208   36 32                        LD      (hl),0x32
020A   2F                           CPL
020B   2C                           INC     l
020C   2A 27 25                     LD      hl,(0x2527)
020F   23                           INC     hl
0210   19           FREQNC:         ADD     hl,de
0211   1A                           LD      a,(de)
0212   1C                           INC     e
0213   1D                           DEC     e
0214   1E 20                        LD      e,0x20
0216   23                           INC     hl
0217   25                           DEC     h
0218   27                           DAA
0219   29                           ADD     hl,hl
021A   2C                           INC     l
021B   2E 31                        LD      l,0x31
021D   33                           INC     sp
021E   37                           SCF
021F   3A 3D 41                     LD      a,(0x413d)
0222   45                           LD      b,l
0223   49                           LD      c,c
0224   4D                           LD      c,l
0225   52                           LD      d,d
0226   57                           LD      d,a
0227   5C                           LD      e,h
0228   10 FF                        DJNZ    0x0229
022A   FF                           DB      0xFF
022B   FF                           DB      0xFF
022C   FF                           DB      0xFF
022D   FF                           DB      0xFF
022E   FF                           DB      0xFF
022F   FF                           DB      0xFF
0230                TUNE1:          ORG     0x0230
0230   06 06                        DB      0x06,0x06
0232   0A                           DB      0x0A
0233   0D                           DB      0x0D
0234   06 0D                        DB      0x06,0x0D
0236   0A                           DB      0x0A
0237   0D                           DB      0x0D
0238   12                           DB      0x12
0239   16 14                        DB      0x16,0x14
023B   12                           DB      0x12
023C   0F                           DB      0x0F
023D   11 12 0F                     DB      0x11,0x12,0x0F
0240   0D                           DB      0x0D
0241   0D                           DB      0x0D
0242   0D                           DB      0x0D
0243   0A                           DB      0x0A
0244   12                           DB      0x12
0245   0F                           DB      0x0F
0246   0D                           DB      0x0D
0247   0A                           DB      0x0A
0248   08                           DB      0x08
0249   06 08                        DB      0x06,0x08
024B   0A                           DB      0x0A
024C   0F                           DB      0x0F
024D   0A                           DB      0x0A
024E   0D                           DB      0x0D
024F   0F                           DB      0x0F
0250   06 06                        DB      0x06,0x06
0252   0A                           DB      0x0A
0253   0D                           DB      0x0D
0254   06 0D                        DB      0x06,0x0D
0256   0A                           DB      0x0A
0257   0D                           DB      0x0D
0258   12                           DB      0x12
0259   16 14                        DB      0x16,0x14
025B   12                           DB      0x12
025C   0F                           DB      0x0F
025D   11 12 0F                     DB      0x11,0x12,0x0F
0260   0D                           DB      0x0D
0261   0D                           DB      0x0D
0262   0D                           DB      0x0D
0263   0A                           DB      0x0A
0264   12                           DB      0x12
0265   0F                           DB      0x0F
0266   0D                           DB      0x0D
0267   0A                           DB      0x0A
0268   08                           DB      0x08
0269   06 08                        DB      0x06,0x08
026B   0A                           DB      0x0A
026C   06 12                        DB      0x06,0x12
026E   00                           DB      0x00
026F   1E                           DB      0x1E
0270                SHOWTEXT:       ORG     0x0270
0270   FD 2A 00 08                  LD      iy,(STARTRAM)   ;iy = text_ptr
0274   DD 21 F1 0F                  LD      ix,DISPLAY      ;ix = display_ptr
0278                                                        ;clear display
0278   06 06                        LD      b,0x06          ;b = num of display digits
027A   21 F1 0F                     LD      hl,DISPLAY      ;hl = display_ptr
027D   36 00        STXT1:          LD      (hl),0x00       ;(hl) = SPACE
027F   23                           INC     hl              ;hl++
0280   10 FB                        DJNZ    STXT1           ;loop until b == 0
0282   06 06        STXTLOOP:       LD      b,0x06          ;b = num of display digits
0284   11 F7 0F                     LD      de,DISPLAY6     ;de = last display digit
0287   21 F6 0F                     LD      hl,DISPLAY5       ;hl = second last display digit
028A                                                        ;shift display one digit to the left
028A   7E           STXT2:          LD      a,(hl)          ;a = (hl)
028B   12                           LD      (de),a          ;(de) = a
028C   2B                           DEC     hl              ;hl--
028D   1B                           DEC     de              ;de--
028E   10 FA                        DJNZ    STXT2
0290   FD 7E 00                     LD      a,(iy+0)        ;a = (iy) ;text char
0293   FD 23                        INC     iy              ;iy++
0295   E6 1F                        AND     0x1f            ;mask lower 5 bits
0297   FE 1F                        CP      0x1f            ;if a == ENDOFTEXT
0299   C8                           RET     z               ;  return
029A   FE 1E                        CP      0x1e            ;if a == REPEATTEXT
029C   28 D2                        JR      z,SHOWTEXT        ;  goto SHOWTEXT
029E   21 B3 02                     LD      hl,CHAR7SEGTBL  ;hl = char_7segment_table
02A1   CD E3 01                     CALL    TBLOOKUP        ;convert char to 7segments
02A4   32 F1 0F                     LD      (DISPLAY),a     ;store in first digit
02A7                                                        ;scan display 128 times
02A7   3E 80                        LD      a,0x80          ;a = 80
02A9   F5           STXT3:          PUSH    af              ;save a
02AA   CD 40 01                     CALL    SCANDISP        ;scan display
02AD   F1                           POP     af              ;restore a
02AE   3D                           DEC     a               ;if (a-- != 0)
02AF   20 F8                        JR      nz,STXT3        ;  goto STXT3
02B1   18 CF                        JR      STXTLOOP        ;repeat shifting and scanning
02B3   00           CHAR7SEGTBL:    DB      0x00            ;00 SPACE
02B4   6F                           DB      0x6F            ;01 A
02B5   E6                           DB      0xE6            ;02 B
02B6   C3                           DB      0xC3            ;03 C
02B7   EC                           DB      0xEC            ;04 D
02B8   C7                           DB      0xC7            ;05 E
02B9   47                           DB      0x47            ;06 F
02BA   E3                           DB      0xE3            ;07 G
02BB   6E                           DB      0x6E            ;08 H
02BC   28                           DB      0x28            ;09 I
02BD   E8                           DB      0xE8            ;0A J
02BE   CE                           DB      0xCE            ;0B K
02BF   C2                           DB      0xC2            ;0C L
02C0   6B                           DB      0x64            ;0D N
02C1   EB                           DB      0xEB            ;0E O
02C2   4F                           DB      0x4F            ;0F P
02C3   2F                           DB      0x2F            ;10 Q
02C4   43                           DB      0x44            ;11 R
02C5   A7                           DB      0xA7            ;12 S
02C6   46                           DB      0x46            ;13 T
02C7   EA                           DB      0xE0            ;14 U
02C8   E0                           DB      0xA9            ;15 V
02C9   AE                           DB      0xAE            ;16 Y
02CA   CD                           DB      0xCD            ;17 Z
02CB   04                           DB      0x04            ;18 -
02CC   10                           DB      0x10            ;19 .
02CD   18                           DB      0x18            ;1A !
02CE   00                           DB      0x00
02CF   00                           DB      0x00
02D0   00                           DB      0x00
02D1                WELCOME:        ORG     0x02D1
02D1   08                           DB      0x08            ;h
02D2   05                           DB      0x05            ;e
02D3   0C                           DB      0x0c            ;l
02D4   0C                           DB      0x0c            ;l
02D5   0E                           DB      0x0e            ;o
02D6   00                           DB      0x00            ;
02D7   13                           DB      0x13            ;t
02D8   08                           DB      0x08            ;h
02D9   05                           DB      0x05            ;e
02DA   11                           DB      0x11            ;r
02DB   05                           DB      0x05            ;e
02DC   00                           DB      0x00            ;
02DD   13                           DB      0x13            ;t
02DE   08                           DB      0x08            ;h
02DF   09                           DB      0x09            ;i
02E0   12                           DB      0x12            ;s
02E1   00                           DB      0x00            ;
02E2   09                           DB      0x09            ;i
02E3   12                           DB      0x12            ;s
02E4   00                           DB      0x00            ;
02E5   13                           DB      0x13            ;t
02E6   08                           DB      0x08            ;h
02E7   05                           DB      0x05            ;e
02E8   00                           DB      0x00            ;
02E9   13                           DB      0x13            ;t
02EA   05                           DB      0x05            ;e
02EB   03                           DB      0x03            ;c
02EC   18                           DB      0x18            ;-
02ED   09                           DB      0x09            ;1
02EE   19                           DB      0x19            ;.
02EF   19                           DB      0x19            ;.
02F0   19                           DB      0x19            ;.
02F1   19                           DB      0x19            ;.
02F2   04                           DB      0x04            ;d
02F3   05                           DB      0x05            ;e
02F4   12                           DB      0x12            ;s
02F5   09                           DB      0x09            ;i
02F6   07                           DB      0x07            ;g
02F7   0D                           DB      0x0d            ;n
02F8   05                           DB      0x05            ;e
02F9   04                           DB      0x04            ;d
02FA   00                           DB      0x00            ;
02FB   02                           DB      0x02            ;b
02FC   16                           DB      0x16            ;y
02FD   00                           DB      0x00            ;
02FE   0A                           DB      0x0a            ;j
02FF   0E                           DB      0x0e            ;o
0300   08                           DB      0x08            ;h
0301   0D                           DB      0x0d            ;n
0302   00                           DB      0x00            ;
0303   08                           DB      0x08            ;h
0304   01                           DB      0x01            ;a
0305   11                           DB      0x11            ;r
0306   04                           DB      0x04            ;d
0307   16                           DB      0x16            ;y
0308   00                           DB      0x00            ;
0309   06                           DB      0x06            ;f
030A   0E                           DB      0x0e            ;o
030B   11                           DB      0x11            ;r
030C   00                           DB      0x00            ;
030D   13                           DB      0x13            ;t
030E   05                           DB      0x05            ;e
030F   1A                           DB      0x1a            ;!
0310   00                           DB      0x00            ;
0311   00                           DB      0x00            ;
0312   00                           DB      0x00            ;
0313   00                           DB      0x00            ;
0314   00                           DB      0x00            ;
0315   00                           DB      0x00            ;
0316   1E                           DB      0x1e            ; REPEATTEXT
0317   FF                           DB      0xff
0318   FF                           DB      0xff
0319   FF                           DB      0xff
031A   FF                           DB      0xff
031B   FF                           DB      0xff
031C   FF                           DB      0xff
031D   FF                           DB      0xff
031E   FF                           DB      0xff
031F   FF                           DB      0xff
0320                ; INVADERS game
0320                ; invaders advance towards you from the right
0320                ; you shoot invaders by pressing the 0 key
0320                ; you can only destroy the invaders the match the number on your guner on your gun
0320                ; you can only rotate the number on your gun by pressing the + keyng the + key
0320                INVADERS:       ORG     0x0320
0320   DD 21 F1 0F                  LD      ix,DISPLAY      ;ix = DISPLAY
0324   AF                           XOR     a               ;a = 0
0325   32 FA 0F                     LD      (INV_SCORE),a   ;(INV_SCORE) = 0
0328   32 FB 0F                     LD      (INV_GUN),a     ;(INV_GUN) = 0
032B                                                        ;clear display
032B   06 06                        LD      b,0x06          ;b = num_digits
032D   21 F1 0F                     LD      hl,DISPLAY      ;hl = DISPLAY
0330   36 00        INV10:          LD      (hl),0x00       ;clear digit
0332   23                           INC     hl              ;hl++
0333   10 FB                        DJNZ    INV10           ;if (--b != 0) goto INV10
0335   3A F5 0F     INV_LOOP:       LD      a,(DISPLAY4)    ;a = second last digit
0338   FE 00                        CP      0x00            ;if (a != 0)
033A   20 37                        JR      nz,INV40        ;  goto INV40
033C                                                        ;shift bottom 4 digits up
033C   11 F5 0F                     LD      de,DISPLAY4     ;second last digit
033F   21 F4 0F                     LD      hl,DISPLAY3     ;third last digit
0342   06 04                        LD      b,0x04          ;num digits to shift
0344   7E           INV20:          LD      a,(hl)          ;get rightmost
0345   12                           LD      (de),a          ;move one left
0346   2B                           DEC     hl              ;hl--
0347   1B                           DEC     de              ;de--
0348   10 FA                        DJNZ    INV20           ;if (--b != 0) goto INV20
034A   ED 5F                        LD      a,r             ;load a = random from refresh
034C   CD B5 03                     CALL    TRI2SEG           ;convert to number?
034F   32 F1 0F                     LD      (DISPLAY),a     ;rightmost digit
0352   3E 00                        LD      a,0x00          ;a = 0
0354   00                           NOP
0355   F5           INV30:          PUSH    af              ;save a
0356   3E FF                        LD      a,0xff          ;a = FF
0358   ED 47                        LD      i,a             ;i = a
035A   3A FB 0F                     LD      a,(INV_GUN)     ;a = INV_GUN
035D   CD B5 03                     CALL    TRI2SEG           ;convert to number?
0360   32 F6 0F                     LD      (DISPLAY5),a    ;leftmost digit = INV_GUN
0363   CD 40 01                     CALL    SCANDISP        ;scan display
0366   ED 57                        LD      a,i             ;a = i
0368   FE FF                        CP      0xff            ;if key pressed
036A   C4 8E 03                     CALL    nz,INVKEYPRESS  ;  goto INVKEYPRESS
036D   F1                           POP     af              ;restore a
036E   3D                           DEC     a               ;if (--a > 0)
036F   20 E4                        JR      nz,INV30        ;  goto INV30
0371   18 C2                        JR      INV_LOOP        ;goto INV_LOOP
0373   CD 8E 01     INV40:          CALL    BEEP            ;beep
0376                                                        ;clear display
0376   06 06                        LD      b,0x06          ;b = num_digits
0378   21 F1 0F                     LD      hl,DISPLAY      ;hl = DISPLAY
037B   36 00        INV50:          LD      (hl),0x00       ;(hl) = 0
037D   23                           INC     hl              ;hl++
037E   10 FB                        DJNZ    INV50           ;if (--b != 0) goto INV50
0380   3A FA 0F                     LD      a,(INV_SCORE)   ;a = (INV_SCORE)
0383   21 F3 0F                     LD      hl,DISPLAY2     ;hl = DISPLAY
0386   CD 15 01                     CALL    WRITEHEX        ;write hex(a) to (hl)
0389   CD 31 01                     CALL    GETKEY          ;wait for key
038C   18 92                        JR      INVADERS        ;restart INVADERS
038E   FE 10        INVKEYPRESS:    CP      0x10
0390   20 08                        JR      nz,INV60        ; if (key == "+")
0392   3A FB 0F                     LD      a,(INV_GUN)     ;   (INV_GUN)++
0395   3C                           INC     a
0396   32 FB 0F                     LD      (INV_GUN),a
0399   C9                           RET
039A                                                        ;loop over invaders comparing with gun number
039A   3A F6 0F     INV60:          LD      a,(DISPLAY5)    ;a = last digit (gun)
039D   4F                           LD      c,a             ;c = a
039E   21 F5 0F                     LD      hl,DISPLAY4     ;hl = second last digit
03A1   06 05                        LD      b,0x05          ;b = 5 digits
03A3   7E           INV65:          LD      a,(hl)          ;a = (hl)
03A4   B9                           CP      c
03A5   20 0A                        JR      nz,INV70        ; if (invader_num == gun_num) {
03A7   36 00                        LD      (hl),0x00       ;    clear invader
03A9   3A FA 0F                     LD      a,(INV_SCORE)   ;
03AC   3C                           INC     a               ;    increase score
03AD   27                           DAA                     ;
03AE   32 FA 0F                     LD      (INV_SCORE),a   ; }
03B1   2B           INV70:          DEC     hl              ;hl--
03B2   10 EF                        DJNZ    INV65           ;if (--b != 0) goto INV65
03B4   C9                           RET
03B5                                                        ;subroutine TRI2SEG
03B5                                                        ;convert lower 3 bits to segments
03B5   E6 07        TRI2SEG:        AND     0x07            ;mask lower 3 bits (0-7) of a
03B7   CD 26 01                     CALL    HEX2SEGS        ;a = segments(a)
03BA   C9                           RET
03BB                                ; NIM strings used in NIM game below
03BB   16           NIMLOSE:        DB      0x16            ;y
03BC   0E                           DB      0x0E            ;o
03BD   14                           DB      0x14            ;u
03BE   00                           DB      0x00
03BF   0C                           DB      0x0C            ;l
03C0   0E                           DB      0x0E            ;o
03C1   12                           DB      0x12            ;s
03C2   05                           DB      0x05            ;e
03C3   00                           DB      0x00
03C4   12                           DB      0x12            ;s
03C5   13                           DB      0x13            ;t
03C6   14                           DB      0x14            ;u
03C7   0F                           DB      0x0F            ;p
03C8   09                           DB      0x09            ;i
03C9   04                           DB      0x04            ;d
03CA   1A                           DB      0x1A            ;!
03CB   1F                           DB      0x1F            ;ENDOFTEXT
03CC   0E           NIMWIN:         DB      0x0E            ;o
03CD   08                           DB      0x08            ;h
03CE   00                           DB      0x00
03CF   0D                           DB      0x0D            ;n
03D0   0E                           DB      0x0E            ;o
03D1   19                           DB      0x19            ;.
03D2   19                           DB      0x19            ;.
03D3   19                           DB      0x19            ;.
03D4   09                           DB      0x09            ;i
03D5   00                           DB      0x00
03D6   0C                           DB      0x0C            ;l
03D7   0E                           DB      0x0E            ;o
03D8   12                           DB      0x12            ;s
03D9   13                           DB      0x13            ;t
03DA   1A                           DB      0x1A            ;!
03DB   1F                           DB      0x1F            ;ENDOFTEXT
03DC   FF                           DB      0xFF
03DD   FF                           DB      0xFF
03DE   FF                           DB      0xFF
03DF   FF                           DB      0xFF
03E0                                ; NIM is a game of 23 matches played against the computerter
03E0                                ; Each player takes it in turns to take 1, 2 or 3 matches.hes.
03E0                                ; The player that is left to pick up the last match loses.ses.
03E0                NIM:            ORG     0x03E0
03E0   DD 21 F1 0F                  LD      ix,DISPLAY      ;ix = display[0]
03E4   3E 23                        LD      a,0x23          ;23 matches in BCD
03E6   32 FA 0F                     LD      (NIMMATCHES),a  ;save in total matches
03E9                                                        ;clear display
03E9   21 F1 0F                     LD      hl,DISPLAY      ;hl = DISPLAY
03EC   06 06                        LD      b,0x06          ;num digits
03EE   36 00        NIMLOOP1:       LD      (hl),0x00       ;store 0 at DISPLAY
03F0   23                           INC     hl              ;point to next digit
03F1   10 FB                        DJNZ    NIMLOOP1        ;b-- if b > 0 jump to NIMLOOP1
03F3   1E 00                        LD      e,0x00          ; e = 0
03F5   CD 66 04     NIMLOOP2:       CALL    NIMDISPLAY      ;render nim state
03F8   CD 31 01                     CALL    GETKEY          ;get key (blocking)
03FB   ED 57                        LD      a,i             ;a = key
03FD   FE 04                        CP      0x04            ;if (key >= 4)
03FF   30 F4                        JR      nc,NIMLOOP2     ;  goto NIMLOOP2
0401   FE 00                        CP      0x00            ;if (key == 0)
0403   28 F0                        JR      z,0x03f5        ;  goto NIMLOOP2
0405   5F                           LD      e,a             ;e = choice
0406   3A FA 0F                     LD      a,(NIMMATCHES)  ;a = num_matches
0409   BB                           CP      e               ;if (num_matches <= e)
040A   28 44                        JR      z,NIMLOSER      ;  goto NIMLOSER
040C   38 42                        JR      c,NIMLOSER
040E   93                           SUB     e               ;a = a - choice
040F   27                           DAA                     ;BCD adjust
0410   32 FA 0F                     LD      (NIMMATCHES),a  ;update
0413   CD 66 04                     CALL    NIMDISPLAY      ;render nim state
0416   21 F6 0F                     LD      hl,DISPLAY5     ;
0419   36 AE                        LD      (hl),0xae       ;letter 'Y' for "you chose"
041B   16 00                        LD      d,0x00
041D   CD 40 01     NIMLOOP3:       CALL    SCANDISP        ;scan LEDS 255 times
0420   15                           DEC     d
0421   20 FA                        JR      nz,NIMLOOP3
0423   3A FA 0F                     LD      a,(NIMMATCHES)  ;a = num_matches
0426   FE 01                        CP      0x01            ;if (a == 1)
0428   28 2C                        JR      z,0x0456        ;   goto NIMWINNER
042A   3D                           DEC     a               ;a = num_matches - 1
042B   27                           DAA                     ;BCD adjust
042C   D6 04        NIMLOOP4:       SUB     0x04            ;a -= 4
042E   27                           DAA                     ;BCD adjust
042F   30 FB                        JR      nc,NIMLOOP4
0431   C6 04                        ADD     a,0x04
0433   27                           DAA                     ;a = (num_matches - 1) % 4
0434   FE 00                        CP      0x00            ;if (a == 0) //no move available
0436   28 10                        JR      z,NIMRAND       ;  goto random_move
0438   5F           NIMRESUME:      LD      e,a             ;e = a -- computer's choice
0439   3A FA 0F                     LD      a,(NIMMATCHES)  ;a = num_matches
043C   93                           SUB     e               ;a = a - choice
043D   27                           DAA                     ;BCD adjust
043E   32 FA 0F                     LD      (NIMMATCHES),a  ;update
0441   21 F6 0F                     LD      hl,DISPLAY5
0444   36 28                        LD      (hl),0x28       ;letter 'I' for "I chose"
0446   18 AD                        JR      NIMLOOP2
0448   ED 5F        NIMRAND:        LD      a,r             ;get "random" num from refresh register
044A   E6 03                        AND     0x03            ;truncate range to 0-3
044C   28 28                        JR      z,NIMADJUST     ;if choice == 0 choice++
044E   18 E8                        JR      NIMRESUME       ;use choice
0450   11 BB 03     NIMLOSER:       LD      de,NIMLOSE      ;show loser text
0453   C3 59 04                     JP      NIMTEXT
0456   11 CC 03     NIMWINNER:      LD      de,NIMWIN       ;show winner text
0459   ED 53 00 08  NIMTEXT:        LD      (STARTRAM),de   ;show text
045D   CD 70 02                     CALL    SHOWTEXT
0460   CD 31 01                     CALL    GETKEY          ;wait for key
0463   C3 E0 03                     JP      NIM
0466                                                        ;subroutine: display nim state
0466                                                        ;e = choice
0466                                                        ;destroys a, hl
0466   21 F1 0F     NIMDISPLAY:     LD      hl,DISPLAY
0469   3A FA 0F                     LD      a,(NIMMATCHES)  ;num matches
046C   CD 15 01                     CALL    WRITEHEX        ;write BCD values
046F   23                           INC     hl              ;blank digit
0470   7B                           LD      a,e
0471   CD 26 01                     CALL    HEX2SEGS        ;a = 7segs(e)
0474   77                           LD      (hl),a          ;(hl) = 7segs
0475   C9                           RET                     ;return
0476   3C           NIMADJUST:      INC     a               ;turn 0 into 1
0477   C3 38 04                     JP      NIMRESUME       ;resume
047A   FF                           DB      0xFF
047B   14           LUNAWIN:        DB      0x14            ;D
047C   12                           DB      0x12            ;C
047D   14                           DB      0x14            ;D
047E   17                           DB      0x17            ;F
047F   17                           DB      0x17            ;F
0480   12                           DB      0x12            ;C
0481   14                           DB      0x14            ;D
0482   10                           DB      0x10            ;A#
0483   1F                           DB      0x1F            ;END
0484   01           LUNALOSE:       DB      0x01            ;G
0485   11                           DB      0x11            ;B
0486   01                           DB      0x01            ;G
0487   11                           DB      0x11            ;B
0488   01                           DB      0x01            ;G
0489   11                           DB      0x11            ;B
048A   1F                           DB      0x1F            ;END
048B   FF                           DB      0xFF
048C   FF                           DB      0xFF
048D   FF                           DB      0xFF
048E   FF                           DB      0xFF
048F   FF                           DB      0xFF
0490                                                        ;LUNALANDER
0490                                                        ;you must land your luna module on the moon
0490                                                        ;as gently as possible while gravity is pulling you down.wn.
0490                                                        ;You can use the + key to fire your engine briefly
0490                                                        ;this will slow down your descent but it also uses fuell
0490                                                        ;if you run out of fuel you will crash
0490                LUNALANDER:     ORG     0x490
0490   DD 21 F1 0F                  LD      ix,DISPLAY      ;ix = DISPLAY
0494   FD 21 00 08                  LD      iy,STARTRAM     ;iy = STARTRAM
0498   3E 50                        LD      a,0x50
049A   FD 77 00                     LD      (iy+0),a        ;(ALTITUDE) = 50
049D   3E 20                        LD      a,0x20
049F   FD 77 01                     LD      (iy+1),a        ;(FUEL) = 20
04A2   AF                           XOR     a
04A3   FD 77 02                     LD      (iy+2),a        ;(VELOCITY) = 0
04A6                                                        ;clear display
04A6   21 F1 0F                     LD      hl,DISPLAY      ;hl = DISPLAY
04A9   06 06                        LD      b,0x06          ;b = num_digits
04AB   36 00        LUNA10:         LD      (hl),0x00       ;(hl) = 0
04AD   23                           INC     hl              ;hl++
04AE   10 FB                        DJNZ    0x04ab          ;if (--b != 0) goto LUNA10
04B0   16 80        LUNA15:         LD      d,0x80          ;d = 80
04B2   FD 7E 01     LUNA20:         LD      a,(iy+1)        ;a = (FUEL)
04B5   21 F1 0F                     LD      hl,DISPLAY      ;hl = DISPLAY
04B8   CD 15 01                     CALL    WRITEHEX        ;write (FUEL) BCD number
04BB   23                           INC     hl
04BC   23                           INC     hl              ;hl += 2
04BD   FD 7E 00                     LD      a,(iy+0)        ;a = (ALTITUDE)
04C0   CD 15 01                     CALL    WRITEHEX        ;write (ALTITUDE) BCD number
04C3   3E FF                        LD      a,0xff          ;a = FF
04C5   ED 47                        LD      i,a
04C7   CD 40 01                     CALL    SCANDISP
04CA   ED 57                        LD      a,i
04CC   FE FF                        CP      0xff            ;if (keypressed)
04CE   C4 F3 04                     CALL    nz,LUNAKPRESS   ;    call LUNAKPRESS
04D1   15                           DEC     d               ;d--
04D2   C2 B2 04                     JP      nz,LUNA20       ;loop 128 times
04D5   FD 7E 02                     LD      a,(iy+2)        ;a = (VELOCITY)
04D8   D6 01                        SUB     0x01            ;a--
04DA   27                           DAA                     ;BCD adjust
04DB   FD 77 02                     LD      (iy+2),a        ;(VELOCITY) = a
04DE   47                           LD      b,a             ;b = a
04DF   FD 7E 00                     LD      a,(iy+0)        ;a = (ALTITUDE)
04E2   80                           ADD     a,b             ;a += b
04E3   27                           DAA                     ;BCD adjust
04E4   FE 00                        CP      0x00            ;if (a == 0)
04E6   CA 11 05                     JP      z,LWIN          ;  goto LWIN
04E9   FE 60                        CP      0x60            ;if (a < 60)
04EB   30 1B                        JR      nc,LLOSE         ;  goto LLOSE
04ED   FD 77 00                     LD      (iy+0),a        ;(ALTITUDE) = a
04F0   C3 B0 04                     JP      LUNA15          ;goto LUNA15
04F3                                                        ;subroutine LUNAKPRESS
04F3   FD 7E 01     LUNAKPRESS:     LD      a,(iy+1)        ;a = (FUEL)
04F6   FE 00                        CP      0x00            ;if (a == 0)
04F8   C8                           RET     z               ;  return
04F9   3D                           DEC     a               ;reduce fuel
04FA   27                           DAA                     ;BCD adjust
04FB   FD 77 01                     LD      (iy+1),a        ;(FUEL) = a
04FE   FD 7E 02                     LD      a,(iy+2)        ;a = (VELOCITY)
0501   C6 02                        ADD     a,0x02          ;a += 2
0503   27                           DAA                     ;BCD adjust
0504   FD 77 02                     LD      (iy+2),a        ;(VELOCITY) = a
0507   C9                           RET                     ;return
0508   11 84 04     LLOSE:          LD      de,LUNALOSE     ;de = winning tune
050B   DD 21 00 00                  LD      ix,0x0000       ;???
050F   18 03                        JR      LUNAPLAYTUNE    ;goto LUNAPLAYTUNE
0511   11 7B 04     LWIN:           LD      de,LUNAWIN      ;de = losing tune
0514   ED 53 00 08  LUNAPLAYTUNE:   LD      (STARTRAM),de   ;store starting address in RAM
0518   CD B0 01                     CALL    PLAYTUNE        ;play tune
051B   CD 31 01                     CALL    GETKEY          ;wait for key
051E   C3 90 04                     JP      LUNALANDER      ;repeat
0521   FF                           DB      0xFF
0522   FF                           DB      0xFF
0523   FF                           DB      0xFF
0524   FF                           DB      0xFF
0525   FF                           DB      0xFF
0526   FF                           DB      0xFF
0527   FF                           DB      0xFF
0528   FF                           DB      0xFF
0529   FF                           DB      0xFF
052A   FF                           DB      0xFF
052B   FF                           DB      0xFF
052C   FF                           DB      0xFF
052D   FF                           DB      0xFF
052E   FF                           DB      0xFF
052F   FF                           DB      0xFF
0530   0B           TUNE2:          DB      0x0B            ;Bealach An Doirín
0531   0A                           DB      0x0A
0532   08                           DB      0x08
0533   0A                           DB      0x0A
0534   0A                           DB      0x0A
0535   0A                           DB      0x0A
0536   06                           DB      0x06
0537   06                           DB      0x06
0538   06                           DB      0x06
0539   0B                           DB      0x0B
053A   0A                           DB      0x0A
053B   08                           DB      0x08
053C   0A                           DB      0x0A
053D   0A                           DB      0x0A
053E   0A                           DB      0x0A
053F   0A                           DB      0x0A
0540   0A                           DB      0x0A
0541   0A                           DB      0x0A
0542   0B                           DB      0x0B
0543   0A                           DB      0x0A
0544   08                           DB      0x08
0545   0A                           DB      0x0A
0546   0A                           DB      0x0A
0547   0A                           DB      0x0A
0548   06 06                        DB      0x06,0x06
054A   06 0A                        DB      0x06,0x0A
054C   08                           DB      0x08
054D   0A                           DB      0x0A
054E   0D                           DB      0x0D
054F   0D                           DB      0x0D
0550   0D                           DB      0x0D
0551   0D                           DB      0x0D
0552   0D                           DB      0x0D
0553   00                           DB      0x00
0554   0D                           DB      0x0D
0555   05                           DB      0x05
0556   08                           DB      0x08
0557   0B                           DB      0x0B
0558   0B                           DB      0x0B
0559   0B                           DB      0x0B
055A   06 06                        DB      0x06,0x06
055C   06 0B                        DB      0x06,0x0B
055E   0A                           DB      0x0A
055F   08                           DB      0x08
0560   0A                           DB      0x0A
0561   0A                           DB      0x0A
0562   0A                           DB      0x0A
0563   06 06                        DB      0x06,0x06
0565   06 0B                        DB      0x06,0x0B
0567   0A                           DB      0x0A
0568   06 08                        DB      0x06,0x08
056A   08                           DB      0x08
056B   08                           DB      0x08
056C   08                           DB      0x08
056D   08                           DB      0x08
056E   0A                           DB      0x0A
056F   0B                           DB      0x0B
0570   0A                           DB      0x0A
0571   08                           DB      0x08
0572   06 06                        DB      0x06,0x06
0574   06 06                        DB      0x06,0x06
0576   06 06                        DB      0x06,0x06
0578   00                           DB      0x00
0579   00                           DB      0x00
057A   00                           DB      0x00
057B   1E FF                        DB      0x1E,0xFF
057D   FF                           DB      0xFF
057E   FF                           DB      0xFF
057F   FF                           DB      0xFF
0580   21 00 08     STARTMON:       LD      hl,STARTRAM
0583   31 F0 0F                     LD      sp,STARTSTACK   ;set stack
0586   DD 21 F1 0F                  LD      ix,DISPLAY      ;ix = DISPLAY
058A   22 F7 0F                     LD      (ADDRESS),hl    ;address_ptr = STARTRAM
058D   AF                           XOR     a
058E   32 F9 0F                     LD      (MODE),a        ;MODE = ADDR
0591   32 FA 0F                     LD      (KEYFLAG),a     ;KEYFLAG = false
0594   0E 0A                        LD      c,0x0a          ;c = note E
0596   21 50 00                     LD      hl,0x0050       ;hl = duration
0599   CD 93 01                     CALL    PLAYTONE        ;beep
059C   0E 20                        LD      c,0x20
059E   21 30 00                     LD      hl,0x0030
05A1   CD 93 01                     CALL    PLAYTONE        ;beep
05A4   C3 E3 00                     JP      DATADISP
05A7   FF                           DB      0xFF
05A8   FF                           DB      0xFF
05A9   FF                           DB      0xFF
05AA   FF                           DB      0xFF
05AB   FF                           DB      0xFF
05AC   FF                           DB      0xFF
05AD   FF                           DB      0xFF
05AE   FF                           DB      0xFF
05AF   FF                           DB      0xFF
05B0   FF                           DB      0xFF
05B1   FF                           DB      0xFF
05B2   FF                           DB      0xFF
05B3   FF                           DB      0xFF
05B4   FF                           DB      0xFF
05B5   FF                           DB      0xFF
05B6   FF                           DB      0xFF
05B7   FF                           DB      0xFF
05B8   FF                           DB      0xFF
05B9   FF                           DB      0xFF
05BA   FF                           DB      0xFF
05BB   FF                           DB      0xFF
05BC   FF                           DB      0xFF
05BD   FF                           DB      0xFF
05BE   FF                           DB      0xFF
05BF   FF                           DB      0xFF
05C0   FF                           DB      0xFF
05C1   FF                           DB      0xFF
05C2   FF                           DB      0xFF
05C3   FF                           DB      0xFF
05C4   FF                           DB      0xFF
05C5   FF                           DB      0xFF
05C6   FF                           DB      0xFF
05C7   FF                           DB      0xFF
05C8   FF                           DB      0xFF
05C9   FF                           DB      0xFF
05CA   FF                           DB      0xFF
05CB   FF                           DB      0xFF
05CC   FF                           DB      0xFF
05CD   FF                           DB      0xFF
05CE   FF                           DB      0xFF
05CF   FF                           DB      0xFF
05D0   FF                           DB      0xFF
05D1   FF                           DB      0xFF
05D2   FF                           DB      0xFF
05D3   FF                           DB      0xFF
05D4   FF                           DB      0xFF
05D5   FF                           DB      0xFF
05D6   FF                           DB      0xFF
05D7   FF                           DB      0xFF
05D8   FF                           DB      0xFF
05D9   FF                           DB      0xFF
05DA   FF                           DB      0xFF
05DB   FF                           DB      0xFF
05DC   FF                           DB      0xFF
05DD   FF                           DB      0xFF
05DE   FF                           DB      0xFF
05DF   FF                           DB      0xFF
05E0   FF                           DB      0xFF
05E1   FF                           DB      0xFF
05E2   FF                           DB      0xFF
05E3   FF                           DB      0xFF
05E4   FF                           DB      0xFF
05E5   FF                           DB      0xFF
05E6   FF                           DB      0xFF
05E7   FF                           DB      0xFF
05E8   FF                           DB      0xFF
05E9   FF                           DB      0xFF
05EA   FF                           DB      0xFF
05EB   FF                           DB      0xFF
05EC   FF                           DB      0xFF
05ED   FF                           DB      0xFF
05EE   FF                           DB      0xFF
05EF   FF                           DB      0xFF
05f0   ff                           DB      0xFF
05f1   ff                           DB      0xFF
05f2   ff                           DB      0xFF
05f3   ff                           DB      0xFF
05f4   ff                           DB      0xFF
05f5   ff                           DB      0xFF
05f6   ff                           DB      0xFF
05f7   ff                           DB      0xFF
05f8   ff                           DB      0xFF
05f9   ff                           DB      0xFF
05fa   ff                           DB      0xFF
05fb   ff                           DB      0xFF
05fc   ff                           DB      0xFF
05fd   ff                           DB      0xFF
05fe   ff                           DB      0xFF
05ff   ff                           DB      0xFF
0600   ff                           DB      0xFF
0601   ff                           DB      0xFF
0602   ff                           DB      0xFF
0603   ff                           DB      0xFF
0604   ff                           DB      0xFF
0605   ff                           DB      0xFF
0606   ff                           DB      0xFF
0607   ff                           DB      0xFF
0608   ff                           DB      0xFF
0609   ff                           DB      0xFF
060A   ff                           DB      0xFF
060B   FF                           DB      0xFF
060C   FF                           DB      0xFF
060D   FF                           DB      0xFF
060E   FF                           DB      0xFF
060F   FF                           DB      0xFF
0610   FF                           DB      0xFF
0611   FF                           DB      0xFF
0612   FF                           DB      0xFF
0613   FF                           DB      0xFF
0614   FF                           DB      0xFF
0615   FF                           DB      0xFF
0616   FF                           DB      0xFF
0617   FF                           DB      0xFF
0618   FF                           DB      0xFF
0619   FF                           DB      0xFF
061A   FF                           DB      0xFF
061B   FF                           DB      0xFF
061C   FF                           DB      0xFF
061D   FF                           DB      0xFF
061E   FF                           DB      0xFF
061F   FF                           DB      0xFF
0620   FF                           DB      0xFF
0621   FF                           DB      0xFF
0622   FF                           DB      0xFF
0623   FF                           DB      0xFF
0624   FF                           DB      0xFF
0625   FF                           DB      0xFF
0626   FF                           DB      0xFF
0627   FF                           DB      0xFF
0628   FF                           DB      0xFF
0629   FF                           DB      0xFF
062A   FF                           DB      0xFF
062B   FF                           DB      0xFF
062C   FF                           DB      0xFF
062D   FF                           DB      0xFF
062E   FF                           DB      0xFF
062F   FF                           DB      0xFF
0630   FF                           DB      0xFF
0631   FF                           DB      0xFF
0632   FF                           DB      0xFF
0633   FF                           DB      0xFF
0634   FF                           DB      0xFF
0635   FF                           DB      0xFF
0636   FF                           DB      0xFF
0637   FF                           DB      0xFF
0638   FF                           DB      0xFF
0639   FF                           DB      0xFF
063A   FF                           DB      0xFF
063B   FF                           DB      0xFF
063C   FF                           DB      0xFF
063D   FF                           DB      0xFF
063E   FF                           DB      0xFF
063F   FF                           DB      0xFF
0640   FF                           DB      0xFF
0641   FF                           DB      0xFF
0642   FF                           DB      0xFF
0643   FF                           DB      0xFF
0644   FF                           DB      0xFF
0645   FF                           DB      0xFF
0646   FF                           DB      0xFF
0647   FF                           DB      0xFF
0648   FF                           DB      0xFF
0649   FF                           DB      0xFF
064A   FF                           DB      0xFF
064B   FF                           DB      0xFF
064C   FF                           DB      0xFF
064D   FF                           DB      0xFF
064E   FF                           DB      0xFF
064F   FF                           DB      0xFF
0650   FF                           DB      0xFF
0651   FF                           DB      0xFF
0652   FF                           DB      0xFF
0653   FF                           DB      0xFF
0654   FF                           DB      0xFF
0655   FF                           DB      0xFF
0656   FF                           DB      0xFF
0657   FF                           DB      0xFF
0658   FF                           DB      0xFF
0659   FF                           DB      0xFF
065A   FF                           DB      0xFF
065B   FF                           DB      0xFF
065C   FF                           DB      0xFF
065D   FF                           DB      0xFF
065E   FF                           DB      0xFF
065F   FF                           DB      0xFF
0660   FF                           DB      0xFF
0661   FF                           DB      0xFF
0662   FF                           DB      0xFF
0663   FF                           DB      0xFF
0664   FF                           DB      0xFF
0665   FF                           DB      0xFF
0666   FF                           DB      0xFF
0667   FF                           DB      0xFF
0668   FF                           DB      0xFF
0669   FF                           DB      0xFF
066A   FF                           DB      0xFF
066B   FF                           DB      0xFF
066C   FF                           DB      0xFF
066D   FF                           DB      0xFF
066E   FF                           DB      0xFF
066F   FF                           DB      0xFF
0670   FF                           DB      0xFF
0671   FF                           DB      0xFF
0672   FF                           DB      0xFF
0673   FF                           DB      0xFF
0674   FF                           DB      0xFF
0675   FF                           DB      0xFF
0676   FF                           DB      0xFF
0677   FF                           DB      0xFF
0678   FF                           DB      0xFF
0679   FF                           DB      0xFF
067A   FF                           DB      0xFF
067B   FF                           DB      0xFF
067C   FF                           DB      0xFF
067D   FF                           DB      0xFF
067E   FF                           DB      0xFF
067F   FF                           DB      0xFF
0680   FF                           DB      0xFF
0681   FF                           DB      0xFF
0682   FF                           DB      0xFF
0683   FF                           DB      0xFF
0684   FF                           DB      0xFF
0685   FF                           DB      0xFF
0686   FF                           DB      0xFF
0687   FF                           DB      0xFF
0688   FF                           DB      0xFF
0689   FF                           DB      0xFF
068A   FF                           DB      0xFF
068B   FF                           DB      0xFF
068C   FF                           DB      0xFF
068D   FF                           DB      0xFF
068E   FF                           DB      0xFF
068F   FF                           DB      0xFF
0690   FF                           DB      0xFF
0691   FF                           DB      0xFF
0692   FF                           DB      0xFF
0693   FF                           DB      0xFF
0694   FF                           DB      0xFF
0695   FF                           DB      0xFF
0696   FF                           DB      0xFF
0697   FF                           DB      0xFF
0698   FF                           DB      0xFF
0699   FF                           DB      0xFF
069A   FF                           DB      0xFF
069B   FF                           DB      0xFF
069C   FF                           DB      0xFF
069D   FF                           DB      0xFF
069E   FF                           DB      0xFF
069F   FF                           DB      0xFF
06A0   FF                           DB      0xFF
06A1   FF                           DB      0xFF
06A2   FF                           DB      0xFF
06A3   FF                           DB      0xFF
06A4   FF                           DB      0xFF
06A5   FF                           DB      0xFF
06A6   FF                           DB      0xFF
06A7   FF                           DB      0xFF
06A8   FF                           DB      0xFF
06A9   FF                           DB      0xFF
06AA   FF                           DB      0xFF
06AB   FF                           DB      0xFF
06AC   FF                           DB      0xFF
06AD   FF                           DB      0xFF
06AE   FF                           DB      0xFF
06AF   FF                           DB      0xFF
06B0   FF                           DB      0xFF
06B1   FF                           DB      0xFF
06B2   FF                           DB      0xFF
06B3   FF                           DB      0xFF
06B4   FF                           DB      0xFF
06B5   FF                           DB      0xFF
06B6   FF                           DB      0xFF
06B7   FF                           DB      0xFF
06B8   FF                           DB      0xFF
06B9   FF                           DB      0xFF
06BA   FF                           DB      0xFF
06BB   FF                           DB      0xFF
06BC   FF                           DB      0xFF
06BD   FF                           DB      0xFF
06BE   FF                           DB      0xFF
06BF   FF                           DB      0xFF
06C0   FF                           DB      0xFF
06C1   FF                           DB      0xFF
06C2   FF                           DB      0xFF
06C3   FF                           DB      0xFF
06C4   FF                           DB      0xFF
06C5   FF                           DB      0xFF
06C6   FF                           DB      0xFF
06C7   FF                           DB      0xFF
06C8   FF                           DB      0xFF
06C9   FF                           DB      0xFF
06CA   FF                           DB      0xFF
06CB   FF                           DB      0xFF
06CC   FF                           DB      0xFF
06CD   FF                           DB      0xFF
06CE   FF                           DB      0xFF
06CF   FF                           DB      0xFF
06D0   FF                           DB      0xFF
06D1   FF                           DB      0xFF
06D2   FF                           DB      0xFF
06D3   FF                           DB      0xFF
06D4   FF                           DB      0xFF
06D5   FF                           DB      0xFF
06D6   FF                           DB      0xFF
06D7   FF                           DB      0xFF
06D8   FF                           DB      0xFF
06D9   FF                           DB      0xFF
06DA   FF                           DB      0xFF
06DB   FF                           DB      0xFF
06DC   FF                           DB      0xFF
06DD   FF                           DB      0xFF
06DE   FF                           DB      0xFF
06DF   FF                           DB      0xFF
06E0   FF                           DB      0xFF
06E1   FF                           DB      0xFF
06E2   FF                           DB      0xFF
06E3   FF                           DB      0xFF
06E4   FF                           DB      0xFF
06E5   FF                           DB      0xFF
06E6   FF                           DB      0xFF
06E7   FF                           DB      0xFF
06E8   FF                           DB      0xFF
06E9   FF                           DB      0xFF
06EA   FF                           DB      0xFF
06EB   FF                           DB      0xFF
06EC   FF                           DB      0xFF
06ED   FF                           DB      0xFF
06EE   FF                           DB      0xFF
06EF   FF                           DB      0xFF
06F0   FF                           DB      0xFF
06F1   FF                           DB      0xFF
06F2   FF                           DB      0xFF
06F3   FF                           DB      0xFF
06F4   FF                           DB      0xFF
06F5   FF                           DB      0xFF
06F6   FF                           DB      0xFF
06F7   FF                           DB      0xFF
06F8   FF                           DB      0xFF
06F9   FF                           DB      0xFF
06FA   FF                           DB      0xFF
06FB   FF                           DB      0xFF
06FC   FF                           DB      0xFF
06FD   FF                           DB      0xFF
06FE   FF                           DB      0xFF
06FF   FF                           DB      0xFF
0700   FF                           DB      0xFF
0701   FF                           DB      0xFF
0702   FF                           DB      0xFF
0703   FF                           DB      0xFF
0704   FF                           DB      0xFF
0705   FF                           DB      0xFF
0706   FF                           DB      0xFF
0707   FF                           DB      0xFF
0708   FF                           DB      0xFF
0709   FF                           DB      0xFF
070A   FF                           DB      0xFF
070B   FF                           DB      0xFF
070C   FF                           DB      0xFF
070D   FF                           DB      0xFF
070E   FF                           DB      0xFF
070F   FF                           DB      0xFF
0710   FF                           DB      0xFF
0711   FF                           DB      0xFF
0712   FF                           DB      0xFF
0713   FF                           DB      0xFF
0714   FF                           DB      0xFF
0715   FF                           DB      0xFF
0716   FF                           DB      0xFF
0717   FF                           DB      0xFF
0718   FF                           DB      0xFF
0719   FF                           DB      0xFF
071A   FF                           DB      0xFF
071B   FF                           DB      0xFF
071C   FF                           DB      0xFF
071D   FF                           DB      0xFF
071E   FF                           DB      0xFF
071F   FF                           DB      0xFF
0720   FF                           DB      0xFF
0721   FF                           DB      0xFF
0722   FF                           DB      0xFF
0723   FF                           DB      0xFF
0724   FF                           DB      0xFF
0725   FF                           DB      0xFF
0726   FF                           DB      0xFF
0727   FF                           DB      0xFF
0728   FF                           DB      0xFF
0729   FF                           DB      0xFF
072A   FF                           DB      0xFF
072B   FF                           DB      0xFF
072C   FF                           DB      0xFF
072D   FF                           DB      0xFF
072E   FF                           DB      0xFF
072F   FF                           DB      0xFF
0730   FF                           DB      0xFF
0731   FF                           DB      0xFF
0732   FF                           DB      0xFF
0733   FF                           DB      0xFF
0734   FF                           DB      0xFF
0735   FF                           DB      0xFF
0736   FF                           DB      0xFF
0737   FF                           DB      0xFF
0738   FF                           DB      0xFF
0739   FF                           DB      0xFF
073A   FF                           DB      0xFF
073B   FF                           DB      0xFF
073C   FF                           DB      0xFF
073D   FF                           DB      0xFF
073E   FF                           DB      0xFF
073F   FF                           DB      0xFF
0740   FF                           DB      0xFF
0741   FF                           DB      0xFF
0742   FF                           DB      0xFF
0743   FF                           DB      0xFF
0744   FF                           DB      0xFF
0745   FF                           DB      0xFF
0746   FF                           DB      0xFF
0747   FF                           DB      0xFF
0748   FF                           DB      0xFF
0749   FF                           DB      0xFF
074A   FF                           DB      0xFF
074B   FF                           DB      0xFF
074C   FF                           DB      0xFF
074D   FF                           DB      0xFF
074E   FF                           DB      0xFF
074F   FF                           DB      0xFF
0750   FF                           DB      0xFF
0751   FF                           DB      0xFF
0752   FF                           DB      0xFF
0753   FF                           DB      0xFF
0754   FF                           DB      0xFF
0755   FF                           DB      0xFF
0756   FF                           DB      0xFF
0757   FF                           DB      0xFF
0758   FF                           DB      0xFF
0759   FF                           DB      0xFF
075A   FF                           DB      0xFF
075B   FF                           DB      0xFF
075C   FF                           DB      0xFF
075D   FF                           DB      0xFF
075E   FF                           DB      0xFF
075F   FF                           DB      0xFF
0760   FF                           DB      0xFF
0761   FF                           DB      0xFF
0762   FF                           DB      0xFF
0763   FF                           DB      0xFF
0764   FF                           DB      0xFF
0765   FF                           DB      0xFF
0766   FF                           DB      0xFF
0767   FF                           DB      0xFF
0768   FF                           DB      0xFF
0769   FF                           DB      0xFF
076A   FF                           DB      0xFF
076B   FF                           DB      0xFF
076C   FF                           DB      0xFF
076D   FF                           DB      0xFF
076E   FF                           DB      0xFF
076F   FF                           DB      0xFF
0770   FF                           DB      0xFF
0771   FF                           DB      0xFF
0772   FF                           DB      0xFF
0773   FF                           DB      0xFF
0774   FF                           DB      0xFF
0775   FF                           DB      0xFF
0776   FF                           DB      0xFF
0777   FF                           DB      0xFF
0778   FF                           DB      0xFF
0779   FF                           DB      0xFF
077A   FF                           DB      0xFF
077B   FF                           DB      0xFF
077C   FF                           DB      0xFF
077D   FF                           DB      0xFF
077E   FF                           DB      0xFF
077F   FF                           DB      0xFF
0780   FF                           DB      0xFF
0781   FF                           DB      0xFF
0782   FF                           DB      0xFF
0783   FF                           DB      0xFF
0784   FF                           DB      0xFF
0785   FF                           DB      0xFF
0786   FF                           DB      0xFF
0787   FF                           DB      0xFF
0788   FF                           DB      0xFF
0789   FF                           DB      0xFF
078A   FF                           DB      0xFF
078B   FF                           DB      0xFF
078C   FF                           DB      0xFF
078D   FF                           DB      0xFF
078E   FF                           DB      0xFF
078F   FF                           DB      0xFF
0790   FF                           DB      0xFF
0791   FF                           DB      0xFF
0792   FF                           DB      0xFF
0793   FF                           DB      0xFF
0794   FF                           DB      0xFF
0795   FF                           DB      0xFF
0796   FF                           DB      0xFF
0797   FF                           DB      0xFF
0798   FF                           DB      0xFF
0799   FF                           DB      0xFF
079A   FF                           DB      0xFF
079B   FF                           DB      0xFF
079C   FF                           DB      0xFF
079D   FF                           DB      0xFF
079E   FF                           DB      0xFF
079F   FF                           DB      0xFF
07A0   FF                           DB      0xFF
07A1   FF                           DB      0xFF
07A2   FF                           DB      0xFF
07A3   FF                           DB      0xFF
07A4   FF                           DB      0xFF
07A5   FF                           DB      0xFF
07A6   FF                           DB      0xFF
07A7   FF                           DB      0xFF
07A8   FF                           DB      0xFF
07A9   FF                           DB      0xFF
07AA   FF                           DB      0xFF
07AB   FF                           DB      0xFF
07AC   FF                           DB      0xFF
07AD   FF                           DB      0xFF
07AE   FF                           DB      0xFF
07AF   FF                           DB      0xFF
07B0   FF                           DB      0xFF
07B1   FF                           DB      0xFF
07B2   FF                           DB      0xFF
07B3   FF                           DB      0xFF
07B4   FF                           DB      0xFF
07B5   FF                           DB      0xFF
07B6   FF                           DB      0xFF
07B7   FF                           DB      0xFF
07B8   FF                           DB      0xFF
07B9   FF                           DB      0xFF
07BA   FF                           DB      0xFF
07BB   FF                           DB      0xFF
07BC   FF                           DB      0xFF
07BD   FF                           DB      0xFF
07BE   FF                           DB      0xFF
07BF   FF                           DB      0xFF
07C0   FF                           DB      0xFF
07C1   FF                           DB      0xFF
07C2   FF                           DB      0xFF
07C3   FF                           DB      0xFF
07C4   FF                           DB      0xFF
07C5   FF                           DB      0xFF
07C6   FF                           DB      0xFF
07C7   FF                           DB      0xFF
07C8   FF                           DB      0xFF
07C9   FF                           DB      0xFF
07CA   FF                           DB      0xFF
07CB   FF                           DB      0xFF
07CC   FF                           DB      0xFF
07CD   FF                           DB      0xFF
07CE   FF                           DB      0xFF
07CF   FF                           DB      0xFF
07D0   FF                           DB      0xFF
07D1   FF                           DB      0xFF
07D2   FF                           DB      0xFF
07D3   FF                           DB      0xFF
07D4   FF                           DB      0xFF
07D5   FF                           DB      0xFF
07D6   FF                           DB      0xFF
07D7   FF                           DB      0xFF
07D8   FF                           DB      0xFF
07D9   FF                           DB      0xFF
07DA   FF                           DB      0xFF
07DB   FF                           DB      0xFF
07DC   FF                           DB      0xFF
07DD   FF                           DB      0xFF
07DE   FF                           DB      0xFF
07DF   FF                           DB      0xFF
07E0   FF                           DB      0xFF
07E1   FF                           DB      0xFF
07e2   ff                           DB      0xFF
07e3   ff                           DB      0xFF
07e4   ff                           DB      0xFF
07e5   ff                           DB      0xFF
07e6   ff                           DB      0xFF
07e7   ff                           DB      0xFF
07e8   ff                           DB      0xFF
07e9   ff                           DB      0xFF
07ea   ff                           DB      0xFF
07eb   ff                           DB      0xFF
07ec   ff                           DB      0xFF
07ed   ff                           DB      0xFF
07ee   ff                           DB      0xFF
07ef   ff                           DB      0xFF
07f0   ff                           DB      0xFF
07f1   ff                           DB      0xFF
07f2   ff                           DB      0xFF
07f3   ff                           DB      0xFF
07f4   ff                           DB      0xFF
07f5   ff                           DB      0xFF
07f6   ff                           DB      0xFF
07f7   ff                           DB      0xFF
07f8   ff                           DB      0xFF
07f9   ff                           DB      0xFF
07fa   ff                           DB      0xFF
07fb   ff                           DB      0xFF
07fc   ff                           DB      0xFF
07fd   ff                           DB      0xFF
07fe   ff                           DB      0xFF
07ff   ff                           DB      0xFF

STARTRAM:           0800 DEFINED AT LINE 6
                    > USED AT LINE 83
                    > USED AT LINE 335
                    > USED AT LINE 482
                    > USED AT LINE 814
                    > USED AT LINE 861
                    > USED AT LINE 920
                    > USED AT LINE 1008
DISPLAY:            0FF1 DEFINED AT LINE 7
                    > USED AT LINE 175
                    > USED AT LINE 204
                    > USED AT LINE 483
                    > USED AT LINE 486
                    > USED AT LINE 508
                    > USED AT LINE 633
                    > USED AT LINE 639
                    > USED AT LINE 657
                    > USED AT LINE 677
                    > USED AT LINE 755
                    > USED AT LINE 759
                    > USED AT LINE 821
                    > USED AT LINE 860
                    > USED AT LINE 869
                    > USED AT LINE 876
                    > USED AT LINE 1010
DISPLAY2:           0FF3 DEFINED AT LINE 8
                    > USED AT LINE 171
                    > USED AT LINE 196
                    > USED AT LINE 682
DISPLAY3:           0FF4 DEFINED AT LINE 9
                    > USED AT LINE 648
DISPLAY4:           0FF5 DEFINED AT LINE 10
                    > USED AT LINE 643
                    > USED AT LINE 647
                    > USED AT LINE 695
DISPLAY5:           0FF6 DEFINED AT LINE 11
                    > USED AT LINE 492
                    > USED AT LINE 665
                    > USED AT LINE 693
                    > USED AT LINE 781
                    > USED AT LINE 804
DISPLAY6:           0FF7 DEFINED AT LINE 12
                    > USED AT LINE 491
ADDRESS:            0FF7 DEFINED AT LINE 13
                    > USED AT LINE 135
                    > USED AT LINE 155
                    > USED AT LINE 159
                    > USED AT LINE 161
                    > USED AT LINE 163
                    > USED AT LINE 165
                    > USED AT LINE 167
                    > USED AT LINE 185
                    > USED AT LINE 1011
MODE:               0FF9 DEFINED AT LINE 14
                    > USED AT LINE 127
                    > USED AT LINE 183
                    > USED AT LINE 1013
KEYFLAG:            0FFA DEFINED AT LINE 15
                    > USED AT LINE 145
                    > USED AT LINE 296
                    > USED AT LINE 303
                    > USED AT LINE 1014
INV_SCORE:          0FFA DEFINED AT LINE 17
                    > USED AT LINE 635
                    > USED AT LINE 681
                    > USED AT LINE 701
                    > USED AT LINE 704
INV_GUN:            0FFB DEFINED AT LINE 18
                    > USED AT LINE 636
                    > USED AT LINE 663
                    > USED AT LINE 688
                    > USED AT LINE 690
PORTKEYB:           0000 DEFINED AT LINE 19
PORTDIGIT:          0001 DEFINED AT LINE 20
                    > USED AT LINE 251
                    > USED AT LINE 257
                    > USED AT LINE 318
PORTSPKR:           0001 DEFINED AT LINE 21
PORTSEGS:           0002 DEFINED AT LINE 22
                    > USED AT LINE 248
                    > USED AT LINE 316
PORTSLOW:           0003 DEFINED AT LINE 23
                    > USED AT LINE 1040
PORTFAST:           0004 DEFINED AT LINE 24
                    > USED AT LINE 1046
                    > USED AT LINE 1050
SLOWSEQ:            0800 DEFINED AT LINE 25
                    > USED AT LINE 1033
                    > USED AT LINE 1038
FASTSEQ:            0B00 DEFINED AT LINE 26
                    > USED AT LINE 1034
                    > USED AT LINE 1044
ENDOFSEQ:           00FF DEFINED AT LINE 27
                    > USED AT LINE 1036
                    > USED AT LINE 1042
REPEATTEXT:         001E DEFINED AT LINE 28
ENDOFTEXT:          001F DEFINED AT LINE 29
REPEATTUNE:         001E DEFINED AT LINE 30
ENDOFTUNE:          001F DEFINED AT LINE 31
NIMMATCHES:         0FFA DEFINED AT LINE 32
                    > USED AT LINE 757
                    > USED AT LINE 773
                    > USED AT LINE 779
                    > USED AT LINE 787
                    > USED AT LINE 800
                    > USED AT LINE 803
                    > USED AT LINE 822
STARTTUNE:          0041 DEFINED AT LINE 83
                    > USED AT LINE 67
                    > USED AT LINE 71
NMINT:              0066 DEFINED AT LINE 118
WRITEDISP2:         006D DEFINED AT LINE 124
                    > USED AT LINE 193
ADDRKEY:            0088 DEFINED AT LINE 135
                    > USED AT LINE 133
WRITEDISP3:         0096 DEFINED AT LINE 141
                    > USED AT LINE 129
DATAKEY:            00B7 DEFINED AT LINE 155
                    > USED AT LINE 143
GOADDR:             00C2 DEFINED AT LINE 159
                    > USED AT LINE 150
DECADDR:            00C6 DEFINED AT LINE 161
                    > USED AT LINE 152
INCADDR:            00D0 DEFINED AT LINE 165
                    > USED AT LINE 154
ADDRDISP:           00DA DEFINED AT LINE 169
                    > USED AT LINE 140
                    > USED AT LINE 148
DATADISP:           00E3 DEFINED AT LINE 173
                    > USED AT LINE 134
                    > USED AT LINE 158
                    > USED AT LINE 164
                    > USED AT LINE 168
                    > USED AT LINE 1021
WRITEDISP:          00EA DEFINED AT LINE 183
                    > USED AT LINE 172
DPLOOP:             00FA DEFINED AT LINE 190
                    > USED AT LINE 192
WRITEADDR:          0102 DEFINED AT LINE 196
                    > USED AT LINE 186
WRITEDATA:          010E DEFINED AT LINE 204
                    > USED AT LINE 188
WRITEHEX:           0115 DEFINED AT LINE 210
                    > USED AT LINE 198
                    > USED AT LINE 200
                    > USED AT LINE 205
                    > USED AT LINE 683
                    > USED AT LINE 823
                    > USED AT LINE 877
                    > USED AT LINE 881
HEX2SEGS:           0126 DEFINED AT LINE 225
                    > USED AT LINE 211
                    > USED AT LINE 219
                    > USED AT LINE 711
                    > USED AT LINE 826
GETKEY:             0131 DEFINED AT LINE 236
                    > USED AT LINE 125
                    > USED AT LINE 242
                    > USED AT LINE 684
                    > USED AT LINE 766
                    > USED AT LINE 816
                    > USED AT LINE 922
SCANDISP:           0140 DEFINED AT LINE 245
                    > USED AT LINE 238
                    > USED AT LINE 512
                    > USED AT LINE 666
                    > USED AT LINE 784
                    > USED AT LINE 884
L145:               0145 DEFINED AT LINE 247
                    > USED AT LINE 258
SDDELAY:            0154 DEFINED AT LINE 255
                    > USED AT LINE 256
HEXSEGTBL:          015F DEFINED AT LINE 261
                    > USED AT LINE 226
GETADDRKEY:         016F DEFINED AT LINE 281
                    > USED AT LINE 136
GETDATAKEY:         017B DEFINED AT LINE 294
                    > USED AT LINE 156
                    > USED AT LINE 281
BEEP:               018E DEFINED AT LINE 308
                    > USED AT LINE 126
                    > USED AT LINE 674
PLAYTONE:           0193 DEFINED AT LINE 313
                    > USED AT LINE 359
                    > USED AT LINE 1017
                    > USED AT LINE 1020
MTLOOP:             019B DEFINED AT LINE 318
                    > USED AT LINE 323
MTDELAY:            019E DEFINED AT LINE 320
                    > USED AT LINE 320
PLAYTUNE:           01B0 DEFINED AT LINE 334
                    > USED AT LINE 84
                    > USED AT LINE 343
                    > USED AT LINE 921
PTLOOP1:            01B4 DEFINED AT LINE 336
                    > USED AT LINE 361
                    > USED AT LINE 380
TBLOOKUP:           01E3 DEFINED AT LINE 367
                    > USED AT LINE 350
                    > USED AT LINE 354
                    > USED AT LINE 507
PTSILENCE:          01E9 DEFINED AT LINE 372
                    > USED AT LINE 345
PTLOOP2:            01ED DEFINED AT LINE 374
                    > USED AT LINE 377
FREQWL:             01F8 DEFINED AT LINE 381
                    > USED AT LINE 349
FREQNC:             0210 DEFINED AT LINE 402
                    > USED AT LINE 353
TUNE1:              0230 DEFINED AT LINE 429
                    > USED AT LINE 66
SHOWTEXT:           0270 DEFINED AT LINE 481
                    > USED AT LINE 505
                    > USED AT LINE 815
STXT1:              027D DEFINED AT LINE 487
                    > USED AT LINE 489
STXTLOOP:           0282 DEFINED AT LINE 490
                    > USED AT LINE 516
STXT2:              028A DEFINED AT LINE 494
                    > USED AT LINE 498
STXT3:              02A9 DEFINED AT LINE 511
                    > USED AT LINE 515
CHAR7SEGTBL:        02B3 DEFINED AT LINE 517
                    > USED AT LINE 506
WELCOME:            02D1 DEFINED AT LINE 547
INVADERS:           0320 DEFINED AT LINE 632
                    > USED AT LINE 40
                    > USED AT LINE 685
INV10:              0330 DEFINED AT LINE 640
                    > USED AT LINE 642
INV_LOOP:           0335 DEFINED AT LINE 643
                    > USED AT LINE 673
INV20:              0344 DEFINED AT LINE 650
                    > USED AT LINE 654
INV30:              0355 DEFINED AT LINE 660
                    > USED AT LINE 672
INV40:              0373 DEFINED AT LINE 674
                    > USED AT LINE 645
INV50:              037B DEFINED AT LINE 678
                    > USED AT LINE 680
INVKEYPRESS:        038E DEFINED AT LINE 686
                    > USED AT LINE 669
INV60:              039A DEFINED AT LINE 693
                    > USED AT LINE 687
INV65:              03A3 DEFINED AT LINE 697
                    > USED AT LINE 706
INV70:              03B1 DEFINED AT LINE 705
                    > USED AT LINE 699
TRI2SEG:            03B5 DEFINED AT LINE 710
                    > USED AT LINE 656
                    > USED AT LINE 664
NIMLOSE:            03BB DEFINED AT LINE 714
                    > USED AT LINE 811
NIMWIN:             03CC DEFINED AT LINE 731
                    > USED AT LINE 813
NIM:                03E0 DEFINED AT LINE 754
                    > USED AT LINE 46
                    > USED AT LINE 817
NIMLOOP1:           03EE DEFINED AT LINE 761
                    > USED AT LINE 763
NIMLOOP2:           03F5 DEFINED AT LINE 765
                    > USED AT LINE 769
                    > USED AT LINE 806
NIMLOOP3:           041D DEFINED AT LINE 784
                    > USED AT LINE 786
NIMLOOP4:           042C DEFINED AT LINE 792
                    > USED AT LINE 794
NIMRESUME:          0438 DEFINED AT LINE 799
                    > USED AT LINE 810
                    > USED AT LINE 830
NIMRAND:            0448 DEFINED AT LINE 807
                    > USED AT LINE 798
NIMLOSER:           0450 DEFINED AT LINE 811
                    > USED AT LINE 775
                    > USED AT LINE 776
NIMWINNER:          0456 DEFINED AT LINE 813
NIMTEXT:            0459 DEFINED AT LINE 814
                    > USED AT LINE 812
NIMDISPLAY:         0466 DEFINED AT LINE 821
                    > USED AT LINE 765
                    > USED AT LINE 780
NIMADJUST:          0476 DEFINED AT LINE 829
                    > USED AT LINE 809
LUNAWIN:            047B DEFINED AT LINE 832
                    > USED AT LINE 919
LUNALOSE:           0484 DEFINED AT LINE 841
                    > USED AT LINE 916
LUNALANDER:         0490 DEFINED AT LINE 859
                    > USED AT LINE 52
                    > USED AT LINE 923
LUNA10:             04AB DEFINED AT LINE 871
LUNA15:             04B0 DEFINED AT LINE 874
                    > USED AT LINE 903
LUNA20:             04B2 DEFINED AT LINE 875
                    > USED AT LINE 889
LUNAKPRESS:         04F3 DEFINED AT LINE 905
                    > USED AT LINE 887
LLOSE:              0508 DEFINED AT LINE 916
                    > USED AT LINE 901
LWIN:               0511 DEFINED AT LINE 919
                    > USED AT LINE 899
LUNAPLAYTUNE:       0514 DEFINED AT LINE 920
                    > USED AT LINE 918
TUNE2:              0530 DEFINED AT LINE 939
                    > USED AT LINE 70
STARTMON:          0580 DEFINED AT LINE 1008
                    > USED AT LINE 1086
SEQUENCER:          05B0 DEFINED AT LINE 1032
LOOPSEQ:            05B6 DEFINED AT LINE 1035
                    > USED AT LINE 1039
                    > USED AT LINE 1054
SEQ2:               05C2 DEFINED AT LINE 1040
                    > USED AT LINE 1037
SEQ3:               05C4 DEFINED AT LINE 1041
                    > USED AT LINE 1045
SEQ4:               05D0 DEFINED AT LINE 1046
                    > USED AT LINE 1043
SEQDELAY:           05E1 DEFINED AT LINE 1057
                    > USED AT LINE 1047
                    > USED AT LINE 1051
SEQDEL1:            05E4 DEFINED AT LINE 1058
                    > USED AT LINE 1061
