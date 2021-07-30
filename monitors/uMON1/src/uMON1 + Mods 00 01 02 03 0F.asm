; ######################################
; #                                    #
; #         uMON1 Version 1.10         #
; #  --------------------------------  #
; #   Special Key Sequences            #
; #  --------------------------------  #
; #   Shift-+ - Insert byte.           #
; #   Shift-- - Delete byte.           #
; #                                    #
; #  --------------------------------  #
; #   Included Modules                 #
; #  --------------------------------  #
; #                None                #
; #  --------------------------------  #
; #                                    #
; #  by Scott Gregory                  #
; #  13/06/2021                        #
; #                                    #
; #  Last update                       #
; #  30/07/2021                        #
; ######################################
;
STACKTOP	.EQU	$08C0 ; Stack position.
ROMBASE		.EQU	$0000 ; Start of ROM.
ROMTOP		.EQU	$07FF ; End of ROM.
RAMBASE		.EQU	$0900 ; Start of user RAM.
RAMTOP		.EQU	$FFFF ; End of user RAM.
CATHDLY		.EQU	$40 ; Digit display delay.
KEYPORT		.EQU	$00 ; Keypad port.
CATHPORT	.EQU	$01 ; Display catchode port.
SEGPORT		.EQU	$02 ; Display segment port.
;
ADDRESS		.EQU	$08C0 ; 2 Bytes - Current monitor address.
SCRATCH		.EQU	$08C2 ; 3 Bytes - Display scratch space.
MODE		.EQU	$08C5 ; 1 Byte - Mode flags.
KEYDATA		.EQU	$08C6 ; 1 Byte - Current Keyscan data.
BEEPLENGTH	.EQU	$08C7 ; 2 Bytes - Next beep length store.
BEEPFREQ	.EQU	$08C9 ; 1 Byte - Next beep frequency store.
RNDSEEDA	.EQU	$08CA ; 2 Bytes - Random Seed A.
RNDSEEDB	.EQU	$08CC ; 2 Bytes - Random Seed B.
RANDOM		.EQU	$08CE ; 2 Byte - Generated random number.
GENERALA	.EQU	$08D0 ; 2 Bytes - General use Address / Data address A.
GENERALB	.EQU	$08D2 ; 2 Bytes - General use Address / Data address B.
GENERALC	.EQU	$08D4 ; 2 Bytes - General use Address / Data address C.
GENERALD	.EQU	$08D6 ; 2 Bytes - General use Address / Data address D.
SHIFTGO		.EQU	$08D8 ; 2 Bytes - Shift-GO destination address.
;
; Begin included modules.
; #DEFINE INCLUDE_MODXX
#DEFINE INCLUDE_MOD00
#DEFINE INCLUDE_MOD01
#DEFINE INCLUDE_MOD02
#DEFINE INCLUDE_MOD03
#DEFINE INCLUDE_MOD0F
; End included modules.
;
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; Nothing is really configurable below this point
; unless you know what you are doing.
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
			.FILL	(ROMTOP - ROMBASE) + 1, $00
			.ORG	$0000
RESET_00:	DI
			JP		SETUP
;
			.ORG	$0008
RESET_08:	DI
			JP		SETUP
;
			.ORG	$0010
RESET_10:	DI
			JP		SETUP
;
			.ORG	$0018
RESET_18:	DI
			JP		SETUP
;
			.ORG	$0020
RESET_20:	DI
			JP		SETUP
;
			.ORG	$0028
RESET_28:	DI
			JP		SETUP
;
			.ORG	$0030
RESET_30:	DI
			JP		SETUP
;
			.ORG	$0038
RESET_38:	DI
			JP		SETUP
;
			.ORG	$0040
VERSION:	.DB	"uMON V1.10 by Scott Gregory"
;
			.ORG	$0066
NMISERVICE:	PUSH	af ; Keyboard service routine.
			IN		a,(KEYPORT)
			AND		$3F	; We're only interested in the first 6 bits.
			XOR		$20	; Flip bit 5 because bit 5 is low when the Shift key is pressed.
			LD		(KEYDATA),a
			POP		af
			RETN
;
			.ORG	$0080
