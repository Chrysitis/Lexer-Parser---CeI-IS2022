
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

  private void tokenInfo(String token, String val) {

    String info = token + " > " + val + " < ";
    System.out.print(info);
  }
%}

// ---------- Some type definitions ----------
sign = "-"
zero = 0 | 0.0
digR = [1-9]
digs = [0-9]
decimalPoint =  \. 
letter = [a-zA-Z]
// ---------- char ----------
charDelimiter = \'
char = {charDelimiter} {letter} {charDelimiter}

// ---------- integer ----------
integer = 0 | {digR}{digs}*
//integer = {zero}
//integer = {digR}
//integer = {sign} {integer} | {integer}
//integer = {digR} {integerRest}
//integerRest = {digs} {intergerRest}
//integerRest = {digs}

// ---------- float ----------
floatNum = 0.0 | {digR}+ {decimalPoint} {digs}*
float = zero
float = sign preDecimal postDecinmal | preDecimal postDecinmal
preDecimal = digR preDecimal
preDecimal = digs preDecimal
postDecimal = decimalPoint digs

// ---------- boolean ----------
boolean = TRUE | FALSE

// ---------- identifier ----------
underScore = "_"
identifier = {letter}+ ({letter} | {underScore} | {digs})*

// ---------- literal ----------
literal = {integer} | {string} | {floatNum} | {boolean}
// ---------- constant ----------
//As in to name a "case" in the case control structure.
constant = [ char digs ]*
// ---------- string ----------
stringDelimiter = \"
strSymbols = [$#%&/()!¡¿?]
string = {stringDelimiter} ({letter} | {digs} | [ ])+ {stringDelimiter}
// ---------- relational expressions ----------
relationalOperator = < | <= | > | >= | == | !=
booleanRelationalOperator = == | !=

// ---------- logical expressions ----------
logicalOperator = AND | OR | NOT
// ---------- one/multi line comments ----------
comment = "//" ({letter} | {digs}| [ ] )* {newLine}
comment = "/*" ({letter} | {digs}| [ ] )* "*/"
//comment = ({letter} | {digs})* {commentEnd}
commentEnd = "*/"

// ---------- new line ----------
newLine = \r | \n | \r\n
// ---------- whitespace ----------
whitespace = {newLine} | [ \t\f]

// ---------- parameters ----------
type = "int" | "char" | "boolean" | "array"
parameters = {type} {identifier}
parameters = "," {type} {identifier} {parameters}
// ---------- function invocation ----------
functionType = "int" | "char"
paramInv = ({identifier} | {literal}) {paramInv}
paramInv = "," ({identifier} | {literal}) {paramInv}
paramInv = "," {identifier} | {literal}
functionInv = {identifier} "(" ")"
functionInv = {identifier} "("paramInv")" 
%%
/* Lexical rules */
<YYINITIAL> {

    // Keywords
    "int"       { tokenInfo("-INT- ", yytext()); return symbol(sym.INT); }
    "float"     { tokenInfo("-FLOAT- ", yytext()); return symbol(sym.FLOAT); }
    "char"      { tokenInfo("-CHAR- ", yytext()); return symbol(sym.CHAR); }
    "array"     { tokenInfo("-ARRAY- ", yytext()); return symbol(sym.ARRAY); }
    "boolean"      { tokenInfo("-BOOL- ", yytext()); return symbol(sym.BOOL); }
    "string"    { tokenInfo("-STRING- ", yytext()); return symbol(sym.STRING); }
    "begin"     { tokenInfo("-BEGIN- ", yytext()); return symbol(sym.BEGIN); }
    "end"       { tokenInfo("-END- ", yytext()); return symbol(sym.END); }
    "if"        { tokenInfo("-IF- ", yytext()); return symbol(sym.IF); }
    "then"      { tokenInfo("-THEN- ", yytext()); return symbol(sym.THEN); }
    "else"      { tokenInfo("-ELSE- ", yytext()); return symbol(sym.ELSE); }
    "for"       { tokenInfo("-FOR- ", yytext()); return symbol(sym.FOR); }
    "break"     { tokenInfo("-BREAK- ", yytext()); return symbol(sym.BREAK); }
    "while"     { tokenInfo("-WHILE- ", yytext()); return symbol(sym.WHILE); }
    "switch"    { tokenInfo("-SWITCH- ", yytext()); return symbol(sym.SWITCH); }
    "case"      { tokenInfo("-CASE- ", yytext()); return symbol(sym.CASE); }
    "return"    { tokenInfo("-RETURN- ", yytext()); return symbol(sym.RETURN); }

    // Boolean literals.
    "true"      { tokenInfo("-TRUE- ", yytext()); return symbol(sym.TRUE); }
    "false"     { tokenInfo("-FALSE- ", yytext()); return symbol(sym.FALSE); }

    // Separator.
    "="         { tokenInfo("-EQ- ", yytext()); return symbol(sym.EQ); }
    "=="        { tokenInfo("-EQEQ- ", yytext()); return symbol(sym.EQEQ); }
    "#"         { tokenInfo("-HASH- ", yytext()); return symbol(sym.HASH); }
    "("         { tokenInfo("-LPAREN- ", yytext()); return symbol(sym.LPAREN); }
    ")"         { tokenInfo("-RPAREN- ", yytext()); return symbol(sym.RPAREN); }
    "{"         { tokenInfo("-LCURLY- ", yytext()); return symbol(sym.LCURLY); }
    "}"         { tokenInfo("-RCURLY- ", yytext()); return symbol(sym.RCURLY); }
    "["         { tokenInfo("-LSQUARE- ", yytext()); return symbol(sym.LSQUARE); }
    "]"         { tokenInfo("-RSQUARE- ", yytext()); return symbol(sym.RSQUARE); }
    "."         { tokenInfo("-DOT- ", yytext()); return symbol(sym.DOT); }
    ","         { tokenInfo("-COMMA- ", yytext()); return symbol(sym.COMMA); }

    // Operators.
    "+"         { tokenInfo("-ADD- ", yytext()); return symbol(sym.ADD); }
    "-"         { tokenInfo("-SUBS- ", yytext()); return symbol(sym.SUBS); }
    "*"         { tokenInfo("-MULT- ", yytext()); return symbol(sym.MULT); }
    "/"         { tokenInfo("-DIV- ", yytext()); return symbol(sym.DIV); }
    "&"         { tokenInfo("-AND- ", yytext()); return symbol(sym.AND); }
    "|"         { tokenInfo("-OR- ", yytext()); return symbol(sym.OR); }
    "!"         { tokenInfo("-NOT- ", yytext()); return symbol(sym.NOT); }

    {integer}   { tokenInfo("-INTEGER- ", yytext()); return symbol(sym.INTLIT); }
    {floatNum}   { tokenInfo("-FLOATNUM- ", yytext()); return symbol(sym.FLOATLIT); }
    {char}      { tokenInfo("-CHAR- ", yytext()); return symbol(sym.CHARLIT); }
    {comment}   { tokenInfo("-COMMENT- ", yytext()); }
    {string}    { tokenInfo("-STRING- ", yytext()); return symbol(sym.STRINGLIT); }
    {identifier}    { tokenInfo("-ID- ", yytext()); return symbol(sym.ID); }      
    {whitespace}    { /* Does nothing */ }  
    //{functionInv} { tokenInfo("-NOT- ", yytext()); return symbol(sym.FUNCT); }
}
[^]             { System.out.println("ILLEGAL ENTRY ::> " + yytext()); }
