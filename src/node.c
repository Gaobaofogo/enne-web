#include "node.h"
#include "str_aux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
  code = cat(code, node->var.name, ".op = \"", node->op, "\";\n");

  if (strcmp(node->op, "/") == 0) {
    code = cat(code, node->var.name, ".var.value = ", "", "");
    code = cat(code, "(void*)((", node->left->var.type, ")", node->var.name);
    code = cat(code, ".left->var.value / (", node->right->var.type, ")",
               node->var.name);
  } else if (strcmp(node->op, "+") == 0) {
    code = cat(code, node->var.name, ".var.value = ", "", "");
    code = cat(code, "(void*)((", node->left->var.type, ")", node->var.name);
    code = cat(code, ".left->var.value + (", node->right->var.type, ")",
               node->var.name);

  } else if (strcmp(node->op, "-") == 0) {
    code = cat(code, node->var.name, ".var.value = ", "", "");
    code = cat(code, "(void*)((", node->left->var.type, ")", node->var.name);
    code = cat(code, ".left->var.value - (", node->right->var.type, ")",
               node->var.name);

  } else if (strcmp(node->op, "*") == 0) {
    code = cat(code, node->var.name, ".var.value = ", "", "");
    code = cat(code, "(void*)((", node->left->var.type, ")", node->var.name);
    code = cat(code, ".left->var.value * (", node->right->var.type, ")",
               node->var.name);
  } else if (strcmp(node->op, "**") == 0) {
    char *aux_name = aux_t_name_generator();
    code = cat(code, "double ", aux_name, " = pow((", "");
    code = cat(code, node->left->var.type, ")", node->left->var.name,
               ".var.value");
    code = cat(code, ", (", node->right->var.type, ")", node->right->var.name);
    code = cat(code, ".var.value);\n", "", "", "");
    code = cat(code, node->var.name, ".var.value = (void*)", aux_name, ";\n");
    return code;
  }

  code = cat(code, ".right->var.value);\n", "", "", "");

  return code;
}

void generate_node(Node *node) {
  node->var.name = aux_t_name_generator();
  node->codigo = cat("Node ", node->var.name, ";\n", "", "");
}

char *create_attr_code(Node *node1, Node *node2) {
  char *code;

  code =
      cat(node1->var.name, ".var.type = ", node2->var.name, ".var.type;\n", "");
  code = cat(code, node1->var.name, ".var.value = ", node2->var.name,
             ".var.value;\n");

  return code;
}

/* Se a função executou e os dois tipos não vomitaram um erro, são compatíveis*/
void check_type_comp(Node n1, Node n2) {
  if ((strcmp(n1.var.type, "long") && strcmp(n2.var.type, "long")
      || strcmp(n1.var.type, "long") && strcmp(n2.var.type, "double")
      || strcmp(n1.var.type, "double") && strcmp(n2.var.type, "long")
      || strcmp(n1.var.type, "double") && strcmp(n2.var.type, "double"))) {
    printf("%s e %s sao incompativeis.\n", n1.var.type, n2.var.type);
    exit(1);
  }
}

char* generate_new_type(Node n1, Node n2) {
  char* code;

  if (strcmp(n1.var.type, "long") && strcmp(n2.var.typ))
  return code;
}
