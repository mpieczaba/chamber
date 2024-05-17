EXIT_NR = 60
WRITE_NR = 1

STDOUT = 1

.global _start

.data
msg:
    .ascii "Hello, world!\n"
    len = . - msg

.text
_start:
    mov $WRITE_NR, %rax
    mov $STDOUT, %rdi
    mov $msg, %rsi
    mov $len, %rdx
    syscall

    mov $EXIT_NR, %rax
    mov $EXIT_CODE_STATUS, %rdi
    syscall
