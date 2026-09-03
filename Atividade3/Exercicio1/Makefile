calc: calc.y calc.l
	bison -d calc.y
	flex calc.l
	gcc calc.tab.c lex.yy.c -lm -o meucalc

clean:
	rm -f meucalc calc.tab.c calc.tab.h lex.yy.c calc.output