/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package symbolTable;

import cup.sym;

/**
 *
 * @author chris
 */
public final class Token {
  
  private final int symbol;
  private final int symbolTable;
  private final String symbolName;
  private int tokenId;
  private static int globalTokenId = 0;

  public Token(int symbol, String symbolName, int symbolTable) {
    this.symbol = symbol;
    this.symbolTable = symbolTable;
    this.symbolName = symbolName;
    this.tokenId += globalTokenId;
    globalTokenId += 1;
  }
  
  public Token(int symbol, String symbolName) {
    this.symbol = symbol;
    this.symbolTable = 0;
    this.symbolName = symbolName;
    this.tokenId = 0;
  }

  public int getSymbol() {
    return symbol;
  }

  public int getSymbolTable() {
    return symbolTable;
  }

  public String getSymbolName() {
    return symbolName;
  }

  public int getTokenId() {
    return tokenId;
  }
  
}
