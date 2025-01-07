%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "vars.h"
#include "if.h"
//#include "tokenBuff.h"
#include "func.h"
#include "pars.tab.h"


extern int yylex();
extern char* yytext;
//extern YYSTYPE yylval;

// int custom_yylex() {
//     int token;
//     // if(get_if()==1 && tok_while==3)
//     // return 281;
//     if (tokenBuffSize>0 && (tok_while==0 || tok_while == 3)) {
//         //printBuff(); 
//         token = getToken();
//         if(tok_while==3){
//             pushToken(token);
//             }
//         //printf("tokw=%d %d %d\n",tok_while, token, tokenBuffSize);
        
//     } else if (tok_while==1||tok_while==2) {
//         // printf("\n");
//         // printBuff(); 
//         // printf("%d\n", tokenBuffSize);
//         // printBuffTxt();
//         // printf("%d\n", txtBuffSize);
        
//         // if(if_count>1){
//         //     if(ok_while==0){
//         //         token = 280;
//         //         ok_while++;
//         //     }
//         //     else
//         //     {
//         //         token = getToken();
//         //         ok_while--;
//         //     }
//         // printf("\n");
//         // printBuff(); 
//         // }
//         // else token = yylex();
//         //printBuffTxt();
//         token == yylex();
//         if(tok_while==1){
//             pushToken(293);
//             pushTxt("cat timp");
//             tok_while++;
//         }
//         pushToken(token);
//         pushTxt(yytext);
//         //printf("tokw=%d %d aici\n",tok_while, token);
//     } else {
//         token = yylex();
//         //printf("tokw=%d %d \n",tok_while, token);
//     }

//     if(tok_while==3){
//         // printf("\n");
//         // printBuff(); 
//         // printf("%d\n", tokenBuffSize);
//         // printBuffTxt();
//         // printf("%d\n", txtBuffSize);
//         char* txt = getTxt();
//         switch (token) {
//             case 258: // Identifier
//                 yylval.str = strdup(txt); 
//                 //printf("%s", yytext);
//                 break;
//             case 268: // Integer constant
//                 yylval.intVal = atoi(txt); 
//                 break;
//             case 269: // Real constant
//                 yylval.doubleVal = atof(txt); 
//                 break;
//             case 270: // Real constant
//                 yylval.floatVal = atof(txt); 
//                 break;
//             case 282:
//                 yylval.str = strdup(txt + 1);  
//                 break;
//             default:
//                 break;
//         }
//         // printf("\n%s\n", txt);
//         // printf("\n%d\n", token);
//         pushTxt(txt);
//     }
//     return token;
// }
int custom_yylex() {
    int token;
    // if(get_if()==1 && tok_while==3)
    // return 281;
    if(tokenBuffSize==0)func_ok=0;
    if(func_ok==1){
        token=getToken();
        //printf("  -%d-   ", token);
    }else if (tokenBuffSize>0 && (tok_while==0 || tok_while == 3)) {
        // printBuff(); 
        token = getToken();
        if(tok_while==3){
            pushToken(token);
            }
        //printf("tokw=%d %d %d\n",tok_while, token, tokenBuffSize);
        
    } else if (tok_while==1||tok_while==2) {
        token = yylex();
        //printBuffTxt();
        if(tok_while==1){
            pushToken(293);
            pushTxt("cat timp");
            tok_while++;
        }
        pushToken(token);
        pushTxt(yytext);
        //printf("tokw=%d %d aici\n",tok_while, token);
    } else {
        token = yylex();
        //printf("tokw=%d %d \n",tok_while, token);
    }

    if(tok_while==3 || func_ok==1){
        // printf("\n");
        // printBuff(); 
        // printf("%d\n", tokenBuffSize);
        // printBuffTxt();
        // printf("%d\n", txtBuffSize);
        char* txt = getTxt();
        switch (token) {
            case 258: 
                yylval.str = strdup(txt); 
                //printf("%s", yytext);
                break;
            case 268: 
                yylval.intVal = atoi(txt); 
                break;
            case 269: 
                yylval.doubleVal = atof(txt); 
                break;
            case 270: 
                yylval.floatVal = atof(txt); 
                break;
            case 282:
                yylval.str = strdup(txt + 1);  
                break;
            default:
                break;
        }
        // printf("\n%s\n", txt);
        // printf("\n%d\n", token);
        pushTxt(txt);
    }
    return token;
}


