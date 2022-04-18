/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package symbolTable;

import symbolTable.SymbolTable;
import java.util.ArrayList;

/**
 *
 * @author chris
 */
public class SymbolTableManager {
  
  private final ArrayList<SymbolTable> symbolTables;
  private int currentScope;
  private int scopeLevel;

  public SymbolTableManager() {
    symbolTables = new ArrayList<>();
    scopeLevel = 0;
    currentScope = 0;
  }

  public ArrayList<SymbolTable> getSymbolTables() {
    return symbolTables;
  }
  
  public void createNewSymbolTable(int scopeLevel, String scopeFuncName) {
    SymbolTable newSymbolTable = new SymbolTable(scopeLevel, scopeFuncName);
    symbolTables.add(newSymbolTable);
    scopeLevel += 1;
  }
  public void addToSymbolTable(int scopeLevel, String scopeFuncName, String symbol, ArrayList attributes) {
    
    // In case we have to add to a completely new scope. We create a new symbol table and add it to the arrayList.
    if (scopeLevel > symbolTables.size()) {
      createNewSymbolTable(scopeLevel, scopeFuncName);
    }
    // Then, we add to the new scope or a previous scope if the pre-condition is false.
    symbolTables.get(scopeLevel).addSymbol(symbol, attributes);
   
  }
  
  public boolean checkSymbolScope(int symbolScope, String key) {
    return symbolTables.get(symbolScope).isSymbolPresent(key);
  }

  public int getCurrentScope() {
    return currentScope;
  }

  public int getScopeLevel() {
    return scopeLevel;
  }
  
  
  
}
