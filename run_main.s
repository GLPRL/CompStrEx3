#318778594 Gal Pearl
###########################################################
.data
###########################################################
.section 	  .rodata
format_scanf:      .string "%d"                    #format for number
format_scanfstring:.string "%s"                    #format for string
#printing formats
format_printf:      .string "%d\n"
format_printfstring:.string "%s\n"
###########################################################
.section	.text
.globl  main
    .type main, @function
###########################################################
main:
    push %rbp
    movq %rsp, %rbp
run_main:
                                            #Receiving size of string 1
    sub     $560, %rsp                      #allocate 560bytes
    movq    $format_scanf, %rdi             #init format for scanf for int
    leaq    -16(%rbp), %rsi                 #align for scanf
    xor     %rax, %rax
    call    scanf                           #calling scanf
    movq    $format_printf, %rdi
    call    printf
                                            #Receiving the string  1
    movq    $format_scanfstring, %rdi       #init format for scanf for string input
    leaq    -256(%rbp), %rsi                #give 255bytes for max size string
    xor     %rax, %rax
    call    scanf                           #calling scanf
    movq    $format_printfstring, %rdi
    leaq    -256(%rbp), %rsi
    call    printf
                                            #Receiving size of string 2
    movq    $format_scanf, %rdi             #init format for scanf for int
    leaq    -272(%rbp), %rsi                #align for scanf
    xor     %rax, %rax
    call    scanf                           #calling scanf
    movq    $format_printf, %rdi
    call    printf
                                            #Receiving the string 2
    movq    $format_scanfstring, %rdi       #init format for scanf for string input
    leaq    -544(%rbp), %rsi                #give 255bytes for max size string
    xor     %rax, %rax
    call    scanf
    movq    $format_printfstring, %rdi
    leaq    -544(%rbp), %rsi
    call    printf
                                            #Receiving int for switch-case
    movq    $format_scanf, %rdi             #init format for option select
    leaq    -560(%rbp), %rsi                #init argument for option
    xor     %rax, %rax
    call    scanf                           #read input
    movq    $format_printf, %rdi
    call    printf
func_call:                                  #calling run_func from func_select.s
.extern run_func                            #Announce that run_func is external
    .type run_func, @function
    call    run_func                        #call run_func
end:                                        #ending the operation
    addq    $560, %rsp                      #restore rsp
    movq    %rbp, %rsp                      #restore rbp to rsp
    popq    %rbp                            #pop base pointer
    xorq    %rax, %rax
    ret
    