%{
#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "hashmap.h"
#include "stack.h"
#include "node.h"
#include "variable.h"
#include "str_aux.h"

int yylex(void);
void yyerror (const char *msg);
extern int yylineno;
extern char * yytext;
extern int charPos;

char* scope = "";
char* DEFAULT_CODE = "\0";
int DEFAULT_SIZE = 2;

void concat_code(char *code, char *new_code) {
  code = (char *)realloc(code, strlen(code) + strlen(new_code) + 1);
  sprintf(code, "%s%s", code, new_code);
}


ht* symbol_table;
Stack* context_stack;

%}

%union {
	int     iValue;
  double  dValue;
	char*   sValue;
  Node    node;
};

%token <sValue> IDENTIFIER STRING_LITERAL BOOL_LITERAL
%token <iValue> INTEGER_LITERAL
%token <dValue> DOUBLE_LITERAL
%token FUNC VAR FOR WHILE STRUCT RETURN BREAK CONTINUE IF ELIF ELSE
%token READ PRINT INT_TO_STRING DOUBLE_TO_STRING BOOL_TO_STRING LENGTH AMPERSAND
%token '=' PLUS_ASSIGN_OP MINUS_ASSIGN_OP MULT_ASSIGN_OP DIV_ASSIGN_OP '!'
%left OR_OP OR_NAMED_OP
%left AND_OP AND_NAMED_OP
%nonassoc '>' GTE_OP '<' LTE_OP EQ_OP DIFF_OP
%token '(' ')' '[' ']' '{' '}' '.' ',' ':' ';'
%left CONCAT_OP
%left '+' '-'
%left '*' '/' '%'
%left U_MINUS_OP U_NOT_OP
%right EXP_OP

%type <sValue> io decs dec block cmd var_dec init_declarator_list
%type <node> literal init_declarator exp

%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF */

prog : { push(context_stack, "global"); } decs
     {
      pop(context_stack);
      FILE *out_file = fopen("codigo_intermediario.c", "w");
      fprintf(out_file, "#include <math.h>\n#include \"str_aux.h\"\n#include <stdio.h>\n#include \"node.h\"\n#include \"variable.h\"\n%s", $2);
     } 
	   ;

decs :
     {
      $$ = "";
     }
     | dec decs
     {
      char *teste = (char *)malloc(sizeof(char) * DEFAULT_SIZE);
      concat_code(teste, $1);
      concat_code(teste, $2);

      $$ = teste;
     }
     ;

cmd : dec { $$ = $1; }
    | if {}
    | loop {}
    | assignment ';' {}
    | io ';' { $$ = $1; }
    | RETURN return {}
    | exp ';' {}
    | BREAK ';' {}
    | CONTINUE ';' {}
    ; 

io : READ '(' assignable ')' { }
   | PRINT '(' exp ')'
   { 
      char *teste = (char *)malloc(sizeof(char) * 8);
      concat_code(teste, "printf(");
      concat_code(teste, "alala");
      /* concat_code(teste, $3); */
      concat_code(teste, ");\n");

      $$ = teste;
   }
   ;

return : ';' {}
       | exp ';' {}
       ;

block :
      {
        $$ = "";
      }
      | block  cmd
      {
        char *teste = (char *)malloc(sizeof(char) * DEFAULT_SIZE);
        concat_code(teste, $1);
        concat_code(teste, $2);
        $$ = teste;
      }
      ;

if : IF '(' exp ')' '{' block '}' elseif else {}
   ;

elseif : {}
       | ELIF '(' exp ')' '{' block '}' elseif {}
       ;

else : ELSE '{' block '}' {}
     | {}
     ;

loop : while {}
     | for {}
     ;

while : WHILE '(' exp ')' '{' block '}' {}
      ;

for : FOR '(' for_left for_middle for_right ')' '{' block '}' {}
    ;

for_left : var_dec {}
         | assignment ';' {}
         | ';' {}
         ;

for_middle : exp ';' {}
           | ';' {}
           ;

for_right : exp {}
          | assignment {}
          | {}
          ;

assignment : assignable '=' exp {}
           | assignable PLUS_ASSIGN_OP exp {}
           | assignable MINUS_ASSIGN_OP exp {}
           | assignable DIV_ASSIGN_OP exp {}
           | assignable MULT_ASSIGN_OP exp {}
           ;

dec : FUNC IDENTIFIER { push(context_stack, $2); } '(' args ')' '{' block '}'
      {
        pop(context_stack);
        char* name = get_scope(context_stack);
        concat_code(name, $2);
        ht_set(symbol_table, name, name);
        char *teste = (char *)malloc(sizeof(char) * DEFAULT_SIZE);
        concat_code(teste, "int ");
        concat_code(teste, $2);
        concat_code(teste, " () {\n");
        concat_code(teste, $8);
        concat_code(teste, "}\n");
        
        $$ = teste;
      }
    | STRUCT IDENTIFIER '{' struct_fields '}' {}
    | var_dec { $$ = $1;}
    ;

