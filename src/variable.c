#include "variable.h"
#include "str_aux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void set_value_variable(Variable *var, char *type, void *value) {
  char *value_string = (char *)value;

  if (strcmp(type, "int") == 0) {
    var->type = "int";
    var->value = (int *)value;
  }
}

char *generate_insert_code(Variable *var, char *name) {
  // char *aux = cat("set_value_variable(&", name, ".var, \"", var->type, "\", ");
  char *insert_code = cat(var->name, ".var.type = \"", var->type, "\";\n", "");

  if (strcmp(var->type, "long") == 0) {
    char buffer[200];
    sprintf(buffer, "%ld", (long *)var->value);
    insert_code = cat(insert_code, var->name, ".var.value = (void*)((long)", buffer, ");\n");
    // insert_code = cat(insert_code, "(long*)", buffer, ");\n", "");
  }

  return insert_code;
}

char *generate_insert_code_from_variable(Variable *var1, Variable *var2) {
  char *aux = cat("set_value_variable(&", var1->name, ".var, \"", var2->type, "\", ");
  char *insert_code;

  if (strcmp(var2->type, "long") == 0) {
    char buffer[300];
    sprintf(buffer, "%ld", (long *)var1->value);
    insert_code = cat(aux, "(long*)get_value_from_variable(&", var2->name, ".var));\n", "");
  }

  return insert_code;
}
