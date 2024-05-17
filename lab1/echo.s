WRITE_NR = 1
EXIT_NR = 60

STDIN = 0
STDOUT = 1

EXIT_CODE_STATUS = 0

SPACE = 0x20
NULL = 0x00

.global _start

.text
_start:
    pop %rbx # Get the number of args from the stack.
    pop %rsi # Pop the program path from the stack.

print:
    mov $0, %rdx    # Set the length number to zero.
    dec %rbx        # Decrease the number of args. 
    cmp $0, %rbx    # Check if the number of args is zero
    je exit         # Jump to exit if the nummber of args is zero.

    pop %rsi # Get the buffer adress

strlen:
    mov (%rsi, %rdx), %al   # Get next character from the buffer.
    inc %rdx                # Increment length.
    cmp $NULL, %al          # Check if charater is NULL.
    jne strlen              # Jump if character not NULL.

    movb $SPACE, -1(%rsi, %rdx) # Add space character.

    # Write
    mov $WRITE_NR, %rax
    mov $STDOUT, %rdi
    syscall

    jmp print

exit:
    # Exit
    mov $EXIT_NR, %rax
    mov $EXIT_CODE_STATUS, %rdi
    syscall
