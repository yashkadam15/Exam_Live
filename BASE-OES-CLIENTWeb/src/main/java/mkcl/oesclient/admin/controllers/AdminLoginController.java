package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Random;
import java.util.concurrent.ExecutorService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oes.commons.CaptchaUtil;
import mkcl.oesclient.admin.services.AdminDashboardServiceImpl;
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
import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModel;

@Controller
@RequestMapping("adminLogin")
public class AdminLoginController 
{
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminLoginController.class);
	private String LOGINPAGE = "Admin/adminLogin/adminLogin";
	private static final String USER="user";
	private static ExecutorService threadPool;
	
	/**
	 * Get method for Login
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "loginpage", method = RequestMethod.GET)
	public String loginGet(Model model, HttpSession session, String messageid, Locale locale) {
		try 
		{
			if (messageid != null && !messageid.equals("")) {
				addMessage(Integer.parseInt(messageid), model, locale);
			}

			// code to get app version details
			model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
			
		}
		catch(Exception e)
		{
			LOGGER.error("Exception occured in loginGet: " ,e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e);
			return Constants.ERRORPAGE;
		}
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		addRNum(model, session);
				
		model.addAttribute(USER, new VenueUser());
		model.addAttribute("logintype", LoginType.Admin);
		/*SessionHelper.SetSession(null, LoginType.Admin, null, new VenueUser(), null,session);*/
		return LOGINPAGE;
	}
	
	/**
	 * Post method for Login
	 * @param model
	 * @param user
	 * @param session
	 * @param errors
	 * @param locale
	 * @param request
	 * @param redirectAttributes
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "loginpage" }, method = RequestMethod.POST)
	public String loginPost(Model model, @ModelAttribute(USER) VenueUser user, HttpSession session, BindingResult errors, Locale locale, HttpServletRequest request,final RedirectAttributes redirectAttributes, HttpServletResponse response) {
		String returnDashBoard = "";
		try {

			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			VenueUser dbUser = new LoginServiceImpl().getAdminUserByUsername(user.getUserName());
						
			if (request.getParameter("captcha") == null || request.getParameter("captcha").isEmpty() || !CaptchaUtil.validateCaptcha(session,  request.getParameter("captcha"))) {
				MKCLUtility.addMessage(MessageConstants.INVALID_CAPTCHA, model, locale);
				model.addAttribute(USER, user);
				model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
				addRNum(model, session);
				return LOGINPAGE;
			}
			
			if (dbUser == null) {
				MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);
				model.addAttribute(USER, user);
				model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
				addRNum(model, session);
				return LOGINPAGE;
			}
			
			// get salt added hash value
			md5Helper md5 = new md5Helper();
			String saltMd5 = md5.getsaltMD5(dbUser.getPassword(),SessionHelper.getVariable("rnum", request).toString());
			
			if (!saltMd5.equals(user.getPassword())) {
				MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);
				model.addAttribute(USER, user);
				model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
				addRNum(model, session);
				return LOGINPAGE;
			}
			//Added one more role i.e. Call Center(4) for that added condition Yograj 24-Jun-2016
			if(dbUser.getFkRoleID()!=1 && dbUser.getFkRoleID()!=2 && dbUser.getFkRoleID()!=4 && dbUser.getFkRoleID()!=5)
			{
				MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);
				addRNum(model, session);
				return LOGINPAGE;
			}
			List<VenueUser> venueUserList=new ArrayList<VenueUser>();
			venueUserList.add(dbUser);
			session = SessionHelper.SetSession(null,LoginType.Admin, venueUserList, null,0,null, request, response);

			new LoginServiceImpl().updateLastLoginDeatilsByUserId(dbUser.getUserID(),OESLogger.getHostAddress(request),LoginType.Admin);
			MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);
			model.addAttribute(USER, user);
			
			boolean isGroupEnabled=false;
			
			// check autoupload status from property file
			boolean isAutoUploadOn = Boolean.parseBoolean(getAutoUploadStatus("AutoUpload"));
			
			if (dbUser.getFkRoleID() == 1 || dbUser.getFkRoleID()==4) {
				//set Is group enable exame evnt
				isGroupEnabled=new ExamEventServiceImpl().isGroupEnabledExamEvent();
				SessionHelper.setExamEventIsGroupEnabled(session,isGroupEnabled);
				
				//start candidate data upload
				if(dbUser.getFkRoleID() == 1 && isAutoUploadOn)
				{
					redirectAttributes.addFlashAttribute("uploadInfo", "1");
				}
				returnDashBoard = "redirect:../dashboard/adminDashBoard";
			}
			if (dbUser.getFkRoleID() == 2) {
				//set Is group enable exame evnt
				isGroupEnabled=new ExamEventServiceImpl().isGroupEnabledExamEvent();
				SessionHelper.setExamEventIsGroupEnabled(session,isGroupEnabled);
			
				//start candidate data upload
				if(isAutoUploadOn){
					redirectAttributes.addFlashAttribute("uploadInfo", "1");
					}
				returnDashBoard = "redirect:../dashboard/subjectAdminDashBoard";
			}
			if (dbUser.getFkRoleID() == 5) {
				returnDashBoard = "redirect:../ddtdashboard/ddtDashBoard";
			}

			if(session != null && SessionHelper.getVariable("rnum", request) != null ) {
				SessionHelper.removeVariable("rnum", request);
			}
			return returnDashBoard;
		} catch (Exception ex) {
			LOGGER.error("Exception occured in loginPost: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
	}
	
	/**
	 * Get method for Log out
	 * @param model
	 * @param session
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "logout" }, method = RequestMethod.GET)
	public String logOutGet(Model model, HttpSession session, String messageid, Locale locale) {
		model.addAttribute(USER, new VenueUser());
		SessionHelper.removeSession(session);
		addMessage(Integer.parseInt(messageid), model, locale);
		return "redirect:../adminLogin/loginpage";
	}
	
	/**
	 * Get method for Score Card
	 * @param model
	 * @param messageid
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "scoreCard" }, method = RequestMethod.GET)
	public String scoreCard(Model model, String messageid, Locale locale,HttpServletRequest request) {
		List<ExamDisplayCategoryPaperViewModel> candidateExamList=null;
		if(request.getParameter("loginId")!=null && !request.getParameter("loginId").isEmpty())
		{
			model.addAttribute("loginId", request.getParameter("loginId"));
			candidateExamList=new AdminDashboardServiceImpl().getCandidateResultByCandidateLoginId(request.getParameter("loginId"));
		}
		model.addAttribute("candidateExamList", candidateExamList);
		return "Admin/adminLogin/scoreCard";
	}
	
	
	
	private void addMessage(Integer messageid, Model model, Locale locale) {
		if (messageid != null && !messageid.equals("")) {
			MKCLUtility.addMessage(messageid, model, locale);
		}
	}
	
	/**
	 * Method for Auto Upload Status
	 * @param propertyName
	 * @return String  the returns the auto upload status
	 */
	public String getAutoUploadStatus(String propertyName) {
		Properties properties = null;
		try {
			properties = MKCLUtility.loadMKCLPropertiesFile();
		} catch (Exception e) {
			properties = null;
		}
		if (properties == null || properties.isEmpty()) {
			return null;
		}
		String autoUpload = properties.getProperty(propertyName);
		if (autoUpload != null && !autoUpload.isEmpty()) {
			return autoUpload;
		} else {
			return null;
		}
	}
	
	private void addRNum(Model model, HttpSession session) {
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
	}
	
}
