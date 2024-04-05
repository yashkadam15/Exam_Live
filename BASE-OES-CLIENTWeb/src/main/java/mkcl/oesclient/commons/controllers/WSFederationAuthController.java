package mkcl.oesclient.commons.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.services.OESAppInfoServicesImpl;
import mkcl.oesclient.commons.services.WSFederationService;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.model.CandidateCollectionAssociation;
import mkcl.oesclient.model.OESAppInfo;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.systemaudit.AuditVerificationMethods;
import mkcl.oesclient.systemaudit.BrowserInfo;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamVenueExamEventAssociation;


/**
 * Author Yograjs
 * 
 */
@Controller
@RequestMapping(value = "wsfAuth")
public class WSFederationAuthController 
{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(WSFederationAuthController.class);

	/**
	 * Get method for Login
	 * @param model
	 * @param request
	 * @param locale
	 * @param session
	 * @param response
	 * @param userNamefromWSD
	 * @param url
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(Model model,HttpServletRequest request,Locale locale,HttpSession session, HttpServletResponse response, @ModelAttribute("user") final String userNamefromWSD, @ModelAttribute("lurl") final String url) 
	{		
		try 
		{
			if(userNamefromWSD == null || userNamefromWSD.isEmpty() || url == null || url.isEmpty())
			{
				clientVersionInfo(model);
				model.addAttribute("error", 2);
				return "wsfAuth/eventSelection";
			}
			//TODO: Remove direct session add attribute, use SessionHelper instead
			SessionHelper.addVariable("launcherURL", url, session);
			Cookie c = new Cookie("referer", url);
			c.setHttpOnly(true);
			c.setMaxAge(-1);
			c.setPath("/");
			response.addCookie(c);
			if(userNamefromWSD!=null && userNamefromWSD.trim().length()>0)
			{
				model.addAttribute("user", userNamefromWSD);
				List<ExamVenueExamEventAssociation> examVenueExamEventAssociationList=new WSFederationService().getCandidateExamEvents(userNamefromWSD);
				if(examVenueExamEventAssociationList==null || examVenueExamEventAssociationList.size()==0)
				{
					clientVersionInfo(model);
					removeSession(model, session, request);
					model.addAttribute("error", 1);
					return "wsfAuth/eventSelection";
				}
				else if(examVenueExamEventAssociationList.size()==1)
				{
					ExamEvent examEvent=new ExamEventServiceImpl().getExamEventByID(examVenueExamEventAssociationList.get(0).getExamEvent().getExamEventID());
					
					return validateAndCreateSession(model, request, locale, session, userNamefromWSD, examEvent, response);
				}
				else
				{
					clientVersionInfo(model);
					model.addAttribute("examVenueExamEventAssociationList", examVenueExamEventAssociationList);
					return "wsfAuth/eventSelection";
				}
			}
			else
			{
				clientVersionInfo(model);
				removeSession(model, session, request);
				model.addAttribute("error", 1);
				return "wsfAuth/eventSelection";
			}
		} 
		catch (Exception e)
		{
			clientVersionInfo(model);
			removeSession(model, session, request);
			model.addAttribute("error", 1);
			return "wsfAuth/eventSelection";
		}
	}

	/**
	 * Post method for Exam Event Selection 
	 * @param model
	 * @param request
	 * @param session
	 * @param locale
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "eventSelection", method = RequestMethod.POST)
	public String eventSelection(Model model,HttpServletRequest request,HttpSession session,Locale locale, HttpServletResponse response) {
		ExamEvent examEvent=null;
		try
		{
			String userNamefromWSD = request.getParameter("user");
			//userNamefromWSD ="mkclrb10yyyyyy";
			if(request.getParameter("examEventID")!=null && userNamefromWSD!=null && userNamefromWSD.length()>1)
			{
				examEvent=new ExamEventServiceImpl().getExamEventByID(Long.parseLong(request.getParameter("examEventID")));
				return validateAndCreateSession(model, request, locale, session, userNamefromWSD, examEvent, response);
			}
			else
			{
				LOGGER.error("Exam Event ID is null in Event selection of wsfAuth");
			}
		}
		catch (Exception e) {
			LOGGER.error("Exception in wsfAuth Eventselection Post",e);			
		}
		return "redirect:../wsfAuth/login";
	}
	
	/**
	 * Method to fetch the Client Version Information
	 * @param model
	 */
	private void clientVersionInfo(Model model) 
	{
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
	}

