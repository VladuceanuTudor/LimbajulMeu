#pragma once
#define MAX_PARAMS 10
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "vars.h"
#include "tokenBuff.h"

static int func_ok = 0;
static int nrF=0;
static int local_params_size=0;
static char local_params[10][40];

struct function
{
    int nr;
    char name[256];
    int nrParams;
    char params[MAX_PARAMS][10];
    int lBsize;
    int lexicalBuff[200];
    //int sBsize;
    char semanticalBuff[200][100];
    struct function *next;
};

typedef struct function function;

function *fctHead = (function *)NULL;

function *getFunc(char *name)
{
    for (function *ptr = fctHead; ptr != NULL; ptr = ptr->next)
    {
        if (strcmp(ptr->name, name) == 0)
            return ptr;
    }
    return NULL;
}

function *getFuncByNr(int i)
{
    for (function *ptr = fctHead; ptr != NULL; ptr = ptr->next)
    {
        if (ptr->nr == i)
            return ptr;
    }
    return NULL;
}


function *addFunc(char *name)
{
    if (getFunc(name) != NULL){
        printf("this func already exists!");
        return NULL;
    }
    function *ptr = (function *)malloc(sizeof(function));
    strcpy(ptr->name, name);
    ptr->next = fctHead;
    fctHead = ptr;
    nrF++;
    ptr->nr=nrF;
    return ptr;
}

void populateFunction(char * name, int tokens[200], int nrTokens, char txts[200][100])
{
    function * f = getFunc(name);
    for(int i = 1; i<=nrTokens; i++)
        f->lexicalBuff[i]= tokens[i];
    for(int i =1; i<=nrTokens; i++)
        strcpy(f->semanticalBuff[i], txts[i]);

    f->lBsize=nrTokens;
}

void printFunction(char* name){
    function * f = getFunc(name);
    for(int i = 1; i<=f->lBsize; i++)
        printf("%d ", f->lexicalBuff[i]);
    printf("\n");
    for(int i =1; i<=f->lBsize; i++)
        printf("!%s! ", f->semanticalBuff[i]);
    for(int i =1; i<=f->nrParams; i++)
        printf("%s ", f->params[i]);
}
void addParam(char* param, int nrFunc)
{
    function * f = getFuncByNr(nrFunc);
    f->nrParams++;
    strcpy(f->params[f->nrParams], param);
}

void pumpFunc(char * name){
    function * f = getFunc(name);
    if(f==NULL)return;
    func_ok=1;
    for(int i = 1; i<f->lBsize; i++)
        pushToken(f->lexicalBuff[i]);
    for(int i =1; i<f->lBsize; i++)
        pushTxt(f->semanticalBuff[i]);
}

void apel_fnc(char param_noi[10][40], char* nume){
    //printf("-------------");
    //printFunction(nume);
    function * f = getFunc(nume);
    for(int i=1; i<=f->lBsize; i++)
        for(int j=1; j<= f->nrParams; j++){
            if(strcmp(f->semanticalBuff[i], f->params[j])==0)
                strcpy(f->semanticalBuff[i], param_noi[j]);
        }
    //printFunction(nume);
}

void clear_local_params(){
local_params_size=0;
}