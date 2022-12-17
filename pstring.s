#318778594 Gal Pearl
###########################################################
    .data
.section .rodata
format31:               .string "first pstring length: %d, second pstring length: %d\n"
format35:               .string "length: %d, string: %s\n"
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
#TODO: move to next byte with incq <%reg> or decq. change the value with accessing <(%reg)>
#TODO: work on the byte with suffix "b" on operations.
###########################################################
pstrijcpy:
    push %rbp                               #new stack frame
    movq %rsp, %rbp                         #move stack pointer to base

    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
# str[i] in ranges of: ((%reg))
# 65-90: increase by 32 (upper to lower)
# 97-122: decrease by 32 (lower to upper)
# anything else is a symbol and must not be changed
###########################################################
swapCase:
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
    movzbq  (%rbx), %r13                    #save size
    incq    %rbx                            #get to str[0]

loopSC:                                     #swapCase
    cmpb    $64, (%rbx)                     #if is symbol with ascii value of 64 or less (64:str[i])
    jbe     cont1                           #then do nothing and continue
    cmpb    $90, (%rbx)                     #90:str[i] -> is a high case letter ?
    jbe     toLower                         #if higher case letter, then convert to lower case
    cmpb    $123, (%rbx)                    #if is symbol with ascii value of 123 or higher (123:str[i])
    jae     cont1                           #then do nothing and continue
    cmpb    $97, (%rbx)                     #97:str[i] -> is a low case letter ?
    jae     toHigher                        #if lower case letter, then convert to higher case
    jmp     cont1                           #otherwise, is a symbol
toHigher:
    subb    $32, (%rbx)                     #convert to higher case
    jmp     cont1                           #continue
toLower:
    addb    $32, (%rbx)                     #convert to lower case
cont1:
    incq    %rbx                            #get str[i+1]
    cmpb    $0, (%rbx)                      #check if endofstring
    jne     loopSC                          #if not endofstring, continue iteration
    subq    %r13, %rbx                      #restore to beginning of string
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