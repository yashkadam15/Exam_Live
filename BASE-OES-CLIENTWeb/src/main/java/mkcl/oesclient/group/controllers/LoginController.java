package mkcl.oesclient.group.controllers;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.baseoesclient.model.LoginType;
import mkcl.baseoesclient.model.UserColor;
import mkcl.oesclient.admin.services.CollectionMasterServicesImpl;
import mkcl.oesclient.admin.services.UserServicesImpl;
import mkcl.oesclient.commons.controllers.OESLogger;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.services.OESAppInfoServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.commons.utilities.SessionObject;
import mkcl.oesclient.group.services.GroupCandidateExamServiceImpl;
import mkcl.oesclient.group.services.GroupServicesImpl;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.GroupMaster;
import mkcl.oesclient.model.OESAppInfo;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.solo.services.SchedulePaperAssociationServicesImpl;
import mkcl.oesclient.systemaudit.AuditVerificationMethods;
import mkcl.oesclient.systemaudit.BrowserInfo;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oespcs.model.CollectionType;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ScheduleType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller("GroupLoginController")
@RequestMapping("groupLogin")
public class LoginController {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);
	private static final String LOGINPAGE = "Group/groupLogin/groupLoginpage";	

	@InitBinder
	public void initBinder(WebDataBinder dataBinder, Locale locale,
			HttpServletRequest request) {
		Properties properties = null;
		String dateFormatString;
		SimpleDateFormat dateFormat;

		properties = MKCLUtility.loadMKCLPropertiesFile();

		dateFormatString = properties
				.getProperty("global.dateFormatWithTime");

		dateFormat = new SimpleDateFormat(dateFormatString);
		dateFormat.setLenient(false);
		dataBinder.registerCustomEditor(Date.class, new CustomDateEditor(
				dateFormat, true));
	}
	
	/**
	 * Get method for Login
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "loginpage", method = RequestMethod.POST)
	public String loginGet(Model model, HttpSession session, String messageid, Locale locale,HttpServletRequest request) {
		
		String examEventID=null;
		LoginType loginType=null;
		Long collectionId=null;
		if(request.getParameter("examEventID")==null && request.getParameter("loginType")==null && request.getParameter("collectionId")==null)
		{
			return "redirect:../login/eventSelection";
		}
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			examEventID=request.getParameter("examEventID");
			loginType=LoginType.valueOf(request.getParameter("loginType"));
			collectionId=Long.parseLong(request.getParameter("collectionId"));
		
		try {
			
			if (messageid != null && !messageid.equals("")) {
				addMessage(Integer.parseInt(messageid), model, locale);
			}
			
			ExamEvent examEvent=null;
			examEvent=new ExamEventServiceImpl().getExamEventByID(Long.parseLong(examEventID));
			
			// code to get app version details
			model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());

			SessionObject sessionObject=null;
			List<GroupMaster> groupMasterList=null;
			GroupMaster groupMaster=null;
			List<VenueUser> venueUserList=null;
			CollectionMaster collectionMaster=null;
			if(request.getParameter("groupId")!=null && request.getParameter("collectionId")!=null)
			{
				sessionObject=new SessionObject();
				sessionObject.setCollectionID(collectionId);
				sessionObject.setExamEvent(examEvent);
				groupMaster=new GroupServicesImpl().getGroupById(Long.parseLong(request.getParameter("groupId")));
				sessionObject.setGroupMaster(groupMaster);
				venueUserList=new UserServicesImpl().getVenueuserByGroupID(Long.parseLong(request.getParameter("groupId")),collectionId);
				sessionObject.setVenueUser(venueUserList);
				sessionObject.setLoginType(loginType);
				collectionMaster=new CollectionMasterServicesImpl().getCollectionMasterOne(collectionId);
			}
			model.addAttribute("collectionMaster", collectionMaster);
			model.addAttribute("sessionObject",sessionObject );
			model.addAttribute("groupMasterList", groupMasterList);
			model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath"));
			model.addAttribute("userColors", UserColor.values());
		} catch (Exception ex) {
			LOGGER.error("Exception occured in loginGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}		
		return LOGINPAGE;
	}

	/**
	 * Post method for Login 
	 * @param model
	 * @param sessionObject
	 * @param errors
	 * @param locale
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "postloginpage" }, method = RequestMethod.POST)
	public String loginPost(Model model, @ModelAttribute("sessionObject") SessionObject sessionObject, BindingResult errors, Locale locale, HttpServletRequest request, HttpServletResponse response) {
		try {
			
			VenueUser dbUser =null;
			Boolean loginStatus=true;
			
			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			if(sessionObject!=null)
			{
				for (VenueUser venueUser : sessionObject.getVenueUser()) {
					
					if(venueUser.getObject()==null)
					{
						dbUser = new LoginServiceImpl().getCandidateByUsernameEventID(venueUser.getUserName(),sessionObject.getExamEvent().getExamEventID());
						if (dbUser.getPassword().equals(venueUser.getPassword())) 
						{
							Candidate candidate=new CandidateServiceImpl().getCandidateByCandidateUsername(dbUser.getUserName());
							venueUser.setObject(candidate.getCandidateID());
						}
						else 
						{
							loginStatus=false;
						}
					}
				}
				if (!loginStatus) {
					// code to get app version details
					model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
					model.addAttribute("userColors", UserColor.values());
					model.addAttribute("sessionObject", sessionObject);
					model.addAttribute("groupMasterList", null);
					model.addAttribute("errorStatus", "1");
					model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath"));
					CollectionMaster collectionMaster=new CollectionMasterServicesImpl().getCollectionMasterOne(sessionObject.getCollectionID());
					model.addAttribute("collectionMaster", collectionMaster);
					return LOGINPAGE;
				}
				
			}
			ExamEvent examEvent=null;
			GroupMaster groupMaster=null;
			groupMaster=new GroupServicesImpl().getGroupById(sessionObject.getGroupMaster().getGroupID());
			examEvent=new ExamEventServiceImpl().getExamEventByID(sessionObject.getExamEvent().getExamEventID());
			
			SessionHelper.SetSession(examEvent, sessionObject.getLoginType(), sessionObject.getVenueUser(), groupMaster,sessionObject.getCollectionID(),null, request, response);
			for (VenueUser venueuser : sessionObject.getVenueUser()) {
				new LoginServiceImpl().updateLastLoginDeatilsByUserId(venueuser.getUserID(),OESLogger.getHostAddress(request), LoginType.Group);
			}
			
			
			MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);
			return "redirect:../groupCandidatesModule/grouphomepage";
		} catch (Exception ex) {
			LOGGER.error("Exception occured in loginPost: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

	}
	
	/**
	 * Post method for Manual Group Login
	 * @param model
	 * @param sessionObject
	 * @param errors
	 * @param locale
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "manualgrouplogin" }, method = RequestMethod.POST)
	public String manualgrouplogin(Model model, @ModelAttribute("sessionObject") SessionObject sessionObject, BindingResult errors, Locale locale, HttpServletRequest request, HttpServletResponse response) {
		try {
			/**
			 * MD5 autehentication
			 */
			/*if(FileCheckSumhelper.isEligibleForScan("APPLICATIONVERIFICATIONDETAILS"))
			{
				return "redirect:../login/eventSelection";
			}*/ 
			Long groupID=null;
			Long scheduleID=null;
			ExamEvent examEvent=null;
			GroupMaster groupMaster=null;
			
			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			if(sessionObject!=null)
			{
				examEvent=new ExamEventServiceImpl().getExamEventByID(sessionObject.getExamEvent().getExamEventID());
				sessionObject.setExamEvent(examEvent);
				scheduleID=new GroupServicesImpl().getActiveGroupScheduleIDByEventIDAndCollectionID(sessionObject.getExamEvent().getExamEventID(), sessionObject.getCollectionID());
				/*if Group Test not available*/
				if(scheduleID==null)
				{
					setGroupLoginDetails(model, sessionObject, request);
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.901.failure")+" "+examEvent.getCollectionType());
					return"Group/groupLogin/manualGroupLogin";
				}
				List<Candidate> candidateList=new ArrayList<Candidate>();
				String userStr="";
				int flag=0;
				/*Checking of user existance in candidate*/
				for (VenueUser venueUser : sessionObject.getVenueUser())
				{
					if(  venueUser.getUserName()!=null && !venueUser.getUserName().isEmpty())
					{
						Candidate candidate=new CandidateServiceImpl().getCandidateByCandidateUsername(venueUser.getUserName());
						
						if(candidate==null)
						{
							userStr+=venueUser.getUserName()+", ";
							flag=1;
						}
						else
						{
							venueUser.setObject(candidate.getCandidateID());
							candidateList.add(candidate);
						}
					}
				}
				if(flag==1)
				{
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.902.failure")+" "+userStr.substring(0, userStr.lastIndexOf(',')));
					setGroupLoginDetails(model, sessionObject, request);
					return"Group/groupLogin/manualGroupLogin";
				}
				/*Checking of user existence in selected collection*/
				for (Candidate candidate : candidateList)
				{
					boolean result=new GroupServicesImpl().getIsCandidateInEventCollection(candidate.getCandidateID(), sessionObject.getExamEvent().getExamEventID(), sessionObject.getCollectionID());
					if(!result)
					{
						setGroupLoginDetails(model, sessionObject, request);
						model.addAttribute("message", "failure");
						model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.903.failure")+" "+examEvent.getCollectionType() );
						return"Group/groupLogin/manualGroupLogin";
					}
						
				}
				Map<Long,Long> groupMap=new GroupServicesImpl().getCandidatesGroup(candidateList, scheduleID, sessionObject.getCollectionID());
				/*Checking of users associated to group and new users */
				if(groupMap.size()>1 && groupMap.containsKey(0l))
				{
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.904.failure"));
					setGroupLoginDetails(model, sessionObject, request);
					return"Group/groupLogin/manualGroupLogin";
				}
				/*Checking of users associated to different groups */
				if(groupMap.size()>1 && !groupMap.containsKey(0l))
				{
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.904.failure"));
					setGroupLoginDetails(model, sessionObject, request);
					return"Group/groupLogin/manualGroupLogin";
				}
				/*if users group already exist*/
				if(groupMap.size()==1 && !groupMap.containsKey(0l))
				{
					for (Long key : groupMap.keySet()) {
						groupID=key;
					}
					if(validateUsers(sessionObject, model,locale))
					{
						groupMaster=new GroupServicesImpl().getGroupById(groupID);
						SessionHelper.SetSession(examEvent, sessionObject.getLoginType(), sessionObject.getVenueUser(), groupMaster,sessionObject.getCollectionID(),null, request, response);
						for (VenueUser venueuser : sessionObject.getVenueUser()) 
						{
							new LoginServiceImpl().updateLastLoginDeatilsByUserId(venueuser.getUserID(),OESLogger.getHostAddress(request),LoginType.Group);
						}
						MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);
						return "redirect:../groupCandidatesModule/grouphomepage";
					}
					else 
					{
						setGroupLoginDetails(model, sessionObject, request);
						return"Group/groupLogin/manualGroupLogin";
					}
				}
				/*if creation of new user group*/
				if(groupMap.size()==1 && groupMap.containsKey(0l))
				{
					if(validateUsers(sessionObject, model,locale))
					{
						groupID=new GroupServicesImpl().saveGroupIdentityandGetGroupID(sessionObject, scheduleID);
						groupMaster=new GroupServicesImpl().getGroupById(groupID);
						sessionObject.setGroupMaster(groupMaster);
						if(!new GroupServicesImpl().saveGroupColletionAssociationAndGroupCandidateAssociation(sessionObject, scheduleID))
						{
							model.addAttribute("message", "failure");
							model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.905.failure") );
							setGroupLoginDetails(model, sessionObject, request);
							return"Group/groupLogin/manualGroupLogin";
						}

						SessionHelper.SetSession(examEvent, sessionObject.getLoginType(), sessionObject.getVenueUser(), groupMaster,sessionObject.getCollectionID(),null, request, response);
						for (VenueUser venueuser : sessionObject.getVenueUser()) {
							new LoginServiceImpl().updateLastLoginDeatilsByUserId(venueuser.getUserID(),OESLogger.getHostAddress(request),LoginType.Group);
						}
						MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);
						return "redirect:../groupCandidatesModule/grouphomepage";
					}
					else 
					{
						setGroupLoginDetails(model, sessionObject, request);
						return"Group/groupLogin/manualGroupLogin";
					}
				}
			}
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in loginPost: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "redirect:../login/eventSelection";
	}
	
	/**
	 * Method to Validate Users
	 * @param sessionObject
	 * @param model
	 * @param locale
	 * @return boolean this returns true if valid
	 */
	private boolean validateUsers(SessionObject sessionObject,Model model, Locale locale)
	{
		VenueUser dbUser=null;
		String dbusernames="";
		int mainflag=0;
		List<VenueUser> venueUserList=new ArrayList<VenueUser>();
		for (VenueUser venueuser : sessionObject.getVenueUser()) 
		{
			int flag=0;
			if(venueuser.getUserName()!=null && !venueuser.getUserName().isEmpty())
			{
				dbUser = new LoginServiceImpl().getCandidateByUsernameEventID(venueuser.getUserName(),sessionObject.getExamEvent().getExamEventID());
				if(dbUser!=null)
				{
					dbUser.setObject(venueuser.getObject());
					venueUserList.add(dbUser);
					if (!dbUser.getUserName().equals(venueuser.getUserName())) 
					{
						flag=1;
					}
					if (!dbUser.getPassword().equals(venueuser.getPassword())) 
					{
						flag=1;
					}
					if(flag==1)
					{
						mainflag=1;
						dbusernames+=venueuser.getUserName()+", ";
					}
				}
			}
		}
		if(mainflag==0)
		{
			sessionObject.setVenueUser(venueUserList);
			return true;
		}
		else 
		{
			model.addAttribute("message", "failure");
			model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.906.failure")+" "+dbusernames.substring(0,dbusernames.lastIndexOf(',')) );
			return false;
		}

	}
	
	
	/**
	 * Method to Set Group Login Details
	 * @param model
	 * @param sessionObject
	 * @param request
	 */
	private void setGroupLoginDetails(Model model,SessionObject sessionObject, HttpServletRequest request) {
		Long noneCollectionId=null;
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
		model.addAttribute("sessionObject", sessionObject);
		List<CollectionMaster> collectionMasterList=null;
		if(sessionObject.getExamEvent().getCollectionType()==CollectionType.Batch)
		{
			collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(sessionObject.getExamEvent().getCollectionType(), sessionObject.getExamEvent().getExamEventID());
		}
		else if(sessionObject.getExamEvent().getCollectionType()==CollectionType.Division)
		{
			collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(sessionObject.getExamEvent().getCollectionType(), sessionObject.getExamEvent().getExamEventID());
		}
		else if (sessionObject.getExamEvent().getCollectionType()==CollectionType.None) {
			collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(sessionObject.getExamEvent().getCollectionType(), sessionObject.getExamEvent().getExamEventID());
			if(collectionMasterList!=null && collectionMasterList.size()>0)
			{
				noneCollectionId=collectionMasterList.get(0).getCollectionID();
			}
		}
		model.addAttribute("collectionId", noneCollectionId);
		model.addAttribute("collectionMasterList", collectionMasterList);
	}
	
	
	
	
	/**
	 * Post method to Load Groups
	 * @param fkExamEventID
	 * @param collectionID
	 * @param request
	 * @return List<GroupMaster> this returns the GroupMasterList
	 */
	@RequestMapping(value = "/loadGroups.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<GroupMaster> getGroupMastersList(
			@RequestParam("fkExamEventID") Long fkExamEventID,
			@RequestParam("collectionID") Long collectionID,
			HttpServletRequest request) {
		List<GroupMaster> groupMasterList=null;
		GroupServicesImpl groupServicesImpl =new GroupServicesImpl();
		groupMasterList=groupServicesImpl.getSheduledGroupsByEventAndCollectionId(fkExamEventID, collectionID);
		return groupMasterList;
	}
	
	
	private void addMessage(Integer messageid, Model model, Locale locale) {
		if (messageid != null && !messageid.equals("")) {
			MKCLUtility.addMessage(messageid, model, locale);
		}

	}
	
	/**
	 * Get method for Gateway Group Login
	 * @param model
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "gatewayGrouplogin", method = RequestMethod.GET)
	public String gatewayGrouploginGet(Model model,HttpServletRequest req) {

		ExamEvent examEvent=null;	
		boolean secureBrowserCompatible=true;
		CollectionMaster collectionMaster=null;
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		// code to get app version details
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
		Long paperId=Long.parseLong(req.getParameter("pid")) ;
		if(SessionHelper.getExamEvent(req)!=null && SessionHelper.getLoginType(req)==LoginType.Group)
		{
			
			examEvent=SessionHelper.getExamEvent(req);
			// check secure browser details
			String userAgent = req.getHeader("User-Agent");
			if(examEvent.getIsExamClientRequired()){
				BrowserInfo browserInfo  = AuditVerificationMethods.verifySecureBrowser(userAgent);				
				if (!browserInfo.isCompatibilityStatus()) {
					secureBrowserCompatible=false;
				}
			}
			model.addAttribute("secureBrowserCompatible", secureBrowserCompatible);

			LoginType loginType=SessionHelper.getLoginType(req);
			SessionObject sessionObject= new SessionObject();
			sessionObject.setExamEvent(examEvent);
			sessionObject.setLoginType(loginType);
			sessionObject.setCollectionID(SessionHelper.getCollectionID(req));
			sessionObject.setIsGroupEnabled(SessionHelper.getExamEventIsGroupEnabled(req));
			sessionObject.setIsThirdPartySession(SessionHelper.getIsSessionThirdParty(req));
			sessionObject.setVenueUser(SessionHelper.getLogedInUsers(req));
			

			/* For Manual Group Generation*/
			/*	
			List<CollectionMaster> collectionMasterList=null;
			Long noneCollectionId=null;
			if(examEvent.getCollectionType()==CollectionType.Batch)
			{
				collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
			}
			else if(examEvent.getCollectionType()==CollectionType.Division)
			{
				collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
			}
			else if (examEvent.getCollectionType()==CollectionType.None) 
			{
				collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
				if(collectionMasterList!=null && collectionMasterList.size()>0)
				{
					noneCollectionId=collectionMasterList.get(0).getCollectionID();
				}
			}
			model.addAttribute("collectionId", noneCollectionId);
			model.addAttribute("collectionMasterList", collectionMasterList);*/
			model.addAttribute("pid", paperId);
			model.addAttribute("sessionObject",sessionObject);
			
			collectionMaster=new CollectionMasterServicesImpl().getCollectionMasterOne(SessionHelper.getCollectionID(req));
			model.addAttribute("collectionMaster", collectionMaster);
			
			return"Group/groupLogin/gatewayGrouplogin";
		}


		model.addAttribute("examEvent", examEvent);
		model.addAttribute("admin", LoginType.Admin);
		return "Common/login/eventSelection";
	}
	
	
	
	/*changes done for BSDM requirement*/
	/**
	 * Post method for Gateway Group Login
	 * @param model
	 * @param sessionObject
	 * @param session
	 * @param errors
	 * @param locale
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "gatewayGrouplogin" }, method = RequestMethod.POST)
	public String gatewayGrouplogin(Model model, @ModelAttribute("sessionObject") SessionObject sessionObject, HttpSession session, BindingResult errors, Locale locale, HttpServletRequest request, HttpServletResponse response) {
		try {

			Long groupID=null;
			long scheduleID=0l;
			ExamEvent examEvent=null;
			GroupMaster groupMaster=null;
			List<Candidate> candidateList=new ArrayList<Candidate>();
			
			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			Long paperId=Long.parseLong(request.getParameter("pid")) ;
			model.addAttribute("pid", paperId);
			if(sessionObject!=null)
			{
				examEvent=SessionHelper.getExamEvent(request);
				sessionObject.setExamEvent(examEvent);
				scheduleID=new SchedulePaperAssociationServicesImpl().getTodaysScheduleIdByScheduleType(ScheduleType.Day,sessionObject.getExamEvent().getExamEventID());
				/*if Group Test not available*/
				if(scheduleID==0l)
				{
					setgatewayGrouploginDetails(model, sessionObject, request);
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.907.failure"));
					return"Group/groupLogin/gatewayGrouplogin";
				}
				
				String userStr="";
				int flag=0;
				/*Checking of user existance in candidate*/
				for (VenueUser venueUser : sessionObject.getVenueUser())
				{
					if(  venueUser.getUserName()!=null && !venueUser.getUserName().isEmpty())
					{
						Candidate candidate=new CandidateServiceImpl().getCandidateByCandidateUsername(venueUser.getUserName());
						
						if(candidate==null)
						{
							userStr+=venueUser.getUserName()+", ";
							flag=1;
						}
						else
						{
							venueUser.setObject(candidate.getCandidateID());
							candidateList.add(candidate);
						}
					}
				}
				if(flag==1)
				{
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.902.failure")+" "+userStr.substring(0, userStr.lastIndexOf(',')));
					setgatewayGrouploginDetails(model, sessionObject, request);
					return"Group/groupLogin/gatewayGrouplogin";
				}
				/*Checking of user existence in selected collection*/
				for (Candidate candidate : candidateList)
				{
					boolean result=new GroupServicesImpl().getIsCandidateInEventCollection(candidate.getCandidateID(), sessionObject.getExamEvent().getExamEventID(), sessionObject.getCollectionID());
					if(!result)
					{
						setgatewayGrouploginDetails(model, sessionObject, request);
						model.addAttribute("message", "failure");
						model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.903.failure")+" "+examEvent.getCollectionType() );
						return"Group/groupLogin/gatewayGrouplogin";
					}
						
				}
				
				/*find the paperid against each candidate in candidateexam*/
				List<String> candidateIdList=new ArrayList<String>();
				for (Candidate candidate : candidateList) {
					candidateIdList.add(candidate.getCandidateID().toString());
				}
				
				int candCount=new GroupServicesImpl().getCandidatePaperCount(sessionObject.getExamEvent().getExamEventID(), paperId, candidateIdList);
				
				if(candCount!=candidateList.size())
				{
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.908.failure") );
					setgatewayGrouploginDetails(model, sessionObject, request);
					LOGGER.error("Exam data not found. Candidate Ids:"+candidateIdList);
					return"Group/groupLogin/gatewayGrouplogin";
				}
				
				
				Map<Long,Long> groupMap=new GroupServicesImpl().getCandidatesGroup(candidateList, scheduleID, sessionObject.getCollectionID());
				/*Checking of users associated to group and new users */
				if(groupMap.size()>1 && groupMap.containsKey(0l))
				{
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.904.failure"));
					setgatewayGrouploginDetails(model, sessionObject, request);
					return"Group/groupLogin/gatewayGrouplogin";
				}
				/*Checking of users associated to different groups */
				if(groupMap.size()>1 && !groupMap.containsKey(0l))
				{
					model.addAttribute("message", "failure");
					model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.904.failure"));
					setgatewayGrouploginDetails(model, sessionObject, request);
					return"Group/groupLogin/gatewayGrouplogin";
				}
				/*if users group already exist*/
				if(groupMap.size()==1 && !groupMap.containsKey(0l))
				{
					for (Long key : groupMap.keySet()) {
						groupID=key;
					}
					if(validateUsers(sessionObject, model,locale))
					{
						groupMaster=new GroupServicesImpl().getGroupById(groupID);
						Object obj = SessionHelper.getPartnerObject(request);
						SessionHelper.removeSession(session);
						SessionHelper.SetSession(examEvent, sessionObject.getLoginType(), sessionObject.getVenueUser(), groupMaster,sessionObject.getCollectionID(),obj, request, response);
						for (VenueUser venueuser : sessionObject.getVenueUser()) 
						{
							new LoginServiceImpl().updateLastLoginDeatilsByUserId(venueuser.getUserID(),OESLogger.getHostAddress(request),LoginType.Group);
						}
						/*set paper to incomplete mode for all candidate*/
						new GroupCandidateExamServiceImpl().updateCadidateExamsForFirstTime(candidateList, sessionObject.getExamEvent().getExamEventID(), paperId);
						MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);
						return "redirect:../groupExam/groupInfo?examEventID="+SessionHelper.getExamEvent(request).getExamEventID()+"&paperID="+paperId+"&scheduleID="+scheduleID;
					}
					else 
					{
						setgatewayGrouploginDetails(model, sessionObject, request);
						return"Group/groupLogin/gatewayGrouplogin";
					}
				}
				/*if creation of new user group*/
				if(groupMap.size()==1 && groupMap.containsKey(0l))
				{
					if(validateUsers(sessionObject, model,locale))
					{
						groupID=new GroupServicesImpl().saveGroupIdentityandGetGroupID(sessionObject, scheduleID);
						groupMaster=new GroupServicesImpl().getGroupById(groupID);
						sessionObject.setGroupMaster(groupMaster);
						if(!new GroupServicesImpl().saveGroupColletionAssociationAndGroupCandidateAssociation(sessionObject, scheduleID))
						{
							model.addAttribute("message", "failure");
							model.addAttribute("messageText",MKCLUtility.getMessagefromKey(locale, "global.905.failure") );
							setgatewayGrouploginDetails(model, sessionObject, request);
							return"Group/groupLogin/gatewayGrouplogin";
						}
						Object obj = SessionHelper.getPartnerObject(request);
						SessionHelper.removeSession(session);
						SessionHelper.SetSession(examEvent, sessionObject.getLoginType(), sessionObject.getVenueUser(), groupMaster,sessionObject.getCollectionID(),obj, request, response);
						for (VenueUser venueuser : sessionObject.getVenueUser()) {
							new LoginServiceImpl().updateLastLoginDeatilsByUserId(venueuser.getUserID(),OESLogger.getHostAddress(request),LoginType.Group);
						}
						
						/*set paper to incomplete mode for all candidate*/
						new GroupCandidateExamServiceImpl().updateCadidateExamsForFirstTime(candidateList, sessionObject.getExamEvent().getExamEventID(), paperId);
						
						MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);
						return "redirect:../groupExam/groupInfo?examEventID="+SessionHelper.getExamEvent(request).getExamEventID()+"&paperID="+paperId+"&scheduleID="+scheduleID;
					}
					else 
					{
						setgatewayGrouploginDetails(model, sessionObject, request);
						return"Group/groupLogin/gatewayGrouplogin";
					}
				}
			}
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in loginPost: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "redirect:../login/eventSelection";
	}
	
	
	/**
	 * Method to Set Gateway Group Login Details
	 * @param model
	 * @param sessionObject
	 * @param request
	 */
	private void setgatewayGrouploginDetails(Model model,SessionObject sessionObject, HttpServletRequest request) 
	{
		CollectionMaster collectionMaster=null;
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
		
		
		
		sessionObject.setExamEvent(SessionHelper.getExamEvent(request));
		sessionObject.setLoginType(SessionHelper.getLoginType(request));
		sessionObject.setCollectionID(SessionHelper.getCollectionID(request));
		sessionObject.setIsGroupEnabled(SessionHelper.getExamEventIsGroupEnabled(request));
		sessionObject.setIsThirdPartySession(SessionHelper.getIsSessionThirdParty(request));
		
		model.addAttribute("sessionObject", sessionObject);
		
		collectionMaster=new CollectionMasterServicesImpl().getCollectionMasterOne(SessionHelper.getCollectionID(request));
		model.addAttribute("collectionMaster", collectionMaster);
	}
	
	
	
	
	
	
	
}
