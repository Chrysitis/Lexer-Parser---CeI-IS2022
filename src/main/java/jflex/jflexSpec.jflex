
/* user code */
package jflex;
//import java_cup.sym;
import java_cup.runtime.*;
import cup.*;
import symbolTable.*;
import java.util.ArrayList;
import fileManager.*;
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
  public ArrayList<Token> tokens = new ArrayList<>();
  public SymbolTableManager newManager = new SymbolTableManager();
  public int scope = 0;
  private Symbol symbol(int type) {
    if (type == 39) {
      increaseScope();
    } else if (type == 40) {
      decreaseScope();
    }
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }

  private void tokenInfo(String token, String val) {
    //String info = token + " > " + val + " < ";
    //System.out.println(info);
  }

  private void saveToken(int symbol, String value) {
    if (symbol != 61) {
      Token newToken = new Token(symbol, value);
      tokens.add(newToken);
      String tokenInfo = "[ " + sym.terminalNames[newToken.getSymbol()] + " ] " + newToken.getSymbolName();
      writeTokensToFile(tokenInfo);
    } else {
      Token newToken = new Token(symbol, value, this.scope);
      tokens.add(newToken);
      String tokenInfo = "[ " + sym.terminalNames[newToken.getSymbol()] + " " + 
        newToken.getTokenId() + " ] " + newToken.getSymbolName() + " - Found in symbol table: " + newToken.getSymbolTable();
      writeTokensToFile(tokenInfo);
      // After creating the ID token, we save it to the symbol table with its attributes...
    }
  }

  private void increaseScope() {
    scope += 1;
  }
  private void decreaseScope() {
    scope -= 1;
  }

  public void printTokens() {
    int tokensSize = tokens.size();
    for (int i = 0; i < tokensSize; i++) {
      Token token = tokens.get(i);
      if (token.getSymbol() == 61) {
        System.out.println("[ " + sym.terminalNames[token.getSymbol()] + " " + 
          token.getTokenId() + " ] " + token.getSymbolName() + " - Found in symbol table: " + token.getSymbolTable());
      } else {
          System.out.println("[ " + sym.terminalNames[token.getSymbol()] + " ] " + token.getSymbolName());
      } 
    }
  }

  private void writeTokensToFile(String info){
    FileManager fileManager = new FileManager("C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/symbolTable/Tokens.txt");
    fileManager.writeToFile(info);
  }

  private void reportErr(String info, int line, int column) {
    //System.err.println("ILLEGAL ENTRY AT LINE " + line + " - COLUMN " + column + " ::> " + yytext());
    String err = "LEXICAL ERROR AT LINE " + String.valueOf(line) + " - COLUMN " + String.valueOf(column) + " ::> " + yytext();
    writeTokensToFile(err);
  }

%}

// ---------- Some type definitions ----------
sign = "-"
digR = [1-9]
digs = [0-9]
decimalPoint =  \. 
letter = [a-zA-Z]
// ---------- char ----------
charDelimiter = \'
char = {charDelimiter} ({letter} | {strSymbols}) {charDelimiter}

// ---------- integer ----------
integer = -?(0 | {digR}{digs}*)

// ---------- float ----------
floatNum = -?(0.0 | {digs}+ {digs}* {decimalPoint} {digs}*)

// ---------- identifier ----------
underScore = "_"
identifier = {letter}+ ({letter} | {underScore} | {digs})*

