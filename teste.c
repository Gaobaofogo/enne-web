#include "./src/variable.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct noh {
  Variable var;
  char* op;
  char *codigo;
  char* var_temp_name;
  struct noh *left;
  struct noh *right;
} noh;

char* gerador_de_nome() {
  return "t1";
}

char * cat(char * s1, char * s2, char * s3, char * s4, char * s5){
  int tam;
  char * output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5)+ 1;
  output = (char *) malloc(sizeof(char) * tam);
  
  if (!output){
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }
  
  sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);
  
  return output;
}

void gerar_folha(noh* noh) {
  noh->var_temp_name = gerador_de_nome();
  noh->codigo = cat("Variable ", noh->var_temp_name, ";\n", "", "");
  noh->codigo = cat(noh->codigo, generate_insert_code(&noh->var, noh->var_temp_name), "", "", "");
}

int main(int argc, char *argv[]) {
  // Variable x;
  // set_value_variable(&x, "int", (void *)3);

  noh x;
  set_value_variable(&x.var, "int", (void *)20);

  noh y;
  set_value_variable(&y.var, "int", (void *)2);

  gerar_folha(&x);
  printf("%s\n", x.codigo);
  printf("%s\n", x.var_temp_name);

  gerar_folha(&y);
  printf("%s\n", y.codigo);
  printf("%s\n", y.var_temp_name);
  

  // noh div;
  // div.op = "/";
  // div.left = &x;
  // div.right = &y;

  return 0;
}
