#318778594 Gal Pearl
###########################################################
    .data
.section .rodata
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
#args: string. returns size of string.
###########################################################
pstrlen:
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #rsp to rbp
    movb    (%rbx), %al                    #loading the size into sil to print
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
#args: string, oldChar, newChar. replaces every oldChar in str[i] in newChar
###########################################################
replaceChar:
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
#args: string1, string2, startIndex, endIndex.
#replaces string1[startIndex:endIndex] with string2[startIndex:endIndex]
###########################################################
pstrijcpy:          #r14 start index, r15 end index
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
    cmpq    %r14, %r15                      #startIndex:endIndex
    jl      err35
    cmpb    %r15b, (%rbx)                   #endIndex:str1.size
    jbe     err35                           #endIndex>=str1.size -> error
    cmpb    %r15b, (%r12)                   #endIndex:str2.size
    jbe     err35                           #endIndex>=str2.size -> error
    movzbq  (%rbx), %r10                    #save size of str1
    decq    %r10                            #for correct return to str1[0]
    incq    %rbx                            #get to str1[1]
    incq    %r12                            #get to str2[1]
incrcpy:
    cmpq    $0, %r14                        #check if we reached startIndex
    je      switchStr                       #if yes then go to switch characters
    incq    %rbx                            #get str1[i+1]
    incq    %r12                            #get str2[i+1]
    decq    %r15                            #endIndex--
    decq    %r14                            #startIndex--
    jmp     incrcpy
switchStr:
    movb    (%r12), %al                     #takes str2[i]
    movb    %al, (%rbx)                     #str1[i]=str2[i]
    cmpq    $0, %r15                        #reached endIndex (?)
    je      end35                           #end iterations
    incq    %r12                            #str1[i+1]
    incq    %rbx                            #str2[i+1]
    decq    %r15                            #j--
    jmp     switchStr                       #continue looping
err35:
    movq    $format_err, %rdi               #load error format
    xor     %rsi, %rsi                      #no args to print
    call    printf                          #printf error
    movq    $-2, %rax                       #return -2 as error
end35:
    subq    %r10, %rbx                      #get back to str[0]
    incq    %r10                            #get to original size
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
###########################################################
#args: string. replaces any lower case character to higher case character,
#while ignoring symbols.
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
#args: string1, string2, startIndex, endIndex.
#lexicographic comparison between string1[startIndex:endIndex] and string2[startIndex:endIndex]
#return -2 if error indexes, 0 if string1=string2, 1 if string1>string2, -1 if string1<string2
###########################################################
pstrijcmp:
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
    cmpq    $0, %r14                        #r14:0
    cmpq    %r14, %r15                      #startIndex:endIndex
    jb      err37                           #endIndex < startIndex -> error
                                            #check indexes on sizes
    cmpb    %r15b, (%rbx)                   #endIndex:size of str1
    jb      err37                           #if endIndex>=str1 size then error
    cmpb    %r15b, (%r12)                   #endIndex:size of str2
    jb      err37                           #if endIndex>=str2 size then error
    incq    %rbx                            #get to str1[1]
    incq    %r12                            #get to str2[1]
iter:                                       #iterate until reached startIndex
    cmpq    $0, %r14                        #check if reached to startIndex
    je      compare                         #startIndex==0
    decq    %r14                            #i -= 1
    decq    %r15                            #j -= 1
    incq    %rbx                            #get str1[i+1]
    incq    %r12                            #get str2[i+1]
    jmp     iter
compare:
    movb    (%rbx), %al                     #str1[i] to al
    movb    (%r12), %dl                     #str2[i] to dl
    cmpb    %al, %dl                        #str1[i]:str2[i]
    jb      s1                              #str1[i] > str2[i]
    ja      s2                              #str1[i] < str2[i]
    incq    %rbx                            #str1[i+1]
    incq    %r12                            #str2[i+1]
    decq    %r15                            #j--
    cmpq    $0, %r15                        #j:0
    je      eq                              #done checking without having str1[i] >/< str2[i]
    jmp     compare                         #continue looping
s1:
    movq    $1, %rax                        #str1 is larger, return 1
    jmp     end37                           #end function
s2:
    movq    $-1, %rax                       #str2 is larger, return -1
    jmp     end37                           #end function
eq:
    movq    $0, %rax                        #equal in range i:j
    jmp     end37                           #end function
err37:
    movq    $format_err, %rdi               #load error message
    xor     %rsi, %rsi                      #no parameters
    call    printf                          #printf()
    movq    $-2, %rax                       #return -2 code
end37:
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    ret
