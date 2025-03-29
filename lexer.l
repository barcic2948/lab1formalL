%option noyywrap 

%{
	
	#include <iostream>
    #include <set>
    #include <string>
    #include <cstdio>

    using namespace std;

    int line_length = 0;
    void check_line_length() {
        if (line_length > 132) {
            fprintf(stderr, "Warning: Line exceeds 132 characters!\n");
        }
        line_length = 0;
    }

%}

%x COMMENT

TYPE_REG (bool|int|float|string)
RELATIONAL_REG (=|<|>|<=|>=)
OPERATION_REG (\+|\-|\*|\/)
BRACKET_REG (\(|\)|\{|\}|\[|\]|<|>)
SEMI_REG (;)
VAR_REG [a-zA-Z_][a-zA-Z0-9_]*
COMMENT_SINGLE "//".*
COMMENT_MULTI_START "/*"
NEWLINE \n

%%

{COMMENT_SINGLE} { /* Ignore single-line comments */ }
{COMMENT_MULTI_START} { BEGIN(COMMENT); }

<COMMENT>[^*\n]+ ; /* Consume everything except '*' */
<COMMENT>\*+[^*/\n]* ; /* Consume '*' sequences not followed by '/' */
<COMMENT>"*/" { BEGIN(INITIAL); } /* End of multi-line comment */
<COMMENT>. ; /* Consume other characters in comment state */

{NEWLINE} { check_line_length(); }
{TYPE_REG} { printf("Found type: %s\n", yytext); line_length += yyleng; }
{OPERATION_REG} { printf("Found arithmetic operator: %s\n", yytext); line_length += yyleng; }
{RELATIONAL_REG} { printf("Found relational operator: %s\n", yytext); line_length += yyleng; }
{BRACKET_REG} { printf("Found bracket: %s\n", yytext); line_length += yyleng; }
{SEMI_REG} { printf("Found semicolon\n"); line_length += yyleng; }
{VAR_REG} { printf("Found variable: %s\n", yytext); line_length += yyleng; }
[ \t]+  { line_length += yyleng; }
. { printf("Found other character: %s\n", yytext); line_length += yyleng; }

%%
int main() 
{
    yyin = fopen("test.txt", "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }
    yylex();   
    fclose(yyin);
    return 0;
}