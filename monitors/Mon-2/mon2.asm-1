0000                ;Keyboard functions:
0000                ;Shift-Insert range 0900 - 4000 (03FF??)
0000                ;Shift-Delete range 0900 - 03FF (03FF is set to 00 on use of delete
0000                ;function).
0000                ;Shift -Address jumps to location stored at 08D2 and 08D3
0000                ;
0000                STARTSTACK:     EQU 0x08C0              ;Stack Max Length C0
0000                VECTOR0:        EQU 0x08C0              ;user vector 0
0000                VECTOR1:        EQU 0x08C2              ;user vector 1
0000                VECTOR2:        EQU 0x08C4              ;user vector 2
0000                VECTOR3:        EQU 0x08C6              ;user vector 3
0000                VECTOR4:        EQU 0x08C8              ;user vector 4
0000                VECTOR5:        EQU 0x08CA              ;user vector 5
0000                VECTOR6:        EQU 0x08CC              ;user vector 6
0000                X0:             EQU 0x08D0
0000                TUNEADDR:       EQU 0x08D6
0000                ADDRESS:        EQU 0x08D8              ;current address in nibbles over 4 bytes
0000                ADDRESS0:       EQU 0x08D8
0000                ADDRESS1:       EQU 0x08D9
0000                ADDRESS2:       EQU 0x08DA
0000                ADDRESS3:       EQU 0x08DB
0000                X1:             EQU 0x08DC
0000                X2:             EQU 0x08dd
0000                MODE:           EQU 0x08DF              ;Monitor mode
0000                STARTRAM:       EQU 0x0900              ;User Code Start 0900
0000                KEYDATA:        EQU 0x08E0              ;Key data location updated by NMI routine
0000                X3:             EQU 0x08e1;
0000                ;
0000                STARTROM:       ORG 0x0000
0000   C3 00 02     RESTART00:      jp STARTMON		        ;Jump to STARTMON
0003   FF                           db 0xFF
0004   FF                           db 0xFF
0005   FF                           db 0xFF
0006   FF                           db 0xFF
0007   FF                           db 0xFF
0008   2A C0 08     RESTART08:      ld hl,(VECTOR0)          ;jump to vector stored at 0x08c0
000B   E9                           jp (hl)
000C   FF                           db 0xFF
000D   FF                           db 0xFF
000E   FF                           db 0xFF
000F   FF                           db 0xFF
0010   2A C2 08     RESTART10:      ld hl,(VECTOR1)          ;jump to vector stored at 0x08c2
0013   E9                           jp (hl)
0014   FF                           db 0xFF
0015   FF                           db 0xFF
0016   FF                           db 0xFF
0017   FF                           db 0xFF
0018   2A C4 08     RESTART18:      ld hl,(VECTOR2)          ;jump to vector stored at 0x08c4
001B   E9                           jp (hl)
001C   FF                           db 0xFF
001D   FF                           db 0xFF
001E   FF                           db 0xFF
001F   FF                           db 0xFF
0020   2A C6 08     RESTART20:      ld hl,(VECTOR3)          ;jump to vector stored at 0x08c6
0023   E9                           jp (hl)
0024   FF                           db 0xFF
0025   FF                           db 0xFF
0026   FF                           db 0xFF
0027   FF                           db 0xFF
0028   2A C8 08     RESTART28:      ld hl,(VECTOR4)          ;jump to vector stored at 0x08c8
002B   E9                           jp (hl)
002C   FF                           db 0xFF
002D   FF                           db 0xFF
002E   FF                           db 0xFF
002F   FF                           db 0xFF
0030   2A CA 08     RESTART30:      ld hl,(VECTOR5)          ;jump to vector stored at 0x08ca
0033   E9                           jp (hl)
0034   FF                           db 0xFF
0035   FF                           db 0xFF
0036   FF                           db 0xFF
0037   FF                           db 0xFF
0038   2A CC 08     RESTART38:      ld hl,(VECTOR6)          ;jump to vector stored at 0x08cc
003B   E9                           jp (hl)
003C   FF                           db 0xFF
003D   FF                           db 0xFF
003E   FF                           db 0xFF
003F   FF                           db 0xFF
0040   FF                           db 0xFF
0041   FF                           db 0xFF
0042   FF                           db 0xFF
0043   FF                           db 0xFF
0044   FF                           db 0xFF
0045   FF                           db 0xFF
0046   FF                           db 0xFF
0047   FF                           db 0xFF
0048   FF                           db 0xFF
0049   FF                           db 0xFF
004A   FF                           db 0xFF
004B   FF                           db 0xFF
004C   FF                           db 0xFF
004D   FF                           db 0xFF
004E   FF                           db 0xFF
004F   FF                           db 0xFF
0050   FF                           db 0xFF
0051   FF                           db 0xFF
0052   FF                           db 0xFF
0053   FF                           db 0xFF
0054   FF                           db 0xFF
0055   FF                           db 0xFF
0056   FF                           db 0xFF
0057   FF                           db 0xFF
0058   FF                           db 0xFF
0059   FF                           db 0xFF
005A   FF                           db 0xFF
005B   FF                           db 0xFF
005C   FF                           db 0xFF
005D   FF                           db 0xFF
005E   FF                           db 0xFF
005F   FF                           db 0xFF
0060   FF                           db 0xFF
0061   FF                           db 0xFF
0062   FF                           db 0xFF
0063   FF                           db 0xFF
0064   FF                           db 0xFF
0065   FF                           db 0xFF
0066   F5           NMINT:          ORG 0x066               ;NMI keyboard event
0066   F5                           push af                 ;save af ;good idea! fixes Mon1
0067   DB 00                        in a,(0x00)             ;a = key port
0069   32 E0 08                     ld (KEYDATA),a          ;save in ram
006C   F1                           pop af                  ;restore af
006D   ED 45                        retn                    ;correct return. fixes Mon1
006F   FF                           db 0xFF
0070   FF                           db 0xFF
0071   FF                           db 0xFF
0072   FF                           db 0xFF
0073   FF                           db 0xFF
0074   FF                           db 0xFF
0075   FF                           db 0xFF
0076   FF                           db 0xFF
0077   FF                           db 0xFF
0078   FF                           db 0xFF
0079   FF                           db 0xFF
007A   FF                           db 0xFF
007B   FF                           db 0xFF
007C   FF                           db 0xFF
007D   FF                           db 0xFF
007E   FF                           db 0xFF
007F   FF                           db 0xFF
0080                SEVSEGDATA:     org 0x0080
0080   EB                           DB 0xEB
0081   28 CD                        DB 0x28
                                    DB 0xCD
