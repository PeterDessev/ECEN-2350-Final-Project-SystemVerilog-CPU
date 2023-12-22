
ldi $3 0b100        # Finish button
ldi $1 0b1000       # Store byte button
ldi $2 48           # Storage location
ldi $4 0b11111100   # Maximum byte location 
beq $6 $1 +3        # Store byte input received
beq $6 $3 +8        # Finish input received, execute
jmp -2              # Wait for input
st $2 $5            # Store byte
beq $6 $1 -1        # Wait for release of button
inc $2              # Increment to next address
beq $2 $4 +2        # Storage full, execute
jmp 4               # Repeat
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
jmp 11