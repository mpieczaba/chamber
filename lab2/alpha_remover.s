READ_NR = 0
WRITE_NR = 1
EXIT_NR = 60

STDIN = 0
STDOUT = 1

EXIT_CODE_STATUS = 0

.global _start

.bss
msg:
    .space 100

.text
_start:
    # Read
    mov $READ_NR, %rax
    mov $STDIN, %rdi
    mov $msg, %rsi
    mov $100, %rdx
    syscall

    lea (%rsi, %rax), %rbx # Load address at buffer end to rbx.

nextchar:
    cmp %rsi, %rbx # Check if current address is equal to the last address of the buffer.
    je exit

    cmpb $'A', (%rsi) # Check if character is less than ascii 'A'.
    jl write
    cmpb $'Z', (%rsi) # Check if character is less than ascii 'Z'.
    jl increment
    cmpb $'a', (%rsi) # Check if character is less than ascii 'a'.
    jl write
    cmpb $'z', (%rsi) # Check if character is less than ascii 'z'.
    jl increment

write:
    # Write character at rsi.
    mov $WRITE_NR, %rax
    mov $STDOUT, %rdi
    mov $1, %rdx
    syscall

increment:
    inc %rsi        # Increment buffer address.
    jmp nextchar    # Continue loop.

exit:
    mov $EXIT_NR, %rax
    mov $EXIT_CODE_STATUS, %rdi
    syscall
