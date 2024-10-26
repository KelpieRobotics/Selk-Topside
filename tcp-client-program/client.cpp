#include <stdio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h> // read(), write(), close()
#define MAX 1024
#define PORT 8080
#define SA struct sockaddr
char buff[MAX];


void func(int connfd) {
    
    // read the message from companion server and copy it in buffer
    read(connfd, buff, sizeof(buff));

    // print buffer which contains the temp data
    printf("From companion reading: %s \n", buff);
    
    close(connfd);
}

int main()
{
    int sockfd, connfd;
    struct sockaddr_in servaddr, cli;

    // socket create and verification
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        printf("socket creation failed...\n");
        exit(1);
    }

    bzero(&servaddr, sizeof(servaddr));

    // assign IP, PORT

    struct hostent *server  = gethostbyname("127.0.0.1");
    servaddr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&servaddr.sin_addr.s_addr,
         server->h_length);
    servaddr.sin_port = htons(PORT);

    // connect the client socket to server socket
    if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr))
        != 0) {
        printf("connection with the server failed...\n");
        exit(1);
    }

    func(sockfd);

    return 0;
}

