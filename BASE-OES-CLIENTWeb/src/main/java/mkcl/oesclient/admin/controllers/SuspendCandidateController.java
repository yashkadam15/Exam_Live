package mkcl.oesclient.admin.controllers;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.oesclient.admin.services.SuspendCandidateServicesImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ViewModelCandidateAcademicSummaryReport;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.Paper;

@Controller
@RequestMapping(value = "/suspendCandidate")
public class SuspendCandidateController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SuspendCandidateController.class);	
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final long ONE = 1;
	
	private static final String ISADMIN = "isAdmin";
	SuspendCandidateServicesImpl suspendCandidateServicesImpl=new SuspendCandidateServicesImpl();
	
	@RequestMapping(value = "/eventList", method = {RequestMethod.GET,RequestMethod.POST})
	public String getExamEventForSusupendCandidate(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response,Integer messageid,Locale locale)
	{
		try {

			List<ExamEvent> onGoingExamEventList = null;
			if (messageid != null && !messageid.equals("")) {
				MKCLUtility.addMessage(messageid, model, locale);
			}

			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);

				/* call to get on going Exam Event List service */
				onGoingExamEventList = suspendCandidateServicesImpl.getOnGoingExamEvents();

				String username=request.getParameter("username");
				if(request.getParameter("SELEXAMEVENTID")!=null && request.getParameter("SELECTPAPERID")!=null && username!=null) 
				{
					List<ViewModelCandidateAcademicSummaryReport> candidateDetails=suspendCandidateServicesImpl.getCandidateScheduleDetailsByUserName(username,Integer.parseInt(request.getParameter("SELEXAMEVENTID")),Integer.parseInt(request.getParameter("SELECTPAPERID")));
					model.addAttribute("CandidateDetails", candidateDetails);
					
					if(candidateDetails.size() > 0 ) {
						 String isCandidateOnline = SessionHelper.getLoginMapValue(candidateDetails.get(0).getCandidate().getCandidateUserName(), request);
						 model.addAttribute("isCandidateOnline",isCandidateOnline);
					} 
						
					model.addAttribute("username", username);
					model.addAttribute("examEventID",request.getParameter("SELEXAMEVENTID") );
					model.addAttribute("paperID",request.getParameter("SELPAPERID") );	
				}	
			} else {
				model.addAttribute(ISADMIN, 0);
			}

			model.addAttribute("onGoingExamEventList", onGoingExamEventList);

		} catch (Exception ex) {
			LOGGER.error("Error occured in getExamEventForSusupendCandidate: " , ex);			
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}	
		return "Admin/SuspendExam/suspendExam";
	}

	
	
	@RequestMapping(value = "/paper.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<Paper> getPaperList( @RequestBody ExamEvent examEventID, HttpServletRequest request) {
		List<Paper> paperList =null;		
		try {
			paperList = suspendCandidateServicesImpl.getPaperListbyEventId(examEventID.getExamEventID());
		} catch (Exception e) {
			LOGGER.error("Error occured in getPaperList " , e);	
		}
		return paperList;
	}
	
	@RequestMapping(value = { "/suspendCandidateExam" }, method = RequestMethod.POST)
	public String suspendCandidateExam(Model model, HttpServletRequest request,Locale locale) {

		String candidateExmaId=request.getParameter("ceid");
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);
			boolean success=false;
			SessionHelper.getLoginMapValue(request.getParameter("cuName"), request);
			
			if(user.getFkRoleID()==1)
				success=suspendCandidateServicesImpl.suspendCandidate(Long.parseLong(candidateExmaId),user.getUserName());

			if(success)
				return "redirect:eventList?messageid=138";	

		} catch (Exception e) {
			LOGGER.error("Exception occured in suspendCandidateExam: " , e);
			return ERRORPAGE;
		}
		return "redirect:eventList?messageid=140";
	}
	
}
