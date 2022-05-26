/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package symbolTable;

import cup.sym;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


/**
 *
 * @author chris
 */
public final class SymbolTable {
  
  private Map<String, ArrayList<String>> symbolTable;
  private final int tableScope;
  private final String funcName;
  private final String funcType;
  private ArrayList<String> funcParams;
  
  public SymbolTable(int tableScope, String funcName, String funcType) {
    this.tableScope = tableScope;
    this.funcName = funcName;
    this.symbolTable = new HashMap<>();
    this.funcType = funcType;
  }
 
  public SymbolTable(int tableScope, String funcName, String funcType, ArrayList<String> params) {
    this.tableScope = tableScope;
    this.funcName = funcName;
    this.symbolTable = new HashMap<>();
    this.funcType = funcType;
    this.funcParams = params;
  }

  public Map<String, ArrayList<String>> getSymbolTable() {
    return this.symbolTable;
  }

  public int getTableScope() {
    return this.tableScope;
  }

  public String getFuncName() {
    return this.funcName;
  }
  
  public boolean isSymbolPresent(String key) {
    return symbolTable.containsKey(key);
  }
  public ArrayList<String> getAttributes(String key) {
    if (isSymbolPresent(key)) {
      return symbolTable.get(key);
    } else return null;
  }
 
  public void addSymbol(String lexeme, ArrayList<String> attributes) {
    symbolTable.put(lexeme, attributes);
  }

  public String getFuncType() {
    return funcType;
  }

  public ArrayList<String> getFuncParams() {
    return funcParams;
  }
  
}
