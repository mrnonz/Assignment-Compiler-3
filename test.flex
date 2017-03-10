%{
#include <stdio.h>
#include "test.tab.h"
%}
%%
[0-9]+            { yylval.l = atol(yytext); return NUMBER; }
[a-fA-F0-9]+[h|H] { yylval.l = (int)strtol(yytext,NULL,16); return NUMBER;}

[s|S][h|H][o|O][w|W]	return SHOW;
[p|P][u|U][s|S][h|H]	return PUSH;
[p|P][o|O][p|P]			return POP;
[a|A][c|C][c|C]			return ACC;
[t|T][o|O][p|P]			return TOP;
[s|S][i|I][z|Z][e|E]	return SIZE;
[l|L][o|O][a|A][d|D]	return LOAD;
[a|A][n|N][d|D]			return OP_AND;
[o|O][r|R]				return OP_OR;
[n|N][o|O][t|T]			return OP_NOT;
"$"						return DOLLAR;

[r][A-Z]		  { yylval.l = yytext[1] - 65; return REG; }
[r][a-z]		  { yylval.l = yytext[1] - 97; return REG; }

[a-zA-Z0-9]+			return ERROR_TOK;


[ \t\v\f]		{ }

"+"						return '+';
"-"						return '-';
"*"						return '*';
"/"						return '/';
"\\"						return '\\';
"^"						return '^';
"\n"					return '\n';
"("						return '(';
")"						return ')';
%%
