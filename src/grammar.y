%{
#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "stack.h"
#include "str_aux.h"
#include "data.h"
#include "zhash.h"

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


struct ZHashTable* symbol_table;
Stack* context_stack;

%}

%union {
	int     iValue;
  double  dValue;
	char*   sValue;
  Data    data;
};

%token <sValue> IDENTIFIER STRING_LITERAL BOOL_LITERAL PRIM_TYPE
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

%type <sValue> args args_specifier reference_ampersand io decs dec block cmd var_dec init_declarator_list init_declarator loop while assignment if else
%type <data>   literal exp assignable

%start prog

%% /* Inicio da segunda seção, onde colocamos as regras BNF */

prog : { push(context_stack, "global"); } decs
     {
      pop(context_stack);
      FILE *out_file = fopen("codigo_intermediario.c", "w");
      fprintf(out_file, "#include <math.h>\n#include <stdio.h>\n\n%s", $2);
     } 
	   ;

decs :
     {
      $$ = "";
     }
     | dec decs
     {
      char *code = cat($1, $2, "", "", "");
      $$ = code;
     }
     ;

cmd : dec
    {
      $$ = $1;
    }
    | if 
    {
      $$ = $1;
    }
    | loop { $$ = $1; }
    | assignment ';'
    {
      char *code = cat($1, ";\n", "", "", "");
      $$ = code;
    }
    | io ';' { $$ = $1; }
    | RETURN return {}
    | exp ';' {}
    | BREAK ';' {}
    | CONTINUE ';' {}
    ; 

io : READ '(' assignable ')'
   {
    char *type;

    if (strcmp($3.type, "int") == 0) {
      type = "d";
    } else if (strcmp($3.type, "double") == 0) {
      type = "lf";
    } if (strcmp($3.type, "string") == 0) {
      type = "s";
    }

    char *code = cat("scanf(\"%", type, "\", &", $3.code, ");\n");

    $$ = code;
   }
   | PRINT '(' exp ')'
   {
    char *type;

    if (strcmp($3.type, "int") == 0) {
      type = "d";
    } else if (strcmp($3.type, "double") == 0) {
      type = "lf";
    } if (strcmp($3.type, "string") == 0) {
      type = "s";
    }

    char *code = cat("printf(\"%", type, "\", ", $3.code, ");\n");

    $$ = code;
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
        char *code = cat($1, $2, "", "", "");
        $$ = code;
      }
      ;

if : IF '(' exp ')' '{' block '}' elseif else
   {
    char *label_true = generate_goto();
    char *label_false = generate_goto();
    char *label_next = generate_goto();
    char *code = cat("if (", $3.code, ") goto ", label_true, ";\n");
    code = cat(code, "goto ", label_false, ";\n", "");
    code = cat(code, label_true, ":\n", $6, "goto ");
    code = cat(code, label_next, ";\n", label_false, "");
    code = cat(code, ":\n", $9, "goto ", label_next);

    code = cat(code, ";\n", label_next, ":\n", "");
    $$ = code;
   }
   ;

elseif : {}
       | ELIF '(' exp ')' '{' block '}' elseif {}
       ;

else : ELSE '{' block '}'
     {
      char *code = cat($3, "", "", "", "");
      $$ = code;
     }
     | { $$ = ""; }
     ;

loop : while { $$ = $1;}
     | for {}
     ;

while : WHILE '(' exp ')' '{' block '}' {
        char *label_true = generate_goto();
        char *label_next = generate_goto();
        char *code = cat("if (", $3.code, ") goto ", label_true, ";\n");
        code = cat(code, "goto ", label_next, ";\n", label_true);
        code = cat(code, ":\n", $6, "", "if (");
        code = cat(code, $3.code, ") goto ", label_true, ";\n"); 

        code = cat(code, label_next, ":\n", "", "");
        $$ = code;
      }
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

assignment : assignable '=' exp
           {
            assert_types($1, $3);
            char *code = cat($1.code, " = ", $3.code, "", "");
            $$ = code;
           }
           | assignable PLUS_ASSIGN_OP exp {}
           | assignable MINUS_ASSIGN_OP exp {}
           | assignable DIV_ASSIGN_OP exp {}
           | assignable MULT_ASSIGN_OP exp {}
           ;

