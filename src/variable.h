#ifndef _VARIABLE_H_

typedef struct {
  char *type;
  void *value;
  char* name;
} Variable;

void set_value_variable(Variable *var, char *type, void *value);
char* generate_insert_code(Variable *var, char *name);

typedef Variable LiteralTemp;

#endif // !_VARIABLE_H_
