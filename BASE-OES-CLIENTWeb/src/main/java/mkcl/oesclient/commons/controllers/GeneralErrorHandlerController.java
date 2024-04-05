package mkcl.oesclient.commons.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "internalerror")
class GeneralErrorHandlerController 
{
	/**
	 * Method to Handle Error
	 * @param request
	 * @param model
	 * @param response
	 * @return String this returns the path of a view
	 */
    @RequestMapping("error")    
    public String handelError(final HttpServletRequest request, final Model model,HttpServletResponse response) 
    {
    	 model.addAttribute("errorMessage", request.getAttribute("javax.servlet.error.message").toString());
    	 return "Common/Error/http_"+request.getAttribute("javax.servlet.error.status_code").toString();
    	 
    }
}