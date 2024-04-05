package mkcl.oesclient.group.controllers;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mkcl.oesclient.commons.controllers.ExamLocaleThemeResolver;
import mkcl.oesclient.commons.services.ExamEventConfigurationServiceImpl;
import mkcl.oesclient.group.services.GroupCandidateExamServiceImpl;
import mkcl.oesclient.group.services.IGroupCandidateExamService;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamPaperSetting;
import mkcl.oespcs.model.ExamEventPaperDetails;
import mkcl.oespcs.model.ShowResultType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("GroupEndExamController")
@RequestMapping(value = "/groupendexam")
public class EndExamController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EndExamController.class);
	
	@Autowired
	private ExamLocaleThemeResolver examLocaleThemeResolver;

	/**
	 * Get method for End Test
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/FrmendTestGet", method = RequestMethod.GET)
	public String endTestGet(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException {
		try {	
			IGroupCandidateExamService groupService = new GroupCandidateExamServiceImpl();
			Map<Long, Long> candidateExamMap = groupService.getCandidateExamIDsFromCandidates(SessionHelper.getCandidates(request), SessionHelper.getExamEvent(request).getExamEventID(),SessionHelper.getExamPaperSetting(request).getPaperID());
			groupService.getMarksObtainedandUpdateExamScore(candidateExamMap.values());
			return "redirect:showTestResult?examEventID="+SessionHelper.getExamEvent(request).getExamEventID()+"&paperID="
						+SessionHelper.getExamPaperSetting(request).getPaperID()+"&attemptNo="+SessionHelper.getExamPaperSetting(request).getAttemptNo();
		} catch (Exception e) {
			LOGGER.error("Error occured in endTestGet: " , e);
			model.addAttribute("error", e);
			/*	response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;*/
			response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}finally{
			//remove exam settings from Session
			//SessionHelper.removeExamSetting(session);
		}
	}

	/**
	 * Post method for End Test
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/FrmendTest", method = RequestMethod.POST)
	public String endTest(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException {
		try {
			IGroupCandidateExamService groupService = new GroupCandidateExamServiceImpl();
			Map<Long, Long> candidateExamMap = groupService.getCandidateExamIDsFromCandidates(SessionHelper.getCandidates(request), SessionHelper.getExamEvent(request).getExamEventID(), SessionHelper.getExamPaperSetting(request).getPaperID());
			groupService.getMarksObtainedandUpdateExamScore(candidateExamMap.values());		
			return "redirect:showTestResult?examEventID="+SessionHelper.getExamEvent(request).getExamEventID()+"&paperID="
						+SessionHelper.getExamPaperSetting(request).getPaperID()+"&attemptNo="+SessionHelper.getExamPaperSetting(request).getAttemptNo();
		} catch (Exception e) {
			LOGGER.error("Error occured in endTest: " , e);
			model.addAttribute("error", e);
				response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}
		finally{
			//remove exam settings from Session
			//SessionHelper.removeExamSetting(session);
		}
	}

	/**
	 * Get method for Display Test Result
	 * @param model
	 * @param request
	 * @param session
	 * @param response
	 * @return String this returns the path of a view
	 * @throws IOException
	 */
	@RequestMapping(value = "/showTestResult", method = RequestMethod.GET)
	public String showTestResult(Model model, HttpServletRequest request,HttpSession session,HttpServletResponse response) throws IOException {
		try {
			
			String examEventID = request.getParameter("examEventID");
			String paperID = request.getParameter("paperID");
			String attemptNo=request.getParameter("attemptNo");
			
			/* Added by Reena : 24 July 2015
			 * This call should always be on the top of each function as locale further 
			 accessed will not behave as required 
			 This call will set back Locale to application Default if Candidate comes from Exam Interface
			 */						
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(request, response);	
			
			ExamPaperSetting examPaperSetting = new ExamEventConfigurationServiceImpl().getExamEventConfiguration(Long.parseLong(examEventID), Long.parseLong(paperID));
			model.addAttribute("showResultType", examPaperSetting.getShowResultType());
			if (examPaperSetting !=null && examPaperSetting.getShowResultType() == ShowResultType.No) {
				model.addAttribute("resultText", examPaperSetting.getResultText());
			} else {
				//redirect to group score card
				return "redirect:../GroupResultAnalysis/groupScoreCardCandidateList?examEventId="+examEventID+"&paperId="
								+paperID+"&attemptNo="+attemptNo;
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in showTestResult: " , e);
			model.addAttribute("error", e);
				response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());return null;
		}
		return "Group/groupExam/viewtestscore";
	}
	

}
