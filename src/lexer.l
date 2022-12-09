%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "string.h"
  #include "hashmap.h"
  #include "stack.h"
  #include "node.h"
  #include "variable.h"
  #include "str_aux.h"
  #include "y.tab.h"

  void yyerror (const char *msg);
  int charPos = 1;
  #define ADJ (charPos+=yyleng)
%}

%option yylineno

digit [0-9]
id [A-Za-z][A-Za-z0-9_]*

%%

[ \t]                 { ADJ;}
\n                    { charPos = 0; }
func                  { ADJ; return FUNC;}
var                   { ADJ; return VAR;}
for                   { ADJ; return FOR;}
while                 { ADJ; return WHILE;}
struct                { ADJ; return STRUCT;}
return                { ADJ; return RETURN;}
break                 { ADJ; return BREAK;}
continue              { ADJ; return CONTINUE;}
if                    { ADJ; return IF;}
elif                  { ADJ; return ELIF; }
else                  { ADJ; return ELSE;}
read                  { ADJ; return READ;}
print                 { ADJ; return PRINT;}
int_to_string         { ADJ; return INT_TO_STRING;}
double_to_string      { ADJ; return DOUBLE_TO_STRING;}
bool_to_string        { ADJ; return BOOL_TO_STRING;}
length                { ADJ; return LENGTH;}

\"([^\\\"]|\\.)*\"         { ADJ; yylval.sValue = strdup(yytext);
                             return STRING_LITERAL; }
(\+|\-)?{digit}+           { ADJ; yylval.iValue = atoi(yytext); 
                             return INTEGER_LITERAL; }
(\+|\-)?{digit}+\.{digit}+ { ADJ; yylval.dValue = strtod(yytext, NULL);
                             return DOUBLE_LITERAL; }
(true|false)               { ADJ; yylval.sValue = strdup(yytext);
                             return BOOL_LITERAL; }

\+                         { ADJ; return '+'; }
\-                         { ADJ; return '-'; }
\*                         { ADJ; return '*'; }
\/                         { ADJ; return '/'; }
\%                         { ADJ; return '%';}
\*\*                       { ADJ; return EXP_OP; }
==                         { ADJ; return EQ_OP; }
\!=                        { ADJ; return DIFF_OP; }
\>                         { ADJ; return '>'; }
\>=                        { ADJ; return GTE_OP; }
\<                         { ADJ; return '<'; }
\<=                        { ADJ; return LTE_OP; }
\&                         { ADJ; return '&';}
\+\+                       { ADJ; return CONCAT_OP; }
\|\|                       { ADJ; return OR_OP; }
\&&                        { ADJ; return AND_OP; }
and                        { ADJ; return AND_NAMED_OP; }
or                         { ADJ; return OR_NAMED_OP; }
\=                         { ADJ; return '='; }
\+=                        { ADJ; return PLUS_ASSIGN_OP; }
\-=                        { ADJ; return MINUS_ASSIGN_OP; }
\*=                        { ADJ; return MULT_ASSIGN_OP; }
\/=                        { ADJ; return DIV_ASSIGN_OP; }
\!                         { ADJ; return '!'; }

{id}	{ ADJ; yylval.sValue = strdup(yytext); 
                       return IDENTIFIER;}
\(                         { ADJ; return '('; }
\)                         { ADJ; return ')'; }
\[                         { ADJ; return '['; }
\]                         { ADJ; return ']'; }
\{                         { ADJ; return '{'; }
\}                         { ADJ; return '}'; }
"."                        { ADJ; return '.'; }
","                        { ADJ; return ','; }
":"                        { ADJ; return ':'; }
";"                        { ADJ; return ';'; }
(\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/)|(\/\/.*) { ADJ; } /*Comentario*/
.                      { ADJ; yyerror("invalid character");}

%%

#ifndef yywrap

int yywrap (void){
    return 1;
}

#endif
