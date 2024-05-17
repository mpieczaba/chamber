.global integral_fpu
.type integral_fpu, @function

# f(x) = x^2 - 2x + 8

.data

n: .float 1000
a: .float 5
b: .float 20
k: .float 0
x: .float 0
two: .float 2
eight: .float 8
sum: .float 0

.text

integral_fpu:
    # Function preamble
    pushq %rbp
    movq %rsp, %rbp

    # k = (b - a) / n
    fld b
    fsub a
    fdiv n
    fstp k

    # x = a
    fld a
    fstp x

    mov $1000, %rcx

sum_polygons:
    # sum += k * (x^2 -2x + 8)
    fld x       # x
    fmul x      # x*x
    fsub x      # x*x - x
    fsub x      # x*x - x - x
    fadd eight  # x*x - x - x + 8
    fmul k      # (x*x - x - x + 8) * k
    fadd sum    # (x*x - x - x + 8) * k + sum
    fstp sum    # sum = (x*x - x - x + 8) * k + sum
   
    # x += k
    fld x       # x
    fadd k      # x + k
    fstp x      # x = x + k

    loop sum_polygons
   
exit:
    # Return sum.
    fld sum
    
    popq %rbp
    ret
