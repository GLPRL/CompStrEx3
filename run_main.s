#318778594 Gal Pearl
###########################################################
.data
###########################################################
.section 	  .rodata
format_scanf:      .string "%d"                    #format for number
format_scanfstring:.string "%s"                    #format for string
###########################################################
.section	.text
.globl  run_main
    .type run_main, @function
###########################################################
run_main:
    push    %rbp                            #new stack frame
    movq    %rsp, %rbp                      #move stack pointer to base
                                            #Receiving size of string 1
    sub     $560, %rsp                      #allocate 560bytes
    movq    $format_scanf, %rdi             #init format for scanf for int
    leaq    -273(%rbp), %rsi                #align for scanf
    xor     %rax, %rax
    call    scanf                           #calling scanf
                                            #Receiving the string  1
    movq    $format_scanfstring, %rdi       #init format for scanf for string input
    leaq    -272(%rbp), %rsi                #give 255bytes for max size string
    xor     %rax, %rax
    call    scanf                           #calling scanf
                                            #Receiving size of string 2
    movq    $format_scanf, %rdi             #init format for scanf for int
    leaq    -545(%rbp), %rsi                #align for scanf
    xor     %rax, %rax
    call    scanf                           #calling scanf
                                            #Receiving the string 2
    movq    $format_scanfstring, %rdi       #init format for scanf for string input
    leaq    -544(%rbp), %rsi                #give 255bytes for max size string
    xor     %rax, %rax
    call    scanf
                                            #Receiving int for switch-case
    movq    $format_scanf, %rdi             #init format for option select
    leaq    -560(%rbp), %rsi                #init argument for option
    xor     %rax, %rax
    call    scanf                           #read input
func_call:                                  #calling run_func from func_select.s
    leaq    -273(%rbp), %rbx                #first pstring to rbx
    leaq    -545(%rbp), %r12                #second pstring to r12
    call    run_func                        #call run_func. Option is given in RSI
end:                                        #ending the operation
    addq    $560, %rsp                      #restore rsp
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    xorq    %rax, %rax
    ret
    