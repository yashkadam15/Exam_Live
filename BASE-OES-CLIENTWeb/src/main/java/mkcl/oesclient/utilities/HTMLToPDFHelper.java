package mkcl.oesclient.utilities;
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.AgeFileFilter;
import org.apache.commons.lang.time.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import mkcl.oesclient.commons.utilities.MKCLUtility;


public class HTMLToPDFHelper {

	private static final Logger LOGGER = LoggerFactory.getLogger(HTMLToPDFHelper.class);
	
	private static int noOfPDFExportsGoingOn=0;
	private int noOfPDFExportLimit;
	//private String rootPath=null;
	public HTMLToPDFHelper(){
		Properties properties=MKCLUtility.loadMKCLPropertiesFile();
		noOfPDFExportLimit=Integer.parseInt(properties.get("noOfPDFExportLimit").toString());
		//rootPath = properties.getProperty("rootPath");
	}
	/**
	 * 
	 * @param listCmd : All arguments in sequence except .exe path,--quiet, --lowquality, --image-dpi, 100, --image-quality, 20 and outputPDFFilePath
	 * @param fileName : only filename including extension 
	 * @return
	 * @throws ArrayIndexOutOfBoundsException
	 * @throws Exception
	 */
	public String generateHTMLToPDF(List<String> listCmd,String fileName) throws ArrayIndexOutOfBoundsException,Exception{
		String targetFolderPath = null;
		String outputPDFFilePath="";
		String externalCSSFolderPath=null;
		String externalCSSFilePath="";
		Properties properties=null;
		File file = null;
		List<String> finalcmdList=null;
		try 
		{
			
			if(noOfPDFExportsGoingOn<noOfPDFExportLimit)
			{
				properties=MKCLUtility.loadMKCLPropertiesFile();
				targetFolderPath = properties.getProperty("HTMLToPDFtargetFolderPath");
				outputPDFFilePath=System.getProperty("OESrootPath")+targetFolderPath+File.separator+fileName;
				//outputPDFFilePath=rootPath+targetFolderPath+File.separator+fileName; //Piyusha
				//LOGGER.error("outputPDFFilePath :"+outputPDFFilePath);
				externalCSSFolderPath= properties.getProperty("styleFolderPath");
				externalCSSFilePath=System.getProperty("OESrootPath")+externalCSSFolderPath+File.separator+"wkhtmltopdfFontFamily.css";
				//externalCSSFilePath=rootPath+externalCSSFolderPath+File.separator+"wkhtmltopdfFontFamily.css";//Piyusha
				deleteOldFiles(System.getProperty("OESrootPath")+targetFolderPath);
				//deleteOldFiles(rootPath+targetFolderPath);//Piyusha
				finalcmdList=new ArrayList<String>();
				finalcmdList.add((String) properties.get("wkhtmltopdfPath"));
				//--quiet --lowquality --image-dpi 100 --image-quality 20
				finalcmdList.add("--user-style-sheet");
				finalcmdList.add(externalCSSFilePath);
				finalcmdList.add("--quiet");
				finalcmdList.add("--lowquality");
				finalcmdList.add("--image-dpi");
				finalcmdList.add("100");
				finalcmdList.add("--image-quality");
				finalcmdList.add("20");
				finalcmdList.addAll(listCmd);
				finalcmdList.add(outputPDFFilePath);
	
				ProcessBuilder pb=new ProcessBuilder(finalcmdList);
				noOfPDFExportsGoingOn++;
				syncStreamReader(pb);
				noOfPDFExportsGoingOn--;
				properties=null;

				file = new File(outputPDFFilePath);
				if(!file.exists())
				{
					LOGGER.error("file not exists on target Location.");
					return null;
				}
				else
				{
					LOGGER.error("file exists on target Location.");
					return (targetFolderPath+"/"+fileName);
				}
				
			}
			else
			{
				throw new ArrayIndexOutOfBoundsException("Maximum concurrent PDF file generation limit is reached");
			}
			

		} catch (Exception e) 
		{
			noOfPDFExportsGoingOn--;
			LOGGER.error("Exception occured in generateHTMLToPDF1: ", e);
			file = new File(outputPDFFilePath);
			if(file.exists())
			{
				file.delete();
			}
			throw e;
		}
		
	}

