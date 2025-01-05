%{
#include "pars.tab.h"
#include <stdio.h>
#include <stdlib.h>

int colNo = 0;
int lineNo = 1; // Prima linie începe de la 1
%}

%option noyywrap

%%

"intreg"                   { colNo += yyleng; return TOK_INTREG; }
"real"                     { colNo += yyleng; return TOK_REAL; }
"zecimal"                  { colNo += yyleng; return TOK_ZECIMAL; }
"program"                  { colNo += yyleng; return TOK_PROGR; }
"afiseaza"                 { colNo += yyleng; return TOK_AFISEAZA; }
"inceput"                    {colNo += yyleng; return TOK_BEGIN; }
"sfarsit"                      {colNo += yyleng; return TOK_END; }
"citeste"                  { colNo += yyleng; return TOK_CITESTE; }
"daca"                     { colNo += yyleng; return TOK_DACA;}
"Daca"                      {colNo += yyleng; return TOK_Daca;}
"atunci"                   { colNo += yyleng; return TOK_ATUNCI;}
"altfel"                   {colNo += yyleng; return TOK_ALTFEL;}
"cat timp"                  {colNo += yyleng; return TOK_WHILE;}
"executa"                  {colNo += yyleng; return TOK_EXECUTE;}


"+"                         { colNo++; return TOK_PLUS; }
"-"                         { colNo++; return TOK_MINUS; }
"*"                         { colNo++; return TOK_MULT; }
"/"                         { colNo++; return TOK_DIV; }
"="                         { colNo++; return TOK_EQ; }
";"                         { colNo++; return TOK_SEP; }
"("                         { colNo++; return TOK_OPARAN; }
")"                         { colNo++; return TOK_CPARAN; }
"<"                         { colNo++; return TOK_LOWER; }
">"                         { colNo++; return TOK_GREATER; }
"=="                        { colNo++; return TOK_EQUAL; }
"!="                        { colNo++; return TOK_DIFFERENT; }
"<="                        { colNo++; return TOK_LWEQ; }
">="                        { colNo++; return TOK_GREQ; }
"{"                         { colNo++; return TOK_LACC; }
"}"                         { colNo++; return TOK_RACC; }

"//"[^\n]*                           { colNo += yyleng; return TOK_COMM; }
\/\*[^*]*\*+([^/*][^*]*\*+)*\/       { colNo += yyleng; return TOK_COMM; }
[0-9]+"."[0-9]+"f"              { colNo += yyleng; yylval.floatVal = atof(yytext); return CTZ; }  // Zecimal cu virgulă
[0-9]+"."[0-9]+                 { colNo += yyleng; yylval.doubleVal = atof(yytext); return CTR; }  // Real
[0-9]+                          { colNo += yyleng; yylval.intVal = atoi(yytext); return CTI; }  // Intreg
[a-zA-Z_][a-zA-Z0-9_]*          { colNo += yyleng; yylval.str=strdup(yytext); return ID; }
\"[^\"]*\" {
    colNo += yyleng;
    yytext[yyleng - 1] = '\0';  // Remove trailing quote
    yylval.str = strdup(yytext + 1);  // Skip leading quote
    return TXT;
}



[ \t]                       { colNo += yyleng; }
\n                          { lineNo++; colNo = 0; }
.                           { colNo++; return TOK_ERR; }

%%
