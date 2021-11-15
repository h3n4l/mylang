%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define FATAL -1
int yylex(void);
void yyerror(char*);   

    union value{
    int         iValue;
    unsigned    uValue;
    double      dValue;
    char        cValue;
    char*       sValue;
    };
    struct symtbl{
        char* name;
        union value lex_value;
        struct symtbl* next;
        int type;
    };
    void logmsg(char *msg);
    struct symtbl* findInTable(char* identifer_name);
    int addInTable(char* identifer_name, union value input_value,int type);
    struct symtbl* mytbl = NULL;

    
%}
// yylval and YYSTYPE
%union{
    char*       name;
    // type
    
    int         iValue;
    unsigned    uValue;
    double      dValue;
    char        cValue;
    char*       sValue;
}
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

%token <iValue>DEC_DIGIT
%token <iValue>HEX_DIGIT
%token <dValue>DECIMAL
%token INPUTCHAR
%token <name>IDENTIFIER

%left ALOG_ADD ALOG_SUB
%left ALOG_MUL ALOG_DIV
%left ALOG_AND ALOG_OR

%type <iValue> intExpr
%type <dValue> doubleExpr
%type <iValue> intValue 
%%
%start statement;

statement:
    statement intExpr SEMIC{printf("result:%d\n",$2);}
    |statement doubleExpr SEMIC{printf("result:%lf\n",$2);}
    |statement intAssignment{printf("intassignment;\n");}
    |
    ;

intAssignment:
    INT IDENTIFIER ALOG_EQUAL intExpr SEMIC{
        logmsg("New assignment");
        union value v;
        v.iValue= $4;
        addInTable($2,v,INT);
    }
    | IDENTIFIER ALOG_EQUAL intExpr SEMIC{
        // modify exist assignment's value
        struct symtbl* tbl = findInTable($1);
        if(tbl->type!=INT){
            yyerror("Expected an int identifier\n");
        }
        tbl->lex_value.iValue = $3;
        logmsg("Change existed assignment's value");
    }
    ;

intValue:
    DEC_DIGIT{$$=$1}
    |HEX_DIGIT{$$=$1}
    |IDENTIFIER{

        
        struct symtbl * tbl = findInTable($1);
        if(tbl->type != INT){
            yyerror("Expected an int identifier\n");
        }
        $$=tbl->lex_value.iValue;
    }
    ;

intExpr:
    intValue{$$=$1}
    |intExpr ALOG_MUL intExpr{$$=$1*$3;}
    |intExpr ALOG_DIV intExpr{$$=$1/$3;}
    |intExpr ALOG_AND intExpr{$$=$1&$3;}
    |intExpr ALOG_OR  intExpr{$$=$1|$3;}
    |intExpr ALOG_ADD intExpr{$$=$1+$3;}
    |intExpr ALOG_SUB intExpr{$$=$1-$3;}
    ;

doubleExpr:
    DECIMAL{$$=$1}
    |doubleExpr ALOG_MUL doubleExpr{$$=$1*$3;}
    |doubleExpr ALOG_DIV doubleExpr{$$=$1/$3;}
    |doubleExpr ALOG_ADD doubleExpr{$$=$1+$3;}
    |doubleExpr ALOG_SUB doubleExpr{$$=$1-$3;}
    ;
    
%%

struct symtbl* findInTable(char* identifer_name){
    struct symtbl* t = mytbl;
    for(;t!=NULL;t=t->next){
        if(strcmp(t->name,identifer_name)== 0){
            return t;
        }
    }
    printf("Error: Undefine identifier: %s\n",identifer_name);
    exit(FATAL);
}

int addInTable(char* identifer_name, union value input_value,int type){
    // find the last
    logmsg("Call Add In Table");
    struct symtbl* sp;
    struct symtbl* t = mytbl;
    for(;t!=NULL;t=t->next){
        if(strcmp(t->name,identifer_name) == 0){
            printf("Error: duplicate identifer name : %s\n",identifer_name);
            exit(FATAL);
        }
    }
    sp = malloc(sizeof(struct symtbl));
    memset(sp,0,sizeof(struct symtbl));
    sp->name = strdup(identifer_name);
    sp->lex_value = input_value;
    sp->next = mytbl;
    sp->type = type;
    mytbl = sp;
    logmsg("Call Add In Table Return");
    return 0;
}

void logmsg(char *msg){
    printf("\033[032m[LOG]: %s \033[0m\n",msg);
}

void yyerror(char *s){
    printf("Error:%s\n",s);
    exit(1);
}

int main(){
    yyparse();
    return 0;
}