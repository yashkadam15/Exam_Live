/**
 * 
 */
package mkcl.oesclient.commons.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author virajd
 *
 */
@Controller
@RequestMapping(value = "/exploriments")
public class ExplorimentsController {
	
	/**
	 * Get method for Take a Test
	 * @param model
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/explorimentsTree", method = RequestMethod.GET)
	public String takeTest(Model model) {
		return "Exploriments/ExplorimentsTree";
	}
}