0083   AD                           DB 0xAD
0084   2E A7                        DB 0x2E
                                    DB 0xA7
0086   E7                           DB 0xE7
0087   29                           DB 0x29
0088   EF                           DB 0xEF
0089   2F                           DB 0x2F
008A   6F                           DB 0x6F
008B   E6 C3                        DB 0xE6
                                    DB 0xC3
008D   EC C7 47                     DB 0xEC
                                    DB 0xC7
                                    DB 0x47
0090   E3                           DB 0xE3
0091   66                           DB 0x66
0092   28 E8                        DB 0x28
                                    DB 0xE8
0094   4E                           DB 0x4E
0095   C2 2D 6B                     DB 0xC2
                                    DB 0x2D
                                    DB 0x6B
0098   EB                           DB 0xEB
0099   4F                           DB 0x4F
009A   2F                           DB 0x2F
009B   4B                           DB 0x4B
009C   A7                           DB 0xA7
009D   46                           DB 0x46
009E   EA E0 AC                     DB 0xEA
                                    DB 0xE0
                                    DB 0xAC
00A1   A4                           DB 0xA4
00A2   AE                           DB 0xAE
00A3   C9                           DB 0xC9
00A4   10 08                        DB 0x10
                                    DB 0x08
00A6   18 04                        DB 0x18
                                    DB 0x04
