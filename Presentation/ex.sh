bison -d -v -b y parser_me.y 
flex lexer_me.l
g++ y.tab.c lex.yy.c 
rm lex.yy.c
rm y.tab.h
rm y.tab.c
rm y.output
./a.out "Test/.go" > out.txt
