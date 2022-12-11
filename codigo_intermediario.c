#include "str_aux.h"
#include <stdio.h>
#include "node.h"
#include "variable.h"
int main () {
Node t1;
t1.var.type = "long";
t1.var.value = (void*)((long)20);
Node t2;
t2.var.type = "long";
t2.var.value = (void*)((long)2);
Node t3;
t3.left = &t1;
t3.right = &t2;
t3.op = "/";
t3.var.value = (void*)((long)t3.left->var.value / (long)t3.right->var.value);

Node global_main_x;
set_value_variable(&global_main_x.var, "long", (long*)get_value_from_variable(&t3.var));
  printf("%ld\n", (long) global_main_x.var.value);
}