DISPLAY:	XOR		a ; Display update routine.
			OUT		(CATHPORT),a ; Blank the display.
			OUT		(SEGPORT),a
			LD		c,$20 ; Set the last digit.
			LD		hl,(ADDRESS)
			LD		a,(hl)
			EX		de,hl
			LD		hl,SCRATCH
			LD		(hl),a ; Add the data from the current address to the scratchpad.
			INC		hl
			LD		(hl),e ; Add the current address LSB to the scratchpad.
			INC		hl
			LD		(hl),d ; Add the current address MSB to the scratchpad.
			LD		de,HEX2SEG
			LD		a,(MODE)
			AND		$10
			LD		b,a
			CALL	DGTPAIR ; Decode and display digits 5 and 4.
			DEC		hl
			CALL	DGTPAIR ; Decode and display digits 3 and 2.
			DEC		hl
			LD		a,(MODE)
			AND		$10
			XOR		$10
			LD		b,a
			CALL	DGTPAIR ; Decode and display digits 1 and 0.
			RET
;
DGTPAIR:	XOR		a
			RLD
			PUSH	hl
			CALL	DECNSHOW
			POP		hl
			XOR		a
			RLD
			PUSH	hl
			CALL	DECNSHOW
			POP		hl
			RET
;
DECNSHOW:	LD		h,$00
			LD		l,a
			ADD		hl,de
			LD		a,(hl)
			OR		b
			PUSH	bc
			LD		b,a
			CALL	UPDATE
			POP		bc
			LD		a,c
			RRA
			LD		c,a
			RET			
;
UPDATE:		LD		a,b
			OUT		(SEGPORT),a
			LD		a,c
			OUT		(CATHPORT),a
			LD		b,CATHDLY
HOLD:		DJNZ	HOLD
			XOR		a
			OUT		(CATHPORT),a
			RET
;
KEYBOARD:	PUSH	hl ; Key decoder routine.
			PUSH	af
			LD		hl,$0030
			LD		(BEEPLENGTH),hl
			LD		hl,BEEPFREQ
			LD		(hl),$30
			LD		a,(KEYDATA)
			CP		$FF
			JP		z,KEYDONE
			CALL	BEEP
			BIT		5,a ; Test for a shifted key.
			JP		z,TESTFUNC ; If no shift, do this jump.
			XOR		$20 ; Remove the shift bit.
			LD		de,SHIFTTBL ; Load the shifted key table.
			JP		JUMP
;
TESTFUNC:	BIT		4,a ; Test for a function key press (+, -, GO, AD)
			JP		nz,SETFUNC ; If it is a function key, do this jump.
;
KEYS0TOF:	LD		b,a
			LD		a,(MODE)
			CP		$10
			JP		z,ADDRENTRY ; Jump on first address mode entry.
			CP		$11
			JP		z,NXTADNTRY ; Jump on subsequent address mode entries.
			CP		$01
			JP		nz,NXTDATTST ; Jump on all but second data nibble entry to a location.
			INC		a ; Do this on the second data nibble entry to a location.
			LD		(MODE),a
			JP		NXTDATNTR
;
NXTDATTST:	CP		$02
			JP		nz,FSTDATNTR ; Jump if this is the first data nibble entry to a location.
			LD		hl,(ADDRESS) ; Do this on the third data nibble entry to a location.
			INC		hl
			LD		(ADDRESS),hl
			LD		a,$00
FSTDATNTR:	INC		a ; Do this on the first data nibble entry to a location.
			LD		(MODE),a
			LD		hl,(ADDRESS)
			LD		(hl),$00
NXTDATNTR:	LD		hl,(ADDRESS)
			LD		a,b
			RLD
			JP		KEYDONE
;
ADDRENTRY:	INC		a ; do this on the first address nibble entry.
			LD		(MODE),a
			LD		hl,$0000
			LD		(ADDRESS),hl
NXTADNTRY:	LD		a,b ; Do this on first and subsequent address nibble entries.
			LD		hl,ADDRESS
			RLD
			LD		hl,(ADDRESS)
			SLA		h
			SLA		h
			SLA		h
			SLA		h
			LD		b,a
			XOR		a
			OR		h
			OR		b
			LD		h,a
			LD		(ADDRESS),hl
			JP		KEYDONE
;
SETFUNC:	XOR		$10 ; Remove the function key bit.
			LD		de,FUNCTBL ; Load the function table.
JUMP:		LD		hl,KEYDONE ; Push where we go when we have finished onto the stack.
			PUSH	hl
			LD		h,$00 ; Adjust the pointer in the selected table based on the key pressed.
			LD		l,a
			ADD		hl,hl
			EX		de,hl
			ADD		hl,de
			LD		e,(hl)
			INC		hl
			LD		d,(hl)
			PUSH	de ; Push the new calculated function jump address onto the stack.
			RET ; Jump to the calculated function.