args : {}
     | args_specifier
     ;

args_specifier : reference_ampersand IDENTIFIER {}
               | args_specifier ',' reference_ampersand IDENTIFIER
               ;

reference_ampersand : {}
                    | '&'
                    ;

struct_fields : {}
       | field struct_fields {}
       ;

field : IDENTIFIER ';' {}
      ;

var_dec : VAR init_declarator_list ';'
        {
          $$ = $2;
        }
        | VAR init_declarator '=' exp ';' {
          char* code;
          code = cat($4.codigo, "\nNode ", $2.var.name, ";\n", create_attr_code(&$2, &$4));
          $$ = code;
        }
        ;

init_declarator_list : init_declarator
                     {
                      char *code = cat("Node ", $1.var.name, ";\n", "", "");
                      $$ = code;
                     }
                     | init_declarator ',' init_declarator_list {}
                     ;

init_declarator : IDENTIFIER 
                {
                  char* nome_com_escopo = get_scope(context_stack);
                  concat_code(nome_com_escopo, $1);

                  Node n;
                  n.var.name = cat(nome_com_escopo, "", "", "", "");

                  free(nome_com_escopo);

                  ht_set(symbol_table, n.var.name, n.var.name);
                  $$ = n;
                }
                | init_declarator '[' exp ']' {}
                ;

exp : '-' exp                         %prec U_MINUS_OP {}
    | '!' exp                         %prec U_NOT_OP   {}
    | exp '+' exp                         {
      Node n;
      n.left = &$1;
      n.right = &$3;
      n.op = "+";
      n.codigo = cat(generate_op_code(&n), "", "", "", "");
      $$ = n;
    }
    | exp '-' exp                         {
      Node n;
      n.left = &$1;
      n.right = &$3;
      n.op = "-";
      n.codigo = cat(generate_op_code(&n), "", "", "", "");
      $$ = n;
    }
    | exp '*' exp                         {
      Node n;
      n.left = &$1;
      n.right = &$3;
      n.op = "*";
      n.codigo = cat(generate_op_code(&n), "", "", "", "");
      $$ = n;
    }
    | exp '/' exp
    {
      Node n;
      n.left = &$1;
      n.right = &$3;
      n.op = "/";
      n.codigo = cat(generate_op_code(&n), "", "", "", "");
      $$ = n;
    }
    | exp EXP_OP exp                      {
      Node n;
      n.left = &$1;
      n.right = &$3;
      n.op = "**";
      n.codigo = cat(generate_op_code(&n), "", "", "", "");
      $$ = n;
    }
    | exp '%' exp                         {}
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
    | literal
    {
      $$ = $1;
    }
    | builtin_functions                   {}
    | '(' exp ')'                         {}
    ;

builtin_functions : INT_TO_STRING '(' exp ')'    {}
                  | DOUBLE_TO_STRING '(' exp ')' {}
                  | BOOL_TO_STRING '(' exp ')'   {}
                  | LENGTH '(' assignable ')'    {}
                  ;


func_call : IDENTIFIER '(' params ')' {}
          ;

params : {}
       | exp remaining_params {}
       ;

remaining_params :                        {}
               | ',' exp remaining_params {}
               ;

assignable : IDENTIFIER                       {}
           | IDENTIFIER '[' exp ']' access    {}
           | IDENTIFIER '.' IDENTIFIER access {}
           ;

access :                       {}
       | '.' IDENTIFIER access {}
       | '[' exp ']' access    {}
       ;
literal : INTEGER_LITERAL {
          Node n;
          n.var.type = "long";
          n.var.value = (void*)$1;
          generate_leaf(&n);
          $$ = n;
        }
        | DOUBLE_LITERAL  {}
        | STRING_LITERAL {
        }
        | BOOL_LITERAL    {}
        | struct_literal  {}
        ;

struct_literal : '{' struct_elements '}' {}
               ;

struct_elements :                                       {}
                | struct_elem remaining_struct_elements {}
                ;

remaining_struct_elements :                                           {}
                          | ',' struct_elem remaining_struct_elements {}
                          ;

struct_elem : IDENTIFIER '=' exp      {}
            | '{' struct_elements '}' {}
            ;


%% /* Fim da segunda seção */

int main (void) {
  symbol_table = ht_create();
  context_stack = createStack(300);
  yyparse();
  return 0;
}

void yyerror (const char *msg) {
	fprintf (stderr, "%s '%s' founded at %d:%d\n", msg, yytext, yylineno, charPos);
}
