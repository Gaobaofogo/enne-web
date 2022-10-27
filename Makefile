
all:
	flex -o bin/lex.yy.c src/lexer.l
	gcc bin/lex.yy.c -o bin/enne-web

clean:
	rm -rf bin/*
