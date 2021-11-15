%option noyywrap
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "parser.tab.h"

    /*
    enum yytokentype
    {
        // some key-words in mylang
        // about types
        CHAR = 0x10,
        INT = 0x11,
        UINT = 0x12,
        DOUBLE = 0x13,
        
        // about funtions
        FUNCTION = 0x14,
        CALL     = 0x15,
        RETURN   = 0x16,
        
        // about tags
        SEMIC      = 0x17,
        OPEN_PAREN  = 0x18,
        CLOSE_PAREN = 0x19,
        OPEN_BRACE  = 0x1A,
        CLOSE_BRACE = 0x1B,
        
        // about operations
        ALOG_EQUAL = 0x1C,
        ALOG_ADD = 0x1D,
        ALOG_SUB = 0x1E,
        ALOG_MUL = 0x1F,
        ALOG_DIV = 0x20,
        ALOG_AND = 0x21,
        ALOG_OR  = 0x22,
        LOGI_AND = 0x23,
        LOGI_OR  = 0x24,
        LOGI_NOT = 0x26,

        // flow control
        FOR = 0x26,
        IF = 0x27,
        // usual
        DEC_DIGIT      = 0x28,
        HEX_DIGIT      = 0x29,
        INPUTCHAR      = 0x2A,
        IDENTIFIER     = 0x2B
    };
    */

    // some declaration about lex
    FILE* yyout;
    FILE* yyin;
%}

CHAR        "char"
INT         "int"
UINT        "uint"
DOUBLE      "double"

FUNCTION    "function"
CALL        "call"
RETURN      "return"

SEMIC       ";"
OPEN_PAREN   "("
CLOSE_PAREN  ")"
OPEN_BRACE   "{"
CLOSE_BRACE  "}"

ALOG_EQUAL  "="
ALOG_ADD    "+"
ALOG_SUB    "-"
ALOG_MUL    "*"
ALOG_DIV    "/"
ALOG_AND    "&"
ALOG_OR     "|"
LOGI_AND    "&&"
LOGI_OR     "||"
LOGI_NOT    "!"

FOR         "for"
IF          "if"

DEC_DIGIT       [0-9][0-9]*
HEX_DIGIT       0x[0-9A-F][0-9A-F]*
DECIMAL         [0-9]\.[0-9][0-9]*
INPUTCHAR       '[a-zA-Z]'
SPACE           [ \t]
NEWLINE     \n

IDENTIFIER  [a-zA-Z][0-9a-zA-Z]*
COMMENT     "//".*

%%
{CHAR}          {printf("CHAR\n");      return CHAR;}
{INT}           {printf("INT\n");       return INT;}
{UINT}          {printf("UINT\n");      return UINT;}
{DOUBLE}        {printf("DOUBLE\n");    return DOUBLE;}
{FUNCTION}      {printf("FUNCTION\n");   return FUNCTION;}
{CALL}          {printf("CALL\n");      return CALL;}
{RETURN}        {printf("RETURN\n");    return RETURN;}
{SEMIC}         {printf("SEMIC\n");     return SEMIC;}
{OPEN_PAREN}    {printf("OPENPAREN\n"); return OPEN_PAREN;}
{CLOSE_PAREN}   {printf("CLOSEPAREN\n");return CLOSE_PAREN;}
{OPEN_BRACE}    {printf("OPENBRACE\n"); return OPEN_BRACE;}
{CLOSE_BRACE}   {printf("OPENBRACE\n"); return CLOSE_BRACE;}
{ALOG_EQUAL}    {printf("LOGI_EQUAL\n");return ALOG_EQUAL;}
{ALOG_ADD}      {printf("ALOG_ADD\n");  return ALOG_ADD;}
{ALOG_SUB}      {printf("ALOG_SUB\n");  return ALOG_SUB;}
{ALOG_MUL}      {printf("ALOG_MUL\n");  return ALOG_MUL;}
{ALOG_DIV}      {printf("ALOG_DIV\n");  return ALOG_DIV;}
{ALOG_AND}      {printf("ALOG_AND\n");  return ALOG_AND;}
{ALOG_OR}       {printf("ALOG_OR\n");   return ALOG_OR;}
{LOGI_AND}      {printf("LOGI_AND\n");  return LOGI_AND;}
{LOGI_OR}       {printf("LOGI_OR\n");   return LOGI_OR;}
{LOGI_NOT}      {printf("LOGI_NOT\n");  return LOGI_NOT;}
{FOR}           {printf("FOR\n");       return FOR;}
{IF}            {printf("IF\n");        return IF;}

{INPUTCHAR}     {printf("INPUTCHAR, value:%s\n",yytext); yylval.cValue = *yytext; return CHAR;}
{DEC_DIGIT}     {
    printf("DEC_DIGIT, value:%s\n",yytext);
    yylval.iValue = strtol(yytext,NULL,10);
    return DEC_DIGIT;
}
{DECIMAL}       {printf("DECIMAL, value:%s\n",yytext); yylval.dValue = atof(yytext); return DECIMAL;}
{HEX_DIGIT}     {printf("HEX_DIGIT, value:%s\n",yytext); yylval.iValue = strtol(yytext,NULL,16); return HEX_DIGIT;}
{IDENTIFIER}    {printf("IDENTIFIER, value:%s\n",yytext); yylval.name = strdup(yytext); return IDENTIFIER;}

{SPACE}*        //{printf(" ");}      //ignore space
{COMMENT}*      {printf("COMMENT\n");}
{NEWLINE}*      //{printf("\n");}     //ignore newline


.               {printf("unknown Token %s\n",yytext);return -1;}
%%


/*
int main(int argc, char* argv[]){
    int token_type;
    yyin = fopen(argv[1],"r");
    yyout = stderr;
    for(;yylex();){

    }
}
*/