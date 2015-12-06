#include <stdio.h>
#include <math.h>

int main(){
	int i;
	double a,t;
	printf("      =             |radian       |degree\n");
	for(i=0; i<32; i++){
		a = pow(2,-1*i);
		t = tan(a);
		printf("2^%3d =%12.10f |%12.10f  |%12.10f\n",-1*i, a, t, t*180/M_PI);
	}

	return 0;
}
