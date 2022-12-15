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

    #i need to check if the items are in ranges of: ((%register))
    #65-90: increase by 32 (upper to lower)
    #97-122: decrease by 32 (lower to upper)
    #after finished running over the string: return using the sizes (decrement)
##loop1:
##    cmpb    $65, (%rbx)     #if equals/above "A"
##    jae     tolower1
##    jmp     cont1            #lesser than "A" is a symbol only
##tolower1:
##    cmpb    $90, (%rbx)     #if equals/lower than "Z"
##    jbe     tolower
##    jmp     tohigher1       #means, higher than "Z", could be lower case!
##tolower:
##    addb    $32, (%rbx)
##    jmp     cont1
##tohigher1:
##    cmpb    $97, (%rbx)
##    jae     tohigher
##    jmp     cont1            #less than "a" are letters. inbetween "Z" and "a"
##tohigher:
##    cmpb    $122, (%rbx)
##    ja      cont1            #more than "z", which is last letter
##    subb    $32, (%rbx)
##cont1:
##    incq    (%rbx)
##    inc     %r11
##    cmpq    %r11, %rsi
##    jne     loop1
##
##    xor     %r11, %r11
##loop2:
##    cmpb    $65, (%r12)     #if equals/above "A"
##    jae     tolower2
##    jmp     cont2            #lesser than "A" is a symbol only
##tolower2:
##    cmpb    $90, (%r12)     #if equals/lower than "Z"
##    jbe     tolower22
##    jmp     tohigher1       #means, higher than "Z", could be lower case!
##tolower22:
##    addb     $32, (%r12)
##    jmp     cont2
##tohigher2:
##    cmpb    $97, (%r12)
##    jae     tohigher22
##    jmp     cont2            #less than "a" are letters. inbetween "Z" and "a"
##tohigher22:
##    cmpb    $122, (%rb12)
##    ja      cont2            #more than "z", which is last letter
##    subb    $32, (%r12)
##cont2:
##    incq    (%r12)
##    inc     %r11
##    cmpq    %r11, %rdx
##    jne     loop2

    sub     %r11, %rbx
    sub     %rsi, %rcx
    #finish
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
    .globl pstrijcmp
    .type pstrijcmp, @function
###########################################################
pstrijcmp:      #rbx=first string; r12=second string; r14=start index; r15=end index
    push    %rbp                               #new stack frame
    movq    %rsp, %rbp                         #move stack pointer to base
    xor     %rax, %rax
incloop:
    add     $1, %rbx
    add     $1, %r12
    decq    %r14
    decq    %r15
    cmpq    $0, %r14
    jnz     incloop                         #check if we reached str1[i] and str2[i]
    cmpb    $0, (%rbx)                      #if passed end of string 1, then substring 2 is bigger
    je      S2
    cmpb    $0, (%r12)                      #if passed end of string 2, then substring 1 is bigger
    je      S1
charcheck:                                  #get str1[k] to al; str2[k] to bl, and compare them
    add     $1, %rbx                          #get str1[k+1]
    add     $1, %r12                           #get str2[k+1]
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
    sub     %al, %bl
    movzbq  %bl, %rsi
    call    printf
    jmp     end37
S2:
    movq    $format37, %rdi
    sub     %al, %bl
    movzbq  %bl, %rsi
    call    printf
    jmp     end37
EQ:
    movq    $format37, %rdi
    movq    $0, %rsi
    call    printf
end37:
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
