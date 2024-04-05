/**
 * 
 */
package mkcl.oesclient.common;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Serializable;

import org.junit.Test;

/**
 * @author virajd
 *
 */
public class Java_Practice {

	@Test
	public void test() {
		// The name of the file to open.
        String fileName = "D:\\__MKCLDevelopment\\OES\\00_Source\\BASE OES\\BASE OES-CLIENT\\BASE-OES-CLIENTWeb\\src\\test\\java\\mkcl\\oesclient\\common\\GroupFormationTestCase.java";

        // This will reference one line at a time
        String line = null;

        try {
            // FileReader reads text files in the default encoding.
            FileReader fileReader = 
                new FileReader(fileName);

            // Always wrap FileReader in BufferedReader.
            BufferedReader bufferedReader = 
                new BufferedReader(fileReader);
            
            StringBuilder strBldr=new StringBuilder();
            while((line = bufferedReader.readLine()) != null) {
                // System.out.println(line);
                strBldr.append(line);
                line.replaceAll("class GroupFormationTestCase", "class GroupFormationTestCase implements Serializable");
            }   

            // Always close files.
            bufferedReader.close();
            System.out.println(strBldr.toString());
        }
        catch(FileNotFoundException ex) {
            System.out.println(
                "Unable to open file '" + 
                fileName + "'");                
        }
        catch(IOException ex) {
            System.out.println(
                "Error reading file '" 
                + fileName + "'");                  
            // Or we could just do this: 
            // ex.printStackTrace();
        }

			
	}

}
