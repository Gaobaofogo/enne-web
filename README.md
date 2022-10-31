# Enne Web

## Pré Requisitos

Para compilar o projeto, é necessário verificar se o <i>flex</i>, o <i>gcc</i> e o <i>make</i> estão todos instalados na máquina. O <i>flex</i> será nosso analisador léxico, o <i>gcc</i> será o compilador C e o <i>make</i> vai compilar tudo.

## Executando os programas

Há dois programas de exemplo da linguagem dentro da pasta "programas" na raiz do projeto para serem usados pra testar o analisador léxico: hello_world.enne e merge_sort.enne. Ao imprimir os tokens, os espaçamentos e linhas são mantidos. Tokens contendo um único caracter ou aritméticos, lógicos e relacionais são impressos como são escritos, como o ponto em vez de imprimir um valor como "PONTO" imprime ".". Tokens que contém valor associado imprimem como o de string: "STRING_LITERAL("Hello World!\n")". 

Para compilar o programa, utilizamos um Makefile que irá gerar o arquivo  lexer na pasta <i>bin</i> e compilamos o binário dentro da mesma pasta. Para invocarmos o Makefile, criamos um script bash para compilar o projeto usando o Makefile e rodar o código ao mesmo tempo. Execute o arquivo "run.sh" passando como parâmetro o caminho do arquivo:

```bash
$ ./run.sh programas/hello_world.enne
flex -o bin/lex.yy.c src/lexer.l
gcc bin/lex.yy.c -o bin/enne-web
COMMENT(/*func main() {
  print("Hello world!\n");
}*/)
```

A saída esperada é o flex compilando o arquivo .l na primeira linha, a segunda linha mostrando o gcc compilando o .c gerado na linha anterior e em seguida vem os tokens encontrados dentro do arquivo do código fonte.

A seguir, a saída esperada após executar o merge_sort.enne:

```bash
$ ./run.sh programas/merge_sort.enne
flex -o bin/lex.yy.c src/lexer.l
gcc bin/lex.yy.c -o bin/enne-web
FUNC IDENTIFIER(merge_sort)(IDENTIFIER(arr), IDENTIFIER(low), IDENTIFIER(high))
{
    VAR IDENTIFIER(mid);
    IF (IDENTIFIER(low) < IDENTIFIER(high)) {
        COMMENT(//divide the array at mid and sort independently using merge sort)
        IDENTIFIER(mid)=(IDENTIFIER(low)+IDENTIFIER(high))/INTEGER_LITERAL(2);
        IDENTIFIER(merge_sort)(IDENTIFIER(arr),IDENTIFIER(low),IDENTIFIER(mid));
        IDENTIFIER(merge_sort)(IDENTIFIER(arr),IDENTIFIER(mid) + INTEGER_LITERAL(1),IDENTIFIER(high));
        COMMENT(//merge or conquer sorted arrays)
        IDENTIFIER(merge)(IDENTIFIER(arr),IDENTIFIER(low),IDENTIFIER(high),IDENTIFIER(mid));
    }
}
COMMENT(// Merge sort)
FUNC IDENTIFIER(merge)(IDENTIFIER(arr), IDENTIFIER(low), IDENTIFIER(high), IDENTIFIER(mid))
{
    VAR IDENTIFIER(i), IDENTIFIER(j), IDENTIFIER(k), IDENTIFIER(c)[INTEGER_LITERAL(50)];
    IDENTIFIER(i) = IDENTIFIER(low);
    IDENTIFIER(k) = IDENTIFIER(low);
    IDENTIFIER(j) = IDENTIFIER(mid) + INTEGER_LITERAL(1);
    WHILE (IDENTIFIER(i) <= IDENTIFIER(mid) && IDENTIFIER(j) <= IDENTIFIER(high)) {
        IF (IDENTIFIER(arr)[IDENTIFIER(i)] < IDENTIFIER(arr)[IDENTIFIER(j)]) {
            IDENTIFIER(c)[IDENTIFIER(k)] = IDENTIFIER(arr)[IDENTIFIER(i)];
            IDENTIFIER(k) += INTEGER_LITERAL(1);
            IDENTIFIER(i) += INTEGER_LITERAL(1);
        }
        ELSE  {
            IDENTIFIER(c)[IDENTIFIER(k)] = IDENTIFIER(arr)[IDENTIFIER(j)];
            IDENTIFIER(k) += INTEGER_LITERAL(1);
            IDENTIFIER(j) += INTEGER_LITERAL(1);
        }
    }
    WHILE (IDENTIFIER(i) <= IDENTIFIER(mid)) {
        IDENTIFIER(c)[IDENTIFIER(k)] = IDENTIFIER(arr)[IDENTIFIER(i)];
        IDENTIFIER(k) += INTEGER_LITERAL(1);
        IDENTIFIER(i) += INTEGER_LITERAL(1);
    }
    WHILE (IDENTIFIER(j) <= IDENTIFIER(high)) {
        IDENTIFIER(c)[IDENTIFIER(k)] = IDENTIFIER(arr)[IDENTIFIER(j)];
        IDENTIFIER(k) += INTEGER_LITERAL(1);
        IDENTIFIER(j) += INTEGER_LITERAL(1);
    }
    FOR (IDENTIFIER(i) = IDENTIFIER(low); IDENTIFIER(i) < IDENTIFIER(k); IDENTIFIER(i) += INTEGER_LITERAL(1))  {
        IDENTIFIER(arr)[IDENTIFIER(i)] = IDENTIFIER(c)[IDENTIFIER(i)];
    }
}
COMMENT(/* read input array and call mergesort */)

FUNC IDENTIFIER(main)()
{
    VAR IDENTIFIER(myarray)[INTEGER_LITERAL(30)], IDENTIFIER(num);
    PRINT(STRING_LITERAL("Enter number of elements to be sorted:"));
    READ(IDENTIFIER(num));
    PRINT(STRING_LITERAL("Enter ") ++ INT_TO_STRING(IDENTIFIER(num)) ++ STRING_LITERAL("elements to be sorted."));
    FOR (VAR IDENTIFIER(i) = INTEGER_LITERAL(0); IDENTIFIER(i) < IDENTIFIER(num); IDENTIFIER(i) += INTEGER_LITERAL(1)) {
        READ(IDENTIFIER(myarray)[IDENTIFIER(i)]);
    }
    IDENTIFIER(merge_sort)(IDENTIFIER(myarray), INTEGER_LITERAL(0), IDENTIFIER(num) - INTEGER_LITERAL(1));
    PRINT(STRING_LITERAL("Sorted array\n"));
    FOR (VAR IDENTIFIER(i) = INTEGER_LITERAL(0); IDENTIFIER(i) < IDENTIFIER(num); IDENTIFIER(i) += INTEGER_LITERAL(1))
    {
        PRINT(INT_TO_STRING(IDENTIFIER(myarray)[IDENTIFIER(i)]) ++ STRING_LITERAL("\t"));
    }
}
```
