#include <stdio.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h> // read(), write(), close()
#define MAX 80
#define PORT 8080
#define SA struct sockaddr


void main()
{
    int sockfd, connfd;
    struct sockaddr_in servaddr, cli;

    // socket create and verification
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        printf("socket creation failed...\n");
        exit(0);
    }

    bzero(&servaddr, sizeof(servaddr));

    // assign IP, PORT
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    servaddr.sin_port = htons(PORT);

    // connect the client socket to server socket
    if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr))
        != 0) {
        printf("connection with the server failed...\n");
        exit(0);
    }

    func(sockfd);

    // initialise sht30 sensor
    // TwoWire.begin();
    // Serial.begin(115200);
    // delay(300);
}

void func(int connfd) {
    char buff[MAX];
    int n;
    //for (;;) {
    
    // read the message from companion server and copy it in buffer
    read(connfd, buff, sizeof(buff));

    //printf(buff);
    // print buffer which contains the temp data
    printf("From companion reading: %s", buff);
    //}
}