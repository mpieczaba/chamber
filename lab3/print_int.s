WRITE_NR = 4
EXIT_NR = 1

STDOUT = 1

EXIT_CODE_STATUS = 0

.global _start

.data
number: 
    .int 0x700CF6B8 # 70 0C F6 B8

.bss
buffer:
    .space 8

.text
_start:
    mov $number, %eax
    mov $buffer, %ebx
    mov $8, %ecx # Hex digit down counter
    mov $0, %esi # Byte counter

next:
    mov (%eax, %esi), %dl   # Copy the first byte to dl.
    and $0x0F, %dl          # Logic and on dl with 0x0F - get the first hex digit.

    cmp $0x0A, %dl
    jl skip1    # Skip ajusting ascii code for 0xa-0xf digits.
    add $7, %dl # Add 'A' - '0' = 7.

skip1:
    add $'0', %dl # Add '0'.

    movb %dl, -1(%ebx, %ecx) # Move digit in ascii to the buffer.
    dec %ecx

    movb (%eax, %esi), %dl  # Copy the first byte to dl one more time.
    shr $4, %dl             # Bit shift right on dl 4 times - get the second hex digit.

    
    cmp $0x0A, %dl
    jl skip2    # Skip ajusting ascii code for 0xa-0xf digits.
    add $7, %dl # Add 'A' - '0' = 7.

skip2:
    add $'0', %dl               # Add '0'.
    movb %dl, -1(%ebx, %ecx)    # Move digit in ascii to the buffer.

    inc %esi

    loop next # Decrenent ecx, jump to next if ecx is not equal to 0.

write:
    mov $WRITE_NR, %eax
    mov $STDOUT, %ebx
    mov $buffer, %ecx
    mov $8, %edx
    int $0x80

exit:
    mov $EXIT_NR, %eax
    mov $EXIT_CODE_STATUS, %ebx
    int $0x80

