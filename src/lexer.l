%{
  #include <stdio.h>

  void yyerror (const char *msg);
  int charPos = 0;
  #define ADJ (charPos+=yyleng)
%}

%option yylineno

digit [0-9]
id [A-Za-z][A-Za-z0-9_]*

%%

[\t]                       { ADJ; printf("\t");                     }
[ ]                        { ADJ; printf(" ");                      }
\n                         { charPos = 0; printf("\n");             }
func                       { ADJ; printf("%s", "FUNC");             }
var                        { ADJ; printf("%s", "VAR");              }
for                        { ADJ; printf("%s", "FOR");              }
while                      { ADJ; printf("%s", "WHILE");            }
struct                     { ADJ; printf("%s", "STRUCT");           }
return                     { ADJ; printf("%s", "RETURN");           }
break                      { ADJ; printf("%s", "BREAK");            }
continue                   { ADJ; printf("%s", "CONTINUE");         }
if                         { ADJ; printf("%s", "IF");               }
elif                       { ADJ; printf("%s", "ELIF");             }
else                       { ADJ; printf("%s", "ELSE");             }
read                       { ADJ; printf("%s", "READ");             }
print                      { ADJ; printf("%s", "PRINT");            }
int_to_string              { ADJ; printf("%s", "INT_TO_STRING");    }
double_to_string           { ADJ; printf("%s", "DOUBLE_TO_STRING"); }

\"([^\\\"]|\\.)*\"         { ADJ; printf("STRING_LITERAL(%s)", yytext);  }
(\+|\-)?{digit}+           { ADJ; printf("INTEGER_LITERAL(%s)", yytext); }
(\+|\-)?{digit}+\.{digit}+ { ADJ; printf("DOUBLE_LITERAL(%s)", yytext);  }
(true|false)               { ADJ; printf("BOOL_LITERAL(%s)", yytext);    }

\+                         { ADJ; printf("%s", "+");   }
\-                         { ADJ; printf("%s", "-");   }
\*                         { ADJ; printf("%s", "*");   }
\/                         { ADJ; printf("%s", "/");   }
\*\*                       { ADJ; printf("%s", "*");   }
==                         { ADJ; printf("%s", "==");  }
\!=                        { ADJ; printf("%s", "!=");  }
\>                         { ADJ; printf("%s", ">");   }
\>=                        { ADJ; printf("%s", ">=");  }
\<                         { ADJ; printf("%s", "<");   }
\<=                        { ADJ; printf("%s", "<=");  }
\+\+                       { ADJ; printf("%s", "++");  }
\|\|                       { ADJ; printf("%s", "||");  }
\&&                        { ADJ; printf("%s", "&&");  }
and                        { ADJ; printf("%s", "AND"); }
or                         { ADJ; printf("%s", "OR");  }
\=                         { ADJ; printf("%s", "=");   } 
\+=                        { ADJ; printf("%s", "+=");  }
\-=                        { ADJ; printf("%s", "-=");  }
\*=                        { ADJ; printf("%s", "*=");  }
\/=                        { ADJ; printf("%s", "/=");  }
\!                         { ADJ; printf("%s", "!");   }

{id}	                     { ADJ; printf("IDENTIFIER(%s)", yytext); }

\(                         { ADJ; printf("%s", "(");  }
\)                         { ADJ; printf("%s", ")");  }
\[                         { ADJ; printf("%s", "[");  }
\]                         { ADJ; printf("%s", "]");  }
\{                         { ADJ; printf("%s", "{");  }
\}                         { ADJ; printf("%s", "}");  }
"."                        { ADJ; printf("%s", ".");  }
","                        { ADJ; printf("%s", ",");  }
":"                        { ADJ; printf("%s", ":");  }
";"                        { ADJ; printf("%s", ";");  }
(\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/)|(\/\/.*) { ADJ; printf("COMMENT(%s)", yytext); }
.                      { ADJ; yyerror("invalid character"); }

%%

#ifndef yywrap

int yywrap (void){
    return 1;
}

#endif

void yyerror (const char *msg) {
	fprintf (stderr, "%s '%s' founded at %d:%d\n", msg, yytext, yylineno, charPos);
}

int main() {
  yylex();

  return 1;
  
}
