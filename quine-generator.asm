lis $28
.word 4 ; increment stack pointer, 4 uses
lis $25
.word 0xffff000c ; print, essential
printword:
lis $22 ; newline, decimal chop, 2 uses
.word 10
lis $20
.word 48 ; 0-9 offset, 1 use

lis $1
.word 0x2e
sw $1, 0($25)

lis $11
.word 0x100 ; chop up .word stuff, 1 use
lis $1
.word 0x64726f77
wlp:sw $1, 0($25)
div $1, $11 
mflo $1
bne $1, $0, wlp

lw $6, 0($18)

add $3, $11, $0
save:
divu $6, $22
mfhi $7
mflo $6
add $7, $20, $7
sw $7, 0($11)
add $11, $11, $20 ; doesn't have to be 4.
bne $6, $0, save

print:
sub $11, $11, $20
lw $7, 0($11)
sw $7, 0($25)
bne $3, $11, print

sw $22, 0($25)
lw $14, 8($18)
add $18, $18, $28
bne $0, $14, printword
jr $31
end:
