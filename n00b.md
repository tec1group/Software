## Observations from a n00b
Hi there! Let me introduce myself: I'm a n00b to the TEC-1, coding in assemby and not so skilled in electronic designs. But I'm an enthusiast and I'd like to share my findings struggling with the TEC-1.
I use a TEC-1D, built it myself, ordered the PCB from Benn Grimmett (who gives me also technical and moral support!).
Some stuff I put here might be very obvious to you but wasn't for me: my apologies for that!
I also have built an 8x8 matrix board and the observations are starting from there! 
I will update this document and add listings to the repository! 

Best regards, Reinoud.

### 8x8 matrix board examples
#### Blinking led
On page 32 of Talking Electronics magazine edition 11 there is an example of a blinking led at 01,01.

Here is my listing: (I will upload the asm80 files too)
<pre><code>0800                          .ORG   $800   
0800   3E 01                  LD   A,01   
0802   D3 03                  OUT   (3),A   
0804   3E 01                  LD   A,01   
0806   D3 04                  OUT   (4),A   
0808   CD 00 0A               CALL   $A00   
080B   3E 00                  LD   A,00   
080D   D3 03                  OUT   (3),A   
080F   3E 00                  LD   A,00   
0811   D3 04                  OUT   (4),A   
0813   CD 00 0A               CALL   $A00   
0816   C3 00 08               JP   $800
</code></pre>
For my TEC-1 I have changed the delay routine because my TEC-1 has a 4MHz crystal clock. The value of 1791 (06FF) is way to small.
<pre><code>0A00                          .ORG   $A00   
0A00   11 FF FF               LD   DE,65535   
0A03   1B                     DEC   DE   
0A04   7B                     LD   A,E   
0A05   B2                     OR   D   
0A06   C2 03 0A               JP   NZ,$A03   
0A09   C9                     RET      
</code></pre>
Value 65535 can be changed to 32767 (7FFF, enter FF 7F) to double the speed.

Blink the whole screen, change:
<pre><code>0801   FF
0805   FF
</code></pre>
  
Blink the top/bottom screen, change:
<pre><code>0801   FF
0805   0F
080C   FF
0810   F0
</code></pre>

Blink the left/right screen, change:
<pre><code>0801   0F
0805   FF
080C   F0
0810   FF
</code></pre>

Blink overlap screen, change:
<pre><code>0801   FF
0805   1F
080C   FF
0810   F8
</code></pre>

Blink interlocking screen, change:
<pre><code>0801   FF
0805   AA
080C   FF
0810   55
</code></pre>

#### Running light across the screen
On page 32 and 33 of Talking Electronics magazine edition 11 there is an example of a running led.
The listing in the magazine did not work for me, so here is my listing, it runs in a different direction. The magazine shows a picture of a running led CCW (which didn't work on my TEC) my listing is a running led CW (or it should be at least):

<pre><code>0800                          .ORG   $800   
0800                             ;Left side
0800   3E 01                  LD   A,$01   
0802   D3 03                  OUT   (3),A   
0804   0E 08                  LD   C,$08   
0806   3E 01                  LD   A,$01   
0808   D3 04                  OUT   (4),A   
080A   47                     LD   B,A   
080B   CD 00 0A               CALL   $A00   
080E   78                     LD   A,B   
080F   CB 07                  RLC   A   
0811   0D                     DEC   C   
0812   C2 08 08               JP   NZ,$808   
0815                             ;Top side
0815   3E 80                  LD   A,$80   
0817   D3 04                  OUT   (4),A   
0819   0E 07                  LD   C,$07   
081B   3E 02                  LD   A,$02   
081D   D3 03                  OUT   (3),A   
081F   47                     LD   B,A   
0820   CD 00 0A               CALL   $A00   
0823   78                     LD   A,B   
0824   CB 07                  RLC   A   
0826   0D                     DEC   C   
0827   C2 1D 08               JP   NZ,$81D   
082A                             ;Right side
082A   3E 80                  LD   A,$80   
082C   D3 03                  OUT   (3),A   
082E   0E 07                  LD   C,$07   
0830   3E 40                  LD   A,$40   
0832   D3 04                  OUT   (4),A   
0834   47                     LD   B,A   
0835   CD 00 0A               CALL   $A00   
0838   78                     LD   A,B   
0839   CB 0F                  RRC   A   
083B   0D                     DEC   C   
083C   C2 32 08               JP   NZ,$832   
083F                             ;Bottom side
083F   3E 01                  LD   A,$01   
0841   D3 04                  OUT   (4),A   
0843   0E 07                  LD   C,$07   
0845   3E 40                  LD   A,$40   
0847   D3 03                  OUT   (3),A   
0849   47                     LD   B,A   
084A   CD 00 0A               CALL   $A00   
084D   78                     LD   A,B   
084E   CB 0F                  RRC   A   
0850   0D                     DEC   C   
0851   C2 47 08               JP   NZ,$847   
0854   C3 00 08               JP   $800   
0857                             ;delay routine
0A00                          .ORG   $A00   
0A00   11 FF FF               LD   DE,65535   
0A03   1B                     DEC   DE   
0A04   7B                     LD   A,E   
0A05   B2                     OR   D   
0A06   C2 03 0A               JP   NZ,$A03   
0A09   C9                     RET      
</code></pre>

