%{
int lineno = 1;
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define	 ASSIGN	1
#define	 ADD	2
#define	 SUB	3
#define	 MUL	4
#define	 QUO	5
#define	 REM	6
#define	 AND	7
#define	 OR	8
#define	 XOR	9
#define	 SHL	10
#define	 SHR	11
#define	 AND_NOT	12
#define	 ADD_ASSIGN	13
#define	 SUB_ASSIGN	14
#define	 MUL_ASSIGN	15
#define	 QUO_ASSIGN	16
#define	 REM_ASSIGN	17
#define	 AND_ASSIGN	18
#define	 OR_ASSIGN	19
#define	 XOR_ASSIGN	20
#define	 SHL_ASSIGN	21
#define	 SHR_ASSIGN	22
#define	 AND_NOT_ASSIGN	23
#define	 LAND	24
#define	 LOR	25
#define	 ARROW	26
#define	 INC	27
#define	 DEC	28
#define	 EQL	29
#define	 GTR	30
#define	 LSS	31
#define	 NOT	32
#define	 NEQ	33
#define	 LEQ	34
#define	 GEQ	35
#define	 ELLIPSIS	36
#define	 LPAREN	37
#define	 RPAREN	38
#define	 LBRACE	39
#define	 RBRACE	40
#define	 LBRACK	41
#define	 RBRACK	42
#define	 COMMA	43
#define	 SEMICOLON	44
#define	 COLON	45
#define	 PERIOD	46
#define	 DEFINE	47
#define	 PACKAGE	48
#define	 IMPORT	49
#define	 FUNC	50
#define	 BREAK	51
#define	 CASE	52
#define	 CONST	53
#define	 CONTINUE	54
#define	 DEFAULT	55
#define	 ELSE	56
#define	 FOR	57
#define	 GO	58
#define	 IF	59
#define	 RANGE	60
#define	 RETURN	61
#define	 STRUCT	62
#define	 SWITCH	63
#define	 TYPE	64
#define	 VAR	65
#define	 VAR_TYPE	66
#define	 BOOL_CONST	67
#define	 NIL_VAL	68
#define	 IDENTIFIER	69
#define	 INTEGER	70
#define	 FLOAT	71
#define	 BYTE	72
#define	 STRING	73
#define SLC 74
#define MLCS 75
#define MLCE 76
#define DQ 77
#define ARR 78
#define NUM_ERR 79
#define UNKNOWN 80
%}
%option nounput yylineno
UNICODE_LETTER			[a-zA-Z]
LETTER				[a-zA-Z_]
DIGIT				[0-9]
UNICODE_CHAR			[^\n]
NEW_LINE			[\n]
VAR_TYPE			"bool"|"byte"|"error"|"float32"|"float64"|"int"|"int8"|"int16"|"int32"|"int64"|"rune"|"string"|"uint"|"uint8 "|"uint16"|"uint32"|"uint64"|"uintptr"
BOOL_CONST			"true"|"false"
NIL_VAL				"nil"

%%
"="				return ASSIGN;
"+"				return ADD;
"-"				return SUB;
"*"				return MUL;
"/"				return QUO;
"%"				return REM;

"&"				return AND;
"|"				return OR;
"^"				return XOR;
"<<"				return SHL;
">>"				return SHR;
"&^"				return AND_NOT;

"+="				return ADD_ASSIGN;
"-="				return SUB_ASSIGN;
"*="				return MUL_ASSIGN;
"/="				return QUO_ASSIGN;
"%="				return REM_ASSIGN;

"&="				return AND_ASSIGN;
"|="				return OR_ASSIGN;
"^="				return XOR_ASSIGN;
"<<="				return SHL_ASSIGN;
">>="				return SHR_ASSIGN;
"&^="				return AND_NOT_ASSIGN;

"&&"				return LAND;
"||"				return LOR;
"->"				return ARROW;
"++"				return INC;
"--"				return DEC;

"=="				return EQL;
">"				return GTR;
"<"				return LSS;
"!"				return NOT;

"!="				return NEQ;
"<="				return LEQ;
">="				return GEQ;
":="				return DEFINE;
"..."				return ELLIPSIS;

"("				return LPAREN;
")"				return RPAREN;
"{"				return LBRACE;
"}"				return RBRACE;
"["				return LBRACK;
"]"				return RBRACK;
","				return COMMA;
";"				return SEMICOLON;
":"				return COLON;
"."				return PERIOD;

"//"	return SLC;
"/*"	return MLCS;
"*/"	return MLCE;

"package"			return PACKAGE;
"import"			return IMPORT;
"func"				return FUNC;
"break"				return BREAK;
"case"				return CASE;
"const"				return CONST;
"continue"        		return CONTINUE;
"default"        		return DEFAULT;
"else"				return ELSE;
"for"				return FOR;
"go"        			return GO;
"if"				return IF;
"range"				return RANGE;
"return"        		return RETURN;
"struct"        		return STRUCT;
"switch"        		return SWITCH;
"type"       			return TYPE;
"var"        			return VAR;
{VAR_TYPE}			return VAR_TYPE;
{BOOL_CONST}			return BOOL_CONST;
{NIL_VAL}			return NIL_VAL;

