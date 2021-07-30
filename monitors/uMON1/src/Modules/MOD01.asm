#IFNDEF MOD01_GLOBALS
#DEFINE MOD01_GLOBALS
; Begin global MOD assignments.
SERSTATUS	.EQU	$06
SERBUFFER	.EQU	$07
RXAVAILFLAG	.EQU	$01 ; Binary value of the bit associated with RX Data Available flag.
TXREADYFLAG	.EQU	$04 ; Binary value of the bit associated with TX Ready flag.
; End global MOD assignments.
;
#ENDIF
#IFNDEF MOD01_CODE
#DEFINE MOD01_CODE
; START MOD01 - Serial Send - V1.10 by Scott Gregory
MOD01:		IN		a,(SERBUFFER)
			LD		de,(GENERALA)
			LD		hl,(GENERALB)
			LD		a,(GENERALC)
			CP		$00
			JP		z,M01SEADDR
			DEC		hl
			JP		M01SET
;
M01SEADDR:	XOR		a ; Clear the Carry Flag.
			SBC		hl,de
M01SET:		EX		de,hl
			LD		a,SERBUFFER
			LD		c,a
			LD		b,e
M01MAIN:	IN		a,(SERSTATUS)
			AND		TXREADYFLAG
			JP		z,M01MAIN
			OUTI
			LD		a,d
			OR		e
			RET		z
			DEC		de
			LD		b,e
			JP		M01MAIN
; END MOD01
#ENDIF
