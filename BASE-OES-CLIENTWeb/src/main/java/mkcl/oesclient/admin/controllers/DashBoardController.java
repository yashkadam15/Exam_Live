package mkcl.oesclient.admin.controllers;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.admin.services.AdminDashboardServiceImpl;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.uploader.service.CandidateExamDataUploaderService;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamStatusViewModel;
import mkcl.oesclient.viewmodel.IncompleteExamCandidateViewModel;
import mkcl.oespcs.model.ExamEvent;
import mkcl.os.security.AESHelper;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("dashboard")
public class DashBoardController {

	@Autowired
	private AppInfoHelper appInfo;
	private static final Logger LOGGER = LoggerFactory.getLogger(DashBoardController.class);

	/**
	 * Get method for Admin Dashboard
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/adminDashBoard" }, method = RequestMethod.GET)
	public String adminDashBoard(Model model, HttpServletRequest request, Locale locale) {
		try {
			String messageid = request.getParameter("messageId");
			boolean showAPIURLInputPopup=false;
			if(AppInfoHelper.appInfo.getIsERAAuthenticationRequired() && (AppInfoHelper.appInfo.getEraAuthenticationAPIIP()==null || AppInfoHelper.appInfo.getEraAuthenticationAPIIP().isEmpty()))
			{
				showAPIURLInputPopup=true;
			}
			if (messageid != null && messageid != "") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
			List<ExamStatusViewModel> candidateViewModelList=new AdminDashboardServiceImpl().getAllExamStatus();
			model.addAttribute("candidateViewModelList", candidateViewModelList);
			model.addAttribute("flag", request.getParameter("flag"));
			model.addAttribute("showAPIURLInputPopup", showAPIURLInputPopup);
			
		} catch (Exception e) {
			LOGGER.error("Exception Occured in adminDashBoard : ", e);
		}
		return "Admin/dashboard/adminDashboard";
	}

	/**
	 * Get method for Subject Admin Dashboard
	 * @param model
	 * @param request
	 * @param locale
	 * @param session
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/subjectAdminDashBoard" }, method = RequestMethod.GET)
	public String subjectAdminDashBoard(Model model, HttpServletRequest request, Locale locale, HttpSession session) {
		try {
			String messageid = request.getParameter("messageId");
			if (messageid != null && messageid != "") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured in subjectAdminDashBoard : ", e);
		}
		return "Admin/dashboard/subjectAdminDashboard";
	}

	/**
	 * Get method for Incomplete Exam Candidates
	 * @param model
	 * @param request
	 * @param locale
	 * @param session
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/incompleteExamCandidates" }, method = RequestMethod.GET)
	public String incompleteExamCandidates(Model model, HttpServletRequest request, Locale locale, HttpSession session) {
		try {
			long paperID=0;
			long examEventID=0;
			List<IncompleteExamCandidateViewModel> incompleteExamCandidateViewModelList=null;
			String messageid = request.getParameter("messageId");
			if (messageid != null && messageid != "") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
			if(request.getParameter("paperID")!=null && request.getParameter("examEventID")!=null)
			{
				paperID=Long.parseLong(request.getParameter("paperID"));
				examEventID=Long.parseLong(request.getParameter("examEventID"));
				if(paperID>0 && examEventID>0)
				{
					incompleteExamCandidateViewModelList=new AdminDashboardServiceImpl().getIncompleteCandidateExamDetails(paperID, examEventID);
				}
			}
			model.addAttribute("incompleteExamCandidateViewModelList", incompleteExamCandidateViewModelList);
			
		} catch (Exception e) {
			LOGGER.error("Exception Occured in incompleteExamCandidates : ", e);
		}
		return "Admin/dashboard/incompleteExamCandidates";
	}
	
	/**
	 * Get method for Upload Status
	 * @param model
	 * @param request
	 * @param locale
	 * @param session
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/uploadStatus" }, method = RequestMethod.GET)
	public String uploadStatusGet(Model model, HttpServletRequest request, Locale locale, HttpSession session) {
		try {
			List<ExamStatusViewModel> examStatusViewModelList=new AdminDashboardServiceImpl().getAllExamStatus();
			model.addAttribute("examStatusViewModelList", examStatusViewModelList);
		} catch (Exception e) {
			LOGGER.error("Exception Occured in uploadStatusGet : ", e);
		}
		return "Admin/dashboard/uploadStatus";
	}
		
	/**
	 * Get method for Candidate Details
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/candidateDetails" }, method = RequestMethod.GET)
	public String getCandidateDetails(Model model, HttpServletRequest request) {
		try {
			long paperID=0;
			long examEventID=0;
			List<IncompleteExamCandidateViewModel> candidateViewModelList=null; 
			if(request.getParameter("paperID")!=null && request.getParameter("examEventID")!=null)
			{
				paperID=Long.parseLong(request.getParameter("paperID"));
				examEventID=Long.parseLong(request.getParameter("examEventID"));
				if(paperID>0 && examEventID>0)
				{
					candidateViewModelList=new AdminDashboardServiceImpl().getCandidateDetails(paperID, examEventID, Byte.parseByte(request.getParameter("flag")));
				}
			}
			model.addAttribute("candidateViewModelList", candidateViewModelList);
			model.addAttribute("flag", request.getParameter("flag"));
			
		} catch (Exception e) {
			LOGGER.error("Exception Occured in getCandidateDetails : ", e);
		}
		return "Admin/dashboard/candidateDetails";
	}
	
	/**
	 * Post method to Save ERA URL for Authentication
	 * @param examEvent
	 * @param request
	 * @return boolean this returns true on success
	 */
	@RequestMapping(value = "/saveERAURLforAuth.ajax", method = RequestMethod.POST)
	@ResponseBody public boolean saveERAURLforAuth(@RequestBody ExamEvent examEvent, HttpServletRequest request) 
	{
		boolean isSaved=false;
		try 
		{
			//event.name is used as URL
			String url=examEvent.getName();
			updateProperty(request, url);
			isSaved=true;
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception occured in saveERAURLforAuth ",e);
			isSaved=false;
		}
		return isSaved;
	}

