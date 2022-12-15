#include "data.h"
#include "string.h"
#include <stdlib.h>
#include <stdio.h>

void assert_types(Data d1, Data d2) {
  if (!(strcmp(d1.type, "int") && strcmp(d2.type, "int")
        || strcmp(d1.type, "int") && strcmp(d2.type, "double")
        || strcmp(d1.type, "double") && strcmp(d2.type, "int")
        || strcmp(d1.type, "double") && strcmp(d2.type, "double"))) {
    printf("%s e %s sao incompativeis.\n", d1.type, d2.type);
    exit(1);
  }
}

void assert_types_with_prim(char *type, Data d) {
  if (!(strcmp(type, "int") && strcmp(d.type, "int")
        || strcmp(type, "int") && strcmp(d.type, "double")
        || strcmp(type, "double") && strcmp(d.type, "int")
        || strcmp(type, "double") && strcmp(d.type, "double"))) {
    printf("%s e %s sao incompativeis.\n", type, d.type);
    exit(1);
  }
}

void assert_is_numeric(char *type) {
  if (!(strcmp(type, "int") == 0 || strcmp(type, "double") == 0)) {
    printf("%s nao eh um tipo numerico.\n", type);
    exit(1);
  }
}

char *generate_type(Data d1, Data d2) {
  if (strcmp(d1.type, "int") == 0 && strcmp(d2.type, "int") == 0) {
    return "int";
  } else if (strcmp(d1.type, "int") == 0 && strcmp(d2.type, "double") == 0
            || strcmp(d1.type, "double") == 0 && strcmp(d2.type, "double") == 0
            || strcmp(d1.type, "double") == 0 && strcmp(d2.type, "int") == 0) {
    return "double";
  }

  printf("Tipo desconhecido");
  exit(1);
}