dec : PRIM_TYPE IDENTIFIER { push(context_stack, $2); } '(' args ')' '{' block '}'
      {
        pop(context_stack);
        char *code = cat($1, " ", $2, "(", $5);
        code = cat(code, ") {\n", $8, "}\n", "");

        $$ = code;
      }
    | STRUCT IDENTIFIER '{' struct_fields '}' {}
    | var_dec { $$ = $1;}
    ;

args : { $$ = ""; }
     | args_specifier {$$ = $1;}
    ;

args_specifier : PRIM_TYPE reference_ampersand IDENTIFIER
               {
                char* nome_com_escopo = get_scope(context_stack);
                concat_code(nome_com_escopo, $3);
                char *code = cat($1, " ", $2, nome_com_escopo, "");

                Data *d = malloc(sizeof(Data));
                d->name = nome_com_escopo;
                d->type = $1;
                d->code = nome_com_escopo;
                zhash_set(symbol_table, nome_com_escopo, (void*)d);
                printf("%s\n", nome_com_escopo);
                $$ = code;
               }
               | args_specifier ',' PRIM_TYPE reference_ampersand IDENTIFIER
               {
                char* nome_com_escopo = get_scope(context_stack);
                concat_code(nome_com_escopo, $5);

                char *code = cat($1, ", ", $3, " ", $4);
                code = cat(code, nome_com_escopo, "", "", "");

                Data *d = malloc(sizeof(Data));
                d->name = nome_com_escopo;
                d->type = $3;
                d->code = nome_com_escopo;
                zhash_set(symbol_table, nome_com_escopo, (void*)d);
                printf("%s\n", nome_com_escopo);
                $$ = code;
               }
               ;

reference_ampersand : { $$ = ""; }
                    | '*' { $$ = cat("*", "", "", "", ""); }
                    ;

struct_fields : {}
       | field struct_fields {}
       ;

field : IDENTIFIER ';' {}
      ;

var_dec : PRIM_TYPE init_declarator_list ';'
        {
          char *code = cat($1, " ", $2, ";\n", "");
          Data *d = malloc(sizeof(Data));
          d->name = $2;
          d->type = $1;
          d->code = $2;
          zhash_set(symbol_table, $2, (void*)d);

          $$ = code;
        }
        | PRIM_TYPE init_declarator '=' exp ';' {
          assert_types_with_prim($1, $4);

          char *code = cat($1, " ", $2, " = ", $4.code);
          code = cat(code, ";\n", "", "", "");

          Data *d = malloc(sizeof(Data));
          d->name = $2;
          d->type = $1;
          d->code = $2;
          zhash_set(symbol_table, $2, (void*)d);

          $$ = code;
        }
        ;

init_declarator_list : init_declarator
                     {
                      $$ = $1;
                     }
                     | init_declarator ',' init_declarator_list {}
                     ;

init_declarator : IDENTIFIER 
                {
                  char* nome_com_escopo = get_scope(context_stack);
                  concat_code(nome_com_escopo, $1);

                  $$ = nome_com_escopo;
                }
                | init_declarator '[' exp ']' {}
                ;

