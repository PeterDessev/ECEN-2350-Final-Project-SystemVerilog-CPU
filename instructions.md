| Instruction Name | Description                                                                                     | Example      | Bit Map                                              |
| ---------------- | ----------------------------------------------------------------------------------------------- | ------------ | ---------------------------------------------------- |
|                  |                                                                                                 |              | \|31 -- 24\|23 -- 16\|15 -- 8\|7 -- 0\| |
| add              | Adds $1 and $2, storing the output in $3                                                        | add $3 $1 $2 | \|00000000\|storeAddr\|source1Addr\|source2addr\|    |
| sub              | Subtracts from $1 $2 ($1 - $2), storing the output in $3                                        | sub $3 $1 $2 | \|00000001\|storeAddr\|minuendAddr\|subtrahendAddr\| |
| inc              | Incrememnts $1 by 1                                                                             | inc $1       | \|00000010\|Addr\|                                   |
| dec              | Decremenets $1 by 1                                                                             | dec $1       | \|00000011\|Addr\|                                   |
| and              | Performs a bitwise and between $1 and $2, storing the output in $3                              | and $3 $1 $2 | \|00000100\|storeAddr\|sorce1Addr\|source2addr\|     |
| or               | Performs a bitwise or between $1 and $2, storing the output in $3                               | or $3 $1 $2  | \|00000101\|storeAddr\|sorce1Addr\|source2addr\|     |
| not              | Performs a bitwise not on $1                                                                    | not $1       | \|00000110\|Addr\|                                   |
| xor              | Performs a bitwise xor on $1 and $2, storing the output in $3                                   | xor $3 $1 $2 | \|00000111\|storeAddr\|sorce1Addr\|source2addr\|     |
| shl              | Shifts $1 left by 1                                                                             | shl $1       | \|00000110\|Addr\|                                   |
| shr              | Shifts $1 right by 1                                                                            | shr $1       | \|00000110\|Addr\|                                   |
| st               | Stores the contents of $2 in memory at address $1                                               | st $1 $2     | \|00000111\|memAddr\|dataAddr\|                      |
| ld               | Loads the data from memory address $1 into $2                                                   | ld $1 $2     | \|00001000\|memAddr\|destAddr\|                      |
| jmp              | jumps to memory address stored in $1 multiplying by 2 as needed to align the address on 32 bits | jmp $1       | \|00001001\|jumpLocAddr\|                            |
| beq              | jumps to $1 if $2 and $3 are equal                                                              | beq $1 $2 $3 | \|00001010\|jumpLocAddr\|sorce1Addr\|source2addr\|   |


# Arithmatic
- add
- sub
- inc
- dec
- and
- or
- not
- xor
- shl
- shr

# Register control
- mov

# Memory control
- st
- ld

# Program flow
- jmp
- beq