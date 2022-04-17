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
import org.apache.commons.lang3.tuple.MutablePair;
import org.apache.commons.lang3.tuple.Pair;


/**
 *
 * @author chris
 */
public final class SymbolTable {
  
  private Map<String, ArrayList<String>> symbolTable;
  private int tableId;
  private String funcId;

  public SymbolTable(int tableId, String funcId) {
    //Pair<Integer, String> pair = new MutablePair<>(tableId , funcId);  
    this.tableId = tableId;
    this.funcId = funcId;
    this.symbolTable = new HashMap<String, ArrayList<String>>();
  }

  public Map getSymbolTable() {
    return symbolTable;
  }

  public int getTableId() {
    return tableId;
  }

  public String getFuncId() {
    return funcId;
  }
  
  public boolean isSymbolPresent(String key) {
    return symbolTable.containsKey(key);
  }
  public ArrayList<String> getAttributes(String key) {
    if (isSymbolPresent(key)) {
      return symbolTable.get(key);
    } else return null;
  }
 
  public void addSymbol(String symbol, ArrayList attributes) {
    symbolTable.put(symbol, attributes);
  }
}
