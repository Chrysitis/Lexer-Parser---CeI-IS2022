/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package codeGenerator;

import fileManager.FileManager;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import org.apache.commons.lang3.math.NumberUtils;

/**
 *
 * @author chris
 */
public class MIPSGenerator {

  // load and store instructions.
  public static final String LB = "lb";
  public static final String SB = "sb";
  public static final String LW = "lw";
  public static final String SW = "sw";
  public static final String LI = "li";
  public static final String LA = "la";

  // arithmetic operators.
  public static final String MOVE = "move";
  public static final String ADD = "add";
  public static final String ADDI = "addi";
  public static final String SUB = "sub";
  public static final String MULT = "mul";
  public static final String DIV = "div";

  // logical operators.
  public static final String AND = "and";
  public static final String OR = "or";

  // conditional branches
  public static final String BEQ = "beq";
  public static final String BGT = "bgt";
  public static final String BGE = "bge";
  public static final String BLT = "blt";
  public static final String BLE = "ble";

  // unconditional jumps
  public static final String J = "j";
  public static final String JR = "jr";
  public static final String JAL = "jal";

  // label/function
  public static final String LABEL = "label";
  // vars for data segment
  public static final String DATA = "data";
  // read function
  public static final String READ = "READ";
  // print function
  public static final String PRINT = "PRINT";
  // return statement
  public static final String RETURN = "RETURN";
  // comment
  public static final String COMMENT = "COMMENT";

  // Register with constant zero.
  public static String zeroRegister = "$zero";
  // Reserved register.
  public static String atRegister = "$at";
  // Registers for expressions and function results.
  public static String[] vRegisters = {"$v0", "$v1"};
  // Registers for arguments or parameters.
  public static String[] aRegisters = {"$a0", "$a1", "$a2", "$a3"};
  // Registers for temporal values.
  public static String[] tRegisters = {"$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8", "$t9"};
  // Registers for stored values.
  public static String[] sRegisters = {"$s0", "$s1", "$s2", "$s4", "$s5", "$s6", "$s7"};
  // Register for interruptions...
  public static String[] kRegisters = {"$k0", "$k1"};
  // Global register.
  public static String globalPointer = "$gp";
  // Stack pointer.
  public static String stackPointer = "$sp";
  // Stored value/frama pointer.
  public static String framePointer = "$s8";
  // Return address register.
  public static String raRegister = "$ra";
  // Register indexes.
  public static int tIndex = 0;
  public static int sIndex = 0;

  public static ArrayList<String> MIPSDataSegment = new ArrayList<>();
  public static ArrayList<String> MIPSTextSegment = new ArrayList<>();
  public static ArrayList<String> MIPSMainSegment = new ArrayList<>();
  public static ArrayList<String> temps = new ArrayList<>();
  public static ArrayList<String> tempsValues = new ArrayList<>();
  public static Map<String, String> dataSegmentVars = new HashMap<>();

  public static FileManager TDCManager = new FileManager("C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/codeGenerator/iCode.txt");
  public static FileManager MIPSManager = new FileManager("C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/codeGenerator/MIPSCode.s");

  // to check if we are in main label or other function/label.
  public static boolean main = false;
  // to check if a math operation is taking place and use the proper instructions.
  public static boolean mathOp = false;
  // printable values.
  public static String printTag = "printLabel_";
  public static int printTagCount = 0;
  public MIPSGenerator() {

  }

