#IFNDEF MOD00_CODE
#DEFINE MOD00_CODE
; START MOD00 - Memory Test - V1.10 by Scott Gregory
MOD00:		CALL	M00SREG
			EXX
			CALL	M00SREG
M00SETMEM:	LD		(hl),b
			LD		a,d
			OR		e
			JP		z,M00DELAY
			INC		hl
			DEC		de
			JP		M00SETMEM
M00DELAY:	DEC		de
			ld		a,d
			OR		e
			JP		nz,M00DELAY
			EXX
			LD		ix,$0000
M00TSTMEM:	LD		a,(hl)
			CP		b
			JP		z,M00TSTCNT
			INC		ix
M00TSTCNT:	LD		a,d
			OR		e
			JP		z,M00END
			INC		hl
			DEC		de
			JP		M00TSTMEM
;
M00END:		LD		(GENERALD),ix
			RET
;
M00SREG:	OR		a ; Clear the Carry Flag.
			LD		de,(GENERALA)
			LD		hl,(GENERALB)
			LD		a,(GENERALC)
			LD		b,a
			SBC		hl,de
			EX		de,hl
			RET
; END MOD00
#ENDIF
