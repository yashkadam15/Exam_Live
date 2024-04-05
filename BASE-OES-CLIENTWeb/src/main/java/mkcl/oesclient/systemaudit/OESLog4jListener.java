/**
 * 
 */
package mkcl.oesclient.systemaudit;

import java.io.File;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import mkcl.oesclient.commons.utilities.MKCLUtility;

/**
 * @author amitk
 * 
 */
public class OESLog4jListener implements ServletContextListener{
	
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		ServletContext context = sce.getServletContext();
		String path = context.getRealPath(File.separator);
		
		if(path.endsWith(File.separator))
		{
			System.setProperty("OESrootPath", path);
		}
		else
		{
			path=path.concat(File.separator);
			System.setProperty("OESrootPath", path);
		}
		System.out.println("Setting log path:");
		System.out.println(System.getProperty("OESrootPath"));
		//code added to verify and reset auto increment value if machine(where OES-Client web is installed) is restarted. 
		//AuditVerificationMethods.verifyAutoincrementTables();
		// to take system backup at application context loading
		
		// Code to create folders in resources
		Properties properties=MKCLUtility.loadMKCLPropertiesFile();
		
		File UserPhotoUploadPath=new File(path+properties.getProperty("UserPhotoUploadPath"));		
		if (! UserPhotoUploadPath.exists()) {
			UserPhotoUploadPath.mkdirs();
		}
		
		File FileUploadPath=new File(path+properties.getProperty("FileUploadPath"));		
		if (! FileUploadPath.exists()) {
			FileUploadPath.mkdirs();
		}
		
		File BackupLocation=new File(path+properties.getProperty("BackupLocation"));		
		if (! BackupLocation.exists()) {
			BackupLocation.mkdirs();
		}
		
		File manualBackupLocation=new File(path+properties.getProperty("manualBackupLocation"));		
		if (! manualBackupLocation.exists()) {
			manualBackupLocation.mkdirs();
		}
		
		File EvidenceUploadPath=new File(path+properties.getProperty("EvidenceUploadPath"));		
		if (! EvidenceUploadPath.exists()) {
			EvidenceUploadPath.mkdirs();
		}
		
		File HTMLToPDFtargetFolderPath=new File(path+properties.getProperty("HTMLToPDFtargetFolderPath"));		
		if (! HTMLToPDFtargetFolderPath.exists()) {
			HTMLToPDFtargetFolderPath.mkdirs();
		}
				
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		
	}

}
