#include<stdio.h>

int main()
{

	int a = 0b11111111111111111111111111111111;
	int b = 0b01111111111111111111111111111111;
	int c = 0b01000000000000000000000000000000;
	int d = 1<<30;
	int e = 0b11111111111111111111111111111111;
	int f = 0b11111111111111111111111111111111;

	printf("a = %d\n",a);
	printf("b = %d\n",b);
	printf("c = %d\n",c);
	printf("d = %d\n",d);
	printf("e = %d\n",e);
	printf("f = %d\n",f);
	return 0;
}
