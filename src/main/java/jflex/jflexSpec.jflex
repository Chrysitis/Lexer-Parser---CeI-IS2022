
/* user code */
package jflex;
//import java_cup.sym;
import java_cup.runtime.*;
import cup.*;
%%

/* options and declarations */
%class Lexer
%cup
//%implements sym
%line
%column

%{
  StringBuilder string = new StringBuilder();
  
  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }
%}

// ---------- Some type definitions ----------
sign = -
zero = 0 | 0.0
digR = [1 ... 9]
digs = [0 ... 9]
decimalPoint =  \. 

// ---------- char ----------
char = [a...z A...Z]

// ---------- integer ----------
integer = zero
integer = sign integer | integer
integer = digR integerRest
integerRest = digs intergerRest
integerRest = digs

// ---------- float ----------
float = zero
float = sign preDecimal postDecinmal | preDecimal postDecinmal
preDecimal = digR preDecimal
preDecimal = digs preDecimal
postDecimal = decimalPoint digs

// ---------- boolean ----------
boolean = TRUE | FALSE

// ---------- identifier ----------
identifier = char+ ( punctuation | digs ) *

// ---------- constant ----------
//As in to name a "case" in the case control structure.
constant = [ char digs ]*
// ---------- string ----------
string = char string

// ---------- relational expressions ----------
relationalOperator = < | <= | > | >= | == | !=
booleanRelationalOperator = == | !=

// ---------- logical expressions ----------
logicalOperator = AND | OR | NOT
// ---------- one/multi line comments ----------
comment = " // " ( char* | digs* ) comment
comment = " /* " ( char* | digs* ) comment
comment = ( char* | digs* ) comment
comment = " // " | " */ "

%%
/* Lexical rules */
":=" { return symbol(sym.EQ); }
";" { return symbol(sym.SEMI); }
"+" { return symbol(sym.ADD); }
"-" { return symbol(sym.SUBS); }
"*" { return symbol(sym.MULT); }
"/" { return symbol(sym.DIV); }
[^] { throw new Error("That is not what I call a legal character >.< <"+yytext()+">"); }
