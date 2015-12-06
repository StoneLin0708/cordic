#include <stdio.h>
#include <math.h>
#define PI 3.14159265

int main(){
	int i,mul,k=0xFFFFFFFFF;
	double t = 4,a;
	mul = 1<<30;
	printf("mul = 2^30 = %d = 0x%X\n",mul,mul);
	printf("      |radian       |radian*mul |degree\n");
	for(i=0; i<32; i++){
		a = pow(2,-1*i);
		t = atan(a);
		printf("2^%3d |%.10f |0x%08X |%12.10f\n",-1*i,t,(int)(t*1073741824),t*180/PI );
	}

	return 0;
}
