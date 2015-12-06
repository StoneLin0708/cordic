#include <stdio.h>
#include <math.h>
#define _1k 0.6072529350088812561694

void help()
{
		printf("bit of header?\n");
}
int main(int argc,char* argv[])
{
		int bit = 32;
		int mul,size;
		int i;
		if(argc!=2){
				help();
				return 1;
		}

		bit = atoi(argv[1]);
		size = bit;
		mul = 1 << (bit -2);

		printf("mul =\n%d\n0x%08x\n",mul,mul);
		printf("k =\n%d\n0x%08x\n", (int)(mul*_1k), (int)(mul*_1k) );
		printf("arctan = \n");

		for(i=0;i<size;i++){
			printf("0x%08x,\n", (int)(atan(pow(2,-1*i))*mul) );
		}

		return 0;
}


