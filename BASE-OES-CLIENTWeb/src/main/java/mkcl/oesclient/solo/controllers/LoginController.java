package mkcl.oesclient.solo.controllers;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
/**
 * Author Yograj
 */
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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

import mkcl.baseoesclient.model.LoginType;
import mkcl.oes.commons.CaptchaUtil;
import mkcl.oesclient.commons.controllers.OESLogger;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.utilities.md5Helper;
import mkcl.oespcs.model.ExamEvent;

@Controller("SoloLoginController")
@RequestMapping("soloLogin")
public class LoginController {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);
	private String LOGINPAGE = "Solo/soloLogin/soloLoginpage";	
	private static final String USER="user";
	private static final String LOGINSTATUS = "loginStatus";
	private static final String USERAGENT = "userAgent";
	private static final String LOGIN = "Login";
	private static final String CAPTCHACODE="captchaCode";
	
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
	 * Post method for Login
	 * @param model
	 * @param user
	 * @param session
	 * @param errors
	 * @param locale
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "loginpage" }, method = RequestMethod.POST)
	public String loginPost(Model model, @ModelAttribute(USER) VenueUser user, HttpSession session, BindingResult errors, Locale locale, HttpServletRequest request, HttpServletResponse response) {
		try {
			
			if(request.getParameter("examEventID")==null || request.getParameter("loginType")==null)
			{
				return "redirect:../login/eventSelection";
			}
			
			//Candidate candidate=null;			
			ExamEvent examEvent=new ExamEventServiceImpl().getExamEventByID(Long.parseLong(request.getParameter("examEventID")));
			VenueUser dbUser = new LoginServiceImpl().getCandidateByUsernameEventID(user.getUserName(), examEvent.getExamEventID());
			
			if (session == null || session.getAttribute(CAPTCHACODE) == null) {
				MKCLUtility.addMessage(MessageConstants.ERROR_INVALID_SESSION, model, locale);
				buildLoginObject(model, request, session, user, examEvent.getName());
				return LOGINPAGE;
			}
			if (request.getParameter("captcha") == null || request.getParameter("captcha").isEmpty() || !CaptchaUtil.validateCaptcha(session,  request.getParameter("captcha"))) {
				MKCLUtility.addMessage(MessageConstants.INVALID_CAPTCHA, model, locale);
				buildLoginObject(model, request, session, user, examEvent.getName());
				return LOGINPAGE;
			}
			
			if (dbUser == null) {
				MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);
				buildLoginObject(model, request, session, user, examEvent.getName());
				return LOGINPAGE;
			}			
			if (dbUser.getFkRoleID()!=3) { // 1: admin, 2: subject admin, 3: candidate Login
				MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);
				buildLoginObject(model, request, session, user, examEvent.getName());
				return LOGINPAGE;
			}			
			if(SessionHelper.getVariable("rnum", request) == null ) {
				MKCLUtility.addMessage(MessageConstants.ERROR_INVALID_SESSION, model, locale);
				buildLoginObject(model, request, session, user, examEvent.getName());
				return LOGINPAGE;
			}
			
			// get salt added hash value
			md5Helper md5 = new md5Helper();
			String saltMd5 = md5.getsaltMD5(dbUser.getPassword(), SessionHelper.getVariable("rnum", request).toString());
		
			if (!saltMd5.equals(user.getPassword())) {
				MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);
				buildLoginObject(model, request, session, user, examEvent.getName());
				return LOGINPAGE;
			}
			
			if(AppInfoHelper.appInfo.getIsERAAuthenticationRequired())
			{
				if(AppInfoHelper.appInfo.getEraAuthenticationAPIIP()==null || AppInfoHelper.appInfo.getEraAuthenticationAPIIP().isEmpty())
				{
					model.addAttribute("messageText", "ERA Aadhar API URL not Configured. Please contact LF to configure it and try again.");
					model.addAttribute("message", "failure");
					buildLoginObject(model, request, session, user, examEvent.getName());
					return LOGINPAGE;
				}
				String candidateCodeForAuth=dbUser.getMkclIdentificationNumber().length()>8?dbUser.getMkclIdentificationNumber().substring(0,8):dbUser.getMkclIdentificationNumber();
				String result = callERAAuthAPI(candidateCodeForAuth);
				if(!result.equals("true"))
				{
					if(!result.equals("false"))
					{
						model.addAttribute("messageText", result);
					}
					else
					{
						model.addAttribute("messageText", "Your biomatric attendance is not marked for the day.");
					}
					model.addAttribute("message", "failure");
					buildLoginObject(model, request, session, user, examEvent.getName());
					return LOGINPAGE;
				}
			}
			
			
			LoginType logType= LoginType.valueOf(request.getParameter("loginType"));
			List<VenueUser> venueUserList=new ArrayList<VenueUser>();
			//candidate = new CandidateServiceImpl().getCandidateByCandidateUsername(dbUser.getUserName());
			long collectionID=Long.parseLong(dbUser.getObject().toString());
			dbUser.setObject(dbUser.getUserID());
			venueUserList.add(dbUser);
			
			SessionHelper.SetSession(examEvent,logType,venueUserList , null,collectionID, null,request, response);
			
			//new LoginServiceImpl().updateLastLoginDeatilsByUserId(dbUser.getUserID());
			new LoginServiceImpl().updateLastLoginDeatilsByUserId(dbUser.getUserID(),OESLogger.getHostAddress(request),LoginType.Solo);			
			MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);

			/*Start of Combo Generation code*/
			//Combo Generation commented by amoghs; on 21 Aug 2018 as combo paper generation will no more support due to primary key in CE; hence ItemBank group impact is not handled in combo paper generation service
			/*List<Long> displayCategoryIdList=null;
			if(examEvent!=null)
			{
				List<ExamEventScheduleTypeAssociation> examEventScheduleTypeAssociationList=new GenerateComboServiceImpl().getEventScheduleTypeAssociationList(examEvent.getExamEventID());
				Properties properties=MKCLUtility.loadMKCLPropertiesFile();
				Collection wise Combo Generation
				if(examEvent.getLocalSchedular()==LocalSchedular.Admin)
				{
					for (ExamEventScheduleTypeAssociation examEventScheduleTypeAssociation : examEventScheduleTypeAssociationList)
					{
						if(examEventScheduleTypeAssociation.getIsComboRequired())
						{
							displayCategoryIdList=new GenerateComboServiceImpl().getCandidateDisplayCategoryList(dbUser.getUserID(), examEvent.getExamEventID(),examEventScheduleTypeAssociation.getScheduleType());
							for (Long displayCategoryId : displayCategoryIdList) {
									new GenerateComboServiceImpl().genrateCombo(dbUser.getUserID(), displayCategoryId, properties,  examEventScheduleTypeAssociation,SessionHelper.getLogedInUser(request).getUserName());
							}
						}
					}
				}
				end of collection wise Combo Generation
				
				Candidate wise Combo Generation
				if(examEvent.getLocalSchedular()==LocalSchedular.Candidate)
				{
					for (ExamEventScheduleTypeAssociation examEventScheduleTypeAssociation : examEventScheduleTypeAssociationList)
					{
						if(examEventScheduleTypeAssociation.getIsComboRequired())
						{
							displayCategoryIdList=new GenerateComboServiceImpl().getCandidateDisplayCategoryList(dbUser.getUserID(), examEvent.getExamEventID(),examEventScheduleTypeAssociation.getScheduleType());
							for (Long displayCategoryId : displayCategoryIdList) {
									new GenerateCandidateComboServiceImpl().genrateCandidatewiseCombo(dbUser.getUserID(), displayCategoryId, properties,  examEventScheduleTypeAssociation,SessionHelper.getLogedInUser(request).getUserName());
							}
						}
					}
				}
			}*/
			/*End of Combo Generation code*/
			

			if(SessionHelper.getVariable("rnum", request) != null ) {
				SessionHelper.removeVariable("rnum", request);
			}
			return "redirect:../candidateModule/homepage";
		} catch (Exception ex) {
			LOGGER.error("Exception occured in solo loginPost: " , ex);
			//model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		finally {
			
		}

	}

	/**
	 * Method to add message
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
	 * Method to add random number
	 * @param model
	 * @param session
	 */
	private void addRNum(Model model, HttpSession session) {
		/*************************************/
		try {
			Random random = new Random();
			int rnum = random.nextInt(100);
			model.addAttribute("soloRnum", rnum);
			SessionHelper.addVariable("rnum", rnum, session);
		}catch (Exception ex) {
			LOGGER.error("Exception occured in eventSelection-solorandomnumber-generation: ", ex);
		}

		/*************************************/
	}
	
	/**
	 * Method to Call ERA Authentication API
	 * @param candidateCodeForAuth
	 * @return String this returns the response
	 * @throws MalformedURLException
	 * @throws IOException
	 * @throws ProtocolException
	 * @throws Exception
	 */
	private String callERAAuthAPI(String candidateCodeForAuth) throws MalformedURLException, IOException, ProtocolException,Exception 
	{
		URL url = new URL("http://"+AppInfoHelper.appInfo.getEraAuthenticationAPIIP()+":4337/o/biometric/checklearnerattendancevalidity/"+candidateCodeForAuth);
		//URL url = new URL("http://localhost:8081/OES-CLIENTWeb/SyncApi/candidateStatus/"+candidateCodeForAuth);
		
		String readLine=null;
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setRequestMethod("GET");
		int responseCode=connection.getResponseCode();
		StringBuffer resp= new StringBuffer();
		if(responseCode==HttpURLConnection.HTTP_OK)
		{
			BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			while((readLine=in.readLine())!=null)
			{
				resp.append(readLine);
			}
			in.close();
			return resp.toString();
		}
		else 
		{
			BufferedReader in = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
			while((readLine=in.readLine())!=null)
			{
				resp.append(readLine);
			}
			in.close();
			return "Learner not found in ERA. Error Code - "+responseCode+" : "+resp.toString();
		}
	}
	
	public void buildLoginObject(Model model, HttpServletRequest request, HttpSession session, VenueUser user, String eventName) throws Exception {
		try {
			SessionHelper.removeVariable(USER, request);
			SessionHelper.removeVariable(LOGINSTATUS, request);	
			SessionHelper.removeVariable(USERAGENT, request);
			SessionHelper.removeVariable(LOGIN, request);

			addRNum(model, session);			
			user.setPassword(null);
			
			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			
			model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion()); //Code to get app version details
			model.addAttribute("eventName", eventName);
			model.addAttribute(USER, user);
			model.addAttribute("examEventID",request.getParameter("examEventID"));
			model.addAttribute("loginType",request.getParameter("loginType"));
			model.addAttribute("todayDate", new Date());
		} catch(Exception ex) {
			throw ex;
		}
	}
	
	
}
