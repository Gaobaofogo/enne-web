#include "data.h"
#include "string.h"
#include <stdlib.h>
#include <stdio.h>

void assert_types(Data d1, Data d2) {
  if (strcmp(d1.type, "long") && strcmp(d2.type, "long")
        || strcmp(d1.type, "long") && strcmp(d2.type, "double")
        || strcmp(d1.type, "double") && strcmp(d2.type, "long")
        || strcmp(d1.type, "double") && strcmp(d2.type, "double")) {
    printf("%s e %s sao incompativeis.\n", d1.type, d2.type);
    exit(1);
  }
}
