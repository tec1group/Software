;Command block registers
PATA_ADDR:      .equ    20H             ; Base address A5
REG_DATA:       .equ    PATA_ADDR+000B  ;Data Register
REG_ERR:        .equ    PATA_ADDR+001B  ;Read: Error
REG_FR:         .equ    PATA_ADDR+001B  ;Write: Features
REG_SC:         .equ    PATA_ADDR+010B  ;Sector Count
REG_SN:         .equ    PATA_ADDR+011B  ;Sector Number
REG_LBA7:       .equ    PATA_ADDR+011B  ;LBA Bits 0-7
REG_CYLO:       .equ    PATA_ADDR+100B  ;Cylinder Low
REG_LBA15:      .equ    PATA_ADDR+100B  ;LBA Bits 8-15
REG_CYHI:       .equ    PATA_ADDR+101B  ;Cylinder High
REG_LBA23:      .equ    PATA_ADDR+101B  ;LBA Bits 16-23
REG_DH:         .equ    PATA_ADDR+110B  ;Drive/Head
REG_LBA27:      .equ    PATA_ADDR+110B  ;LBA Bits 24-27
REG_STATUS:     .equ    PATA_ADDR+111B  ;Read: Status
REG_CMD:        .equ    PATA_ADDR+111B  ;Write: Command
REG_DATA_HI:    .equ    PATA_ADDR+1000B ;Data Register High Byte

;Status flags (bits)
F_BSY:          .equ    7               ;Drive busy
F_DRDY:         .equ    6               ;Drive ready for command
F_DSC:          .equ    4               ;Drive head settled over sector
F_DRQ:          .equ    3               ;Drive ready for r/w
F_ERR:          .equ    1               ;Drive error

;Features flags
F_ENA8BIT       .equ    01H             ;Enable 8-bit mode
F_DIS8BIT       .equ    81H             ;Disable 8-bit mode

;Drive commands
CMD_INITPAR:    .equ    091H            ;Init drive parameters
CMD_READ:       .equ    020H            ;Read sector w. retry
CMD_WRITE:      .equ    030H            ;Write sector w. retry
CMD_IDENTIFY:   .equ    0ECH            ;Identify device
CMD_SETFR:      .equ    0EFH            ;Set Features
CMD_DIAG:	.equ    090H            ;Drive diagnosis

;Constants
C_RETRIES:      .equ    0FFH            ;Number of retries for busy disk
C_FILENO:       .equ    0897H           ;Address of File number menu selection 
C_MCB:          .equ    0888H           ;Master Control Block
C_SERIDLE:      .equ 00000101B          ;Serial Idle state
C_SERCS:        .equ 11111011B          ;Serial Chip Select state

;MON3 API Calls
API_STR2LCD:    .equ    0DH             ;string to LCD
API_CHR2LCD:    .equ    0EH             ;character to LCD
API_CMD2LCD:    .equ    0FH             ;command to LCD
API_MENU:       .equ    1FH             ;menu driver
API_PARAM:      .equ    20H             ;parameter driver
API_MENUPOP:    .equ    2FH             ;menu pop

;RAM Locations
HIGH_RAM:       .equ    0800H           ;High RAM
DISK_BUFF:      .equ    HIGH_RAM - 200H ;Disk data buffer (512 bytes)
;FAT32 Configuration data
DATA_START:     .equ    DISK_BUFF - 4   ;Data start sector
ROOT_CLUS:      .equ    DATA_START - 4  ;Cluster number of the Root Directory / File
ROOT_START:     .equ    ROOT_CLUS - 4   ;Root directory start sector
FAT_START:      .equ    ROOT_START - 4  ;Start sector to first FAT
PART_START:     .equ    FAT_START - 4   ;First sector of partition
FAT_COUNT:      .equ    PART_START - 1  ;Number of FATs
FAT_SIZE:       .equ    FAT_COUNT - 4   ;FAT size in sectors
RSVD_SEC:       .equ    FAT_SIZE - 2    ;Number of reserved sectors
CLUS_SEC:       .equ    RSVD_SEC - 1    ;Size of a cluster (in sectors)
VOL_LABEL:      .equ    CLUS_SEC - 11   ;Name of Volume Label
;File Control Block
FCB_NAME:       .equ    VOL_LABEL - 12  ;File Name
FCB_NSEC:       .equ    FCB_NAME - 4    ;Next sector
FCB_ADDR:       .equ    FCB_NSEC - 2    ;TEC Address of file
FCB_SCNT:       .equ    FCB_ADDR - 1    ;Sector counter
;SD Card Read/Write Command
SD_CMD:         .equ    FCB_SCNT - 6    ;SD Read Command
;Root File clusters (4 bytes) and file size (2 bytes)
RFC_LIST:       .equ    SD_CMD - 400    ;Root file cluster / file size list (8 bytes / file)
;Directory Configuration, Max entries = (886 - 27 ) / 15 = 49 MAX
DIR_CFG:        .equ    RFC_LIST - 816  ;100H

loadFromDisk:
        call initDisk                   ;Mount and get Root Directory
        ld hl,DIR_CFG
        ld c,API_MENU                   ;menu driver
        rst 10H                         ;mon3 API Call
        ret

initDisk:
        ;mount the volume and display the root directory
        ;check for SD and if present, initialize it
        ld a,(C_MCB)                    ;Get MCB
        and MCB_SD_CARD                 ;Check if Bit 7 set?
        call nz,initSD                  ;yes, init SD Card
        call FATmount                   ;Mount the Drive
        call FATgetRootDir              ;List root directory
        ret

initPata1:
        call waitBusy               ;Wait for Busy flag to clear
        ; ld a,F_ENA8BIT              ;Features register 8 bit mode
        ; out (REG_FR),a
        ; ld a,CMD_SETFR              ;Send set features command
        ; out (REG_CMD),a
        ; call waitDriveReady         ;Wait for Busy flag to clear
        ret

;wait until busy flag is unset
;return:  carry not set = device is ready
;         carry set = device timeout
;         A = error register if carry is set (could be zero if just a time out)
;         HL = error message if carry is set
waitBusy:
        push bc                     ;save BC
        and a                       ;clear carry flag
        ld b,C_RETRIES              ;number of retries to timeout
waitLoop1:        
        in a,(REG_STATUS)           ;Read Status register
        and 11000001B               ;Only bits 7,6 and 0 are needed
        xor 01000000B               ;Flip disk ready bit
        jr z,waitExit               ;all good, just exit
        ld c,0                      ;sub delay
waitLoop2:
        dec c                       ;mini loop
        jr nz,waitLoop2
        djnz waitLoop1
        scf                         ;error if here
        ld hl,MSG_TIMEOUT
        bit 0,a                     ;check if error bit set
        ld a,0                      ;default to zero
        jr z,waitExit               ;no error bit set, just exit
        in a,(REG_ERR)              ;get error register
waitExit:
        pop bc                      ;restore BC
        ret

;wait for data request to be set.  Meaning data is ready to be sent/received
;return:  carry not set = data requested
;         carry set = not data requested (error)
;         A = error register if carry is set (could be zero if just a no data request)
;         HL = error message if carry is set
waitDataRequest:
        push bc                     ;save BC
        and a                       ;clear carry flag
        ld bc,C_RETRIES * 256 + C_RETRIES  ;mega delay as drive head could take a time
waitDRLoop1:        
        in a,(REG_STATUS)           ;Read Status register
        bit 3,a                     ;check data request bit
        jr nz,waitDRExit            ;its set, all good
        dec bc                       ;mini loop
        ld a,c
        or b
        jr nz,waitDRLoop1
        scf                         ;error if here
        ld hl,MSG_DRQST
        bit 0,a                     ;check if error bit set
        ld a,0                      ;default to zero
        jr z,waitDRExit             ;no error bit set, just exit
        in a,(REG_ERR)              ;get error register
