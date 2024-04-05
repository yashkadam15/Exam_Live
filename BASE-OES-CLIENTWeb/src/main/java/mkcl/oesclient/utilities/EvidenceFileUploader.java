package mkcl.oesclient.utilities;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.commons.services.ExamClientServiceImpl;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;

import org.slf4j.LoggerFactory;

public class EvidenceFileUploader {

    
	private String interval;  
	private static String contextRealPath;
	private static Process process;
/*	Thread t1=null;
	Thread t2=null;*/
	
	
	  private static String  workingDir = null;
	    public static final String osname=System.getProperty("os.name").toLowerCase();
	static{
        try{
          File f = new File(EvidenceFileUploader.class.getProtectionDomain().getCodeSource().getLocation().getPath());
            if(f != null)
            {              
                workingDir = URLDecoder.decode(EvidenceFileUploader.class.getProtectionDomain().getCodeSource().getLocation().getPath().replaceFirst(f.getName(), ""), "utf-8");
                if(workingDir.startsWith("/") && osname.indexOf("win") >= 0)
                {
                    workingDir = workingDir.substring(1);
                }
                contextRealPath=workingDir.substring(0, workingDir.lastIndexOf("WEB-INF"));
            }  
            
       }
       catch(Exception ex)
       {
    	   LoggerFactory.getLogger(EvidenceFileUploader.class).error("Error in static block EvidenceFileUploade:",ex);
       }
    }
	
	public void killEvidenceFileUploader()
	{
		if(process != null && process.isAlive())
		{
			try {
				process.destroyForcibly();
			} catch (Exception e) {
				 LoggerFactory.getLogger(EvidenceFileUploader.class).error("Error in killEvidenceFileUploader method:",e);
			}
		}
	}


	public String getInterval() {
		return interval;
	}

	public void setInterval(String interval) {
		this.interval = interval;
	}

	/*private void syncStreamReader(ProcessBuilder pb) throws IOException {		
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
				 LoggerFactory.getLogger(EvidenceFileUploader.class).error("Error in reading error stream",e);
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
				   LoggerFactory.getLogger(EvidenceFileUploader.class).error("Error in reading input stream",e);
			   }
			}
		};        
		pb.redirectError(new File(contextRealPath + "resources" + File.separator + "EvidenceUploader" + File.separator + "errorStream.log"));
		pb.redirectOutput(new File(contextRealPath + "resources" + File.separator + "EvidenceUploader" + File.separator + "outStream.log"));
		process = pb.start();		

		t1 = new Thread(new errorReader(process));		
		t1.start();
		t2 = new Thread(new inputReader(process));		
		t2.start();
	}*/


	public void startEvidenceUpload() {
		String targetUrl = new ExamClientServiceImpl().getEvidenceServerURL();
		if (targetUrl != null && !targetUrl.isEmpty()) {
			targetUrl = targetUrl.concat("FileUploader/uploadEvidences");
			try {
				String osname = System.getProperty("os.name").toLowerCase();
				ProcessBuilder pb = null;
				List<String> cmdList = new ArrayList<String>();
				String uploaderPath = contextRealPath + "resources" + File.separator + "EvidenceUploader"
						+ File.separator
						+ (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0 ? "EvidenceUploader.jar"
								: "uploader.exe");

				String evidenceUploadPath = contextRealPath + "resources" + File.separator + "WebFiles" + File.separator
						+ "Evidence";

				if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) {
					String jrePath = System.getProperty("java.home") + File.separator + "bin" + File.separator + "java";

					cmdList.add(jrePath);
					cmdList.add("-jar");
					cmdList.add(uploaderPath);
					cmdList.add(targetUrl);
					cmdList.add(evidenceUploadPath);
					cmdList.add(interval);
				} else {
					uploaderPath = "\"" + uploaderPath + "\"";

					cmdList.add(uploaderPath);
					cmdList.add("\"" + targetUrl + "\"");
					cmdList.add("\"" + evidenceUploadPath + "\"");
					cmdList.add(interval);
				}
				pb = new ProcessBuilder(cmdList);
				pb.directory(new File(contextRealPath + "resources" + File.separator + "EvidenceUploader"));
				//syncStreamReader(pb);
				pb.redirectError(new File(contextRealPath + "resources" + File.separator + "EvidenceUploader" + File.separator + "errorStream.log"));
				pb.redirectOutput(new File(contextRealPath + "resources" + File.separator + "EvidenceUploader" + File.separator + "outStream.log"));
				process = pb.start();	

			} catch (Exception e) {
				LoggerFactory.getLogger(EvidenceFileUploader.class).error("Exception occured in EvidenceUpload: ", e);
			} 
		}
		
	}

	
}