#define yylex custom_yylex
extern int yylex_destroy();
int yyerror(char* msg);
int skipToToken(int tokenToFind ,int tokenToIncrement);
extern FILE* yyin;
extern int lineNo;  
extern int colNo;   
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
%token TOK_DACA TOK_ATUNCI TOK_ALTFEL TOK_Daca
%token TOK_WHILE TOK_EXECUTE
%token TOK_CAST_INTREG TOK_CAST_REAL TOK_CAST_ZECIMAL
%token TOK_FUNC TOK_CALL



%type <doubleVal> E

%left TOK_PLUS TOK_MINUS 
%left TOK_MULT TOK_DIV 
%right TOK_CAST_INTREG TOK_CAST_REAL TOK_CAST_ZECIMAL



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

P   : TOK_BEGIN BLOCK  
    | FUNC TOK_BEGIN BLOCK 
    ;

FUNC : 
     | FUNC TOK_FUNC ID{
        addFunc($3);
     } PARAMS TOK_LACC{
        startScope();
        int tok;
        int toklist[200], tokNr=1;
        char txtList[200][100];
        while((tok=yylex())!=TOK_RACC){
             toklist[tokNr]=tok;
             strcpy(txtList[tokNr], yytext);
             tokNr++;
        }
        populateFunction($3, toklist, tokNr, txtList);
     }
     ; 

PARAMS : 
       | PARAMS ID {
        addParam($2, nrF);
       }
       ;

PARAMS_APEL:
        | PARAMS_APEL ID {
            //printf("%s...", $1);
            local_params_size++;
            strcpy(local_params[local_params_size],$2);
            //for(int i=1; i<=local_params_size; i++)
            //printf("....%s", local_params[i]);
       }
       ;

BLOCK : TOK_LACC{
                startScope();
            }
       Li TOK_RACC {
                endScope();

            }
      ;
IF_BLOCK : TOK_LACC{
            
            if (get_if()==1) {
                //printf("%d", currentScopeLevel);
                //printf("--%d--", tok_while);
                skipToToken(TOK_RACC, TOK_LACC);
            }else{
                startScope();
            }
            }
       Li  TOK_RACC
      ;

Li  : 
    | Li WHILE_SETUP TOK_WHILE E TOK_EXECUTE {
            if($4)
                set_if(0);
            else {
                set_if(1);
            }
    
    } IF_BLOCK {
        if(get_if()==0){
            tok_while=3;
            }
        else {
            if(tok_while==3)endScope();
            tok_while=0;
            cleanBuff();
            cleanBuffTxt();
        }
    }
    | Li TOK_DACA E TOK_ATUNCI {
            if($3) 
                set_if(0);
            else {
                set_if(1);
                }
        } IF_BLOCK {
            //printf("%d", currentScopeLevel);
            if(get_if()==0)
                endScope();
            //printf("if discarded!");
            discard_if();
            //printf("-------------%d----------", if_count);
        }
    |  Li TOK_Daca E TOK_ATUNCI{
             if($3) 
                set_if(0);
            else {
                set_if(1);
                }
    } IF_BLOCK{
            if(get_if()==0)
                endScope();  
            discard_if();
    } TOK_ALTFEL {
            if($3) 
                set_if(1);
            else {
                set_if(0);
                }
    } IF_BLOCK {
            if(get_if()==0)
                endScope();
            discard_if();
    }
    ;
    | Li BLOCK
    | Li TOK_COMM
    | Li I TOK_SEP
    | I TOK_SEP
    ;

WHILE_SETUP : { if(tok_while==0)tok_while = 1; }
;

