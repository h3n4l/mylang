
parser: parser.l
	flex parser.l
	gcc -g lex.yy.c -o parser

.PHONY test_parser:
test_parser:
	flex parser.l
	gcc -g lex.yy.c -o parser
	./parser Test/test.lang
.PHONY clean:

clean:
	rm lex.yy.c parser