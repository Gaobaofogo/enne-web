#include <math.h>
#include "str_aux.h"
#include <stdio.h>
#include "node.h"
#include "variable.h"
int main () {
Node t1;
t1.var.type = "long";
t1.var.value = (void*)((long)5);
Node t2;
t2.var.type = "long";
t2.var.value = (void*)((long)2);
Node t3;
t3.left = &t1;
t3.right = &t2;
t3.op = "**";
double t4 = pow((long)t1.var.value, (long)t2.var.value);
t3.var.value = &t4;
Node t5;
t5.var.type = "long";
t5.var.value = (void*)((long)3);
Node t6;
t6.left = &t3;
t6.right = &t5;
t6.op = "-";
t6.var.value = (void*)((long)t6.left->var.value - (long)t6.right->var.value);
Node t7;
t7.var.type = "long";
t7.var.value = (void*)((long)2);
Node t8;
t8.left = &t6;
t8.right = &t7;
t8.op = "+";
t8.var.value = (void*)((long)t8.left->var.value + (long)t8.right->var.value);

Node global_main_x;
global_main_x.var.type = t8.var.type;
global_main_x.var.value = t8.var.value;
}
