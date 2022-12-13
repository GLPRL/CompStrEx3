#318778594 Gal Pearl
###########################################################
.data
.section 	.rodata
    .align 8
.L30:           #Jump Table
    .quad .L31          #Case 31:       pstrlen
    .quad .L32          #Case 32:       replaceChar, flow through to L33
    .quad .L33          #Case 33:       replaceChar
    .quad .L34          #Case 34:       moves to .err
    .quad .L35          #Case 35:       pstrijcpy
    .quad .L36          #Case 36:       swapCase
    .quad .L37          #Case 37:       pstrijcmp
    .quad .err          #Else:          error input
#Formats for different cases
    format31:       .string "first pstring length: %d, second pstring length: %d\n"
    format323:      .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
    format35:       .string "length: %d, string: %s\n"
    format36:       .string "length: %d, string: %s\n"
    format37:       .string "compare result: %d\n"
    formaterr:      .string "Invalid option!\n"
###########################################################
.text
    .globl run_func
    .type pstrlen, @function
###########################################################
run_func:
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
    jmp     endcall
.L34:   #error input, sends to .err#
    jmp     .err
.L35:   #case 35: pstrijcpy#
    jmp     endcall
.L36:   #case 36: swapCase#
    jmp     endcall
.L37:   #case 37: pstrijcmp#
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
