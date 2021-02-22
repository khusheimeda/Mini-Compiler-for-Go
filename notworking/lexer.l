



%{

int lineno = 1;

char datatype[100];

int tl;

char next;



#include <stdio.h>

#include <string.h> 



#include "define.h"



%}





UNICODE_LETTER			[a-zA-Z]

LETTER				[a-zA-Z_]

DIGIT				[0-9]

UNICODE_CHAR			[^\n]

NEW_LINE			[\n]

VAR_TYPE			"bool"|"byte"|"error"|"float32"|"float64"|"int"|"int8"|"int16"|"int32"|"int64"|"rune"|"string"|"uint"|"uint8 "|"uint16"|"uint32"|"uint64"|"uintptr"

BOOL_CONST			"true"|"false"

NIL_VAL				"nil"



%%

"/*"					{ printf("mlc");multicomment(); }

"//"					{ singlecomment(); }



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







"package"			{insertToHash(yytext,"KEYWORD",yylineno);return PACKAGE;}

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



{LETTER}({LETTER}|{DIGIT})*	{  

						strcpy(datatype,"IDENTIFIER");	

						insertToHash(yytext,datatype,yylineno);

							return IDENTIFIER; 

						}

					

[+-]?{DIGIT}+			{  insertToConstTable(yytext, yylineno, "INTEGER"); return INTEGER; }

[+-]?{DIGIT}+(\.{DIGIT}+)?([Ee][+-]?{DIGIT}+)?		{  insertToConstTable(yytext, yylineno, "FLOAT"); return FLOAT; }

\'{UNICODE_CHAR}\'  		return BYTE;



\"([^\\\n\"]|(\\.))*\"	{  insertToConstTable(yytext, yylineno, "STRING"); return STRING; } 

\/\/{UNICODE_CHAR}*\n		;

"\n"		{ yylineno++; }

"\t"				;

" "				;

.				printf("ERROR : unexpected character in line %d\n",yylineno);



%%



//#include "define.h"

#include "dependency.c"



struct cnode

{

	char num[50];

	int lno;

	char type[20];

};

struct cnode ctable[100];

int ccount = 0;



void insertToConstTable(char *num, int l, char *type)

{

	strcpy(ctable[ccount].num, num);

	strcpy(ctable[ccount].type, type);

	ctable[ccount].lno = l;

	ccount++;

}



void disp()

{

	int i;

	printf("\n\n------------------------------CONSTANT TABLE------------------------------\n");

	printf("--------------------------------------------------------------------------\n");

	printf("Value \t\t|\tData Type\t\t\n");

	printf("--------------------------------------------------------------------------\n");

	for(i=0;i<ccount;i++)

	{

		printf("%s\t\t\t", ctable[i].num);

		printf("%s\t\t\t\n", ctable[i].type);

		printf("\t%d\t\n", ctable[i].lno);

	}

	printf("\n\n");

}



struct node

{

	char token[100];

    	char attr[100];

    	int line[100];

    	int line_count;

	struct node *next;

};



struct hash

{

	struct node *head;

	int hash_count;

};



struct hash hashTable[1000];

int eleCount = 1000;



struct node * createNode(char *token, char *attr, int l)

{

	struct node *newnode;

	newnode = (struct node *) malloc(sizeof(struct node));

	strcpy(newnode->token, token);

	strcpy(newnode->attr, attr);

	newnode->line[0] = l;

	newnode->line_count = 1; 

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



void insertToHash(char *token, char *attr, int l)

{

	int flag=0;

	int hi;

	hi = hashIndex(token);

	struct node *newnode = createNode(token, attr, l);

	/* head of list for the bucket with index "hashIndex" */

	if (hashTable[hi].head==NULL)

	{

		hashTable[hi].head = newnode;

	        hashTable[hi].hash_count = 1;

	        return;

	}

	struct node *myNode;

    	myNode = hashTable[hi].head;

	while (myNode != NULL)

    	{

        	if (strcmp(myNode->token, token)==0)

        	{

            		flag = 1;

            		myNode->line[(myNode->line_count)++] = l;

            		if(strcmp(myNode->attr, attr)!=0)

            		{

            			strcpy(myNode->attr, attr);

            		}

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

		hashTable[hi].hash_count++;

	}

	return;

}







void display()

{

    	struct node *myNode;

    	int i,j, k=1;

    	printf("\n-----------------------------------------Symbol Table---------------------------------------------\n");

    	printf("--------------------------------------------------------------------------------------------------");

    	printf("\nToken \t\t|\tToken Type \t\t\t\t\t \n");

        printf("--------------------------------------------------------------------------------------------------\n");

    	for (i = 0; i < eleCount; i++)

    	{

        	if (hashTable[i].hash_count == 0)

            		continue;

        	myNode = hashTable[i].head;

        	if (!myNode)

            		continue;

        	while (myNode != NULL)

        	{

            		printf("%d\t\t", k++);

            		printf("%s\t\t\t", myNode->token);

            		printf("%s\t\t\t", myNode->attr);

            		for(j=0;j<(myNode->line_count);j++)

            			printf("%d  ",myNode->line[j]);

            		printf("\n");

            		myNode = myNode->next;

        	}

	}

	printf("--------------------------------------------------------------------------------------------------\n");

   	return;

}





yywrap()

{

	return(1);

}

multicomment()

{

	char c, c1;

	while ((c = input()) != '*' && c != 0);

	c1=input();

	if(c=='*' && c1=='/')

	{

		c=0;

	}

	if (c != 0)

		putchar(c1);

}

singlecomment()

{

	char c;

	while(c=input()!='\n');

	if(c=='\n')

		c=0;

	if(c!=0)

		putchar(c);

}

