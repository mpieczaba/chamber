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

    add %rax, %rsi # Add length of the buffer to rsi.

write:
    # Write character at rsi.
    mov $WRITE_NR, %rax
    mov $STDOUT, %rdi
    mov $1, %rdx
    syscall

    dec %rsi # Decrement buffer address.

    cmp $msg, %rsi 
    jge write # Jump if current address is greater or equal to the original buffer address.

exit:
    mov $EXIT_NR, %rax
    mov $EXIT_CODE_STATUS, %rdi
    syscall
