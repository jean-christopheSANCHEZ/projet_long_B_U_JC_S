 

.section .text

.global main 

main:
  xor     %rax, %rax
  xor     %rdi, %rdi
  push    %rax                                          
  mov     $0x636e2f2f6e69622F, %rdi  
  #mov     $0x736c2f2f6e69622F, %rdi  
  push    %rdi
  lea     (%rsp), %rdi
  xor     %rsi, %rsi                 
  xor     %rdx, %rdx
  mov     $59, %al                 
  syscall

