%{



	int yylineno;



	char data_type[200];



%}



//%expect 19







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









 







%union{



	char str[1000];



}







%%

StartFile:

    PackageClause SEMICOLON ImportDeclList TopLevelDeclList 

    ;



Block:

	LBRACE OPENB StatementList CLOSEB RBRACE

	//printf("I have a block -------");cout << $1 << endl;}

	; 





OPENB:

	/*empty*/

	;

	

CLOSEB:

	/*empty*/

	;



StatementList:

    StatementList Statement SEMICOLON 

    | Statement SEMICOLON 

    ;



Statement:

	Declaration 

	| LabeledStmt 

	| SimpleStmt 

	|ReturnStmt 

	| BreakStmt 

	| ContinueStmt 

	|Block 

	| IfStmt 

	|  ForStmt  

	| FunctionCall  

	| FunctionStmt ;



SimpleStmt:

	EmptyStmt 

	|  IncDecStmt 

	| Assignment  

;



EmptyStmt:

	/*empty*/

	;







LabeledStmt:

	Label COLON Statement ;

Label:

	IDENTIFIER ;







IncDecStmt:

	Expression INC 

	|Expression DEC ;



Assignment:

	ExpressionList assign_op ExpressionList 

	;



VarDecl:

		VAR VarSpec 

		;

VarSpec:

		IdentifierList Type ASSIGN ExpressionList 

		| IdentifierList Type 

		;





Declaration:

	ConstDecl 

	| TypeDecl 

	| VarDecl ;





FunctionDecl:

		FUNC FunctionName OPENB Function CLOSEB 

		|FUNC FunctionName OPENB Signature CLOSEB ;

FunctionName:

		IDENTIFIER ;

Function:

		Signature FunctionBody ;

FunctionBody:		

		Block ;

//-----------------------------------------------------------------------------------------------start

//function call starts here

FunctionStmt:

		VarDecl DEFINE FunctionCall

		//new changes

		| IDENTIFIER DEFINE FunctionCall

		;





FunctionCall:	PrimaryExpr LPAREN ArgumentList RPAREN 

		;		



ArgumentList:	

		ArgumentList COMMA Arguments 

		| Arguments 

		| /*empty*/

		;



Arguments:	PrimaryExpr 

		| FunctionCall 

		;

		

//function call till here 



Signature:

	Parameters 

	|Parameters Result ;



//------------------------------------------------------------------------------------------------------end

Result:

	LPAREN TypeList RPAREN 

	| Type  ;



Parameters:

	LPAREN RPAREN 

	| LPAREN ParameterList RPAREN 

	|LPAREN ParameterList COMMA RPAREN 

	; 

ParameterList:

	ParameterDecl 

	|ParameterList COMMA ParameterDecl 

	;



//change



ParameterDecl:

	IdentifierList Type 

	| IdentifierList ELLIPSIS  Type 

	|ELLIPSIS Type 

	;



TypeList:

    TypeList COMMA Type 

    | Type 

    ;



//change

//--------------------------------------------------------------------------------------------------------------------------------start

IdentifierList:

		IDENTIFIER IdentifierLIST 

		| IDENTIFIER 

		;

//-----------------------------------------------end		

IdentifierLIST:	IdentifierLIST COMMA IDENTIFIER 

		| COMMA IDENTIFIER 

		;



//change

MethodDecl:

	FUNC Receiver IDENTIFIER Function 

	| FUNC Receiver IDENTIFIER Signature 

	;



Receiver:

	Parameters ;



TopLevelDeclList:

    TopLevelDeclList SEMICOLON /*here colon*/ TopLevelDecl  

    | TopLevelDecl  

    ;



TopLevelDecl:

	Declaration 	

	| FunctionDecl 

	| MethodDecl 

	;



TypeLit:

	ArrayType 

	| StructType 

	| PointerType 

	| FunctionType 

	;





//change



Type:

	TypeName 

	| TypeLit 

	;



Operand:

	Literal 

	| OperandName 

	| LPAREN Expression RPAREN ;



OperandName:

	IDENTIFIER 

;



ReturnStmt:

	RETURN Expression 

	|RETURN ;



BreakStmt:

	BREAK Label 

	| BREAK ;



ContinueStmt:

	CONTINUE Label 

	|CONTINUE 

	;



IfStmt:

	IF OPENB Expression Block CLOSEB 

	|IF OPENB SimpleStmt SEMICOLON Expression Block CLOSEB 

	|IF OPENB SimpleStmt SEMICOLON Expression Block ELSE IfStmt CLOSEB  

	|IF OPENB SimpleStmt SEMICOLON Expression Block ELSE  Block CLOSEB 

	|IF OPENB Expression Block ELSE IfStmt CLOSEB 

	|IF OPENB Expression Block ELSE  Block CLOSEB 

	;



ForStmt:

	FOR OPENB Condition Block CLOSEB 

	|FOR OPENB ForClause Block CLOSEB 

	;

Condition:

	Expression ;



ForClause:

	InitStmt SEMICOLON Condition SEMICOLON PostStmt 

	;

