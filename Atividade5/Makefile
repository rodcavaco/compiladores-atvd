valida: valida.tab.c lex.yy.c
	gcc -o valida valida.tab.c lex.yy.c

valida.tab.c valida.tab.h: valida.y
	bison -d valida.y

lex.yy.c: valida.l valida.tab.h
	flex valida.l

clean:
	rm -f valida valida.tab.c valida.tab.h lex.yy.c