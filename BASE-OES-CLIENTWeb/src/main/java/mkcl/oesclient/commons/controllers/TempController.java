package mkcl.oesclient.commons.controllers;

import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("temp")
public class TempController {

	private static final Logger LOGGER = LoggerFactory.getLogger(TempController.class);

	/**
	 * Get method for Gateway Login 
	 * @param model
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/check" }, method = RequestMethod.GET)
	public String gatewayLogin(Model model, Locale locale) {
		String[] errormsg = new String[1];
		try {			
			return "Common/login/test";
			
		} catch (Exception e) {
			LOGGER.error("Exception occured in gatewayLogin: ", e);
			errormsg[0]="Exception occured in gatway login : "+e;

		}
		return "Common/login/test";
	}

	
	
/*
 * End by sapanag 
 */
}
