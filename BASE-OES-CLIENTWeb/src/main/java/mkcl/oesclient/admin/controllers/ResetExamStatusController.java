package mkcl.oesclient.admin.controllers;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import mkcl.oesclient.admin.services.ResetExamStatusServices;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ViewModelCandidateAcademicSummaryReport;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("resetExamStatus")
public class ResetExamStatusController {

	private static Logger LOGGER = LoggerFactory.getLogger(ResetExamStatusController.class);
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	
	/**
	 * Get method for Reset Status
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/resetStatus" }, method = RequestMethod.GET)
	public String resetStatusGet(Model model, HttpServletRequest request,Locale locale) {
		try {
			
			String messageid=request.getParameter("messageid");		
			if (messageid != null && !messageid.isEmpty()) {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model,locale);
			}	
		
		} catch (Exception e) {
			LOGGER.error("Exception occured in examScheduling: " , e);
			return ERRORPAGE;
		}
		return "Admin/ResetExamStatus/resetExamStatus";

	}
	
	/**
	 * Post method for Reset Status 
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/resetStatus" }, method = RequestMethod.POST)
	public String resetStatusPost(Model model, HttpServletRequest request) {
		try 
		{
			String username=request.getParameter("username");
			if(username!=null)
			{
				ResetExamStatusServices resetExamStatusServices= new ResetExamStatusServices();
				List<ViewModelCandidateAcademicSummaryReport> viewModelList= resetExamStatusServices.getExamstatusDetails(username);
				model.addAttribute("viewModelList", viewModelList);
				model.addAttribute("username", username);
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in examScheduling: " , e);
			return ERRORPAGE;
		}
		return "Admin/ResetExamStatus/resetExamStatus";
	}
	
	/**
	 * Post method for Marks In-complete
	 * @param model
	 * @param request
	 * @param session
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/markIncomplete" }, method = RequestMethod.POST)
	public String markIncompleteGet(Model model, HttpServletRequest request,HttpSession session,Locale locale) {
		
		try {				
			
			String candidateExmaId=request.getParameter("ceid");
			String elapsedTime=request.getParameter(candidateExmaId+"elapsedTime");
			String uploadFlagValue=request.getParameter(candidateExmaId+"uploadFlag");
			
			VenueUser venueUser=SessionHelper.getLogedInUser(request);
			ResetExamStatusServices resetExamStatusServices= new ResetExamStatusServices();
			String userIpAddress=getCurrentMachineIPaddress();		
			
		   Boolean success=resetExamStatusServices.setIncomplete(Long.parseLong(candidateExmaId),venueUser,userIpAddress,elapsedTime,Integer.valueOf(uploadFlagValue));
		    if(success)
		    {
		    	return "redirect:../resetExamStatus/resetStatus?messageid=115";	
		    }
		    
		} catch (Exception e) {
			LOGGER.error("Exception occured in markIncomplete: " , e);
			return ERRORPAGE;
		}
		return "redirect:../resetExamStatus/resetStatus?messageid=22";

	}
	
	/**
	 * Post method for Reset Attempt
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/resetAttempt" }, method = RequestMethod.POST)
	public String resetAttemptGet(Model model, HttpServletRequest request,Locale locale) {
		
		String candidateExmaId=request.getParameter("ceid");
		try {				
			
		  	VenueUser venueUser=SessionHelper.getLogedInUser(request);
			ResetExamStatusServices resetExamStatusServices= new ResetExamStatusServices();
			String userIpAddress=getCurrentMachineIPaddress();
			Boolean success=resetExamStatusServices.resetAttempt(Long.parseLong(candidateExmaId),venueUser,userIpAddress);
			if(success)
			{
				return "redirect:../resetExamStatus/resetStatus?messageid=116";	
			}
		
		} catch (Exception e) {
			LOGGER.error("Exception occured in resetAttempt: " , e);
			return ERRORPAGE;
		}
		return "redirect:../resetExamStatus/resetStatus?messageid=22";

	}
	
	/**
	 * Method to fetch the Current Machine IP Address
	 * @return String this returns the current machine ip address
	 */
	private static String getCurrentMachineIPaddress()
	{
	String serverAddress="";
	try
	{
	// Get Current machine address	
	Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
	while (interfaces.hasMoreElements()){
	    NetworkInterface current = interfaces.nextElement();
	   
	    if (!current.isUp() || current.isLoopback() || current.isVirtual()) continue;
	    Enumeration<InetAddress> addresses = current.getInetAddresses();
	    while (addresses.hasMoreElements()){
	        InetAddress current_addr = addresses.nextElement();
	        if (current_addr.isLoopbackAddress()) continue;
	        serverAddress= current_addr.getHostAddress().toString();
	  
	        }

		}
	}
	catch(SocketException e)	{
		
		LOGGER.error("Exception occured in getCurrentMachineIPaddress: " , e);
		return ERRORPAGE;
	}
	return serverAddress;
}
	/**
	 * Method to fetch the Host Address
	 * @param request
	 * @return String this returns the host address
	 */
	public static String getHostAddress(HttpServletRequest request){
		 String hostAddress = null;
		try {
			hostAddress = request.getHeader("X-FORWARDED-FOR");  
			  if (hostAddress == null) {  
				   hostAddress = request.getRemoteAddr();  
			   }
		} catch (Exception e) {
			LOGGER.error("Exception generated in getHostAddress",e);
		}
		return hostAddress;
	}
	
}
