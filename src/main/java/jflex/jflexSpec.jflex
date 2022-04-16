
/* user code */
package jflex;
//import java_cup.sym;
import java_cup.runtime.*;
import cup.*;
%%

/* options and declarations */
%class Lexer
%cup
%public
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
sign = "-"
zero = 0 | 0.0
digR = [1-9]
digs = [0-9]
decimalPoint =  \. 

// ---------- char ----------
char = [a-zA-Z]

// ---------- integer ----------
integer = {zero}
integer = {sign} {integer} | {integer}
integer = {digR} {integerRest}
integerRest = {digs} {intergerRest}
integerRest = {digs}

// ---------- float ----------
float = zero
float = sign preDecimal postDecinmal | preDecimal postDecinmal
preDecimal = digR preDecimal
preDecimal = digs preDecimal
postDecimal = decimalPoint digs

// ---------- boolean ----------
boolean = TRUE | FALSE

// ---------- identifier ----------
underScore = "_"
identifier = {char}+ ({underScore}|{digs})*
// ---------- constant ----------
//As in to name a "case" in the case control structure.
constant = [ char digs ]*
// ---------- string ----------
string = {char}{string}
string = {char}
// ---------- relational expressions ----------
relationalOperator = < | <= | > | >= | == | !=
booleanRelationalOperator = == | !=

// ---------- logical expressions ----------
logicalOperator = AND | OR | NOT
// ---------- one/multi line comments ----------
comment = "//"({char} | {digs})*
comment = "/*"( {char} | {digs})* "*/"
//comment = ({char} | {digs})* {commentEnd}
commentEnd = "*/"

// ---------- new line ----------
newLine = \r|\n|\r\n
// ---------- whitespace ----------
whitespace = {newLine} | [ \t\f]

%%
/* Lexical rules */
<YYINITIAL> {

    // Keywords
    "int"       { System.out.print(" -INT- "); return symbol(sym.INT); }
    "float"     { System.out.print(" -FLOAT- "); return symbol(sym.FLOAT); }
    "char"      { System.out.print(" -CHAR- "); return symbol(sym.CHAR); }
    "array"     { System.out.print(" -ARRAY- "); return symbol(sym.ARRAY); }
    "bool"      { System.out.print(" -BOOL- "); return symbol(sym.BOOL); }
    "string"    { System.out.print(" -STRING- "); return symbol(sym.STRING); }
    "begin"     { System.out.print(" -BEGIN- "); return symbol(sym.BEGIN); }
    "end"       { System.out.print(" -END- "); return symbol(sym.END); }
    "if"        { System.out.print(" -IF- "); return symbol(sym.IF); }
    "then"      { System.out.print(" -THEN- "); return symbol(sym.THEN); }
    "else"      { System.out.print(" -ELSE- "); return symbol(sym.ELSE); }
    "for"       { System.out.print(" -FOR- "); return symbol(sym.FOR); }
    "break"     { System.out.print(" -BREAK- "); return symbol(sym.BREAK); }
    "while"     { System.out.print(" -WHILE- "); return symbol(sym.WHILE); }
    "switch"    { System.out.print(" -SWITCH- "); return symbol(sym.SWITCH); }
    "case"      { System.out.print(" -CASE- "); return symbol(sym.CASE); }
    "return"    { System.out.print(" -RETURN- "); return symbol(sym.RETURN); }

    // Boolean literals.
    "true"      { System.out.print(" -TRUE- "); return symbol(sym.TRUE); }
    "false"     { System.out.print(" -FALSE- "); return symbol(sym.FALSE); }

    // Separator.
    "="         { System.out.print(" -EQ- "); return symbol(sym.EQ); }
    "=="        { System.out.print(" -EQEQ- "); return symbol(sym.EQEQ); }
    "#"         { System.out.print(" -HASH- "); return symbol(sym.HASH); }
    "("         { System.out.print(" -LPAREN- "); return symbol(sym.LPAREN); }
    ")"         { System.out.print(" -RPAREN- "); return symbol(sym.RPAREN); }
    "{"         { System.out.print(" -LCURLY- "); return symbol(sym.LCURLY); }
    "}"         { System.out.print(" -RCURLY- "); return symbol(sym.RCURLY); }
    "["         { System.out.print(" -LSQUARE- "); return symbol(sym.LSQUARE); }
    "]"         { System.out.print(" -RSQUARE- "); return symbol(sym.RSQUARE); }
    "."         { System.out.print(" -DOT- "); return symbol(sym.DOT); }
    ","         { System.out.print(" -COMMA- "); return symbol(sym.COMMA); }

    // Operators.
    "+"         { System.out.print(" -ADD- "); return symbol(sym.ADD); }
    "-"         { System.out.print(" -SUBS- "); return symbol(sym.SUBS); }
    "*"         { System.out.print(" -MULT- "); return symbol(sym.MULT); }
    "/"         { System.out.print(" -DIV- "); return symbol(sym.DIV); }
    "&"         { System.out.print(" -AND- "); return symbol(sym.AND); }
    "|"         { System.out.print(" -OR- "); return symbol(sym.OR); }
    "!"         { System.out.print(" -NOT- "); return symbol(sym.NOT); }

    {integer}   { System.out.print(" -INTEGER- " + " > " + yytext() + " < "); return symbol(sym.INTLIT); }
    {identifier}    { System.out.print(" -ID- " + " > " + yytext() + " < "); return symbol(sym.ID); }  
    {char}      { System.out.print(" -CHAR-" + " > " + yytext() + " < "); return symbol(sym.CHARLIT); }
    {string}    { System.out.print(" -STRING- " + " > " + yytext() + " < "); return symbol(sym.STRINGLIT); }
    {comment}   { System.out.print(" -COMMENT- "); }
    {whitespace}    { /* Does nothing */ }
      
}
[^]             { System.out.print("That is not what I call a legal character >.< <"+yytext()+">"); }
