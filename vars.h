#pragma once
#include <stdlib.h>
#include <string.h>

typedef struct Var{
    char nume[20];
    double val;
    int tip; // 1 - int; 2 - double; 3 -float
    struct Var* next;
}Var;

Var* headVar = NULL;

Var* getVar(char *nume){
    Var* p = headVar;
    while(p){
        if(strcmp(p->nume, nume )==0)
        return p;
        p = p->next;
    }
    return NULL;
}

Var* addVar(char nume[20], double val, int tip){
    if(getVar(nume)){
        return NULL;
    }
    Var* p = (Var*)malloc(sizeof(Var));
    strcpy(p->nume, nume);
    p->tip=tip;
    p->val=val;
    p->next=headVar;
    headVar=p;
    return p;
}