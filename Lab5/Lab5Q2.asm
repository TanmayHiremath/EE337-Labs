LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start
ORG 100H
start:acall lcd_init
START1:MOV A,P1
ANL A,#00000111B
MOV R2,A
MOV R3,A
MOV R2,03H
CLR P1.4
CLR P1.5
CLR P1.6
CLR P1.7
INC R2
ZERO:ACALL BASEDELAY
DJNZ R2,ZERO

MOV R2,03H
MOV A,#9
CLR C
SUBB A,R2
MOV R2,A

MOV A, R2
ADD A, R2
DA A
MOV R7, A

MOV A, R2
ORL A,#30H
MOV R5,A

SETB P1.4
SETB P1.5
SETB P1.6
SETB P1.7
MOV A,#2
ONE:ACALL BASEDELAY
INC A
INC A
DJNZ R2,ONE
LJMP LEDSTART
BASEDELAY:MOV R6,#8
DELAYLOOP: 
	  ACALL DELAY1
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
	  
	  
	  
	  LEDSTART:	  mov a,#82h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1
	  acall lcd_sendstring
	  acall delay
	  mov  A,R5   
	  acall lcd_senddata
	  mov A,#30H
	  acall lcd_senddata
	  acall delay

	  mov a,#0C0h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring
	  acall delay
	  mov   A,R7
	  SWAP A
	  ANL A, #0FH
	  ADD A, #30H
      acall lcd_senddata
	  MOV A,R7
	  ANL A, #0FH
	  ADD A, #30H
      acall lcd_senddata

	  MOV A, #30H
	  acall lcd_senddata
	  acall lcd_senddata
	  LJMP START1	 

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
loop2:	 mov r1,#55
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
DB   "Duty cycle: ", 00H
my_string2:
DB   "Pulse width:", 00H
end
