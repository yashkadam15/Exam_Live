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
@RequestMapping(value = "/releaseCandidate")
public class ReleaseCandidateController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ReleaseCandidateController.class);	
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final long ONE = 1;
	
	private static final String ISADMIN = "isAdmin";
	SuspendCandidateServicesImpl suspendExamServicesImpl=new SuspendCandidateServicesImpl();

	@RequestMapping(value = "/eventList", method = {RequestMethod.GET,RequestMethod.POST})
	public String getExamEventForReleaseCandidate(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response,Integer messageid,Locale locale)
	{
		try {
			List<ExamEvent> suspendedExamEventList = null;
			if (messageid != null && !messageid.equals("")) {
				MKCLUtility.addMessage(messageid, model, locale);
			}

			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);

				/* call to get on going Exam Event List service */
				suspendedExamEventList = suspendExamServicesImpl.getSuspendedExamEvents();

				if(request.getParameter("SELEXAMEVENTID")!=null && request.getParameter("SELPAPERID")!=null ) 
				{
					List<ViewModelCandidateAcademicSummaryReport> candidateDetails=suspendExamServicesImpl.getSuspendedCandidatesByEventIdAndPaperId(Long.parseLong(request.getParameter("SELEXAMEVENTID")),Long.parseLong(request.getParameter("SELPAPERID")));
					if(candidateDetails.size()==0)
						model.addAttribute("mode",0);
					
					model.addAttribute("CandidateDetails", candidateDetails);
					model.addAttribute("examEventID",request.getParameter("SELEXAMEVENTID") );
					model.addAttribute("paperID",request.getParameter("SELPAPERID") );	
				}	

			} else {
				model.addAttribute(ISADMIN, 0);
			}
			model.addAttribute("suspendedExamEventList", suspendedExamEventList);

		} catch (Exception ex) {
			LOGGER.error("Error occured in getExamEventForReleaseCandidate " , ex);			
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}	
		return "Admin/SuspensionRelease/releaseExam";		
	}
	
	@RequestMapping(value = "/paper.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<Paper> getPaperList( @RequestBody ExamEvent examEventID, HttpServletRequest request) {
		List<Paper> paperList =null;		
		try {
			paperList = suspendExamServicesImpl.getPaperListbyEventId(examEventID.getExamEventID());
		} catch (Exception e) {
			LOGGER.error("Error occured in getPaperList " , e);		
		}
		return paperList;
	}
	
	@RequestMapping(value = { "/releasesCandidateExam" }, method = RequestMethod.POST)
	public String releasesCandidateExam(Model model, HttpServletRequest request,Locale locale) {

		String candidateExmaId=request.getParameter("ceid");
		Boolean success=false;
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);

			if(user.getFkRoleID() == 1)
				success=suspendExamServicesImpl.releaseCandidate(Long.parseLong(candidateExmaId),user.getUserName());	 

			if(success)
				return "redirect:eventList?messageid=139";	

		} catch (Exception e) {
			LOGGER.error("Exception occured in releasesCandidateExam: " , e);
			return ERRORPAGE;
		}
		return "redirect:eventList?messageid=141";
	}

	
	
	
	

}
