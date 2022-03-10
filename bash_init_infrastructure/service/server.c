#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strings.h>
#include <sys/socket.h>
#include <resolv.h>
#include <arpa/inet.h>
#include <errno.h>
#include <string.h>

#define MAX_BUF		1000


void display_message(char* str){
  char buffer[200];
  strcpy(buffer,str);
  printf("Bonjour, %s\n", buffer);
}

int main(int argc, char *argv[]){   
	if(argc!=2){
		printf("Wrong call : ./server port\n");
		exit(1);
	}
	int port = atoi(argv[1]);
	int sockfd;
	struct sockaddr_in self;
	char buffer[MAX_BUF];
	pid_t childpid;
  int yes = 1;  

	//create socket
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	{
		perror("Socket creation error");
		exit(errno);
	}

	//Initialize address/port structure
	bzero(&self, sizeof(self));
	self.sin_family = AF_INET;
	self.sin_port = htons(port);
	self.sin_addr.s_addr = INADDR_ANY;

	// Assign a port number to the socket
  setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int));                                                                      
  if (bind(sockfd, (struct sockaddr*)&self, sizeof(self)) != 0)
	{
		perror("socket:bind()");
		exit(errno);
	}

	// Make it a "listening socket". Limit to 30 connections
	if (listen(sockfd, 30) != 0)
	{
		perror("socket:listen()");
		exit(errno);
	}

	//Server run continuously
		
		int clientfd;
    struct sockaddr_in client_addr;
		int addrlen=sizeof(client_addr);

		//accept an incomming connection
		clientfd = accept(sockfd, (struct sockaddr*)&client_addr,(void *)&addrlen);
		printf("%s:%d connected\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
/*		
		if((childpid = fork()) == 0){
			close(sockfd);
			while(1){
				read(clientfd, &buffer, MAX_BUF);
				printf("id:%s\n", buffer);
			}
		}
*/
    read(clientfd, &buffer, MAX_BUF);
    display_message(buffer);
		
		//recv the id and print it
		//recv(clientfd, buffer, MAX_BUF, 0);
		//printf("id:%s\n", buffer);

		//Echo back the received data to the client
		//send(clientfd, buffer, recv(clientfd, buffer, MAX_BUF, 0), 0);

		//Close data connection
    //close(clientfd);
  


	//Clean up
	close(clientfd);
	return 0;
}