  /**
   *
   * @param op operation to perform.
   * @param destinationR register where the result is stored.
   * @param firstOp first operand register.
   * @param secondOp second operand register/immediate.
   * @param label could be label from data segment, function or branch tag.
   */
  public static void instructionGenerator(String op, String destinationR, String firstOp, String secondOp, String label) {

    switch (op) {
      case LABEL:
        if (main) {
          MIPSMainSegment.add("main:");
          dataSegmentVars.clear();
        } else {
          label = label.replace("(", ":");
          MIPSTextSegment.add("\n" + label);
          dataSegmentVars.clear();
        }
        break;
      case DATA:
        if (label.equals("dataInt") || label.equals("dataChar")) {
          MIPSDataSegment.add(destinationR + ":\t\t\t\t.byte " + firstOp);
        } else if(label.equals("dataBoolean")) {
          String boolVal = firstOp.equals("true")? "1" : "0";
          MIPSDataSegment.add(destinationR + ":\t\t\t\t.byte " + boolVal);
        } else if (label.equals("dataFloat")) {
          MIPSDataSegment.add(destinationR + ":\t\t\t\t.float" + firstOp);
        } else if (label.equals("dataString")) {
          MIPSDataSegment.add(destinationR + ":\t\t\t\t.asciiz " + firstOp);
        }
        break;
      case LI:
        if (main) {
          MIPSMainSegment.add("\t" + LI + "\t\t\t\t" + destinationR + ",\t" + firstOp);
        } else {
          MIPSTextSegment.add("\t" + LI + "\t\t\t\t" + destinationR + ",\t" + firstOp);
        }
        break;
      case LA:
        if (main) {
          MIPSMainSegment.add("\t" + LA + "\t\t\t\t" + destinationR + ",\t" + firstOp);
        } else {
          MIPSTextSegment.add("\t" + LA + "\t\t\t\t" + destinationR + ",\t" + firstOp);
        }
        break;
      case LB:
        if (main) {
          MIPSMainSegment.add("\t" + LB + "\t\t\t\t" + destinationR + ",\t" + "(" + firstOp + ")");
        } else {
          MIPSTextSegment.add("\t" + LB + "\t\t\t\t" + destinationR + ",\t" + "(" + firstOp + ")");
        }
        break;
      case SB:
        if (main) {
          MIPSMainSegment.add("\t" + SB + "\t\t\t\t" + destinationR + ",\t" + "(" + firstOp + ")");
        } else {
          MIPSTextSegment.add("\t" + SB + "\t\t\t\t" + destinationR + ",\t" + "(" + firstOp + ")");
        }
        break;
      case MULT:
        if (main) {
          MIPSMainSegment.add("\t" + MULT + "\t\t\t\t" + destinationR + ",\t" + firstOp + ",\t" + secondOp);
        } else {
          MIPSTextSegment.add("\t" + MULT + "\t\t\t\t" + destinationR + ",\t" + firstOp + ",\t" + secondOp);
        }
        break;
      case DIV:
        if (main) {
          MIPSMainSegment.add("\t" + DIV + "\t\t\t\t" + destinationR + ",\t" + firstOp + ",\t" + secondOp);
        } else {
          MIPSTextSegment.add("\t" + DIV + "\t\t\t\t" + destinationR + ",\t" + firstOp + ",\t" + secondOp);
        }
        break;
      case ADD:
        if (main) {
          MIPSMainSegment.add("\t" + ADD + "\t\t\t\t" + destinationR + ",\t" + firstOp + ",\t" + secondOp);
        } else {
          MIPSTextSegment.add("\t" + ADD + "\t\t\t\t" + destinationR + ",\t" + firstOp + ",\t" + secondOp);
        }
        break;
      case SUB:
        if (main) {
          MIPSMainSegment.add("\t" + SUB + "\t\t\t\t" + destinationR + ",\t" + firstOp + ",\t" + secondOp);
        } else {
          MIPSTextSegment.add("\t" + SUB + "\t\t\t\t" + destinationR + ",\t" + firstOp + ",\t" + secondOp);
        }
        break;
      case PRINT:
        if (main) {
          if (label.equals("string")) {
            MIPSMainSegment.add("\n\t" + LI + "\t\t\t\t" + vRegisters[0] + ",\t4");
            MIPSMainSegment.add("\t" + LA + "\t\t\t\t" + aRegisters[0] + ",\t" + firstOp);
            MIPSMainSegment.add("\tsyscall\n");
          } else if (label.equals("int")) {
            MIPSMainSegment.add("\n\t" + LI + "\t\t\t\t" + vRegisters[0] + ",\t1");
            MIPSMainSegment.add("\t" + MOVE + "\t\t\t\t" + aRegisters[0] + ",\t" + firstOp);
            MIPSMainSegment.add("\tsyscall\n");
          }
        } else {
          if (label.equals("string")) {
            MIPSTextSegment.add("\n\t" + LI + "\t\t\t\t" + vRegisters[0] + ",\t4");
            MIPSMainSegment.add("\t" + LA + "\t\t\t\t" + aRegisters[0] + ",\t" + firstOp);
            MIPSMainSegment.add("\tsyscall\n");
          } else if (label.equals("int")) {
            MIPSMainSegment.add("\n\t" + LI + "\t\t\t\t" + vRegisters[0] + ",\t1");
            MIPSMainSegment.add("\t" + MOVE + "\t\t\t\t" + aRegisters[0] + ",\t" + firstOp);
            MIPSMainSegment.add("\tsyscall\n");
          }
        }
        break;
      case READ:
        if (main) {
          MIPSMainSegment.add("\n\t" + LI + "\t\t\t\t" + vRegisters[0] + ",\t5");
          MIPSMainSegment.add("\tsyscall\n");
        } else {
          MIPSTextSegment.add("\n\t" + LI + "\t\t\t\t" + vRegisters[0] + ",\t5");
          MIPSTextSegment.add("\tsyscall\n");        
        }
        break;
      case RETURN:
        if (main) {
          MIPSMainSegment.add("\nend:");
          MIPSMainSegment.add("\t" + LI + "\t\t\t\t" + vRegisters[0] + ",\t10");
          MIPSMainSegment.add("\tsyscall");
        } else {
          MIPSTextSegment.add("\n\t" + JR + "\t\t\t\t" + raRegister);
        }
        break;
      case COMMENT:
        if (main) {
          MIPSMainSegment.add("#" + firstOp);
        } else {
          MIPSMainSegment.add("#" + firstOp);
        }
        break;
    }
  }

