#318778594 Gal Pearl
###########################################################
.data
.section 	.rodata
    .align 8
.L30:
    .quad .L31          #‫‪Case 31:       pstrlen‬‬
    .quad .L323         #‫‪Case 32 or 33: replaceChar‬‬
    .quad .L35          #Case 35:       ‫‪pstrijcpy‬‬
    .quad .L36          #Case 36: ‫‪      swapCase‬‬
    .quad .L37          #Case 37: ‫‪      pstrijcmp‬‬
    .quad .err          #Else:          error input
format_printf:  .string "%s\n"
format31:       .string "first pstring length: %d, second pstring length: %d\n"
format323:      .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format35:       .string "length: %d, string: %s\n"
format36:       .string "length: %d, string: %s\n"
format37:       .string "compare result: %d\n"
formaterr:      .string "Invalid option!\n"
###########################################################
.text
    .globl run_func
    .type run_func, @function
###########################################################
run_func:
    movq    $1, %rsi
    movq    $format_printf, %rdi
    call    printf
    cmpq    $31, %rsi
    jb      .err                #if less than 31, do error case
    je      .L31                #if 31, do pstrlen
    cmpq    $37, %rsi
    ja      .err                #if bigger then 37, do error case
    je      .L37                #if 37, do pstrijcmp‬‬
    cmpq    $32, %rsi
    je      .L323               #if 32, do replaceChar
    cmpq    $33, %rsi
    je      .L323               #if 33, do replaceChar
    cmpq    $34, %rsi
    je      .err                #if 34, do error case
    cmpq    $35, %rsi
    je      .L35                #if 35, do pstrijcpy
    cmpq    $36, %rsi
    je      .L36                #if 36, do swapCase
    ret                         #finish, return to run_main
.L31:   #case 31
    ret
.L323:  #case 32 or 33
    ret
.L35:   #case 35
    ret
.L36:   #case 36
    ret
.L37:   #case 37
    ret
.err:   #error case
    ret
