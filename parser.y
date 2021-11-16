%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define DEBUG 0
#define BUFSZ 1024
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
        union value parser_value;
        struct symtbl* next;
        int type;
    };
    // about symtbl function
    struct symtbl* findInTable(char* identifer_name);
    int addInTable(char* identifer_name, union value input_value,int type);
    void checkType(int in, int correct);
    // log function
    void inputPrompt();
    void logmsg(char *msg);
    // some vars
    struct symtbl* mytbl = NULL;
    FILE *yyin;
    FILE* yyout;
    
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

%token IINPUT_FUNC

%left ALOG_ADD ALOG_SUB
%left ALOG_MUL ALOG_DIV
%left ALOG_AND ALOG_OR

%type <iValue> intExpr
%type <dValue> doubleExpr
%type <iValue> intValue 
%%
%start statement;

statement:
    statement intExpr SEMIC{
        printf("%d\n",$2); 
    }
    |statement doubleExpr SEMIC{
        printf("result:%lf\n",$2);
    }
    |statement intAssignment SEMIC
    |statement inputFunc SEMIC
    |
    ;

intAssignment:
    INT IDENTIFIER ALOG_EQUAL intExpr{
        logmsg("New assignment");
        union value v;
        v.iValue= $4;
        addInTable($2,v,INT);
    }
    | IDENTIFIER ALOG_EQUAL intExpr{
        // modify exist assignment's value
        struct symtbl* tbl = findInTable($1);
        if(tbl->type!=INT){
            yyerror("Expected an int identifier\n");
        }
        tbl->parser_value.iValue = $3;
        logmsg("Modify existed assignment's value");
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
        $$=tbl->parser_value.iValue;
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

inputFunc:
    IDENTIFIER ALOG_EQUAL IINPUT_FUNC{
        // find symtbl entry
        struct symtbl* tbl = findInTable($1);
        checkType(tbl->type,INT);
        int t = 0;
        inputPrompt();
        scanf("%d",&t);
        tbl->parser_value.iValue = t;
    }
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
    sp->parser_value = input_value;
    sp->next = mytbl;
    sp->type = type;
    mytbl = sp;
    logmsg("Call Add In Table Return");
    return 0;
}

void checkType(int in, int correct){
    if(in != correct){
        yyerror("Uncorrect type\n");
    }
    return;
}

void logmsg(char *msg){
    if(DEBUG){
        printf("\033[032m[LOG]: %s \033[0m\n",msg);
    }
}

void yyerror(char *s){
    printf("Error:%s\n",s);
    exit(1);
}

void inputPrompt(){
    printf("\033[031m>\033[0m");
}
int main(int argc, char* argv[]){
    if(argc < 2){
        fprintf(stderr,"Usage:\n");
        fprintf(stderr,"\t./parser <inputFile>\n");
        exit(FATAL);
    }
    yyin = fopen(argv[1],"r");
    yyout = stdout;
    yyparse();
    return 0;
}