package mkcl.oesclient.commons.controllers;
import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oes.commons.EncryptionHelper;
import mkcl.oes.commons.FileUploadHelper;
import mkcl.oesclient.admin.services.CollectionMasterServicesImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.commons.utilities.SessionObject;
import mkcl.oesclient.commons.utilities.TransformerService;
import mkcl.oesclient.group.services.GroupServicesImpl;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.ExamCenterSupervisorAssociation;
import mkcl.oesclient.model.GroupMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.systemaudit.AuditVerificationMethods;
import mkcl.oesclient.systemaudit.BrowserInfo;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.utilities.md5Helper;
import mkcl.oesclient.viewmodel.ExamCenterSupervisorAssociationViewModel;
import mkcl.oespcs.model.CollectionType;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamVenueExamEventAssociation;
import mkcl.os.apps.MKCLHttpClient;
import mkcl.os.security.AESHelper;

@Controller("CommenLoginController")
@RequestMapping("login")
public class LoginController {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);

	private static final String USER="user";
	private static final String OBJUSER="objUser";
	private static final String LOGIN_PASSWORDCHANGE="Common/login/passwordchange";
	private static final String EXCEPTIONSTRING = "messageText";
	private static final String EXCEPTION = "message";
	
	@Autowired
	ExamLocaleThemeResolver examLocaleThemeResolver;


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
	 * Get method for Logout
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "logout" }, method = RequestMethod.GET)
	public String logOutGet(Model model, HttpSession session, String messageid, Locale locale,HttpServletRequest request) {
		String isDualLogin=null;
		String host=null;
		String isSuspend=null;
		try {
			if(request.getParameter("isDualLogin")!=null)
			{
				isDualLogin=request.getParameter("isDualLogin");
				if(SessionHelper.getLoginStatus(request) && SessionHelper.getLogedInUser(request)!=null)
				{
					host=new LoginServiceImpl().getLoginIPByUserID(SessionHelper.getLogedInUser(request).getUserID()); 
				}

			}else {
				SessionHelper.removeLoginFromMap(SessionHelper.getLogedInUser(request).getUserName(), request);
			}
			
			
			if(request.getParameter("isSuspend")!=null)
			{
				isSuspend=request.getParameter("isSuspend");	
				
			}
			
			SessionHelper.removeSession(session);
			if (messageid != null && !messageid.trim().equals("")) {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
		}  catch (Exception e) {
			LOGGER.error("Error in logOutGet : ", e);
			return "redirect:../login/logoutMsg?isDualLogin="+isDualLogin+"&host="+host+"&isSuspend="+isSuspend;
		}


		// code to get app version details
		return "redirect:../login/logoutMsg?isDualLogin="+isDualLogin+"&host="+host+"&isSuspend="+isSuspend;
	}

	/**
	 * Get method for Logout Message
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "logoutMsg" }, method = RequestMethod.GET)
	public String logoutMsg(Model model, HttpSession session, String messageid, Locale locale,HttpServletRequest request) {

		String isDualLogin=null;
		String host=null;
	    String isSuspend=null;
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());

		if(request.getParameter("isDualLogin")!=null)
		{
			isDualLogin=request.getParameter("isDualLogin");
			host=request.getParameter("host");
		}
		if(request.getParameter("isSuspend")!=null)
		{
			isSuspend=request.getParameter("isSuspend");	
			
		}
		
		model.addAttribute("isDualLogin", isDualLogin);
		model.addAttribute("host", host);
		model.addAttribute("isSuspend", isSuspend);

		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		return "Common/login/logout";

	}

	/**
	 * Get method for Change Password
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "changePassword" }, method = RequestMethod.GET)
	public String changePasswordGet(Model model, HttpSession session, String messageid, Locale locale) {
		model.addAttribute(OBJUSER, new VenueUser());
		
		/*************************************/
		try {
			Random random = new Random();
			int rnum = random.nextInt(100);
			model.addAttribute("adminRnum", rnum);
			SessionHelper.addVariable("rnum", rnum, session);
		}catch (Exception ex) {
			LOGGER.error("Exception occured in loginpage-adminrandomnumber-generation: ", ex);
		}
		
		/*************************************/
		
		return LOGIN_PASSWORDCHANGE;
	}

	/**
	 * Post method for Change Password
	 * @param user
	 * @param model
	 * @param session
	 * @param newpassword
	 * @param result
	 * @param locale
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "changePassword" }, method = RequestMethod.POST)
	public String changePasswordPost(@ModelAttribute(OBJUSER) VenueUser user, Model model, HttpSession session, @RequestParam("newpassword") String newpassword, BindingResult result, Locale locale,HttpServletRequest req) {

		LoginServiceImpl loginServiceImplObj=new LoginServiceImpl();
		VenueUser currentuser = SessionHelper.getLogedInUser(req);
		boolean errorstatus = true;
		String enteredOldpassword = null;
		String oldpassword = null;
		//String returnDashBoard = null;
		//String enteredOldPwdSaltMd5 = null;
		String oldPwdSaltMd5  = null;
	
				
		// validating entered old password
		if (currentuser != null) {
			oldpassword = currentuser.getPassword();
			enteredOldpassword = user.getPassword();
			
			try {
				
				md5Helper md5 = new md5Helper();
				oldPwdSaltMd5 = md5.getsaltMD5(oldpassword,SessionHelper.getVariable("rnum", req).toString());			
				
			} catch (Exception e) {
				LOGGER.error("Exception occured in changePasswordPost: " , e);
				model.addAttribute(Constants.EXCEPTIONSTRING, e);
				
				if(session != null && SessionHelper.getVariable("rnum", req) != null ) {
					SessionHelper.removeVariable("rnum", req);
				}
				return Constants.ERRORPAGE;
			}

			if(newpassword==null || newpassword.equals("")){
				model.addAttribute("blankNewPasswordError","You have Entered blank Password");
				model.addAttribute(OBJUSER, new VenueUser());			
				return LOGIN_PASSWORDCHANGE;
			}

			if ((enteredOldpassword != null && oldPwdSaltMd5 != null) && enteredOldpassword.equals(oldPwdSaltMd5)) {
				errorstatus = false;
				try {
					if(!loginServiceImplObj.updateUserPassword(currentuser.getUserID(),newpassword)){						
						MKCLUtility.addMessage(MessageConstants.FAILED_TO_UPDATE, model, locale);
						model.addAttribute(OBJUSER, user);
						return LOGIN_PASSWORDCHANGE;
					}

					//update session user password
					currentuser.setPassword(newpassword);


				} catch (Exception e) {
					LOGGER.error("Exception occured in changePasswordPost: " , e);
					model.addAttribute(Constants.EXCEPTIONSTRING, e);
					
					if(session != null && SessionHelper.getVariable("rnum", req) != null ) {
						SessionHelper.removeVariable("rnum", req);
					}
					return Constants.ERRORPAGE;
				}

			}
		}

		// creating simple error validation
		if (errorstatus) {
			FieldError fieldError = new FieldError(USER, "password", "You Have Entered Wrong password");
			result.addError(fieldError);
		}

		if (result.hasErrors()) {
			return LOGIN_PASSWORDCHANGE;
		}
		
		if(session != null && SessionHelper.getVariable("rnum", req) != null ) {
			SessionHelper.removeVariable("rnum", req);
		}

		/*if (currentuser.getFkRoleID() == 1) {
			returnDashBoard = "redirect:../dashboard/adminDashBoard?messageId=72";
		}
		if (currentuser.getFkRoleID() == 2) {
			returnDashBoard = "redirect:../dashboard/subjectAdminDashBoard?messageId=72";
		}
		if (currentuser.getFkRoleID() == 3) {
			returnDashBoard = "redirect:../candidateModule/homepage?messageId=72";
		}
				
		return returnDashBoard;*/
		

		return "redirect:/login/logoutMsg";
	}

	/**
	 * Method for Add Message
	 * @param messageid
	 * @param model
	 * @param locale
	 */
	private void addMessage(Integer messageid, Model model, Locale locale) {
		if (messageid != null && !messageid.equals("")) {
			MKCLUtility.addMessage(messageid, model, locale);
		}

	}

	/**
	 * Get method for DB Check
	 * @param model
	 * @param message
	 * @param messageText
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "dbCheck", method = RequestMethod.GET)
	public String dbCheckGet(Model model,String message,String messageText) {
		try {
			if (message != null && messageText != null) {
				model.addAttribute("message", message);
				model.addAttribute("messageText", messageText);
			}
		}
		catch (Exception ex) {
			LOGGER.error("Exception occured in dbCheckGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Common/login/dbNotExist";
	}

	/**
	 * Get method for Exam Event Selection
	 * @param model
	 * @param req
	 * @param event
	 * @param redirectAtrributes
	 * @param messageid
	 * @param locale
	 * @param session
	 * @param response
	 * @param user
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "eventSelection", method = RequestMethod.GET)
	public String eventSelectionget(Model model,HttpServletRequest req,@ModelAttribute("examEvent") ExamEvent event,final RedirectAttributes redirectAtrributes,String messageid,Locale locale,HttpSession session,HttpServletResponse response,@ModelAttribute("user") String user) {

		ExamEvent examEvent=null;
		//Reena : 30 July 2015 : remove User Session and set Default Locale
		try {
			SessionHelper.removeSession(session);
			//26-May-2020:Yograjs:added following condition to store user name which is passed by launcher application.
			session= req.getSession();
			if(user!=null && !user.isEmpty())
			{
				SessionHelper.addVariable("u", user, session);
			}
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(req, response);
		} catch (Exception e) {
			LOGGER.error("Error while removing user session and setting default locale in login : "+e);
		}
		
	    //Set Selected module for sitemesh in session
		String moduleName=req.getParameter("moduleName");		
		if(moduleName!=null && !moduleName.isEmpty())
		{
			SessionHelper.SetSiteMeshModule(session, moduleName);
		}		
		
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		if (messageid!=null && messageid!="") {
			MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
		}

		// code to get app version details
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
		
		List<ExamVenueExamEventAssociation> examVenueExamEventAssociationList=new LoginServiceImpl().getVenueExamEvents();
		
		if(examVenueExamEventAssociationList.size()>1)
		{
			model.addAttribute("examVenueExamEventAssociationList", examVenueExamEventAssociationList);	
		}
		else
		{
			model.addAttribute("examVenueExamEventAssociationList", null);
		}
		if(req.getHeader("User-Agent").contains("MOSB")) {


			examVenueExamEventAssociationList =	examVenueExamEventAssociationList.stream().filter(c -> c.getExamEvent().getIsExamClientRequired()==true).collect(Collectors.toList()); 

			if(examVenueExamEventAssociationList.size()==1) {
				examEvent=examVenueExamEventAssociationList.get(0).getExamEvent();

				// check secure browser details
				boolean secureBrowserCompatible=true;
				String userAgent = req.getHeader("User-Agent");
				if(examEvent.getIsExamClientRequired()){
					BrowserInfo browserInfo  = AuditVerificationMethods.verifySecureBrowser(userAgent);				
					if (!browserInfo.isCompatibilityStatus()) {
						secureBrowserCompatible=false;
					}
				}
				model.addAttribute("secureBrowserCompatible", secureBrowserCompatible);
				if(examEvent.getIsGroupEnabled())
				{
					model.addAttribute("loginType", LoginType.values());
				}
				else 
				{
					/*************************************/
					try {
						Random random = new Random();
						int rnum = random.nextInt(100);
						model.addAttribute("soloRnum", rnum);
						SessionHelper.addVariable("rnum", rnum, session);
					}catch (Exception ex) {
						LOGGER.error("Exception occured in eventSelection-solorandomnumber-generation on Secure browser: ", ex);
					}

					/*************************************/

					LoginType lType=LoginType.Solo;
					model.addAttribute(USER, new VenueUser());
					model.addAttribute("examEventID", examEvent.getExamEventID());
					model.addAttribute("loginType", lType);
					model.addAttribute("eventName", examEvent.getName());
					model.addAttribute("todayDate", new Date());
					return "Solo/soloLogin/soloLoginpage";
				}

			} else {
				model.addAttribute("examVenueExamEventAssociationList", examVenueExamEventAssociationList);
				model.addAttribute("examEvent", examEvent);
				model.addAttribute("admin", LoginType.Admin);
				return "Common/login/eventSelection";
			}
		}	
		else if(examVenueExamEventAssociationList.size()==1)
		{
			examEvent=examVenueExamEventAssociationList.get(0).getExamEvent();
			if(examEvent.getIsGroupEnabled())
			{
				model.addAttribute("loginType", LoginType.values());
			}
			else 
			{
			 /*************************************/
				try {
					Random random = new Random();
					int rnum = random.nextInt(100);
					model.addAttribute("soloRnum", rnum);
					SessionHelper.addVariable("rnum", rnum, session);
				}catch (Exception ex) {
					LOGGER.error("Exception occured in eventSelection-solorandomnumber-generation in rnum: ", ex);
				}

			/*************************************/

			LoginType lType=LoginType.Solo;
			model.addAttribute(USER, new VenueUser());
			model.addAttribute("examEventID", examEvent.getExamEventID());
			model.addAttribute("loginType", lType);
			model.addAttribute("eventName", examEvent.getName());
			model.addAttribute("todayDate", new Date());
			return "Solo/soloLogin/soloLoginpage";
		}
		}

		model.addAttribute("examEvent", examEvent);
		model.addAttribute("admin", LoginType.Admin);
		return "Common/login/eventSelection";
	}

	/**
	 * Post method for Exam Event Selection
	 * @param model
	 * @param req
	 * @param event
	 * @param redirectAtrributes
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "eventSelection", method = RequestMethod.POST)
	public String eventSelection(Model model,HttpServletRequest req,@ModelAttribute("examEvent") ExamEvent event,final RedirectAttributes redirectAtrributes) {

		ExamEvent examEvent=null;	
		boolean secureBrowserCompatible=true;
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		// code to get app version details
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
		
		/*************************************/
		HttpSession session = req.getSession(); 		
		
		try {
			Random random = new Random();
			int rnum = random.nextInt(100);
			model.addAttribute("soloRnum", rnum);
			SessionHelper.addVariable("rnum", rnum, session);
		}catch (Exception ex) {
			LOGGER.error("Exception occured in eventSelection-solorandomnumber-generation: ", ex);
		}
		
		/*************************************/
		
		if(req.getParameter("examEventID")!=null && req.getParameter("loginType")!=null)
		{
			examEvent=new ExamEventServiceImpl().getExamEventByID(Long.parseLong(req.getParameter("examEventID")));

			// check secure browser details
			String userAgent = req.getHeader("User-Agent");
			if(examEvent.getIsExamClientRequired()){
				BrowserInfo browserInfo  = AuditVerificationMethods.verifySecureBrowser(userAgent);				
				if (!browserInfo.isCompatibilityStatus()) {
					secureBrowserCompatible=false;
				}
			}
			model.addAttribute("secureBrowserCompatible", secureBrowserCompatible);

			LoginType loginType=LoginType.valueOf(req.getParameter("loginType"));
			if(loginType==LoginType.Solo)
			{
				model.addAttribute(USER, new VenueUser());
				model.addAttribute("examEventID", req.getParameter("examEventID"));
				model.addAttribute("loginType", req.getParameter("loginType"));
				model.addAttribute("eventName", examEvent.getName());
				model.addAttribute("todayDate", new Date());
				return"Solo/soloLogin/soloLoginpage";
			}
			else {
				SessionObject sessionObject= new SessionObject();

				sessionObject.setExamEvent(examEvent);
				sessionObject.setLoginType(loginType);
				List<CollectionMaster> collectionMasterList=null;
				Long noneCollectionId=null;

				Properties properties=MKCLUtility.loadMKCLPropertiesFile();
				String groupCreationMode=properties.getProperty("GroupCreationMode");
				if(groupCreationMode.equals("1"))/* For System Generated*/
				{
					List<GroupMaster> groupMasterList=null;
					if(examEvent.getCollectionType()==CollectionType.Batch)
					{
						collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
					}
					else if(examEvent.getCollectionType()==CollectionType.Division)
					{
						collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
					}
					else if (examEvent.getCollectionType()==CollectionType.None) {
						List<CollectionMaster> collectionList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
						if(collectionList!=null && collectionList.size()>0)
						{
							noneCollectionId=collectionList.get(0).getCollectionID();
							groupMasterList=new GroupServicesImpl().getSheduledGroupsByEventAndCollectionId(examEvent.getExamEventID(), noneCollectionId);
						}
					}
					model.addAttribute("collectionId", noneCollectionId);
					model.addAttribute("collectionMasterList", collectionMasterList);
					//groupMasterList=new GroupServicesImpl().getActiveandScheduledGroupListByExamEventId(Long.parseLong(req.getParameter("examEventID")));
					model.addAttribute("groupMasterList", groupMasterList);
					model.addAttribute("sessionObject",sessionObject);
					return"Group/groupLogin/groupLoginpage";
				}
				else /* For Manual Group Generation*/
				{
					if(examEvent.getCollectionType()==CollectionType.Batch)
					{
						collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
					}
					else if(examEvent.getCollectionType()==CollectionType.Division)
					{
						collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
					}
					else if (examEvent.getCollectionType()==CollectionType.None) {
						collectionMasterList=new CollectionMasterServicesImpl().getCollectionMasterByTypeAndEventId(examEvent.getCollectionType(), examEvent.getExamEventID());
						if(collectionMasterList!=null && collectionMasterList.size()>0)
						{
							noneCollectionId=collectionMasterList.get(0).getCollectionID();
						}
					}
					model.addAttribute("collectionId", noneCollectionId);
					model.addAttribute("collectionMasterList", collectionMasterList);
					model.addAttribute("sessionObject",sessionObject);
					return"Group/groupLogin/manualGroupLogin";
				}
			}
		}
		else if(req.getParameter("examEventID")!=null)
		{
			examEvent=new ExamEventServiceImpl().getExamEventByID(Long.parseLong(req.getParameter("examEventID")));

			// check secure browser details
			String userAgent = req.getHeader("User-Agent");
			if(examEvent.getIsExamClientRequired()){
				BrowserInfo browserInfo  = AuditVerificationMethods.verifySecureBrowser(userAgent);				
				if (!browserInfo.isCompatibilityStatus()) {
					secureBrowserCompatible=false;
				}
			}
			model.addAttribute("secureBrowserCompatible", secureBrowserCompatible);


			if(examEvent.getIsGroupEnabled())
			{
				model.addAttribute("loginType", LoginType.values());
			}
			else 
			{
				LoginType lType=LoginType.Solo;
				model.addAttribute(USER, new VenueUser());
				model.addAttribute("examEventID", req.getParameter("examEventID"));
				model.addAttribute("loginType", lType);
				model.addAttribute("eventName", examEvent.getName());
				model.addAttribute("todayDate", new Date());
				return "Solo/soloLogin/soloLoginpage";
			}
		}

		model.addAttribute("examEvent", examEvent);
		model.addAttribute("admin", LoginType.Admin);
		return "Common/login/eventSelection";
	}




	// Supervisor change pwd
	/*@RequestMapping(value = { "SupervisorchangePwd" }, method = RequestMethod.GET)
	public String supervisorChangePwdGet(Model model, HttpSession session, String messageid, Locale locale,HttpServletRequest req) {
		VenueUser venueUser = SessionHelper.getLogedInUser(req);
		String returnStr="";
		if(venueUser.getFkRoleID() != 1)
		{
			if (venueUser.getFkRoleID() == 2) {
				returnStr= "redirect:../dashboard/subjectAdminDashBoard?messageId=78";
			}
			if (venueUser.getFkRoleID() == 3) {
				returnStr= "redirect:../candidateModule/homepage?messageId=78";
			}
		}

		else
		{
			model.addAttribute("examCenterSupervisorAssociation", new ExamCenterSupervisorAssociation());
			returnStr= "Common/login/supervisorPwdchange";
		}

		return returnStr;
	}
	 */

	/**
	 * Get method for Supervisor - Change Password
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "SupervisorchangePwd" }, method = RequestMethod.GET)
	public String supervisorChangePwdGet(Model model, HttpSession session, String messageid, Locale locale,HttpServletRequest req) {
		VenueUser venueUser = SessionHelper.getLogedInUser(req);
		String returnStr="";
		LoginServiceImpl loginServiceImplObj=new LoginServiceImpl();
		ExamCenterSupervisorAssociationViewModel examCenterSupervisorAssociationViewModel=new ExamCenterSupervisorAssociationViewModel();
		try
		{
			if (messageid != null && messageid != "") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}

			if(venueUser.getFkRoleID() != 1 && venueUser.getFkRoleID() != 4)
			{
				if (venueUser.getFkRoleID() == 2) {
					returnStr= "redirect:../dashboard/subjectAdminDashBoard?messageId=78";
				}
				if (venueUser.getFkRoleID() == 3) {
					returnStr= "redirect:../candidateModule/homepage?messageId=78";
				}
			}

			else
			{
				 List<ExamCenterSupervisorAssociation> examCenterSupervisorAssociationList = loginServiceImplObj.getExCenterSupervisorAssociation();
				 examCenterSupervisorAssociationViewModel.setExamCenterSupervisorAssociationList(examCenterSupervisorAssociationList);
				 model.addAttribute("examCenterSupervisorAssociationViewModel",examCenterSupervisorAssociationViewModel);
				 model.addAttribute("examCenterSupervisorAssociationList",examCenterSupervisorAssociationList);
				 returnStr= "Common/login/newSupervisorPwdchange";
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in supervisorChangePwdGet...",e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return Constants.ERRORPAGE;
		}

		return returnStr;
	}

	/*@RequestMapping(value = { "SupervisorchangePwd" }, method = RequestMethod.POST)
	public String supervisorChangePwdPost(@ModelAttribute("examCenterSupervisorAssociation") ExamCenterSupervisorAssociation examCenterSupervisorAssociation, Model model, HttpSession session, @RequestParam("newpassword") String newpassword, BindingResult result, Locale locale,HttpServletRequest req) {


		LoginServiceImpl loginServiceImplObj=new LoginServiceImpl();
		VenueUser currentuser = SessionHelper.getLogedInUser(req);
		boolean errorstatus = true;
		String enteredOldpassword = null;
		String oldpassword = null;
		String returnDashBoard = null;

		// validating entered old password

		ExamCenterSupervisorAssociation objExamCenterSupervisorAssociation= loginServiceImplObj.getExCenterSupervisorAssociation(currentuser.getFkExamVenueID());

		if (currentuser != null) {
			oldpassword = objExamCenterSupervisorAssociation.getSupervisorPassword();
			enteredOldpassword = examCenterSupervisorAssociation.getSupervisorPassword();

			if(newpassword==null || newpassword.equals("")){
				model.addAttribute("blankNewPasswordError","You have Entered blank Password");
				model.addAttribute("examCenterSupervisorAssociation", new ExamCenterSupervisorAssociation());
				return LOGIN_PASSWORDCHANGE;
			}

			if ((enteredOldpassword != null && oldpassword != null) && enteredOldpassword.equals(oldpassword)) {
				errorstatus = false;
				try {
					if(!loginServiceImplObj.changeSupervisorPwd(objExamCenterSupervisorAssociation.getFkExamVenueID(),newpassword)){
						MKCLUtility.addMessage(MessageConstants.FAILED_TO_UPDATE, model, locale);
						model.addAttribute("examCenterSupervisorAssociation", examCenterSupervisorAssociation);
						return LOGIN_PASSWORDCHANGE;
					}

					//update session user password
					currentuser.setPassword(newpassword);


				} catch (Exception e) {
					LOGGER.error("Exception occured in changePasswordPost: " , e);
					model.addAttribute(Constants.EXCEPTIONSTRING, e);
					return Constants.ERRORPAGE;
				}

			}


		// creating simple error validation
		if (errorstatus) {
			FieldError fieldError = new FieldError("examCenterSupervisorAssociation", "supervisorPassword", MKCLUtility.getMessagefromKey(locale, "password.wrongPwd"));
			result.addError(fieldError);
		}

		if (result.hasErrors()) {
		//	model.addAttribute("examCenterSupervisorAssociation",examCenterSupervisorAssociation);
			return "Common/login/supervisorPwdchange";
		}

		if (currentuser.getFkRoleID() == 1) {
			returnDashBoard = "redirect:../dashboard/adminDashBoard?messageId=72";
		}
		if (currentuser.getFkRoleID() == 2) {
			returnDashBoard = "redirect:../dashboard/subjectAdminDashBoard?messageId=72";
		}
		if (currentuser.getFkRoleID() == 3) {
			returnDashBoard = "redirect:../candidateModule/homepage?messageId=72";
		}
	}
		return returnDashBoard;
	}*/


	/**
	 * Post method for Supervisor - Change Password
	 * @param fkExamVenueID
	 * @param supervisorPassword
	 * @param audioResetPassword
	 * @param closeBrowserPassword
	 * @param model
	 * @param session
	 * @param locale
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "SupervisorchangePwd" }, method = RequestMethod.POST)
	public String supervisorChangePwdPost(Model model, HttpSession session, Locale locale,HttpServletRequest req) {
		LoginServiceImpl loginServiceImplObj=new LoginServiceImpl();
		String returnDashBoard = null;
		String supervisorPwd =req.getParameter("supervisorPwd");
		String audioresetpwd =  req.getParameter("audioResetPwd");
		String closebrowserpwd =  req.getParameter("closeBrowserPwd");
		long examVenueID=Long.valueOf(req.getParameter("examVenueID"));
		try {
			if(!loginServiceImplObj.changeSupervisorPwd(examVenueID,supervisorPwd,audioresetpwd,closebrowserpwd,SessionHelper.getLogedInUser(req).getUserName())){
				MKCLUtility.addMessage(MessageConstants.FAILED_TO_UPDATE, model, locale);
				return "Common/login/newSupervisorPwdchange";
			}
			returnDashBoard = "redirect:../login/SupervisorchangePwd?messageid=2";
		} catch (Exception e) {
			LOGGER.error("Exception occured in changePasswordPost: " , e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return Constants.ERRORPAGE;
		}

		return returnDashBoard;
	}
	
	/**
	 * Get method to Reset Supervisor Password
	 * @param model
	 * @param session
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping (value= {"resetSupervisorPwd"},method = RequestMethod.GET)
	public String resetSupervisorPwdGet(Model model,HttpSession session, Locale locale,HttpServletRequest request) {
		VenueUser venueUser = SessionHelper.getLogedInUser(request);
		String returnStr="";		

		String messageid = request.getParameter("messageId");
		if (messageid != null && messageid != "") {
			MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
		}
		if(venueUser.getFkRoleID() != 1)
		{
			if (venueUser.getFkRoleID() == 2) {
				returnStr= "redirect:../dashboard/subjectAdminDashBoard?messageId=78";
			}
			if (venueUser.getFkRoleID() == 3) {
				returnStr= "redirect:../candidateModule/homepage?messageId=78";
			}
		}

		else
		{
			returnStr= "Common/login/resetSupervisorPwd";
		}
		return returnStr;
	}

	/**
	 * Post method to Reset Supervisor Password
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping (value= {"resetSupervisorPwd"},method = RequestMethod.POST)
	public String resetSupervisorPwdPost(Model model,HttpSession session, String messageid, Locale locale,HttpServletRequest req) {
		String returnDashBoard = null;
		LoginServiceImpl loginServiceImplObj=new LoginServiceImpl();
		VenueUser currentuser = SessionHelper.getLogedInUser(req);
		try
		{
			if(!loginServiceImplObj.changeSupervisorPwd(AppInfoHelper.appInfo.getExamVenueId(), md5Helper.getMd5(AppInfoHelper.appInfo.getExamVenueCode()),md5Helper.getMd5(AppInfoHelper.appInfo.getExamVenueCode()),md5Helper.getMd5(AppInfoHelper.appInfo.getExamVenueCode()),SessionHelper.getLogedInUser(req).getModifiedBy()))
			{
				// If no supervisor pwd is there as per examVenue id than
				return "redirect:../login/resetSupervisorPwd?messageId=77";
			}
		}
		catch(Exception e)
		{
			return "redirect:../login/resetSupervisorPwd?messageId=77";
		}
		//model.addAttribute(EXCEPTION, "success");
		MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_RESET_SUPERVISOR_PWD , model, locale);
		//model.addAttribute(EXCEPTIONSTRING, MessageConstants.SUCCESSFULLY_RESET_SUPERVISOR_PWD. +venueCode);
		if (currentuser.getFkRoleID() == 1) {
			return "Admin/dashboard/adminDashboard";
		}
		if (currentuser.getFkRoleID() == 2) {
			return "Admin/dashboard/subjectAdminDashboard";
		}
		if (currentuser.getFkRoleID() == 3) {
			return "Solo/candidateModule/homepage";
		}
		return returnDashBoard;
	}

	/* 02 Feb 2016 :Reena : Exam Venue Forget Password Services for SOLAR Venues */
	/**
	 * Get method for Change Admin Password
	 * @param model
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "changeAdminPassword" }, method = RequestMethod.GET)
	public String changeAdminPasswordGet(Model model,Integer messageid,Locale locale) {
		try
		{
			if (messageid != null && !messageid.equals("")) {
				MKCLUtility.addMessage(messageid, model, locale);
			}
			//Call to OES App Version service
			model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
			//Call to get ClientID
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			model.addAttribute("soloRnum", 87);
		}

		catch(Exception ex)
		{
			LOGGER.error("Exception occured in changeAdminPasswordGet: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Common/login/adminPasswordChange";
	}

	/**
	 * Post method for Change Admin Password
	 * @param model
	 * @param request
	 * @param session
	 * @param res
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "changeAdminPasswordPost" }, method = RequestMethod.POST)
	public String changeAdminPasswordPost(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse res) {

		LoginServiceImpl loginServiceImplObj=new LoginServiceImpl();		
		try
		{

			if(request.getParameter("examVenueCode")!=null && (request.getParameter("password")!=null || !request.getParameter("password").isEmpty()))
			{
				String venueCode=request.getParameter("examVenueCode");
				String pwd=request.getParameter("password");		

				if(loginServiceImplObj.IsValidVenueCode(venueCode))
				{
					// Call to Transformer
					String url = MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL")+"/transformer/executeTransformerJsonSecure/PasswordRecovery";		
					String transformerId = "DB1-DB2777777777777700018"; 

					// Generating post request for HTTP Client
					HttpPost postRequest = new HttpPost(url);
					//HttpServletRequest postRequest = new HttpServletRequest(url);
					// Adding necessary parameters to request required for execution of
					// transformer
					Map<String, String> requestParameters = new HashMap<String, String>();

					requestParameters.put("transformerId", transformerId);
					requestParameters.put("appId", "abc");
					requestParameters.put("examVenueCode", venueCode);
					requestParameters.put("password", pwd);	

					postRequest = MKCLHttpClient.addParametersToPost(postRequest,
							requestParameters);

					// Sending request to ESB and fetching the response
					HttpResponse response = MKCLHttpClient.sendRequest(postRequest);
					// Reading the JSON response
					HttpEntity httpEntity = response.getEntity();
					InputStream inputStream = httpEntity.getContent();
					BufferedReader reader = new BufferedReader(new InputStreamReader(
							inputStream));
					StringBuilder sb = new StringBuilder();
					String line = null;
					while ((line = reader.readLine()) != null) {
						sb.append(line + "\n");
					}
					inputStream.close();
					String jsonText = sb.toString();

					if (jsonText.length() > 2) {
						jsonText = AESHelper.decryptAsdecompress(jsonText, "MKCLSecurity$#@!");
					}

					String returnStatus=parseData(jsonText);
					if(returnStatus !=null && ! returnStatus.isEmpty() && Boolean.valueOf(returnStatus.split("::")[0]))					
					{
						if(loginServiceImplObj.updateVenuePassword(venueCode, returnStatus.split("::")[1]))
							return "redirect:changeAdminPassword?messageid=19";
						else
							return "redirect:changeAdminPassword?messageid=16";	
					}
					else
					{
						return "redirect:changeAdminPassword?messageid=15";
					}
				}
				else
				{
					return "redirect:changeAdminPassword?messageid=17";
				}
			}
			else
			{
				return "redirect:changeAdminPassword?messageid=18";
			}
		}
		catch (Exception ex) {
			LOGGER.error("Exception occured in changeAdminPasswordPost: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}


	}

	/**Method to parse data from JSON Text	 * 
	 * @param jsonText
	 * @return String this returns the valid venue
	 */
	public static String parseData(String jsonText)
	{
		String isValidVenue="";
		try
		{
			Object returnObject =TransformerService.getReturnObject(jsonText);			

			if(returnObject!=null)
			{
				isValidVenue=(String)returnObject;
			}			

		}
		catch(Exception e)
		{
			LOGGER.error("Error in parsing jsonResponse to parseData :", e);
		}
		return isValidVenue;
	}
	
	/*If you want to change bulk of supervisor password */
	@RequestMapping(value = { "/exportSupervisorPwdTemplate" }, method = {RequestMethod.GET})
	public void createExcel(Model model,HttpServletRequest request,HttpServletResponse response, Locale locale) {
		LoginServiceImpl loginServiceImplObj=new LoginServiceImpl();
		boolean isTemplate = false;
		try {
			isTemplate=loginServiceImplObj.getSupervisorPwdTemplate(response);
		} catch (Exception e) {
			LOGGER.error("Exception getting supervisor password data template file ...",e);
		}
	
	}
	
	@RequestMapping(value = { "/importTemplate" }, method = {RequestMethod.POST})	
	public String postImportTemplate(@RequestParam("file") MultipartFile fileData,Model model,HttpServletRequest request,HttpServletResponse response, Locale locale,RedirectAttributes redirectAttributes) {
		VenueUser loggedUser = SessionHelper.getLogedInUser(request);
		LoginServiceImpl loginServiceImplObj=new LoginServiceImpl();
		List<String> failedVenueCodeList= new ArrayList<String>();
		try {		
		
		if (!fileData.isEmpty()) {
			String serverFolderPath = FileUploadHelper.getPhysicalFolderPathWithinWebApp(request,"ChangeSupervisorPwdPath");
			String uploadedfileName;
			uploadedfileName = FileUploadHelper.uploadFileService(serverFolderPath, fileData);
			File sourceFile = new File(serverFolderPath + uploadedfileName);
			File targetFile = new File(serverFolderPath + uploadedfileName+ ".xlsx");
			AESHelper.decrypt(sourceFile, targetFile,EncryptionHelper.encryptDecryptKey);
			sourceFile.delete();
		   
			failedVenueCodeList= loginServiceImplObj.readAndSaveFileData(targetFile,loggedUser.getUserName());
			// Convert the List of String to String
	        String listOfFailedVenueCode = String.join(", ", failedVenueCodeList);
	        // Print the comma separated String
	        // System.out.println("Comma separated String: "+ listOfFailedVenueCode);
	      
	        redirectAttributes.addFlashAttribute("listOfFailedVenueCode",listOfFailedVenueCode);
	        targetFile.delete();
	        
	        return "redirect:../login/SupervisorchangePwd?messageid=195";  
	    }//end if
		
		
		} catch (Exception e) {
			LOGGER.error("error in postImportTemplate:", e);
			 model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return Constants.ERRORPAGE;
		}
		return "redirect:../login/SupervisorchangePwd";   
	
}
	
}
