#include "./src/variable.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct noh {
  Variable var;
  char* op;
  char *codigo;
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
  noh->var.name = gerador_de_nome();
  noh->codigo = cat("Variable ", noh->var.name, ";\n", "", "");
  noh->codigo = cat(noh->codigo, generate_insert_code(&noh->var, noh->var.name), "", "", "");
}

char* generate_op_code(noh* noh) {
  char *code;

  

  return code;
}

void gerar_noh(noh* noh) {
  noh->var.name = gerador_de_nome();
  noh->codigo = cat("Variable ", noh->var.name, ";\n", "", "");
}

int main(int argc, char *argv[]) {
  // Variable x;
  // set_value_variable(&x, "int", (void *)3);

  noh x;
  set_value_variable(&x.var, "int", (void *)1234567);

  noh y;
  set_value_variable(&y.var, "int", (void *)1234);
  
  gerar_folha(&x);
  printf("%s\n", x.codigo);
  printf("%s\n", x.var.name);
  
  gerar_folha(&y);
  printf("%s\n", y.codigo);
  printf("%s\n", y.var.name);
  
  
  noh div;
  div.left = &x;
  div.right = &y;
  div.op = "/";
  div.var.name = gerador_de_nome();
  
  if (strcmp(div.op, "/") == 0) {
    div.var.type = "int"; // Precisa de um gerador de tipos pra comparar o left e right
    printf("1: %d\n", (int)div.left->var.value);
    printf("2: %d\n", (int)div.right->var.value);
    printf("%d\n", (int)div.left->var.value / (int)div.right->var.value);
    div.var.value = (void*)((int)div.left->var.value / (int)div.right->var.value);
  }

  printf("Variable %s;\n", div.var.name);
  printf("set_value_variable(&%s, \"int\", (void*)%d);\n", div.var.name, (int)div.var.value);

  return 0;
}
