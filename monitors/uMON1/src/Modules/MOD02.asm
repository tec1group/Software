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
#IFNDEF MOD02_CODE
#DEFINE MOD02_CODE
; START MOD02 - Serial Receive - V1.10 by Scott Gregory
MOD02:		IN		a,(SERBUFFER)
			LD		de,(GENERALA)
			LD		hl,(GENERALB)
			LD		a,(GENERALC)
			CP		$00
			JP		z,M02SEADDR
			DEC		hl
			JP		M02SET
;
M02SEADDR:	XOR		a ; Clear the Carry Flag.
			SBC		hl,de
M02SET:		EX		de,hl
			LD		a,SERBUFFER
			LD		c,a
			LD		b,e
M02MAIN:	IN		a,(SERSTATUS)
			AND		RXAVAILFLAG
			JP		z,M02MAIN
			INI
			LD		a,d
			OR		e
			RET		z
			DEC		de
			LD		b,e
			JP		M02MAIN
; END MOD02
#ENDIF
