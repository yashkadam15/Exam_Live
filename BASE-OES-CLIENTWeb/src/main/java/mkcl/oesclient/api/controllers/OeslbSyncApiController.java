package mkcl.oesclient.api.controllers;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.MessageSource;
import org.springframework.context.support.DelegatingMessageSource;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import mkcl.baseoesclient.model.ExamEventLB;
import mkcl.baseoesclient.model.ExamVenueURLMappingLB;
import mkcl.baseoesclient.model.SynchronizeDataViewModel;
import mkcl.oesclient.admin.services.AdminDashboardServiceImpl;
import mkcl.oesclient.admin.services.ExamEventClosureServicesImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.sync.controllers.ServerConnectionCheckHelper;
import mkcl.oesclient.sync.controllers.SynchronizeCandidateData;
import mkcl.oesclient.sync.controllers.SynchronizeDataController;
import mkcl.oesclient.sync.controllers.SynchronizeEventData;
import mkcl.oesclient.sync.model.OESSyncConstants;
import mkcl.oesclient.sync.services.OESCandidateService;
import mkcl.oesclient.sync.services.OESEventService;
import mkcl.oesclient.uploader.CandidateExamDataUploader;
import mkcl.oesclient.utilities.EvidenceFileUploader;
import mkcl.oesclient.viewmodel.ExamStatusViewModel;
import mkcl.oesclient.viewmodel.ExamVenueActivationViewModel;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamVenue;

@CrossOrigin(origins = "*", allowedHeaders = "*",methods = {RequestMethod.GET, RequestMethod.POST})
@RestController
@RequestMapping("SyncApi")
public class OeslbSyncApiController implements ApplicationContextAware {
	

	ReloadableResourceBundleMessageSource r = null;
	EvidenceFileUploader uploader = null; 
	
	// success
	private static final int UPLOAD_SUCCESS = 2;
	// error occure
	private static final int UPLOAD_FAILED = 3;
	// no data to upload
	private static final int NO_DATA_to_UPLOAD = 4;
	// server is not responding
	private static final int SERVER_NOT_RESPONDING = 5;
	
	private static final int UPLOAD_ALREDY_IN_PROGRESS = 6;
	private static final int AUTO_UPLOAD_DISABLED = 7;
	
	@Autowired
	private AppInfoHelper appInfo;
	
	@Autowired
	public ServletContext sc;
	
	@Autowired
	private SynchronizeDataController syncCont;
	private static final Logger LOGGER = LoggerFactory.getLogger(OeslbSyncApiController.class);
	
