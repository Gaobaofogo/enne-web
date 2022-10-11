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
%token '=' ';'
%left '+'
%left '*'

%start prog

%type <sValue> stm

%% /* Inicio da segunda seção, onde colocamos as regras BNF */

prog : stmlist                            {} 
	 ;

stmlist : stm						              		{}
		| stmlist stm             				    {}
	  ;

stm : IDENTIFIER '=' exp ';'  {}
	  ;

exp : exp '+' term                    {}
    | term                                {}
    ;

term : term '*' factor                {}
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
