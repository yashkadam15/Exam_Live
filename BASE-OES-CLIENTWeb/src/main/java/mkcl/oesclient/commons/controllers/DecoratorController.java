package mkcl.oesclient.commons.controllers;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oesclient.commons.utilities.AppInfoHelper;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;

@Controller
public class DecoratorController {

	/**
	 * Get method for Decorator Details Theme
	 * @param model
	 * @param request
	 * @param locale
	 * @param detailstheme
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/decorators/{detailstheme}", method = RequestMethod.GET)
	public String decoratorGet(Model model, HttpServletRequest request, Locale locale, @PathVariable("detailstheme") String detailstheme,HttpServletResponse response) 
	{
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		model.addAttribute("loginType", SessionHelper.getLoginType(request));
		List<VenueUser> venueUserList = SessionHelper.getLogedInUsers(request);
		model.addAttribute("venueUserList", venueUserList);

		model.addAttribute("iear", AppInfoHelper.appInfo.getIsERAAuthenticationRequired());
		if (SessionHelper.getLoginType(request) == LoginType.Admin) {
			model.addAttribute("roleID", venueUserList.get(0).getFkRoleID());
			model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath"));
		} else {
			if (SessionHelper.getLoginType(request) == LoginType.Group) {
				model.addAttribute("group", SessionHelper.getGroupMaster(request));
			}
			model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(request, "CandidatePhotoUploadPath"));
		}
		
		// notification url
		model.addAttribute("notificationUrl", getNotificationUrlPath(request, "notificationUrl"));
					
		return "/decorators/" + detailstheme;
	}

	/**
	 * Post method for Decorator Details Theme
	 * @param model
	 * @param request
	 * @param locale
	 * @param detailstheme
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/decorators/{detailstheme}", method = RequestMethod.POST)
	public String decoratorPost(Model model, HttpServletRequest request, Locale locale, @PathVariable("detailstheme") String detailstheme,HttpServletResponse response) 
	{
		
		//Code For dynamic logo render:13-july-2015:Yograjs
		model.addAttribute("clientid", AppInfoHelper.appInfo.getClientID());
		
		model.addAttribute("isCopyRightEnabled", AppInfoHelper.appInfo.getIsCopyRightEnabled());
		model.addAttribute("loginType", SessionHelper.getLoginType(request));
		List<VenueUser> venueUserList = SessionHelper.getLogedInUsers(request);
		model.addAttribute("venueUserList", venueUserList);
		model.addAttribute("iear", AppInfoHelper.appInfo.getIsERAAuthenticationRequired());
		if (SessionHelper.getLoginType(request) == LoginType.Admin) {
			model.addAttribute("roleID", venueUserList.get(0).getFkRoleID());
			model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath"));
		} else {
			model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(request, "CandidatePhotoUploadPath"));
		}
		
		// notification url
		model.addAttribute("notificationUrl", getNotificationUrlPath(request, "notificationUrl"));
		
		return "/decorators/" + detailstheme;
	}

	/**
	 * Method for Notification URL Path
	 * @param request
	 * @param propertyName
	 * @return String this returns the URL path
	 */
	private String getNotificationUrlPath(HttpServletRequest request, String propertyName) {
		Properties properties = null;
		try {
			properties = MKCLUtility.loadMKCLPropertiesFile();
		} catch (Exception e) {
			properties = null;
		}
		if (properties == null || properties.isEmpty()) {
			return null;
		}
		String path = properties.getProperty(propertyName);
		if (path != null && !path.isEmpty()) {
			return path;
		} else {
			return null;
		}
	}

}
