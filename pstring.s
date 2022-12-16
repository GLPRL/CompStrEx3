#318778594 Gal Pearl
###########################################################
    .data
.section .rodata
format31:               .string "first pstring length: %d, second pstring length: %d\n"
format35:               .string "length: %d, string: %s\n"
format36:               .string "length: %d, string: %s\n"
format37:               .string "compare result: %d\n"
format_err:             .string "invalid input!\n"
.text
    .globl swapCase
    .type swapCase, @function
    .globl replaceChar
    .type replaceChar, @function
    .globl pstrlen
    .type pstrlen, @function
    .globl pstrijcpy
    .type pstrijcpy, @function
    .globl pstrijcmp
    .type pstrijcmp, @function
###########################################################
pstrlen:
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #rsp to rbp
    xor     %rsi, %rsi                      #clearing rsi
    movb    (%rax), %sil                    #loading the size into sil to print
    movb    (%rbx), %dl                     #loading the size into dl to print
    movq    $format31, %rdi                 #loading format into rdi
    call    printf                          #calling printf procedue
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################

###########################################################
replaceChar:    #rbx=first string; r12=second string; r9=newChar; r13=oldChar;
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
    xor     %r14, %r14
    xor     %r15, %r15
    xor     %rax, %rax
    movzbq  (%rbx), %r14                    #loading the size of str1 into r14b to return back
    incq    %rbx                            #get to beginning of str1
loop1RC:
    movb    (%rbx), %dl                     #take str2[i]
    cmpb    %dl, (%r13)                     #str2[i]:oldChar
    jne     cont1RC                         #str2[i]!=oldchar then continue
                                            #if didnt jump, then they are equal
rep1RC:
    mov     (%r9), %dl
    mov     %dl, (%rbx)                     #impl: str2[i] = newChar
cont1RC:
    incq    %rbx                            #get str2[i+1]
    cmpb    $0, (%rbx)                      #0:str2[i]
    jne     loop1RC                         #if 0!=str2[i], then more characters are left to check
    sub     %r14, %rbx                      #get to the beginning of the string

    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
#TODO: We modify first string(in rbx) according to second string(r12). check I and J indexes if correct
###########################################################
pstrijcpy:
    push %rbp                               #new stack frame
    movq %rsp, %rbp                         #move stack pointer to base

    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
#TODO: First, check if bigger than 122 or smaller than 65: then do nothing
#TODO: later, check if: smaller/equal to 90: then continue check in highertolower
#TODO: else,  check if: bigger/equal to 97, then continue to lowertohigher
#TODO: otherwise, do nothing
#TODO: work on a single pstring, and load the first one into RSI after finished
###########################################################
swapCase:   #r11 to be the incrementor. check it with the sizes to see if we're done the iteration
            #rbx first string, r12 second string
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
    # i need to check if the items are in ranges of: ((%register))
    # 65-90: increase by 32 (upper to lower)
    # 97-122: decrease by 32 (lower to upper)
    # after finished running over the string: return using the sizes (decrement)
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
#TODO: first check I and J if they are in range: 1 to end. If not = error -2
#TODO: check if I isnt bigger than J. can be equal. if not = error -2
#TODO: if str1[i] > str2[i] -> 1
#TODO: if str1[i] < str2[i] -> -1
#TODO: if str1[i] == 0 && str2[i] == 0 -> 0
#TODO: if str1[i] == 0 && str2[i] != 0 -> -1
#TODO: if str1[i] != 0 && str2[i] == 0 -> 1
#TODO: str1[i] != 0 && str2[i] != 0 -> continue checking
#TODO: return 0/1/-1/-2 in RAX and go to end37
###########################################################
pstrijcmp:      #rbx=first string; r12=second string; r14=start index; r15=end index
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base

    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
