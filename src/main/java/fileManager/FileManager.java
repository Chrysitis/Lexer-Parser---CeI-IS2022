/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fileManager;
import java.io.File;  // Import the File class
import java.io.FileWriter;
import java.io.IOException;  // Import the IOException class to handle errors
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author chris
 */
public class FileManager {
  
  private final File file;
  private FileWriter writer;

  public FileManager(String file) {
    this.file = new File(file);
  }
  
 
  public void writeToFile(String info) {
    try {
      this.writer = new FileWriter(this.file, true);
      writer.write(info);
      writer.write("\n");
      writer.close();
    } catch (IOException ex) {
      Logger.getLogger(FileManager.class.getName()).log(Level.SEVERE, null, ex);
    }
  }
  
  public void emptyFile() {
    try {
      this.writer = new FileWriter(this.file);
      writer.write("");
      writer.close();
    } catch (IOException ex) {
      Logger.getLogger(FileManager.class.getName()).log(Level.SEVERE, null, ex);
    }
  }
}
