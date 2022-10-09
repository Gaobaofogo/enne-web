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
%token ASSIGN_OP PLUS_OP MULT_OP SEMICOLON LEFT_PAREN RIGHT_PAREN

%start prog

%type <sValue> stm

%% /* Inicio da segunda seção, onde colocamos as regras BNF */

prog : stmlist                            {} 
	 ;

stmlist : stm						              		{}
		| stmlist stm             				    {}
	  ;

stm : IDENTIFIER ASSIGN_OP exp SEMICOLON  {}
	  ;

exp : exp PLUS_OP term                    {}
    | term                                {}
    ;

term : term MULT_OP factor                {}
     | factor                             {}
     ;

factor : IDENTIFIER                       {}
       | INTEGER_LITERAL                  {}
       ;
	

%% /* Fim da segunda seção */

int main (void) {
	return yyparse();
}

void yyerror (const char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
}
