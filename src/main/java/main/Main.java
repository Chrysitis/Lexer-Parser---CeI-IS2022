/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import cup.parser;
import cup.sym;
import fileManager.FileManager;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.Symbol;
import jflex.Lexer;

/**
 *
 * @author chris
 */
public class Main {
  
  public static FileManager fileManager = new FileManager("C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/symbolTable/Tokens.txt");
  // Lexer.class, parser.class and sym.class dirs to delete them everytime the program in run to avoid replication. :)
  public static String lexerClassDir = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/jflex/Lexer.java";
  public static String parserClassDir = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/cup/parser.java";
  public static String symClassDir = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/cup/sym.java";
  // The jflex and cup specification dirs to work with.
  public static String[] jFlexFile = {"C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/jflex/jflexSpec.jflex"};
  public static String[] cupFile = {"-parser", "parser" ,"C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/cup/cupSpec.cup"};
  // The direction to the cup package to move the parser and sym classes.
  public static Path currentPath = Paths.get("");
  public static String cupPackageDir = currentPath.toAbsolutePath().toString() + File.separator + "src" + File.separator + "main"
            + File.separator + "java" + File.separator + "cup" + File.separator;
  public static String testFilePackageDir = currentPath.toAbsolutePath().toString() + File.separator + "src" + File.separator + "main"
            + File.separator + "java" + File.separator + "testFiles" + File.separator;
  // Some files to test on...
  public static String testFile = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/testFiles/lexerTest.txt";
  public static String codeFile = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/testFiles/codeTest.txt";
  public static String codeFile2 = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/testFiles/codeTest2.txt";
  public static String codeFile3 = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/testFiles/codeTest3.txt";

  /**
   * @param args the command line arguments
   */
  public static void main(String[] args) throws IOException {
    //lexicalAnalysis(testFilePackageDir + "codeTest2.txt");
    syntacticAnalysis(testFilePackageDir + "codeTest.txt");
  }

  private static void lexicalAnalysis(String file)throws IOException {
    fileManager.emptyFile();
    // Delete the files if they have been previously created...
    delFile(new File(lexerClassDir));
    delFile(new File(parserClassDir));
    delFile(new File(symClassDir));
    createLexer(jFlexFile);             // Creates the lexer class.
    createParser(cupFile);              // Creates the parser and sym class.       
    // Moving the parser and sym class.
    moveFile(new File("parser.java"), cupPackageDir);
    moveFile(new File("sym.java"), cupPackageDir);

    BufferedReader br = null;
    try {
      br = new BufferedReader(new FileReader(file));
      Lexer lexer = new Lexer(br);
      Symbol token;
      do {
        token = lexer.next_token();
      } while (token.sym != sym.EOF);
      System.out.println("*************** LEXYCAL ANALYSIS RESULT ***************");
      lexer.printTokens();
      System.out.println("*************** RESULTS WRITTEN TO TOKENS.TXT FILE ***************");
    } catch (FileNotFoundException ex) {
      Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
    } finally {
      try {
        br.close();
      } catch (IOException ex) {
        Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
      }
    }
  }
  
  public static void syntacticAnalysis(String file) throws IOException {
 
    fileManager.emptyFile();
    // Delete the files if they have been previously created...
    delFile(new File(lexerClassDir));
    delFile(new File(parserClassDir));
    delFile(new File(symClassDir));
    createLexer(jFlexFile);             // Creates the lexer class.
    createParser(cupFile);              // Creates the parser and sym class.       
    // Moving the parser and sym class.
    moveFile(new File("parser.java"), cupPackageDir);
    moveFile(new File("sym.java"), cupPackageDir);

    BufferedReader br = null;
    try {
      br = new BufferedReader(new FileReader(file));
      Lexer lexer = new Lexer(br);
      parser codeParser = new parser(0, lexer);
      codeParser.initParser();
    } catch (FileNotFoundException ex) {
      Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
    } finally {
      try {
        br.close();
      } catch (IOException ex) {
        Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
      }
    }
  }
  
  private static void createLexer(String[] jFlexFile) {
    jflex.Main.main(jFlexFile);         // Creates the lexer class.
    System.out.println("*************** The lexer was created ***************");
  }

  private static void createParser(String[] cupFile) {
    try {
      java_cup.Main.main(cupFile);        // Creates the parser and sym class.
      System.out.println("*************** The parser was created ***************");
    } catch (IOException ex) {
      Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
    } catch (Exception ex) {
      Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
    }
  }

  private static boolean moveFile(File file, String newDir) {

    if (file.exists()) {
      File oldFile = new File(newDir + file.getName());
      delFile(oldFile);
      if (file.renameTo(new File(newDir + file.getName()))) {
        System.out.println("*************** The file " + file.getName() + " was moved ***************");
        return true;
      }
    }
    System.out.println("*************** The file " + file.getName() + " does not exist ***************");
    return false;
  }

  private static boolean delFile(File file) {

    if (file.exists()) {
      file.delete();
      System.out.println("*************** Old " + file.getName() + " file deleted ***************");
      return true;
    }
    return false;
  }
}