	/**
	 * Method to Update Property
	 * @param request
	 * @param url
	 * @throws Exception
	 */
	private void updateProperty(HttpServletRequest request, String url) throws Exception {
		String filePath = AppInfoHelper.appInfo.getAppPhysicalPath() + "resources/propertyFiles/iear.properties";
		if(new File(filePath).createNewFile())
			LOGGER.error("File not found. Created new File");
		PropertiesConfiguration config=new PropertiesConfiguration(filePath);
		url = url.substring(0, url.length() - (url.endsWith("/") ? 1 : 0));
		config.setProperty("iear", AESHelper.encrypt("true", EncryptionHelper.encryptDecryptKey));
		config.setProperty("ieari",AESHelper.encrypt(url, EncryptionHelper.encryptDecryptKey));
		config.save();
		appInfo.setApplicationInfo();
	}
	
	/**
	 * Get method to edit ERA URL
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/editERAURL" }, method = RequestMethod.GET)
	public String editERAURL(Model model, HttpServletRequest request, Locale locale) {
		try {
			String messageid = request.getParameter("messageid");
			if (messageid != null && messageid != "") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
			model.addAttribute("eraAPIURL", AppInfoHelper.appInfo.getEraAuthenticationAPIIP());
			
		} catch (Exception e) {
			LOGGER.error("Exception occured in editERAURL get: ", e);
		}
		return "Admin/dashboard/editERAURL";
	}
	
	/**
	 * Post method to Edit ERA URL
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/editERAURL" }, method = RequestMethod.POST)
	public String editERAURLPost(Model model, HttpServletRequest request, Locale locale) {
		try 
		{
			String eraURL=request.getParameter("eraURL");
			updateProperty(request, eraURL);
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception occured in editERAURL post: ", e);
			return "redirect:../dashboard/editERAURL?messageid=135";
		}
		return "redirect:../dashboard/editERAURL?messageid=136";
	}
	
	/**
	 * Post method to check ERA URL
	 * @param examEvent
	 * @param request
	 * @return boolean this returns true if URL is valid
	 */
	@RequestMapping(value = "/checkERAURL.ajax", method = RequestMethod.POST)
	@ResponseBody public boolean checkERAURL(@RequestBody ExamEvent examEvent, HttpServletRequest request) 
	{
		boolean isValid=false;
		try 
		{
			//event.name is used as URL
			URL url = new URL(examEvent.getName());
			
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
				LOGGER.error("checkERAURL HTTP Status: "+responseCode+" : Info :"+resp);
				return true;
			}
			else 
			{
				BufferedReader in = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
				while((readLine=in.readLine())!=null)
				{
					resp.append(readLine);
				}
				in.close();
				LOGGER.error("checkERAURL HTTP Status: "+responseCode+" : Error :"+resp);
				return false;
			}
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception occured in checkERAURL ",e);
			isValid=false;
		}
		return isValid;
	}
}