waitDRExit:
        pop bc                      ;restore BC
        ret

;read a sector from the disk and store in data buffer pointed from HL
;Input: BCDE = LBA sector address 3,2,1 and 0
;       HL = Address of data buffer (512 bytes)
;Output:  carry not set = data read 
;         carry set = data not read (error)
IDEreadSector:
        push bc                     ;save BC
        push hl                     ;save HL
        push de                     ;save DE
        ld a,(C_MCB)                ;Get MCB
        and MCB_SD_CARD             ;Check if Bit 7 set?
        jr z,readPATA               ;no, read PATA
        ;read from SD card as its present
        ld a,1
        ld (SD_CMD+5),a             ;set return
        ex de,hl                    ;swap DE and HL
        ld a,l                      ;LBA 0
        ld (SD_CMD+4),a             ;set LBA 0-7
        ld a,h                      ;LBA 1
        ld (SD_CMD+3),a             ;set LBA 8-15
        ld a,c                      ;LBA 2
        ld (SD_CMD+2),a             ;set LBA 16-23
        ld a,b                      ;LBA 3
        ld (SD_CMD+1),a             ;set LBA 24-27
        ld a,(spiCMD17)             ;Read command
        ld (SD_CMD),a               ;set command id
        ld hl,SD_CMD                ;Read command
        call sendSPICommand
        or a
        ld hl,MSG_BPB
        jr nz,doERR                 ;error
        ex de,hl                    ;swap DE and HL
        call readSPIBlock
        jr rsExit                   ;exit cleanly
        ;read from PATA drive
readPATA:
        call waitBusy               ;is the drive ready?
        jr c,doERR                  ;no, error
        call setLBA                 ;set up LBA
        call waitBusy               ;is the drive ready?
        jr c,doERR                  ;no, error
        ld a,CMD_READ               ;set read command
        out (REG_CMD),a
        call waitDataRequest        ;Is the drive ready to send data?
        jr c,doERR                  ;no, error
        ld b,0                      ;256 words (512 bytes)
rsloop:
        in a,(REG_DATA)	            ;get low byte of ide data word first	
        ld (hl),a                   ;store low byte
        inc hl
        in a,(REG_DATA_HI)          ;get high byte of ide data word from latch
        ld (hl),a
        inc hl
        djnz rsloop
rsExit:
        pop de                      ;restore DE
        pop hl                      ;restore HL
        pop bc                      ;restore BC
        ret

;general error output routine.  
;Input: HL = address of ASCII string
;       A = error register
doERR:
        ld b,01H                    ;clear LCD
        ld c,API_CMD2LCD            ;command to LCD
        rst 10H                     ;mon3 API Call
        push af                     ;save error register
        push hl                     ;save error message
        ld hl,MSG_IOERR             ;set read message
        ld c,API_STR2LCD            ;string to LCD
        rst 10H                     ;mon3 API Cal
        ld b,0C0H                   ;second row
        ld c,API_CMD2LCD            ;command to LCD
        rst 10H                     ;mon3 API Call
        pop hl
        ld c,API_STR2LCD            ;string to LCD
        rst 10H                     ;mon3 API Cal
        pop af                      ;restore error register
        call AtoLCD                 ;display error register
        rst 08H                     ;wait for key press
        scf                         ;set carry for error
        pop de                      ;restore DE
        pop hl                      ;restore HL
        pop bc                      ;restore BC
        rst 00H                     ;reboot

;write a sector to the disk.
;Input: BCDE = LBA sector address 3,2,1 and 0
;       HL = Address of data buffer (512 bytes)
;Output:  carry not set = data read 
;         carry set = data not read (error)
IDEwriteSector:
        push bc                     ;save BC
        push hl                     ;save HL
        push de                     ;save DE
        ld a,(C_MCB)                ;Get MCB
        and MCB_SD_CARD             ;Check if Bit 7 set?
        jr z,writePATA              ;no, write PATA
        ;write to SD card as its present
        ld a,1
        ld (SD_CMD+5),a             ;set return
        ex de,hl                    ;swap DE and HL
        ld a,l                      ;LBA 0
        ld (SD_CMD+4),a             ;set LBA 0-7
        ld a,h                      ;LBA 1
        ld (SD_CMD+3),a             ;set LBA 8-15
        ld a,c                      ;LBA 2
        ld (SD_CMD+2),a             ;set LBA 16-23
        ld a,b                      ;LBA 3
        ld (SD_CMD+1),a             ;set LBA 24-27
        ld a,(spiCMD24)             ;Write command
        ld (SD_CMD),a               ;set command id
        ld hl,SD_CMD                ;Write command
        call sendSPICommand
        or a
        ld hl,MSG_BPB
        jr nz,doERR                 ;error
        ex de,hl                    ;swap DE and HL
        call writeSPIBlock
        cp 05h                      ;check if write was successful
        jr nz,doERR                 ;no, error
        jr rsExit                   ;exit cleanly
writePATA:
        call waitBusy               ;is the drive ready?
        jr c,doERR                  ;no, error
        call setLBA                 ;set up LBA
        call waitBusy               ;is the drive ready?
        jr c,doERR                  ;no, error
        ld a,CMD_WRITE              ;set write command
        out (REG_CMD),a
        call waitDataRequest        ;Is the drive ready to send data?
        jr c,doERR                  ;no, error
        ld b,0                      ;256 words (512 bytes)
wsloop1:
        ld a,(hl)                   ;get low byte
        ld c,a                      ;store in C
        inc hl
        ld a,(hl)                   ;get high byte
        out (REG_DATA_HI),a         ;send high byte to latch
        ld a,c                      ;get low byte in A
        out (REG_DATA),a            ;send low byte and output entire word
        inc hl
        djnz wsloop1
        jp rsExit                   ;exit cleanly

;read disk information
;Input:   HL = Address of data buffer (512 bytes)
;Output:  carry not set = data read 
;         carry set = data not read (error)
; IDEdiskInfo:
;         push bc                     ;save BC
;         push hl                     ;save HL
;         call waitBusy               ;is the drive ready?
;         jr c,doERR                  ;no, error
;         call setLBA                 ;set up LBA
;         call waitBusy               ;is the drive ready?
;         jr c,doERR                  ;no, error
;         ld a,CMD_IDENTIFY           ;set identify command
;         out (REG_CMD),a
;         call waitDataRequest        ;Is the drive ready to send data?
;         jr c,doERR                  ;no, error
;         ld b,0                      ;256 words (512 bytes)
; idloop:
;         in a,(REG_DATA)	            ;get low byte of ide data word first
;         ld c,a                      ;store in C	
;         in a,(REG_DATA_HI)          ;get high byte of ide data word from latch
;         ld (hl),a                   ;store low byte
;         inc hl
;         ld (hl),c
;         inc hl
;         djnz idloop
;         jr rsExit                   ;exit cleanly

; Set sector count and LBA registers of the drive
; Input: BCDE = LBA sector address 3,2,1 and 0
; Destory: None
setLBA:
        push af
        ;sector count
        ld a,01H
        out (REG_SC),a              ;set sector count
        ld a,e                      ;LBA 0
        out (REG_LBA7),a            ;set LBA 0-7
        ld a,d                      ;LBA 1
        out (REG_LBA15),a           ;set LBA 8-15
        ld a,c                      ;LBA 2
        out (REG_LBA23),a           ;set LBA 16-23
        ld a,b                      ;LBA 3
        and 00001111B               ;only bits 0-3 are LBA 3
        or 11100000B                ;select LBA and master drive
        out (REG_LBA27),a           ;set LBA 24-27
        pop af
        ret

