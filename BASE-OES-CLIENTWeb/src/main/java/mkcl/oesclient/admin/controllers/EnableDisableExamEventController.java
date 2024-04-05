package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.admin.services.EnableDisableExamEventServicesImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oespcs.model.ExamEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("EnableDisableExamEvent")
public class EnableDisableExamEventController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EnableDisableExamEventController.class);
	EnableDisableExamEventServicesImpl enableDisableExamEventServicesImpl= new EnableDisableExamEventServicesImpl();
	
	/**
	 * Get method for Manage Exam Event List
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/manageExamEvent" }, method = {RequestMethod.GET})
	public String getExamExamEventList(Model model,HttpServletRequest request,Locale locale) {
		try {
			String messageid=request.getParameter("messageid");
			String mode=request.getParameter("mode");
			if (messageid != null && !messageid.isEmpty()) {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model,
						locale);
			}	
			
	    List<ExamEvent> examEventList= new ArrayList<ExamEvent>();
	    List<ExamEvent> examEventList2= new ArrayList<ExamEvent>();
	    if(mode!=null && mode.equals("0"))
	    {	
	    model.addAttribute("mode",mode);	
	    }
	    else if(mode!=null && mode.equals("1"))
	    {	  
	     model.addAttribute("mode",mode);	   
	    }
	    else
	    {	       
	 	    model.addAttribute("mode","0");	 		
	    }
	    examEventList=enableDisableExamEventServicesImpl.getExamEventListByIsEnableStatus(true);	
        examEventList2=enableDisableExamEventServicesImpl.getExamEventListByIsEnableStatus(false);
	    model.addAttribute("examEventList", examEventList);	
 		model.addAttribute("examEventList2", examEventList2);	
		
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getExamExamEventList: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/EnableDisableEvent/enableDisableEvent";
	}
	
	/**
	 * Post method to Manage Exam Event
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/manageExamEvent" }, method = RequestMethod.POST)
	public String saveStatus(Model model,HttpServletRequest request,Locale locale) {
		try {
			String selectedDisableExamEventId=request.getParameter("hdnDisableExamEventId");
			String selectedEnableExamEventId=request.getParameter("hdnEnableExamEventId");
			
			boolean success=false;
			if(selectedDisableExamEventId!=null)
			{
				if (selectedDisableExamEventId.trim().length() > 0) {
					String selectedID = null;	
					if (selectedDisableExamEventId.length() > 0 && selectedDisableExamEventId.charAt(selectedDisableExamEventId.length() - 1) == ',') {
						selectedID = selectedDisableExamEventId.substring(0,	selectedDisableExamEventId.length() - 1);
				success=enableDisableExamEventServicesImpl.saveExamEventStatus(false, selectedID);
				
					}
				}				
			}
			else if(selectedEnableExamEventId!=null)
			{
				if (selectedEnableExamEventId.trim().length() > 0) {
					String selectedID = null;	
					if (selectedEnableExamEventId.length() > 0 && selectedEnableExamEventId.charAt(selectedEnableExamEventId.length() - 1) == ',') {
						selectedID = selectedEnableExamEventId.substring(0,	selectedEnableExamEventId.length() - 1);
				success=enableDisableExamEventServicesImpl.saveExamEventStatus(true, selectedID);
					}
				}	
			}			
			
			if(success)
			{
				if(selectedDisableExamEventId!=null)
				{
			return	"redirect:../EnableDisableExamEvent/manageExamEvent?messageid=12&mode=0";
				}
				else
				{
			return	"redirect:../EnableDisableExamEvent/manageExamEvent?messageid=13&mode=1";	
				}
				
			}	
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in saveStatus: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "redirect:../EnableDisableExamEvent/manageExamEvent";
	}

}
