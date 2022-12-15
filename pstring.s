#318778594 Gal Pearl
###########################################################
    .data
.section .rodata
format31:       .string "first pstring length: %d, second pstring length: %d\n"
format323:      .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format35:       .string "length: %d, string: %s\n"
format36:       .string "length: %d, string: %s\n"
format37:       .string "compare result: %d\n"
format_scanfstring:    .string "%c"    #format for oldchar and newchar
format_err:     .string "invalid input!\n"

.text
    .globl pstrlen
    .type pstrlen, @function
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
    .globl replaceChar
    .type replaceChar, @function
###########################################################
replaceChar:    #rbx=first string; r12=second string; r9=newChar; r8=oldChar;
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
    xor     %r14, %r14
    xor     %r15, %r15
    xor     %rax, %rax
    movb    (%rbx), %r14b                   #loading the size into r14b to return back
    movb    (%r12), %r15b                   #loading the size into r15b to return back

    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
    .globl pstrijcpy
    .type pstrijcpy, @function
###########################################################
pstrijcpy:
    push %rbp                               #new stack frame
    movq %rsp, %rbp                         #move stack pointer to base

    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
    .globl swapCase
    .type swapCase, @function
###########################################################
swapCase:   #r11 to be the incrementor. check it with the sizes to see if we're done the iteration
            #rbx first string, r12 second string
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
    #i need to check if the items are in ranges of: ((%register))
    #65-90: increase by 32 (upper to lower)
    #97-122: decrease by 32 (lower to upper)
    #after finished running over the string: return using the sizes (decrement)
    movzbq  (%rbx), %rcx                    #save first string size
    addq    $1, %rbx                        #get to string
loop1:
    cmpb    $0, (%rbx)                      #check if we went through the string
    je      cont1                           #reached end of string, move to string2
    cmpb    $90, (%rbx)                     #65:str[i]
    jb      toLower1                        #goto another check if higher case
    cmpb    $97, (%rbx)                     #97:str[i]
    jae     toHigher1                       #if str[i] is low case letter. if not low case, then not a letter.
    jmp     contLoop                        #if less than 65, do nothing and move on
toLower1:
    cmpb    $65, (%rbx)                     #90:str[i]
    jae     toLower                         #higher case to lower case
toLower:
    add    $32, (%rbx)                      #+32 gives the lower case letter, and move to next letter
    jmp     contLoop                        #continue
toHigher1:
    cmpb    $122, (%rbx)                    #122:str[i]
    jbe     toHigher                        #lower case to higher case
toHigher:
    sub    $32, (%rbx)                      #decrease 32 from value, to bring to higher case
contLoop:
    addq    $1, %rbx                        #get str[i+1]
    jmp     loop1                           #continue running the loop
cont1:
    sub     %rcx, %rbx                      #return the pointer to original spot
    movq    $format36, %rdi                 #load format
    movq    %rcx, %rsi                      #load the size to print
    leaq    (%rbx), %rdx                    #load the string to print
    call    printf
    xor     %rcx, %rcx                      #refreshing registers
    xor     %rax, %rax
    xor     %rdx, %rdx
    xor     %rdi, %rdi
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
    .globl pstrijcmp
    .type pstrijcmp, @function
###########################################################
pstrijcmp:      #rbx=first string; r12=second string; r14=start index; r15=end index
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
    xor     %rax, %rax
    cmpb    $0, %r14b                       #is start index negative value
    jbe     err37
    cmpb    %r15b, (%rbx)                   #is end index larger than string1 size
    jb     err37
    cmpb    %r15b, (%r12)                   #is end index larger than string2 size
    jb     err37

incloop:
    add     $1, %rbx                        #iterate on string1
    add     $1, %r12                        #iterate on string2
    decq    %r14
    decq    %r15
    cmpq    $0, %r14
    jnz     incloop                         #check if we reached str1[i] and str2[i]
    cmpb    $0, (%rbx)                      #if passed end of string 1, then substring 2 is bigger
    je      S2
    cmpb    $0, (%r12)                      #if passed end of string 2, then substring 1 is bigger
    je      S1
charcheck:                                  #get str1[k] to al; str2[k] to bl, and compare them
    add     $1, %rbx                        #get str1[k+1]
    add     $1, %r12                        #get str2[k+1]
    decq    %r15
    cmpq    $-1, %r15                       #check if we went over end index: means the substrings are equal
    je      EQ
    movb    (%rbx), %al
    movb    (%r12), %bl
    cmp     %al, %bl
    jl      S1
    jg      S2                              #string2 is greater
    jmp     charcheck
S1:
    movq    $format37, %rdi
    movq    $1, %rsi
    call    printf
    jmp     end37
S2:
    movq    $format37, %rdi
    movq    $-1, %rsi
    call    printf
    jmp     end37
EQ:
    movq    $format37, %rdi
    movq    $0, %rsi
    call    printf
err37:
    xor     %rsi, %rsi                      #print error input
    movq    $format_err, %rdi
    call    printf
    xor     %rdi, %rdi
    movq    $format37, %rdi                 #print return value -2
    movq    $-2, %rsi
    call    printf
end37:
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
