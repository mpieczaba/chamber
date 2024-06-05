.global integral_simd
.type integral_simd, @function

.data

n: .float 1000
a: .float 5
b: .float 20
eight: .float 8
four: .float 4
mul_factor: .float 0, 1, 2, 3

.text

integral_simd:
    # Function preamble
    pushq %rbp
    movq %rsp, %rbp

    movss a(%rip), %xmm1 # a
    movss b(%rip), %xmm2 # b
    movss n(%rip), %xmm3 # n

    subss %xmm1, %xmm2 # b - a
    divss %xmm3, %xmm2 # (b - a) / n = k
    
    vbroadcastss %xmm2, %xmm2

    movups mul_factor(%rip), %xmm6 # [0, 1, 2, 3]
    mulps %xmm2, %xmm6 # [0, k, 2k, 3k]

    movss eight(%rip), %xmm5 # [8, 0, 0, 0]
    vbroadcastss %xmm5, %xmm5 # [8, 8, 8, 8]

    mov $250, %ecx # ecx = n / 4 = 1000 / 4 = 250

    pxor %xmm0, %xmm0 # [0, 0, 0, 0]

    vbroadcastss %xmm1, %xmm1 # [x, x, x, x] 
    addps %xmm6, %xmm1 # [x, x+k, x+2k, x+3k]

    movups four(%rip), %xmm6 # [4, 0, 0, 0]
    vbroadcastss %xmm6, %xmm6 # [4, 4, 4, 4]
    mulps %xmm2, %xmm6 # [4k, 4k, 4k, 4k]
 
sum_polygons:
    movaps %xmm1, %xmm3

    mulps %xmm1, %xmm3 # x*x
    subps %xmm1, %xmm3 # x*x - x
    subps %xmm1, %xmm3 # x*x - x - x
    addps %xmm5, %xmm3 # x*x - x - x + 8

    dpps $0xff, %xmm2, %xmm3 # (x*x - x - x + 8) * k

    addss %xmm3, %xmm0 # sum = (x*x - x - x + 8) * k + sum
    
    addps %xmm6, %xmm1 # x = [x+4k, x+5k, x+6k, x+7k]
    
    loop sum_polygons

exit:
    popq %rbp
    ret