  public static void MipsGenerator() {
    MIPSDataSegment.add(".data\n");
    MIPSMainSegment.add("\n.text\n");
    BufferedReader lineReader;
    boolean lineBlank = false;
    try {
      lineReader = new BufferedReader(new FileReader("C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/codeGenerator/iCode.txt"));
      String line = lineReader.readLine();
      while (line != null) {
        reinitRegistersIndex();
        // Deletes whitespaces.
        String[] lineParts = !line.isBlank() ? line.split(" ") : null;
        lineBlank = lineParts == null;
        System.out.println("LINE IS: " + line);
        //System.out.println("LINEPARTS IS: " + (lineParts == null? "null" : lineParts[0]));
        if (!lineBlank) {
          lineParts[0] = !(lineParts == null) ? deleteTabs(lineParts[0]) : null;
          // Deletes tabs from first value.
          Character initChar = !lineBlank ? lineParts[0].charAt(0) : ' '; // Obstains a "t" if inst is "t# = 99"
          // in case it is a function.
          if (lineParts[0].equals("func")) {
            if (lineParts[2].equals("begin")) {
              main = lineParts[1].equals("main()"); // changes to true if we are on main label/function.
              instructionGenerator(LABEL, null, null, null, lineParts[1]);
            } else {
              temps.clear();
              tempsValues.clear();
              instructionGenerator(RETURN, null, null, null, null);
            }

          } else if(lineParts[0].contains("PRINT(")) {
            String dataValue = getPrintInformation(lineParts);
            // Si es un string literal.
            String newTag = printTag + printTagCount;
            if (dataValue.contains("\"")) {
              printTagCount++;
              instructionGenerator(DATA, newTag, dataValue, null, "dataString");
              //instructionGenerator(LA, aRegisters[1], newTag, null, null);
              instructionGenerator(PRINT, null, newTag, null, "string");
            } else {
              instructionGenerator(LA, aRegisters[0], dataValue, null, null);
              instructionGenerator(LB, aRegisters[1], aRegisters[0], null, null);
              instructionGenerator(PRINT, null, aRegisters[1], null, "int");
            }
          } else if (lineParts.length >= 4 && lineParts[3].contains("READ()")) {
              instructionGenerator(DATA, lineParts[1], "0", null, "dataInt");
              instructionGenerator(COMMENT, null, "READ INT RETURNS IN $V0", null, null);
              instructionGenerator(READ, null, null, null, "string");
              instructionGenerator(LA, aRegisters[1], lineParts[1], null, null);
              instructionGenerator(SB, vRegisters[0], aRegisters[1], null, null);
          } else if (lineParts[0].contains("data")) {
            // in case it is a declaration.
            String dataValue = getTempValue(lineParts[3]);
            //String dataValue = getIdentifier(lineParts[3]);
            if (lineParts[0].equals("dataString")) {
              dataValue = getDataStringValue(lineParts);
              instructionGenerator(DATA, lineParts[1], dataValue, null, lineParts[0]);
            } else if(lineParts[0].equals("dataChar")) {
              String op1Temp = getTempValue(lineParts[3]);
              instructionGenerator(DATA, lineParts[1], op1Temp, null, lineParts[0]);
            } else if(lineParts[0].equals("dataBoolean")) {
              String op1Temp = getTempValue(lineParts[3]);
              instructionGenerator(DATA, lineParts[1], op1Temp, null, lineParts[0]);
            } else {
              if (mathOp) {
                instructionGenerator(DATA, lineParts[1], "0", null, lineParts[0]);
                instructionGenerator(LA, sRegisters[sIndex], lineParts[1], null, null);
                int tRegisterIndex = tIndex == 0 ? 0 : tIndex - 1;
                instructionGenerator(SB, tRegisters[tRegisterIndex], sRegisters[sIndex], null, null);
                sIndex++;
              } else {
                //instructionGenerator(COMMENT, null, "DATA value is: " + dataValue, null, null);
                //int tRegisterIndex = tIndex == 0? 0 : tIndex - 1;
                instructionGenerator(DATA, lineParts[1], "0", null, lineParts[0]);
                instructionGenerator(LA, sRegisters[sIndex], lineParts[1], null, null);
                instructionGenerator(LI, tRegisters[tIndex], dataValue, null, null);
                instructionGenerator(SB, tRegisters[tIndex], sRegisters[sIndex], null, null);
              }
              sIndex++;
              mathOp = false;
            }
            dataSegmentVars.put(lineParts[3], lineParts[1]);
          } else if ((lineParts.length >= 4) && (lineParts[3].contains("*") || lineParts[3].contains("/") || lineParts[3].contains("+") || lineParts[3].contains("-"))) {
            // in case it is a temps arithmetic operation.
            //temps.add(lineParts[0]);
            tIndex = (tIndex > 0) ? tIndex - 1 : 1;
            String op1Temp = lineParts[2];
            String op2Temp = lineParts[4];
            String op1Val = getTempValue(op1Temp);
            String op2Val = getTempValue(op2Temp);
            String op1Var = getIdentifier(op1Temp);
            String op2Var = getIdentifier(op2Temp);
            //if(!op1Val.equals("0")) {
            //  instructionGenerator(LI, tRegisters[tIndex++], op1Val, null, lineParts[0]);
            //}
            //instructionGenerator(LI, tRegisters[tIndex], op2Val, null, lineParts[0]);
            if (!NumberUtils.isParsable(op1Var)) {
              instructionGenerator(COMMENT, null, "LA op1Var is: " + op1Var, null, null);
              instructionGenerator(LA, sRegisters[sIndex], op1Var, null, null);
              instructionGenerator(LB, tRegisters[tIndex], sRegisters[sIndex], null, null);
            } else {
              if (!op1Val.equals("0")) {
                instructionGenerator(COMMENT, null, "LI op1Val is: " + op1Val, null, null);
                instructionGenerator(LI, tRegisters[tIndex], op1Val, null, lineParts[0]);
              }
              //instructionGenerator(LI, tRegisters[tIndex], op2Val, null, lineParts[0]);
            }
            //instructionGenerator(LB, tRegisters[tIndex], sRegisters[sIndex], null, null);
            sIndex++;
            tIndex++;
            if (!NumberUtils.isParsable(op2Var)) {
              instructionGenerator(COMMENT, null, "LA op2Var is: " + op2Var, null, null);
              instructionGenerator(LA, sRegisters[sIndex], op2Var, null, null);
              instructionGenerator(LB, tRegisters[tIndex], sRegisters[sIndex], null, null);
            } else {
              if (!op2Val.equals("0")) {
                instructionGenerator(COMMENT, null, "LI op2Val is: " + op2Val, null, null);
                instructionGenerator(LI, tRegisters[tIndex], op2Val, null, lineParts[0]);
              }
            }
            //instructionGenerator(LB, tRegisters[tIndex], sRegisters[sIndex], null, null);
            sIndex++;
            //tIndex++;
            if (lineParts[3].equals("*")) {
              //Integer intRes = Integer.parseInt(getTempValue(op1)) * Integer.parseInt(getTempValue(op2));
              //String valRes = String.valueOf(intRes);
              instructionGenerator(MULT, tRegisters[--tIndex], tRegisters[tIndex], tRegisters[++tIndex], null);
            } else if (lineParts[3].equals("/")) {
              //Integer intRes = Integer.parseInt(getTempValue(op1)) / Integer.parseInt(getTempValue(op2));
              //sString valRes = String.valueOf(intRes);
              instructionGenerator(DIV, tRegisters[--tIndex], tRegisters[tIndex], tRegisters[++tIndex], null);
            } else if (lineParts[3].equals("+")) {
              //Integer intRes = Integer.parseInt(getTempValue(op1)) + Integer.parseInt(getTempValue(op2));
              //String valRes = String.valueOf(intRes);
              instructionGenerator(ADD, tRegisters[--tIndex], tRegisters[tIndex], tRegisters[++tIndex], null);
            } else if (lineParts[3].equals("-")) {
              //Integer intRes = Integer.parseInt(getTempValue(op1)) - Integer.parseInt(getTempValue(op2));
              //String valRes = String.valueOf(intRes);
              instructionGenerator(SUB, tRegisters[--tIndex], tRegisters[tIndex], tRegisters[++tIndex], null);
            }
            mathOp = true;
            //temps.add(lineParts[0]);
            //tempsValues.add("0");

          } else if (initChar.equals('t')) {
            // in case it is a temp assignation.
            temps.add(lineParts[0]);
            String tempVal = lineParts[2];
            //tempVal = tempVal.replace("\'", "\"");
            tempsValues.add(tempVal);
          }
          System.out.println(MIPSGenerator.temps);
          System.out.println(MIPSGenerator.tempsValues);
        }
        line = lineReader.readLine();
      }
    } catch (IOException e) {
      e.printStackTrace();
    }
    writeMipsToFile();
  }

