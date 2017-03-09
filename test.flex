%{
#include <stdio.h>
#include "test.tab.h"
%}
%%
[0-9]+            { yylval.l = atol(yytext); return NUMBER; }

[s|S][h|H][o|O][w|W]	return SHOW;
[p|P][u|U][s|S][h|H]	return PUSH;
[p|P][o|O][p|P]			return POP;
[a|A][c|C][c|C]			return ACC;

"$"						return DOLLAR;
[r][A-Z]		  { yylval.l = yytext[1] - 65; return REG; }
[t|T][o|O][p|P]			return TOP;
[s|S][i|I][z|Z][e|E]	return SIZE;

"+"						return '+';
"-"						return '-';
"*"						return '*';
"/"						return '/';
"^"						return '^';
"\n"					return '\n';
%%
