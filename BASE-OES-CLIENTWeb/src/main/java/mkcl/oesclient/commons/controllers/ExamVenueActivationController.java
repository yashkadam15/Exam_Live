package mkcl.oesclient.commons.controllers;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Properties;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.MessageSource;
import org.springframework.context.support.DelegatingMessageSource;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.systemaudit.AuditVerificationMethods;
import mkcl.oesclient.utilities.EvidenceFileUploader;
import mkcl.oesclient.viewmodel.ExamVenueActivationViewModel;

@Controller
@RequestMapping("activateVenue")
public class ExamVenueActivationController implements ApplicationContextAware{
	private static final Logger LOGGER = LoggerFactory.getLogger(ExamVenueActivationController.class);
	ReloadableResourceBundleMessageSource r = null;
	EvidenceFileUploader uploader = null; 
	
	@Autowired
	private AppInfoHelper appInfo;
	
	/**
	 * Get method for Venue Registration
	 * @param model
	 * @param req
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/venueRegistration" }, method = RequestMethod.GET)
	public String getVenuRegistrationForm(Model model,HttpServletRequest req, String messageid,Locale locale) {
		HttpSession session = req.getSession(); 
		try {
			ExamVenueActivationServicesImpl objExamVenueActivationServicesImpl = new ExamVenueActivationServicesImpl();
			// If venue is already registered show message
			if(objExamVenueActivationServicesImpl.isExamVenueRegistered())
			{
				return "redirect:../login/eventSelection?messageid=46";
			}
			
			if (messageid!=null && messageid!="") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
			// code to get app version details
				model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
				
				/*Random random = new Random();
				int rnum = random.nextInt(100);*/
				model.addAttribute("rnum", 95);
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getVenuRegistrationForm: " ,ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		model.addAttribute("clientid", 0);
		return "Common/ExamVenue/examVenueRegistration";
	}

	/**
	 * Post method for Venue Registration
	 * @param request
	 * @param model
	 * @param locale
	 * @param venueCode
	 * @param password
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/venueRegistration" }, method = RequestMethod.POST)
	public String postVenuRegistrationForm(HttpServletRequest request,Model model, Locale locale,
			String venueCode, String password) {
		boolean flag = false;
		try {
			ExamVenueActivationServicesImpl objExamVenueActivationServicesImpl = new ExamVenueActivationServicesImpl();
			// If venue is already registered show message
			if(objExamVenueActivationServicesImpl.isExamVenueRegistered())
			{
				return "redirect:../login/eventSelection?messageid=46";
			}
			
			if (venueCode != null && password != null) {
				
				String appName =  AppInfoHelper.appInfo.getAppName();
				Format formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
				String activitytime = formatter.format(new Date());
				
				ExamVenueActivationViewModel evActivation = objExamVenueActivationServicesImpl
						.getExamVenueActivationViewModel(venueCode,password,appName,activitytime);

				// save all objects of viewModel

				if (evActivation == null || evActivation.getVenueUser() == null) {
					return "redirect:/activateVenue/venueRegistration?messageid=39";
				} else {
					flag = objExamVenueActivationServicesImpl
							.saveExamVenueActivationViewModel(evActivation);

				}
			}
		
		if (flag) {
			
			//load application info
			appInfo.setApplicationInfo();
			//Code For dynamic logo render:13-july-2015:Yograjs
			long clientID=AppInfoHelper.appInfo.getClientID();
			
			/*Changes  for client wise property loading Yograj:15-July-2015*/
			MKCLUtility.loadClientPropertiesFile(String.valueOf(clientID));
			/*reloading of Property files*/
			r.clearCacheIncludingAncestors();	
			uploader.startEvidenceUpload();
			
			return "redirect:../activateVenue/venueRegistrationMsg?messageid="
					+ MessageConstants.SUCCESSFULLY_ADDED_VENUE;
		} else {
			return "redirect:/activateVenue/venueRegistration?messageid=39";
		}
		}  catch (Exception ex) {
			LOGGER.error("Exception occured in postVenuRegistrationForm: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
	}
	
	/**
	 * Get method for Venue Registration 
	 * @param model
	 * @param messageid
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/venueRegistrationMsg" }, method = RequestMethod.GET)
	public String venueRegistrationMsg(Model model, String messageid) 
	{
		try {
			
			model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
			//Code For dynamic logo render:13-july-2015:Yograjs
			model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
			model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in venueRegistrationMsg: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Common/ExamVenue/venueRegistrationMsg";
	}

	@Override
	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		r=(ReloadableResourceBundleMessageSource) ((DelegatingMessageSource) ((MessageSource)applicationContext.getBean("messageSource"))).getParentMessageSource();
		uploader=(EvidenceFileUploader)applicationContext.getBean("evidenceFileUploader");
	}
}
