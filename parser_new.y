%{
int yylex();
voIDENTIFIER yyerror(char const *s);
int yylineno;
#define YYDEBUG 1
char data_type[200];
voIDENTIFIER yyerror(const char *s);


%}

%expect 0
%define parse.error verbose


%union
{
    int ival;
    float fval;
    char *sval;
    //bool bval;
char *val;
    //symbol table pointer
   
}




//%name parse


%token  PACKAGE IMPORT FUNC BREAK CASE CONST CONTINUE DEFAULT

%token  ELSE FOR GO IF RANGE RETURN STRUCT SWITCH TYPE VAR VAR_TYPE

%token  BOOL_CONST NIL_VAL IDENTIFIER BYTE STRING ELLIPSIS

%token  SHL SHR INC DEC

%token  INTEGER

%token  FLOAT



 

%left  ADD SUB MUL QUO REM

%right  ASSIGN AND NOT DEFINE AND_NOT

%left  OR XOR ARROW //Identifier

%right  ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN QUO_ASSIGN REM_ASSIGN

%right  AND_ASSIGN OR_ASSIGN XOR_ASSIGN

%right  SHL_ASSIGN SHR_ASSIGN AND_NOT_ASSIGN COLON

%left  LAND LOR EQL NEQ LEQ GEQ SEMICOLON

%left  GTR LSS LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK COMMA PERIOD



%start StartFile

%type<str> assignment assignment1 consttype ASSIGN ADD SUB MUL QUO E T F
%right UMINUS


%%
StartFile: PackageClause SEMICOLON IMPORT "fmt" SEMICOLON TopLevelDeclList

 
          //printf(" Reenter last line: " );}
{printf("I have a startfile -------\n");}
    ;

PackageClause:
/*PACKAGE*/PACKAGE PackageName
{printf("I have a packageclause-------\n");}
;
PackageName:
IDENTIFIER
{printf("I have a packagename-------\n");}
;

FunctionDecl: FUNC "main" LPAREN RPAREN FunctionBody

{
if(strcmp($2,"main")!=0)
{
printf("goto F%d\n",lnum1);
}
insert($2,FUNC);
insert($2,$1);
g_addr+=4;

printf("I have a functiondecl -------\n");
} ;

FunctionBody:
Block ;


/*
VarDecl:
VAR VarSpec
{printf("I have a vardecl -------\n");}
;
VarSpec:
IdentifierList TypeName ASSIGN ExpressionList
| IdentifierList TypeName
{printf("I have a varspec -------\n");}
;

IdentifierList:
IDENTIFIER IdentifierLIST
| IDENTIFIER
{printf("I have a identifierlist-------\n");}
;

IdentifierLIST: IdentifierLIST COMMA IDENTIFIER
| COMMA IDENTIFIER
{printf("I have a identifierLIST -------\n");}
;

TypeName:
IDENTIFIER
| VAR_TYPE
{printf("I have a typename-------\n");}
;

*/

ExpressionList:
ExpressionList COMMA E
| E
{printf("I have a expressionlist-------\n");}
;

Block:
LBRACE StatementList RBRACE
{printf("I have a block -------\n");}
;

StatementList:
    StatementList Statement SEMICOLON
{printf("I have a statementlist -------\n");}
    ;
   
Statement:
Declaration
| SimpleStmt
|Block
| if
| for  
{printf("I have a statement-------\n");}
;

SimpleStmt:
EmptyStmt
|  IncDecStmt
| Assignment  
{printf("I have a simplestmt -------\n");}
;

EmptyStmt:
/*empty*/
;

IncDecStmt:
Expression INC
|Expression DEC {printf("I have a incdec -------\n");} ;

Assignment:
ExpressionList assign_op ExpressionList
{printf("I have a assignment -------\n");}
;

/*
Expression:
    Expression3
{printf("I have a expression-------\n");}
    ;

Expression3:
    Expression3 rel_op Expression4
    | Expression4
{printf("I have a expression3-------\n");}
    ;

Expression4:
    Expression4 add_op Expression5
    | Expression5
{printf("I have a expression4-------\n");}
    ;

Expression5:
    Expression5 mul_op PrimaryExpr
    | UnaryExpr
{printf("I have a expression5-------\n");}
    ;*/
   
 E : E ADD{strcpy(st1[++top],"+");} T{codegen();}
   | E SUB{strcpy(st1[++top],"-");} T{codegen();}
   | T
   | IDENTIFIER {push($1);} LEQ {strcpy(st1[++top],"<=");} E {codegen();}
   | IDENTIFIER {push($1);} GEQ {strcpy(st1[++top],">=");} E {codegen();}
   | IDENTIFIER {push($1);} EQL {strcpy(st1[++top],"==");} E {codegen();}
   | IDENTIFIER {push($1);} NEQ {strcpy(st1[++top],"!=");} E {codegen();}
   | IDENTIFIER {push($1);} LAND {strcpy(st1[++top],"&&");} E {codegen();}
   | IDENTIFIER {push($1);} LOR {strcpy(st1[++top],"||");} E {codegen();}
   | IDENTIFIER {push($1);} LSS {strcpy(st1[++top],"<");} E {codegen();}
   | IDENTIFIER {push($1);} GTR {strcpy(st1[++top],">");} E {codegen();}
   | IDENTIFIER {push($1);} ASSIGN {strcpy(st1[++top],"=");} E {codegen_assign();}

   ;
T : T MUL{strcpy(st1[++top],"*");} F{codegen();}
   | T QUO{strcpy(st1[++top],"/");} F{codegen();}
   | F
   ;
F : LPAREN E RPAREN {$$=$2;}
   | SUB{strcpy(st1[++top],"-");} F{codegen_umin();} %prec UMINUS
   | IDENTIFIER {push($1);fl=1;}
   | consttype {push($1);}
   ;
   
assignment : IDENTIFIER '=' consttype
| IDENTIFIER '+' assignment
| IDENTIFIER ',' assignment
| consttype ',' assignment
| IDENTIFIER
| consttype
;

assignment1 : IDENTIFIER {push($1);} '=' {strcpy(st1[++top],"=");} E {codegen_assign();}
{
int sct=returnscope($1,stack[index1-1]);
int type=returntype($1,sct);
if((!(strspn($5,"0123456789")==strlen($5))) && type==258 && fl==0)
printf("\nError : Type Mismatch : Line %d\n",printline());
if(!lookup($1))
{
int currscope=stack[index1-1];
int scope=returnscope($1,currscope);
if((scope<=currscope && end[scope]==0) && !(scope==0))
{
check_scope_update($1,$5,currscope);
}
}
}

| IDENTIFIER COMMA assignment1    {
if(lookup($1))
printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
}
| consttype COMMA assignment1
| IDENTIFIER  {
if(lookup($1))
printf("\nUndeclared Variable %s : Line %d\n",$1,printline());
}
| consttype
;

consttype : INTEGER
| FLOAT
;

for : FOR SEMICOLON E {for2();}SEMICOLON E {for3();} Block {for4();}
;

if : IF LPAREN E RPAREN {if1();} Block {if2();} else
;

else : ELSE Block {if3();}
|
;

Declaration : VAR IDENTIFIER VAR_TYPE '=' E

| assignment1 ';'  
| error
;