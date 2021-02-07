org 0000h
ljmp start
org 100h
start:
mov r0,#8
mov a,#0D6H
mov b,#96H
mul AB
rep:
rlc a
jnc next
clr c
next:
djnz r0,rep
jz insert
sjmp here
insert:
add a,#0ACH

here:
sjmp here
end
