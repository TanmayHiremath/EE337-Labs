LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
LJMP START1
org 000BH
LJMP T0_INTR 
ORG 50H
	T0_INTR:INC R5
	RETI
ORG 100H
START1:
abc:SETB EA
SETB ET0
MOV C,P1.0
JNC START
LJMP abc
START:acall lcd_init
CLR P1.4
CLR P1.5
CLR P1.6
CLR P1.7
mov a,#80h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string3
	  acall lcd_sendstring
	  acall delay
	  mov a,#0C0h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string4
	  acall lcd_sendstring
	  acall delay
ACALL BASEDELAY
ACALL BASEDELAY
acall lcd_init
SETB P1.4
CLR C	  
ACALL REACTION
CLR P1.4	  
	  LEDSTART:	  mov a,#82h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1
	  acall lcd_sendstring
	  acall delay

	  mov a,#0C0h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring
	  MOV A,R5
	  SWAP A
	  ACALL RETURNHEX
      acall lcd_senddata
	  MOV A,R5
	  ACALL RETURNHEX
      acall lcd_senddata
	  MOV A,#20H
	  acall lcd_senddata
	  
      MOV A,TH0
	  SWAP A
	  ACALL RETURNHEX
      acall lcd_senddata
	  MOV A,TH0
	  ACALL RETURNHEX
      acall lcd_senddata
	  
	  MOV A,TL0
	  SWAP A
	  ACALL RETURNHEX
      acall lcd_senddata
	  MOV A,TL0
	  ACALL RETURNHEX
      acall lcd_senddata
	  ACALL BASEDELAY
	  ACALL BASEDELAY
	  ACALL BASEDELAY
	  ACALL BASEDELAY
	  ACALL BASEDELAY
	  acall lcd_init
	  LJMP START1
	  
;-------------------------------------------------------------------------------------
REACTION: ACALL DELAY2
	  JC NEXT3
      LJMP REACTION
      
DELAY2: MOV TMOD,#00000001B 
       MOV TH0,#00H
       MOV TL0,#00H 
       SETB TR0 
HERE2: JNB P1.0,HERE3
CLR TR0 
CLR TF0 
SETB C
RET
HERE3:JNB TF0,HERE2
      CLR TR0 
      CLR TF0 
      RET
	  NEXT3:RET  
RETURNHEX:	  
      ANL A, #0FH
	  MOV B,#10
	  DIV AB
	  XCH A,B
	  JNB B.0,LABEL2
	  ADD A,#31H
	  LABEL2:ADD A, #30H
      RET
BASEDELAY:MOV R6,#40
DELAYLOOP: ACALL DELAY1
      DJNZ R6,DELAYLOOP
      LJMP NEXT2
DELAY1: MOV TMOD,#00000001B 
       MOV TH0,#3CH
       MOV TL0,#0B0H 
       SETB TR0 
HERE1: JNB TF0,HERE1
      CLR TR0 
      CLR TF0 
      RET
	  NEXT2:RET
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#155
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
DB   "Reaction Time", 00H
my_string2:
DB   "Count is ", 00H
my_string3:
DB " Toggle SW1",00H
my_string4:
DB "if LED glows",00H
end
