%{

//int yylineno = 1;

char datatype[100];

int tl;

char next;

#include <stdio.h>

#include <string.h> 
#include "parser.tab.h"
#include<stdbool.h>
#include <stdlib.h>

void insertToConstTable(char *num, int l, char *type);

void insertToHash(char *token, char *attr, int l);
void multicomment();
void singlecomment();
int yywrap();
%}






UNICODE_LETTER			[a-zA-Z]

LETTER				[a-zA-Z_]

DIGIT				[0-9]

UNICODE_CHAR			[^\n]

NEW_LINE			[\n]

VAR_TYPE			"bool"|"byte"|"error"|"float"|"float32"|"float64"|"int"|"int8"|"int16"|"int32"|"int64"|"rune"|"string"|"uint"|"uint8 "|"uint16"|"uint32"|"uint64"|"uintptr"

BOOL_CONST			"true"|"false"

NIL_VAL				"nil"



%%
		


"/*"					{multicomment(); }
"//"					{ singlecomment(); }


"="				{return ASSIGN;}

"+"				{return ADD;}

"-"				{return SUB;}

"*"				{return MUL;}

"/"				{return QUO;}

"%"				{return REM;}



"&"				{return AND;}

"|"				{return OR;}

"^"				{return XOR;}

"<<"				{return SHL;}

">>"				{return SHR;}

"&^"				{return AND_NOT;}



"+="				{return ADD_ASSIGN;}

"-="				{return SUB_ASSIGN;}

"*="				{return MUL_ASSIGN;}

"/="				{return QUO_ASSIGN;}

"%="				{return REM_ASSIGN;}



"&="				{return AND_ASSIGN;}

"|="				{return OR_ASSIGN;}

"^="				{return XOR_ASSIGN;}

"<<="				{return SHL_ASSIGN;}

">>="				{return SHR_ASSIGN;}

"&^="				{return AND_NOT_ASSIGN;}



"&&"				{return LAND;}

"||"				{return LOR;}

"->"				{return ARROW;}

"++"				{return INC;}

"--"				{return DEC;}



"=="				{return EQL;}

">"				{return GTR;}

"<"				{return LSS;}

"!"				{return NOT;}



"!="				{return NEQ;}

"<="				{return LEQ;}

">="				{return GEQ;}

":="				{return DEFINE;}

"..."				{return ELLIPSIS;}



"("				{return LPAREN;}

")"				{return RPAREN;}

"{"				{return LBRACE;}

"}"				{return RBRACE;}

"["				{return LBRACK;}

"]"				{return RBRACK;}

","				{return COMMA;}

";"				{return SEMICOLON;}

":"				{return COLON;}

"."				{return PERIOD;}







"package"			{insertToHash(yytext,"KEYWORD",yylineno);return PACKAGE;}

"import"			{insertToHash(yytext,"KEYWORD",yylineno);return IMPORT;}

"func"				{insertToHash(yytext,"KEYWORD",yylineno);return FUNC;}

"break"				{insertToHash(yytext,"KEYWORD",yylineno);return BREAK;}

"case"				{insertToHash(yytext,"KEYWORD",yylineno);return CASE;}

"const"				{insertToHash(yytext,"KEYWORD",yylineno);return CONST;}

"continue"        		{insertToHash(yytext,"KEYWORD",yylineno);return CONTINUE;}

"default"        		{insertToHash(yytext,"KEYWORD",yylineno);return DEFAULT;}

"else"				{insertToHash(yytext,"KEYWORD",yylineno);return ELSE;}

"for"				{insertToHash(yytext,"KEYWORD",yylineno);return FOR;}

"go"        			{insertToHash(yytext,"KEYWORD",yylineno);return GO;}

"if"				{insertToHash(yytext,"KEYWORD",yylineno);return IF;}

"range"				{insertToHash(yytext,"KEYWORD",yylineno);return RANGE;}

"return"        		{insertToHash(yytext,"KEYWORD",yylineno);return RETURN;}

"struct"        		{insertToHash(yytext,"KEYWORD",yylineno);return STRUCT;}

"switch"        		{insertToHash(yytext,"KEYWORD",yylineno);return SWITCH;}

"type"       			{insertToHash(yytext,"KEYWORD",yylineno);return TYPE;}

"var"        			{insertToHash(yytext,"KEYWORD",yylineno);return VAR;}

{VAR_TYPE}			{insertToHash(yytext,"KEYWORD",yylineno);return VAR_TYPE;}

{BOOL_CONST}			{insertToHash(yytext,"KEYWORD",yylineno);/*strcpy(yylval.bval,yytext);*/return BOOL_CONST;}

{NIL_VAL}			{insertToHash(yytext,"KEYWORD",yylineno);return NIL_VAL;}

"\n"		{ yylineno++; }

"\t"				;

" "				;



{LETTER}({LETTER}|{DIGIT})*	{  if(yyleng>31)
						{
							char temp[32];
							strncpy(temp,yytext,31);
							temp[31]='\0';
							strcpy(yytext,temp);
						}

							strcpy(datatype,"IDENTIFIER");
							

							insertToHash(yytext,datatype,yylineno);

							return IDENTIFIER; 

				}

					

[+-]?{DIGIT}+			{  insertToConstTable(yytext, yylineno, "INTEGER");yylval.ival = atoi(yytext); return INTEGER; }

[+-]?{DIGIT}+(\.{DIGIT}+)?([Ee][+-]?{DIGIT}+)?		{  char *pend;
			float in_float = strtof(yytext, &pend);
			char buf[100];
			gcvt(in_float, 32, buf);
			yylval.fval = atof(yytext);
			
			insertToConstTable(buf, yylineno, "FLOAT"); return FLOAT; }

\'{UNICODE_CHAR}\'  		return BYTE;


\"([^\\\n\"]|(\\.))*\" {  insertToConstTable(yytext, yylineno, "STRING"); 
			yylval.sval = strdup(yytext);
			return STRING; } 

\/\/{UNICODE_CHAR}*\n		;

.				printf("ERROR : unexpected character in line %d\n",yylineno);// yyerror("invalid character");


%%





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

	printf("Value \t\t|\tData Type\t\t|Lineno\n");

	printf("--------------------------------------------------------------------------\n");

	for(i=0;i<ccount;i++)

	{

		printf("%s\t\t\t", ctable[i].num);

		printf("%s\t\t\t", ctable[i].type);

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

    	printf("\nToken \t\t\t|\tToken Type \t\t\t|Line No \n");

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

            		printf("%d\t", k++);

            		printf("%s\t\t", myNode->token);

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
void multicomment()

{
	char c, c1;
	L1:
	while ((c = input()) != '*' && c != 0);
	c1=input();
	if(c=='*')
	{
		if(c1=='/')
			return;
		else
			goto L1;
	}
	printf("MLC not ended\n");
}

void singlecomment()

{

	char c;

	while(c=input()!='\n');

	if(c=='\n')

		c=0;

	if(c!=0)

		putchar(c);

}


int yywrap()

{

	return(1);

}