;
KEYPL:		LD		hl,(ADDRESS) ; Incrament the current monitor address.
			INC		hl
			LD		(ADDRESS),hl
			XOR		a ; Clear the Address / Data modes.
			LD		(MODE),a
			RET
;
KEYMN:		LD		hl,(ADDRESS) ; Decrement the current monitor address.
			DEC		hl
			LD		(ADDRESS),hl
			XOR		a ; Clear the Address / Data modes.
			LD		(MODE),a
			RET
;
KEYGO:		PUSH	hl
			PUSH	af
			LD		hl,RETURN ; Start executing from the current monitor address.
			push	hl
			LD		hl,(ADDRESS)
			JP		(hl)
RETURN:		POP		af
			POP		hl
			RET
;
KEYAD:		LD		a,(MODE)
			XOR		$10 ; Invert the address mode flag.
			LD		(MODE),a
			JP		CLRNBFLGS
;
SHFTPL:		LD		hl,RAMTOP ; Insert a byte at the current monitor address.
			LD		de,(ADDRESS)
			SBC		hl,de
			LD		b,h
			LD		c,l
			LD		hl,RAMTOP
			LD		d,h
			LD		e,l
			DEC		hl
			LDDR
			LD		h,d
			LD		l,e
			LD		(hl),$00
			JP		CLRNBFLGS
;
SHFTMN:		LD		hl,RAMTOP ; Delete a byte from the current monitor address.
			LD		de,(ADDRESS)
			SBC		hl,de
			LD		b,h
			LD		c,l
			LD		hl,(ADDRESS)
			LD		d,h
			LD		e,l
			INC		hl
			LDIR
			LD		h,d
			LD		l,e
			LD		(hl),$00
CLRNBFLGS:	LD		hl,MODE ; Clear the nibble mode flags preserving the rest.
			RES		0,(hl)
			RES		1,(hl)
			RET
;
SHFTGO:		PUSH	hl
			PUSH	af
			LD		hl,RETURN ; Start executing from the current monitor address.
			push	hl
			LD		hl,(SHIFTGO)
			JP		(hl)
;
SHFTAD:		RET
;
KEYDONE:	LD		hl,KEYDATA ; Done with the key decoder.
			LD		(hl),$FF
			POP		af
			POP		hl
			RET
;
FUNCTBL:	.dw		KEYPL, KEYMN, KEYGO, KEYAD
;
SHIFTTBL:
#IFDEF INCLUDE_MOD00 ; SHIFT-0
			.dw		MOD00
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD01 ; SHIFT-1
			.dw		MOD01
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD02 ; SHIFT-2
			.dw		MOD02
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD03 ; SHIFT-3
			.dw		MOD03
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD04 ; SHIFT-4
			.dw		MOD04
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD05 ; SHIFT-5
			.dw		MOD05
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD06 ; SHIFT-6
			.dw		MOD06
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD07 ; SHIFT-7
			.dw		MOD07
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD08 ; SHIFT-8
			.dw		MOD08
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD09 ; SHIFT-9
			.dw		MOD09
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD0A ; SHIFT-A
			.dw		MOD0A
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD0B ; SHIFT-B
			.dw		MOD0B
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD0C ; SHIFT-C
			.dw		MOD0C
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD0D ; SHIFT-D
			.dw		MOD0D
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD0E ; SHIFT-E
			.dw		MOD0E
#ELSE
			.dw		NOMOD
#ENDIF
#IFDEF INCLUDE_MOD0F ; SHIFT-F
			.dw		MOD0F
#ELSE
			.dw		NOMOD
#ENDIF
;
			.dw		SHFTPL, SHFTMN, SHFTGO, SHFTAD
;
BEEP:		PUSH	hl
			PUSH	af
			LD		hl,BEEPFREQ
			LD		c,(hl)
			LD		hl,(BEEPLENGTH)
			XOR		a
			LD		d,a
BEEPL01:	LD		b,c
			LD		a,d
			OUT		(CATHPORT),a
BEEPL02:	DJNZ	BEEPL02
			XOR		$80
			DEC		hl
			LD		d,a
			LD		a,h
			OR		l
			JP		nz,BEEPL01
			XOR		a
			OUT		(CATHPORT),a
			POP		af
			POP		hl
			RET
