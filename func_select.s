#318778594 Gal Pearl
###########################################################
.data
.section 	.rodata
    .align 8
.L30:                                                   #Jump Table
    .quad .L31                                          #Case 31:       pstrlen
    .quad .L32                                          #Case 32:       replaceChar
    .quad .L33                                          #Case 33:       replaceChar
    .quad .L34                                          #Case 34:       moves to .err
    .quad .L35                                          #Case 35:       pstrijcpy
    .quad .L36                                          #Case 36:       swapCase
    .quad .L37                                          #Case 37:       pstrijcmp
    .quad .err                                          #Else:          error input
formaterr:              .string "invalid option!\n"     #error format
format_scanfstring:     .string "%s"                    #format for string
format_scanf:           .string "%d"                    #format for number
format323:              .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format36:               .string "length: %d, string: %s\n"
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
.L33:  #case 33: replaceChar#
    sub     $32, %rsp                       #allocating space for 2 strings
    movq    $format_scanfstring, %rdi       #format to rdi
    leaq    -16(%rbp), %rsi                 #first string to rsi
    xor     %rax, %rax
    call    scanf                           #reading input: the oldChar
    leaq    -16(%rbp), %r13                 #oldChar into r13
    movq    $format_scanfstring, %rdi       #load format into rdi
    leaq    -32(%rbp), %rsi                 #second string to rsi
    xor     %rax, %rax
    call    scanf                           #read input into rsi: the newChar
    leaq    -32(%rbp), %r9                  #newChar into r9
    call    replaceChar                     #replaceChar on string1
    leaq    (%rbx), %rcx                    #load str1 into rcx
    movq    %r12, %rbx
    call    replaceChar                     #replaceChar on string2
    movq    $format323, %rdi                #format into rdi
    movzbq  (%r13), %rsi                    #load oldChar into rsi
    movzbq  (%r9), %rdx                     #load newChar into rdx
    leaq    1(%r12), %r8                    #load str2 into r8
    call    printf
    jmp     endcall
.L34:   #error input, sends to .err#
    jmp     .err
.L35:   #case 35: pstrijcpy#
#TODO
    call    pstrijcpy
    jmp     endcall
.L36:                                       #case 36: swapCase#
    call    swapCase                        #calling swapCase on first string
    movq    $format36, %rdi                 #load format into first arg
    movzbq  -1(%rbx), %rsi                  #load size into first arg
    leaq    (%rbx), %rdx                    #load first string as arg to printf
    call    printf                          #call printf
    movq    %r12, %rbx                      #loading second string
    call    swapCase                        #calling swapCase on second string
    movq    $format36, %rdi                 #format to
    movzbq  -1(%rbx), %rsi                  #load size into first arg
    leaq    (%rbx), %rdx                    #load first string as arg to printf
    call    printf
    jmp     endcall                         #load format into first arg

.L37:                                       #case 37: pstrijcmp#
    sub     $32, %rsp                       #allocating space for scanf
    movq    $format_scanf, %rdi             #read and save start index at r8
    leaq    -16(%rbp), %rsi                 #pointing at free space in stack
    xor     %rax, %rax
    call    scanf
    movq    %rsi, %r14                      #saving start index in r14
    movq    $format_scanf, %rdi             #read and save end index at r9
    leaq    -32(%rbp), %rsi                 #pointing at free space in stack
    xor     %rax, %rax
    call    scanf
    movq    %rsi, %r15                      #saving end index in r15
    call    pstrijcmp                       #pstrijcmp
    jmp     endcall                         #end
.err:                                       #error case#
    xorq    %rsi, %rsi                      #refreshing register
    xorq    %rdi, %rdi                      #refreshing register for format
    subq    $16, %rsp                       #allocating space for printf
    movq    $formaterr, %rdi                #init format for error message printf
    call    printf
    jmp     endcall                         #end
endcall:
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
