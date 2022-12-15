#include "str_aux.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int label_count = 1;

char *cat(char *s1, char *s2, char *s3, char *s4, char *s5) {
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

char *generate_goto() {
  char *label = malloc(sizeof(char) * 100);
  sprintf(label, "L%d", label_count++);

  return label;
}