	// @RequestMapping(value = "/syncEventData", method = RequestMethod.POST)
	/**
	 * Post method for Server Status
	 * @param examVenueURLMapping
	 * @param request
	 * @return ResponseEntity<ExamVenueURLMappingLB> this returns the http response status of exam venue URL mapping 
	 */
	@PostMapping("/serverStatus")
	public ResponseEntity<ExamVenueURLMappingLB> serverStatus(@RequestBody ExamVenueURLMappingLB examVenueURLMapping, HttpServletRequest request) {

		try
		{		
			return new ResponseEntity<ExamVenueURLMappingLB>(examVenueURLMapping, HttpStatus.OK);
		}
		catch (Exception e) 
		{
			LOGGER.error("Error in serverStatus:", e);
			return new ResponseEntity<ExamVenueURLMappingLB>(examVenueURLMapping,HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	/**
	 * Get method for Upload All Data
	 * @param model
	 * @param request
	 * @return ResponseEntity<?> this returns the http response status
	 */
	@PostMapping(value = "/examEventClosure")
	public ResponseEntity<ExamStatusViewModel> examEventClosure(@RequestBody ExamStatusViewModel examEventPD, HttpServletRequest request) {
		CandidateExamServiceImpl candidateExamServiceImpl=new CandidateExamServiceImpl();
		AdminDashboardServiceImpl adminDashboardServiceImpl=new AdminDashboardServiceImpl();
		ExamEventClosureServicesImpl eventClosureServicesImpl = new ExamEventClosureServicesImpl();
		int cnt=0;
		ExamStatusViewModel examStatus = new ExamStatusViewModel();
		try 
		{	
			List<CandidateExam> incompleteExamList=null;	


			if(examEventPD.getExamEventID()>0)
			{	
				//check is selected examevent Expired
				if(eventClosureServicesImpl.checkExamEventExpired(examEventPD.getExamEventID())) 
				{

					//call to get candidates having exams in incomplete mode
					if(examEventPD.getPaperID()>0 )
					{
						incompleteExamList=eventClosureServicesImpl.getEventPaperWiseIncompleteExamsList(examEventPD.getExamEventID(), examEventPD.getPaperID());	
					}
					else {
						incompleteExamList=eventClosureServicesImpl.getEventEventWiseIncompleteExamsList(examEventPD.getExamEventID());

					}

					if(incompleteExamList!=null && incompleteExamList.size()>0) {
						for (CandidateExam candidateExam : incompleteExamList) {

							if(candidateExamServiceImpl.getMarksObtainedandUpdateExamScore(candidateExam.getCandidateExamID()))
							{
								cnt++;								
							}
						}					
					}
					
					List<ExamStatusViewModel> examStatusViewMdellist=adminDashboardServiceImpl.getExamStatusByEventID(examEventPD.getExamEventID(),examEventPD.getPaperID());
					if(examStatusViewMdellist!=null && examStatusViewMdellist.size()>0) {
						examStatus.setExamEventID(examStatusViewMdellist.get(0).getExamEventID());
						examStatus.setExamEventName(examStatusViewMdellist.get(0).getExamEventName());
						examStatus.setPaperID(examStatusViewMdellist.get(0).getPaperID());
						examStatus.setPaperName(examStatusViewMdellist.get(0).getPaperName());
						examStatus.setIncompletedExamsMarkedAsCompleted(cnt);
						for (ExamStatusViewModel examStatusViewModel : examStatusViewMdellist) {

							examStatus.setIncompleteExamCount(examStatus.getIncompleteExamCount()+examStatusViewModel.getIncompleteExamCount());
							examStatus.setUploadedExamCount(examStatus.getUploadedExamCount()+examStatusViewModel.getUploadedExamCount());
							examStatus.setNotUploadedExamCount(examStatus.getNotUploadedExamCount()+examStatusViewModel.getNotUploadedExamCount());
							examStatus.setTotalCandidates(examStatus.getTotalCandidates()+examStatusViewModel.getTotalCandidates());
							examStatus.setNotAppearedCandidates(examStatus.getNotAppearedCandidates()+examStatusViewModel.getNotAppearedCandidates());

						}
						
					}
					
				}

			} else {
				return new ResponseEntity<ExamStatusViewModel>(examStatus, HttpStatus.UNAUTHORIZED);
			}	
			

		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncMasterData: " ,e);
			return new ResponseEntity<ExamStatusViewModel>(examStatus, HttpStatus.INTERNAL_SERVER_ERROR);
		}		
		return new ResponseEntity<ExamStatusViewModel>(examStatus, HttpStatus.OK);
	}
	
	@RequestMapping(value = { "/uploadAllData" }, method = RequestMethod.GET)
	public ResponseEntity<?> performUpload(Model model, HttpServletRequest request) 
	{
		try
		{
			int result = CandidateExamDataUploader.uploadAllData();
			String uploadResponse = null;
			switch(result){
			case UPLOAD_SUCCESS:uploadResponse = "UPLOAD SUCCESS";
			break;
			
			case UPLOAD_FAILED:uploadResponse = "UPLOAD FAILED";
			break;
			
			case NO_DATA_to_UPLOAD:uploadResponse = "NO DATA to UPLOAD";
			break;
			
			case SERVER_NOT_RESPONDING:uploadResponse = "SERVER NOT RESPONDING";
			break;
			
			case UPLOAD_ALREDY_IN_PROGRESS:uploadResponse = "UPLOAD ALREDY IN PROGRESS";
			break;
			
			case AUTO_UPLOAD_DISABLED:uploadResponse = "AUTO UPLOAD DISABLED";
			break;
			
			default : LOGGER.error("No response");
			
			break;
			
			}
			
			
			return new ResponseEntity<String>(uploadResponse, HttpStatus.OK);	
		}
		catch(Exception e)
		{
			LOGGER.error("",e);
			return new ResponseEntity<Error>(new Error("Some exception is occured"),HttpStatus.INTERNAL_SERVER_ERROR);
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
	 * Method to Sync Master Data
	 * @param syncData
	 * @param request
	 * Error levels Code[In Master Sync and Full Data Sync Supported]
     * 0: Successful execution
     * 1: Generic exception which is not handled with error level
     * 2: Error in Full Data Sync
     * 3: Error in Master Data sync
     * 4: Connection Check failed.No valid OES Url found
     * 5: InValid User or blank required data
     * 6: Security Certificate Issues/Internet Issue/Connection Issue   
	 * @return ResponseEntity<SynchronizeDataViewModel> this returns the http response status of synchronize data
	 */
	@PostMapping(value = "syncMasterData")
	public ResponseEntity<SynchronizeDataViewModel> syncMasterData(@RequestBody SynchronizeDataViewModel syncData, HttpServletRequest request) {
		SynchronizeDataViewModel synchronizeData = new SynchronizeDataViewModel();
		try 
		{	
			ExamVenue examVenueDB = new OESCandidateService().getExamVenue();
			/*OESSyncConstants.syncMsg="";*/
			if(syncData.getExamVenueID() != null && examVenueDB != null && Long.toString(examVenueDB.getExamVenueID()).equals(syncData.getExamVenueID())) 
			{
				SynchronizeEventData.resetSyncMsg();
				synchronizeData.setExamEventID("0");
				synchronizeData.setExamVenueID(syncData.getExamVenueID());
				synchronizeData.setExamVenueUrl(syncData.getExamVenueUrl());
				String eventVenue = "Exam Venue : \"" +examVenueDB.getExamVenueCode()+ "\", ";
				OESSyncConstants.syncStatus=true;
				request.setAttribute("finalStatus", false);
				
				syncCont.SyncMasterData(request);  
				
				synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
				if((Boolean) request.getAttribute("finalStatus"))
				{
					synchronizeData.setSyncStatus("Success");
					return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.OK);
				}
				OESSyncConstants.syncMsg+="\n "+eventVenue+" Master(s) Data synchronization Failed.";
				synchronizeData.setSyncStatus("Failed");
			}
			else
			{
				OESSyncConstants.syncMsg+="\n\t Master(s) Data synchronization Process Failed, Invalid VenueID"; 
				synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
				synchronizeData.setSyncStatus("Failed");
				return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncMasterData: " ,e);
			return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		finally{
			OESSyncConstants.syncStatus=false;
		}
		return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.INTERNAL_SERVER_ERROR);
	}

	/**
	 * Post Method to Sync Exam Event Data
	 * @param syncData
	 * @param request
	 * @return ResponseEntity<SynchronizeDataViewModel> this returns the http response status of synchronize data 
	 */
	@PostMapping(value = "syncExamEventData")
	public ResponseEntity<SynchronizeDataViewModel> syncExamEventData(@RequestBody SynchronizeDataViewModel syncData, HttpServletRequest request) {
		SynchronizeDataViewModel synchronizeData = new SynchronizeDataViewModel();
		try 
		{
			ExamEvent examEventDB=null;
			ExamVenue examVenueDB=null;
			if(syncData.getExamEventID() != null) {
				examEventDB = new ExamEventServiceImpl().getExamEventByID(Long.parseLong(syncData.getExamEventID()));
				examVenueDB = new OESCandidateService().getExamVenue();
			}
			/*OESSyncConstants.syncMsg="";*/
			if(examEventDB != null && examVenueDB != null && Long.toString(examEventDB.getExamEventID()).equals(syncData.getExamEventID()) && Long.toString(examVenueDB.getExamVenueID()).equals(syncData.getExamVenueID())) 
			{
				SynchronizeEventData.resetSyncMsg();
				boolean finalStatus = false;
				synchronizeData.setExamEventID(syncData.getExamEventID());
				synchronizeData.setExamVenueID(syncData.getExamVenueID());
				synchronizeData.setExamVenueUrl(syncData.getExamVenueUrl());
				String eventName = "Exam Event : \"" +examEventDB.getName().toUpperCase()+ "\", ";
				OESSyncConstants.syncStatus=true;
				ExamEvent examEventDetails = new OESCandidateService().getExamEventByID(examEventDB.getExamEventID());
				OESSyncConstants.errorLevel=1;

				OESSyncConstants.syncMsg+="****************************************************************************************";
				OESSyncConstants.syncMsg+="\n\t\t"+eventName+" Process Started...";
				finalStatus = syncCont.fullDataSynchronization(Long.toString(examEventDetails.getExamEventID()),request, synchronizeData.getExamVenueUrl());
				if(finalStatus)
				{
					OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
					OESSyncConstants.syncMsg+="\n\t"+eventName+"Data Synchronization Process Completed";
					OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
					OESSyncConstants.errorLevel=0;
				}
				else
				{
					OESSyncConstants.syncMsg+="\n\t"+eventName+"Data Synchronization Process Failed";  
					OESSyncConstants.errorLevel=2;
				}
				
				synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
				if(finalStatus)
				{
					synchronizeData.setSyncStatus("Success");
					return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.OK);
				}
				synchronizeData.setSyncStatus("Failed");
			}
			else
			{
				OESSyncConstants.syncMsg+="\n\t Data Synchronization Process Failed, Invalid ExamEventID or VenueID"; 
				synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
				synchronizeData.setSyncStatus("Failed");
				return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in syncExamEventData: " ,e);
			return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		finally{
			OESSyncConstants.syncStatus=false;
		}
		return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	/**
	 * Post method for Exam Venue Activation
	 * @param synchronizeDataViewModel
	 * @param request
	 * @return ResponseEntity<SynchronizeDataViewModel> this returns the http response status of synchronize data
	 */
	@PostMapping(value = "/venueActivation")
	public ResponseEntity<SynchronizeDataViewModel> getVenueActivationStatus(@RequestBody SynchronizeDataViewModel synchronizeDataViewModel, HttpServletRequest request) {
		SynchronizeDataViewModel synchronizeData = new SynchronizeDataViewModel();
		ExamVenueActivationViewModel evActivation=new ExamVenueActivationViewModel();
		boolean flag = false;
		
		try {
			String examVenueCode=synchronizeDataViewModel.getExamVenueCode().trim();
			String password=synchronizeDataViewModel.getPassword().trim();
			if (synchronizeDataViewModel.getExamVenueCode()!= null && synchronizeDataViewModel.getPassword() != null) {
				
				if(AppInfoHelper.appInfo.getExamVenueId()>0)
				{
					synchronizeDataViewModel.setExamVenueID(String.valueOf(AppInfoHelper.appInfo.getExamVenueId()));
					return new ResponseEntity<SynchronizeDataViewModel>(synchronizeDataViewModel, HttpStatus.OK);
				}
				ExamVenueActivationServicesImpl objExamVenueActivationServicesImpl = new ExamVenueActivationServicesImpl();
				
				String appName =  AppInfoHelper.appInfo.getAppName();
				Format formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
				String activitytime = formatter.format(new Date());
				
				evActivation = objExamVenueActivationServicesImpl
						.getExamVenueActivationViewModel(examVenueCode,password,appName,activitytime);
	
				// save all objects of viewModel
	
				if (evActivation == null || evActivation.getVenueUser() == null) {
					LOGGER.error("Exam venue data not found ");
					return new ResponseEntity<SynchronizeDataViewModel>(synchronizeDataViewModel, HttpStatus.INTERNAL_SERVER_ERROR);
				} else {
					flag = objExamVenueActivationServicesImpl
							.saveExamVenueActivationViewModel(evActivation);
				}
				
			}
		
			if (flag) {
				//load application info
				appInfo.setApplicationInfo();
				synchronizeDataViewModel.setExamVenueID(String.valueOf(AppInfoHelper.appInfo.getExamVenueId()));
				//Code For dynamic logo render:13-july-2015:Yograjs
				long clientID=AppInfoHelper.appInfo.getClientID();
				/*Changes  for client wise property loading Yograj:15-July-2015*/
				MKCLUtility.loadClientPropertiesFile(String.valueOf(clientID));
				/*reloading of Property files*/
				r.clearCacheIncludingAncestors();	
				uploader.startEvidenceUpload();
			} else {
				LOGGER.error("Error in saving venue data ");
				return new ResponseEntity<SynchronizeDataViewModel>(synchronizeDataViewModel, HttpStatus.INTERNAL_SERVER_ERROR);
			}
				
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in examVenueActivationViewModel: " ,e);
			return new ResponseEntity<SynchronizeDataViewModel>(synchronizeDataViewModel, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		//LOGGER.error("Venue Activation status:"+flag);
		return new ResponseEntity<SynchronizeDataViewModel>(synchronizeDataViewModel, HttpStatus.OK);
	}
	
	/**
	 * Post method to fetch Exam Event List
	 * @param syncData
	 * @param request
	 * @return ResponseEntity<List<ExamEventLB>> this returns the http response status for Exam Event LB List 
	 */
	@PostMapping(value = "examEventList")
	public ResponseEntity<List<ExamEventLB>> getAllExamEvent(@RequestBody SynchronizeDataViewModel syncData, HttpServletRequest request) {
		
		List<ExamEventLB> examEventLBList = new ArrayList<ExamEventLB>();
		try 
		{	
			ExamVenue examVenueDB = new OESCandidateService().getExamVenue();
			
			if(examVenueDB != null && Long.toString(examVenueDB.getExamVenueID()).equals(syncData.getExamVenueID())) 
			{
				List<ExamEvent> examEventList=new ExamEventServiceImpl().getAllExamEventList();
				if(!examEventList.isEmpty())
				{
					ExamEventLB examEventLB = null;
					for (ExamEvent examEvent : examEventList) {
						examEventLB = new ExamEventLB();
						examEventLB.setExamEventID(examEvent.getExamEventID());
						examEventLB.setName(examEvent.getName());
						examEventLBList.add(examEventLB);
					}
				}
				return new ResponseEntity<List<ExamEventLB>>(examEventLBList, HttpStatus.OK);
			}
			else
			{
				return new ResponseEntity<List<ExamEventLB>>(examEventLBList, HttpStatus.NOT_FOUND);
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in getAllExamEvent: " ,e);
			return new ResponseEntity<List<ExamEventLB>>(examEventLBList, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	
	/**
	 * Post method to Read Downloading Status
	 * @param syncData
	 * @param request
	 * @return ResponseEntity<SynchronizeDataViewModel> this returns the http response status of synchronize data
	 */
	@PostMapping("/readDownloadingStatus")
	public ResponseEntity<SynchronizeDataViewModel> readDownloadingStatusAjax(@RequestBody SynchronizeDataViewModel syncData, HttpServletRequest request) {
		
		SynchronizeDataViewModel synchronizeData = new SynchronizeDataViewModel();
		String syncMsg=OESSyncConstants.syncMsg;
		try
		{	
			/*
			 * if Sync status contains some data
			 * else if sync status is completed the add cap identifier to recognize it as process completed
			 */
			
			synchronizeData.setExamEventID(String.valueOf( syncData.getExamEventID()));
			synchronizeData.setExamVenueID(String.valueOf( syncData.getExamVenueID()));
			synchronizeData.setExamVenueUrl(syncData.getExamVenueUrl());
			synchronizeData.setSyncStatus(Boolean.toString(OESSyncConstants.syncStatus));
			
			if(OESSyncConstants.syncStatus)
			{
				synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);				
				return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.OK);
			}
			else
			{
				syncMsg=OESSyncConstants.syncMsg;
				synchronizeData.setSyncDetails(syncMsg + "^^^");
				OESSyncConstants.syncMsg = "";
				return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.OK);
			}
          
		}
		catch (Exception e) 
		{
			LOGGER.error("Error:", e);
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * Post method t Sync Candidate Data
	 * @param syncData
	 * @param request
	 * @return ResponseEntity<SynchronizeDataViewModel> this returns the http response status of synchronize data
	 */
	@PostMapping("/syncCandidateData")
	public ResponseEntity<SynchronizeDataViewModel> syncCandidateData(@RequestBody SynchronizeDataViewModel syncData, HttpServletRequest request) {
		SynchronizeDataViewModel synchronizeData = new SynchronizeDataViewModel();
		
		try
		{	
			OESSyncConstants.errorLevel=1;
			ExamEvent examEvent = null;
			SynchronizeEventData.resetSyncMsg();		
 
			
			synchronizeData.setExamEventID(String.valueOf( syncData.getExamEventID()));
			synchronizeData.setExamVenueID(String.valueOf( syncData.getExamVenueID()));
			synchronizeData.setExamVenueUrl(syncData.getExamVenueUrl());
			synchronizeData.setSyncDetails("");
			
			ExamEvent examEventDB=null;
			ExamVenue examVenueDB=null;
			if(syncData.getExamEventID() != null) {
				examEventDB = new ExamEventServiceImpl().getExamEventByID(Long.parseLong(syncData.getExamEventID()));
				examVenueDB = new OESCandidateService().getExamVenue();
			}
						
			if(examEventDB != null && examVenueDB != null && Long.toString(examEventDB.getExamEventID()).equals(syncData.getExamEventID()) && Long.toString(examVenueDB.getExamVenueID()).equals(syncData.getExamVenueID())) 
			{
								
				OESSyncConstants.currentTask = "1/3 Establishing connection with server ";
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
		        	
					
					 OESSyncConstants.currentTask = "<br>2/3 Checking Exam Event version from server ";
				     OESSyncConstants.progressBarPercentage = 0;
				     OESSyncConstants.eventVersionCheckStatus = OESSyncConstants.currentTask;
				  	 OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus;
				  		
				
				 SynchronizeCandidateData synchronizeCandidateDataObj = new SynchronizeCandidateData();
				 SynchronizeEventData synchronizeEventDataObj = new SynchronizeEventData();
				/* examEvent = new OESEventService().getExamVersion(Long.parseLong(syncData.getExamEventID()));
				 int isVersionChange = 0;
				 String version = null;
				 if (examEvent != null) {
				        version = String.valueOf(examEvent.getExamEventversion());                        
				        Map<String, String> reqMap = new HashMap<String, String>();
				        reqMap.put("exameventVersion", version);                       
				        reqMap.put("eventID", String.valueOf(Long.parseLong(syncData.getExamEventID())));
				       
				        //isVersionChange = synchronizeEventDataObj.checkExamEventVersion(Long.parseLong(syncData.getExamEventID()));     //.eventVersionCheckTransformerRequest(reqMap);
				}*/
				 int isVersionChange = 0;
				 isVersionChange = synchronizeEventDataObj.checkExamEventVersion(Long.parseLong(syncData.getExamEventID()));  
				 				 
			    if (isVersionChange != -1 ) {
			    	
			    	OESSyncConstants.progressBarPercentage = 100;
            		OESSyncConstants.eventVersionCheckStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
            		OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus;
			    	
			    	if(isVersionChange == 1)
			    	{
				    	 OESSyncConstants.currentTask = "<br>3/3 Candidate Data Synchronization ";
					     OESSyncConstants.progressBarPercentage = 0;
					  	 OESSyncConstants.candidateDownloadStatus = OESSyncConstants.currentTask+OESSyncConstants.progressBarPercentage+"% <i class=\"icon-ok\"></i>";
					  	 OESSyncConstants.syncMsg=OESSyncConstants.esbConnectionStatus+OESSyncConstants.eventVersionCheckStatus+OESSyncConstants.downloadEventDataStatus+OESSyncConstants.processEventDataStatus+OESSyncConstants.verifyingDataIntegrityStatus+OESSyncConstants.candidateDownloadStatus;
					  			    	
					  	 String eventName = "Exam Event : \"" +examEventDB.getName().toUpperCase()+ "\", ";
					  	 ExamEvent examEventDetails = new OESCandidateService().getExamEventByID(examEventDB.getExamEventID());
				
					  	 OESSyncConstants.syncStatus=true;

		 				if(synchronizeCandidateDataObj.synchronizeCandidateData(Long.toString(examEventDetails.getExamEventID()), request))
		                 {    
		 					
		               		OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
							OESSyncConstants.syncMsg+="\n\t"+eventName+" Data Synchronization Process Completed";
							OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
							OESSyncConstants.errorLevel=0;
				
		                 }
		                 else
		                 {
		                 	OESSyncConstants.syncMsg+="\n----------------------------------------------------------------------------------------";
		                 	OESSyncConstants.syncMsg+="\n\t "+eventName+"  Data Synchronization Process Failed";  
		                 	OESSyncConstants.syncMsg+="\n---------------------------------------------------------------------------------------- ";
		                 	OESSyncConstants.errorLevel=2;
		                 }
		 				
		 				synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
		 				
						if(OESSyncConstants.syncStatus)
						{
							synchronizeData.setSyncStatus("Success");
							return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.OK);
						}
						synchronizeData.setSyncStatus("Failed");
						
			    }// version change check
			    else
				{
			    	OESSyncConstants.syncMsg+="\n\tUpdate available for Exam Event. Please synchronize event data first!";
					synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
					synchronizeData.setSyncStatus("Failed");
					return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.NOT_FOUND);
				}
			    	
		       } 
			    else {
			    	 OESSyncConstants.syncMsg+="\n \nError in verifying Exam Event version.Please try later!";
			    	 synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
					 synchronizeData.setSyncStatus("Failed");
					 return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.NOT_FOUND);
			     }
			    
		        }
				
				else if (iConnectStatus == 1) {
					OESSyncConstants.syncMsg+="\n Error in establishing connection! Securities Certificates not found.";
					synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
					synchronizeData.setSyncStatus("Failed");
					return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.NOT_FOUND);
	            
		        } else if (iConnectStatus == 2) {
		        	OESSyncConstants.syncMsg+="\n Please verify that you are connected to Internet.";
		        	synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
					synchronizeData.setSyncStatus("Failed");
					return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.NOT_FOUND);
		           
		        } else if (iConnectStatus == 3) {
		        	OESSyncConstants.syncMsg+="\n Error in establishing connection!";
		        	synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
					synchronizeData.setSyncStatus("Failed");
					return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.NOT_FOUND);
		           
		        }
			}
			else
			{
				OESSyncConstants.syncMsg+="\n\t Data Synchronization Process Failed, Invalid ExamEventID or VenueID"; 
				synchronizeData.setSyncDetails(OESSyncConstants.syncMsg);
				synchronizeData.setSyncStatus("Failed");
				return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.NOT_FOUND);
			}
			
			
		}
		catch (Exception e) 
		{
			LOGGER.error("Exception occured in syncExamEventData: " ,e);
			return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		finally{
			OESSyncConstants.syncStatus=false;
		}
		return new ResponseEntity<SynchronizeDataViewModel>(synchronizeData, HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
		@PostMapping("/uploadPaperWiseData")
		public ResponseEntity<?> performPaperWiseUpload(@RequestBody ExamStatusViewModel examStatusViewModel,Model model, HttpServletRequest request) 
		{
			try
			{
				int result;
				if(examStatusViewModel.getPaperID() > 0 && examStatusViewModel.getExamEventID() > 0)
					result = CandidateExamDataUploader.uploadPaperWiseData(examStatusViewModel.getPaperID(), examStatusViewModel.getExamEventID());
				else
					result = CandidateExamDataUploader.uploadAllData();
				
				String uploadResponse = null;
				switch(result){
				case UPLOAD_SUCCESS:uploadResponse = "UPLOAD SUCCESS";
				break;
				
				case UPLOAD_FAILED:uploadResponse = "UPLOAD FAILED";
				break;
				
				case NO_DATA_to_UPLOAD:uploadResponse = "NO DATA TO UPLOAD";
				break;
				
				case SERVER_NOT_RESPONDING:uploadResponse = "SERVER NOT RESPONDING";
				break;
				
				case UPLOAD_ALREDY_IN_PROGRESS:uploadResponse = "UPLOAD ALREDY IN PROGRESS";
				break;
				
				case AUTO_UPLOAD_DISABLED:uploadResponse = "AUTO UPLOAD DISABLED";
				break;
				
				default : LOGGER.error("No response");
				
				break;
				
				}
				
				
				return new ResponseEntity<String>(uploadResponse, HttpStatus.OK);	
			}
			catch(Exception e)
			{
				LOGGER.error("",e);
				return new ResponseEntity<Error>(new Error("Some exception is occured"),HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

	@Override
	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		r=(ReloadableResourceBundleMessageSource) ((DelegatingMessageSource) ((MessageSource)applicationContext.getBean("messageSource"))).getParentMessageSource();
		uploader=(EvidenceFileUploader)applicationContext.getBean("evidenceFileUploader");
	}

}
