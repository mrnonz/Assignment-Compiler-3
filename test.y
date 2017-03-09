%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

void yyerror (char const *);


typedef struct node {
	int val;
	struct node *next;
} acc_stack;

acc_stack *top_stack = NULL;
int stack_size = 0;
int temp = 0;
int reg_data[26] = {0};
%}

%union {
   int l;
}

%type <l> exp
%type <l> command_pop

/* Bison declarations.  */
%token SHOW TOP SIZE DOLLAR PUSH POP ACC LOAD ERROR_TOK;
%token <l> NUMBER; 
%token <l> REG;
%left '-' '+'
%left '*' '/'
%precedence NEG   /* negation--unary minus */
%right '^'        /* exponentiation */
%% /* The grammar follows.  */

input:
  %empty
| input line {printf("> ");}
;

line:
  '\n'
| exp '\n' {temp = $1; printf("= %d\n",temp);}
| commands '\n'
| err '\n'
;

err:
	ERROR_TOK {printf("! Syntax Error\n");}
;

commands:
	command_show
	| command_push
	| command_pop
	| command_load
;

command_show:
	SHOW DOLLAR TOP 	
	{
		if(top_stack!= NULL){
			printf("= %d\n",top_stack->val);
		}else{
			printf("! Stack is Empty\n");
		}
	}
	| SHOW DOLLAR SIZE
	{
		printf("= %d\n",stack_size);
	}
	| SHOW DOLLAR REG
	{
		printf("= %d\n",reg_data[$3]);
	}
	| SHOW DOLLAR ACC
	{
		printf("= %d\n",temp);
	}
;

command_push:
	PUSH DOLLAR ACC
	{
		push_item(temp);
	}
;

command_pop:
	POP DOLLAR REG
	{
		if(top_stack!= NULL){
			reg_data[$3] = pop_item();
		}else{
			printf("! Stack is Empty\n");
		}
	}
;

command_load:
	LOAD DOLLAR REG DOLLAR REG
	{
		reg_data[$5] = reg_data[$3];
	}
	| LOAD DOLLAR ACC DOLLAR REG
	{
		reg_data[$5] = temp;
	}
;

exp:
  NUMBER             { $$ = $1;        }
| DOLLAR REG 		 { $$ = reg_data[$2];	}
| exp '+' exp        { $$ = $1 + $3; }
| exp '-' exp        { $$ = $1 - $3;      }
| exp '*' exp        { $$ = $1 * $3;    }
| exp '/' exp        { $$ = $1 / $3;     }
| '-' exp  %prec NEG { $$ = -$2;          }
| exp '^' exp        { $$ = power($1, $3);}
| '(' exp ')'        { $$ = $2;           }
;

%%

void push_item(int n){
	acc_stack *new_node;
	new_node = malloc(sizeof(acc_stack));

	new_node->val = n;
	new_node->next = top_stack;
	top_stack = new_node;
	stack_size++;
}

int pop_item(){
	int tmp;
	acc_stack *tmp_node = top_stack;

	tmp = top_stack->val;
	top_stack = top_stack->next;
	free(tmp_node);
	stack_size--;

	return tmp;
}

void yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
    return 1;
} 

int power(int a,int b){
	int i;
	for(i = 1;i < b;i++){
		a *= a;
	}
	return a;
} 

int main()
{
	printf("> ");
    return yyparse ();
} 


