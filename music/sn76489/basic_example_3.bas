10  REM ** MISSILE SOUND **
20  N=7; REM PORT NUMBER OF SN76489
30  OUT N, 159; REM TURN OFF TONE 1
40  OUT N, 191; REM TURN OFF TONE 3
50  OUT N, 223; REM TURN OFF TONE 4
60  OUT N, 255; REM TURN OFF NOISE
70  OUT N, 231; REM SET NOISE TONE
80  OUT N, 240; REM SET NOISE VOLUME
90  FOR B=0 TO 15; REM LOOP FOR SECOND BYTE
100 FOR A=192 TO 207;REM LOOP FOR FIRST BYTE
110 OUT N, A; OUT N, B; REM OUTPUT TONES
120 NEXT A
130 OUT N, (240+B); REM DECREASE VOLUME
140 NEXT B
150 GOTO 30