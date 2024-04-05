/**
 * 
 */
package mkcl.oesclient.appmanager.controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.appmanager.model.PropertiesModel;
import mkcl.oesclient.appmanager.utilities.PropertiesService;
import mkcl.oesclient.appmanager.utilities.ServerReload;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.os.security.AESHelper;

/**
 * @author rakeshb
 *
 */

@Controller
@RequestMapping("appmanager")
public class AppManagerController {
	private static final Logger LOGGER = LoggerFactory.getLogger(AppManagerController.class);
	private String LOGIN = "app/manager/appManagerLogin";
	private static final String USERNAME = "VywkwDvpPkGqeBQpSB7ZCA==";
	private static final String PASSWORD = "NPL4KjmH6GFqExSjwc0fIw==";

	PropertiesService propertiesService = new PropertiesService();

	/**
	 * Get method for Application Manager Login
	 * @param locale
	 * @param model
	 * @param session
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String appManagerLogin(Locale locale, Model model, HttpSession session, HttpServletRequest request) {
		try {
			String messageid = request.getParameter("messageid");
			if (messageid != null && !messageid.equals("")) {
				addMessage(Integer.parseInt(messageid), model, locale);
			}
			model.addAttribute("user", new VenueUser());
		} catch (Exception e) {
			LOGGER.error("Exception occured in appManagerLogin...", e);
		}
		return LOGIN;
	}

	/**
	 * Post method for Login
	 * @param model
	 * @param user
	 * @param locale
	 * @param request
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String loginPost(Model model, @ModelAttribute("user") VenueUser user, Locale locale,
			HttpServletRequest request, HttpServletResponse response) {

		try {

			if (user.getUserName() != null && user.getPassword() != null) {
				if (!AESHelper.decrypt(USERNAME, EncryptionHelper.encryptDecryptKey).equals(user.getUserName())) {
					MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);
					return LOGIN;
				}
				if (!AESHelper.decrypt(PASSWORD, EncryptionHelper.encryptDecryptKey).equals(user.getPassword())) {
					MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);
					return LOGIN;
				}
			} else {
				MKCLUtility.addMessage(MessageConstants.INVALID_USERNAME, model, locale);// please fill mandatory field
				return LOGIN;
			}

			List<VenueUser> venueUserList = new ArrayList<VenueUser>();
			venueUserList.add(user);
			SessionHelper.SetSession(null, null, venueUserList, null, 0, null, request, response);

			MKCLUtility.addMessage(MessageConstants.SUCCESSFULLY_LOGIN, model, locale);
			model.addAttribute("user", user);

		} catch (Exception ex) {
			LOGGER.error("Exception occured in loginPost: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "redirect:selectPropertiesFile";
	}

	/**
	 * Get method for Logout
	 * @param model
	 * @param session
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "logout", method = RequestMethod.GET)
	public String logOutGet(Model model, HttpSession session, Locale locale, HttpServletRequest request) {
		try {
			SessionHelper.removeSession(session);

		} catch (Exception e) {
			LOGGER.error("Exception occured in logOutGet...", e);
		}
		return "redirect:../appmanager/login?messageid=" + MessageConstants.SUCCESSFULLY_LOGOUT;
	}

	/**
	 * Get method for Reload Server
	 * @param locale
	 * @param model
	 * @param session
	 * @param request
	 * @param update
	 * @param reload
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/reload" }, method = RequestMethod.GET)
	public String reloadServerGet(Locale locale, Model model,HttpSession session, HttpServletRequest request, String update, String reload) {
		LOGGER.info("reload in reloadServerGet..");
		try {
			//if properties update successful restart server
			if (Boolean.valueOf(update)) {
				model.addAttribute("update", update);
			}
			
			if (Boolean.valueOf(reload)) {
				addMessage(MessageConstants.SUCCESSFULLY_SERVER_RESTART, model, locale);
			}	
			
			String hostName = request.getServerName();
			model.addAttribute("hostName", hostName);		
	    	
			String applicationName = request.getSession().getServletContext().getContextPath();
			//String applicationName =  request.getServletContext().getContextPath();
			if(applicationName != null && applicationName != "") {
				applicationName = applicationName.substring(1);
			}	    	
	    	model.addAttribute("applicationName", applicationName);
	    	
		} catch (Exception e) {
			LOGGER.error("Exception occured in reloadServerGet...",e);
		}
		return "app/manager/reloadServer";
	}

	/**
	 * Post method for Reload Application
	 * @param reload
	 * @param request
	 * @return boolean this returns true on success
	 */
	@RequestMapping(value = "/reloadApp.ajax", method = RequestMethod.POST)
	@ResponseBody
	public boolean reloadApp(@RequestBody String reload, HttpServletRequest request) {
		try {
			ServerReload.shutdownApp(request);

		} catch (Exception e) {
			LOGGER.error("Exception occured in reloadApp...", e);
		}
		return true;
	}

