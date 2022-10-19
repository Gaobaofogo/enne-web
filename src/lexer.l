%{
  #include <stdio.h>
  #include "y.tab.h"
  
  extern void yyerror (const char *msg);
%}

digit [0-9]
id [A-Za-z][A-Za-z0-9_]*

%%

[ \t\n]               ;

func                  { return FUNC;}
var                   { return VAR;}
for                   { return FOR;}
while                 { return WHILE;}
struct                { return STRUCT;}
return                { return RETURN;}
break                 { return BREAK;}
continue              { return CONTINUE;}
if                    { return IF;}
elif                  { return ELIF; }
else                  { return ELSE;}
read                  { return READ;}
print                 { return PRINT;}

\"([^\\\"]|\\.)*\"         { return STRING_LITERAL; }
(\+|\-)?{digit}+           { yylval.iValue = atoi(yytext); 
                             return INTEGER_LITERAL; }
(\+|\-)?{digit}+\.{digit}+ { return DOUBLE_LITERAL; }
(true|false)               { return BOOL_LITERAL; }

\+                         { return '+'; }
\-                         { return '-'; }
\*                         { return '*'; }
\/                         { return '/'; }
\*\*                       { return EXP_OP; }
==                         { return EQ_OP; }
\!=                        { return DIFF_OP; }
\>                         { return '>'; }
\>=                        { return GTE_OP; }
\<                         { return '<'; }
\<=                        { return LTE_OP; }
\+\+                       { return CONCAT_OP; }
\&                         { return '&'; }
\|\|                       { return OR_OP; }
\&&                        { return AND_OP; }
and                        { return AND_NAMED_OP; }
or                         { return OR_NAMED_OP; }
\=                         { return '='; }
\+=                        { return PLUS_ASSIGN_OP; }
\-=                        { return MINUS_ASSIGN_OP; }
\*=                        { return MULT_ASSIGN_OP; }
\/=                        { return DIV_ASSIGN_OP; }
\!                         { return '!'; }

{id}	{yylval.sValue = strdup(yytext); 
                       return IDENTIFIER;}
\(                         { return '('; }
\)                         { return ')'; }
\[                         { return '['; }
\]                         { return ']'; }
\{                         { return '{'; }
\}                         { return '}'; }
"."                        { return '.'; }
","                        { return ','; }
":"                        { return ':'; }
";"                        { return ';'; }
\/\/.*                     {;} /*Comentario*/
.                      {yyerror("invalid character");}

%%

#ifndef yywrap

int yywrap (void){
    return 1;
}

#endif
