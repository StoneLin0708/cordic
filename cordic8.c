#include <stdio.h>
#include <math.h>
// 1/k = 0.6072529350088812561694;
int mul = 64;
int cordic_1k = 0x00000026; // 1/k * mul
int table_size = 8;
int table_arct[] = {
0x00000032,0x0000001d,0x0000000f,0x00000007,
0x00000003,0x00000001,0x00000000,0x00000000
};

void cordic(int theta,int *sin,int *cos,int step){
  int i,s;
	int x = cordic_1k, y = 0, t = theta;
	int nx = 0, ny = 0, nt = 0;
	int dx,dy,dt;
	if (step > table_size)
		step = table_size;
	for(i = 0; i<step; ++i)
	{
		s = t>=0 ? 0 : -1;
		nx = x - (((y>>i) ^ s) - s); //nx = x - z*( y>>i )
		y += ((x>>i) ^ s) - s; //ny = y - z*( x>>i )
		t -= (table_arct[i] ^ s) - s; //nt = t - z*arctan(pow(2,-1*i))
		x = nx;
	}
	*sin = y;
	*cos = x;
}

int main()
{
	int i;
	int s ,c;
	int n = 50;
	for(i = 0; i < n; i++){
		cordic( (int)((double)mul*M_PI*i/(2*n)), &s, &c, 8);
		printf( "%12.10f : %12.10f\n", (float)s/mul, (float)sin((float)M_PI*i/(2*n)) );
	}
}
