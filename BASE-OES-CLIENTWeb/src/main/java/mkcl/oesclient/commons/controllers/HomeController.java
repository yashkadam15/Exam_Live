package mkcl.oesclient.commons.controllers;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.OESAppInfoServicesImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.OESAppInfo;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.os.security.AESHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.theme.SessionThemeResolver;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	@Autowired
	ExamLocaleThemeResolver examLocaleThemeResolver;
	/*
	 * Simply selects the home view to render by returning its name.
	 */
	/**
	 * Get method for home
	 * @param locale
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model,HttpServletRequest request,HttpServletResponse response,HttpSession session) {
		
		//Reena : 30 July 2015 : remove User Session and set Default Locale
		try {			
			SessionHelper.removeSession(session);
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);
			} catch (Exception e) {
			logger.error("Error while removing user session and setting default locale in home : "+e);
			}
		logger.info("Welcome OES-Client! The client locale is {}.", locale);
					
		model.addAttribute("webVersion", AppInfoHelper.appInfo.getWebVersion());
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());		
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		return "/Common/Home/homepage";
		
	}	
	
	/**
	 * Get method for Launcher
	 * @param model
	 * @param request
	 * @param response
	 * @param session
	 * @param u
	 * @param l
	 * @param redir
	 * @return String this returns the path of a view
	 * @throws Exception
	 */
	@RequestMapping(value = "/launcher", method = RequestMethod.GET)
	public String launcher(Model model,HttpServletRequest request,HttpServletResponse response,HttpSession session, String u,String l, RedirectAttributes redir) throws Exception 
	{
		redir.addFlashAttribute("user", AESHelper.decrypt(u, EncryptionHelper.encryptDecryptKey));
		if(Boolean.parseBoolean(MKCLUtility.loadMKCLPropertiesFile().getProperty("enableWsFederationAuth", "false")))
		{
			redir.addFlashAttribute("lurl", l);
			return "redirect:wsfAuth/login";
		}
		return "redirect:login/eventSelection";
	}
}