;A to LCD.  Display register A to the LCD screen
AtoLCD:
        push af                     ;save AF
        rra                         ;move high
        rra                         ;nibble to low nibble
        rra
        rra
        call lowNibToString1        ;get lower nibble and save in DE
        pop af                      ;restore AF
lowNibToString1:
        and 0FH                     ;mask out high nibble
        add a,90H                   ;convert to
        daa                         ;ASCII
        adc a,40H                   ;using this
        daa                         ;amazing routine
        ld c,API_CHR2LCD            ;character to LCD
        rst 10H                     ;mon3 API Cal
        ret                         ;exit back

;Mount the Disk and configure the FAT data for IO
FATmount:
        ;get the Master Boot Record located at sector 0 of the disk
        ld bc,0000H                 ;high lba
        ld de,0000H                 ;low lba
        ld hl,DISK_BUFF             ;allocate disk buffer
        call IDEreadSector          ;get block
        jp c,FATerror1              ;error
        ;check 55AAH on MBR trailer
        ld a,(DISK_BUFF + 01FEH)
        cp 55H
        jp nz,FATerror2             ;error
        ld a,(DISK_BUFF + 01FFH)
        cp 0AAH
        jp nz,FATerror2             ;error
        ;get partition start
        ld bc,0004H                 ;4 bytes
        ld hl,DISK_BUFF + 01C6H     ;source of partition 1
        ld de,PART_START            ;destination
        ldir                        ;copy it
        ;read Bios Parameter Block (BPB)
        ld bc,(PART_START + 2)      ;high lba
        ld de,(PART_START)          ;low lba
        ld hl,DISK_BUFF             ;allocate disk buffer
        call IDEreadSector          ;get block
        jp c,FATerror3              ;error
        ;check Bytes per sector is 512
        ld a,(DISK_BUFF + 0BH)
        or a                        ;zero
        jp nz,FATerror4             ;error
        ld a,(DISK_BUFF + 0CH)
        cp 02H
        jp nz,FATerror4             ;error
        ;get volume label
        ld bc,0011H                 ;1 bytes
        ld hl,DISK_BUFF + 47H       ;source of volume lable
        ld de,VOL_LABEL             ;destination
        ldir                        ;copy it
        ;get cluster size
        ld a,(DISK_BUFF + 0DH)
        ld (CLUS_SEC),a
        ld (FCB_SCNT),a             ;and set it to sector count
        ;get reserve sector count
        ld hl,(DISK_BUFF + 0EH)
        ld (RSVD_SEC),hl
        ;get Root Cluster
        ld bc,0004H                 ;4 bytes
        ld hl,DISK_BUFF + 2CH       ;source of RootClus
        ld de,ROOT_CLUS             ;destination
        ldir                        ;copy it
        ;get FAT count
        ld a,(DISK_BUFF + 10H)
        ld (FAT_COUNT),a
        ;get FAT size
        ld bc,0004H                 ;4 bytes
        ld hl,DISK_BUFF + 24H       ;source of FATSz32
        ld de,FAT_SIZE              ;destination
        ldir                        ;copy it
        ;calculate FAT start
        ld hl,(PART_START)          ;FAT START = PART START + RESERVED SECTORS
        ld bc,(RSVD_SEC)
        add hl,bc                   ;add lower parts together
        ld (FAT_START),hl           ;save to lower of fat start
        ld hl,(PART_START + 2)      
        ld bc,0000H                 ;upper part
        adc hl,bc                   ;add high parts with carry together
        ld (FAT_START + 2),hl       ;save to higher of fat start
        ;calculate Data Start Sector = FAT_START + (FAT_COUNT * FAT_SIZE)
        ld a,(FAT_COUNT)            ;get number of FATs
        ld de,(FAT_SIZE)            ;get lower byte
        ld bc,(FAT_SIZE+2)          ;get upper byte
        call BCDEtimeA              ;get product
        ld de,(FAT_START)
        ld bc,(FAT_START+2)         ;get fat start
        add ix,de                   ;add lower word
        adc hl,bc                   ;add upper word
        ld (DATA_START),ix          ;save ROOT_START
        ld (DATA_START+2),hl
        ;calculate Root Directory.  This is the Root Cluster
        ld de,(ROOT_CLUS)           ;get root cluster number
        ld bc,(ROOT_CLUS+2)
        call FATgetSector           ;get root cluster sector
        ld (ROOT_START),ix          ;save root directory
        ld (ROOT_START+2),hl
        ret

FATerror1:
        ld hl,MSG_MBR               ;Master Boot Record
        jr FATerror
FATerror2:
        ld hl,MSG_MBR_BAD           ;MBR Illegal
        jr FATerror
FATerror3:
        ld hl,MSG_BPB               ;BPB failure
        jr FATerror
FATerror4:
        ld hl,MSG_BPS               ;Bytes per sector
        jr FATerror
FATerror5:
        ld hl,MSG_ROOT              ;Root dir error
        jr FATerror
FATerror6:
        ld hl,MSG_FILE              ;File not found
        jr FATerror
FATerror7:
        ld hl,MSG_INTEL             ;Bad Checksum
        jr FATerror
FATerror8:
        ld hl,MSG_NOSDCARD          ;No SD Card
        jr FATerror
FATerror9:
        ld hl,MSG_OCR              ;OCR Read Fail
        jr FATerror
FATerror10:
        ld hl,MSG_SDINVALID         ;Invalid SDCard
        jr FATerror
FATerror11:
        ld hl,MSG_SDCMD16          ;CMD16 Failed
        jr FATerror
FATerror12:
        ld hl,MSG_TOOBIG           ;Address too large
        jr FATerror

FATerror:
        push bc                     ;save BC
        push hl                     ;save HL
        jp doERR                    ;display the error

;Get the root directory.  Only look at visiable, short name files.  Fill out 
;menu data structure with directory listing
FATgetRootDir:
        ;create menu configuration
        ld de,DIR_CFG               ;get menu config
        xor a                       ;clear count
        ld (de),a
        inc de
        ld hl,MENU_SEG              ;get menu segments
        ld bc,14
        ldir                        ;copy segment/menu text
        ld hl,VOL_LABEL             ;get volumen label
        ld bc,11
        ldir
        xor a
        ld (de),a                   ;zero terminate string
        inc de
        push de
        ;iterate through the 32 byte directory enties, and single out visable short files
        ld hl,DISK_BUFF
        ld de,(ROOT_START)
        ld bc,(ROOT_START+2)
        call FATreadSector
        ld ix,DISK_BUFF-32          ;start of diretory buffer
        pop de
dirLoop:
        push de
        ld bc,32                    ;skip to next directory entry (32 bytes)
        add ix,bc
        ld hl,HIGH_RAM              ;check if end of sector
        or a                        ;clear carry
        push ix
        pop bc
        sbc hl,bc
        jr nz,skipLoadNextSec
        ;load next sector
        ld hl,DISK_BUFF
        ld de,(FCB_NSEC)
        ld bc,(FCB_NSEC+2)
        call FATreadSector
        ld ix,DISK_BUFF             ;start of new diretory sector
skipLoadNextSec:
        pop de
        ld a,(ix+0)                 ;check first character
        cp 00H                      ;is it end of directory listing?
        ret z                       ;yes, all done, exit
        cp 0E5H                     ;is it a deleted file?
        jr z,dirLoop                ;ignore
        ld a,(ix+11)                ;get attribute byte
        cp 20H                      ;must be ATTR_ARCHIVE only
        jr nz,dirLoop               ;ignore if otherwise
        ;good file, copy it to menu configuration
        ld bc,8                     ;get main part of file name
        push ix
        pop hl
spaceLoop:
        ld a,(hl)                   ;get character
        cp " "                      ;is it a space?
        jr z,mainDone
        ldi
        jp pe,spaceLoop
