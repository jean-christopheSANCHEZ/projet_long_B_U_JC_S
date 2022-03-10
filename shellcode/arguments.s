.section .text

.global main

main:

        xor %rax, %rax            #create null eax register
        push %rax                #push null eax register to the stack
       
         
        xor %rdi, %rdi
        push  $0x7461632f
        push  $0x6e69622f  #/bin/cat
        
        #push %rdi
        lea (%rsp), %rdi

        push $0x6c2d
        lea (%rsp), %rbx
        
        push %rax
        push %rbx
        push %rdi
        lea (%rsp), %rsi

        
        xor %rdx, %rdx

        mov $59, %al              
        syscall                 
