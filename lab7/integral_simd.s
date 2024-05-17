.global integral_simd
.type integral_simd, @function

.data

n: .float 1000
a: .float 5
b: .float 20
eight: .float 8

.text

integral_simd:
    # Function preamble
    pushq %rbp
    movq %rsp, %rbp

    movss a(%rip), %xmm1 # a
    movss b(%rip), %xmm2 # b
    movss n(%rip), %xmm3 # n
    subss %xmm1, %xmm2 # b - a

    divss %xmm3, %xmm2 # (b - a) / n

    movss eight(%rip), %xmm5

    mov $1000, %ecx

    pxor %xmm0, %xmm0

sum_polygons:
    # sum += k * (x^2 -2x + 8)
    movaps %xmm1, %xmm3 # x
    mulss %xmm1, %xmm3 # x*x
    subss %xmm1, %xmm3 # x*x - x
    subss %xmm1, %xmm3 # x*x - x - x
    addss %xmm5, %xmm3 # x*x - x - x + 8
    mulss %xmm2, %xmm3 # (x*x - x - x + 8) * k
    addss %xmm3, %xmm0 # sum = (x*x - x - x + 8) * k + sum

    addss %xmm2, %xmm1 # x = x + k

    loop sum_polygons

exit:
    popq %rbp
    ret
