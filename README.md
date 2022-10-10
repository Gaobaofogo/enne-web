# enne-web

## Rodar o programa

Para compilar o programa, utilizamos um Makefile que irá gerar os arquivos da gramática e do lexer na pasta <i>bin</i> e compilamos o binário dentro da mesma pasta. O arquivo de programa da linguagem está na pasta raiz e se chama <i>programa.enne</i>. Use o seguinte comando:

```bash
$ ./run.sh
yacc -d src/grammar.y -o bin/y.tab.c
lex -o bin/lex.yy.c src/lexer.l
cc bin/lex.yy.c bin/y.tab.c -o bin/enne-web
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
cc bin/lex.yy.c bin/y.tab.c -o bin/enne-web
1: syntax error at ''
```
