| Name | Description                                                        | Example       | Bit Map                                                                  | impld |
| ---- | ------------------------------------------------------------------ | ------------- | ------------------------------------------------------------------------ | ----- |
| bit  | Not an instruction, shows bit boundaries in the table              | N/A           | \|31 -- 24\|23 -- 20\|19 -- 16\|15 -- 12\|11 --  8\|7  --  5\|4  --  0\| |       |
|      |                                                                    |               | \|        \|        \|        \|        \|        \|        \|        \| |       |
| add  | Adds $1 and $2, storing the output in $3                           | add $3 $1 $2  | \|00000000\|   $1   \|   $2   \|   $3   \|  0000  \|  0000  \|  0000  \| | x     |
| sub  | Subtracts from $1 $2 ($1 - $2), storing the output in $3           | sub $3 $1 $2  | \|00000001\|   $1   \|   $2   \|   $3   \|  0000  \|  0000  \|  0000  \| | x     |
| and  | Performs a bitwise and between $1 and $2, storing the output in $3 | and $3 $1 $2  | \|00000010\|   $1   \|   $2   \|   $3   \|  0000  \|  0000  \|  0000  \| | x     |
| or   | Performs a bitwise or between $1 and $2, storing the output in $3  | or $3 $1 $2   | \|00000011\|   $1   \|   $2   \|   $3   \|  0000  \|  0000  \|  0000  \| | x     |
| xor  | Performs a bitwise xor on $1 and $2, storing the output in $3      | xor $3 $1 $2  | \|00000100\|   $1   \|   $2   \|   $3   \|  0000  \|  0000  \|  0000  \| | x     |
|      |                                                                    |               | \|        \|        \|        \|        \|        \|        \|        \| |       |
| beq  | jumps to Imm* if $1 and $2 are equal                               | beq $2 $3 Imm | \|00100000\|   $1   \|   $2   \|  0000  \|  0000  \|  ImmH  \|  ImmL  \| | x     |
|      |                                                                    |               | \|        \|        \|        \|        \|        \|        \|        \| |       |
| st   | Stores the contents of $2 in memory at address $1                  | st $1 $2      | \|01000000\|   $1   \|   $2   \|  0000  \|  0000  \|  0000  \|  0000  \| | x     |
| ld   | Loads the data from memory address $1 into $2                      | ld $1 $2      | \|01000001\|   $1   \|   $2   \|  0000  \|  0000  \|  0000  \|  0000  \| | x     |
|      |                                                                    |               | \|        \|        \|        \|        \|        \|        \|        \| |       |
| inc  | Incrememnts $1 by 1                                                | inc $1        | \|01100001\|  0000  \|   $1   \|  0000  \|  0000  \|  0000  \|  0000  \| | x     |
| dec  | Decremenets $1 by 1                                                | dec $1        | \|01100010\|  0000  \|   $1   \|  0000  \|  0000  \|  0000  \|  0000  \| | x     |
| not  | Performs a bitwise not on $1                                       | not $1        | \|01100011\|  0000  \|   $1   \|  0000  \|  0000  \|  0000  \|  0000  \| | x     |
| shl  | Shifts $1 left by 1                                                | shl $1        | \|01100100\|  0000  \|   $1   \|  0000  \|  0000  \|  0000  \|  0000  \| | x     |
| shr  | Shifts $1 right by 1                                               | shr $1        | \|01100101\|  0000  \|   $1   \|  0000  \|  0000  \|  0000  \|  0000  \| | x     |
|      |                                                                    |               | \|        \|        \|        \|        \|        \|        \|        \| |       |
| jmp  | jumps to memory address Imm*                                       | jmp Imm       | \|10000000\|  0000  \|  0000  \|  0000  \|  0000  \|  ImmH  \|  ImmL  \| | x     |
|      |                                                                    |               | \|        \|        \|        \|        \|        \|        \|        \| |       |
| sti  | Stores the contents of $1 into memory at Imm                       | sti $1 Imm    | \|10100000\|  0000  \|   $1   \|  0000  \|  0000  \|  ImmH  \|  ImmL  \| | x     |
| ldi  | Loads the contents of memory at Imm into $1                        | ldi $1 Imm    | \|10100001\|  0000  \|   $1   \|  0000  \|  0000  \|  ImmH  \|  ImmL  \| | x     |
|      |                                                                    |               |                                                                          |       |

This most significant 3 bits of an instruction have the following meanings:
| bits | meaning                                      |
| ---- | -------------------------------------------- |
| 000  | Tripple argument arithmetic operation        |
| 001  | Double argument instruction-memory operation |
| 010  | Double argument memory operation             |
| 011  | Single argument arithmetic operation         |
| 100  | Single argument instruction-memory operation |
| 101  | Single argument memory operation             |
| 110  | Reserved                                     |
| 111  | Reserved                                     |
<!-- Register file input A is connected to bits 23:20, B to 19:16, and C to {1: 19:16, 0: 15:12} -->
> \*Imm in this case will be aligned to instruction space throlugh multiplication by 2, on 4 byte boundaries, unlike store and load commands, which are aligned on 1 byte boundaries.

<!-- \|31 -- 24\|23 --- 16\|15 --  8\|7  --  0\| -->

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