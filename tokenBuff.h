#include <stdlib.h>
#include <string.h>
static int tokenBuff[100];
static int tokenBuffSize=0;
static int tok_while = 0;


void pushTokenInFront(int tok){
    tokenBuffSize++;
    for(int i = tokenBuffSize; i>=2; i--){
        tokenBuff[i]=tokenBuff[i-1];
    }
    tokenBuff[1]=tok;
}

void pushToken(int tok){
    tokenBuffSize++;
    tokenBuff[tokenBuffSize]=tok;
}
int getToken(){
    int tok = tokenBuff[1];
    for(int i=1; i<=tokenBuffSize-1; i++)
    tokenBuff[i] = tokenBuff[i+1];
    tokenBuffSize--;
    return tok;
}

void printBuff(){
    for (int i =1 ; i<=tokenBuffSize; i++)
    printf("%d ", tokenBuff[i]);
    printf("\n");
}

void cleanBuff(){
    tokenBuffSize=0;
}

static char txtBuff[100][100];
static int txtBuffSize=1;

void pushTxt(char * name){
    txtBuffSize++;
    strcpy(txtBuff[txtBuffSize],name);
}
char * getTxt(){
    char* name = txtBuff[1];
    for(int i=1; i<=txtBuffSize-1; i++)
    strcpy(txtBuff[i], txtBuff[i+1]);
    txtBuffSize--;
    //printf("a intors: %s\n", name);
    return name;
}

void pushTxtInFront(char* tok){
    txtBuffSize++;
    for(int i = txtBuffSize; i>=2; i--){
        strcpy(txtBuff[i],txtBuff[i-1]);
    }
    strcpy(txtBuff[1],tok);
}

void printBuffTxt(){
    for (int i =1 ; i<=txtBuffSize; i++)
    printf("t%st ", txtBuff[i]);
    printf("\n");
}

void cleanBuffTxt(){
    txtBuffSize=0;
}

