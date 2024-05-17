#include <stdio.h>

unsigned long long rdtsc(char a);
double long integral_fpu();
float integral_simd();

int main(int argc, char const *argv[])
{
    unsigned long long start = 0;
    unsigned long long end = 0;

    double long res_fpu = 0.0;
    float res_simd = 0.0f;

    start = rdtsc(0);
    res_fpu = integral_fpu();
    end = rdtsc(1);

    printf("Result FPU: %Lf, delta time: %llu\n", res_fpu, end - start);

    start = rdtsc(0);
    res_simd = integral_simd();
    end = rdtsc(1);

    printf("Result SIMD: %f, delta time: %llu\n", res_simd, end - start);

    return 0;
}
