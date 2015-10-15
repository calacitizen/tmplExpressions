/* description: Parses and executes conditional expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"==="                 return '==='
"!=="                 return '!=='
"&&"                  return '&&'
"||"                  return '||'
"("                   return '('
")"                   return ')'
"!"                   return '!'
"."                   return '.'
"|"                   return '|'
"true"                return 'BOOL'
"false"               return 'BOOL'
"null"                return 'NULL'
"undefined"           return 'UNDEFINED'
[A-Za-z_][A-Za-z_0-9.]* return 'LITERAL'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '|'
%left '===' '!=='
%left '&&' '||'

%start expressions

%%

expressions
    : e EOF
        { return (function(lambdas) { return new Function('data', 'return ' + $1) })(lambdas); }
    ;

e
    : e '|' e
        {$$ = 'lambdas.' + $3 + '.call(' + $1 + ')'; }
    | e '===' e
        {$$ = '(' + $1 + '===' + $3+ ')';}
    | e '!==' e
        {$$ = '(' + $1 + '!==' + $3 + ')';}
    | e '&&' e
        {$$ = '(' + $1 + '&&' + $3 + ')';}
    | e '||' e
        {$$ = '(' + $1 + '||' + $3 + ')';}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = 'Number(' + yytext + ')';}
    | BOOL
        {$$ = 'Boolean(' + yytext + ')';}
    | NULL
        {$$ = 'null';}
    | UNDEFINED
        {$$ = 'undefined';}
    | LITERAL
        { $$ = 'data.' + $1 }
    ;
