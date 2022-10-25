
all:
	byacc -d -v src/grammar.y -o bin/y.tab.c
	flex -o bin/lex.yy.c src/lexer.l
	gcc bin/lex.yy.c bin/y.tab.c -o bin/enne-web

clean:
	rm -rf bin/*
