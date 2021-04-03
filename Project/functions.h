#include <at89c5131.h>
#include "lcd.h"	  //Header file with LCD interfacing functions
#include "serial.c" //C file with UART interfacing functions
#include <string.h>
#include <stdlib.h>
int consta[4] = {2000, 500, 200, 100};
// char *doubleDigitString(int x)
// {
// 	char str[80];
// 	if (x >= 10)
// 	{
// 		sprintf(str, "%d", x);
// 		return str;
// 	}
// 	else
// 	{
// 		sprintf(str, "0%d", x);
// 		return str;
// 	}
// }
// void numberNotes(char *x,int array[])
// {
// 	int n = atoi(x);
// 	int arr[4];
// 	int consta[4] = {2000, 500, 200, 100};
// 	int i;
// 	for (i = 0; i < 4; i++)
// 	{
// 		arr[i] = n / consta[i];
// 		n = n % consta[i];
// 	}

// }
void invalidInput()
{
	transmit_string("Invalid input\r\n");
	lcd_cmd(0x01);
	lcd_cmd(0xC0);
	lcd_write_string("Invalid input");
	msdelay(2000);
	lcd_cmd(0x01);
}
int numberNotes(char *x, int number[])
{
	int n = atoi(x);
	int arr[4];
	int i;
	for (i = 0; i < 4; i++)
	{
		arr[i] = n / consta[i];
		if (arr[i] > number[i])
		{
			n -= number[i] * consta[i];
			number[i] = 0;
		}
		// n = n % consta[i];
		else
		{
			n -= arr[i] * consta[i];
			number[i] -= arr[i];
		}
	}
	if (n == 0)
		return 1;
	else
		return 0;
}