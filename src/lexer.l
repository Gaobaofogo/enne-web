%{
  #include <stdio.h>
  #include "y.tab.h"

  void yyerror (const char *msg);
  int charPos = 1;
  #define ADJ (charPos+=yyleng)
%}

%option yylineno

digit [0-9]
id [A-Za-z][A-Za-z0-9_]*

%%

[\t]                      { ADJ; printf("\t");}
[ ]                        { ADJ; printf(" ");}
\n                         { charPos = 0; printf("\n"); }
func                       { ADJ; printf("%s ", "FUNC"); return FUNC;}
var                        { ADJ; printf("%s ", "VAR");return VAR;}
for                        { ADJ; printf("%s ", "FOR"); return FOR;}
while                      { ADJ; printf("%s ", "WHILE"); return WHILE;}
struct                     { ADJ; printf("%s ", "STRUCT"); return STRUCT;}
return                     { ADJ; printf("%s ", "RETURN"); return RETURN;}
break                      { ADJ; printf("%s ", "BREAK"); return BREAK;}
continue                   { ADJ; printf("%s ", "CONTINUE"); return CONTINUE;}
if                         { ADJ; printf("%s ", "IF"); return IF;}
elif                       { ADJ; printf("%s ", "ELIF"); return ELIF; }
else                       { ADJ; printf("%s ", "ELSE"); return ELSE;}
read                       { ADJ; printf("%s ", "READ"); return READ;}
print                      { ADJ; printf("%s ", "PRINT"); return PRINT;}
int_to_string              { ADJ; printf("%s ", "INT_TO_STRING"); return INT_TO_STRING;}
double_to_string           { ADJ; printf("%s ", "DOUBLE_TO_STRING"); return DOUBLE_TO_STRING;}

\"([^\\\"]|\\.)*\"         { ADJ; printf("STRING_LITERAL(%s) ", yytext); yylval.sValue = strdup(yytext);
                             return STRING_LITERAL; }
(\+|\-)?{digit}+           { ADJ; printf("INTEGER_LITERAL(%s) ", yytext); yylval.iValue = atoi(yytext); 
                             return INTEGER_LITERAL; }
(\+|\-)?{digit}+\.{digit}+ { ADJ; printf("DOUBLE_LITERAL(%s) ", yytext); yylval.dValue = strtod(yytext, NULL);
                             return DOUBLE_LITERAL; }
(true|false)               { ADJ; printf("BOOL_LITERAL(%s) ", yytext); yylval.sValue = strdup(yytext);
                             return BOOL_LITERAL; }

\+                         { ADJ; printf("%s ", "+"); return '+'; }
\-                         { ADJ; printf("%s ", "-"); return '-'; }
\*                         { ADJ; printf("%s ", "*"); return '*'; }
\/                         { ADJ; printf("%s ", "/"); return '/'; }
\*\*                       { ADJ; printf("%s ", "*");return EXP_OP; }
==                         { ADJ; printf("%s ", "==");return EQ_OP; }
\!=                        { ADJ; printf("%s ", "!=");return DIFF_OP; }
\>                         { ADJ; printf("%s ", ">"); return '>'; }
\>=                        { ADJ; printf("%s ", ">="); return GTE_OP; }
\<                         { ADJ; printf("%s ", "<"); return '<'; }
\<=                        { ADJ; printf("%s ", "<="); return LTE_OP; }
\+\+                       { ADJ; printf("%s ", "++");return CONCAT_OP; }
\|\|                       { ADJ; printf("%s ", "||"); return OR_OP; }
\&&                        { ADJ; printf("%s ", "&&"); return AND_OP; }
and                        { ADJ; printf("%s ", "AND"); return AND_NAMED_OP; }
or                         { ADJ; printf("%s ", "OR"); return OR_NAMED_OP; }
\=                         { ADJ; printf("%s ", "="); return '='; }
\+=                        { ADJ; printf("%s ", "+="); return PLUS_ASSIGN_OP; }
\-=                        { ADJ; printf("%s ", "-="); return MINUS_ASSIGN_OP; }
\*=                        { ADJ; printf("%s ", "*="); return MULT_ASSIGN_OP; }
\/=                        { ADJ; printf("%s ", "/="); return DIV_ASSIGN_OP; }
\!                         { ADJ; printf("%s ", "!"); return '!'; }

{id}	{ ADJ; printf("IDENTIFIER(%s)", yytext); yylval.sValue = strdup(yytext); 
                       return IDENTIFIER;}
\(                         { ADJ; printf("%s ", "("); return '('; }
\)                         { ADJ; printf("%s ", ")"); return ')'; }
\[                         { ADJ; printf("%s ", "["); return '['; }
\]                         { ADJ; printf("%s ", "]"); return ']'; }
\{                         { ADJ; printf("%s ", "{"); return '{'; }
\}                         { ADJ; printf("%s ", "}"); return '}'; }
"."                        { ADJ; printf("%s ", "."); return '.'; }
","                        { ADJ; printf("%s ", ","); return ','; }
":"                        { ADJ; printf("%s ", ":"); return ':'; }
";"                        { ADJ; printf("%s ", ";"); return ';'; }
\/\/.*                     { ADJ;} /*Comentario*/
.                      { ADJ; yyerror("invalid character");}

%%

#ifndef yywrap

int yywrap (void){
    return 1;
}

#endif

int main() {
  int token;
  while (token = yylex()) {}
  return 0;
}
