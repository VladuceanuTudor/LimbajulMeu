interpreter: lex.l pars.y
	bison -d pars.y
	flex -o lex.yy.c lex.l
	gcc pars.tab.c lex.yy.c -o interpreter -lfl

clean:
	rm -f interpreter lex.yy.c pars.tab.c pars.tab.h

.PHONY: clean
