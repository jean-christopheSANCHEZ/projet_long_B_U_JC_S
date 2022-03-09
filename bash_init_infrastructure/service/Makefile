server: server.c
	gcc -static -Wall server.c -o server -mpreferred-stack-boundary=3 -fno-stack-protector -z execstack -no-pie

clean:
	rm server
