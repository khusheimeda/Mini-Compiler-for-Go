bison -d -v -b y parserpp.y 
flex lexer.l
g++ y.tab.c lex.yy.c 
rm lex.yy.c
rm y.tab.h
rm y.tab.c
rm y.output
chmod +x a.out
./a.out "/home/hadoop/Desktop/Mini-Compiler/phase2/if_else.go" > out.txt
#./a.out "Test/test2.go" > out.txt
# ./a.out "try.go" > out.txt
python3 imco.py
