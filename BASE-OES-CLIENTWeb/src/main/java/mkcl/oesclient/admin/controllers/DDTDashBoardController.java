package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.oesclient.admin.services.DDTDashboardServiceImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.viewmodel.ExamStatusViewModel;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.Paper;

@Controller
@RequestMapping("ddtdashboard")
public class DDTDashBoardController {

	private static final Logger LOGGER = LoggerFactory.getLogger(DDTDashBoardController.class);
	
	//Health Awareness Dashboard.
	/**
	 * Get method for DDT Dashboard
	 * @param model
	 * @param request
	 * @param locale 
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/ddtDashBoard" }, method = RequestMethod.GET)
	public String ddtDashBoard(Model model, HttpServletRequest request, Locale locale) {
		try {
			String messageid = request.getParameter("messageId");
			if (messageid != null && messageid != "") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
			DDTDashboardServiceImpl ddtService= new DDTDashboardServiceImpl();
			List<ExamEvent> exameventList=ddtService.getDDTExamEvents();
			model.addAttribute("exameventList", exameventList);
			if(exameventList!=null && exameventList.size()==1)
			{
				List<Paper> paperList=ddtService.getDDTPaperListbyEventId(exameventList.get(0).getExamEventID());
				model.addAttribute("paperList",paperList);
				
				List<ExamStatusViewModel> examStatusList=ddtService.getAllDDTExamStatus(exameventList.get(0).getExamEventID());
				model.addAttribute("examStatusList", examStatusList);
			}
			
		} catch (Exception e) {
			LOGGER.error("Exception Occured in ddtDashBoard : ", e);
		}
		return "Admin/ddtdashboard/ddtDashboard";
	}
	
	/**
	 * Post method for Exam Statistics
	 * @param examEvent
	 * @param request
	 * @return List<ExamStatusViewModel> this returns the ExamStatusViewModelList
	 */
	@RequestMapping(value = "/getExamStats.ajax", method = RequestMethod.POST)
	@ResponseBody public List<ExamStatusViewModel> getExamStats(@RequestBody ExamEvent examEvent,HttpServletRequest request) 
	{
		List<ExamStatusViewModel> examStatusList = null;
		try 
		{
			DDTDashboardServiceImpl ddtService= new DDTDashboardServiceImpl();
			examStatusList=ddtService.getAllDDTExamStatus(examEvent.getExamEventID());
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception in getExamStats: ", e);
		}
		return examStatusList;
	}
	
	/**
	 * Post method for DDT Paper List
	 * @param examEvent
	 * @param request
	 * @return List<Paper> this returns the PaperList
	 */
	@RequestMapping(value = "/getDDTPapers.ajax", method = RequestMethod.POST)
	@ResponseBody public List<Paper> getPaperList(@RequestBody ExamEvent examEvent,HttpServletRequest request) 
	{
		List<Paper> paperList = null;
		try 
		{
			DDTDashboardServiceImpl ddtService= new DDTDashboardServiceImpl();
			paperList=ddtService.getDDTPaperListbyEventId(examEvent.getExamEventID());
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception in getDDTPapers: ", e);
		}
		return paperList;
	}
	
	/**
	 * Post method for DDT Exam Candidates
	 * @param candidateExam
	 * @param request
	 * @return List<CandidateExam> this returns the CandidateExamList
	 */
	@RequestMapping(value = "/getDDTExamCandidates.ajax", method = RequestMethod.POST)
	@ResponseBody public List<CandidateExam> getDDTExamCandidates(@RequestBody CandidateExam candidateExam,HttpServletRequest request) 
	{
		List<CandidateExam> candidateExamList = null;
		try 
		{
			DDTDashboardServiceImpl ddtService= new DDTDashboardServiceImpl();
			candidateExamList=ddtService.getDDTExamCandidates(candidateExam.getFkExamEventID(),candidateExam.getFkPaperID());
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception in getDDTExamCandidates: ", e);
		}
		return candidateExamList;
	}
}