I   : D
    | TOK_CALL ID PARAMS_APEL{
        apel_fnc(local_params, $2);
        pumpFunc($2);
        func_ok=1;
        //printFunction($2);
    }
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
        // printf(" E div");
        if ($3 == 0) {
            sprintf(msg, "Error: Divide by zero at line %d, column %d\n", lineNo, colNo);
            yyerror(msg);
        } else {
            $$ = $1 / $3; 
        }
        //printf("%lf %lf", $1, $$);
    }
    | ID TOK_DIV E {
        Var* var = getVar($1); 
        //printf(" id div");
        if (!var) {
            yyerror("Undeclared variable used in division!\n");
        } else if (var->tip == 1 && var->cast!=2 && var->cast!=3) {
            if ($3 == 0) {
                sprintf(msg, "Error: Divide by zero at line %d, column %d\n", lineNo, colNo);
                yyerror(msg);
            } else {
                if($3 == (int)$3)
                $$ = (int)var->val / (int)$3;
                else
                $$ = (int)var->val / $3;
            }
        } else {
            $$ = var->val / $3; 
            var->cast=0;
        }

    }
    | E TOK_DIV ID {
        Var* var = getVar($3); 
        if (!var) {
            yyerror("Undeclared variable used in division!\n");
        } else if (var->tip == 1) {
            if (var->val == 0) {
                sprintf(msg, "Error: Divide by zero at line %d, column %d\n", lineNo, colNo);
                yyerror(msg);
            } else {
                $$ = $1 / (int)var->val; 
            }
        } else {
            $$ = $1 / var->val; 
        }
    }
    | ID TOK_DIV ID {
        Var* leftVar = getVar($1);
        Var* rightVar = getVar($3);
        if (!leftVar || !rightVar) {
            yyerror("Undeclared variable used in division!\n");
        } else if (rightVar->val == 0) {
            sprintf(msg, "Error: Divide by zero at line %d, column %d\n", lineNo, colNo);
            yyerror(msg);
        } else if (leftVar->tip == 1 && rightVar->tip == 1) {
            $$ = (int)leftVar->val / (int)rightVar->val;
        } else {
            $$ = leftVar->val / rightVar->val; 
        }
    }
    ;
    | E TOK_EQUAL E { $$ = ($1 == $3);}
    | E TOK_GREATER E { $$ = ($1 > $3);}
    | E TOK_LOWER E { $$ = ($1 < $3);}
    | E TOK_GREQ E { $$ = ($1 >= $3);}
    | E TOK_LWEQ E { $$ = ($1 <= $3);}
    | E TOK_DIFFERENT E { $$ = ($1 != $3);}
    // | TOK_CAST_INTREG E {$$ = (int)$2; }
    // | TOK_CAST_REAL E {$$ = (double)$2; printf("cast");}
    // | TOK_CAST_ZECIMAL E {$$ = (float)$2;}
    | TOK_CAST_INTREG ID 
        {
        Var* var = getVar($2); 
        if (!var) {
            yyerror("Undeclared variable used in division!\n");
        }
        var->cast=1;
        $$ = (int)var->val;
        }
    | TOK_CAST_REAL ID 
        {
            //printf("Asa");
        Var* var = getVar($2); 
        if (!var) {
            yyerror("Undeclared variable used in division!\n");
        }
        var->cast=2;
        $$ = (int)var->val;
        }
    | TOK_CAST_ZECIMAL ID 
        {
        Var* var = getVar($2); 
        if (!var) {
            yyerror("Undeclared variable used in division!\n");
        }
        var->cast=3;
        $$ = (float)var->val;
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

        
        tmpFile = fopen("tmp.vld", "w");
        if (!tmpFile) {
            perror("Eroare la crearea fișierului temporar");
            continue;
        }
        fprintf(tmpFile, "%s\n", input);
        fclose(tmpFile);

        
        yyin = fopen("tmp.vld", "r");
        if (!yyin) {
            perror("Eroare la deschiderea fișierului temporar");
            continue;
        }
        yyparse();
        fclose(yyin);

        
        yylex_destroy();

        
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
    exit(1);
    return 1;
}

int skipToToken(int tokenToFind ,int tokenToIncrement) {
    int token, prevToken;
    int counter=0;
    while ((token = yylex()) != 0) { 
        //printf("%d ", token);
        if(token == tokenToIncrement)counter++;
        if (token == tokenToFind && counter==0) {
            // ungetc(tokenToFind, yyin); 
            // ungetc(TOK_RACC, yyin); 
            // ungetc('}', yyin);
            // ungetc(281, yyin);
            // printf("%d ", TOK_RACC);
            // printf("%d ", tokenToFind);
            // printf("%d ", token);
            // printf("%d ", yylex()); 
            // printf("%d ", yylex());
            // printf("%d ", yylex());
            // printf("%d ", yylex());
            // printf("%d -while\n", TOK_WHILE);
            // printf("%d -ececuta\n", TOK_EXECUTE);
            // printf("%d >\n", TOK_GREATER);
            // printf("%d -CTI\n", CTI);
            // printf("%d -ID\n", ID);
            // printf("%d -CTR\n", CTR);
            // printf("%d -CTZ\n", CTZ);
            //printf("%d -TXT\n", TXT);
            //cleanBuff();
            //tok_while=0;
            pushTokenInFront(tokenToFind);
            //pushTxtInFront("}");
            //if(tok_while)pushTokenInFront(tokenToFind);
            return token;
        }else if(token == tokenToFind)counter--;
        //printf("%d", counter);
        prevToken =  token;
    }
    //yylex();
    printf("Warning: Reached EOF without finding the token\n");
}