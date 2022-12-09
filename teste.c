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

void* get_value_from_node(noh* node) {
  return node->var.value;
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

int COUNTER = 1;

char* aux_t_name_generator() {
  char* name;
  char aux[100];

  sprintf(aux, "%d", COUNTER++);
  name = cat("t", aux, "", "", "");

  return name;
}

void gerar_folha(noh* noh) {
  noh->var.name = aux_t_name_generator();
  noh->codigo = cat("noh ", noh->var.name, ";\n", "", "");
  noh->codigo = cat(noh->codigo, generate_insert_code(&noh->var, noh->var.name), "", "", "");
}

char* generate_op_code(noh* noh) {
  char *code;

  noh->var.name = aux_t_name_generator();
  
  if (strcmp(noh->op, "/") == 0) {
    noh->var.type = "int"; // Precisa de um gerador de tipos pra comparar o left e right
    noh->var.value = (void*)((int)noh->left->var.value / (int)noh->right->var.value);
  }

  code = cat("noh ", noh->var.name, ";\n", "", "");
  code = cat(code, noh->var.name, ".left = &", noh->left->var.name, ";\n");
  code = cat(code, noh->var.name, ".right = &", noh->right->var.name, ";\n");
  code = cat(code, "set_value_variable(&", noh->var.name, ".var, \"int\", get_value_from_node(&", noh->var.name);
  code = cat(code, "));\n", "", "", "");
  
  return code;
}

void gerar_noh(noh* noh) {
  noh->var.name = aux_t_name_generator();
  noh->codigo = cat("noh ", noh->var.name, ";\n", "", "");
}

int main(int argc, char *argv[]) {
  // Variable x;
  // set_value_variable(&x, "int", (void *)3);

  noh x;
  set_value_variable(&x.var, "int", (void *)1234567);

  noh y;
  set_value_variable(&y.var, "int", (void *)1234);
  set_value_variable(&y.var, "int", y.var.value);
  
  gerar_folha(&x);
  printf("%s\n", x.codigo);
  
  gerar_folha(&y);
  printf("%s\n", y.codigo);
  
  noh div;
  div.left = &x;
  div.right = &y;
  div.op = "/";
  printf("%s\n", generate_op_code(&div));

  return 0;
}
