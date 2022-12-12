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
t3.var.value = (void*)pow((long)t3.left->var.value, (long)t3.right->var.value);
Node t4;
t4.var.type = "long";
t4.var.value = (void*)((long)3);
Node t5;
t5.left = &t3;
t5.right = &t4;
t5.op = "-";
t5.var.value = (void*)((long)t5.left->var.value - (long)t5.right->var.value);
Node t6;
t6.var.type = "long";
t6.var.value = (void*)((long)2);
Node t7;
t7.left = &t5;
t7.right = &t6;
t7.op = "+";
t7.var.value = (void*)((long)t7.left->var.value + (long)t7.right->var.value);

Node global_main_x;
global_main_x.var.type = t7.var.type;
global_main_x.var.value = t7.var.value;
}
