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
%token STRING_LITERAL INTEGER_LITERAL DOUBLE_LITERAL BOOL_LITERAL
%token CONCAT_OP '&' OR_OP AND_OP '=' PLUS_ASSIGN_OP MINUS_ASSIGN_OP MULT_ASSIGN_OP DIV_ASSIGN_OP '!'
%nonassoc '>' GTE_OP '<' LTE_OP EQ_OP DIFF_OP
%token '(' ')' '[' ']' '{' '}' '.' ',' ':' ';'
%left '+' '-'
%left '*' '/'
%left U_MINUS_OP U_NOT_OP
%right EXP_OP

%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF */

prog : dec                            {} 
     | prog dec
	   ;

dec : func_declaration {}
    | var_dec          {}
    ;

func_declaration : FUNC IDENTIFIER '(' args ')' '{' '}' {}
                 ;

args : {}
     | args_specifier
     ;

args_specifier : IDENTIFIER {}
               | args_specifier ',' IDENTIFIER
               ;

var_dec : VAR init_declarator ';' {}
        ;

init_declarator : IDENTIFIER {}
                | init_declarator '[' ']' {} // Tem que botar uma expressão aí no meio
                ;

%% /* Fim da segunda seção */

int main (void) {
	return yyparse();
}

void yyerror (const char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
}
