package mkcl.oesclient.commons.controllers;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.systemaudit.AuditVerificationMethods;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("audit")
public class AuditVerificationController 
{
	/**
	 * Get method for Default 
	 * @param model
	 * @return String this returns the path of a view
	 */
    @RequestMapping(value = {"", "/"}, method = RequestMethod.GET)
	public String DefaultMethod(Model model)
	{
    	return "audit/pleaseWait";
	}

    /**
     * Get method for Verification
     * @param model
     * @param request
     * @return ResponseEntity<?> this returns the response status 
     */
	@RequestMapping(value = "/verification", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<?> verification(Model model, HttpServletRequest request) 
	{
		return new ResponseEntity<String>(verification(request), HttpStatus.OK);
	}
	
	/**
	 * Get method for Verification Status
	 * @param model
	 * @param locale
	 * @param request
	 * @param verificationStatus
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/deny/{verificationStatus}", method = RequestMethod.GET)
	public String comfirmation(Model model, Locale locale,HttpServletRequest request ,@PathVariable("verificationStatus") String verificationStatus) {
		String message =  MKCLUtility.getMessagefromKey(locale, "audit." + verificationStatus);
		if (message == null || message.isEmpty()) {
			message =  MKCLUtility.getMessagefromKey(locale,"audit.appsVerificationFailed");
		}
		model.addAttribute("message", message);
		
		return "audit/verification";
	}
	
	/**
	 * Method for Verification
	 * @param request
	 * @return String this returns the verification status
	 */
	private String verification(HttpServletRequest request) 
	{
		//check system time zone
		if (!AuditVerificationMethods.verifyTimeZone()) {
			return "appsTimeZoneVerificationFailed";
		}
		
		//check all tables are created or not
		if (!AuditVerificationMethods.verifyDbForAllTablesCreated()) {
			return "appsAllTableCreationFailed";
		}
		
		// check application version verification
		if (!AuditVerificationMethods.verifyApplicationVersion()) {
			return "appsVersionVerificationFailed";
		}

		// check application MD5 hash values
		if (AuditVerificationMethods.verifyMD5(request)) {
			return "appsMD5VerificationFailed";
		}

		return "verified";
	}
}
