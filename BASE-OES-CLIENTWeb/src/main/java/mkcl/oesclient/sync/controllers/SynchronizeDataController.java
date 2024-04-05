package mkcl.oesclient.sync.controllers;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.sync.model.OESSyncConstants;
import mkcl.oesclient.sync.services.OESCandidateService;
import mkcl.oespcs.model.ExamEvent;

@Controller
@RequestMapping("syncData")
public class SynchronizeDataController 
{
	private static final Logger LOGGER = LoggerFactory.getLogger(SynchronizeDataController.class);

	/**
	 * Get method for Exam Event List to be Synchronized
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
	 * @return String this returns the sync message
	 */
	@RequestMapping(value = "readDownloadingStatusAjax", method = RequestMethod.GET)
	@ResponseBody public String readDownloadingStatusAjax(Model model, Locale locale,HttpServletRequest request) 
	{
		if(OESSyncConstants.syncStatus)
		{
			return OESSyncConstants.syncMsg;
		}
		else
		{
			String syncMsg=OESSyncConstants.syncMsg;
			OESSyncConstants.syncMsg="";
			return syncMsg+"^^^";
			
		}

	}
	
	/*
     * Error levels Code[In Master Sync and Full Data Sync Supported]
     * 0: Successful execution
     * 1: Generic exception which is not handled with error level
     * 2: Error in Full Data Sync
     * 3: Error in Master Data sync
     * 4: Connection Check failed.No valid OES Url found
     * 5: InValid User or blank required data
     * 6: Security Certificate Issues/Internet Issue/Connection Issue                 
     */
	/**
	 * Get method to Sync Master		
	 * @param locale
	 * @param request
	 */
	@RequestMapping(value = "syncMasterAjax", method = RequestMethod.GET)
	@ResponseBody public void syncMasterAjax( Locale locale,HttpServletRequest request) {
		try 
		{	
			OESSyncConstants.syncStatus=true;	
			SyncMasterData(request);                        

			//return "OK";
			
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncMasterAjax: " ,e);
			//return null;
		}
		finally{
			OESSyncConstants.syncStatus=false;
		}
	}

	/**
	 * Method to Sync Master Data
	 * @param request
	 * @throws IOException
	 */
	public void SyncMasterData(HttpServletRequest request) throws Exception 
	{
			
		OESSyncConstants.errorLevel=1;
		OESSyncConstants.currentTask = "1/3 Establishing connection with server ";
		OESSyncConstants.progressBarPercentage = 5;
		OESSyncConstants.esbConnectionStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus;
		
		
		ServerConnectionCheckHelper serverConnectionCheckHelper=new ServerConnectionCheckHelper();
		int iConnectStatus = serverConnectionCheckHelper.checkConnectionToESB();
		boolean masterSaved=true;
		 if (iConnectStatus == 0) {
			 OESSyncConstants.progressBarPercentage = 100;
			 OESSyncConstants.esbConnectionStatus=OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
			 OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus;
			 
			/* OESSyncConstants.syncMsg+="\n Connection established successfully.";*/
			 OESSyncConstants.currentTask = "<br>2/3 Downloading Master Data ";
			 OESSyncConstants.progressBarPercentage = 0;
			 OESSyncConstants.downloadMasterDataStatus = OESSyncConstants.currentTask + OESSyncConstants.progressBarPercentage+"%";
			 OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.downloadMasterDataStatus;
			 masterSaved=new SynchronizeMasterData().synchronizeMasterData(request); 

		   if(masterSaved)
		   {
			   OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
			   OESSyncConstants.syncMsg+="\n <b>Please select \"Exam Event\" to synchronize exam data.</b>";
			   OESSyncConstants.errorLevel=0;
			   request.setAttribute("finalStatus", true);
		   }
		   else
		   {
			   OESSyncConstants.syncMsg+="\n Error while synchronizing master data. Try again later.";
			   OESSyncConstants.errorLevel=3;
		   }                               
		 }
		 else if(iConnectStatus==-1) {
			// OES-CLient and central server is not synched
			 OESSyncConstants.syncMsg+="\n Time of OES-Client and central server is not synched up.";
		 }
		 else if(iConnectStatus==-2) {
			 OESSyncConstants.syncMsg+="\n Time of OES-Client Database and central server is not synched up.";
		 }
		 else if(iConnectStatus==1)
		 {
		     OESSyncConstants.syncMsg+="\n Error in establishing connection! Securities Certificates not found.";
		     masterSaved=false;
		     OESSyncConstants.errorLevel=6;
		 }
		 else if(iConnectStatus==2)
		 {
			 OESSyncConstants.syncMsg+="\n Please verify that you are connected to Internet.";
		     masterSaved=false;
		     OESSyncConstants.errorLevel=6;
		 }
		 else if(iConnectStatus==3)
		 {
			 OESSyncConstants.syncMsg+="\n Error in establishing connection!";
		     masterSaved=false;
		     OESSyncConstants.errorLevel=6;
		 }
		 else if(iConnectStatus==-1)
		 {
			 OESSyncConstants.syncMsg+="\n Error in establishing connection!";
		     masterSaved=false;
		     OESSyncConstants.errorLevel=6;
		 }
		 else if(iConnectStatus==-2)
		 {
			 OESSyncConstants.syncMsg+="\n Error in establishing connection!";
		     masterSaved=false;
		     OESSyncConstants.errorLevel=6;
		 }
	}

