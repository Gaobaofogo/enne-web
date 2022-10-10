# Enne Web

## Pré Requisitos

Para compilar o projeto, é necessário verificar se o <i>yacc</i>, o <i>lex</i>, o <i>gcc</i> e o <i>make</i> estão todos instalados na máquina. O <i>lex</i> será nosso analisador léxico, o <i>yacc</i> será o analisador sintático, o <i>gcc</i> será o compilador C e o <i>make</i> vai juntar tudo e executar tudo de uma vez.

## Rodar o programa

Para compilar o programa, utilizamos um Makefile que irá gerar os arquivos da gramática e do lexer na pasta <i>bin</i> e compilamos o binário dentro da mesma pasta. O arquivo de programa da linguagem está na pasta raiz e se chama <i>programa.enne</i>. Para invocarmos o Makefile, criamos um script bash para compilar o projeto usando o Makefile e rodar o código ao mesmo tempo. Use o seguinte comando:

```bash
$ ./run.sh
yacc -d src/grammar.y -o bin/y.tab.c
lex -o bin/lex.yy.c src/lexer.l
gcc bin/lex.yy.c bin/y.tab.c -o bin/enne-web
```

Depois da última linha onde compila o binário, dentro do arquivo <i>run.sh</i> o binário é executado passando o <i>programa.enne</i>. Por hora, não aparecer nada na tela significa que não há erros sintáticos no programa. Um exemplo de programa com erro por causa da falta do ponto e vírgula no final da linha no arquivo <i>programa.enne</i>:

```
index = 2 * cont + 17
```

O resultado é o seguinte com um erro pouco indicativo:

```bash
$ ./run.sh
yacc -d src/grammar.y -o bin/y.tab.c
lex -o bin/lex.yy.c src/lexer.l
gcc bin/lex.yy.c bin/y.tab.c -o bin/enne-web
1: syntax error at ''
```
