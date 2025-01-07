#pragma once
#include <stdlib.h>

int if_sw[100];
int if_count=0;

void set_if(int val){
    if_sw[if_count]=val;
    if_count++;
}

int get_if(){
    return if_sw[if_count-1];
}

int discard_if(){
    if_count--;
}

static int ok_while=0;