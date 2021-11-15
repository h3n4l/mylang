%{
#include<stdio.h>
#include<stdlib.h>
int yylex(void);
void yyerror(char*);   
%}
%token CHAR
%token INT
%token UINT
%token DOUBLE

%token FUNCTION
%token CALL
%token RETURN

%token SEMIC
%token OPEN_PAREN
%token CLOSE_PAREN
%token OPEN_BRACE
%token CLOSE_BRACE

%token ALOG_EQUAL
%token ALOG_ADD
%token ALOG_SUB
%token ALOG_MUL
%token ALOG_DIV
%token ALOG_AND
%token ALOG_OR
%token LOGI_AND
%token LOGI_OR
%token LOGI_NOT

%token FOR
%token IF

%token DEC_DIGIT
%token HEX_DIGIT
%token INPUTCHAR
%token IDENTIFIER

%left ALOG_ADD ALOG_SUB
%left ALOG_MUL ALOG_DIV
%left ALOG_AND ALOG_OR
%%
statement:
    statement expr SEMIC{printf("result:%d\n",$2);}
    |
    ;
expr:
    DEC_DIGIT{$$=$1};
    |expr ALOG_MUL expr{$$=$1*$3;}
    |expr ALOG_DIV expr{$$=$1/$3;}
    |expr ALOG_AND expr{$$=$1&$3;}
    |expr ALOG_OR  expr{$$=$1|$3;}
    |expr ALOG_ADD expr{$$=$1+$3;}
    |expr ALOG_SUB expr{$$=$1-$3;}
    ;

declration:
    type IDENTIFIER ALOG_EQUAL DEC_DIGIT{$$=$4;}
type:
    INT
    ;
%%


void yyerror(char *s){
    printf("Error:%s\n",s);
    exit(1);
}
int main(){
    yyparse();
    return 0;
}