
.globl rdtsc
.type rdtsc, @function

rdtsc:
    pushq %rbp             
    movq %rsp, %rbp
    pushq %rbx             
                        

    movb 8(%rbp), %al # Get the function parameter.

    cmpb $1, %al
    je true # Jump to true if the function parameter is equal to 1.
    

    movl $0, %eax           
    cpuid                  
                       
    rdtsc                  

    shlq $32, %rdx         
    orq %rax, %rdx

    jmp exit
     
true:
    rdtscp
    cpuid

    shlq $32, %rdx         
    orq %rax, %rdx

exit:
    popq %rbx            
    popq %rbp             
    ret