mainDone:
        add hl,bc                   ;move hl to correct position
        ld a,"."                    ;separate with a dot
        ld (de),a                   ;zero terminate string
        inc de
        ld bc,3                     ;get extension part of file name
extLoop:
        ld a,(hl)                   ;get first character
        cp " "                      ;is it a space?
        jr z,extDone                ;yes, no extension
        ldi
        jp pe,extLoop               ;no, copy extension
extDone:
        xor a
        ld (de),a                   ;zero terminate string
        inc de
        ld bc,FATfileLoader         ;get address of function
        ld a,c
        ld (de),a
        inc de
        ld a,b
        ld (de),a                   ;store it in menu config
        inc de
        ld a,(DIR_CFG)               ;get menu count
        push af                     ;store menu count
        ;store cluster number and file size
        ld hl,RFC_LIST
        ld c,a
        ld b,0                      ;clear B
        ;calculate index to RFC_LIST
        or a                       ;clear carry
        rl c                        ;x2
        rl c                        ;x4
        rl c                        ;x8
        jr nc,$+3
        inc b                       ;add 1 if carry set
        add hl,bc                  ;add to RFC_LIST
        ld a,(ix+26)                ;First cluster low word
        ld (hl),a
        inc hl
        ld a,(ix+27)                ;First cluster low word
        ld (hl),a
        inc hl
        ld a,(ix+20)                ;First cluster high word
        ld (hl),a
        inc hl
        ld a,(ix+21)                ;First cluster high word
        ld (hl),a
        inc hl
        ld a,(ix+28)                ;File size low word
        ld (hl),a       
        inc hl
        ld a,(ix+29)                ;File size low word
        ld (hl),a       
        inc hl
        ld a,(ix+30)                ;File size high word
        ld (hl),a       
        inc hl
        ld a,(ix+31)                ;File size high word
        ld (hl),a       
        pop af                      ;restore menu count
        inc a
        ld (DIR_CFG),a              ;save menu count
        jp dirLoop                  ;repeat

MENU_SEG:       .db "LOAD--Volume: "

;Load a file from menu.  First get the file number in the menu.  Use this
;to index the RFC_LIST to get the file cluster and file size.  Save file name 
;to FCB_NAME and Finally, ask for an address to load to and load the cluster to
;that address
FATfileLoader:
        ;get file name 
        call saveFileName           ;save the file name to FCB_NAME
        ;see if its an Intel Hex File *.hex extension
        ld hl,FCB_NAME              ;name of file
        ld bc,9                     ;up to 9 chars for file name
        ld a,'.'                    ;file extension separator
        cpir                        ;move hl to extension
        ld de,HEX_EXT
        ;check extension for .hex
        call cpstr                  ;compare file extension
        jr z,HEXfile                ;its a hex file, load as intel hex file
        ;Load file as binary
        ;get save address via parameter driver
        ld a,(C_FILENO)             ;map to mon3 Menu data for selected menu entry
        push af                     ;save file number        
        ld hl,LOAD_CFG              ;load parameter configuration
        ld c,API_PARAM              ;parameter driver
        rst 10H                     ;mon3 API Call
        pop af
        ;get cluster from RFC_LIST
        ld (C_FILENO),a             ;map to mon3 Menu data for selected menu entry
        call getFirstCluster        ;get first cluster of file selected
        push ix                     ;save file size
        call FATgetSector           ;get sector of cluster
        ld hl,DISK_BUFF
        ld de,(FCB_NSEC)
        ld bc,(FCB_NSEC+2)
        call FATreadSector          ;read sector of file
        ;keep going until all bytes are copied.
        ld ix,HIGH_RAM              ;end of sector
        pop bc                      ;get file size
        ld hl,DISK_BUFF             ;source
        ld de,(FCB_ADDR)            ;destination
fileCopyLoop:
        ldi
        jp po,fileLoaded            ;no data left
        ld a,d                      ;check for max address 0x0000
        or e
        jr z,fileLoaded
        ld a,ixl
        cp l
        jr nz,fileCopyLoop          ;check if next sector needed
        ld a,ixh
        cp h
        jr nz,fileCopyLoop          ;check if next sector needed
        ;load next sector
        push bc
        push de
        ld hl,DISK_BUFF
        ld de,(FCB_NSEC)
        ld bc,(FCB_NSEC+2)
        call FATreadSector
        ld hl,DISK_BUFF             ;source
        pop de
        pop bc
        jr fileCopyLoop
HEXfile:
        ;must be hex file
        call loadHEX                ;load intel hex file
        jp nz,FATerror7             ;error
fileLoaded:
        ;pop menu off
        ld c,API_MENUPOP            ;menu pop off
        rst 10H                     ;mon3 API Call
        ret

HEX_EXT:        .db "HEX",0

;Load a intel HEX file from menu.  First get the file number in the menu.  Use this
;to index the RFC_LIST to get the file cluster and file size.  Then iterate through
;the data converting it to binary
loadHex:
        ;get cluster from RFC_LIST
        ld a,(C_FILENO)             ;map to mon3 Menu data for selected menu entry
        call getFirstCluster        ;get first cluster of file selected
        call FATgetSector           ;get sector of cluster
        ld hl,DISK_BUFF
        ld de,(FCB_NSEC)
        ld bc,(FCB_NSEC+2)
        call FATreadSector          ;read sector of file
        ;keep going until all bytes are copied.
        ld ix,HIGH_RAM              ;end of sector
        ld iy,DISK_BUFF             ;source
intelLoader1:
        ld c,0                      ;clear checksum
        ;Get header information
intelMark1:
        call checkEndBuff           ;check if reached end of buffer
        ld a,(iy+0)                 ;get byte
        inc iy                      ;move to next char
        cp ':'                      ;Is byte received a colon?
        jr nz,intelMark1            ;No, loop until a colon is found
        call getHexByte1            ;Convert ASCII to Byte (Length)
        ld b,a                      ;Store Record Length in B
        call getHexByte1            ;Convert ASCII to Byte (Destination address)
        ld h,a                      ;Store High Address byte in H
        call getHexByte1            ;Convert ASCII to Byte (Destination address)
        ld l,a                      ;Store Low Address byte in L
        call getHexByte1            ;Convert ASCII to Byte (Record Type)
        jr nz,intelCheckSum1        ;Anything non zero treat as EOF
        ;C=checksum, B=number of bytes, HL=destination address
        ;Load bytes to (HL), B times
intelLoad1:
        call getHexByte1            ;Convert ASCII to Byte (Data)
        ld (hl),a                   ;store data in RAM
        inc hl                      ;move to next RAM location
        djnz intelLoad1             ;repeat until B=0
        call intelCheckSum1         ;Get checksum value
        jr z,intelLoader1           ;Line is processed and okay, get next line
        ret                         ;Exit with zero flag not set (load error)
intelCheckSum1:
        call getHexByte1            ;Convert ASCII to Byte (Checksum)
        ld a,c                      ;Final Checksum is zero if okay
        or a                        ;set zero flag
        ret                         ;get next line or exit

        ;Get ASCII character from FTDI AND convert it to a byte
        ;IE: "D3" -> 0D3H
getHexByte1:
        call getHexChar1            ;Get first Hex character from FTDI
        rlca                        ;Move lower nibble
        rlca                        ;(first character)
        rlca                        ;to upper
        rlca                        ;nibble in A
        ld d,a                      ;store it in D
        call getHexChar1            ;Get second Hex character from FTDI
        or d                        ;make a byte
        ;add byte to checksum
        push af                     ;save AF
        add a,c                     ;add existing checksum C to current byte
        ld c,a                      ;load total back to C
        pop af                      ;restore AF
        ret