	/**
	 * Get method to Sync Master Data
	 * @param locale
	 * @param request
	 * @return String this returns the sync status
	 */
	@RequestMapping(value = "syncExamDataAjax", method = RequestMethod.GET)
	@ResponseBody public String syncExamDataAjax( Locale locale,HttpServletRequest request) {
		try 
		{
			OESSyncConstants.errorLevel=1;
			if(request.getParameter("examEventId")!=null && !request.getParameter("examEventId").isEmpty())
			{
				/* OESSyncConstants.syncMsg+="****************************************************************************************";
				 OESSyncConstants.syncMsg+="\n\t\tProcess Started...";
				 OESSyncConstants.syncMsg+="\n****************************************************************************************";
				*/
				 OESSyncConstants.syncStatus=true;
				 ExamEvent examEvent=new OESCandidateService().getExamEventByID(Long.parseLong(request.getParameter("examEventId")));
                 if(examEvent!=null)
                 {
                	 OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
                	 OESSyncConstants.syncMsg+="\nSELECTED EXAM EVENT: "+examEvent.getName().toUpperCase();
                	 OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
                 }
				
				if(fullDataSynchronization(request.getParameter("examEventId"),request, null))
                {                       
					OESSyncConstants.syncMsg+="\n****************************************************************************************";
					OESSyncConstants.syncMsg+="\n\tData Synchronization Process Completed";
					OESSyncConstants.syncMsg+="\n****************************************************************************************";
					OESSyncConstants.errorLevel=0;
                }
                else
                {
                	OESSyncConstants.syncMsg+="\n****************************************************************************************";
                	OESSyncConstants.syncMsg+="\n\tData Synchronization Process Failed";  
                	OESSyncConstants.syncMsg+="\n****************************************************************************************";
                	OESSyncConstants.errorLevel=2;
                }
				
			}
			return "OK";
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncExamData: " ,e);
			return null;
		}
		finally{
			OESSyncConstants.syncStatus=false;
		}

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
	 * Get method to Sync Single Candidate
	 * @param locale
	 * @param request
	 * @return String this returns the sync status
	 */
	@RequestMapping(value = "syncSingleCandidateAjax", method = RequestMethod.GET)
	@ResponseBody public String syncSingleCandidateAjax( Locale locale,HttpServletRequest request)  {
		try 
		{
			
			if(request.getParameter("examEventId")!=null && !request.getParameter("examEventId").isEmpty() && request.getParameter("userName")!=null && !request.getParameter("userName").isEmpty())
			{
				/*OESSyncConstants.syncMsg+="****************************************************************************************";
				OESSyncConstants.syncMsg+="\n\t\tProcess Started...";
				OESSyncConstants.syncMsg+="\n****************************************************************************************";
				*/
				ExamEvent examEvent=new OESCandidateService().getExamEventByID(Long.parseLong(request.getParameter("examEventId")));
                if(examEvent!=null)
                {
                   //System.out.println("----------------------------------------------------------------------------------------");
                	/*OESSyncConstants.syncMsg+="\nSELECTED EXAM EVENT: "+examEvent.getName().toUpperCase();
                	OESSyncConstants.syncMsg+="\nENTERED USER NAME: "+request.getParameter("userName");
                	OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";*/
                }
				OESSyncConstants.syncStatus=true;
				if(new SynchronizeSingleCandidateData().synchronizeSingleCandidateData(request.getParameter("examEventId"),request.getParameter("userName"),request))
	            {    
					OESSyncConstants.syncMsg+="\n****************************************************************************************";
					OESSyncConstants.syncMsg+="\n \tData Synchronization Process Completed";
					OESSyncConstants.syncMsg+="\n****************************************************************************************";
					OESSyncConstants.errorLevel=0;
	            }
	            else
	            {
	            	OESSyncConstants.syncMsg+="\n****************************************************************************************";
	            	OESSyncConstants.syncMsg+="\n \tData Synchronization Process Failed";  
	            	OESSyncConstants.syncMsg+="\n****************************************************************************************";
	            	OESSyncConstants.errorLevel=5;
	            }
			}
			return "OK";
			
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncExamData: " ,e);
			return null;
		}
		finally{
			OESSyncConstants.syncStatus=false;
		}

	}
	
	
	/**
	 * Method for Full Data Synchronization (Exam Event as well as Candidate data) 
	 * @param eventId
	 * @param request
	 * @return boolean this returns true on success
	 * @throws Exception
	 */
	public boolean fullDataSynchronization(String eventId,HttpServletRequest request, String url ) throws Exception {
        boolean isDataSyncedSuccessfully = false;
        int completeProcessCount = 0;
        if(url != null) {
        	completeProcessCount = 5;
        }
        else {
        	completeProcessCount = 6;
        }
        OESSyncConstants.currentTask = "1/"+completeProcessCount+" Establishing connection with server ";
		OESSyncConstants.progressBarPercentage = 5;
		OESSyncConstants.esbConnectionStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus;
		
        ServerConnectionCheckHelper serverConnectionCheckHelper = new ServerConnectionCheckHelper();

        int iConnectStatus = serverConnectionCheckHelper.checkConnectionToESB();

        if (iConnectStatus == 0) 
        {
        	OESSyncConstants.progressBarPercentage = OESSyncConstants.SUCCESSFULL_COMPLETION_PER;
    		OESSyncConstants.esbConnectionStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
    		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus;
        	
    		//OESSyncConstants.syncMsg+="\n Connection established successfully.";
            SynchronizeEventData synchronizeEventDataObj = new SynchronizeEventData(request);
            boolean eventSaved = synchronizeEventDataObj.synchronizeExamEventData(eventId, completeProcessCount);
            if (eventSaved && url == null) 
            {
	            	isDataSyncedSuccessfully = true;
	            	OESSyncConstants.currentTask = "<br>6/"+completeProcessCount+" Candidate Data Synchronization ";
	          		OESSyncConstants.progressBarPercentage = 0;
	          		OESSyncConstants.candidateDownloadStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"%";
	          		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus+OESSyncConstants.verifyingDataIntegrityStatus+OESSyncConstants.candidateDownloadStatus;
	          
	            	SynchronizeCandidateData synchronizeCandidateDataObj = new SynchronizeCandidateData();
	                if (synchronizeCandidateDataObj.synchronizeCandidateData(eventId,request)) 
	                {
	                    isDataSyncedSuccessfully = true;
	                    callrSync(request);
	                    OESSyncConstants.progressBarPercentage = OESSyncConstants.SUCCESSFULL_COMPLETION_PERCENTAGE;
	              		OESSyncConstants.candidateDownloadStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
	              		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus+OESSyncConstants.verifyingDataIntegrityStatus+OESSyncConstants.candidateDownloadStatus;
	              		
	                } 
	                else 
	                {
	                    isDataSyncedSuccessfully = false;
	                }
              
            } 
            else 
            {
            	if(eventSaved)
            	{
            		isDataSyncedSuccessfully = true;
            	}
            	else
            	{
            		isDataSyncedSuccessfully = false;
            	}
            } 
        } 
        else if (iConnectStatus == 1) 
        {
        	OESSyncConstants.syncMsg+="\n Error in establishing connection! Securities Certificates not found.";
            isDataSyncedSuccessfully = false;
        } else if (iConnectStatus == 2) {
        	OESSyncConstants.syncMsg+="\n Please verify that you are connected to Internet.";
            isDataSyncedSuccessfully = false;
        } else if (iConnectStatus == 3) {
        	OESSyncConstants.syncMsg+="\n Error in establishing connection!";
            isDataSyncedSuccessfully = false;
        }
        return isDataSyncedSuccessfully;
    }
	   
	/**
	 * Get method to fetch Exam Event List
	 * @param request
	 * @return List<ExamEvent> this returns the Exam Event List
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
	 * Method to invoke rSync
	 * @param request
	 */
	public void callrSync(HttpServletRequest request) {
		try 
		{
			ProcessBuilder pb=null;
			Process process = null;
			String filePath =null;
			String shfile="";
			
			String osname = System.getProperty("os.name").toLowerCase();
			
			List<String> cmdList=new ArrayList<String>();
			if (osname.indexOf("nux") >= 0 || osname.indexOf("nix") >= 0) 
			{
				filePath=request.getSession().getServletContext().getRealPath("")+"/WEB-INF/classes/";
				shfile="rSync.sh";
				cmdList.add("sh");
				File file=new File(filePath+shfile);
				if(file.exists() && file.length()>0l)
				{
					cmdList.add(shfile);
					pb=new ProcessBuilder(cmdList);
					
					pb.directory(file.getParentFile());
					OESSyncConstants.syncMsg+="\n \n Image rSync process is started in backgroud.";
					process = pb.start();
					//Code to write response on view
					StringWriter op = new StringWriter();
					IOUtils.copy(process.getInputStream(), op);
	
					if(!op.toString().isEmpty())
					{
						op.toString();
					}
					else
					{					
						IOUtils.copy(process.getErrorStream(), op);
						op.toString();	
					}
					
					
				}
			}


		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in rSync: " ,e);
		}
	}
	
	   /*@RequestMapping(value = "/getSyncProgress", method = RequestMethod.GET)
	    public @ResponseBody
	    String getProgress() {
		   String response = OESSyncConstants.currentTaskType+" | "+OESSyncConstants.processingData;
		   return response;
	    }*/
	
}