exp : '-' exp                         %prec U_MINUS_OP {
      Data d;
      d.type = $2.type;
      d.code = cat("- ", $2.code, "", "", "");
      $$ = d;
    }
    | '!' exp                         %prec U_NOT_OP   {}
    | exp '+' exp                         {
      assert_types($1, $3);
      Data d;
      d.type = generate_type($1, $3);
      d.code = cat($1.code, " + ", $3.code, "", "");
      $$ = d;
    }
    | exp '-' exp                         
    {
      assert_types($1, $3);
      Data d;
      d.type = generate_type($1, $3);
      d.code = cat($1.code, " - ", $3.code, "", "");

      $$ = d;
    }
    | exp '*' exp                         
    {
      assert_types($1, $3);
      Data d;
      d.type = generate_type($1, $3);
      d.code = cat($1.code, " * ", $3.code, "", "");
      $$ = d;
    }
    | exp '/' exp
    {
      assert_types($1, $3);
      Data d;
      d.type = generate_type($1, $3);
      d.code = cat($1.code, " / ", $3.code, "", "");
      $$ = d;
    }
    | exp EXP_OP exp                      {
      assert_types($1, $3);
      Data d;
      d.type = "double";
      d.code = cat("pow(", $1.code, ", ", $3.code, ")");
      $$ = d;
    }
    | exp '%' exp                         
    {
      assert_types($1, $3);
      Data d;
      d.type = generate_type($1, $3);
      d.code = cat($1.code, " % ", $3.code, "", "");
      $$ = d;
    }
    | exp AND_OP exp                      
    {
      /* assert_types($1, $3); */
      Data d;
      d.type = "bool";
      d.code = cat($1.code, " && ", $3.code, "", "");
      $$ = d;
    }
    | exp OR_OP  exp                      
    {
      Data d;
      d.type = "bool";
      d.code = cat($1.code, " || ", $3.code, "", "");
      $$ = d;
    }
    | exp AND_NAMED_OP exp                {}
    | exp OR_NAMED_OP  exp                {}
    | exp '>' exp                         
    {
      Data d;
      d.type = "bool";
      d.code = cat($1.code, " > ", $3.code, "", "");
      $$ = d;
    }
    | exp GTE_OP exp                      
    {
      Data d;
      d.type = "bool";
      d.code = cat($1.code, " >= ", $3.code, "", "");
      $$ = d;
    }
    | exp '<' exp                         
    {
      Data d;
      d.type = "bool";
      d.code = cat($1.code, " < ", $3.code, "", "");
      $$ = d;
    }
    | exp LTE_OP exp                      
    {
      Data d;
      d.type = "bool";
      d.code = cat($1.code, " <= ", $3.code, "", "");
      $$ = d;
    }
    | exp EQ_OP exp                       
    {
      Data d;
      d.type = "bool";
      d.code = cat($1.code, " <= ", $3.code, "", "");
      $$ = d;
    }
    | exp DIFF_OP exp                     
    {
      Data d;
      d.type = "bool";
      d.code = cat($1.code, " != ", $3.code, "", "");
      $$ = d;
    }
    | exp CONCAT_OP exp                   {}
    | func_call                           {}
    | assignable
    {
      $$ = $1;
    }
    | literal
    {
      $$ = $1;
    }
    | builtin_functions                   {}
    | '(' exp ')'                         {}
    ;

builtin_functions : INT_TO_STRING '(' exp ')'    {}
                  | DOUBLE_TO_STRING '(' exp ')' {
                  }
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


assignable : IDENTIFIER                       
           {// TODO: ALTERAR
            char* nome_com_escopo = cat(get_scope(context_stack), $1, "", "", "");
            Data *d = (Data*)zhash_get(symbol_table, nome_com_escopo);

            if (d != NULL) {
              $$ = *d;
            } else {
              printf("Variavel %s nao existe.\n", $1);
              exit(1);
            }
           }
           | IDENTIFIER '[' exp ']' access    {}
           | IDENTIFIER '.' IDENTIFIER access {}
           ;

access :                       {}
       | '.' IDENTIFIER access {}
       | '[' exp ']' access    {}
       ;
literal : INTEGER_LITERAL {
          Data d;
          d.type = "int";
          d.v.i = $1;
          d.code = (char*)malloc(sizeof(char) * 100);
          sprintf(d.code, "%d", $1);
          $$ = d;
        }
        | DOUBLE_LITERAL  {
          Data d;
          d.type = "double";
          d.v.d = $1;
          d.code = (char*)malloc(sizeof(double) * 100);
          sprintf(d.code, "%lf", $1);
          $$ = d;
        }
        | STRING_LITERAL {
          Data d;
          d.type = "string";
          d.v.str = $1;
          d.code = $1;
          $$ = d;
        }
        | BOOL_LITERAL    {
          Data d;
          d.type = "bool";
          d.v.str = $1;
          d.code = $1;
          $$ = d;
        }
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
  symbol_table = zcreate_hash_table();
  context_stack = createStack(300);

  yyparse();

  zfree_hash_table(symbol_table);
  return 0;
}

void yyerror (const char *msg) {
	fprintf (stderr, "%s '%s' founded at %d:%d\n", msg, yytext, yylineno, charPos);
}