getHexChar1:
        call checkEndBuff           ;check if reached end of buffer
        ld a,(iy+0)                 ;Get next byte
        inc iy
        bit 6,a                     ;is the chracter 0-9 or A-F?
        jr z,$+4                    ;Its 0-9 skip A-F adjustment
        add a,9                     ;add 9 to fix A-F
        and 0FH                     ;mask out high nibble and convert to binary
        ret
        ;Check if End of disk buffer and get a new one if at end
checkEndBuff:
        ld a,ixl
        cp iyl
        ret nz                      ;different
        ld a,ixh
        cp iyh
        ret nz                      ;different
        ;load next sector
        push bc
        push de
        push hl
        ld hl,DISK_BUFF
        ld de,(FCB_NSEC)
        ld bc,(FCB_NSEC+2)
        call FATreadSector
        ld iy,DISK_BUFF              ;source
        pop hl
        pop de
        pop bc
        ret

;Read a Sector and fill out next sector in cluster.  If end of cluster,
;get the next cluster and sector from File Allocation Table (FAT)
;Input: BCDE = LBA sector address 3,2,1 and 0
;       HL = Address of data buffer (512 bytes)
;Output: FCB_NSEC set to next sector
FATreadSector:
        ;check if all sectors in cluster have been read
        ld a,(FCB_SCNT)             ;get current sector count
        or a                        ;is it zero
        jr nz,readSector1           ;no, just read sector
        call FATgetFAT              ;get next cluster from FAT
readSector1:
        call IDEreadSector
        jp c,FATerror5              ;error
        ;fill FCB Next Sector
        ld hl,0001H
        add hl,de
        ld (FCB_NSEC),hl
        ld hl,0000H
        adc hl,bc
        ld (FCB_NSEC+2),hl
        ld hl,FCB_SCNT              ;get current sector count
        dec (hl)                    ;decrease by one
        ret

;Get the sector based off a cluster number
;Uses the formula ((Cluster Number - 2) * Sectors Per Cluster) + Data Start
;Input: BCDE = 32 bit cluster number
;Output: HLIX = 32 bit sector number
;        (FCB_NSEC) = HLIX
FATgetSector:
        ld a,2                      ;cluster base
        cpl                         ;take 2 from cluster number
        scf
        adc a,e
        ld e,a
        jr c,nodec
        dec d
        jp p,nodec
        dec bc
nodec:
        ld a,(CLUS_SEC)             ;get clusters per sector
        call BCDEtimeA              ;get sector of cluster
        ld bc,(DATA_START)          ;get low byte of data start
        add ix,bc                   ;get addition
        ld bc,(DATA_START+2)        ;get high byte of data start
        adc hl,bc                   ;get addition
        ;save in FCB_NSEC
        ld (FCB_NSEC),ix
        ld (FCB_NSEC+2),hl
        ret

;set next cluster and sector from FAT
;(Current Cluster * 4) + FAT_START
;Get sector in FAT where cluster is
;Returns BCDE = LBA sector address 3,2,1 and 0
;        HL = Disk Buffer
FATgetFAT:
        ld hl,(ROOT_CLUS)           ;get current cluster
        ld de,(ROOT_CLUS+2)
        ld c,128
        call DEHLDivC               ;(Current Cluster  / 128)
        push af                     ;store remainder
        ;DEHL = cc/128
        ld bc,(FAT_START)
        add hl,bc
        ex de,hl
        ld bc,(FAT_START+2)         ;get fat start
        adc hl,bc
        push hl
        pop bc
        ;BCDE = LBA sector address 3,2,1 and 0
        ld hl,DISK_BUFF
        call IDEreadSector          ;get sector of FAT for cluster
        pop af                      ;get remainder from AF to get offset
        ld e,a
        ld d,0
        ld bc,0
        ld a,4
        push ix
        call BCDEtimeA              ;multipy it by 4.  Result in IX
        ;Index DISK_BUFF to next cluster
        push ix
        pop de
        ld hl,DISK_BUFF
        add hl,de
        ;HL is now pointing to next cluster
        ld e,(hl)                   ;BCDE = cluster number in HL
        inc hl
        ld d,(hl)
        inc hl
        ld c,(hl)
        inc hl
        ld b,(hl)
        ld (ROOT_CLUS),de           ;save root cluster
        ld (ROOT_CLUS+2),bc
        ld a,(CLUS_SEC)             ;get cluster sector
        ld (FCB_SCNT),a             ;and set it to sector count
        ;read sector of cluster
        call FATgetSector           ;get sector of cluster
        ld hl,DISK_BUFF
        ld de,(FCB_NSEC)
        ld bc,(FCB_NSEC+2)
        pop ix
        ret

;Save file name from menu to FCB_NAME
;Output: FCB_NAME populated with file name selected
saveFileName:
        ld hl,DIR_CFG + 7           ;start from menu title
        ld bc,893                   ;size of max menu
        xor a
        cpir                        ;skip menu title
        ld a,(C_FILENO)             ;map to mon3 Menu data for selected menu entry
titleLoop:
        or a                        ;is it zero?
        jr z,saveTitle
        ld d,a                      ;save file number
        xor a
        cpir                        ;find next file name
        inc hl                      ;skip menu routine function
        inc hl
        jp po,FATerror6             ;file not found
        dec d
        ld a,d
        jr titleLoop                ;loop again until title is found
saveTitle:
        ld bc,12                    ;up to 12 bytes
        ld de,FCB_NAME              ;save file name
saveLoop:
        ldi                         ;copy it
        ld a,(hl)
        or a                        ;is it zero?
        jr nz,saveLoop
        ;fill rest with spaces
        or c                        ;are there none left?
        ret z
        ld b,c
        ld a," "                    ;space
fillLoop:
        ld (de),a
        inc de
        djnz fillLoop
        ret

;Get first cluster of file selected on menu
;Input: A = index of file selected from menu
;Output: BCDE = 32 bit cluster number
;        IX = file size
;        (ROOT_CLUS) = BCDE
;Destroy: HL,A
getFirstCluster:
        inc a                       ;move to next entry as I want to look back
        ld hl,RFC_LIST
        ld c,a
        ld b,0                      ;clear B
        ;calculate index to RFC_LIST
        or a                       ;clear carry
        rl c                        ;x2
        rl c                        ;x4
        rl c                        ;x8
        jr nc,$+3
        inc b                       ;add 1 if carry set
        add hl,bc                  ;add to RFC_LIST
        ;HL is now pointing to RFC_LIST
        ;get file size
        dec hl
        dec hl
        dec hl
        ld b,(hl)
        dec hl
        ld c,(hl)
        push bc                     ;save for after cluster load
        pop ix
        ;check for zero file size and make FFFF.  Can only load a max AFFF bytes
        ld a,ixl
        or a
        jr nz,getCluster
        ld a,ixh
        or a
        jr nz,getCluster
        dec ix
getCluster:
        dec hl
        ;get cluster number
        ld b,(hl)                   ;BCDE = cluster number in HL
        dec hl
        ld c,(hl)
        dec hl
        ld d,(hl)
        dec hl
        ld e,(hl)
        ld (ROOT_CLUS),de           ;save root cluster
        ld (ROOT_CLUS+2),bc
        ld a,(CLUS_SEC)             ;get cluster sector
        ld (FCB_SCNT),a             ;and set it to sector count
        ret

