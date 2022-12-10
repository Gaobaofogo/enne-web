#include "node.h"
#include "str_aux.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int COUNTER = 1;

void *get_value_from_node(Node *node) { return node->var.value; }
void *get_value_from_variable(Variable *var) { return var->value; }

char *aux_t_name_generator() {
  char *name;
  char aux[100];

  sprintf(aux, "%d", COUNTER++);
  name = cat("t", aux, "", "", "");

  return name;
}

void generate_leaf(Node *node) {
  node->var.name = aux_t_name_generator();
  node->codigo = cat("Node ", node->var.name, ";\n", "", "");
  node->codigo =
      cat(node->codigo, generate_insert_code(&node->var, node->var.name), "",
          "", "");
}

char *generate_op_code(Node *node) {
  char *code;

  node->var.name = aux_t_name_generator();

  if (strcmp(node->op, "/") == 0) {
    node->var.type =
        "int"; // Precisa de um gerador de tipos pra comparar o left e right
    node->var.value =
        (void *)((int)node->left->var.value / (int)node->right->var.value);
  }

  code = cat("Node ", node->var.name, ";\n", "", "");
  code = cat(code, node->var.name, ".left = &", node->left->var.name, ";\n");
  code = cat(code, node->var.name, ".right = &", node->right->var.name, ";\n");
  code = cat(code, "set_value_variable(&", node->var.name,
             ".var, \"int\", get_value_from_node(&", node->var.name);
  code = cat(code, "));\n", "", "", "");

  return code;
}

void generate_node(Node *node) {
  node->var.name = aux_t_name_generator();
  node->codigo = cat("Node ", node->var.name, ";\n", "", "");
}
