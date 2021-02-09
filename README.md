# Mini-Compiler-for-Go
Mini-compiler for Go using lex and yacc

Linux environment-
1. Use Ubuntu VM or install Multipass

Installing flex-
1. ```sudo apt-get update```
2. ```sudo apt-get install flex```	

Lexing/Lex-
1. ```sudo nano lexer_file_name.l```. Lex files end with .l
2. ```flex lexer_file_name.l```
3. ```cc lex.yy.c -ll```. -ll to find main within lexer
   ```cc c_file_name.c lexx.yy.c```
4. ```./a.out```

Parsing/Yacc-
1. ```sudo nano name.y```
2. ```yacc -d name.y```. -d is to generate y.tab.h. The actual parser output is in y.tab.c
3. Next step is to run lex. ```lex name.l```
4. Compile both together. ```gcc lex.yy.c y.tab.c```
5. ```./a.out```

/* Notes
1. Input to yacc is a context-free grammar.
2. yyerror function called when there's a syntactical error
3. %union allows to specify the different types that the lexical analyser can return
4. %start tells which is the starting production
5. %token passes the following value into the header file that can be used by the lexical analyser
6. %type assigns types to non terminal values that appear after it
*/
