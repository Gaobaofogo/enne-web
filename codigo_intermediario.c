#include <math.h>
#include "str_aux.h"
#include <stdio.h>
#include "variable.h"
int main() {
int global_main_segundoQuarto = 0;
int global_main_primeiroQuarto = 0;
int global_main_terceiroQuarto = 0;
int global_main_quartoQuarto = 0;
int global_main_leitura;
scanf("%d", &global_main_leitura);
if (global_main_leitura >= 0) goto L13;
goto L14;
L13:
if (global_main_leitura >= 0 && global_main_leitura <= 25) goto L1;
goto L2;
L1:
global_main_primeiroQuarto = global_main_primeiroQuarto + 1;
L2:
L3:
if (global_main_leitura > 25 && global_main_leitura <= 50) goto L4;
goto L5;
L4:
global_main_segundoQuarto = global_main_segundoQuarto + 1;
L5:
L6:
if (global_main_leitura > 50 && global_main_leitura <= 75) goto L7;
goto L8;
L7:
global_main_terceiroQuarto = global_main_terceiroQuarto + 1;
L8:
L9:
if (global_main_leitura > 75 && global_main_leitura <= 100) goto L10;
goto L11;
L10:
global_main_quartoQuarto = global_main_quartoQuarto + 1;
L11:
L12:
scanf("%d", &global_main_leitura);
if (global_main_leitura >= 0) goto L13;
L14:
printf("%s", "===================\n");
printf("%s", "Primeiro intervalo:");
printf("%d", global_main_primeiroQuarto);
printf("%s", "\n");
printf("%s", "===================\n");
printf("%s", "Segundo intervalo:");
printf("%d", global_main_segundoQuarto);
printf("%s", "\n");
printf("%s", "===================\n");
printf("%s", "Terceiro intervalo:");
printf("%d", global_main_terceiroQuarto);
printf("%s", "\n");
printf("%s", "===================\n");
printf("%s", "Quarto intervalo:");
printf("%d", global_main_quartoQuarto);
printf("%s", "\n");
}
