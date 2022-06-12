/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package codeGenerator;

import fileManager.FileManager;

/**
 *
 * @author chris
 */
public class TDCGenerator {
  
  
  
  public static int temporalNum;
  public static String temporalVar;
  public static final String FUNCB = "FUNCB";
  public static final String FUNCE = "FUNCE";
  public static final String RETURN = "RETURN";
  public static final String PRINT = "PRINT";
  public static final String ASSIGN = "ASSIGN";
  public static final String CREATE = "CREATE";
  public static final String GOTO = "GOTO";
  public static final String CALL = "CALL";
  public static final String LABEL = "LABEL";
  public static final String IF = "IF";
  public static final String ELSE = "ELSE";
  public static final String READ = "READ";
  public static final String ADD = "ADD";
  public static final String SUB = "SUBS";
  public static final String MULT = "MULT";
  public static final String DIV = "DIV";
  public static final String EQ = "EQ";
  public static final String GTE = "GTE";
  public static final String GT = "GT";
  public static final String LTE = "LTE";
  public static final String LT = "LT";

  public TDCGenerator() {
    this.temporalNum = 0;
    this.temporalVar = "t" + this.temporalNum;
  }
  
  public static String codeGenerator(String operation, String var, String firstArg, String secondArg, String dataType) {
  
    switch(operation) {
      case FUNCB:
        generateICode("func " + var + " begin\n");  
        break;
      case FUNCE:
        generateICode("\nfunc " + var + " end");
        break;
      case RETURN:
        generateICode("\n\tRETURN " + var);
        break;
      case CREATE:
        generateICode("\t" + dataType + " " + var);
        break;
      case ASSIGN:
        if (dataType != null) {
          generateICode("\t" + dataType + " " + var + " = " + firstArg);
        } else {
          generateICode("\t" + var + " = " + firstArg);
        }
        break;
      case ADD:
        generateICode("\t" + var + " = " + firstArg + " + " + secondArg);
        break;
      case SUB:
        generateICode("\t" + var + " = " + firstArg + " - " + secondArg);
        break;
      case MULT:
        generateICode("\t" + var + " = " + firstArg + " * " + secondArg);
        break;
      case DIV:
        generateICode("\t" + var + " = " + firstArg + " / " + secondArg);
        break;
      case CALL:
        generateICode("\t" + var + " = " + " CALL TO " + firstArg);
        break;
    }
    return temporalVar;
  }
  
  public static String newTemporal() {
    temporalNum = temporalNum + 1;
    temporalVar = "t" + String.valueOf(temporalNum);
    return temporalVar;
  }
  
 
  public static void generateICode(String info) {
    FileManager fileManager = new FileManager("C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/symbolTable/iCode.txt");
    fileManager.writeToFile(info);
  }
  
}