;
STARTBEEP:	PUSH	hl
			PUSH	af
			LD		hl,$007F
			LD		(BEEPLENGTH),hl
			LD		hl,BEEPFREQ
			LD		(hl),$35
			CALL	BEEP
			LD		(hl),$30
			CALL	BEEP
			LD		(hl),$25
			CALL	BEEP
			LD		(hl),$20
			CALL	BEEP
			POP		af
			POP		hl
			RET
;
RAND:		CALL	RND
			LD		c,a
			CALL	UPDATESEED
			CALL	RND
			LD		b,a
			LD		(RANDOM),bc
			RET
;
RND:		LD		hl,(RNDSEEDA)
			LD		de,(RNDSEEDB)
			LD		(RNDSEEDB),hl
			LD		a,l
			ADD		a,a
			ADD		a,a
			ADD		a,a
			XOR		l
			LD		l,a
			LD		a,d
			ADD		a,a
			XOR		d
			LD		h,a
			RRA
			XOR		h
			XOR		l
			LD		h,e
			LD		l,a
			LD		(RNDSEEDA),hl
			RET
;
UPDATESEED:	LD		bc,(RNDSEEDA)
			LD		de,(RNDSEEDB)
			INC		bc
			DEC		de
			LD		a,c
			XOR		d
			LD		c,a
			LD		a,b
			XOR		e
			LD		b,a
			LD		a,e
			XOR		c
			LD		e,a
			LD		a,d
			XOR		b
			LD		d,a
			LD		(RNDSEEDA),bc
			LD		(RNDSEEDB),de
			RET
;
SETUP:		LD		sp,STACKTOP ; Post reset/power up setup.
			LD		hl,RAMBASE
			LD		(ADDRESS),hl
			XOR		a
			LD		(MODE),a
			LD		a,$FF
			LD		(KEYDATA),a
			LD		hl,$DF21
			LD		(RNDSEEDA),hl
			LD		hl,$637B
			LD		(RNDSEEDB),hl
			LD		hl,RAND
			LD		(SHIFTGO),hl
			CALL	STARTBEEP;
MAIN:		CALL	UPDATESEED
			CALL	DISPLAY
			CALL	UPDATESEED
			CALL	KEYBOARD
			JP		MAIN
;
HEX2SEG:	.DB		$EB,$28,$CD,$AD,$2E,$A7,$E7,$29 ; HEX Byte to LED Segment conversion.
			.DB		$EF,$2F,$6F,$E6,$C3,$EC,$C7,$47
;
NOMOD:		RET ; What to do when a mod isn't installed.
;
; BEGIN MODULES.
#IFDEF INCLUDE_MOD00
#INCLUDE "Modules/MOD00.asm"
#ENDIF
#IFDEF INCLUDE_MOD01
#INCLUDE "Modules/MOD01.asm"
#ENDIF
#IFDEF INCLUDE_MOD02
#INCLUDE "Modules/MOD02.asm"
#ENDIF
#IFDEF INCLUDE_MOD03
#INCLUDE "Modules/MOD03.asm"
#ENDIF
#IFDEF INCLUDE_MOD04
#INCLUDE "Modules/MOD04.asm"
#ENDIF
#IFDEF INCLUDE_MOD05
#INCLUDE "Modules/MOD05.asm"
#ENDIF
#IFDEF INCLUDE_MOD06
#INCLUDE "Modules/MOD06.asm"
#ENDIF
#IFDEF INCLUDE_MOD07
#INCLUDE "Modules/MOD07.asm"
#ENDIF
#IFDEF INCLUDE_MOD08
#INCLUDE "Modules/MOD08.asm"
#ENDIF
#IFDEF INCLUDE_MOD09
#INCLUDE "Modules/MOD09.asm"
#ENDIF
#IFDEF INCLUDE_MOD0A
#INCLUDE "Modules/MOD0A.asm"
#ENDIF
#IFDEF INCLUDE_MOD0B
#INCLUDE "Modules/MOD0B.asm"
#ENDIF
#IFDEF INCLUDE_MOD0C
#INCLUDE "Modules/MOD0C.asm"
#ENDIF
#IFDEF INCLUDE_MOD0D
#INCLUDE "Modules/MOD0D.asm"
#ENDIF
#IFDEF INCLUDE_MOD0E
#INCLUDE "Modules/MOD0E.asm"
#ENDIF
#IFDEF INCLUDE_MOD0F
#INCLUDE "Modules/MOD0F.asm"
#ENDIF
; END MODULES.
;
			.END