	/**
	 * Post method for After Reload Refresh
	 * @param reload
	 * @param request
	 * @return boolean this returns true on success
	 */
	@RequestMapping(value = "/afterReloadRefresh.ajax", method = RequestMethod.POST)
	@ResponseBody
	public boolean afterReloadRefresh(@RequestBody String reload, HttpServletRequest request) {
		try {
			LOGGER.info("Refresh...");

		} catch (Exception e) {
			LOGGER.error("Exception occured in afterReloadRefresh...", e);
		}
		return true;
	}

	private void addMessage(Integer messageid, Model model, Locale locale) {
		if (messageid != null) {
			MKCLUtility.addMessage(messageid, model, locale);
		}
	}

	/**
	 * Get method for Properties File
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/selectPropertiesFile", method = RequestMethod.GET)
	public String selectLanguagePage(Model model, HttpServletRequest request, Locale locale) {

		try {
			
			String messageid = request.getParameter("messageid");
			if (messageid != null && !messageid.equals("")) {
				addMessage(Integer.parseInt(messageid), model, locale);
			}

			List<String> fileList = PropertiesService.listOfPropertiesFile(request);
			model.addAttribute("propObj", new PropertiesModel());
			model.addAttribute("fileList", fileList);

		} catch (Exception ex) {
			LOGGER.error("Exception occured in selectPropertiesFile: ", ex);
		}
		return "app/manager/selectPropertiesFile";
	}

	/**
	 * Post method to Display Properties File
	 * @param locale
	 * @param request
	 * @param model
	 * @param propertiesModel
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/showPropertiesPage", method = RequestMethod.POST)
	public String home(Locale locale, HttpServletRequest request, Model model,
			@ModelAttribute("propObj") PropertiesModel propertiesModel) {
		// PropertiesModel propertiesModel = new PropertiesModel();

		String selectedFile = propertiesModel.getSelectedFile();
		propertiesModel.setSelectedFile(selectedFile);
		Map<String, String> map = new HashMap<String, String>();
		try {

			map = propertiesService.readValues(selectedFile);
			propertiesModel.setMap(map);
			model.addAttribute("propertiesModel", map);

		} catch (Exception ex) {
			LOGGER.error("Exception occured in showPropertiesPage: ", ex);
		}

		return "app/manager/showPropertiesPage";
	}

	/**
	 * Post method to Update Properties File
	 * @param propertiesModel
	 * @param model
	 * @param locale
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/updateProperty", method = RequestMethod.POST)
	public String updatePropertiesFile(@ModelAttribute("proMap") PropertiesModel propertiesModel, Model model,Locale locale,
			HttpServletRequest request) {
		String url = "redirect:../appmanager/selectPropertiesFile";
		try {
			/*boolean serverReload = Boolean.parseBoolean(request.getParameter("serverReload"));		*/	
			boolean status = false;
			Map<String, String> updatedMap = propertiesModel.getMap();
			String totalPath = PropertiesService.getFilePath(request) + "\\" + propertiesModel.getSelectedFile();

			status = propertiesService.updatePropertyfile(updatedMap, request, totalPath);		
			
			/*if ( serverReload && status ) {
				LOGGER.info("Properties Updated Successfully..");
				return "redirect:../appmanager/reload?update="+status;
			}	*/		
			if (status) {
				LOGGER.info("Properties Updated Successfully..");
				return "redirect:../appmanager/reload?update="+status;
				/*System.out.println("Property file Updated");
				url = url + "?messageid=" + MessageConstants.SUCCESSFULLY_UPDATED;*/
				
			} else {
				/*System.out.println("Property file Update failed");*/
				LOGGER.info("Property file Update failed..");
				url = url + "?messageid=" + MessageConstants.FAILED_UPDATE;
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in updateProperty: ", ex);
		}
		return url;


	}
		

}
