%option noyywrap

%{
/* Now in a section of C that will be embedded
   into the auto-generated code. Flex will not
   try to interpret code surrounded by %{ ... %} */

/* Bring in our declarations for token types and
   the yylval variable. */
#include "histogram.hpp"


// This is to work around an irritating bug in Flex
// https://stackoverflow.com/questions/46213840/get-rid-of-warning-implicit-declaration-of-function-fileno-in-flex
extern "C" int fileno(FILE *stream);

/* End the embedded code section. */
%}


%%
-?[0-9]+(\.[0-9]*)?          {
  fprintf(stderr, "Number : %s\n", yytext);
  char sign = yytext[0];
  if (sign == '-')
    yytext++;
  sscanf(yytext, "%lf", &yylval.numberValue);
  if (sign == '-')
    yylval.numberValue *= -1;
  return Number;
}

-?[0-9]+(\/[0-9]+)? {
  fprintf(stderr, "Number : %s\n", yytext);
  char sign = yytext[0];
  if (sign == '-')
    yytext++;
  double top, bottom;
  sscanf(yytext, "%lf/%lf", &top, &bottom);

  yylval.numberValue = top / bottom;
  if (sign == '-')
    yylval.numberValue *= -1;
  return Number;
}

([a-z]|[A-Z])+          {
  fprintf(stderr, "Word : %s\n", yytext);
  yylval.wordValue = new std::string;
  *yylval.wordValue = yytext;
  return Word;
}

(\[[^\]]*\]) {
  fprintf(stderr, "Word : %s\n", yytext);
  yytext++;
  yytext[strlen(yytext)-1] = '\0';
  fprintf(stderr, "%c\n", yytext[strlen(yytext)-1]);
  yylval.wordValue = new std::string;
  *yylval.wordValue = yytext;
  return Word;
}


\n              { fprintf(stderr, "Newline\n"); }

.               {
return Other;
}

%%

/* Error handler. This will get called if none of the rules match. */
void yyerror (char const *s)
{
  fprintf (stderr, "Flex Error: %s\n", s); /* s is the text that wasn't matched */
  exit(1);
}


