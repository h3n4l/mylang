parser: parser.y lexical.l
	bison --report=all -d parser.y
	flex lexical.l
	gcc -std=c99  parser.tab.c lex.yy.c -o parser
lexical: lexical.l
	flex lexical.l
	gcc -g lex.yy.c -o lexical



.PHONY test_parser:

test_parser:
	flex lexical.l
	gcc -g lex.yy.c -o lexical
	./lexical Test/test.lang

.PHONY clean:

clean:
	rm -r lexical.dSYM lex.yy.c parser.tab.c parser.tab.h lexical parser parser.output