;Open a file from the disk
;Input: HL = Pointer to a ZERO terminated file name
;Output: C_FILENO = (0897H) index of file in RFC_LIST or Directory Listing
openFile:
        push hl
        call initDisk               ;Mount and get Root Directory`
        pop hl
        ;Search the DIR_CFG for the file name
        ex de,hl
        ld hl,DIR_CFG
        ld b,(hl)                   ;get menu count
        ld hl,DIR_CFG + 7           ;start from menu title
        xor a
        ld (C_FILENO),a             ;clear file number
skipTitle:
        ld a,(hl)                   ;get next character
        inc hl
        or a                        ;is it zero?
        jr nz,skipTitle             ;no, keep checking
        ex de,hl
findLoop:
        push hl                     ;save file name pointer
findLoop1:
        ld a,(de)                   ;get file name character
        cp (hl)                     ;compare with file name
        inc de
        inc hl
        jr nz,noMatch               ;no match, update C_FILENO
        or a                        ;is it zero? If still here must have a match
        jr nz,findLoop1             ;yes, check next character
        pop hl                      ;fix stack
        ret                         ;yes, file found, return
noMatch:
        ;no match, update C_FILENO
        ld hl,C_FILENO              ;get file number
        inc (hl)                    ;increment file number
        ;get to next file name
findLoop2:
        ld a,(de)                   ;get next character
        inc de
        or a                        ;is it zero?
        jr nz,findLoop2             ;no, keep checking
        pop hl                      ;restore file name pointer
        inc de                      ;skip address
        inc de                      ;
        djnz findLoop               ;decrement file count
        ;if we get here, file not found;
        jp FATerror6                ;no files in menu

;Read Sector on file
;Will read a sector of 512 bytes from a file
;IE: Sector 0 = 0-511 bytes
;    Sector 1 = 512-1023 bytes
;    Sector 2 = 1024-1535 bytes etc
;Requires the openFile to be called first (and once only)
;Input: HLDE = block in bytes on file to retreive 3,2,1 and 0
;Output: Stores sector in DISK_BUFF 0600H to 07FFH (512 bytes)
readSector:
        push hl         ;save HL    ;make BC=HL
        push de
        ld a,(C_FILENO)             ;get index
        ld hl,RFC_LIST
        ld c,a
        ld b,0                      ;clear B
        ;calculate index to RFC_LIST
        or a                       ;clear carry
        rl c                        ;x2
        rl c                        ;x4
        rl c                        ;x8
        jr nc,$+3
        inc b                       ;add 1 if carry set
        add hl,bc                  ;add to RFC_LIST
        ;HL is now pointing to RFC_LIST
        ;save data to ROOT_CLUS
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld (ROOT_CLUS),de
        ld e,(hl)
        inc hl
        ld d,(hl)
        ld (ROOT_CLUS+2),de
        ;work out which cluster the sector is in.
        pop de
        pop bc                      ;hl
        ;check file size BCDE
        inc hl
        inc hl
        inc hl
        inc hl                      ;get to MSB
        ld a,(hl)
        cp b                        ;if carry too large
        jp c,FATerror12             ;too large
        jr nz,sizeCheckDone         ;file size okay
        dec hl
        ld a,(hl)
        cp c                        ;if carry too large
        jp c,FATerror12             ;too large
        jr nz,sizeCheckDone         ;file size okay
        dec hl
        ld a,(hl)
        cp d                        ;if carry too large
        jp c,FATerror12             ;too large
        jr nz,sizeCheckDone         ;file size okay
        dec hl
        ld a,(hl)
        cp e                        ;if carry too large
        jp c,FATerror12             ;too large
sizeCheckDone:        
        ;set HL with 512 * CLUS_SEC
        ld a,(CLUS_SEC)             ;get cluster sector
        rlca                        ;x2
        ld h,a                      ;save x2 in H
        ld l,0
        ld a,0FFH                   ;cluster counter
        push af                     ;save cluster number
clusterLoop:
        pop af                      ;restore cluster number
        inc a                       ;increment cluster number
        push af                     ;save cluster number
        call BCDEminusHL            ;subtract until overflow
        jr nc,clusterLoop           ;loop until all clusters are done
        pop af                      ;restore cluster number
        add hl,de                   ;store byte remainder in HL
        ;find the correct cluster in the FAT
        push hl
fatLoop:
        or a                        ;is it zero?
        jr z,fatLoopExit
        push af
        call FATgetFAT              ;get next cluster from FAT
        pop af                      ;restore AF
        dec a   
        jr fatLoop               ;loop until all clusters are done
fatLoopExit:
        ld de,(ROOT_CLUS)           ;get root cluster
        ld bc,(ROOT_CLUS+2)
        ;read sector of cluster
        call FATgetSector           ;get sector of cluster
        ld de,(FCB_NSEC)
        ld bc,(FCB_NSEC+2)
        pop hl                      ;restore HL byte remainder.  index for lba
        ; hl is now in bytes, need to divide by 512 to get lba index
        ; do a shift right of h and make l=h and h=0
        srl h
        ld l,h
        ld h,0                     ;make h=0
        add hl,de
        ex de,hl                ;HL now has lba
        jr nc,$+3               ;skip update of BC by one if not carry
        inc bc
        ;Now have lba in BCDE
        ld (FCB_NSEC),de        ;save lba in FCB_NSEC for saving if needed
        ld (FCB_NSEC+2),bc
        ld hl,DISK_BUFF             ;source
        call IDEreadSector          ;read sector of file
        jp c,FATerror5              ;error reading sector
        ret

;Write a sector to file
;Will save a sector of 512 bytes to a file
;Input: Requires readSector to be called first.  This will load the sector for
;       editing.  Then when done, call this routine to save the sector back to the disk
;       Data to save is in DISK_BUFF 0600H to 07FFH (512 bytes)
writeSector:
        ld de,(FCB_NSEC)
        ld bc,(FCB_NSEC+2)
        ld hl,DISK_BUFF             ;source
        call IDEwriteSector         ;write sector of file
        jp c,FATerror5              ;error writing sector
        ret

;Compare two strings at HL and DE
;returns z if they are equal
;returns c if DE points to the smaller string
;returns nc if DE is the bigger (or equal) string.
cpstr:
        ld a,(de)                   ;string 1
        cp (hl)                     ;string 2
        inc de
        inc hl
        ret nz                      ;not equal, return
        ld a,(de)
        or a                        ;end of string?
        jr nz,cpstr                 ;no check next character
        ret

;Save all RAM to disk.  Requires a 64kb file called "MYDATA.TEC" to be present on the disk.
;RAM from 0000H to BFFFH is saved to the file, plus the expansion RAM from 8000H to BFFFH.
saveRam:
        ld hl,RAM_FILE
        call openFile               ;open the file
        ;clear LCD
        ld hl,SAVING_TEXT
        call setupLCD
        ld b,80h                    ;sectors to save, 60h normal sectors + 20h expansion RAM sectors
        ld hl,0000h                 ;byte address to save
        ;read file into ram
        ld de,0000h                 ;start at sector 0
saveRAMLoop:
        push de
        push bc
        push hl
        ld b,0C9H
        call commandToLCD           ;update LCD
        call HLtoLCD                ;write address to LCD
        ex de,hl
        ld b,09DH
        call commandToLCD           ;update LCD
        call HLtoLCD                ;sector address to LCD
        ex de,hl
        call sectorToBytes          ;Convert sector number to byte address
        ;load sector (512 bytes) to ram 0600h-07FFh
        call readSector
        ;save ram to disk
        pop hl
        ld de,0600h                 ;destination address in memory
        ld bc,512                   ;sector size
        ldir                        ;copy ram to disk buffer
        ;write the sector back to disk
        push hl                     ;save current address
        call writeSector
        pop hl
        pop bc
        pop de
        inc de                      ;increment sector number
        ld a,b
        cp 21h                      ;check if we are up to the expansion RAM sectors
        jr nz,skipExp               ;if no, skip
        call setExpandFlag
        ld hl,8000h                 ;reset address to expansion RAM  
skipExp:   
        djnz saveRAMLoop            ;decrement counter and loop if not zero
        ;unset expansion RAM flag
        ld a,00h
        jp setExpand                ;unset expand flag

;Load disk file to RAM.  Requires a 64kb file called "MYDATA.TEC" to be present on the disk.
;RAM from 0000H to BFFFH is loaded from the file, plus the expansion RAM from 8000H to BFFFH.
loadRAM:
        ;load file from disk to ram
        ld hl,RAM_FILE
        call openFile
        ;clear LCD
        ld hl,LOADING_TEXT
        call setupLCD
        ;read file into ram
        ld b,80h                    ;sectors to load, 60h normal sectors + 20h expansion RAM sectors 
        ld de,0000h                 ;start at sector 0
loadLoop:
        push de
        push bc
        ld b,09DH
        call commandToLCD           ;update LCD
        ld h,d
        ld l,e
        call HLtoLCD                ;write address to LCD
        call sectorToBytes          ;Convert sector number to byte address
        push de
        ;load sector (512 bytes) to ram 0600h-07FFh
        call readSector
        ;copy disk ram to memory
        pop de
        pop bc
        push bc
        ld a,b
        cp 21h                      ;if sectors 60h-7Fh load to expansion RAM
        jr nc,skipExp2
        ld hl,0C000h                ;Do a subtraction with and addition and wrap around!
        add hl,de
        ex de,hl
skipExp2:
        ld b,0C9H
        call commandToLCD           ;update LCD
        ld h,d
        ld l,e
        call HLtoLCD                ;write sector to LCD
        ld bc,512                   ;sector size in bytes
        ld hl,0600h                 ;source address in memory
        ldir                        ;fill in the RAM
        ;increment sector number
        pop bc
        pop de
        inc de                      ;increment sector number
        ld a,b
        cp 21h                      ;check if we are up to the expansion RAM sectors
        call z,setExpandFlag
        djnz loadLoop               ;decrement counter and loop if not zero
        ;unset expansion RAM flag
        ld a,00h
        jp setExpand                ;unset expansion RAM flag

; Set Expand flag with LCD update
setExpandFlag:
        ld a,04h                    ;expand flag
        call setExpand
        push bc
        ld b,0DDH
        call commandToLCD           ;update LCD
        pop bc
        ld a,"Y"
        jp charToLCD                ;write "Y" to LCD

;Set up LCD
;Input: HL = first line of LCD
setupLCD:
        ld b,01H                    ;clear LCD instruction
        call commandToLCD           ;update LCD
        call stringToLCD            ;write text
        ld b,0C0H                   ;set cursor to row 2
        call commandToLCD           ;update LCD
        ld hl,GENERAL_TEXT  
        call stringToLCD            ;write text
        ld b,94H                    ;set cursor to row 3
        call commandToLCD           ;update LCD
        call stringToLCD            ;write text
        ld b,0D4H                   ;set cursor to row 4
        call commandToLCD           ;update LCD
        jp stringToLCD              ;write text

; Convert a sector number to actual byte address.  This routine multiplies the sector number by 512
; and returns the result in HLDE.  The result is the byte address of the start of the sector in memory.
; Input: DE = Sector number (0-based)
; Output: HLDE = Byte address of the start of the sector in memory
sectorToBytes:
        ;DE x 512
        or a                        ;Clear carry
        rl e
        rl d                        ;x2
        ld a,0
        ld h,a                      ;Add carry to H if necessary
        adc a,h                     ;Multiply by 256
        ld h,a                      ;H = carry
        ld l,d                      ;L = D
        ld d,e                      ;D = E
        ld e,0                      ;E = 0
        ret

;Check if SD card is present
;This routine checks if the SD card is present by calling CMD0. 
;Input: None
;Output: Zero set if SD card is present
checkSDCardPresent:
        push bc
        ld c,10        ; Number of retries for SD card detection
sdInit1:
        call spiInit    ; set SD interface to idle state

        ld b,80        ; toggle clk 80 times
        ld a,C_SERIDLE ; set CS and MOSI high
sdReset:
        out (SDIO),a
        set 1,a        ; set CLK
        out (SDIO),a
        nop
        res 1,a        ; clear CLK
        out (SDIO),a
        djnz sdReset
        ;Reset card to SPI mode
        ld hl,spiCMD0   ; Initialize the SD card
        call sendSPICommand ; should come back as 01 if card present
        cp 01h
        jr z,sdReset2    ; SD card detected
        dec c           ; card not detected, decrement retry count
        jr z,sdReset1   ; no more retries, exit
        jr sdInit1   ; and try again
sdReset1:
        or 1            ;reset zero flag
sdReset2:
        pop bc
        ret

; Send a command to the SD card
; Input: HL = Pointer to command buffer
; Output: A = Response byte
sendSPICommand:
        push bc          ;Save BC
        push de         ;Save DE
        ld b,6       ; Number of bytes to send
sendLoop1:
        ld c,(hl)     ; Load byte to send
        call spiWrite  ; Send byte
        inc hl         ; Increment HL to point to next byte
        djnz sendLoop1 ; Repeat for all bytes
        call readSPIByte ; Read response byte
        pop de         ; Restore DE
        pop bc         ; Restore BC
        ret

; Read a byte from the SD card
; Input: None
; Output: A = Read byte
readSPIByte:
        push bc
        push de
        ld b,32			; wait up to 32 tries, but should need 1-2
readLoop:
        call spiRead		; get value in A
        cp 0ffh
        jr nz,$+4
        djnz readLoop
        pop de
        pop bc
        ret

; Read a block from the SD card
; Input: HL = Buffer to read to (512 bytes)
; Note: Set up Read Command LBA prior to this call
readSPIBlock:
        ld bc,512
readBlockBusy:
        call spiRead
        cp 0FFH
        jr z,readBlockBusy
        cp 0FEH     ;start token
        jr nz,readBlockBusy ;ignore
readBlockLoop:
        call spiRead
        ld (hl),a
        inc hl
        dec bc
        ld a,b
        or c
        jr nz,readBlockLoop
        ;read CRC (two bytes)
        call spiRead
        call spiRead
        ret

; Write a block to the SD card
; Input: HL = Buffer to write from (512 bytes)
; Output: A = Result of write operation, 05H for success
; Note: Set up Write Command LBA prior to this call
writeSPIBlock:
        ld c,0FEH        ; send start block token
        call spiWrite
        ld de,512
writeBlockLoop:
        ld c,(hl)  ; Load byte to send
        call spiWrite  ; Send byte
        inc hl         ; Increment HL to point to next byte
        dec de
        ld a,d
        or e
        jr nz,writeBlockLoop ; Repeat for all bytes
        ;send dummy CRC (0xFF, 0xFF)
        ld c,0FFH
        call spiWrite  ; send dummy CRC byte 1
        call spiWrite  ; send dummy CRC byte 2
        ; Read the response token
        call readSPIByte  ; get the write response token
        ld c,a         ; save result into C
        ; Wait for the card to finish writing
waitDoneLoop:
        call spiRead   ; 00 = busy - wait for card to finish
        or a
        jr z,waitDoneLoop  ; wait until card is not busy
        ld a,c         ; restore result to A register
        and 1FH        ; return code 05 = success
        ret

; Initialize the SD card.  Call this routine to set up the SD card for use.
; Steps through the initialisation process for the SD card
; Calling CMD0, CMD8, CMD55, CMD41, CMD58, and CMD16
; Throws errors if any of the commands fail
initSD:
        ; Check if SD card is present
        call checkSDCardPresent
        jp nz,FATerror8 ; No SD card, error

        ;Check voltage compatibility (2.7-3.6V, check pattern 0xAA)
        ld hl,spiCMD8
        call sendSPICommand ;returns 5 responses
        cp 1            ;first response
        jr nz,sendCMD55
        ;get the next 4 responses
        ld b,4
cmd8loop:
        call readSPIByte
        djnz cmd8loop
sendCMD55:
        ;Initialize card (send CMD55 + CMD41 repeatedly)
        ld de,0C000H
cmd55delay:
        dec de
        ld a,d
        or e
        jr nz,cmd55delay
        ld hl,spiCMD55
        call sendSPICommand
        ld hl,spiACMD41
        call sendSPICommand
        or a
        jr nz,sendCMD55
        ;Read OCR to check addressing mode
        ld hl,spiCMD58
        call sendSPICommand
        or a
        jp nz,FATerror9  ;SD Failed OCR check
        ld b,4
        ld hl,DISK_BUFF
cmd58loop:
        call readSPIByte
        ld (hl),a
        inc hl
        djnz cmd58loop
        ld a,(DISK_BUFF)    ;bit 7 = valid, bit 6 = SDHC if 1, SDSC if 0
        and 0C0H            ;80h = SDSC, C0h = SDHC
        bit 7,a
        jp z,FATerror10     ;Invalid SD card
        cp 80H              ;check if SDSC
        ret nz
        ;SDSC card, set block size to 512 bytes
        ld hl,spiCMD16
        call sendSPICommand
        or a
        jp nz,FATerror11  ;SD Failed CMD16
        ret

; SD Card Interface:
; - Bit 0: MOSI (Master Out Slave In)
; - Bit 1: CLK (Clock)
; - Bit 2: CS (Chip Select)
; - Bit 7: MISO (Master In Slave Out)

;SPI Init Routine.
;Initialize the SPI interface for SD card communication
spiInit:
        push af         ;Save A
        ld a,C_SERIDLE
        out (SDIO),a    ;Set SDIO to idle state
        pop af          ;Restore A
        ret

;SPI Read Routine.
;Read a byte from the SD card
;Input: None
;Output: A = Read byte
spiRead:
        push bc        ;Save BC
        push de        ;Save DE
        ld b,8         ;8 bits to read
        ld e,0         ;Result
spiReadLoop:
        ld a,C_SERIDLE
        and C_SERCS    ;CS bit
        out (SDIO),a   ;Set CS
        nop            ;Wait for CS to settle
        set 1,a        ;Set CLK
        out (SDIO),a   ;Send clock pulse
        ld c,a         ;Backup A
        in a,(SDIO)    ;Read MISO
        rla            ;Shift left
        rl e           ;Shift result left
        ld a,c         ;Restore A
        and 0FDh       ;Clear CLK
        out (SDIO),a   ;Clear CLK
        djnz spiReadLoop ;Repeat for all bits
        ld a,C_SERIDLE ;Set Idle state, MOSI high, CLK low, CS high
        out (SDIO),a   ;Output to SD Card
        ld a,e         ;Get result
        pop de         ;Restore DE
        pop bc         ;Restore BC
        ret

;SPI Write Routine.
;Write a byte to the SD card
;Input: C = Byte to write
;Output: None
spiWrite:
        push af       ;Save A
        push bc       ;Save BC
        ld b,8        ;8 bits to write
spiWriteLoop:
        ld a,C_SERIDLE
        and C_SERCS   ;CS bit
        bit 7,c       ;Check if bit 7 is set
        jr nz,$+4
        res 0,a       ;Set data bit
        out (SDIO),a  ;Set CS and MOSI        
        or 02h        ;Set CLK
        out (SDIO),a  ;Send clock pulse
        nop           ;Wait for clock pulse
        and 0FDh      ;Clear CLK
        out (SDIO),a  ;Clear CLK
        rlc c         ;Shift left for next bit
        djnz spiWriteLoop ;Repeat for all bits
        ld a,C_SERIDLE  ;Set Idle state, MOSI high, CLK low, CS high
        out (SDIO),a    ;Output to SD Card
        pop bc       ;Restore BC
        pop af       ;Restore A
        ret

;Messages (Max 15 characters plus 1 space)
MSG_TIMEOUT:    .db "Disk Timeout ",0
MSG_DRQST:      .db "Data Not Ready ",0
MSG_IOERR:      .db "IDE ERR IO Bad ",0
MSG_MBR:        .db "Can't read MBR ",0
MSG_MBR_BAD:    .db "MBR Illegal ",0
MSG_BPB:        .db "BPB Read Fail ",0
MSG_BPS:        .db "Byt/Sec != 512 ",0
MSG_ROOT:       .db "Root Dir Read ",0
MSG_FILE:       .db "File Not Found ",0
MSG_INTEL:      .db "Bad Checksum ",0
MSG_NOSDCARD:   .db "No SD Card ",0
MSG_OCR:        .db "OCR Read Fail ",0
MSG_SDINVALID:  .db "Invalid SDCard ",0
MSG_SDCMD16:    .db "CMD16 Failed ",0
MSG_TOOBIG:     .db "Addr. Too Big ",0

;SD Card Commands
spiCMD0:    .db 40h,0,0,0,0,95h     ; reset         R1
spiCMD8:    .db 48h,0,0,1,0AAh,87h  ; send_if_cond  R7
spiCMD16:   .db 50h,0,0,2,0,1h      ; Set sector size to 512 bytes   R1
spiCMD17:   .db 51h,0,0,0,0,1h      ; read single block R1
spiCMD24:   .db 58h,0,0,0,0,1h		; write single block	R1
spiCMD55:   .db 77h,0,0,0,0,1h      ; APP_CMD       R1
spiCMD58:   .db 7Ah,0,0,0,0,1h      ; READ_OCR      R3
spiACMD41:  .db 69h,40h,0,0,0,1h    ; send_OP_COND  R1

;Parameter Configuration for Load and Save addresses
LOAD_CFG:
                .db 1                           ;one parameters
                .db "ADDRES"                    ;7seg Text
                .db " File Load Address ",0     ;Parameter title
                .db "Load To Addr:",0        ;Text and Address
                .dw FCB_ADDR

;RAM File Constants
RAM_FILE:   .db "MYDATA.TEC",0
LOADING_TEXT: .db "-- Restore Backup --",0
SAVING_TEXT:  .db "--== RAM Backup ==--",0
GENERAL_TEXT:
              .db "Address: ",0
              .db "Sector:  ",0
              .db "Expand:  N",0

;Mathematical Routines
;---------------------

;32 bit times 8 bit routine.
;Input: DEBC = first operand
;       A = second operand
;Output: AHLIX = 40-bit result
;        carry reset
;        z set if top 8 bits are 0
BCDEtimeA:
        ld hl,0000H
        ld ix,0000H
        call $+3
        call $+3
        call $+3
        add ix,ix
        adc hl,hl
        adc a,a
        ret nc
        add ix,de
        adc hl,bc
        adc a,0
        ret

;32 bit divide by 8 bit routine.
;Input: DEHL = numerator
;       C = denominator
;Output: DEHL = quotient
;        A = remainder,
;Destroys: B
DEHLDivC:
        ld b,32
        xor a
divloop:
        add hl,hl
        rl e
        rl d
        rla
        cp c
        jr c,divlbl
        inc l
        sub c
divlbl:
        djnz divloop
        ret

; Subtract HL from BCDE (BCDE = BCDE - HL)
; BC = high 16 bits, DE = low 16 bits
; Result stored in BCDE
; Note: Assumes L is zero (L is not used in subtraction)
BCDEminusHL:
        ld a, d      ; Load high byte of DE into A
        sub h        ; Subtract high byte of HL with carry (borrow) from A
        ld d, a      ; Store result back in D
        ld a, c      ; Load high byte of BC into A
        sbc a, 0     ; Subtract any remaining borrow from C
        ld c, a      ; Store result back in C
        ld a, b      ; Load high-high byte of BC into A
        sbc a, 0     ; Subtract any remaining borrow from B
        ld b, a      ; Store result back in B
        ret