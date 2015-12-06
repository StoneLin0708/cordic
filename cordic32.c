#include <stdio.h>
#include <math.h>
// 1/k = 0.6072529350088812561694;
int mul = 1073741824;
int cordic_1k = 0x26DD3B6A; // 1/k * mul
float pi = 3.1415926535897932384626;
int table_size = 32;
int table_arct[] = {
0x3243f6a8,0x1dac6705,0x0fadbafc,0x07f56ea6,
0x03feab76,0x01ffd55b,0x00fffaaa,0x007fff55,
0x003fffea,0x001ffffd,0x000fffff,0x0007ffff,
0x0003ffff,0x0001ffff,0x0000ffff,0x00007fff,
0x00003fff,0x00001fff,0x00000fff,0x000007ff,
0x000003ff,0x000001ff,0x000000ff,0x0000007f,
0x0000003f,0x0000001f,0x0000000f,0x00000008,
0x00000004,0x00000002,0x00000001,0x00000000
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
	int s , c, t;
	int n = 50;
	for(i = 0; i < n; i++){
		t = (int)((double)mul*pi*i/(2*n));
		cordic( t, &s, &c, 32);
		printf( "t:%08x s:%08x c:%08x sin:%12.10f : %12.10f\n", t, s, c, (float)s/mul, (float)sin((float)pi*i/(2*n)) );
		//printf( "%02d : test_a = 32'h%08x;\n", i,t);
	}
}
