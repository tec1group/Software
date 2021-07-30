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
#IFNDEF MOD0F_CODE
#DEFINE MOD0F_CODE
; START MOD0F - Serial Echo - V1.10 by Scott Gregory
MOD0F:		LD		a,$FF
			LD		(KEYDATA),a ; Clear the key buffer.
MOD0FMAIN:	IN		a,(SERSTATUS)
			AND		RXAVAILFLAG
			CALL	nz,M0FRCV ; Have we received data?
			LD		a,(KEYDATA)
			CP		$FF ; Has a key been pressed?
			JP		z,MOD0FMAIN
			RET

M0FRCV:		IN		a,(SERBUFFER)
			LD		b,a
			CALL	M0FXMIT
			RET

M0FXMIT:	IN		a,(SERSTATUS)
			AND		TXREADYFLAG
			JP		z,M0FXMIT
			LD		a,b
			OUT		(SERBUFFER),a
			XOR		a
			RET
; END MOD0F
#ENDIF
