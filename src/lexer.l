%{
  #include <stdio.h>
  #include "y.tab.h"
  
/*   extern int yyerror (char *msg);   */
%}

%%

[ \t\n]               ;
[0-9]+           	    {yylval.iValue = atoi(yytext); 
                       return INTEGER_LITERAL;}
";"      				      {return(SEMICOLON);}
"+"                   {return(PLUS_OP);}
"*"                   {return(MULT_OP);}
"="					          {return ASSIGN_OP;}
[a-zA-Z][a-zA-Z0-9]*	{yylval.sValue = strdup(yytext); 
                       return IDENTIFIER;}
.                      {yyerror("invalid character");}

%%

#ifndef yywrap

int yywrap (void){
    return 1;
}

#endif
