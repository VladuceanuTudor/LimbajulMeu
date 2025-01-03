%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "vars.h"

int yylex();
int yyerror(char* msg);
extern FILE* yyin;
extern int lineNo;  // Declarația pentru variabila externă
extern int colNo;   // Declarația pentru variabila externă
char msg[256];
int successRun = 1;
%}


%union {char* str; int intVal; double doubleVal; float floatVal;}
%token <str>ID 
%token TOK_INTREG TOK_REAL TOK_ZECIMAL TOK_EQ TOK_BEGIN TOK_END TOK_PROGR
%token TOK_AFISEAZA
%token <intVal>CTI <doubleVal>CTR <floatVal>CTZ
%token TOK_PLUS TOK_MINUS TOK_MULT TOK_DIV 
%token TOK_SEP TOK_OPARAN TOK_CPARAN TOK_ERR

%type <doubleVal> E

%left TOK_PLUS TOK_MINUS 
%left TOK_MULT TOK_DIV 

%start START

%%
START   : S
        | START S
        ;

S   : Lg P   
    | P
    | TOK_ERR { successRun = 0; }
    ;

Lg  : Lg D TOK_SEP 
    | D TOK_SEP
    ;

D   : TOK_INTREG ID {
    addVar($2, 0, 1);
}
    | TOK_INTREG ID TOK_EQ CTI{
    addVar($2, $4, 1);
}
    | TOK_REAL ID{
    addVar($2, 0, 2);
}
    | TOK_REAL ID TOK_EQ CTR{
    addVar($2, $4, 2);
}
    | TOK_ZECIMAL ID{
    addVar($2, 0, 3);
}
    | TOK_ZECIMAL ID TOK_EQ CTZ{
    addVar($2, $4, 3);
}
    ;

P   : TOK_PROGR ID TOK_BEGIN Li TOK_END 
    ;

Li  : Li I TOK_SEP
    | I TOK_SEP
    ;

I   : D
    | ID TOK_EQ E {
        Var* p = getVar($1);
        if(!p)
        {yyerror("Variabila nedeclarata!\n");
        break;}
        p->val = $3;
    }
    | TOK_AFISEAZA ID               {
        Var* p = getVar($2);
        if(!p)
        {yyerror("Variabila nedeclarata!\n");
        break;}
        if(p->tip==1)
            printf("%d", (int)p->val);
        if(p->tip==2)
            printf("%lf", p->val);
        if(p->tip==3)
            printf("%f", p->val);
    }
    ;

E   : E TOK_PLUS E     {$$ = $1 + $3;}     
    | E TOK_MINUS E     {$$ = $1 - $3;}   
    | E TOK_MULT E  {$$ = $1 * $3;}       
    | E TOK_DIV E {
        if ($3 == 0) {
            sprintf(msg, "Error: Divide by zero at line %d, column %d\n", lineNo, colNo);
            yyerror(msg);
        } else {
            $$ = $1 / $3;
        }
    }
    | CTI{$$=(double)$1;}
    | CTR
    | CTZ{$$=(double)$1;}
    | ID{
        Var* p = getVar($1);
        if(p)
        $$=getVar($1)->val;
        else 
        yyerror("Variabila nedeclarata!\n");
    }
    ;

%%

int main(int argc, char** argv)
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error opening file");
            return 1;
        }
    }
    yyparse();

    if (successRun) {
        printf("Succes :)\n");
    } else {
        printf("Eroare :(\n");
    }

    fclose(yyin);
    return 0;
}

int yyerror(char* msg)
{
    printf("Error: %s at line %d, column %d\n", msg, lineNo, colNo);
    successRun=0;
    return 1;
}

