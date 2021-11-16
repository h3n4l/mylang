%option noyywrap
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "parser.tab.h"
    #define LEXLOG 0
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
    void lexlog(char*s);
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

IINPUT_FUNC "iInput()"

%%
{CHAR}          {lexlog("CHAR\n");      return CHAR;}
{INT}           {lexlog("INT\n");       return INT;}
{UINT}          {lexlog("UINT\n");      return UINT;}
{DOUBLE}        {lexlog("DOUBLE\n");    return DOUBLE;}
{FUNCTION}      {lexlog("FUNCTION\n");   return FUNCTION;}
{CALL}          {lexlog("CALL\n");      return CALL;}
{RETURN}        {lexlog("RETURN\n");    return RETURN;}
{SEMIC}         {lexlog("SEMIC\n");     return SEMIC;}
{OPEN_PAREN}    {lexlog("OPENPAREN\n"); return OPEN_PAREN;}
{CLOSE_PAREN}   {lexlog("CLOSEPAREN\n");return CLOSE_PAREN;}
{OPEN_BRACE}    {lexlog("OPENBRACE\n"); return OPEN_BRACE;}
{CLOSE_BRACE}   {lexlog("OPENBRACE\n"); return CLOSE_BRACE;}
{ALOG_EQUAL}    {lexlog("ALOG_EQUAL\n");return ALOG_EQUAL;}
{ALOG_ADD}      {lexlog("ALOG_ADD\n");  return ALOG_ADD;}
{ALOG_SUB}      {lexlog("ALOG_SUB\n");  return ALOG_SUB;}
{ALOG_MUL}      {lexlog("ALOG_MUL\n");  return ALOG_MUL;}
{ALOG_DIV}      {lexlog("ALOG_DIV\n");  return ALOG_DIV;}
{ALOG_AND}      {lexlog("ALOG_AND\n");  return ALOG_AND;}
{ALOG_OR}       {lexlog("ALOG_OR\n");   return ALOG_OR;}
{LOGI_AND}      {lexlog("LOGI_AND\n");  return LOGI_AND;}
{LOGI_OR}       {lexlog("LOGI_OR\n");   return LOGI_OR;}
{LOGI_NOT}      {lexlog("LOGI_NOT\n");  return LOGI_NOT;}
{FOR}           {lexlog("FOR\n");       return FOR;}
{IF}            {lexlog("IF\n");        return IF;}

{INPUTCHAR}     {lexlog("INPUTCHAR"); yylval.cValue = *yytext; return CHAR;}
{DEC_DIGIT}     {
    lexlog("DEC_DIGIT");
    yylval.iValue = strtol(yytext,NULL,10);
    return DEC_DIGIT;
}
{DECIMAL}       {lexlog("DECIMAL"); yylval.dValue = atof(yytext); return DECIMAL;}
{HEX_DIGIT}     {lexlog("HEX_DIGIT"); yylval.iValue = strtol(yytext,NULL,16); return HEX_DIGIT;}
{IINPUT_FUNC}   {lexlog("IINPUT_FUNC");return IINPUT_FUNC;}

{IDENTIFIER}    {lexlog("IDENTIFIER"); yylval.name = strdup(yytext); return IDENTIFIER;}

{SPACE}*        //{lexlog(" ");}      //ignore space
{COMMENT}*      {lexlog("COMMENT\n");}
{NEWLINE}*      //{lexlog("\n");}     //ignore newline


.               {printf("\033[0mUnknown Token %s\033[0m\n",yytext);return -1;}
%%


/*
int main(int argc, char* argv[]){
    int token_type;
    yyin = fopen(argv[1],"r");
    yyout = stderr;
    for(;yylex();){

    }
}
#define mian main
#define ；  ;
*/

void lexlog(char*s){
    #ifndef LEXDEBUG
    #define LEXDEBUG 0
    #endif
    if(LEXDEBUG){
        printf("\033[034m%s\033[0m\n",s);
    }
    
}