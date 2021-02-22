#include <stdio.h>

char* substr(const char *src, int m, int n)
{
    // get length of the destination string
    int len = n - m;
 
    // allocate (len + 1) chars for destination (+1 for extra null character)
    char *dest = (char*)malloc(sizeof(char) * (len + 1));
 
    // extracts characters between m'th and n'th index from source string
    // and copy them into the destination string
    for (int i = m; i < n && (*(src + i) != '\0'); i++)
    {
        *dest = *(src + i);
        dest++;
    }
 
    // null-terminate the destination string
    *dest = '\0';
 
    // return the destination string
    return dest - len;
}

int main1(char *f)
{
	int scan, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
	yyin = fopen(f,"r");
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
		lineno = yylineno;
		if((scan>=48 && scan<=68) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "KEYWORD",lineno);
		}
		if(scan==69 && mlc==0)
		{
			if(strlen(yytext)>31)
			{
				char * temp = substr(yytext, 0, 31);
				yytext = temp;
			}
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER",lineno);
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
			insertToHash(yytext, "OPERATOR",lineno);
		}
		if((scan==77||(scan>=36 && scan<=40)||(scan>=43 && scan<=46)) && mlc==0)
		{
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, lineno);
			if(scan==77)
			{
				dq++;
				dqline = lineno;
			}
			insertToHash(yytext, "SPECIAL SYMBOL",lineno);
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
			insertToHash(yytext, "INTEGER CONSTANT",lineno);
		}
		if(scan==71 && mlc==0)
		{
			char *pend;
			float in_float = strtof(yytext, &pend);
			char buf[100];
			gcvt(in_float, 32, buf);
			printf("%f\t\t\tFLOATING POINT CONSTANT\t\tLine %d\n", in_float, lineno);
			insertToHash(buf, "FLOATING POINT CONSTANT",lineno);
		}
		if(scan==78 && mlc==0)
		{
			printf("%s\t\t\tARRAY\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "ARRAY",lineno);
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
			insertToHash(yytext, "STRING CONSTANT",lineno);
		}
		scan = yylex();
	}
	if(mlc==1)
		printf("\n******** ERROR!! UNMATCHED COMMENT STARTING at Line %d ********\n\n",mlcline);
	printf("\n");
	printf("\n\t******** SYMBOL TABLE ********\t\t\n");
	display();
        printf("-------------------------------------------------------------------\n\n");
	fclose(yyin);
}
