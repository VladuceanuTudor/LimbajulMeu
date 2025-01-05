#include <stdlib.h>
int tokenBuff[100];
int tokenBuffSize=0;

void pushToken(int tok){
    tokenBuffSize++;
    tokenBuff[tokenBuffSize]=tok;
}