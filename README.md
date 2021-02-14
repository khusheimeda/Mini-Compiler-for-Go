# Mini-Compiler-for-Go
Mini-compiler for Go using lex and yacc

Windows environment-
1. Click on Setup from http://gnuwin32.sourceforge.net/packages/flex.htm
2. Run the flex application to complete installation.
3. Download bison from https://ecodehacker.com/courses/programming-language-pragmatics/lectures/2062783
4. Setup following https://www.youtube.com/watch?v=0MUULWzswQE&ab_channel=PratikKataria

Linux environment-
1. Use Ubuntu VM or install Multipass

Installing go-
1. refer to https://www.youtube.com/watch?v=G3PvTWRIhZA&list=PLQVvvaa0QuDeF3hP0wQoSxpkqgRcgxMqX

Installing flex (Linux)-
1. ```sudo apt-get update```
2. ```sudo apt-get install flex```	

Lexing/Lex-
1. For Linux, ```sudo nano lexer_file_name.l```. For Windows, install nano; it will already be present in ProgramFiles/Git/usr/bin as nano.exe if Git is installed. Lex files end with .l
2. ```flex lexer_file_name.l```
3. ```g++ scanner.cpp lex.yy.c```
4. ```./a.out program_name.go```. For Windows, ```a.exe program_name.go```

Parsing/Yacc-
1. For Linux, ```sudo nano name.y```. For windows, ```path_to_nano.exe name.y``` 
2. For Linux, ```yacc -d name.y```. For Windows, ```bison -d name.y```. -d is to generate y.tab.h. The actual parser output is in y.tab.c
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
