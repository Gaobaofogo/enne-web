#ifndef _VARIABLE_H_

typedef union {
  char* str;
  int i;
  double d;
} Value;

typedef struct {
  char* type;
  Value v;
} Variable;

typedef Variable LiteralTemp;

#endif // !_VARIABLE_H_