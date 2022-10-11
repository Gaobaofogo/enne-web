%{
  #include <stdio.h>
  #include "y.tab.h"
  
  extern void yyerror (const char *msg);
%}

%%

[ \t\n]               ;
[0-9]+           	    {yylval.iValue = atoi(yytext); 
                       return INTEGER_LITERAL;}
";"      				      {return(';');}
"+"                   {return('+');}
"*"                   {return('*');}
"="					          {return '=';}
[a-zA-Z][a-zA-Z0-9]*	{yylval.sValue = strdup(yytext); 
                       return IDENTIFIER;}
.                      {yyerror("invalid character");}

%%

#ifndef yywrap

int yywrap (void){
    return 1;
}

#endif
