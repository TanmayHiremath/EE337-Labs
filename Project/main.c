
#include "functions.h"
sbit LED = P1 ^ 7;
int number[4] = {20, 30, 10, 0};

//Main function
void main(void)
{

	char str1[10] = "";
	unsigned char ch = 0;
	//Initialize port P1 for output from P1.7-P1.4
	P1 = 0x0F;

	//Call initialization functions
	lcd_init();
	uart_init();

	//These strings will be printed in terminal software
	transmit_string("************************\r\n");
	while (1)
	{
		ch = receive_char();

		switch (ch)
		{
		case '\r':

			if (strlen(str1) == 0)
			{
				invalidInput();
			}
			else
			{

				if (numberNotes(str1, number))
					lcd_write_string("Collect Cash");
				else
					lcd_write_string("Try Again");
			}
			break;
		case '0':
			if (strlen(str1) == 0)
			{
				invalidInput();
			}
			else
			{
				lcd_write_char(ch);
				strncat(str1, &ch, 1);
				transmit_char(ch);
			}
			break;

		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			lcd_write_char(ch);
			strncat(str1, &ch, 1);
			transmit_char(ch);
			break;
		case 'd':
			lcd_cmd(0x01);
			lcd_cmd(0x80);
			if (strlen(str1) == 0)
			{
				lcd_cmd(0x01);
				lcd_cmd(0x80);
				lcd_write_char(ch);
			}
			else
			{
				invalidInput();
			}
			break;
		default:
			transmit_char(ch);
			break;
		}
		msdelay(100);
	}
}
