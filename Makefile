
parser: lexical.l
	flex lexical.l
	gcc -g lex.yy.c -o lexical

.PHONY test_parser:

test_parser:
	flex lexical.l
	gcc -g lex.yy.c -o lexical
	./lexical Test/test.lang
.PHONY clean:

clean:
	rm lex.yy.c lexical
	rm -r lexical.dSYM