// ---------- string ----------
stringDelimiter = \"
strSymbols = [$=><#\+\-%&|/()!¡¿?\"\'\,]
stringLit = {stringDelimiter} ({letter} | {digs} | [ ] | {strSymbols}) + {stringDelimiter}

// ---------- array ----------
arrayLit = "{" ({integer} \,)+ {integer} "}" | "{" ({char} \,)+ {char} "}" 
// ---------- one/multi line comments ----------
comment = "//" ({letter} | {digs}| [ ] )* {newLine}
comment = "/*" ({letter} | {digs}| [ ] | {newLine} | {strSymbols})* "*/"

// ---------- new line ----------
newLine = \r | \n | \r\n
// ---------- whitespace ----------
whitespace = {newLine} | [ \t\f]

// ---------- parameters ----------
type = "int" | "char" | "boolean" | "array" | "string"
parameters = {type} {identifier}
parameters = {type} {identifier} {parameters}
parameters = "," {type} {identifier} {parameters}
// ---------- function ----------
function = {type}{identifier} "("
function = {identifier} "("
//function = {type}{identifier} "(" parameters ")"

%%
/* Lexical rules */
<YYINITIAL> {

    // Keywords
    "main()"    { saveToken(sym.MAIN, yytext()); return symbol(sym.MAIN); }
    "print"     { saveToken(sym.PRINT, yytext()); return symbol(sym.PRINT); }
    {function}  { saveToken(sym.FUNC, yytext()); return symbol(sym.FUNC); }
    {arrayLit}  { saveToken(sym.ARRAYLIT, yytext()); return symbol(sym.ARRAYLIT); }  
    "int["      { saveToken(sym.INTARR, yytext()); return symbol(sym.INTARR); }     
    "char["     { saveToken(sym.CHARARR, yytext()); return symbol(sym.CHARARR); }     
    "int"       { saveToken(sym.INT, yytext()); return symbol(sym.INT); }
    "float"     { saveToken(sym.FLOAT, yytext()); return symbol(sym.FLOAT); }
    "char"      { saveToken(sym.CHAR, yytext()); return symbol(sym.CHAR); }
    "boolean"   { saveToken(sym.BOOL, yytext()); return symbol(sym.BOOL); }
    "string"    { saveToken(sym.STRING, yytext()); return symbol(sym.STRING); }
    "begin"     { saveToken(sym.BEGIN, yytext()); return symbol(sym.BEGIN); }
    "end"       { saveToken(sym.END, yytext()); return symbol(sym.END); }
    "if"        { saveToken(sym.IF, yytext()); return symbol(sym.IF); }
    "then"      { saveToken(sym.THEN, yytext()); return symbol(sym.THEN); }
    "else"      { saveToken(sym.ELSE, yytext()); return symbol(sym.ELSE); }
    "for"       { saveToken(sym.FOR, yytext()); return symbol(sym.FOR); }
    "break"     { saveToken(sym.BREAK, yytext()); return symbol(sym.BREAK); }
    "while"     { saveToken(sym.WHILE, yytext()); return symbol(sym.WHILE); }
    "switch"    { saveToken(sym.SWITCH, yytext()); return symbol(sym.SWITCH); }
    "case"      { saveToken(sym.CASE, yytext()); return symbol(sym.CASE); }
    "return"    { saveToken(sym.RETURN, yytext()); return symbol(sym.RETURN); }
    "read()"    { saveToken(sym.READ, yytext()); return symbol(sym.READ); }
    "default"   { saveToken(sym.DEFAULT, yytext()); return symbol(sym.DEFAULT); }
    
    // Boolean literals.
    "true"      { saveToken(sym.TRUE, yytext()); return symbol(sym.TRUE); }
    "false"     { saveToken(sym.FALSE, yytext()); return symbol(sym.FALSE); }

    // Separator.
    "=="        { saveToken(sym.EQEQ, yytext()); return symbol(sym.EQEQ); }
    "="         { saveToken(sym.EQ, yytext()); return symbol(sym.EQ); }
    "#"         { saveToken(sym.HASH, yytext()); return symbol(sym.HASH); }
    "("         { saveToken(sym.LPAREN, yytext()); return symbol(sym.LPAREN); }
    ")"         { saveToken(sym.RPAREN, yytext()); return symbol(sym.RPAREN); }
    "{"         { saveToken(sym.LCURLY, yytext()); return symbol(sym.LCURLY); }
    "}"         { saveToken(sym.RCURLY, yytext()); return symbol(sym.RCURLY); }
    "["         { saveToken(sym.LSQUARE, yytext()); return symbol(sym.LSQUARE); }
    "]"         { saveToken(sym.RSQUARE, yytext()); return symbol(sym.RSQUARE); }
    "."         { saveToken(sym.DOT, yytext()); return symbol(sym.DOT); }
    ","         { saveToken(sym.COMMA, yytext()); return symbol(sym.COMMA); }
    ":"         { saveToken(sym.COLON, yytext()); return symbol(sym.COLON); }

    {comment}   { saveToken(sym.COMMENT, yytext()); tokenInfo("-COMMENT- ", yytext()); return symbol(sym.COMMENT);}

    // Operators.
    "++"        { saveToken(sym.PADD, yytext()); return symbol(sym.PADD); }
    "--"        { saveToken(sym.PSUBS, yytext()); return symbol(sym.PSUBS); }
    "+"         { saveToken(sym.ADD, yytext()); return symbol(sym.ADD); }
    "-"         { saveToken(sym.SUBS, yytext()); return symbol(sym.SUBS); }
    "*"         { saveToken(sym.MULT, yytext()); return symbol(sym.MULT); }
    "~"         { saveToken(sym.MOD, yytext()); return symbol(sym.MOD); } 
    "^"         { saveToken(sym.EXP, yytext()); return symbol(sym.EXP); }    

    "/"         { saveToken(sym.DIV, yytext()); return symbol(sym.DIV); }
    "&&"        { saveToken(sym.AND, yytext()); return symbol(sym.AND); }
    "||"        { saveToken(sym.OR, yytext()); return symbol(sym.OR); }
    "!"         { saveToken(sym.NOT, yytext()); return symbol(sym.NOT); }

    ">="        { saveToken(sym.GTE, yytext()); return symbol(sym.GTE); }
    ">"         { saveToken(sym.GT, yytext()); return symbol(sym.GT); }
    "<="        { saveToken(sym.LTE, yytext()); return symbol(sym.LTE); }
    "<"         { saveToken(sym.LT, yytext()); return symbol(sym.LT); }

    {integer}   { saveToken(sym.INTLIT, yytext()); return symbol(sym.INTLIT); }
    {floatNum}  { saveToken(sym.FLOATLIT, yytext()); return symbol(sym.FLOATLIT); }
    {char}      { saveToken(sym.CHARLIT, yytext()); return symbol(sym.CHARLIT); }
    {stringLit} { saveToken(sym.STRINGLIT, yytext()); return symbol(sym.STRINGLIT); }
    {identifier}  { saveToken(sym.ID, yytext()); return symbol(sym.ID); }      
    {whitespace}    { /* Does nothing */ }  
    //{functionInv} { tokenInfo("-NOT- ", yytext()); return symbol(sym.FUNCT); }
}
[^]             { reportErr(yytext(), yyline + 1, yycolumn); }
