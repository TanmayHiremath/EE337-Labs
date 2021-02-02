ORG 00H
MOV 70H,#FFH
MOV A,70H
MOV R1,#08H
MOV R2,#00H
loop:RLC A
JNC label2
INC R2
label2:DJNZ R1,loop
MOV 71H,R2
here:SJMP here
end