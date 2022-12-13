#ifndef _DATA_H_

typedef union Value {
  int i;
  double d;
  char *str;
} Value;

typedef struct Data {
  char *type;
  Value v;
  char *code;
} Data;

void assert_types(Data d1, Data d2);
void assert_types_with_prim(char *type, Data d);
char *generate_type(Data d1, Data d2);

#endif // !_DATA_H_
