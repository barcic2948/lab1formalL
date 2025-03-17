
/*
{MAIL_REGEX} {isMailValid=true; printf("Found valid email\n");}
{PASS_REGEX} {isPassValid = true; printf("Password\n");}

{TAB_REGEX} {tabCount++;}
{LINE_REGEX} {lineCount++;}
{WORD_REGEX} {wordCount++;}


*/ 

%option noyywrap 

%{
	
	#include <iostream>
   	#include <set>
   	#include <string>

    bool isMailValid = false;
    bool isPassValid = false;

    int tabCount = 0;
    int lineCount = 1;
    int wordCount = 0;




%}
MAIL_REGEX [a-zA-Z0-9]+@[a-zA-Z0-9]+[.]+[a-z]+
PASS_REGEX [A-Z]+[a-z0-9]{7,14}[^a-z^A-Z^0-9]+
TAB_REGEX [\t]+
LINE_REGEX [\n]
WORD_REGEX [a-zA-Z]+

TYPE_REG (bool|int|float|string|)
OPERATION_REG ("+"|"-"|"*"|"/")
BRACKET_REG ("("[.*]")"|"{"[.*]"}"|"["[.*]"]"|"<"[.*]">")
SEMI_REG ";"
VAR_REG [a-zA-Z]+[a-zA-Z0-9]+

%%

. {}
%%
int main() 
{
    yyin = fopen ("test.txt", "r");
    yylex();   

    if (!isMailValid) {
        //printf("Did not find valid email\n");
    }

    //printf("Tab count %d\n", tabCount);
    //printf("Line count %d\n", lineCount);
    //printf("Word count %d\n", wordCount);

    return 0;
}