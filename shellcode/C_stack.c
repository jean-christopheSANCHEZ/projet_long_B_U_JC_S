#include <stdio.h>

int main(){

  char * rsp;
  asm volatile("mov %%rsp, %0"
              :"=r"(rsp)
              :
              :);

  printf("%p\n", rsp);
  return 0;

}