00A8   2C                           DB 0x2C
00A9   00                           DB 0x00
00AA   FF                           db 0xFF
00AB   FF                           db 0xFF
00AC   FF                           db 0xFF
00AD   FF                           db 0xFF
00AE   FF                           db 0xFF
00AF   FF                           db 0xFF
00B0   00          INITADDR:        db 0x00                  ;inital address (start of RAM)
00B0   00                           db 0x00                  ;0
00B1   09                           db 0x09                  ;9
00B2   00                           db 0x00                  ;0
00B3   00                           db 0x00                  ;0
00B4   FF                           db 0xFF
00B5   FF                           db 0xFF
00B6   FF                           db 0xFF
00B7   FF                           db 0xFF
00B8   FF                           db 0xFF
00B9   FF                           db 0xFF
00BA   FF                           db 0xFF
00BB   FF                           db 0xFF
00BC   F8                           ret m
00BD   FF                           db 0xFF
00BE   00                           nop
00BF   00                           nop
00C0                DEMOTEXT:       ORG 0x00c0              ;Data table for text message demo.
00C0   1B                           db 0x1b                 ;ROUTINE
00C1   18                           db 0x18
00C2   1E                           db 0x1e
00C3   1D                           db 0x1d
00C4   12                           db 0x12
00C5   17                           db 0x17
00C6   0E                           db 0x0e
00C7   29                           db 0x29                 ;[space]
00C8   0B                           db 0x0b                 ;BY
00C9   22                           db 0x22
00CA   29                           db 0x29                 ;[space]
00CB   17                           db 0x17                 ;NIC.   (Nic Enots - Ken Stone's old                                                                    ;programming pseudonym))
00CC   12                           db 0x12
00CD   0C                           db 0x0c
00CE   24                           db 0x24
00CF   29                           db 0x29                 ;[space]
00D0   29                           db 0x29                 ;[space]
00D1   29                           db 0x29                 ;[space]
00D2   29                           db 0x29                 ;[space]
00D3   29                           db 0x29                 ;[space]
00D4   FE                           db 0xfe                 ;(repeat text)
00D5   1C                           db 0x1c                 ;STONE  (Text for real surname
                                                            ;hidden in code)
00D6   1D                           db 0x1d
00D7   18                           db 0x18
00D8   17                           db 0x17
00D9   0A                           db 0x0a
00DA   FF                           db 0xff                 ;(end text)
00DB   FF                           db 0xFF
00DC   FF                           db 0xFF
00DD   FF                           db 0xFF
00DE   FF                           db 0xFF
00DF   FF                           db 0xFF
00E0   CD 89 02     L0E0:           call GETEDITADDR        ;+ key
00E3   03                           inc bc
00E4   18 04                        jr L00EA
00E6   CD 89 02     L0E6:           call GETEDITADDR        ;- key
00E9   0B                           dec bc
00EA   CD 90 04     L00EA           call SETEDITADDR
00ED   CD 70 02                     call GETADDRDATA
00F0   21 DF 08                     ld hl,MODE
00F3   CB C6                        set 0,(hl)
00F5   CB 8E                        res 1,(hl)
00F7   C3 78 03                     jp POP_HLAF
00FA   FF                           db 0xFF
00FB   FF                           db 0xFF
00FC   FF                           db 0xFF
00FD   FF                           db 0xFF
00FE   FF                           db 0xFF
00FF   FF                           db 0xFF
0100   FD           FRQTBL:         db 0xfd               ;(division table for frequencies)
0101   10 10                        db 0x10, 0x10
0103   FD                           db 0xFD
0104   11 EF 12                     db 0x11, 0xEF ,0x12
0107   E1                           db 0xE1
0108   13                           db 0x13
0109   54                           db 0x54
010A   14                           db 0x14
010B   C9                           db 0xC9
010C   10 BE                        db 0x10, 0xBE
010E   10 B2                        db 0x10, 0xB2
0110   10 A9                        db 0x10, 0xA9
0112   19                           db 0x19
0113   9F                           db 0x9F
0114   1A                           db 0x1A
0115   96                           db 0x96
0116   1C                           db 0x1C
0117   80                           db 0x80
0118   1E 86                        db 0x1E, 0x86
011A   20 7F                        db 0x20, 0x7F
011C   22 77 24                     db 0x22, 0x77, 0x24
011F   71                           db 0x71
0120   26 6A                        db 0x26, 0x6A
0122   28 64                        db 0x28, 0x64
0124   2A 5F 2D                     db 0x2A, 0x5F, 0x2D
0127   59                           db 0x59
0128   2F                           db 0x2F
0129   54                           db 0x54
012A   32 50 35                     db 0x32, 0x50, 0x35
012D   4B                           db 0x4B
012E   38 47                        db 0x38, 0x47
0130   3C                           db 0x3C
0131   43                           db 0x43
0132   3F                           db 0x3F
0133   3F                           db 0x3F
0134   43                           db 0x43
0135   3C                           db 0x3C
0136   47                           db 0x47
0137   38 4B                        db 0x38, 0x4B
0139   35                           db 0x35
013A   50                           db 0x50
013B   32 54 2F                     db 0x32, 0x54, 0x2F
013E   59                           db 0x59
013F   2D                           db 0x2D
0140   5F                           db 0x5F
0141   2A 64 28                     db 0x2A, 0x64, 0x28
0144   6A                           db 0x6A
0145   26 71                        db 0x26, 0x71
0147   24                           db 0x24
0148   77                           db 0x77
0149   22 7F 20                     db 0x22, 0x7F, 0x20
014C   86                           db 0x86
014D   1E 8E                        db 0x1E, 0x8E
014F   1C                           db 0x1C
0150   96                           db 0x96
0151   1A                           db 0x1A
0152   94                           db 0x94
0153   19                           db 0x19
0154   A9                           db 0xA9
0155   18 B3                        db 0x18, 0xB3
0157   16 BE                        db 0x16, 0xBE
0159   15                           db 0x15
015A   C9                           db 0xC9
015B   14                           db 0x14
015C   D5                           db 0xD5
015D   13                           db 0x13
015E   E1                           db 0xE1
015F   12                           db 0x12
0160   EF                           db 0xEF
0161   11 FD 10                     db 0x11, 0xFD, 0x10
0164   FF                           db 0xFF
0165   FF                           db 0xFF
0166   FF                           db 0xFF
0167   FF                           db 0xFF
0168   FF                           db 0xFF
0169   FF                           db 0xFF
016A   FF                           db 0xFF
016B   FF                           db 0xFF
016C   FF                           db 0xFF
016D   FF                           db 0xFF
016E   FF                           db 0xFF
016F   FF                           db 0xFF
0170                PLAYTONE:       org 0x0170          ;TONE routine. 0170
                                                        ;a is the tone number
0170   C5                           push bc             ;save bc,de,hl,af
0171   D5                           push de
0172   E5                           push hl
0173   F5                           push af
0174   A7                           and a                   ;Set Z Flag
0175   20 03                        jr nz,ptAisnotzero      ;If not zero, Jump Rel to ptAisnotzero
0177   5F                           ld e,a                  ;Clear E
0178   18 02                        jr ptAiszero            ;Jump Rel to ptzero
017A   1E 80        ptAisnotzero:   ld e,0x80               ;Load E with 80h; high bit is speaker
017C   21 00 01     ptAiszero:      ld hl,FRQTBL            ;(^division table for frequencies)
017F   87                           add a,a                 ;offset a words into table
0180   85                           add a,l                 ;l += a * 2
0181   6F                           ld l,a                  ;
0182   4E                           ld c,(hl)               ;bc = (hl) ;freq division
0183   23                           inc hl                  ;
0184   46           lengthloop:     ld b,(hl)               ;
0185   7B                           ld a,e                  ;a = e
0186   D3 01                        out (0x01),a            ;speaker bit = 1
0188   10 FE        toneloop:       djnz toneloop           ;repeat while (--b > 0)
018A   46                           ld b,(hl)               ;restore b
018B   AF                           xor a                   ;a = 0
018C   D3 01                        out (0x01),a            ;speaker bit = 0
018E   10 FE        toneloop2:      djnz toneloop2          ;repeat while (--b > 0)
0190   0D                           dec c                   ;c--
0191   20 F1                        jr nz,lengthloop        ;if (c != 0) goto lengthloop
0193   F1                           pop af                  ;restore bc,de,hl,af
0194   E1                           pop hl
0195   D1                           pop de
0196   C1                           pop bc
0197   C9                           ret                     ;return
0198   FF                           db 0xFF
0199   FF                           db 0xFF
019A   FF                           db 0xFF
019B   FF                           db 0xFF
019C   FF                           db 0xFF
019D   FF                           db 0xFF
019E   FF                           db 0xFF
019F   FF                           db 0xFF
01A0                PLAYTUNE:       org 0x01a0              ;MUSIC routine.
01A0   F5                           push af
01A1   E5                           push hl
01A2   2A D6 08     L1A2:           ld hl,(TUNEADDR)
01A5   7E                           ld a,(hl)
01A6   FE FF                        cp 0xff
01A8   20 03                        jr nz,L1AD
01AA   E1                           pop hl
01AB   F1                           pop af
01AC   C9                           ret
01AD   FE FE        L1AD:           cp 0xfe
01AF   28 F1                        jr z,L1A2
01B1   23                           inc hl
01B2   CD 70 01                     call PLAYTONE         ;Call PlayTone
01B5   18 EE                        jr 0x01a5
01B7   FF                           db 0xFF
01B8   FF                           db 0xFF
01B9   FF                           db 0xFF
01BA   FF                           db 0xFF
01BB   FF                           db 0xFF
01BC   FF                           db 0xFF
01BD   FF                           db 0xFF
01BE   FF                           db 0xFF
01BF   FF                           db 0xFF
01C0   21 DF 08     L1C0:           ld hl,MODE
01C3   CB 46                        bit 0,(hl)
01C5   20 07                        jr nz,L1CE
01C7   CB C6                        set 0,(hl)
01C9   CB 8E                        res 1,(hl)
01CB   C3 78 03                     jp POP_HLAF
01CE   CB 86        L1CE:           res 0,(hl)
01D0   CB CE                        set 1,(hl)
01D2   C3 78 03                     jp POP_HLAF
01D5   FF                           db 0xFF
01D6   FF                           db 0xFF
01D7   FF                           db 0xFF
01D8                MPDISPLAY:      ORG 0x01d8               ;MULTIPASS DISPLAY
01D8   C5                           push bc
01D9   06 80                        ld b,0x80
01DB   CD A0 02                     call DISPLAY             ;Call DISPLAY
01DE   10 FB                        djnz 0x01db
01E0   C1                           pop bc
01E1   C9                           ret
01E2   FF                           db 0xFF
01E3   FF                           db 0xFF
01E4   ED 4B D2 08  L1E4:           ld bc,(0x08d2)
01E8   CD 90 04                     call SETEDITADDR
01EB   CD 70 02                     call GETADDRDATA
01EE   C3 78 03                     jp POP_HLAF
01F1   FF                           db 0xFF
01F2   ED 4B D4 08  L1F2:           ld bc,(0x08d4)
01F6   CD 90 04                     call SETEDITADDR
01F9   CD 70 02                     call GETADDRDATA
01FC   C3 78 03                     jp POP_HLAF
01FF   FF                           db 0xFF
0200                STARTMON:       ORG 0x0200              ;Main monitor program entry point.
0200   ED 73 E8 08                  ld (STORESP),sp         ;save stack point
0204   31 00 09                     ld sp,RAMSTART          ;sp = RAMSTART
0207   F5                           push af                 ;save registers
0208   C5                           push bc
0209   D5                           push de
020A   E5                           push hl
020B   DD E5                        push ix
020D   FD E5                        push iy
020F   08                           ex af,af'
0210   D9                           exx
0211   F5                           push af
0212   C5                           push bc
0213   D5                           push de
0214   E5                           push hl
0215   ED 57                        ld a,i
0217   F5                           push af
0218   AF                           xor a
0219   32 CC 08                     ld (VECTOR6),a          ;VECTOR6 = 0
021C   32 CD 08                     ld (VECTOR6+1),a
021F   3E FF                        ld a,0xff
0221   32 E0 08                     ld (KEYDATA),a          ;key = FF
0224   C3 40 02                     jp 0x0240
0227   FF                           db 0xFF
0228   FF                           db 0xFF
0229   FF                           db 0xFF
022A   FF                           db 0xFF
022B   FF                           db 0xFF
022C   FF                           db 0xFF
022D   FF                           db 0xFF
022E   FF                           db 0xFF
022F   FF                           db 0xFF
0230   FF                           db 0xFF
0231   FF                           db 0xFF
0232   FF                           db 0xFF
0233   FF                           db 0xFF
0234   FF                           db 0xFF
0235   FF                           db 0xFF
0236   FF                           db 0xFF
0237   FF                           db 0xFF
0238   FF                           db 0xFF
0239   FF                           db 0xFF
023A   FF                           db 0xFF
023B   FF                           db 0xFF
023C   FF                           db 0xFF
023D   FF                           db 0xFF
023E   FF                           db 0xFF
023F   FF                           db 0xFF
0240   31 C0 08     STARTMON2       ld sp,STACKSTART            ;sp = STACKSTART
0243   AF                           xor a
0244   D3 01                        out (0x01),a
0246   D3 02                        out (0x02),a
0248   21 B0 00                     ld hl,INITADDR
024B   11 D8 08                     ld de,ADDRESS
024E   01 05 00                     ld bc,0x0005
0251   ED B0                        ldir
0253   CD 70 02     L253:           call GETADDRDATA
0256   3E 08                        ld a,0x08
0258   CD 70 01                     call PLAYTONE
025B   3E 0F                        ld a,0x0f
025D   CD 70 01                     call PLAYTONE
0260   3E 01                        ld a,0x01
0262   32 DF 08                     ld (MODE),a
0265   CD A0 02     L265:           call DISPLAY
0268   CD 60 03                     call GETKEY
026B   18 F8                        jr L265
026D   FF                           db 0xFF
026E   FF                           db 0xFF
026F   FF                           db 0xFF
0270                GETADDRDATA:    org 0x0270              ;GetAddressedData
0270   F5                           push af                 ;save af, hl, bc
0271   E5                           push hl
0272   C5                           push bc
0273   CD 89 02                     call GETEDITADDR
0276   E6 F0                        and 0xf0
0278   0F                           rrca
0279   0F                           rrca
027A   0F                           rrca
027B   0F                           rrca
027C   32 DC 08                     ld (X1),a
027F   0A                           ld a,(bc)
0280   E6 0F                        and 0x0f
0282   32 DD 08                     ld (X2),a
0285   C1                           pop bc
0286   E1                           pop hl
0287   F1                           pop af
0288   C9                           ret
0289                ;GetEditorAddress
0289                ;The address used by editor and shown on the 7 segment display is stored in one
0289                ;location only, to prevent a situation where dislayed address and real address
0289                ;could differ. In a trade off in processing time, it was more efficient to store
0289                ;the address in the optimal form for the display routine. As such it needs
0289                ;converting to and from this format when used by the monitor program.
0289                ;The chosen location is the display buffer, where the address is broken into
0289                ;nibbles and spread across four bytes, 08D8, 08D9, 08DA, 08DB, MSN to LSN.
0289                ;GetEditorAddress is used to retrieve this address.
0289                ;The data held here is only valid while the monitor program is running. As soon as
0289                ;something else is written to the display it is lost. Resetting the computer
0289                ;restores it to the default 0900h.
0289                ;
0289                ;GetEditorAddress, when called, loads BC with the address currently held In the
0289                ;display buffer. It also loads A with the data held at the location addressed by BC.
0289                ;
0289                ; E.G. If the LED display shows 0900 CD, calling 0289 will load BC with 0900 (B is
0289                ;the MSB) and loads A with CD. This routine is not transparent. HL is destroyed. BC
0289                ;and A hold the results. If this routine is called during a user program that is not
0289                ;an extension to the monitor, the result will have no meaning.
0289                GETEDITADDR:    ORG 0x0289
0289   21 D8 08                     ld hl,ADDRESS
028C   7E                           ld a,(hl)
028D   07                           rlca
028E   07                           rlca
028F   07                           rlca
0290   07                           rlca
0291   23                           inc hl
0292   86                           add a,(hl)
0293   47                           ld b,a
0294   23                           inc hl
0295   7E                           ld a,(hl)
0296   07                           rlca
0297   07                           rlca
0298   07                           rlca
0299   07                           rlca
029A   23                           inc hl
029B   86                           add a,(hl)
029C   4F                           ld c,a
029D   0A                           ld a,(bc)
029E   C9                           ret
029F   FF                           db 0xFF
02A0                DISPLAY:        org 0x02A0
02A0   F5                           push af                 ;save registers
02A1   E5                           push hl
02A2   D5                           push de
02A3   C5                           push bc
02A4   11 D8 08                     ld de,ADDRESS           ;de = ADDRESS buffer
02A7   AF                           xor a                   ;a = 0
02A8   D3 01                        out (0x01),a            ;clear digit port
02AA   CD 50 03                     call HEX2SEG            ;convert (de) to segments -> a
02AD   CB 4E                        bit 1,(hl)              ;check mode bit 1
02AF   28 02                        jr z,L2B3               ;if set
02B1   CB E7                        set 4,a                 ;  set segment 4 of digit (decimal point)
02B3   D3 02        L2B3:           out (0x02),a            ;output a to segment port
02B5   3E 20                        ld a,0x20               ;digit 020
02B7   D3 01                        out (0x01),a            ;output a to digit port
02B9   06 20                        ld b,0x20               ;
02BB   10 FE        L2BB:           djnz L2BB               ;delay by 20
02BD   AF                           xor a                   ;
02BE   D3 01                        out (0x01),a            ;clear digit port
02C0   CD 50 03                     call HEX2SEG            ;
02C3   CB 4E                        bit 1,(hl)              ;
02C5   28 02                        jr z,L2C9               ;
02C7   CB E7                        set 4,a                 ;
02C9   D3 02        L2C9:           out (0x02),a            ;output a to segment port
02CB   3E 10                        ld a,0x10               ;digit 010
02CD   D3 01                        out (0x01),a            ;output a to digit port
02CF   06 20                        ld b,0x20               ;
02D1   10 FE        L2D1:           djnz L2D1               ;delay by 20
02D3   AF                           xor a                   ;
02D4   D3 01                        out (0x01),a            ;clear digit port
02D6   CD 50 03                     call HEX2SEG            ;
02D9   CB 4E                        bit 1,(hl)              ;
02DB   28 02                        jr z,L2DF               ;
02DD   CB E7                        set 4,a                 ;
02DF   D3 02        L2DF:           out (0x02),a            ;output a to segment port
02E1   3E 08                        ld a,0x08               ;digit 080
02E3   D3 01                        out (0x01),a            ;output a to digit port
02E5   06 20                        ld b,0x20               ;
02E7   10 FE        L2E7:           djnz L2E7               ;delay by 20
02E9   AF                           xor a                   ;
02EA   D3 01                        out (0x01),a            ;clear digit port
02EC   CD 50 03                     call HEX2SEG            ;
02EF   CB 4E                        bit 1,(hl)              ;
02F1   28 02                        jr z,L2F5               ;
02F3   CB E7                        set 4,a                 ;
02F5   D3 02        L2F5:           out (0x02),a            ;output a to segment port
02F7   3E 04                        ld a,0x04               ;digit 040
02F9   D3 01                        out (0x01),a            ;output a to digit port
02FB   06 20                        ld b,0x20               ;
02FD   10 FE        L2FD:           djnz L2FD               ;delay by 20
02FF   AF                           xor a                   ;
0300   D3 01                        out (0x01),a            ;clear digit port
0302   00                           nop                     ;
0303   C3 18 03                     jp DISPLAY2
0306   FF                           db 0xFF
0307   FF                           db 0xFF
0308   FF                           db 0xFF
0309   FF                           db 0xFF
030A   FF                           db 0xFF
030B   FF                           db 0xFF
030C   CD 89 02     GOADDR:         call GETEDITADDR        ;go to current address
030F   C5                           push bc
0310   E1                           pop hl
0311   31 C0 08                     ld sp,STACKSTART
0314   E9                           jp (hl)
0315   FF                           db 0xFF
0316   FF                           db 0xFF
0317   FF                           db 0xFF
0318   CD 50 03     DISPLAY2:       call HEX2SEG
031B   CB 46                        bit 0,(hl)
031D   28 02                        jr z,0x0321
031F   CB E7                        set 4,a
0321   D3 02                        out (0x02),a
0323   3E 02                        ld a,0x02               ;digit 020
0325   D3 01                        out (0x01),a            ;output a to digit port
0327   06 20                        ld b,0x20
0329   10 FE                        djnz 0x0329             ;delay by 20
032B   AF                           xor a
032C   D3 01                        out (0x01),a            ;clear digit port
032E   CD 50 03                     call HEX2SEG
0331   CB 46                        bit 0,(hl)
0333   28 02                        jr z,0x0337
0335   CB E7                        set 4,a
0337   D3 02                        out (0x02),a
0339   3E 01                        ld a,0x01               ;digit 040
033B   D3 01                        out (0x01),a            ;output a to digit port
033D   06 20                        ld b,0x20
033F   10 FE                        djnz 0x033f             ;delay by 20
0341   AF                           xor a
0342   D3 01                        out (0x01),a            ;clear digit port
0344   C1                           pop bc                  ;restore registers
0345   D1                           pop de
0346   E1                           pop hl
0347   F1                           pop af
0348   C9                           ret                     ;return
0349   FF                           db 0xFF
034A   FF                           db 0xFF
034B   FF                           db 0xFF
034C   FF                           db 0xFF
034D   FF                           db 0xFF
034E   FF                           db 0xFF
034F   FF                           db 0xFF
0350                ;Hex2SevenSeg converts the Hex value (0 to29) into the ;
0350                ;corresponding seven-segment data. It is part of the display ;
0350                ;destroyed, DE is incremented, A is converted from the value to its
0350                ;7 segment form.
0350                HEX2SEG:        org 0x0350              ;Hex2SevenSeg
0350   21 80 00                     ld hl,SEVSEGDATA        ;hl = 7seg table
0353   1A                           ld a,(de)               ;a = (de)
0354   85                           add a,l                 ;hl += a
0355   6F                           ld l,a
0356   7E                           ld a,(hl)               ;a = (hl + a)
0357   13                           inc de                  ;de++
0358   21 DF 08                     ld hl,MODE              ;hl = mode
035B   C9                           ret                     ;return
035C   FF                           db 0xFF
035D   FF                           db 0xFF
035E   FF                           db 0xFF
035F   FF                           db 0xFF
0360   F5           GETKEY:         push af                 ;save af, hl
0361   E5                           push hl
0362   21 E0 08                     ld hl,KEYDATA           ;hl = KEYDATA
0365   3E FF                        ld a,0xff
0367   BE                           cp (hl)
0368   28 0E                        jr z,POP_HLAF           ;if (key)
036A   7E                           ld a,(hl)               ;  a = (KEYDATA)
036B   E6 1F                        and 0x1f                ;  a = a & 1f
036D   CB 6E                        bit 5,(hl)              ;  test shift bit
036F   20 02                        jr nz,L373              ;  if (shift)
0371   C6 14                        add a,0x14              ;    a += 0x0014
0373   C3 A8 03     L373:           jp L3A8
0376   FF                           db 0xFF
0377   FF                           db 0xFF
0378   E1           POP_HLAF:       pop hl                  ;restore hl, af
0379   F1                           pop af
037A   C9                           ret
037B   FF                           db 0xFF
037C   FF                           db 0xFF
037D   E1           L37D:           pop hl
037E   F1                           pop af
037F   C9                           ret
0380   FF                           db 0xFF
0381   FF                           db 0xFF
0382   FF                           db 0xFF
0383   FF                           db 0xFF
0384   CD 89 02     L384:           call GETEDITADDR
0387   C5                           push bc
0388   DD E1                        pop ix
038A   DD 23        L38A:           inc ix
038C   DD E5                        push ix
038E   E1                           pop hl
038F   7C                           ld a,h
0390   FE 40                        cp 0x40
0392   28 08                        jr z,L39C
0394   DD 7E 00                     ld a,(ix+0)
0397   DD 77 FF                     ld (ix-1),a
039A   18 EE                        jr L38A
039C   3E 00        L39C:           ld a,0x00
039E   32 FF 3F                     ld (0x3fff),a           ;??????
03A1   CD 70 02                     call GETADDRDATA
03A4   C3 78 03                     jp POP_HLAF
03A7   FF                           db 0xFF
03A8   C6 01        L3A8:           add a,0x01
03AA   CD 70 01                     call PLAYTONE
03AD   C3 21 04                     jp L421
03B0   CD 89 02     L3B0:           call GETEDITADDR
03B3   0B                           dec bc
03B4   DD 21 FE 3F                  ld ix,0x3ffe
03B8   DD 7E 00     L3B8:           ld a,(ix+0)
03BB   DD 77 01                     ld (ix+1),a
03BE   DD 2B                        dec ix
03C0   DD E5                        push ix
03C2   E1                           pop hl
03C3   79                           ld a,c
03C4   BD                           cp l
03C5   20 F1                        jr nz,L3B8
03C7   78                           ld a,b
03C8   BC                           cp h
03C9   20 ED                        jr nz,L3B8
03CB   DD 36 01 00                  ld (ix+1),0x00
03CF   CD 70 02                     call GETADDRDATA
03D2   C3 78 03                     jp POP_HLAF
03D5   FF                           db 0xFF
03D6   FF                           db 0xFF
03D7   FF                           db 0xFF
03D8                RUNWRITING:     org 0x03d8;             RUNNING WRITING
03D8   E5                           push hl
03D9   F5                           push af
03DA   DD E5                        push ix
03DC   C5                           push bc
03DD   AF                           xor a
03DE   32 DF 08                     ld (MODE),a
03E1   06 06                        ld b,0x06
03E3   21 D8 08                     ld hl,ADDRESS
03E6   3E 29                        ld a,0x29
03E8   77                           ld (hl),a
03E9   23                           inc hl
03EA   10 FC                        djnz 0x03e8
03EC   2A D0 08     L3EC:           ld hl,(X1)
03EF   7E           L3EF:           ld a,(hl)
03F0   FE FF                        cp 0xff
03F2   20 06                        jr nz,L3FA
03F4   C1                           pop bc
03F5   DD E1                        pop ix
03F7   F1                           pop af
03F8   E1                           pop hl
03F9   C9                           ret
03FA   FE FE        L3FA:           cp 0xfe
03FC   28 EE                        jr z,L3EC
03FE   DD 21 D8 08                  ld ix,ADDRESS
0402   06 05                        ld b,0x05
0404   DD 7E 01                     ld a,(ix+1)
0407   DD 77 00                     ld (ix+0),a
040A   DD 23                        inc ix
040C   10 F6                        djnz 0x0404
040E   7E                           ld a,(hl)
040F   32 DD 08                     ld (X2),a
0412   23                           inc hl
0413   06 40                        ld b,0x40
0415   CD A0 02     L415:           call DISPLAY
0418   10 FB                        djnz L415
041A   18 D3                        jr L3EF
041C   FF                           db 0xFF
041D   FF                           db 0xFF
041E   FF                           db 0xFF
041F   FF                           db 0xFF
0420   FF                           db 0xFF
0421   D6 01         L421:          sub 0x01
0423   36 FF                        ld (hl),0xff
0425   CB 67                        bit 4,a
0427   C2 C0 04                     jp nz,0x04c0
042A   CB 6F                        bit 5,a
042C   C2 C0 04                     jp nz,0x04c0
042F   21 DF 08                     ld hl,MODE
0432   CB 46                        bit 0,(hl)
0434   CA 55 04                     jp z,L455
0437   57                           ld d,a
0438   CD 89 02                     call GETEDITADDR
043B   21 DF 08                     ld hl,MODE
043E   CB 5E                        bit 3,(hl)
0440   20 03                        jr nz,L445
0442   AF                           xor a
0443   CB DE                        set 3,(hl)
0445   07           L445:           rlca
0446   07                           rlca
0447   07                           rlca
0448   07                           rlca
0449   E6 F0                        and 0xf0
044B   82                           add a,d
044C   02                           ld (bc),a
044D   CD 70 02                     call GETADDRDATA
0450   C3 7D 03                     jp L37D
0453   FF                           db 0xFF
0454   FF                           db 0xFF
0455   57           L455:           ld d,a
0456   21 DF 08                     ld hl,MODE
0459   CB 9E                        res 3,(hl)
045B   CB 66                        bit 4,(hl)
045D   20 08                        jr nz,0x0467
045F   01 00 00                     ld bc,0x0000
0462   CD 90 04                     call SETEDITADDR
0465   CB E6                        set 4,(hl)
0467   CD 89 02                     call GETEDITADDR
046A   78                           ld a,b
046B   07                           rlca
046C   07                           rlca
046D   07                           rlca
046E   07                           rlca
046F   E6 F0                        and 0xf0
0471   5F                           ld e,a
0472   79                           ld a,c
0473   07                           rlca
0474   07                           rlca
0475   07                           rlca
0476   07                           rlca
0477   E6 0F                        and 0x0f
0479   83                           add a,e
047A   47                           ld b,a
047B   79                           ld a,c
047C   07                           rlca
047D   07                           rlca
047E   07                           rlca
047F   07                           rlca
0480   E6 F0                        and 0xf0
0482   82                           add a,d
0483   4F                           ld c,a
0484   CD 90 04                     call SETEDITADDR
0487   CD 70 02                     call GETADDRDATA
048A   C3 7D 03                     jp L37D
048D   FF                           db 0xFF
048E   FF                           db 0xFF
048F   FF                           db 0xFF
0490                ;SetEditorAddress 0490 is the opposite of the GetEditorAddress
0490                ;0289 routine.
0490                ;It loads the display buffer (ADDRESS0, ADDRESS1, ADDRESS2, ADDRESS3) with the
0490                ;value held in BC. This routine is transparent.
0490                SETEDITADDR:    org 0x0490              ;SetEditorAddress
0490   F5                           push af                 ;save af, hl
0491   E5                           push hl
0492   21 D8 08                     ld hl,ADDRESS           ;hl points to ADDRESS buffer
0495   78                           ld a,b                  ;a = b
0496   E6 F0                        and 0xf0                ;mask out lower nibble
0498   07                           rlca                    ;rotate upper nibble into lower nibble
0499   07                           rlca
049A   07                           rlca
049B   07                           rlca
049C   77                           ld (hl),a               ;(hl) = a
049D   23                           inc hl                  ;hl++
049E   78                           ld a,b                  ;a = b
049F   E6 0F                        and 0x0f                ;mask lower nibble
04A1   77                           ld (hl),a               ;(hl) = a
04A2   23                           inc hl                  ;hl++
04A3   79                           ld a,c                  ;a = c
04A4   E6 F0                        and 0xf0                ;mask upper nibble
04A6   07                           rlca                    ;rotate upper nibble into lower nibble
04A7   07                           rlca
04A8   07                           rlca
04A9   07                           rlca
04AA   77                           ld (hl),a               ;(hl) = a
04AB   23                           inc hl                  ;hl++
04AC   79                           ld a,c                  ;a = c
04AD   E6 0F                        and 0x0f                ;mask lower nibble
04AF   77                           ld (hl),a               ;(hl) = a
04B0   E1                           pop hl                  ;restore hl, af
04B1   F1                           pop af
04B2   C9                           ret                     ;return
04B3   FF                           db 0xFF
04B4   FF                           db 0xFF
04B5   FF                           db 0xFF
04B6   FF                           db 0xFF
04B7   FF                           db 0xFF
04B8   FF                           db 0xFF
04B9   FF                           db 0xFF
04BA   FF                           db 0xFF
04BB   FF                           db 0xFF
04BC   FF                           db 0xFF
04BD   FF                           db 0xFF
04BE   FF                           db 0xFF
04BF   FF                           db 0xFF
04C0   21 DF 08                     ld hl,MODE
04C3   CB 9E                        res 3,(hl)
04C5   CB A6                        res 4,(hl)
04C7   FE 10                        cp 0x10
04C9   CA E0 00                     jp z,L0E0
04CC   FE 11                        cp 0x11
04CE   CA E6 00                     jp z,L0E6
04D1   FE 12                        cp 0x12
04D3   CA 0C 03                     jp z,GOADDR
04D6   FE 13                        cp 0x13
04D8   CA C0 01                     jp z,L1C0
04DB   FE 14                        cp 0x14
04DD   CA 50 05                     jp z,L550
04E0   FE 15                        cp 0x15
04E2   CA FF FF                     jp z,0xffff
04E5   FE 16                        cp 0x16
04E7   CA FF FF                     jp z,0xffff
04EA   FE 17                        cp 0x17
04EC   CA F2 01                     jp z,L1F2
04EF   FE 18                        cp 0x18
04F1   CA 70 05                     jp z,0x0570             ;????
04F4   FE 19                        cp 0x19
04F6   CA FF FF                     jp z,0xffff
04F9   FE 1A                        cp 0x1a
04FB   CA FF FF                     jp z,0xffff
04FE   FE 1B                        cp 0x1b
0500   CA FF FF                     jp z,0xffff
0503   FE 1C                        cp 0x1c
0505   CA 60 06                     jp z,0x0660
0508   FE 1D                        cp 0x1d
050A   CA FF FF                     jp z,0xffff
050D   FE 1E                        cp 0x1e
050F   CA FF FF                     jp z,0xffff
0512   FE 1F                        cp 0x1f
0514   CA FF FF                     jp z,0xffff
0517   FE 20                        cp 0x20
0519   CA FF FF                     jp z,0xffff
051C   FE 21                        cp 0x21
051E   CA FF FF                     jp z,0xffff
0521   FE 22                        cp 0x22
0523   CA FF FF                     jp z,0xffff
0526   FE 23                        cp 0x23
0528   CA FF FF                     jp z,0xffff
052B   FE 24                        cp 0x24
052D   CA B0 03                     jp z,L3B0
0530   FE 25                        cp 0x25
0532   CA 84 03                     jp z,L384
0535   FE 26                        cp 0x26
0537   CA FF FF                     jp z,0xffff
053A   FE 27                        cp 0x27
053C   CA E4 01                     jp z,L1E4
053F   C3 78 03                     jp POP_HLAF
0542   FF                           RST   0x38
0543   FF                           RST   0x38
0544   FF                           RST   0x38
0545   FF                           RST   0x38
0546   FF                           RST   0x38
0547   FF                           RST   0x38
0548   FF                           RST   0x38
0549   FF                           RST   0x38
054A   FF                           RST   0x38
054B   FF                           RST   0x38
054C   FF                           RST   0x38
054D   FF                           RST   0x38
054E   FF                           RST   0x38
054F   FF                           RST   0x38
0550   CD 89 02     L550:           call GETEDITADDR
0553   60                           ld h,b
0554   69                           ld l,c
0555   3A E1 08                     ld a,(X3)
0558   23           L558:           inc hl
0559   BE                           cp (hl)
055A   20 FC                        jr nz,L558
055C   44                           ld b,h
055D   4D                           ld c,l
055E   CD 90 04                     call SETEDITADDR
0561   C3 53 02                     jp L253
0564   FF                           db 0xFF
0565   FF                           db 0xFF
0566   FF                           db 0xFF
0567   FF                           db 0xFF
0568   FF                           db 0xFF
0569   FF                           db 0xFF
056A   FF                           db 0xFF
056B   FF                           db 0xFF
056C   FF                           db 0xFF
056D   FF                           db 0xFF
056E   FF                           db 0xFF
056F   FF                           db 0xFF
