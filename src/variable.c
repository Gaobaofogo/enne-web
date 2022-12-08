#include "variable.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *cat_v(char *s1, char *s2, char *s3, char *s4, char *s5) {
  int tam;
  char *output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + 1;
  output = (char *)malloc(sizeof(char) * tam);

  if (!output) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);

  return output;
}

void set_value_variable(Variable *var, char *type, void *value) {
  char *value_string = (char *)value;

  if (strcmp(type, "int") == 0) {
    var->type = "int";
    var->value = (int *)value;
  }
}

char *generate_insert_code(Variable *var, char* name) {
  char* aux = cat_v("set_value_variable(", name, ", \"", var->type, "\", ");
  char* insert_code;

  if (strcmp(var->type, "int") == 0) {
    char buffer[300];
    sprintf(buffer, "%d", (int*)var->value);
    insert_code = cat_v(aux, "(int*)", buffer, ");\n", "");
  }

  return insert_code;
}
