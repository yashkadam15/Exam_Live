package mkcl.oesclient.admin.controllers;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.FileUploadException;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oespcs.model.ExamEvent;
import mkcl.os.security.AESHelper;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("syncDataSMC")
public class SynchroniseDataController 
{
	private static final Logger LOGGER = LoggerFactory.getLogger(SynchroniseDataController.class);

	/**
	 * Get method for Sync Exam Event
	 * @param model
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "selectSyncEvent", method = RequestMethod.GET)
	public String selectSyncEvent(Model model, String messageid, Locale locale,HttpServletRequest request) {
		try 
		{
			if (messageid != null && !messageid.equals("")) {
				addMessage(Integer.parseInt(messageid), model, locale);
			}

			List<ExamEvent> examEventList=new ExamEventServiceImpl().getAllExamEventList();
			model.addAttribute("examEventList", examEventList);

		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in selectSyncEvent: " ,e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return Constants.ERRORPAGE;
		}

		return "Admin/syncData/SyncExamData";
	}
		
	/**
	 * Get method to Read Downloading Status
	 * @param model
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "readDownloadingStatusAjax", method = RequestMethod.GET)
	@ResponseBody public String readDownloadingStatusAjax(Model model, Locale locale,HttpServletRequest request) {
		try 
		{
			ProcessBuilder pb=null;
			Process process = null;
			String filePath =null;
			String batORsh="";
			String out="";
			//for sending  request to sh file
			String osname = System.getProperty("os.name").toLowerCase();
			String syncStatusLogFilePath=request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/OESFiles/syncExamDataStatus.txt";
			List<String> cmdList=new ArrayList<String>();
			if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
			{
				filePath=request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";
				batORsh="ReadDownloadStatus.sh";
				cmdList.add("sh");
			}
			else 
			{
				filePath=request.getSession().getServletContext().getRealPath("")+"\\WEB-INF\\classes\\";
				//filePath="\"" + filePath + "\"";
				syncStatusLogFilePath=syncStatusLogFilePath.replace("/", "\\");
				syncStatusLogFilePath="\"" +syncStatusLogFilePath+"\"";
				batORsh="ReadDownloadStatus.bat";
				cmdList.add("cmd");
				cmdList.add("/c");
			}
			if(new File(syncStatusLogFilePath.replace("\"", "")).exists())
			{
				cmdList.add(batORsh);
				cmdList.add(syncStatusLogFilePath);
				pb=new ProcessBuilder(cmdList);
				
				pb.directory(new File(filePath));
				process = pb.start();
				//process = Runtime.getRuntime().exec(filePath+" "+syncStatusLogFilePath);

				//Code to write response on view
				StringWriter op = new StringWriter();
				IOUtils.copy(process.getInputStream(), op);

				if(!op.toString().isEmpty())
				{
					out = op.toString();
				}
				else
				{					
					IOUtils.copy(process.getErrorStream(), op);
					out = op.toString();	
				}
			}

			return out;

		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncExamData: " ,e);
			return null;
		}
	}

	/**
	 * Get method to Sync Exam Data
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "syncExamDataAjax", method = RequestMethod.GET)
	@ResponseBody public String syncExamDataAjax( Locale locale,HttpServletRequest request) {
		try 
		{
			if(request.getParameter("examEventId")!=null && !request.getParameter("examEventId").isEmpty())
			{
				String osname = System.getProperty("os.name").toLowerCase();
				Process process = null;
				ProcessBuilder pb=null;
				List<String> cmdList=new ArrayList<String>();
				String filePath="";
				VenueUser dbUser = new LoginServiceImpl().getAdminUserByUsername(SessionHelper.getLogedInUser(request).getUserName());
				String syncStatusLogFilePath=request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/OESFiles/syncExamDataStatus.txt";
				String smartClientPath=request.getSession().getServletContext().getRealPath("")+"/OES-SmartClient/OES-SmartClient.exe";
				
				if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
				{
					//for sending  request to sh file
					filePath = request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";
					//process = Runtime.getRuntime().exec(filePath +" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" " + request.getParameter("examEventId")+" "+syncStatusLogFilePath+" "+smartClientPath);
					cmdList.add("sh");
					cmdList.add("CallSmartClient.sh");
					cmdList.add(dbUser.getUserName());					
					cmdList.add(dbUser.getPassword());
					cmdList.add(request.getParameter("examEventId"));
					cmdList.add(syncStatusLogFilePath);
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
						jrePath="\""+jrePath+"\"";
					}
					else 
					{
						jrePath="C:\\Program Files\\Java\\jre6\\bin\\java";
						jrePath="\""+jrePath+"\"";
					}
					filePath = request.getSession().getServletContext().getRealPath("")+"\\WEB-INF\\classes\\";
					//filePath="\"" + filePath + "\"";
					
					syncStatusLogFilePath="\""+syncStatusLogFilePath+"\"";
					smartClientPath="\""+smartClientPath+"\"";
					//process = Runtime.getRuntime().exec(filePath+" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" " + request.getParameter("examEventId")+" "+syncStatusLogFilePath+" "+smartClientPath+" "+jrePath);
					cmdList.add("cmd");
					cmdList.add("/c");
					cmdList.add("CallSmartClient.bat");
					cmdList.add(dbUser.getUserName());									
					cmdList.add(passwordParse(dbUser.getPassword()));
					cmdList.add(request.getParameter("examEventId"));
					cmdList.add(syncStatusLogFilePath);
					cmdList.add(smartClientPath);
					cmdList.add(jrePath);
				}	
				
				pb=new ProcessBuilder(cmdList);
				
				pb.directory(new File(filePath));
				syncStreamReader(pb);
				return "OK";
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncExamData: " ,e);
			return null;
		}
		return "";
	}


	private void addMessage(Integer messageid, Model model, Locale locale) {
		if (messageid != null && !messageid.equals("")) {
			MKCLUtility.addMessage(messageid, model, locale);
		}
	}

	/**
	 * Get method for DB Backup List
	 * @param model
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "dbBackupList", method = RequestMethod.GET)
	public String dbBackupList(Model model, String messageid, Locale locale,HttpServletRequest request) {
		try 
		{
			if (messageid != null && !messageid.equals("")) {
				addMessage(Integer.parseInt(messageid), model, locale);
			}

			String BackupLocation = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "BackupLocation");

			Map<String,String> fileNames=new LinkedHashMap<String, String>();
			if(BackupLocation!=null && !BackupLocation.isEmpty())
			{
				fileNames=deleteOlderFiles(BackupLocation);
				
			}
			String fileData=readDBBackupStatusAjax(model, locale, request);
			String isInprocess="0";
			if(fileData!=null && !fileData.trim().isEmpty() && !fileData.contains("^^^"))
			{
				isInprocess="1";
			}
			model.addAttribute("isInprocess", isInprocess);
			model.addAttribute("fileNames", fileNames);
			//model.addAttribute("path", FileUploadHelper.getRelativeFolderPath(request, "BackupLocation"));

		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in dbBackupList: " ,e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return Constants.ERRORPAGE;
		}
		return "Admin/syncData/dbBackupList";
	}

	/**
	 * Get method for Download SQL File
	 * @param model
	 * @param response
	 * @param locale
	 * @param request
	 */
	@RequestMapping(value = "downloadSqlFile", method = RequestMethod.GET)
	public void downloadSqlFile(Model model, HttpServletResponse response, Locale locale,HttpServletRequest request) {
		try 
		{

			String filename=request.getParameter("filename");
			if(filename!=null && !filename.isEmpty())
			{

				String fullFilePath = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request,"BackupLocation");
				File file=new File(fullFilePath+filename);
				FileInputStream inStream = new FileInputStream(file);
				response.setContentType("text/x-sql");
				response.setContentLength((int) file.length());
				String headerKey = "Content-Disposition";
				String headerValue = String.format("attachment; filename=\"%s\"", file.getName());
				response.setHeader(headerKey, headerValue);
				OutputStream outStream = response.getOutputStream();

				byte[] buffer = new byte[4096];
				int bytesRead = -1;

				while ((bytesRead = inStream.read(buffer)) != -1) {
					outStream.write(buffer, 0, bytesRead);
				}
				inStream.close();
				outStream.close(); 
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in downloadSqlFile: ", e);
		}

	}

