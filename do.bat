bison -d test.y
flex test.flex
gcc lex.yy.c test.tab.c
a