InitStmt:

	SimpleStmt ;

PostStmt:

	SimpleStmt ;



int_lit:

	INTEGER

	;

float_lit:

	  FLOAT

	  ;







TypeName:

	IDENTIFIER 

	| VAR_TYPE 

	;







ArrayType:

	LBRACK ArrayLength RBRACK Type

	;



ArrayLength:

	Expression

	;



StructType:

    STRUCT LBRACE FieldDeclList RBRACE 

    | STRUCT LBRACE RBRACE 

    ;



FieldDeclList:

    FieldDecl SEMICOLON 

    | FieldDeclList FieldDecl SEMICOLON 

    ;



FieldDecl:

	IdentifierList Type 

	| IdentifierList Type Tag 

	;



Tag:

	STRING 

	;



PointerType:

	MUL BaseType 

	;

BaseType:

	Type 

	;



FunctionType:

	FUNC Signature 

	;



ConstDecl:

		CONST ConstSpec 

		;



ConstSpec:

		IDENTIFIER Type ASSIGN Expression 

		| IDENTIFIER Type 

		;



ExpressionList:

		ExpressionList COMMA Expression 

		| Expression 

		;



TypeDecl:

		TYPE  TypeSpec 

		| TYPE LPAREN TypeSpecList RPAREN ;



TypeSpecList:

		TypeSpecList TypeSpec SEMICOLON 

		| TypeSpec SEMICOLON 

		;

TypeSpec:

		AliasDecl 

		| TypeDef ;



AliasDecl:

		IDENTIFIER ASSIGN Type 

		;



TypeDef:

		IDENTIFIER Type 

		;









Literal:

	BasicLit 

	| FunctionLit 

	;



string_lit:

	STRING 

	;



//added later

byte_lit:

	BYTE 

	;

	

BasicLit:

	int_lit 

	| float_lit 

	| string_lit 

	| byte_lit 	//added later

	;





FunctionLit:

	FUNC Function ;

//-----------------------------------------------------------------------------start

PrimaryExpr:

	Operand |

	PrimaryExpr Selector |

	PrimaryExpr Index |

	PrimaryExpr TypeAssertion |

	OperandName StructLiteral 

	;

//------------------------------------------------------------------------------end

//here struct literal

StructLiteral:

    LBRACE KeyValList RBRACE 

    ;



KeyValList:

    	/* empty */  

 	| Expression COLON Expression 

	| KeyValList COMMA Expression COLON Expression  

	;

//till here struct literal



Selector:

	PERIOD IDENTIFIER ;

Index:	

	LBRACK Expression RBRACK ;





TypeAssertion:

	PERIOD LPAREN Type RPAREN 

	;



Expression:

    Expression1 

    ;



Expression1:

    Expression1 LOR Expression2 

    | Expression2 

    ;



Expression2:

    Expression2 LAND Expression3 

    | Expression3 

    ;



Expression3:

    Expression3 rel_op Expression4 

    | Expression4 

    ;



Expression4:

    Expression4 add_op Expression5 

    | Expression5 

    ;



Expression5:

    Expression5 mul_op PrimaryExpr 

    | UnaryExpr 

    ;

    

//till here*/	



UnaryExpr:

	PrimaryExpr 

	| unary_op PrimaryExpr 

	//UnaryExpr 

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

	| GEQ ;

add_op:

	ADD 

	| SUB 

	| OR 

	| XOR ;

mul_op:

	MUL 

	| QUO 

	| REM 

	| SHL 

	| SHR 

	| AND 

	| AND_NOT ;

//-------------------------------------------------------------------------------------------start

unary_op:

	ADD 

	| SUB 

	| NOT 

	| XOR 

	| MUL 

	| AND 

	;

//----------------------------------------------------------------------------------------------------------------end



assign_op:

	  ASSIGN 

	| ADD_ASSIGN 

	| SUB_ASSIGN 

	| MUL_ASSIGN 

	| QUO_ASSIGN 

	| REM_ASSIGN 

	| DEFINE 

	;

/*IfStmt shift/reduce conflict*/



PackageClause:

	/*PACKAGE*/PACKAGE PackageName 

	;

PackageName:

	IDENTIFIER 

	;

	

ImportDeclList:

    //* empty */     |

      ImportDeclList ImportDecl  

    | ImportDecl  

    | /*empty*/ 

    ;



ImportDecl:

	IMPORT ImportSpec SEMICOLON 

	| IMPORT LPAREN ImportSpecList  RPAREN 

	;



ImportSpecList:

	ImportSpecList ImportSpec SEMICOLON 

	| ImportSpec SEMICOLON 

	;

ImportSpec:

	 PERIOD ImportPath 

	| PackageName2 ImportPath 

	| PackageName2 ;

ImportPath:

	string_lit 

	;

PackageName2:

	string_lit 	

	;

%%

#include "lex.yy.c"

#include <stdio.h>

#include <string.h>

int main(int argc, char *argv[])

{

	yyin = fopen(argv[1], "r");

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

yyerror(char *s) {

	printf("\nLine %d : %s\n", (yylineno), s);

}         





