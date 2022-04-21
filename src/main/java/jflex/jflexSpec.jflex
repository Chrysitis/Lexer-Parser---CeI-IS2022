
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
    if (type == 32) {
      increaseScope();
    } else if (type == 33) {
      decreaseScope();
    }
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }

  private void tokenInfo(String token, String val) {
    String info = token + " > " + val + " < ";
    System.out.println(info);
  }

  private void saveToken(int symbol, String value) {
    if (symbol != 57) {
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
      if (token.getSymbol() == 57) {
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
char = {charDelimiter} {letter} {charDelimiter}

// ---------- integer ----------
integer = 0 | {digR}{digs}*

// ---------- float ----------
floatNum = 0.0 | {digR}+ {digs}* {decimalPoint} {digs}*

// ---------- identifier ----------
underScore = "_"
identifier = {letter}+ ({letter} | {underScore} | {digs})*

// ---------- string ----------
stringDelimiter = \"
//strSymbols = [$#%&/()!¡¿?]
stringLit = {stringDelimiter} ({letter} | {digs} | [ ])+ {stringDelimiter}

// ---------- one/multi line comments ----------
comment = "//" ({letter} | {digs}| [ ] )* {newLine}
comment = "/*" ({letter} | {digs}| [ ] | {newLine})* "*/"

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
    "main()"    { saveToken(sym.MAIN, yytext()); tokenInfo("-MAIN- ", yytext()); return symbol(sym.MAIN); }
    {function}  { saveToken(sym.FUNC, yytext()); tokenInfo("-FUNC- ", yytext()); return symbol(sym.FUNC); }
    "int["      { saveToken(sym.INT, yytext()); tokenInfo("-INTARR- ", yytext()); return symbol(sym.INTARR); }     
    "char["      { saveToken(sym.INT, yytext()); tokenInfo("-CHARARR- ", yytext()); return symbol(sym.CHARARR); }     
    "int"       { saveToken(sym.INT, yytext()); tokenInfo("-INT- ", yytext()); return symbol(sym.INT); }
    "float"     { saveToken(sym.FLOAT, yytext()); tokenInfo("-FLOAT- ", yytext()); return symbol(sym.FLOAT); }
    "char"      { saveToken(sym.CHAR, yytext()); tokenInfo("-CHAR- ", yytext()); return symbol(sym.CHAR); }
    "boolean"   { saveToken(sym.BOOL, yytext()); tokenInfo("-BOOL- ", yytext()); return symbol(sym.BOOL); }
    "string"    { saveToken(sym.STRING, yytext()); tokenInfo("-STRING- ", yytext()); return symbol(sym.STRING); }
    "begin"     { saveToken(sym.BEGIN, yytext()); tokenInfo("-BEGIN- ", yytext()); return symbol(sym.BEGIN); }
    "end"       { saveToken(sym.END, yytext()); tokenInfo("-END- ", yytext()); return symbol(sym.END); }
    "if"        { saveToken(sym.IF, yytext()); tokenInfo("-IF- ", yytext()); return symbol(sym.IF); }
    "then"      { saveToken(sym.THEN, yytext()); tokenInfo("-THEN- ", yytext()); return symbol(sym.THEN); }
    "else"      { saveToken(sym.ELSE, yytext()); tokenInfo("-ELSE- ", yytext()); return symbol(sym.ELSE); }
    "for"       { saveToken(sym.FOR, yytext()); tokenInfo("-FOR- ", yytext()); return symbol(sym.FOR); }
    "break"     { saveToken(sym.BREAK, yytext()); tokenInfo("-BREAK- ", yytext()); return symbol(sym.BREAK); }
    "while"     { saveToken(sym.WHILE, yytext()); tokenInfo("-WHILE- ", yytext()); return symbol(sym.WHILE); }
    "switch"    { saveToken(sym.SWITCH, yytext()); tokenInfo("-SWITCH- ", yytext()); return symbol(sym.SWITCH); }
    "case"      { saveToken(sym.CASE, yytext()); tokenInfo("-CASE- ", yytext()); return symbol(sym.CASE); }
    "return"    { saveToken(sym.RETURN, yytext()); tokenInfo("-RETURN- ", yytext()); return symbol(sym.RETURN); }
    "read()"    { saveToken(sym.READ, yytext()); tokenInfo("-MAIN- ", yytext()); return symbol(sym.READ); }
    "print"     { saveToken(sym.PRINT, yytext()); tokenInfo("-PRINT- ", yytext()); return symbol(sym.PRINT); }

    // Boolean literals.
    "true"      { saveToken(sym.TRUE, yytext()); tokenInfo("-TRUE- ", yytext()); return symbol(sym.TRUE); }
    "false"     { saveToken(sym.FALSE, yytext()); tokenInfo("-FALSE- ", yytext()); return symbol(sym.FALSE); }

    // Separator.
    "=="        { saveToken(sym.EQEQ, yytext()); tokenInfo("-EQEQ- ", yytext()); return symbol(sym.EQEQ); }
    "="         { saveToken(sym.EQ, yytext()); tokenInfo("-EQ- ", yytext()); return symbol(sym.EQ); }
    "#"         { saveToken(sym.HASH, yytext()); tokenInfo("-HASH- ", yytext()); return symbol(sym.HASH); }
    "("         { saveToken(sym.LPAREN, yytext()); tokenInfo("-LPAREN- ", yytext()); return symbol(sym.LPAREN); }
    ")"         { saveToken(sym.RPAREN, yytext()); tokenInfo("-RPAREN- ", yytext()); return symbol(sym.RPAREN); }
    "{"         { saveToken(sym.LCURLY, yytext()); tokenInfo("-LCURLY- ", yytext()); return symbol(sym.LCURLY); }
    "}"         { saveToken(sym.RCURLY, yytext()); tokenInfo("-RCURLY- ", yytext()); return symbol(sym.RCURLY); }
    "["         { saveToken(sym.LSQUARE, yytext()); tokenInfo("-LSQUARE- ", yytext()); return symbol(sym.LSQUARE); }
    "]"         { saveToken(sym.RSQUARE, yytext()); tokenInfo("-RSQUARE- ", yytext()); return symbol(sym.RSQUARE); }
    "."         { saveToken(sym.DOT, yytext()); tokenInfo("-DOT- ", yytext()); return symbol(sym.DOT); }
    ","         { saveToken(sym.COMMA, yytext()); tokenInfo("-COMMA- ", yytext()); return symbol(sym.COMMA); }

    {comment}   { tokenInfo("-COMMENT- ", yytext()); }

    // Operators.
    "++"        { saveToken(sym.PADD, yytext()); tokenInfo("-PADD- ", yytext()); return symbol(sym.PADD); }
    "--"        { saveToken(sym.PSUBS, yytext()); tokenInfo("-PSUBS- ", yytext()); return symbol(sym.PSUBS); }
    "+"         { saveToken(sym.ADD, yytext()); tokenInfo("-ADD- ", yytext()); return symbol(sym.ADD); }
    "-"         { saveToken(sym.SUBS, yytext()); tokenInfo("-SUBS- ", yytext()); return symbol(sym.SUBS); }
    "*"         { saveToken(sym.MULT, yytext()); tokenInfo("-MULT- ", yytext()); return symbol(sym.MULT); }
    "~"         { saveToken(sym.MOD, yytext()); tokenInfo("-MOD- ", yytext()); return symbol(sym.MOD); } 
    "^"         { saveToken(sym.EXP, yytext()); tokenInfo("-EXP- ", yytext()); return symbol(sym.EXP); }    

    "/"         { saveToken(sym.DIV, yytext()); tokenInfo("-DIV- ", yytext()); return symbol(sym.DIV); }
    "&&"        { saveToken(sym.AND, yytext()); tokenInfo("-AND- ", yytext()); return symbol(sym.AND); }
    "|"         { saveToken(sym.OR, yytext()); tokenInfo("-OR- ", yytext()); return symbol(sym.OR); }
    "!"         { saveToken(sym.NOT, yytext()); tokenInfo("-NOT- ", yytext()); return symbol(sym.NOT); }

    ">="        { saveToken(sym.GTE, yytext()); tokenInfo("-GTE- ", yytext()); return symbol(sym.GTE); }
    ">"         { saveToken(sym.GT, yytext()); tokenInfo("-GT- ", yytext()); return symbol(sym.GT); }
    "<="        { saveToken(sym.LTE, yytext()); tokenInfo("-LTE- ", yytext()); return symbol(sym.LTE); }
    "<"         { saveToken(sym.LT, yytext()); tokenInfo("-LT- ", yytext()); return symbol(sym.LT); }

    {integer}   { saveToken(sym.INTLIT, yytext()); tokenInfo("-INTLIT- ", yytext()); return symbol(sym.INTLIT); }
    {floatNum}  { saveToken(sym.FLOATLIT, yytext()); tokenInfo("-FLOATLIT- ", yytext()); return symbol(sym.FLOATLIT); }
    {char}      { saveToken(sym.CHARLIT, yytext()); tokenInfo("-CHARLIT- ", yytext()); return symbol(sym.CHARLIT); }
    {stringLit} { saveToken(sym.STRINGLIT, yytext()); tokenInfo("-STRINGLIT- ", yytext()); return symbol(sym.STRINGLIT); }
    {identifier}    { saveToken(sym.ID, yytext()); tokenInfo("-ID- ", yytext()); return symbol(sym.ID); }      
    {whitespace}    { /* Does nothing */ }  
    //{functionInv} { tokenInfo("-NOT- ", yytext()); return symbol(sym.FUNCT); }
}
[^]             { reportErr(yytext(), yyline + 1, yycolumn); }
