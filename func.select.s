#318778594 Gal Pearl
###########################################################
.data

###########################################################
	.section 	.rodata
    .align 8        ####EXTERN somewhere?
run_func:
    .quad   .L31
    .quad   .L3233
    .quad   .L35‬‬
    .quad   .L36‬‬
    .quad   .L37
    .quad   .L40
###########################################################
.section	.text
.global    run_func
    .type  run_func, @function
###########################################################
run_func:
    cmp     $31, %rax
    jz      .L31
    cmp     $32, %rax
    jz      .L3233‬‬
    cmp     $33, %rax
    jz      ‫‪.L3233‬‬
    cmp     $35, %rax
    jz      ‫‪‫‪.L35
    cmp     $36, %rax
    jz      ‫‪‫‪‫‪.L36‬‬
    cmp     $37, %rax
    jz      .L37
    jmp     .L40
    
.L31:                                #pstrlen
    #ret
.L3233‬‬:                              #replaceChar
    #ret
.L35‬‬:                                #pstrijcpy
    #ret
.L36‬‬:                                #swapCase‬‬
    #ret
.L37:                                #‫‪‫‪‫‪‫‪pstrijcmp
    #ret
.L40:                                #errorInput
    #ret
    