	/**
	 * Method to Validate and Create Session
	 * @param model
	 * @param request
	 * @param locale
	 * @param session
	 * @param userNamefromWSD
	 * @param examEvent
	 * @param response
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	private String validateAndCreateSession(Model model, HttpServletRequest request, Locale locale, HttpSession session,String userNamefromWSD, ExamEvent examEvent, HttpServletResponse response) throws Exception 
	{
		clientVersionInfo(model);
		boolean secureBrowserCompatible=true;
		String userAgent = request.getHeader("User-Agent");
		if(examEvent.getIsExamClientRequired()){
			BrowserInfo browserInfo  = AuditVerificationMethods.verifySecureBrowser(userAgent);				
			if (!browserInfo.isCompatibilityStatus()) {
				secureBrowserCompatible=false;
				model.addAttribute("secureBrowserCompatible", secureBrowserCompatible);
				removeSession(model, session, request);
				return "wsfAuth/eventSelection";
			}
		}
		model.addAttribute("secureBrowserCompatible", secureBrowserCompatible);
		VenueUser dbUser = new LoginServiceImpl().getCandidateByUsernameEventID(userNamefromWSD, examEvent.getExamEventID());
		model.addAttribute("eventName", examEvent.getName());
		if (dbUser == null) 
		{
			model.addAttribute("error", 1);
			removeSession(model, session, request);
			return "wsfAuth/eventSelection";
		}
		LoginType logType= LoginType.Solo;
		List<VenueUser> venueUserList=new ArrayList<VenueUser>();
		dbUser.setObject(dbUser.getUserID());
		venueUserList.add(dbUser);
		CandidateCollectionAssociation candidateCollectionAssociation=new CandidateServiceImpl().getCandidateCollectionAssociationByEventAndCandidateID(examEvent.getExamEventID(),dbUser.getUserID());
		SessionHelper.SetSession(examEvent,logType,venueUserList , null,candidateCollectionAssociation.getFkCollectionID(), null,request, response);
		new LoginServiceImpl().updateLastLoginDeatilsByUserId(dbUser.getUserID(),OESLogger.getHostAddress(request),LoginType.Solo);
		MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);
		return "redirect:../candidateModule/homepage";
	}
	
	/**
	 * Get method for Logout
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	@RequestMapping(value = { "logout" }, method = RequestMethod.GET)
	public String logOutGet(Model model, HttpSession session, String messageid, Locale locale,HttpServletRequest request, HttpServletResponse response) throws Exception 
	{
		String isDualLogin=null;
		String host=null;
	
		if (messageid != null && !messageid.trim().equals("")) 
		{
			MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
		}
		clientVersionInfo(model);
		if(request.getParameter("isDualLogin")!=null)
		{
			isDualLogin=request.getParameter("isDualLogin");
			if(SessionHelper.getLoginStatus(request) && SessionHelper.getLogedInUser(request)!=null)
			{
				host=new LoginServiceImpl().getLoginIPByUserID(SessionHelper.getLogedInUser(request).getUserID()); 
			}
		}
		model.addAttribute("isDualLogin", isDualLogin);
		model.addAttribute("host", host);
		removeSession(model, session, request);
		if(isDualLogin == null || !isDualLogin.equals("1"))
		{
			String rurl=model.asMap().get("wsflogouturl").toString();
			model.asMap().clear();
			return "redirect:" + rurl;
		}
			
		return "wsfAuth/logout";
	}

	/**
	 * Method to Remove Session 
	 * @param model
	 * @param session
	 * @param request
	 */
	private void removeSession(Model model, HttpSession session, HttpServletRequest request)
	{
		try 
		{
			if(SessionHelper.getVariable("launcherURL", request) != null)
			{
				model.addAttribute("wsflogouturl", SessionHelper.getVariable("launcherURL", request) + "/logout");
			}
			else
			{
				Optional<Cookie> co =  Arrays.stream(request.getCookies()).filter(c -> c.getName().equals("referer")).findFirst();				
				model.addAttribute("wsflogouturl", co.get().getValue() + "/logout");
			}
			
			SessionHelper.removeSession(session);			
			
		} 
		catch (Exception e) 
		{
			LOGGER.error("Error while loading federation properties",e);
		}
	}
}
