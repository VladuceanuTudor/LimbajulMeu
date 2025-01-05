#pragma once
#include <stdlib.h>
#include <string.h>

typedef struct Var{
    char nume[20];
    double val;
    int scopeLvl;
    int tip; // 1 - int; 2 - double; 3 -float
    struct Var* next;
}Var;

Var* headVar = NULL;
int currentScopeLevel = 0;

Var* getVar(char *nume){
    Var* p = headVar;
    while(p){
        if(strcmp(p->nume, nume )==0 && currentScopeLevel >= p->scopeLvl)
        return p;
        p = p->next;
    }
    return NULL;
}

Var* addVar(char nume[20], double val, int tip, int scopeLvl){
    if(getVar(nume)){
        return NULL;
    }
    Var* p = (Var*)malloc(sizeof(Var));
    strcpy(p->nume, nume);
    p->tip=tip;
    p->scopeLvl=scopeLvl;
    p->val=val;
    p->next=headVar;
    headVar=p;
    return p;
}

void startScope() {
    currentScopeLevel++;
}

void endScope() {
    Var* p = headVar;
    
    // Ștergere variabile din capul listei
    while (p && p->scopeLvl == currentScopeLevel) {
        headVar = p->next;
        free(p);
        p = headVar;
    }
    
    // Ștergere variabile din restul listei
    Var* prev = p;
    while (p) {
        if (p->scopeLvl == currentScopeLevel) {
            prev->next = p->next;
            free(p);
            p = prev->next;
        } else {
            prev = p;
            p = p->next;
        }
    }
    currentScopeLevel--;
}