	/**
	 * Get method for Create Backup File
	 * @param model
	 * @param response
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "createBackupFile", method = RequestMethod.GET)
	public String createBackupFile(Model model, HttpServletResponse response, Locale locale,HttpServletRequest request) {
		try 
		{
			ProcessBuilder pb=null;
			List<String> cmdList=new ArrayList<String>();
			String BackupLocation = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "BackupLocation");
			if(BackupLocation!=null && !BackupLocation.isEmpty())
			{
				String smartClientPath=request.getSession().getServletContext().getRealPath("")+"/OES-SmartClient/OES-SmartClient.exe";
				String DBBackupStatusFilePath=request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/OESFiles/DBBackupStatus.txt";
				Process process = null;
				String filePath ="";
				VenueUser dbUser = new LoginServiceImpl().getAdminUserByUsername(SessionHelper.getLogedInUser(request).getUserName());
				String osname = System.getProperty("os.name").toLowerCase();
				
				if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
				{
					//for sending  request to sh file
					filePath = request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";
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
					
					filePath = request.getSession().getServletContext().getRealPath("")+"\\WEB-INF\\classes\\";
					//filePath="\""+filePath+"\"";
					smartClientPath="\""+smartClientPath+"\"";
					DBBackupStatusFilePath="\""+DBBackupStatusFilePath+"\"";

					BackupLocation=BackupLocation.substring(0,BackupLocation.length()-2);
					BackupLocation="\""+BackupLocation+"\"";

					cmdList.add("cmd");
					cmdList.add("/c");
					cmdList.add("OESDBBackup.bat");
					cmdList.add(dbUser.getUserName());
					cmdList.add(passwordParse(dbUser.getPassword()));
					cmdList.add(BackupLocation);
					cmdList.add(DBBackupStatusFilePath);
					cmdList.add(smartClientPath);
					if(System.getenv("OESJAVA") != null)
						cmdList.add(System.getenv("OESJAVA"));
					else
						cmdList.add("java");
				}
				pb=new ProcessBuilder(cmdList);
				pb.directory(new File(filePath));
				//process = Runtime.getRuntime().exec(filePath +" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" "+BackupLocation+" "+DBBackupStatusFilePath+" "+smartClientPath+" "+jrePath);
				syncStreamReader(pb);		       


			}
			return "redirect:/syncDataSMC/dbBackupList";
			
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in createBackupFile: ", e);
			return null;
		}

	}
	

	/**
	 * Get method to Read DB Backup Status
	 * @param model
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "readDBBackupStatusAjax", method = RequestMethod.GET)
	@ResponseBody public String readDBBackupStatusAjax(Model model, Locale locale,HttpServletRequest request) {
		try 
		{
			//for sending  request to sh file
			String filePath = "";
			String batORsh="";
			Process process = null;
			ProcessBuilder pb=null;
			List<String> cmdList=new ArrayList<String>();
			String syncStatusLogFilePath=request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/OESFiles/DBBackupStatus.txt";
			String osname = System.getProperty("os.name").toLowerCase();
			
			if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
			{
				filePath=request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";
				batORsh="ReadDownloadStatus.sh";
				cmdList.add("sh");
			}
			else 
			{
				filePath=request.getSession().getServletContext().getRealPath("")+"\\WEB-INF\\classes\\";
				//filePath="\"" + filePath + "\"";
				syncStatusLogFilePath=syncStatusLogFilePath.replace("/", "\\");
				syncStatusLogFilePath="\"" +syncStatusLogFilePath+"\"";
				batORsh="ReadDownloadStatus.bat";
				cmdList.add("cmd");
				cmdList.add("/c");
			}
			
			
			if(new File(syncStatusLogFilePath.replace("\"", "")).exists())
			{
				
				//process = Runtime.getRuntime().exec(filePath+" "+syncStatusLogFilePath);
				cmdList.add(batORsh);
				cmdList.add(syncStatusLogFilePath);
				
				pb=new ProcessBuilder(cmdList);
				
				pb.directory(new File(filePath));
				process = pb.start();
				
				//Code to write response on view
				StringWriter op = new StringWriter();
				IOUtils.copy(process.getInputStream(), op);
				String out;
				if(!op.toString().isEmpty())
				{
					out = op.toString();
				}
				else
				{					
					IOUtils.copy(process.getErrorStream(), op);
					out = op.toString();	
				}
				return out;
			}
			return "";
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in readDBBackupStatusAjax: " ,e);
			return null;
		}
	}

	/**
	 * Get method for DB Backup List
	 * @param model
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "dbBackupListAjax", method = RequestMethod.GET)
	@ResponseBody public Map<String,String> dbBackupListAjax(Model model, String messageid, Locale locale,HttpServletRequest request) 
	{
		Map<String,String> fileNames=new LinkedHashMap<String, String>();
		try 
		{

			if (messageid != null && !messageid.equals("")) {
				addMessage(Integer.parseInt(messageid), model, locale);
			}

			String BackupLocation = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "BackupLocation");


			if(BackupLocation!=null && !BackupLocation.isEmpty())
			{
				fileNames=deleteOlderFiles(BackupLocation);
			}


		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in dbBackupList: " ,e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return null;
		}
		return fileNames;
	}
	
	/**
	 * Method to Delete Older Files
	 * @param bkpFolderPath
	 * @return Map<String,String> this returns the map of latest files
	 */
	@SuppressWarnings("unchecked")
	private Map<String,String> deleteOlderFiles(String bkpFolderPath)
	{
		try {
			File dir = new File(bkpFolderPath);
			FileFilter fileFilter = new WildcardFileFilter("*.sql");
			File[] files = dir.listFiles(fileFilter);
			String crtdate="";
			Map<String, String> latestFiles=new LinkedHashMap<String, String>();
			
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
					else
					{
						crtdate=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a").format(files[i].lastModified());
						latestFiles.put(files[i].getName(), crtdate);
						
					}
				}
				
			}
			return latestFiles;
		} catch (Exception e) {
			LOGGER.error("Exception occured in deleteOlderFiles: " ,e);
			return null;
		}
	 
	}

	/**
	 * Get method for DB Backup Restore List
	 * @param session
	 * @param model
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "dbBackupRestoreList", method = RequestMethod.GET)
	public String dbBackupRestoreList(HttpSession session,Model model, String messageid, Locale locale,HttpServletRequest request) {
		try 
		{
				String BackupLocation = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "BackupLocation");
				File dir = new File(BackupLocation);
				FileFilter fileFilter = new WildcardFileFilter("*.sql");
				File[] files = dir.listFiles(fileFilter);
				String crtdate="";
				Map<String, String> latestFiles=new LinkedHashMap<String, String>();
				//delete older files if it contains more than 5 files
				deleteOlderFiles(request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/restoreBackupFiles");
				if(files!=null && files.length>0)
				{
						Arrays.sort(files, new Comparator(){
				            public int compare(Object o1, Object o2) 
				            {
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
							crtdate=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a").format(files[i].lastModified());
							latestFiles.put(files[i].getName(), crtdate);
						}
					
					}
			model.addAttribute("fileNames", latestFiles);
		}
		catch (Exception e) {
			LOGGER.error("Exception occured in dbBackupRestoreList: " ,e);
			return null;
		}
		return "Admin/syncData/dbRestoreList";
	}
	
	/**
	 * Get method for DB Restore Task
	 * @param model
	 * @param response
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "dbRestoreTask", method = RequestMethod.GET)
	public String dbRestoreTask(Model model, HttpServletResponse response, Locale locale,HttpServletRequest request) {
		try 
		{
			
			String BackupLocation = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "BackupLocation");
			restoreDBTask(request, BackupLocation);
			return "redirect:/syncData/dbBackupRestoreList";
			
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in dbRestoreTask: ", e);
			return null;
		}

	}

	/**
	 * Method for Restore DB Task
	 * @param request
	 * @param BackupLocation
	 * @throws Exception
	 */
	private void restoreDBTask(HttpServletRequest request, String BackupLocation)
			throws Exception {
		List<String> cmdList=new ArrayList<String>();
		if(BackupLocation!=null && !BackupLocation.isEmpty())
		{
			String restorefilepath=request.getParameter("filename");
			VenueUser dbUser = new LoginServiceImpl().getAdminUserByUsername(SessionHelper.getLogedInUser(request).getUserName());
			String smartClientPath=request.getSession().getServletContext().getRealPath("")+"/OES-SmartClient/OES-SmartClient.exe";
			String DBrestoreStatusFilePath=request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/OESFiles/DBRestoreStatus.txt";
			Process process = null;
			ProcessBuilder pb=null;
			String filePath="";
			
			String osname = System.getProperty("os.name").toLowerCase();
			if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
			{
				
				//for sending  request to sh file
				filePath = request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";
				restorefilepath=BackupLocation+restorefilepath;
				//process = Runtime.getRuntime().exec(filePath +" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" "+restorefilepath+" "+DBrestoreStatusFilePath+" "+smartClientPath);
				cmdList.add("sh");
				cmdList.add("OESDBRestore.sh");
				cmdList.add(dbUser.getUserName());					
				cmdList.add(dbUser.getPassword());
				cmdList.add(restorefilepath);
				cmdList.add(DBrestoreStatusFilePath);
				cmdList.add(smartClientPath);
				
			}
			else
			{
				filePath = request.getSession().getServletContext().getRealPath("")+"\\WEB-INF\\classes\\";
				//filePath="\""+filePath+"\"";
				smartClientPath="\""+smartClientPath+"\"";
				
				BackupLocation=BackupLocation.substring(0,BackupLocation.length()-2);
				restorefilepath=BackupLocation+"\\"+restorefilepath;
				restorefilepath="\""+restorefilepath+"\"";
				
				DBrestoreStatusFilePath="\""+DBrestoreStatusFilePath+"\"";
				
				
				cmdList.add("cmd");
				cmdList.add("/c");
				cmdList.add("OESDBRestore.bat");
				cmdList.add(dbUser.getUserName());
				cmdList.add(passwordParse(dbUser.getPassword()));
				cmdList.add(restorefilepath);
				cmdList.add(DBrestoreStatusFilePath);
				cmdList.add(smartClientPath);
				if(System.getenv("OESJAVA") != null)
					cmdList.add(System.getenv("OESJAVA"));
				else
					cmdList.add("java");

			}
			pb=new ProcessBuilder(cmdList);
			pb.directory(new File(filePath));
			
			syncStreamReader(pb);
		   
		}
	}
	
	/**
	 * Get method for Read DB Restore Status 	
	 * @param model
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "readDBRestoreStatusAjax", method = RequestMethod.GET)
	@ResponseBody public String readDBRestoreStatusAjax(Model model, Locale locale,HttpServletRequest request) {
		try 
		{
			//for sending  request to sh file
			String filePath = "";
			String batORsh="";
			Process process = null;
			ProcessBuilder pb=null;
			String syncStatusLogFilePath=request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/OESFiles/DBRestoreStatus.txt";
			String osname = System.getProperty("os.name").toLowerCase();
			List<String> cmdList=new ArrayList<String>();
			
			if(new File(syncStatusLogFilePath).exists())
			{
		
				if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
				{
					filePath=request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";
					batORsh="ReadDownloadStatus.sh";
					cmdList.add("sh");
				}
				else 
				{
					filePath=request.getSession().getServletContext().getRealPath("")+"\\WEB-INF\\classes\\";
					//filePath="\"" + filePath + "\"";
					syncStatusLogFilePath=syncStatusLogFilePath.replace("/", "\\");
					syncStatusLogFilePath="\"" +syncStatusLogFilePath+"\"";
					batORsh="ReadDownloadStatus.bat";
					cmdList.add("cmd");
					cmdList.add("/c");
				}
				
				if(new File(syncStatusLogFilePath.replace("\"", "")).exists())
				{
					
					//process = Runtime.getRuntime().exec(filePath+" "+syncStatusLogFilePath);
					
					cmdList.add(batORsh);
					cmdList.add(syncStatusLogFilePath);
					pb=new ProcessBuilder(cmdList);
					pb.directory(new File(filePath));
					process = pb.start();
					
					//Code to write response on view
					StringWriter op = new StringWriter();
					IOUtils.copy(process.getInputStream(), op);
					String out;
					if(!op.toString().isEmpty())
					{
						out = op.toString();
					}
					else
					{					
						IOUtils.copy(process.getErrorStream(), op);
						out = op.toString();	
					}
					return out;
				}
			}
			return "";
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in readDBRestoreStatusAjax: " ,e);
			return null;
		}
	}
	
	/**
	 * Get method to Sync Master
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "syncMasterAjax", method = RequestMethod.GET)
	@ResponseBody public String syncMasterAjax( Locale locale,HttpServletRequest request) {
		try 
		{			
			String osname = System.getProperty("os.name").toLowerCase();
			Process process = null;
			ProcessBuilder pb=null;
			List<String> cmdList=new ArrayList<String>();
			String filePath="";
			VenueUser dbUser = new LoginServiceImpl().getAdminUserByUsername(SessionHelper.getLogedInUser(request).getUserName());
			String syncStatusLogFilePath=request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/OESFiles/syncExamDataStatus.txt";
			String smartClientPath=request.getSession().getServletContext().getRealPath("")+"/OES-SmartClient/OES-SmartClient.exe";
			
			if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
			{
				//for sending  request to sh file
				filePath = request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";				
				cmdList.add("sh");
				cmdList.add("OESMasterSync.sh");
				cmdList.add(dbUser.getUserName());				
				cmdList.add(dbUser.getPassword());
				cmdList.add(syncStatusLogFilePath);
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
					jrePath="\""+jrePath+"\"";
				}
				else 
				{
					jrePath="C:\\Program Files\\Java\\jre6\\bin\\java";
					jrePath="\""+jrePath+"\"";
				}
				filePath = request.getSession().getServletContext().getRealPath("")+"\\WEB-INF\\classes\\";
				//filePath="\"" + filePath + "\"";
				
				syncStatusLogFilePath="\""+syncStatusLogFilePath+"\"";
				smartClientPath="\""+smartClientPath+"\"";
				//process = Runtime.getRuntime().exec(filePath+" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" " + request.getParameter("examEventId")+" "+syncStatusLogFilePath+" "+smartClientPath+" "+jrePath);
				cmdList.add("cmd");
				cmdList.add("/c");
				cmdList.add("OESMasterSync.bat");
				cmdList.add(dbUser.getUserName());
				cmdList.add(passwordParse(dbUser.getPassword()));
				cmdList.add(syncStatusLogFilePath);
				cmdList.add(smartClientPath);
				cmdList.add(jrePath);
			}	
			
			pb=new ProcessBuilder(cmdList);
			
			pb.directory(new File(filePath));			
			
			syncStreamReader(pb);
	       
			return "OK";
			
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncMasterAjax: " ,e);
			return null;
		}		
	}

	/**
	 * Method for Sync Stream Reader
	 * @param pb
	 * @throws IOException
	 */
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
	
	/**
	 * Get method to fetch Exam Event List
	 * @param request
	 * @return List<ExamEvent> this return the ExamEventList
	 */
	@RequestMapping(value = "ListExamEvents.ajax", method = RequestMethod.GET)
	@ResponseBody public List<ExamEvent> ListExamEvents(HttpServletRequest request) {
		List<ExamEvent> examEventList = null;
		try {
			examEventList=new ExamEventServiceImpl().getAllExamEventList();
		} catch (Exception e) {
			LOGGER.error("Exception in ListExamEvents ajax: ", e);
			examEventList=null;
		}
		return examEventList;
	}
	
	/**
	 * Get method for Exam Event Single Candidate
	 * @param model
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "examEventSingleCandidate", method = RequestMethod.GET)
	public String examEventSingleCandidate(Model model, String messageid, Locale locale,HttpServletRequest request) {
		try 
		{
			if (messageid != null && !messageid.equals("")) {
				addMessage(Integer.parseInt(messageid), model, locale);
			}

			List<ExamEvent> examEventList=new ExamEventServiceImpl().getActiveandPublishedExamEventList();
			model.addAttribute("examEventList", examEventList);

		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in selectSyncEvent: " ,e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return Constants.ERRORPAGE;
		}

		return "Admin/syncData/candidateSync";
	}
	
	/**
	 * Get method for Sync Single Candidate
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "syncSingleCandidateAjax", method = RequestMethod.GET)
	@ResponseBody public String syncSingleCandidateAjax( Locale locale,HttpServletRequest request) {
		try 
		{
			if(request.getParameter("examEventId")!=null && !request.getParameter("examEventId").isEmpty() && request.getParameter("userName")!=null && !request.getParameter("userName").isEmpty())
			{
				String osname = System.getProperty("os.name").toLowerCase();
				Process process = null;
				ProcessBuilder pb=null;
				List<String> cmdList=new ArrayList<String>();
				String filePath="";
				VenueUser dbUser = new LoginServiceImpl().getAdminUserByUsername(SessionHelper.getLogedInUser(request).getUserName());
				String syncStatusLogFilePath=request.getSession().getServletContext().getRealPath("")+"/resources/WebFiles/OESFiles/syncExamDataStatus.txt";
				String smartClientPath=request.getSession().getServletContext().getRealPath("")+"/OES-SmartClient/OES-SmartClient.exe";
				
				if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
				{
					//for sending  request to sh file
					filePath = request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";
					//process = Runtime.getRuntime().exec(filePath +" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" " + request.getParameter("examEventId")+" "+syncStatusLogFilePath+" "+smartClientPath);
					cmdList.add("sh");
					cmdList.add("SingleCandidateSync.sh");
					cmdList.add(dbUser.getUserName());				
					cmdList.add(dbUser.getPassword());
					cmdList.add(request.getParameter("examEventId"));
					cmdList.add(syncStatusLogFilePath);
					cmdList.add(smartClientPath);
					cmdList.add(request.getParameter("userName"));
				}
				else
				{
					// for windows
					String jrePath="";
					String f="C:/Windows/SysWOW64";
					if(new File(f).exists())
					{
						jrePath="C:\\Program Files (x86)\\Java\\jre6\\bin\\java";
						jrePath="\""+jrePath+"\"";
					}
					else 
					{
						jrePath="C:\\Program Files\\Java\\jre6\\bin\\java";
						jrePath="\""+jrePath+"\"";
					}
					filePath = request.getSession().getServletContext().getRealPath("")+"\\WEB-INF\\classes\\";
					//filePath="\"" + filePath + "\"";
					
					syncStatusLogFilePath="\""+syncStatusLogFilePath+"\"";
					smartClientPath="\""+smartClientPath+"\"";
					//process = Runtime.getRuntime().exec(filePath+" "+ dbUser.getUserName()+" "+ dbUser.getPassword()+" " + request.getParameter("examEventId")+" "+syncStatusLogFilePath+" "+smartClientPath+" "+jrePath);
					cmdList.add("cmd");
					cmdList.add("/c");
					cmdList.add("SingleCandidateSync.bat");
					cmdList.add(dbUser.getUserName());
					cmdList.add(passwordParse(dbUser.getPassword()));
					cmdList.add(request.getParameter("examEventId"));
					cmdList.add(syncStatusLogFilePath);
					cmdList.add(smartClientPath);
					cmdList.add(jrePath);
					cmdList.add(request.getParameter("userName"));
				}	
				
				pb=new ProcessBuilder(cmdList);
				
				pb.directory(new File(filePath));
				syncStreamReader(pb);
				return "OK";
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncSingleCandidateAjax: " ,e);
			return null;
		}
		return "";
	}
	
		/**
		 * Method for Password Parse
		 * @param str
		 * @return String this returns an encrypted password
		 */
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
	   
	   
	   /**
	    * Post method to Upload DB Backup File
	    * @param request
	    * @param response
	    * @param bkpFile
	    * @return String this returns the uploaded file name
	    */
	   @RequestMapping(value = { "/uploadDBBkpFile" }, method = RequestMethod.POST)
		public @ResponseBody String uploadFile(HttpServletRequest request,HttpServletResponse response, @RequestParam("file") MultipartFile bkpFile) {
			try 
			{
				String physicalFolderPath=FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "manualBackupLocation");
				FileUtils.cleanDirectory(new File(physicalFolderPath));
				FileUploadHelper.uploadFileServiceWithFileName(physicalFolderPath+File.separator, bkpFile);

			} 
			catch (FileUploadException e) 
			{
				LOGGER.error("Error occourd in  upload Back up File to server: " , e);
			}
			catch (Exception e) {
				LOGGER.error("Error occourd in uploadDBBkpFile: " , e); 
			}
			return bkpFile.getOriginalFilename();
		}
	   
	   /**
	    * Get method for DB Manual Restore Task
	    * @param model
	    * @param response
	    * @param locale
	    * @param request
	    * @return String this returns the path of a view
	    */
	   @RequestMapping(value = "dbManualRestoreTask", method = RequestMethod.GET)
		public String dbManualRestoreTask(Model model, HttpServletResponse response, Locale locale,HttpServletRequest request) {
			try 
			{
				String BackupLocation = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request, "manualBackupLocation");
				restoreDBTask(request, BackupLocation);
				return "redirect:/syncData/dbBackupRestoreList";
				
			}
			catch(Exception e)
			{
				LOGGER.error("Exception occured in dbManualRestoreTask: ", e);
				return null;
			}

		}
	   
}
