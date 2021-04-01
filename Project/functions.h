#include <stdlib.h>

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
void numberNotes(char *x,int array[])
{
	int n = atoi(x);
	int arr[4];
	int consta[4] = {2000, 500, 200, 100};
	int i;
	for (i = 0; i < 4; i++)
	{
		arr[i] = n / consta[i];
		n = n % consta[i];
	}

}
