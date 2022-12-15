#318778594 Gal Pearl
###########################################################
.data
.section 	.rodata
    .align 8
.L30:           #Jump Table
    .quad .L31          #Case 31:       pstrlen
    .quad .L32          #Case 32:       replaceChar
    .quad .L33          #Case 33:       replaceChar
    .quad .L34          #Case 34:       moves to .err
    .quad .L35          #Case 35:       pstrijcpy
    .quad .L36          #Case 36:       swapCase
    .quad .L37          #Case 37:       pstrijcmp
    .quad .err          #Else:          error input
formaterr:      .string "Invalid option!\n" #error format
format_scanfstring:     .string "%s"        #format for string
format_scanf:      .string "%d"                    #format for number
###########################################################
.text
    .globl run_func
    .type pstrlen, @function
###########################################################
run_func:                                   #first full pstring in rbx, second full pstring is in r12
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #rsp to rbp
    cmpq    $37, %rsi                       #31:rsi
    ja      .err                            #If case > 37, then go to error
    cmpq    $31, %rsi                       #31:rsi
    jb      .err                            #if case < 31, then go to error
    subq    $31, %rsi                       #sub 31 from user input option
    cmpq    $7, %rsi                        #7:rsi
    jmp     *.L30(, %rsi, 8)                #goes to the corresponding case
.L31:   #case 31: pstrlen#
    call    pstrlen
    jmp     endcall
.L32:  #case 32 or 33: replaceChar. drops through to .L33#
    jmp     .L33
.L33:
    sub     $32, %rsp                       #allocating space for 2 strings
    movq    $format_scanfstring, %rdi       #format to rdi
    leaq    -16(%rbp), %rsi                 #first string to rsi
    xor     %rax, %rax
    call    scanf                           #reading input: the oldChar
    movq    %rsi, %r8                       #moving the input into r8
    movq    $format_scanfstring, %rdi       #load format into rdi
    xor     %rax, %rax
    leaq    -32(%rbp), %rsi                 #second string to rsi
    call    scanf                           #read input into rsi: the newChar
    movq    %rsi, %r9                       #moving the input into r9 - 4th arg for functions
                                            #passing rcx which is for int
    call    replaceChar
    jmp     endcall
.L34:   #error input, sends to .err#
    jmp     .err
.L35:   #case 35: pstrijcpy#
    call    pstrijcpy
    jmp     endcall
.L36:   #case 36: swapCase#
    call    swapCase
    jmp     endcall
.L37:   #case 37: pstrijcmp#
    sub     $32, %rsp
    movq    $format_scanf, %rdi             #read and save start index at r8
    leaq    -16(%rbp), %rsi
    xor     %rax, %rax
    call    scanf
    movq    %rsi, %r14
    movq    $format_scanf, %rdi             #read and save end index at r9
    leaq    -32(%rbp), %rsi
    xor     %rax, %rax
    call    scanf
    movq    %rsi, %r15
    call    pstrijcmp
    jmp     endcall
.err:   #error case#
    xorq    %rsi, %rsi
    xorq    %rdi, %rdi
    subq    $16, %rsp
    movq    $formaterr, %rdi                #init format for error message printf
    call    printf
    jmp     endcall
endcall:
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
