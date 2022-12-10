#include "str_aux.h"
#include <stdio.h>
#include "node.h"
#include "variable.h"
int main () {
Node t2;
set_value_variable(&t2.var, "int", (int*)3);

Node global_main_x;
set_value_variable(&global_main_x.var, "int", (int*)get_value_from_variable(&t2.var));
}
