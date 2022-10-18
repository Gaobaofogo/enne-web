%{
#include <stdio.h>

int yylex(void);
void yyerror (const char *msg);
extern int yylineno;
extern char * yytext;

%}

%union {
	int    iValue; 	/* integer value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
	};

%token <sValue> IDENTIFIER
%token <iValue> INTEGER_LITERAL
%token FUNC VAR FOR WHILE STRUCT RETURN BREAK CONTINUE IF ELSE
%token STRING_LITERAL DOUBLE_LITERAL BOOL_LITERAL
%token '&' '=' PLUS_ASSIGN_OP MINUS_ASSIGN_OP MULT_ASSIGN_OP DIV_ASSIGN_OP '!'
%left OR_OP OR_NAMED_OP
%left AND_OP AND_NAMED_OP
%nonassoc '>' GTE_OP '<' LTE_OP EQ_OP DIFF_OP
%token '(' ')' '[' ']' '{' '}' '.' ',' ':' ';'
%left CONCAT_OP
%left '+' '-'
%left '*' '/' '%'
%left U_MINUS_OP U_NOT_OP
%right EXP_OP

%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF */

prog : decs {} 
	;

decs : {}
     | dec decs {}
     ;

cmd_simp :
          dec {}
         | cond {}
         /* | loop {}
         | assignment ';' {}
         | io ';' {}
         | return return {}
         | exp ';' {}
         | goto identifier ';' {}
         | break ';' {}
         | continue ';'
         ; */
         
if : IF '(' exp ')' '{'  elseif else '}' {} // BLock
   ;

elseif : {}
       | ELIF '(' exp ')' '{' block elseif // TODO: block 
       ;

else : ELSE  {} // Block
     | {}
     ;

dec : FUNC IDENTIFIER '(' args ')' '{' '}' {}
    | VAR init_declarator ';' {}
    | VAR init_declarator '=' exp ';' {}
    ;

args : {}
     | args_specifier
     ;

args_specifier : IDENTIFIER {}
               | args_specifier ',' IDENTIFIER
               ;

init_declarator : IDENTIFIER {}
                | init_declarator '[' ']' {} // Tem que botar uma expressão aí no meio
                ;

exp : '-' exp                         %prec U_MINUS_OP {}
    | '!' exp                         %prec U_NOT_OP   {}
    | exp '+' exp                         {}
    | exp '-' exp                         {}
    | exp '*' exp                         {}
    | exp '/' exp                         {}
    | exp '%' exp                         {}
    | exp EXP_OP exp                      {}
    | exp AND_OP exp                      {}
    | exp OR_OP  exp                      {}
    | exp AND_NAMED_OP exp                {}
    | exp OR_NAMED_OP  exp                {}
    | exp '>' exp                         {}
    | exp GTE_OP exp                      {}
    | exp '<' exp                         {}
    | exp LTE_OP exp                      {}
    | exp EQ_OP exp                       {}
    | exp DIFF_OP exp                     {}
    | exp CONCAT_OP exp                   {}
    | func_call                           {}
    | assignable                          {}
    | literal                             {}
    | '(' exp ')'                         {}
    ;

func_call : IDENTIFIER '(' params ')' {}
          ;

params : {}
       | exp remaining_params {}
       ;

remaining_params : {}
               | ',' exp remaining_params {}
               ;

assignable : IDENTIFIER {}
           | IDENTIFIER '[' exp ']' access {}
           | IDENTIFIER '.' IDENTIFIER access {}
           ;

access : {}
       | '.' IDENTIFIER access {}
       | '[' exp ']' access {}
       ;

literal : INTEGER_LITERAL {}
        | DOUBLE_LITERAL {}
        | STRING_LITERAL {}
        | BOOL_LITERAL {}
        /* | array_literal {}
        | struct_literal {} */
        ;

%% /* Fim da segunda seção */

int main (void) {
	return yyparse();
}

void yyerror (const char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
}
