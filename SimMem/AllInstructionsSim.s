ldi $1 1
ldi $2 2
ldi $3 3
add $4 $4 $2
sub $4 $4 $1
or #4 $2 $4
beq $4 $3 3
xor $4 $2 $4
and $4 $4 $1
ldi $1 120
st $1 $4
ld $1 $2
inc $2
dec $2
dec $2
dec $2
not $2
shl $1
shr $1
jmp 23
ldi $1 0
ldi $2 0
sti $1 255
ldi $1 0
ldi $2 0
add $9 $0 $5
beq $1 $2 25