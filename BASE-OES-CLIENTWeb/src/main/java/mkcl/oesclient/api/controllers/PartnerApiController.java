package mkcl.oesclient.api.controllers;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.api.services.CandidateAuthenticationServices;
import mkcl.oesclient.api.services.CourseEventsDataSyncServices;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.utilities.GatewayConstants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.sync.controllers.SynchronizeDataController;
import mkcl.oesclient.sync.model.OESSyncConstants;
import mkcl.oesclient.systemaudit.AuditVerificationMethods;
import mkcl.oesclient.viewmodel.ExamVenueActivationViewModel;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.MessageSource;
import org.springframework.context.support.DelegatingMessageSource;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("OESApi")
public class PartnerApiController implements ApplicationContextAware
{
	private static final Logger LOGGER = LoggerFactory.getLogger(PartnerApiController.class);
	private CourseEventsDataSyncServices dataSyncServices=new CourseEventsDataSyncServices();
	ReloadableResourceBundleMessageSource r = null;
	
	/**
	 * Post method for Sync Exam Event Data
	 * @param locale
	 * @param request
	 * @param pecids
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "syncEventData", method = RequestMethod.POST)
	@ResponseBody public String syncExamDataAjax( Locale locale,HttpServletRequest request,String pecids) {
		try 
		{ 
			SynchronizeDataController syncDataObj=new SynchronizeDataController();
			LOGGER.error("Data Sync request from partner:: pecids="+pecids);
			if(OESSyncConstants.syncStatus)
			{
				LOGGER.error("Previous sync request is in progress.");
				return null;
			}
			
			if(pecids!=null )
			{
				int exitcode=0;	
				Map<String, Boolean> courseEventsSynsStatusMap=new HashMap<String, Boolean>();
				
				VenueUser dbUser=dataSyncServices.getClientAdminDetails();
				if(dbUser!=null)
				{
					// SYNC Master data first to get new program course event association
					syncDataObj.SyncMasterData(request);
					exitcode=OESSyncConstants.errorLevel;
					if(exitcode==0)
					{					
						LOGGER.error("Master data synced sucessfully.");
						LOGGER.error("Starting Program Course wise Exam Events Syncing...");
						
						Map<Long,List<String>> courseEventIdMap =new HashMap<Long, List<String>>();
						courseEventIdMap=dataSyncServices.getCourseWiseActiveExamEvents(pecids);						
						
						if(!courseEventIdMap.isEmpty() && dbUser!=null)
						{	
							exitcode=0;
							Boolean eventSyncStatus=null;							
							
							for (Entry<Long,List<String>> entry : courseEventIdMap.entrySet()) 
							{
								LOGGER.error("Data Sync started for pcid :"+entry.getKey());							

								for (String eventId : entry.getValue()) 
								{
									syncDataObj.fullDataSynchronization(eventId, request,null);					
									exitcode=OESSyncConstants.errorLevel;
										if(exitcode!=0)
										{
											eventSyncStatus=false;
											LOGGER.error("Data Sync failed for pecid :"+entry.getKey()+" and ExameventId :"+eventId);
											LOGGER.error("Smart Client executed errorneously. exitCode :: " +exitcode);
											if(exitcode==1)
												LOGGER.error("Full Data sync: Something unhandled happened during Full Data sync");
											else if(exitcode==2)
												LOGGER.error("Full Data sync: Full Data sync failed");
											else if(exitcode==4)
												LOGGER.error("Full Data sync: Unable to establish connection.Please enter OES application URL.Make sure that OES server application is running.");
											else if(exitcode==5)
												LOGGER.error("Full Data sync: User name or password or examevntId is blank or incorrect.");
											else if(exitcode==6)
												LOGGER.error("Full Data sync: Error in establishing connection! Either Securities Certificates not found or verify that you are connected to Internet.");
													
											break;
										}
										else
										{
											eventSyncStatus=true;										
											LOGGER.error("Full Data Sync success for pecid :"+entry.getKey()+" and ExameventId :"+eventId);
											LOGGER.error("Smart Client executed sucessfully. exitCode :: " +exitcode);
										}								
								}	
								
								courseEventsSynsStatusMap.put(entry.getKey().toString(), eventSyncStatus);					
							}
							
							// This block adds false status to those pecids which are not present in ERAPROGRAMCOURSEASSOCIATION table
							String[] pcidArr = pecids.split(",");
							if(pcidArr.length!=courseEventsSynsStatusMap.size())
							{
								for (String pcid : pcidArr) 
								{
									if (! courseEventsSynsStatusMap.containsKey(pcid)) 
									{
										courseEventsSynsStatusMap.put(pcid, false);
									}
								}								
							}
							LOGGER.error("INFO::::Coursewise Event Download status:"+courseEventsSynsStatusMap.toString());
							return courseEventsSynsStatusMap.toString();
							
						}
						else
						{
							LOGGER.error("PECID Event association not found in OES.Please verify association data");
							// msg to redirect to ERA
							String[] pcidArr = pecids.split(",");
							for (String pcid : pcidArr) {
								courseEventsSynsStatusMap.put(pcid, false);
							}
							
						}
						
					}
					else
					{
						LOGGER.error("Master data sync failed");
						LOGGER.error("Smart Client executed errorneously. exitCode :: " +exitcode);
						if(exitcode==1)
							LOGGER.error("Master Data sync: Something unhandled happened during Master Data sync");
						else if(exitcode==3)
							LOGGER.error("Master Data sync: Master Data sync failed");
						else if(exitcode==4)
							LOGGER.error("Master Data sync: Unable to establish connection.Please enter OES application URL.Make sure that OES server application is running.");
						else if(exitcode==5)
							LOGGER.error("Master Data sync: User name or password is blank or incorrect.");
						else if(exitcode==6)
							LOGGER.error("Master Data sync: Error in establishing connection! Either Securities Certificates not found or verify that you are connected to Internet.");
								
						String[] pcidArr = pecids.split(",");
						for (String pcid : pcidArr) {
							courseEventsSynsStatusMap.put(pcid, false);
						}									
						
					}
				}
				else
				{
					LOGGER.error("Error occured while fetching OES Client Admin details");					
					// msg to redirect to ERA
					String[] pcidArr = pecids.split(",");
					for (String pcid : pcidArr) {
						courseEventsSynsStatusMap.put(pcid, false);
					}
				}
				LOGGER.error("INFO::::Coursewise Event Download status:"+courseEventsSynsStatusMap.toString());
			 return courseEventsSynsStatusMap.toString();	
			}
			else{
				LOGGER.error("pecids[program eCourse Ids] are blank ");
				// msg to redirect to ERA
				return null;
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in OESApi request/syncCourseEventsData: " ,e);
			return null;
		}		
	}	

	/**
	 * Post method for Exam Venue Registration 
	 * @param request
	 * @param venueCode
	 * @param password
	 * @return boolean this returns true on success
	 */
	@RequestMapping(value = { "/venueRegistration" }, method = RequestMethod.POST)
	@ResponseBody
	public boolean postVenuRegistrationERA(HttpServletRequest request, String venueCode, String password) {
		boolean flag = false;
		
		/*String venueCode=null;
		String password=null;*/
		try {
			ExamVenueActivationServicesImpl objExamVenueActivationServicesImpl = new ExamVenueActivationServicesImpl();
			LOGGER.error("Venue Activation request from partner- venueCode: "+venueCode);	
			
			// If venue is already registered show message
			if(objExamVenueActivationServicesImpl.isExamVenueRegistered())
			{
				//return "redirect:../login/eventSelection?messageid=46";
				return true;
			}
			
			if (venueCode != null && password != null) {
				
				String appName = request.getContextPath();
				appName=appName.substring(1);
				
				Format formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
				String activitytime = formatter.format(new Date());
				
				
				ExamVenueActivationViewModel evActivation = objExamVenueActivationServicesImpl
						.getExamVenueActivationViewModel(venueCode, password,appName,activitytime);

				// save all objects of viewModel

				if (evActivation == null || evActivation.getVenueUser() == null) {
					// return "redirect:/activateVenue/venueRegistration?messageid=39";
					LOGGER.error("ExamVenueActivationViewModel is found null(ERA) ");
					return false;
				} else {
					flag = objExamVenueActivationServicesImpl
							.saveExamVenueActivationViewModel(evActivation);

				}
			}
		
			if (flag) {			
				//Code For dynamic logo render:13-july-2015:Yograjs
				long clientID=new ExamVenueActivationServicesImpl().getExamVenueClientID();
				
				/*Changes  for client wise property loading Yograj:15-July-2015*/
				MKCLUtility.loadClientPropertiesFile(String.valueOf(clientID));
				/*reloading of Property files*/
				r.clearCache();		
			}
		
		
		}  catch (Exception ex) {
			LOGGER.error("Exception occured in postVenuRegistrationForm (ERA): " , ex);
			return false;
		}
		LOGGER.error("Venue Activation status:"+flag);
		return flag;
	}
	
	/**
	 * Post method for Validate Candidate
	 * @param request
	 * @param epID
	 * @param ccode
	 * @param pcID
	 * @return boolean this returns true if valid
	 */
	@ResponseBody
	@RequestMapping(value = { "/validateCandidate"}, method = RequestMethod.POST)
	public boolean validateCandidate(HttpServletRequest request, @RequestParam(GatewayConstants.EXEVPID) long epID,  @RequestParam(GatewayConstants.CCODE) String ccode, @RequestParam(value=GatewayConstants.PCID,required=false) Long pcID) {
		LOGGER.error("Validate Candidate request from partner:: epID="+epID+", ccode="+ccode+", pcID="+pcID);
		return new CandidateAuthenticationServices().validateCandidateByEventpaperID(ccode,epID,pcID);
	}
	
	@Override
	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		r=(ReloadableResourceBundleMessageSource) ((DelegatingMessageSource) ((MessageSource)applicationContext.getBean("messageSource"))).getParentMessageSource();
	}
	
}
