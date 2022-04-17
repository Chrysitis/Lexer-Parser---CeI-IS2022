/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import cup.sym;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;
import java_cup.runtime.Symbol;
import jflex.Lexer;

/**
 *
 * @author chris
 */
public class Main {


  /**
   * @param args the command line arguments
   */
  public static void main(String[] args) throws IOException {

    System.out.println("Hello, World!");
    // Lexer.class, parser.class and sym.class dirs to delete them everytime the program in run to avoid replication. :)
    String lexerClassDir = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/jflex/Lexer.java";
    String parserClassDir = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/cup/parser.java";
    String symClassDir = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/cup/parser.java";
    // The jflex and cup specification dirs to work with.
    String[] jFlexFile = {"C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/jflex/jflexSpec.jflex"};
    String[] cupFile = {"C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/cup/cupSpec.cup"};
    // The direction to the cup package to move the parser and sym classes.
    Path currentPath = Paths.get("");
    String cupPackageDir = currentPath.toAbsolutePath().toString() + File.separator + "src" + File.separator + "main"
            + File.separator + "java" + File.separator + "cup" + File.separator;
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
      String testFile = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/testFiles/lexerTest.txt";
      String codeFile = "C:/Users/chris/Documents/NetBeansProjects/CeI-PYI/src/main/java/testFiles/codeTest.txt";
      br = new BufferedReader(new FileReader(testFile));
      Lexer lexer = new Lexer(br);
      Symbol token;
      do {
        token = lexer.next_token();
        System.out.println("El token es: " + token);
      } while (token.sym != sym.EOF);
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
