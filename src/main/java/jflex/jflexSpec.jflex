
/* user code */
package jflex;
//import java_cup.sym;
import java_cup.runtime.*;
import cup.*;
import symbolTable.*;
import java.util.ArrayList;
import fileManager.*;
import java.util.Map;

%%

/* options and declarations */
%class Lexer
%cup
%public
//%implements sym
%line
%column

%{
  SymbolTableManager stManager = new SymbolTableManager();
  SymbolTable currentSymbolTable = null;
  SymbolTable globalSymbolTable = new SymbolTable(0, "global", null);
  StringBuilder string = new StringBuilder();
  public ArrayList<Token> tokens = new ArrayList<>();
  public SymbolTableManager newManager = new SymbolTableManager();
  public int scope = 0;
  public String idType = "";
  public boolean eqOperator = false;
  public boolean isReturnVal = false;
  public boolean isFunction = false;
  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }

  private void createSymbolTable(boolean params, String funcName, String funcType) {
    if (params) {
      System.out.println();
    } else {
      SymbolTable newSymbolTable = new SymbolTable(this.scope, funcName, funcType);
      //System.out.println("SE CREO TABLA CON SCOPE " + this.scope + " EN " + funcName);
      stManager.addSymbolTable(newSymbolTable);
      updateCurrentTable(stManager.getSymbolTables().size()-1);
      //increaseScope();
    }
  }

  private boolean verifyIdentifier(String lexeme) {

    return this.currentSymbolTable.getSymbolTable().containsKey(lexeme);
    
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
  private void updateCurrentTable(int index) {
    currentSymbolTable = stManager.getSymbolTables().get(index);
    //0System.out.println("CURRENT TABLE FUNC NAME IS: " + currentSymbolTable.getFuncName() + " WITH SCOPE " + currentSymbolTable.getTableScope() );
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

  public void printSymbolTable() {

    int index = 0;
    int size = stManager.getSymbolTables().size();
    for(int i = 0; i < size; i++) {
      System.out.println();
      String funcName = stManager.getSymbolTables().get(i).getFuncName();
      int funcScope = stManager.getSymbolTables().get(i).getTableScope();
      Map<String,ArrayList<String>> current = stManager.getSymbolTables().get(i).getSymbolTable();
      System.out.println("FUNCTION \t SCOPE \t\t VARIABLES \t ATTRIBUTES");
      current.forEach(
        (k, v) -> System.out.println(funcName + "\t\t " + funcScope +" \t\t " + k + " \t\t " + v
          + "\n____________________________________________________________")
      );
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

  public SymbolTableManager getSymbolTableManager() {
    return stManager;
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
arrayLit = "{" (-?(0 | {digR}{digs}*) \,)+ -?(0 | {digR}{digs}*) "}" | "{" ({charDelimiter} ({letter} | {strSymbols}) {charDelimiter} \,)+ {charDelimiter} ({letter} | {strSymbols}) {charDelimiter} "}" 
// ---------- one/multi line comments ----------
comment = "//" ({letter} | {digs}| [ ] )* {newLine}
comment = "/*" ({letter} | {digs}| [ ] | {newLine} | {strSymbols})* "*/"

// ---------- new line ----------
newLine = \r | \n | \r\n
// ---------- whitespace ----------
whitespace = {newLine} | [ \t\f]

// ---------- function ----------
function = {identifier} "("
function = {identifier} "("

%%
/* Lexical rules */
<YYINITIAL> {

    // Keywords
    "main()"    { 
                  saveToken(sym.MAIN, yytext());
                  createSymbolTable(false, "main()", "INT"); 
                  return symbol(sym.MAIN, yytext()); 
                }
    "print"     { saveToken(sym.PRINT, yytext()); return symbol(sym.PRINT, yytext()); }
    {function}  { 
                  Boolean func = (idType != "");
                  if (func) {
                    System.out.println("TABLE FOR: " + yytext() + " WITH SCOPE: " + this.scope);
                    createSymbolTable(false, yytext(), idType);
                    this.isFunction = true; 
                  } 
                  saveToken(sym.FUNC, yytext());
                  return symbol(sym.FUNC, yytext()); 
                                     

                }
    {arrayLit}  { saveToken(sym.ARRAYLIT, yytext()); return symbol(sym.ARRAYLIT, yytext()); }  
    "int["      { saveToken(sym.INTARR, yytext()); return symbol(sym.INTARR, yytext()); }     
    "char["     { saveToken(sym.CHARARR, yytext()); return symbol(sym.CHARARR, yytext()); }     
    "int"       { 
                  saveToken(sym.INT, yytext());
                  idType = "int";
                  return symbol(sym.INT, yytext()); 
                }
    "float"     { 
                  saveToken(sym.FLOAT, yytext());
                  idType = "float";
                  return symbol(sym.FLOAT, yytext()); 
                }
    "char"      { 
                  saveToken(sym.CHAR, yytext());
                  idType = "char";
                  return symbol(sym.CHAR, yytext()); 
                }
    "boolean"   { 
                  saveToken(sym.BOOL, yytext());
                  idType = "boolean";
                  return symbol(sym.BOOL, yytext()); 
                }
    "string"    { 
                  saveToken(sym.STRING, yytext());
                  idType = "string";
                  return symbol(sym.STRING, yytext()); 
                }
    "begin"     { saveToken(sym.BEGIN, yytext()); return symbol(sym.BEGIN, yytext()); }
    "end"       { saveToken(sym.END, yytext()); return symbol(sym.END, yytext()); }
    "if"        { saveToken(sym.IF, yytext()); return symbol(sym.IF, yytext()); }
    "then"      { saveToken(sym.THEN, yytext()); return symbol(sym.THEN, yytext()); }
    "else"      { saveToken(sym.ELSE, yytext()); return symbol(sym.ELSE, yytext()); }
    "for"       { saveToken(sym.FOR, yytext()); return symbol(sym.FOR, yytext()); }
    "break"     { saveToken(sym.BREAK, yytext()); return symbol(sym.BREAK, yytext()); }
    "while"     { saveToken(sym.WHILE, yytext()); return symbol(sym.WHILE, yytext()); }
    "switch"    { saveToken(sym.SWITCH, yytext()); return symbol(sym.SWITCH, yytext()); }
    "case"      { saveToken(sym.CASE, yytext()); return symbol(sym.CASE, yytext()); }
    "return"    { 
                  saveToken(sym.RETURN, yytext());
                  isReturnVal = true;
                  return symbol(sym.RETURN, yytext()); 
                }
    "read()"    { saveToken(sym.READ, yytext()); return symbol(sym.READ, yytext()); }
    "default"   { saveToken(sym.DEFAULT, yytext()); return symbol(sym.DEFAULT, yytext()); }
    
    // Boolean literals.
    "true"      { saveToken(sym.TRUE, yytext()); return symbol(sym.TRUE, yytext()); }
    "false"     { saveToken(sym.FALSE, yytext()); return symbol(sym.FALSE, yytext()); }

    // Separator.
    "=="        { saveToken(sym.EQEQ, yytext()); return symbol(sym.EQEQ, yytext()); }
    "="         { 
                  saveToken(sym.EQ, yytext()); 
                  this.eqOperator = true;
                  return symbol(sym.EQ, yytext()); }
    "#"         { saveToken(sym.HASH, yytext()); return symbol(sym.HASH, yytext()); }
    "("         { saveToken(sym.LPAREN, yytext()); return symbol(sym.LPAREN, yytext()); }
    ")"         { 
                  saveToken(sym.RPAREN, yytext()); 
                  this.isFunction = false; 
                  return symbol(sym.RPAREN, yytext()); 
                }
    "{"         { 
                  saveToken(sym.LCURLY, yytext());
                  increaseScope();
                  createSymbolTable(false, currentSymbolTable.getFuncName(), currentSymbolTable.getFuncType());
                  return symbol(sym.LCURLY, yytext()); 
                }
    "}"         { 
                  saveToken(sym.RCURLY, yytext());
                  currentSymbolTable = stManager.getSymbolTables().get((stManager.getSymbolTables().indexOf(currentSymbolTable)) - 1);
                  decreaseScope();
                  return symbol(sym.RCURLY, yytext()); 
                }
    "["         { saveToken(sym.LSQUARE, yytext()); return symbol(sym.LSQUARE, yytext()); }
    "]"         { saveToken(sym.RSQUARE, yytext()); return symbol(sym.RSQUARE, yytext()); }
    "."         { saveToken(sym.DOT, yytext()); return symbol(sym.DOT, yytext()); }
    ","         { 
                  saveToken(sym.COMMA, yytext()); 
                  isFunction = true;
                  return symbol(sym.COMMA, yytext()); 
                }
    ":"         { saveToken(sym.COLON, yytext()); return symbol(sym.COLON, yytext()); }

    {comment}   { saveToken(sym.COMMENT, yytext()); tokenInfo("-COMMENT- ", yytext()); return symbol(sym.COMMENT);}

    // Operators.
    "++"        { saveToken(sym.PADD, yytext()); return symbol(sym.PADD, yytext()); }
    "--"        { saveToken(sym.PSUBS, yytext()); return symbol(sym.PSUBS, yytext()); }
    "+"         { saveToken(sym.ADD, yytext()); return symbol(sym.ADD, yytext()); }
    "-"         { saveToken(sym.SUBS, yytext()); return symbol(sym.SUBS, yytext()); }
    "*"         { saveToken(sym.MULT, yytext()); return symbol(sym.MULT, yytext()); }
    "~"         { saveToken(sym.MOD, yytext()); return symbol(sym.MOD, yytext()); } 
    "^"         { saveToken(sym.EXP, yytext()); return symbol(sym.EXP, yytext()); }    

    "/"         { saveToken(sym.DIV, yytext()); return symbol(sym.DIV, yytext()); }
    "&&"        { saveToken(sym.AND, yytext()); return symbol(sym.AND, yytext()); }
    "||"        { saveToken(sym.OR, yytext()); return symbol(sym.OR, yytext()); }
    "!"         { saveToken(sym.NOT, yytext()); return symbol(sym.NOT, yytext()); }

    ">="        { saveToken(sym.GTE, yytext()); return symbol(sym.GTE, yytext()); }
    ">"         { saveToken(sym.GT, yytext()); return symbol(sym.GT, yytext()); }
    "<="        { saveToken(sym.LTE, yytext()); return symbol(sym.LTE, yytext()); }
    "<"         { saveToken(sym.LT, yytext()); return symbol(sym.LT, yytext()); }

    {integer}   { 
                  saveToken(sym.INTLIT, yytext()); 
                  if (isReturnVal) {
                    System.out.println("RETURN VALUE IS: " + yytext()); 
                    currentSymbolTable.setReturnVal(yytext());
                    isReturnVal = false;
                  }
                  return symbol(sym.INTLIT, yytext()); 
                }
    {floatNum}  { 
                  saveToken(sym.FLOATLIT, yytext()); 
                  if (isReturnVal) {
                    System.out.println("RETURN VALUE IS: " + yytext()); 
                    currentSymbolTable.setReturnVal(yytext());
                    isReturnVal = false;
                  }
                  return symbol(sym.FLOATLIT, yytext()); }
    {char}      { 
                  saveToken(sym.CHARLIT, yytext()); 
                  if (isReturnVal) {
                    System.out.println("RETURN VALUE IS: " + yytext()); 
                    currentSymbolTable.setReturnVal(yytext());
                    isReturnVal = false;
                  }
                  return symbol(sym.CHARLIT, yytext()); }
    {stringLit} { saveToken(sym.STRINGLIT, yytext()); return symbol(sym.STRINGLIT, yytext()); }
    {identifier}  { 
                    saveToken(sym.ID, yytext()); 
                    if(this.idType != "") {
                      ArrayList<String> tokenAttributes = new ArrayList<>();
                      if(isFunction) {
                        currentSymbolTable.addFuncParams(idType, yytext());
                        isFunction = false;
                        System.out.println("AGREGANDO PARAMETRO: " + idType + " " + yytext());
                      } else {
                        tokenAttributes.add(idType);
                        System.out.println("AGREGANDO VARIABLE: " + idType + " " + yytext());
                        currentSymbolTable.addSymbol(yytext(), tokenAttributes);  
                      }
                      this.idType = "";
                      return symbol(sym.ID, yytext());  
                    } else {
                      if (isReturnVal) {
                        System.out.println("RETURN VALUE IS: " + yytext()); 
                        currentSymbolTable.setReturnVal(yytext());
                        isReturnVal = false;
                      }
                      return symbol(sym.ID, yytext());
                    }
                  }
    
    {whitespace}    { /* Does nothing */ }  
    //{functionInv} { tokenInfo("-NOT- ", yytext()); return symbol(sym.FUNCT); }
}
[^]             { reportErr(yytext(), yyline + 1, yycolumn); }
