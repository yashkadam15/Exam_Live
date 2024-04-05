package mkcl.oesclient.dailybackup;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.model.VenueUser;
import mkcl.oespcs.model.ExamVenue;
import mkcl.os.localdal.model.ISqlOperation;
import mkcl.os.localdal.model.ISqlOperationImpl;
import mkcl.os.security.AESHelper;

import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BackUpServices {
	private static final Logger LOGGER = LoggerFactory.getLogger(BackUpServices.class);
	private ISqlOperation icrud = new ISqlOperationImpl();
	public boolean createBackupFile() {
		try 
		{
			ProcessBuilder pb=null;
			List<String> cmdList=new ArrayList<String>();
			/*String BackupLocation = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "BackupLocation");*/
			String rootPath = System.getProperty("OESrootPath");
			String BackupLocation = rootPath+"resources"+File.separator+"WebFiles"+File.separator+"BackupFiles"+File.separator;
			if(BackupLocation!=null && !BackupLocation.isEmpty())
			{
				String smartClientPath=rootPath+"/OES-SmartClient/OES-SmartClient.exe";
				String DBBackupStatusFilePath=rootPath+"/resources/WebFiles/OESFiles/DBBackupStatus.txt";
				String filePath ="";
				VenueUser dbUser = new LoginServiceImpl().getUserByRole(1l);
				String osname = System.getProperty("os.name").toLowerCase();

				if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
				{
					//for sending  request to sh file
					filePath = rootPath+"/WEB-INF/classes/";
					//process = Runtime.getRuntime().exec(filePath +" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" "+BackupLocation+" "+DBBackupStatusFilePath+" "+smartClientPath);
					cmdList.add("sh");
					cmdList.add("OESDBBackup.sh");
					cmdList.add(dbUser.getUserName());				
					cmdList.add(dbUser.getPassword());
					cmdList.add(BackupLocation);
					cmdList.add(DBBackupStatusFilePath);
					cmdList.add(smartClientPath);
				}
				else
				{
					// for windows
					String jrePath="";
					String f="C:/Windows/SysWOW64";
					if(new File(f).exists())
					{
						jrePath="C:\\Program Files (x86)\\Java\\jre6\\bin\\java";
						/*					jrePath="C:\\Program Files\\Java\\jre6\\bin\\java";*/
						jrePath="\""+jrePath+"\"";
					}
					else 
					{
						jrePath="C:\\Program Files\\Java\\jre6\\bin\\java";
						jrePath="\""+jrePath+"\"";
					}
					filePath = rootPath+"\\WEB-INF\\classes\\";
					//filePath="\""+filePath+"\"";
					smartClientPath="\""+smartClientPath+"\"";
					DBBackupStatusFilePath="\""+DBBackupStatusFilePath+"\"";
					BackupLocation=BackupLocation.substring(0,BackupLocation.length()-1);
					BackupLocation="\""+BackupLocation+"\"";
					cmdList.add("cmd");
					cmdList.add("/c");
					cmdList.add("OESDBBackup.bat");
					cmdList.add(dbUser.getUserName());
					cmdList.add(passwordParse(dbUser.getPassword()));
					cmdList.add(BackupLocation);
					cmdList.add(DBBackupStatusFilePath);
					cmdList.add(smartClientPath);
					cmdList.add(jrePath);
					/*	LOGGER.error("credentials ::");
					LOGGER.error("BackupLocation :: "+BackupLocation);
					LOGGER.error("DBBackupStatusFilePath :: "+DBBackupStatusFilePath);
					LOGGER.error("smartClientPath"+smartClientPath);
					LOGGER.error("JRE path :"+jrePath); */
				}
				pb=new ProcessBuilder(cmdList);
				pb.directory(new File(filePath));
				//process = Runtime.getRuntime().exec(filePath +" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" "+BackupLocation+" "+DBBackupStatusFilePath+" "+smartClientPath+" "+jrePath);
				syncStreamReader(pb);		       

				// code to delete older files except first five backup files.
				if(BackupLocation!=null && !BackupLocation.isEmpty())
				{
					if(!deleteOlderFiles(rootPath+"resources"+File.separator+"WebFiles"+File.separator+"BackupFiles"+File.separator)){
						LOGGER.error("Older backup files not delete successfully");
					}
				}
			}



		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in createBackupFile: ", e);
			return false;
		}
		return true;
	}
	
	public boolean createDatabaseBackup() {
		String rootPath = System.getProperty("OESrootPath");
		String BackupLocation = rootPath+"resources"+File.separator+"WebFiles"+File.separator+"BackupFiles"+File.separator;
		ExamVenueActivationServicesImpl examVenueActivationServicesImpl=new ExamVenueActivationServicesImpl();
		boolean status=false;
		try {
			Date date = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("ddMMMyyyyhmmss");
            String formattedDate = sdf.format(date);
			
			File f = new File(BackupLocation);
	        String fileName = f.getAbsolutePath();
	        fileName = fileName.replace("\\", "/");
	        
	        ExamVenue examVenue=examVenueActivationServicesImpl.getExamVenue();
	        if (examVenue !=null) {
	        	BackupLocation=fileName+"/"+examVenue.getExamVenueCode()+"_OES_" + formattedDate + ".sql";
	 			status= icrud.createDBBackup(BackupLocation);
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in createDatabaseBackup: ", e);
			return false;
		}
		return status;
	}
	

	public static String passwordParse(String str)
	{
		try {

			str= AESHelper.encrypt(str,EncryptionHelper.encryptDecryptKey);
		} catch (Exception e) {
			LOGGER.error("Exception occured in getEncryptedAndDoubleCoatedString: " ,e);
			return null;
		}
		str="\""+str+"\"";		 
		return  str;
	}

	private void syncStreamReader(ProcessBuilder pb) throws IOException {
		Process process;
		class errorReader implements Runnable {
			Process p=null;
			errorReader(Process process)
			{					
				p=process;
			}
			@Override
			public void run() {
				try
				{
					InputStream es = p.getErrorStream();
					InputStreamReader esr = new InputStreamReader(es);
					BufferedReader ebr = new BufferedReader(esr);
					int i=0;
					while ((ebr.readLine()) != null) {
						i++;
					}
					es.close();
					esr.close();
					ebr.close();
				}
				catch (Exception e)
				{
					LOGGER.error("Error in reading error stream",e);
				}
			}
		};		


		class inputReader implements Runnable {
			Process p=null;
			inputReader(Process process)
			{					
				p=process;
			}			
			@Override
			public void run() {
				try
				{
					InputStream is = p.getInputStream();
					InputStreamReader isr = new InputStreamReader(is);
					BufferedReader br = new BufferedReader(isr);
					int i=0;
					while ((br.readLine()) != null) {
						i++;
					}				        
					br.close();
					is.close();
					isr.close();
				}
				catch (Exception e)
				{
					LOGGER.error("Error in reading input stream",e);
				}
			}
		};        
		process = pb.start();	      

		new Thread(new errorReader(process)).start();
		new Thread(new inputReader(process)).start();
	}

	public boolean deleteOlderFiles(String bkpFolderPath)
	{
		try {
			File dir = new File(bkpFolderPath);
			FileFilter fileFilter = new WildcardFileFilter("*.sql");
			File[] files = dir.listFiles(fileFilter);
			if(files!=null && files.length>0)
			{
				Arrays.sort(files, new Comparator(){
					public int compare(Object o1, Object o2) {
						return compare( (File)o1, (File)o2);
					}
					private int compare( File f1, File f2){
						long result = f2.lastModified() - f1.lastModified();
						if( result > 0 ){
							return 1;
						} else if( result < 0 ){
							return -1;
						} else {
							return 0;
						}
					}
				});


				for(int i=0; i<files.length; i++) 
				{
					if(i>4)
					{
						files[i].delete();
					}
				}

			}

		} catch (Exception e) {
			LOGGER.error("Exception occured in deleteOlderFiles: " ,e);
			return false;
		}

		return true;

	}
}
