package mkcl.oesclient.commons.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class OESClientController {

	/**
	 * Get method for Login Controller
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/login/login", method = RequestMethod.GET)
	public String loginController() {
		return "Common/login/login";
	}

	/**
	 * Get method for Form Controller
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/form/form", method = RequestMethod.GET)
	public String formController() {
		return "Common/form/form";
	}

	/**
	 * Get method for Dashboard Controller
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/dashboard/dashboard", method = RequestMethod.GET)
	public String dashboardController() {
		return "Admin/dashboard/dashboard";
	}

	/**
	 * Get method for Instruction Controller
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/instruction/instruction", method = RequestMethod.GET)
	public String instructionController() {
		return "instruction/instruction";
	}
}
