# Enne Web

## Pré Requisitos

Para compilar o projeto, é necessário verificar se o <i>yacc</i>, o <i>flex</i>, o <i>gcc</i> e o <i>make</i> estão todos instalados na máquina. O <i>flex</i> será nosso analisador léxico, o <i>yacc</i> será o analisador sintático, o <i>gcc</i> será o compilador C e o <i>make</i> vai juntar tudo e executar tudo de uma vez.

## Executando os programas

Há dois programas de exemplo da linguagem dentro da pasta "programas" na raiz do projeto para serem usados pra testar o analisador léxico: hello_world.enne e merge_sort.enne.

Para compilar o programa, utilizamos um Makefile que irá gerar os arquivos .c na pasta <i>bin</i> e compilamos o binário dentro da mesma pasta. Para invocarmos o Makefile, criamos um script bash para compilar o projeto usando o Makefile e rodar o código ao mesmo tempo. Execute o arquivo "run.sh" passando como parâmetro o caminho do arquivo:

```bash
$ ./run.sh programas/hello_world.enne
yacc -d -v src/grammar.y -o bin/y.tab.c
flex -o bin/lex.yy.c src/lexer.l
gcc bin/lex.yy.c bin/y.tab.c -o bin/enne-web
```

Depois da última linha onde compila o binário, dentro do arquivo <i>run.sh</i> o binário é executado passando o arquivo <i>hello_world.enne</i>.