{LETTER}({LETTER}|{DIGIT})*	return IDENTIFIER;
[+-]?{DIGIT}+			return INTEGER;
[+-]?{DIGIT}+(\.{DIGIT}+)?([Ee][+-]?{DIGIT}+)?		return FLOAT;
\'{UNICODE_CHAR}\'  		return BYTE;

\"([^\\\n\"]|(\\.))*\"	return STRING;
\/\/{UNICODE_CHAR}*\n		;
{UNICODE_LETTER}({UNICODE_LETTER}|{DIGIT}|_)*\[{DIGIT}*\]	return ARR;
({DIGIT}+)\.({DIGIT}+)\.({DIGIT}|\.)* return NUM_ERR;
({DIGIT}|@)+(@|{DIGIT}|_|@)* return UNKNOWN;
"\n"				;
"\t"				;
" "				;
.				printf("ERROR : unexpected character in line %d\n",yylineno);

%%

struct node
{
	char token[100];
    	char attr[100];
	struct node *next;
};

struct hash
{
	struct node *head;
	int count;
};

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void insertToHash(char *token, char *attr)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("-------------------------------------------------------------------");
    	printf("\nSNo \t|\tToken \t\t|\tToken Type \t\n");
        printf("-------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\t\n", myNode->attr);
            		myNode = myNode->next;
        	}
	}
   	return;
}

int main()
{
	int scan, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
	yyin = fopen("p1.go","r");
	printf("\n\n");
	scan = yylex();
	while(scan)
	{
		if(lineno == slcline)
		{
			scan = yylex();
			continue;
		}
		if(lineno!=dqline && dqline!=0)
		{
			if(dq%2!=0)
				printf("\n******** ERROR!! INCOMPLETE STRING at Line %d ********\n\n", dqline);
			dq=0;
		}
		if((scan>=48 && scan<=68) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "KEYWORD");
		}
		if(scan==69 && mlc==0)
		{
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER");
		}
		if(scan==74)
		{
			printf("%s\t\t\tSingleline Comment\t\tLine %d\n", yytext, lineno);
			slcline = lineno;
		}
		if(scan==75 && mlc==0)
		{
			printf("%s\t\t\tMultiline Comment Start\t\tLine %d\n", yytext, lineno);
			mlcline = lineno;
			mlc = 1;
		}
		if(scan==76 && mlc==0)
		{
			printf("\n******** ERROR!! UNMATCHED MULTILINE COMMENT END %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==76 && mlc==1)
		{
			mlc = 0;
			printf("%s\t\t\tMultiline Comment End\t\tLine %d\n", yytext, lineno);
		}
		if((scan>=1 && scan<=35) || scan==47 && mlc==0)
		{
			printf("%s\t\t\tOPERATOR\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "OPERATOR");
		}
		if((scan==77||(scan>=36 && scan<=40)||(scan>=43 && scan<=46)) && mlc==0)
		{
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, lineno);
			if(scan==77)
			{
				dq++;
				dqline = lineno;
			}
			insertToHash(yytext, "SPECIAL SYMBOL");
		}
		// if(scan==56 && mlc==0)
		// {
		// 	printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, lineno);
		// 	insertToHash(yytext, "IDENTIFIER");
		// }
		// if((scan==57 || scan==58) && mlc==0)
		// {
		// 	printf("%s\t\t\tPRE DEFINED FUNCTION\t\tLine %d\n", yytext, lineno);
		// 	insertToHash(yytext, "PRE DEFINED FUNCTION");
		// }
		if(scan==70 && mlc==0)
		{
			printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "INTEGER CONSTANT");
		}
		if(scan==71 && mlc==0)
		{
			printf("%s\t\t\tFLOATING POINT CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "FLOATING POINT CONSTANT");
		}
		if(scan==78 && mlc==0)
		{
			printf("%s\t\t\tARRAY\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "ARRAY");
		}
		// if(scan==50 && mlc==0)
		// {
		// 	printf("%s\t\t\tUSER DEFINED FUNCTION\t\tLine %d\n", yytext, lineno);
		// 	insertToHash(yytext, "USER DEFINED FUNCTION");
		// }
		if(scan==79 && mlc==0)
		{
			printf("\n******** ERROR!! CONSTANT ERROR %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==80 && mlc==0)
		{
			printf("\n******** ERROR!! UNKNOWN TOKEN %s at Line %d ********\n\n", yytext, lineno);
		}
		// if(scan==73 && mlc==0)
		// {
		// 	printf("%s\t\t\tCHARACTER CONSTANT\t\t\tLine %d\n", yytext, lineno);
		// 	insertToHash(yytext, "CHARACTER CONSTANT");
		// }
		// if(scan==71 && mlc==0)
		// {
		// 	printf("%s\t\t\tSIGNED CONSTANT\t\t\tLine %d\n", yytext, lineno);
		// 	insertToHash(yytext, "SIGNED CONSTANT");
		// }
		if(scan==73 && mlc==0)
		{
			printf("%s\t\t\tSTRING CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "STRING CONSTANT");
		}
		scan = yylex();
	}
	if(mlc==1)
		printf("\n******** ERROR!! UNMATCHED COMMENT STARTING at Line %d ********\n\n",mlcline);
	printf("\n");
	printf("\n\t******** SYMBOL TABLE ********\t\t\n");
	display();
        printf("-------------------------------------------------------------------\n\n");
}
int yywrap()
{
	return 1;
}