	/**
	 * 
	 * @param listCmd : All arguments in sequence except .exe path,--quiet, --lowquality, --image-dpi, 100, --image-quality, 20, targetFolderPath & fileName
	 * @param targetFolderPath : Give the full physical path of output Folder.
	 * @param fileName : only filename including extension 
	 * @return
	 * @throws ArrayIndexOutOfBoundsException
	 * @throws Exception
	 */
	public String generateHTMLToPDF(List<String> listCmd,String targetFolderPath,String fileName) throws ArrayIndexOutOfBoundsException,Exception{
		String externalCSSFolderPath=null;
		String externalCSSFilePath="";
		String outputPDFFilePath="";
		File file = null;
		List<String> finalcmdList=null;
		Properties properties=null;
		try 
		{
			if(noOfPDFExportsGoingOn<noOfPDFExportLimit)
			{
				outputPDFFilePath=targetFolderPath+File.separator+fileName;
				LOGGER.error("outputPDFFilePath :"+outputPDFFilePath);
				properties=MKCLUtility.loadMKCLPropertiesFile();
				externalCSSFolderPath= properties.getProperty("styleFolderPath");
				externalCSSFilePath=System.getProperty("OESrootPath")+externalCSSFolderPath+File.separator+"wkhtmltopdfFontFamily.css";
				//externalCSSFilePath=rootPath+externalCSSFolderPath+File.separator+"wkhtmltopdfFontFamily.css"; //Piyusha
				finalcmdList=new ArrayList<String>();
				finalcmdList.add((String) properties.get("wkhtmltopdfPath"));
				//--quiet --lowquality --image-dpi 100 --image-quality 20
				finalcmdList.add("--user-style-sheet");
				finalcmdList.add(externalCSSFilePath);
				finalcmdList.add("--quiet");
				finalcmdList.add("--lowquality");
				finalcmdList.add("--image-dpi");
				finalcmdList.add("100");
				finalcmdList.add("--image-quality");
				finalcmdList.add("20");
				finalcmdList.addAll(listCmd);
				finalcmdList.add(outputPDFFilePath);
				
				ProcessBuilder pb=new ProcessBuilder(finalcmdList);
				noOfPDFExportsGoingOn++;
				syncStreamReader(pb);
				noOfPDFExportsGoingOn--;
				properties=null;
				file = new File(outputPDFFilePath);
				if(!file.exists())
				{
					LOGGER.error("file not exists on target Location.");
					return null;
				}
				else
				{
					LOGGER.error("file exists on target Location.");
					return fileName;
				}
				
			}
			else
			{
				throw new ArrayIndexOutOfBoundsException("Maximum concurrent PDF file generation limit is reached");
			}
			

		} catch (Exception e) 
		{
			noOfPDFExportsGoingOn--;
			LOGGER.error("Exception occured in generateHTMLToPDF2: ", e);
			file = new File(outputPDFFilePath);
			if(file.exists())
			{
				file.delete();
			}
			throw e;
		}
		
	}
	
	private void syncStreamReader(ProcessBuilder pb) throws Exception, InterruptedException {
		//LOGGER.error("-----Inside syncStreamReader----");
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
				// LOGGER.error("-----Inside errorReader run()----");
				InputStream es = p.getErrorStream();
		        InputStreamReader esr = new InputStreamReader(es);
		        BufferedReader ebr = new BufferedReader(esr);
		        String i=null;
		        LOGGER.error("-----From ErrorStream----");
		        while ( (i= ebr.readLine()) != null) {
		        	LOGGER.error(i);
		        }
		        LOGGER.error("-----From ErrorStream----");
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
				//LOGGER.error("-----Inside inputReader run()----");   
				InputStream is = p.getInputStream();
		        InputStreamReader isr = new InputStreamReader(is);
		        BufferedReader br = new BufferedReader(isr);
		        String i=null;
		        LOGGER.error("-----From InputStream----");
		        while ( (i= br.readLine()) != null) {
		          //System.out.println(i);
		         
		          LOGGER.error(i);
		          
		        }				  
		        LOGGER.error("-----From InputStream----");
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
		//LOGGER.error("-----Before pb.start()----");
		process = pb.start();	      
		//LOGGER.error("-----After pb.start()----");
		new Thread(new errorReader(process)).start();
		//LOGGER.error("-----After new errorReader(process)----");
		new Thread(new inputReader(process)).start();
		//LOGGER.error("-----After new inputReader(process)----");
		process.waitFor();
		if(process.exitValue() == 1)
			throw new Exception("request(s) did not return HTTP 200");
	}
	
	public void deleteOldFiles(String path) 
	{
	    try {
			if(new File(path).isDirectory())
			{
				Date oldestAllowedFileDate = DateUtils.addDays(new Date(), -2); //minus days from current date
			    File targetDir = new File(path);
			    Iterator<File> filesToDelete = FileUtils.iterateFiles(targetDir, new AgeFileFilter(oldestAllowedFileDate), null);
			    //if deleting subdirs, replace null above with TrueFileFilter.INSTANCE
			    while (filesToDelete.hasNext()) {
			        filesToDelete.next().delete();
			    }  //I don't want an exception if a file is not deleted. Otherwise use filesToDelete.next().delete() in a try/catch
			}
		} catch (Exception e) {
			LOGGER.error("Exception in deleteOldFiles",e);
			
		}
	}
	
//	public String makeFullURL(HttpServletRequest request,String relativePath) {
//		// set to default path to null Text
//		String fullURL = "null";
//		try {
//			String url = request.getScheme() + "://"+ request.getServerName() + ":"+ request.getLocalPort() + request.getContextPath();
//			/*imageFullPath = url + "/exam/displayImage?disImg=" + imageName;*/
//			fullURL = url + relativePath;
//
//		} catch (Exception e) {
//			LOGGER.error("Exception occured in getQOImagePath: ", e);
//		}
//		return fullURL; 
//	}
	
	
	public String makeFullURL(HttpServletRequest request,String relativePath) {
		StringBuilder fullURL = new StringBuilder();
		try {
			fullURL.append(ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString()).append(relativePath);			
		} catch (Exception e) {
			LOGGER.error("Exception occured in makeFullURL: ", e);
		}
		return fullURL.toString(); 
	}
}
