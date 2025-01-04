%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "vars.h"

int yylex();
extern int yylex_destroy();
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
%token TOK_CITESTE
%token <intVal>CTI <doubleVal>CTR <floatVal>CTZ
%token TOK_PLUS TOK_MINUS TOK_MULT TOK_DIV 
%token TOK_SEP TOK_OPARAN TOK_CPARAN TOK_ERR TOK_COMM TOK_LACC TOK_RACC
%token <str>TXT
%token TOK_LOWER TOK_GREATER TOK_EQUAL TOK_DIFFERENT TOK_LWEQ TOK_GREQ
%token TOK_DACA TOK_ATUNCI TOK_ALTFEL


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
    addVar($2, 0, 1, currentScopeLevel);
}
    | TOK_INTREG ID TOK_EQ CTI{
    addVar($2, $4, 1, currentScopeLevel);
}
    | TOK_REAL ID{
    addVar($2, 0, 2, currentScopeLevel);
}
    | TOK_REAL ID TOK_EQ CTR{
    addVar($2, $4, 2, currentScopeLevel);
}
    | TOK_ZECIMAL ID{
    addVar($2, 0, 3, currentScopeLevel);
}
    | TOK_ZECIMAL ID TOK_EQ CTZ{
    addVar($2, $4, 3, currentScopeLevel);
}
    ;

P   : TOK_BEGIN BLOCK TOK_END 
    ;

BLOCK : TOK_LACC{
            startScope();
            }
       Li TOK_RACC {
             endScope();
      }
      ;

Li  : 
    | Li BLOCK
    | Li TOK_COMM
    | Li I TOK_SEP
    | I TOK_SEP
    ;



I   : D
    | ID TOK_EQ E {
        Var* p = getVar($1);
        if(!p) {
            yyerror("Variabila nedeclarata!\n");
            break;
        }
        p->val = $3;
    }
    | TOK_AFISEAZA PRINT
    | TOK_CITESTE SCAN 
    ;


SCAN : SCAN ID      {
        Var* p = getVar($2);
        if(!p)
        {yyerror("Variabila nedeclarata!\n");
        break;}
        if(p->tip==1)
            scanf("%lf", &p->val);
        if(p->tip==2)
            scanf("%lf", &p->val);
        if(p->tip==3)
            scanf("%lf", &p->val);
        
    }
    | ID        {
        Var* p = getVar($1);
        if(!p)
        {yyerror("Variabila nedeclarata!\n");
        break;}
        if(p->tip==1)
            scanf("%lf", &p->val);
        if(p->tip==2)
            scanf("%lf", &p->val);
        if(p->tip==3)
            scanf("%lf", &p->val);
        
    }
    ;

PRINT : PRINT ID              {
        Var* p = getVar($2);
        if(!p)
        {yyerror("Variabila nedeclarata!\n");
        break;}
        if(p->tip==1)
            printf("%d", (int)p->val);
        if(p->tip==2)
            printf("%lf", p->val);
        if(p->tip==3)
            printf("%.6f", p->val);
        }
        | PRINT TXT{
            // if(strcmp($2, "\\n")==0)
            //     printf("\n");
            // else if(strcmp($2, "\\t")==0)
            //     printf("\t");
            char aux[200] = "\n";
            while(strstr($2, "\\n")){
                strcpy(aux,"\n");
                strcat(aux, strstr($2, "\\n")+2);
                strcpy(strstr($2, "\\n"), aux);
            }
            while(strstr($2, "\\t")){
                strcpy(aux,"\n");
                strcat(aux, strstr($2, "\\t")+2);
                strcpy(strstr($2, "\\t"), aux);
            }
            printf("%s", (char*)$2);
        }
        | ID {
        Var* p = getVar($1);
        if(!p)
        {yyerror("Variabila nedeclarata!\n");
        break;}
        if(p->tip==1)
            printf("%d", (int)p->val);
        if(p->tip==2)
            printf("%lf", p->val);
        if(p->tip==3)
            printf("%.6f", p->val);
        }
        | TXT{
            while(strstr($1, "\\n")){
                strcpy(strstr($1, "\\n"), "\n");
            }
            while(strstr($1, "\\t")){
                strcpy(strstr($1, "\\t"), "\t");
            }
            printf("%s", (char*)$1);
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
    | E TOK_EQUAL E { $$ = ($1 == $3);}
    | E TOK_GREATER E { $$ = ($1 > $3);}
    | E TOK_LOWER E { $$ = ($1 < $3);}
    | E TOK_GREQ E { $$ = ($1 >= $3);}
    | E TOK_LWEQ E { $$ = ($1 <= $3);}
    | E TOK_DIFFERENT E { $$ = ($1 != $3);}
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

void runInteractiveMode();
void runScript(const char* filename);

int main(int argc, char** argv) {
    if (argc == 2) {
        runScript(argv[1]);
    } else if (argc == 1) {
        runInteractiveMode();
    } else {
        printf("Usage:\n");
        printf("  %s                - Interactive mode\n", argv[0]);
        printf("  %s <filename>     - Run script file\n", argv[0]);
        return 1;
    }

    return 0;
}

void runInteractiveMode() {
    char input[1024];
    FILE* tmpFile;

    printf("Interpretor activat. Introduceți comenzi (scrieți `exit` pentru a ieși).\n");
    while (1) {
        printf("> ");
        if (!fgets(input, sizeof(input), stdin)) break;

        input[strcspn(input, "\n")] = 0;

        if (strcmp(input, "exit") == 0) {
            printf("Ieșire din interpretor.\n");
            break;
        }

        // Write the command to a temporary file
        tmpFile = fopen("tmp.vld", "w");
        if (!tmpFile) {
            perror("Eroare la crearea fișierului temporar");
            continue;
        }
        fprintf(tmpFile, "%s\n", input);
        fclose(tmpFile);

        // Parse the command using the parser
        yyin = fopen("tmp.vld", "r");
        if (!yyin) {
            perror("Eroare la deschiderea fișierului temporar");
            continue;
        }
        yyparse();
        fclose(yyin);

        // Destroy lexer state to reset for the next command
        yylex_destroy();

        // Show success or error message
        if (successRun) {
            printf("Succes :)\n");
        } else {
            printf("Eroare :(\n");
        }
    }
}

void runScript(const char* filename) {
    yyin = fopen(filename, "r");
    if (!yyin) {
        perror("Error opening file");
        return;
    }

    printf("Rularea scriptului: %s\n", filename);
    yyparse();
    fclose(yyin);

    yylex_destroy();

    if (successRun) {
        printf("\nSucces :)\n");
    } else {
        printf("\nEroare :(\n");
    }
}

int yyerror(char* msg)
{
    printf("Error: %s at line %d, column %d\n", msg, lineNo, colNo);
    successRun=0;
    return 1;
}

