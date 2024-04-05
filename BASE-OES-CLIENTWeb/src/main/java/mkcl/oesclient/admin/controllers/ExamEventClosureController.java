package mkcl.oesclient.admin.controllers;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.oesclient.admin.services.ExamEventClosureServicesImpl;
import mkcl.oesclient.commons.services.OESLogServices;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ViewModelCandidateAcademicSummaryReport;
import mkcl.oesclient.viewmodel.ViewModelOESLogForCandidate;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.Paper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/examEventClosure")
public class ExamEventClosureController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ExamEventClosureController.class);	
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final long ONE = 1;
	
	private static final String ISADMIN = "isAdmin";
	ExamEventClosureServicesImpl eventClosureServicesImpl = new ExamEventClosureServicesImpl();
	
	/**
	 * Get method for End Test
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/bulkEndExamGet", method = {RequestMethod.GET,RequestMethod.POST})
	public String endTestGet(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response,Integer messageid,Locale locale) {
		try {
			List<ExamEvent> expiredExamEventList = null;
			if (messageid != null && !messageid.equals("")) {
				MKCLUtility.addMessage(messageid, model, locale);
			}
			List<CandidateExam> incompleteExamList=null;	
			
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);
				
				/* call to get Expired Exam Event List service */
				expiredExamEventList = eventClosureServicesImpl.getExpiredExamEvents();
				model.addAttribute("expiredExamEventList", expiredExamEventList);
				
				if(request.getParameter("SELEXAMEVENTID")!=null && request.getParameter("SELPAPERID")!=null)
				{	
					//check is selected examevent Expired
					if(eventClosureServicesImpl.checkExamEventExpired(Long.parseLong(request.getParameter("SELEXAMEVENTID")))) 
					{

						//call to get candidates having exams in incomplete mode
						incompleteExamList=eventClosureServicesImpl.getEventPaperWiseIncompleteExamsList(Long.parseLong(request.getParameter("SELEXAMEVENTID")), Long.parseLong(request.getParameter("SELPAPERID")));
						if(incompleteExamList.size()==0)
							model.addAttribute("mode", 0);

						model.addAttribute("examEventID",request.getParameter("SELEXAMEVENTID") );
						model.addAttribute("paperID",request.getParameter("SELPAPERID") );
					}
					else {
						MKCLUtility.addMessage(MessageConstants.EXPIRED_EXAMEVENT, model, locale);
					}
				}	
				
				//set list to model attribute
				model.addAttribute("incompleteExamsList",incompleteExamList );
				return "Admin/ExamEventClosure/bulkEndExam";
				
			} else {
				model.addAttribute(ISADMIN, 0);
				
				return "Admin/ExamEventClosure/bulkEndExam";
				//return "redirect:../adminLogin/loginpage?messageid=78";
			}
			
			} catch (Exception ex) {
			LOGGER.error("Error occured in examEventClosure/bulkEndExamGet: " , ex);			
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}	
		
	}

	/**
	 * Post method for End Test
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/bulkEndExamPost", method = RequestMethod.POST)
	public String endTest(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) {
		CandidateExamServiceImpl candidateExamServiceImpl=new CandidateExamServiceImpl();
		int cnt=0;
		
		try {
			// Get selected candidateExamIds and iterate each one to save
			String selectedIncompleteExams=request.getParameter("hdnCandidateExamIDs");			
			if(selectedIncompleteExams!=null)
			{
				if (selectedIncompleteExams.trim().length() > 0) {
					String candidateExamId[] = selectedIncompleteExams.split(",");
					
						for (String ceid : candidateExamId) {
							
							if(candidateExamServiceImpl.getMarksObtainedandUpdateExamScore(Long.parseLong(ceid)))
							{
								cnt++;								
							}	
							else
							{								
								return "redirect:bulkEndExamGet?messageid=22";
							}
						}
						if(cnt==candidateExamId.length)
						{							
							return "redirect:bulkEndExamGet?messageid=2";
						}						
						}
				}				
			
			return "redirect:bulkEndExamGet";
		} catch (Exception ex) {
			LOGGER.error("Error occured in bulkEndexam/endExamPost: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
		
	}
	
	/**
	 * Post method to fetch Paper List
	 * @param examEventID
	 * @param request
	 * @return List<Paper> this returns the PaperList
	 */
	@RequestMapping(value = "/paper.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<Paper> getPaperList(
		@RequestBody ExamEvent examEventID, HttpServletRequest request) {
		List<Paper> paperList =null;		
		paperList = eventClosureServicesImpl.getPaperListbyEventId(examEventID.getExamEventID());
		return paperList;
	}
	
	
	//22 march 2016 : candidate Exam Activity Log report in admin
	/**
	 * Get method for Exam Activity Log
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/examActivityLogSearch", method = RequestMethod.GET)
	public String examActivityLog(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response,Integer messageid,Locale locale) {
		try {	
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);
			
			String username=request.getParameter("username");			
				
			if(username!=null)
			{
				List<ViewModelCandidateAcademicSummaryReport> candidateAttemptedExamList=eventClosureServicesImpl.getAttemptedExamListByCandidateUserName(username);
				model.addAttribute("candidateAttemptedExamList", candidateAttemptedExamList);
				model.addAttribute("username", username);
			
			} 
			}
			else
			{
				model.addAttribute(ISADMIN, 0);
			}
			return "Solo/PostLoginActivityLog/ExamActivity";
		}
			catch (Exception ex) {
			LOGGER.error("Error occured in examEventClosure/examActivityLog: " , ex);			
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}	
		
	}
	
	/**
	 * Get method for Exam Actvity Log
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/examActivityLog", method = RequestMethod.GET)
	public String examActivityLogPost(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response,Integer messageid,Locale locale) {
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, ONE);
				String username=request.getParameter("username");	
			List<ViewModelOESLogForCandidate> oesLogForCandidate=new OESLogServices().getCandidatePostLoginActivityLog(Long.parseLong(request.getParameter("examEventId")),Long.parseLong(request.getParameter("paperId")),Long.parseLong(request.getParameter("candidateId")),Long.parseLong(request.getParameter("attemptNo")),username);
			model.addAttribute("OesLogForCandidate", oesLogForCandidate);
			model.addAttribute("username", username);
			}
			
			return "Solo/PostLoginActivityLog/CandidateExamActivityLog";
				
			
			} catch (Exception ex) {
			LOGGER.error("Error occured in examEventClosure/examActivityLog: " , ex);			
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}	
		
	}
	
	
}
