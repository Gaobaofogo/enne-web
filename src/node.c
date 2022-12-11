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
  code = cat(node->left->codigo, node->right->codigo, "", "", "");
  code = cat(code, "Node ", node->var.name, ";\n", "");
  code = cat(code, node->var.name, ".left = &", node->left->var.name, ";\n");
  code = cat(code, node->var.name, ".right = &", node->right->var.name, ";\n");

  if (strcmp(node->op, "/") == 0) {
    code = cat(code, node->var.name, ".op = \"", node->op, "\";\n");
    code = cat(code, node->var.name, ".var.value = ", "", "");
    code = cat(code, "(void*)((", node->left->var.type, ")", node->var.name);
    code = cat(code, ".left->var.value / (", node->right->var.type, ")", node->var.name);
    code = cat(code, ".right->var.value);\n", "", "", "");
  }


  return code;
}

void generate_node(Node *node) {
  node->var.name = aux_t_name_generator();
  node->codigo = cat("Node ", node->var.name, ";\n", "", "");
}
