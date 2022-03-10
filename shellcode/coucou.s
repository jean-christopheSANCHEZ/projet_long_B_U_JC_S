.global main

main :
  jmp X

Y:
  pop %rsi
  mov $1, %rdi
  mov $7, %rdx
  mov $1, %rax
  syscall
  ret

X:
  call Y
coucou:
  .ascii "Coucou\n"
