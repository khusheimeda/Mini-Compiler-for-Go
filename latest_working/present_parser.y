%{
	int yylex();
	void yyerror(char const *s);
	int yylineno;
	#define YYDEBUG 1
	char data_type[200];
	void yyerror(const char *s);


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




%%
StartFile:
    PackageClause eol ImportDeclList TopLevelDeclList 

 
          //printf(" Reenter last line: " );}
	{printf("I have a startfile -------\n");}
    	;
 
eol: SEMICOLON | error '\n' {yyerrok;};
Block:
	LBRACE OPENB StatementList CLOSEB RBRACE
	{printf("I have a block -------\n");}
	; 


OPENB:
	/*empty*/
	;
	
CLOSEB:
	/*empty*/
	;

StatementList:
    StatementList Statement eol 
    | Statement eol 
	{printf("I have a statementlist -------\n");}
    ;

Statement:
	Declaration 
	//| LabeledStmt 
	| SimpleStmt 
	|ReturnStmt 
	| BreakStmt 
	| ContinueStmt 
	|Block 
	| IfStmt 
	|  ForStmt  
	| FunctionCall  
	| FunctionStmt 
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



//LabeledStmt:
//	Label COLON Statement 
//	{printf("I have a labeledstmt -------\n");};

//Label:
//	IDENTIFIER {printf("I have a label -------\n");};



IncDecStmt:
	Expression INC 
	|Expression DEC {printf("I have a incdec -------\n");} ;

Assignment:
	ExpressionList assign_op ExpressionList 
	{printf("I have a assignment -------\n");}
	;

VarDecl:
		VAR VarSpec 
		{printf("I have a vardecl -------\n");}
		;
VarSpec:
		IdentifierList Type ASSIGN ExpressionList 
		| IdentifierList Type 
		{printf("I have a varspec -------\n");}
		;


Declaration:
	ConstDecl 
	| TypeDecl 
	| VarDecl
	{printf("I have declaration-------\n");} ;


FunctionDecl:
		FUNC FunctionName OPENB Function CLOSEB 
		|FUNC FunctionName OPENB Signature CLOSEB
		{printf("I have a functiondecl -------\n");} ;
FunctionName:
		IDENTIFIER
		{printf("I have a functionname-------\n");} ;
Function:
		Signature FunctionBody{printf("I have a function -------\n");} ;
FunctionBody:		
		Block ;
//-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n----start
//function call starts here
FunctionStmt:
		VarDecl DEFINE FunctionCall
		//new changes
		| IDENTIFIER DEFINE FunctionCall
		{printf("I have a functionstmt -------\n");}
		;


FunctionCall:	PrimaryExpr LPAREN ArgumentList RPAREN 
	{printf("I have a functioncall-------\n");}
		;		

ArgumentList:	
		ArgumentList COMMA Arguments 
		| Arguments 
		| /*empty*/
		{printf("I have a arguementlist -------\n");}
		;

Arguments:	PrimaryExpr 
		| FunctionCall 
		{printf("I have a arguements-------\n");}
		;
		
//function call till here 

Signature:
	Parameters 
	|Parameters Result 
	{printf("I have a signature -------\n");};

//-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n----end
Result:
	LPAREN TypeList RPAREN 
	| Type  
	{printf("I have a result-------\n");};

Parameters:
	LPAREN RPAREN 
	| LPAREN ParameterList RPAREN 
	|LPAREN ParameterList COMMA RPAREN 
	{printf("I have a parameters-------\n");}
	; 
ParameterList:
	ParameterDecl 
	|ParameterList COMMA ParameterDecl 
	{printf("I have a parameterlist -------\n");}
	;

//change

ParameterDecl:
	IdentifierList Type 
	| IdentifierList ELLIPSIS  Type 
	|ELLIPSIS Type 
	{printf("I have a parameterdecl-------\n");}
	;

TypeList:
    TypeList COMMA Type 
    | Type 
	{printf("I have a typelist-------\n");}
    ;

//change
//-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n--start
IdentifierList:
		IDENTIFIER IdentifierLIST 
		| IDENTIFIER 
		{printf("I have a identifierlist-------\n");}
		;
//-------\n-------\n-------\n-------\n-------\n-------\n-----end		
IdentifierLIST:	IdentifierLIST COMMA IDENTIFIER 
		| COMMA IDENTIFIER 
		{printf("I have a identifierLIST -------\n");}
		;

//change
MethodDecl:
	FUNC Receiver IDENTIFIER Function 
	| FUNC Receiver IDENTIFIER Signature 
	{printf("I have a MethodDecl------");}
	;

Receiver:
	Parameters {printf("I have a receiver -------\n");};

TopLevelDeclList:
    TopLevelDeclList eol /*here colon*/ TopLevelDecl  
    | TopLevelDecl  
	{printf("I have a topleveldeclist -------\n");}
    ;

TopLevelDecl:
	Declaration 	
	| FunctionDecl 
	| MethodDecl 
	{printf("I have a topleveldecl -------\n");}
	;

TypeLit:
	ArrayType 
	| StructType 
	| PointerType 
	| FunctionType 
	{printf("I have a typelit -------\n");}
	;


//change

Type:
	TypeName 
	| TypeLit 
	{printf("I have a type -------\n");}
	;

Operand:
	Literal 
	| OperandName 
	| LPAREN Expression RPAREN
	{printf("I have a operand-------\n");} ;

OperandName:
	IDENTIFIER %prec ASSIGN
	{printf("I have a operandname -------\n");}
;

ReturnStmt:
	RETURN Expression 
	|RETURN 
	{printf("I have a returnstmt -------\n");};

BreakStmt:
	//BREAK Label 
	BREAK 
	{printf("I have a breakstmt-------\n");};

ContinueStmt:
	//CONTINUE Label 
	CONTINUE
	{printf("I have a continuestmt-------\n");}
	;

IfStmt:
	IF OPENB Expression Block CLOSEB 
	|IF OPENB SimpleStmt eol Expression Block CLOSEB 
	|IF OPENB SimpleStmt eol Expression Block ELSE IfStmt CLOSEB  
	|IF OPENB SimpleStmt eol Expression Block ELSE  Block CLOSEB 
	|IF OPENB Expression Block ELSE IfStmt CLOSEB 
	|IF OPENB Expression Block ELSE  Block CLOSEB 
	{printf("I have a ifstmt-------\n");}
	;

ForStmt:
	FOR OPENB Condition Block CLOSEB 
	|FOR OPENB ForClause Block CLOSEB 
	{printf("I have a forstmt-------\n");}
	;
Condition:
	Expression {printf("I have a condition-------\n");};

ForClause:
	InitStmt eol Condition eol PostStmt 
	{printf("I have a forclause-------\n");}
	;
InitStmt:
	SimpleStmt {printf("I have a initstmt-------\n");};
PostStmt:
	SimpleStmt {printf("I have a poststmt-------\n");};

int_lit:
	INTEGER
	{printf("I have a int_lit-------\n");}
	;
float_lit:
	  FLOAT
	  {printf("I have a float_lit-------\n");}
	  ;



TypeName:
	IDENTIFIER 
	| VAR_TYPE 
	{printf("I have a typename-------\n");}
	;



ArrayType:
	LBRACK ArrayLength RBRACK Type
	{printf("I have a arraytype-------\n");}
	;

ArrayLength:
	Expression
	{printf("I have a arraylength-------\n");}
	;

StructType:
    STRUCT LBRACE FieldDeclList RBRACE 
    | STRUCT LBRACE RBRACE 
	{printf("I have a structtype-------\n");}
    ;

FieldDeclList:
    FieldDecl eol 
    | FieldDeclList FieldDecl eol 
	{printf("I have a fielddecllist-------\n");}
    ;

FieldDecl:
	IdentifierList Type 
	| IdentifierList Type Tag 
	{printf("I have a fielddecl-------\n");}
	;

Tag:
	STRING 
	{printf("I have a tag-------\n");}
	;

PointerType:
	MUL BaseType 
	{printf("I have a pintertype-------\n");}
	;
BaseType:
	Type 
	{printf("I have a basetype-------\n");}
	;

FunctionType:
	FUNC Signature 
	{printf("I have a functiontype-------\n");}
	;

ConstDecl:
		CONST ConstSpec 
		{printf("I have a constdecl -------\n");}
		;

ConstSpec:
		IDENTIFIER Type ASSIGN Expression 
		| IDENTIFIER Type 
		{printf("I have a -constspec------");}
		;

ExpressionList:
		ExpressionList COMMA Expression 
		| Expression 
		{printf("I have a expressionlist-------\n");}
		;

TypeDecl:
		TYPE  TypeSpec 
		| TYPE LPAREN TypeSpecList RPAREN 
		{printf("I have a -typedecl------");};

TypeSpecList:
		TypeSpecList TypeSpec eol 
		| TypeSpec eol 
		{printf("I have a typespeclist-------\n");}
		;
TypeSpec:
		AliasDecl 
		| TypeDef 
		{printf("I have a typespec-------\n");};

AliasDecl:
		IDENTIFIER ASSIGN Type 
		{printf("I have a aliasdecl-------\n");}
		;

TypeDef:
		IDENTIFIER Type 
		{printf("I have a typedef-------\n");}
		;




Literal:
	BasicLit 
	| FunctionLit 
	{printf("I have a literal-------\n");}
	;

string_lit:
	STRING 
	{printf("I have a string_list-------\n");}
	;

//added later
byte_lit:
	BYTE 
	{printf("I have a byte_lit-------\n");}
	;
	
BasicLit:
	int_lit 
	| float_lit 
	| string_lit 
	| byte_lit 	//added later
	{printf("I have a basiclit-------\n");}
	;


FunctionLit:
	FUNC Function 
	{printf("I have a functionlit-------\n");};
//-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\nstart
PrimaryExpr:
	Operand |
	PrimaryExpr Selector |
	PrimaryExpr Index |
	PrimaryExpr TypeAssertion
	{printf("I have a primaryexpr-------\n");}
	;
//-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-------\n-end

Selector:
	PERIOD IDENTIFIER {printf("I have a selector-------\n");};
Index:	
	LBRACK Expression RBRACK {printf("I have a index-------\n");};


TypeAssertion:
	PERIOD LPAREN Type RPAREN 
	{printf("I have a typeassertion-------\n");}
	;

Expression:
    Expression1 
	{printf("I have a expression-------\n");}
    ;

Expression1:
    Expression1 LOR Expression2 
    | Expression2 
	{printf("I have a expression1-------\n");}
    ;

Expression2:
    Expression2 LAND Expression3 
    | Expression3 
	{printf("I have a expression2-------\n");}
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
    ;
    
//till here*/	

UnaryExpr:
	PrimaryExpr 
	| unary_op PrimaryExpr 
	//UnaryExpr 
	{printf("I have a unaryexpr-------\n");}
	;

//ops using tokens
/*
binary_op:
	LOR 
	| LAND 
	| rel_op 
	| add_op 
	| mul_op ;*/
rel_op:
	EQL 
	| NEQ 
	| LSS 
	| LEQ 
	| GTR 
	| GEQ {printf("I have a rel_op-------\n");};
add_op:
	ADD 
	| SUB 
	| OR 
	| XOR {printf("I have add_op -------\n");};
mul_op:
	MUL 
	| QUO 
	| REM 
	| SHL 
	| SHR 
	| AND 
	| AND_NOT {printf("I have a mul_op-------\n");};
//------------------------------------------------------------------------------------------
unary_op:
	ADD 
	| SUB 
	| NOT 
	| XOR 
	| MUL 
	| AND 
	{printf("I have a unary_op-------\n");}
	;
//---------------------------------------------------------------------------------------------------------------

assign_op:
	  ASSIGN 
	| ADD_ASSIGN 
	| SUB_ASSIGN 
	| MUL_ASSIGN 
	| QUO_ASSIGN 
	| REM_ASSIGN 
	| DEFINE 
	{printf("I have assign_op -------\n");}
	;
/*IfStmt shift/reduce conflict*/

PackageClause:
	/*PACKAGE*/PACKAGE PackageName 
	{printf("I have a packageclause-------\n");}
	;
PackageName:
	IDENTIFIER 
	{printf("I have a packagename-------\n");}
	;
	
ImportDeclList:
    //* empty */     |
      ImportDeclList ImportDecl   
    | /*empty*/ 
	{printf("I have a importdecllist-------\n");}
    ;

ImportDecl:
	IMPORT ImportSpec eol 
	| IMPORT LPAREN ImportSpecList  RPAREN 
	//{printf("I have a importdecl-------\n");}
	
	;

ImportSpecList:
	ImportSpecList ImportSpec eol 
	| ImportSpec eol 
	{printf("I have a importspeclist-------\n");}
	;
ImportSpec:
	 PERIOD ImportPath 
	| PackageName2 ImportPath 
	| PackageName2
	{printf("I have a importspec-------\n");} ;
ImportPath:
	string_lit 
	{printf("I have a importpath-------\n");}
	;
PackageName2:
	string_lit 
	{printf("I have a packagename2-------\n");}	
	;
%%
#include "lex.yy.c"
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[])
{
	//main1(argv[1]);
	yyin = fopen(argv[1], "r");
	yylineno=1;
	if(!yyparse())
		printf("\nParsing complete\n");
	else
		printf("\nParsing failed\n");

	fclose(yyin);
	display();
		
	disp();
	
	return 0;
}
//extern int lineno;
extern char *yytext;
void yyerror(const char *s) {
	printf("\nLine %d : %s\n", (yylineno), s);
}         



    
