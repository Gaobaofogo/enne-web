#ifndef _NODE_H_
#define _NODE_H_

#include "variable.h"

typedef struct Node {
  Variable var;
  char *op;
  char *codigo;
  struct Node *left;
  struct Node *right;
} Node;

void *get_value_from_node(Node *node);
char *aux_t_name_generator();
void generate_leaf(Node *node);
char *generate_op_code(Node *node);
void generate_node(Node *node);

#endif // !_NODE_H_