  public static String getTempValue(String temp) {
    if (temps.contains(temp)) {
      return tempsValues.get(temps.indexOf(temp));
    }
    return "0";
  }

  public static String getIdentifier(String temp) {
    if (dataSegmentVars.containsKey(temp)) {
      return dataSegmentVars.get(temp);
    }
    return getTempValue(temp);
  }

  public static String getDataStringValue(String[] array) {
    int index = 3;
    int len = array.length;
    String data = "";
    while (index < len) {
      data += array[index] + " ";
      index++;
    }
    return data;
  }
  
  public static String getPrintInformation(String[] array) {
    int index = 0;
    int len = array.length;
    String data = "";
    while (index < len) {
      data += array[index] + " ";
      index++;
    }
    data = data.replace("PRINT(", "");
    data = data.replace(")", "");
    return data;
  }

  public static String deleteTabs(String val) {
    if (val.contains("\t")) {
      return val.split("\t")[1];
    }
    return val;
  }

  public static void reinitRegistersIndex() {
    if (tIndex > 8) {
      tIndex = 0;
    }
    if (sIndex > 5) {
      sIndex = 0;
    }
  }

  public static void writeMipsToFile() {

    for (String dataLine : MIPSDataSegment) {
      MIPSManager.writeToFile(dataLine);
    }
    for (String mainLine : MIPSMainSegment) {
      MIPSManager.writeToFile(mainLine);
    }
    for (String textLine : MIPSTextSegment) {
      MIPSManager.writeToFile(textLine);
    }
  }
}
