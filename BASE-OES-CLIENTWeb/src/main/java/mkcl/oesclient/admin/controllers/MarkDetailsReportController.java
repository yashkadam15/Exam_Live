/**
 * 
 */
package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.admin.services.ExamWiseMarkDetailsReportServicesImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.Pagination;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamWiseMarkDetailsViewModel;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.Paper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author virajd
 *
 */
@Controller
@RequestMapping("ExamReports")
public class MarkDetailsReportController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MarkDetailsReportController.class);
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final String EXCEPTIONSTRING = Constants.EXCEPTIONSTRING;
	
	private static final String EXAMEVENTID = "examEventId";
	private static final String PAPERID = "paperId";
	private static final String CANDIDATEFIRSTNAME="CANDIDATEFIRSTNAME";
	private static final String LISTEXAMWISEMARKDETAILS="listExamWiseMarkDetails";
	private static final String OBJEXAMWISEMARKDETAILS="objExamWiseMarkDetails";
	
	/**
	 * Method to fetch the Active Exam Event List
	 * @param request
	 * @return List<ExamEvent> this returns the ExamEventList
	 */
	@ModelAttribute("activeExamEventList")
	public List<ExamEvent> getActiveExamEventList(HttpServletRequest request) {
		List<ExamEvent> activeExamEventList = null;
		try {
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			/* Active exam Event List */
			VenueUser user = SessionHelper.getLogedInUser(request);
			activeExamEventList = eServiceObj.getActiveExamEventList(user);

		} catch (Exception e) {
			LOGGER.error("Exception occured in getActiveExamEventList", e);
		}
		return activeExamEventList;
	}

	/**
	 * Post method to fetch the Paper List Associated to the Exam Event
	 * @param examEvent
	 * @param request
	 * @return List<Paper> this returns the PaperList
	 */
	@RequestMapping(value = "/listPaperAssociatedToEvent.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<Paper> getPaperList(@RequestBody ExamEvent examEvent,
			HttpServletRequest request) {
		List<Paper> paperList = null;
		try {
			PaperServiceImpl objPaperServiceImpl = new PaperServiceImpl();
			paperList = new ArrayList<Paper>();
			paperList = objPaperServiceImpl.getPapersByEventId(examEvent.getExamEventID());
		} catch (Exception e) {
			LOGGER.error("Exception in getPaperList: ", e);
		}
		return paperList;
	}
	
	/**
	 * Get method for Marks Details Report
	 * @param model
	 * @param request
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/markDetailsReport" }, method = RequestMethod.GET)
	public String eligibilityCertificateGet(Model model,
			HttpServletRequest request, String messageid, Locale locale) {
		if (messageid != null && !messageid.isEmpty()) {
			MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
		}

		return "Admin/Reports/ExamWiseMarkDetails";
	}
	
	/**
	 * Get method for Exam wise Marks Details List
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/ExamWiseMarkDetails" }, method = { RequestMethod.POST, RequestMethod.GET })
	public String listGet(Model model, HttpServletRequest request, Locale locale) {
		
		ExamWiseMarkDetailsReportServicesImpl objExamWiseMarkDetailsService = new ExamWiseMarkDetailsReportServicesImpl();
		try {
			Long examEventId = 0l;
			Long paperId = 0l;
			String strExamEventId = request.getParameter("examEventSelect");
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				examEventId = Long.valueOf(strExamEventId);
			}

			String strPaperId = request.getParameter("paperSelect");
			if (strPaperId != null && !(strPaperId.equals(""))) {
				paperId = Long.valueOf(strPaperId);
			}
						
			/** Add message into model. */
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,
						locale);
			}

			/** 2 Get searchText. */
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName(LISTEXAMWISEMARKDETAILS);
			ExamWiseMarkDetailsViewModel objExamWiseMarkDetails = objExamWiseMarkDetailsService.getExamWiseMarkDetailsInfo(examEventId, paperId);
			model.addAttribute(OBJEXAMWISEMARKDETAILS, objExamWiseMarkDetails);
			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);

			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName(CANDIDATEFIRSTNAME);
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objExamWiseMarkDetailsService.pagination(null, pagination,
						searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objExamWiseMarkDetailsService.pagination(null, pagination,
						searchText, model);
			}
			return "Admin/Reports/ExamWiseMarkDetails";
		} catch (Exception ex) {
			LOGGER.error("Exception in listGet TestReportControler mapping",ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
	}
	
	/**
	 * Post method for Exam wise Marks Details List Pagination - Next
	 * @param model
	 * @param pagination
	 * @param searchText
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/next" }, method = RequestMethod.POST)
	public String nextGet(Model model,
			@ModelAttribute("pagination") Pagination pagination,
			String searchText, HttpServletRequest request) {
		pagination.setListName(LISTEXAMWISEMARKDETAILS);
		ExamWiseMarkDetailsReportServicesImpl objExamWiseMarkDetailsService = new ExamWiseMarkDetailsReportServicesImpl();
		try {			
			Long examEventId = 0l;
			Long paperId = 0l;
			String strExamEventId = request.getParameter("examEventId");
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				examEventId = Long.valueOf(strExamEventId);
			}

			String strPaperId = request.getParameter("paperId");
			if (strPaperId != null && !(strPaperId.equals(""))) {
				paperId = Long.valueOf(strPaperId);
			}

			ExamWiseMarkDetailsViewModel objExamWiseMarkDetails = objExamWiseMarkDetailsService.getExamWiseMarkDetailsInfo(examEventId, paperId);
			model.addAttribute(OBJEXAMWISEMARKDETAILS, objExamWiseMarkDetails);
			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);

			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName(CANDIDATEFIRSTNAME);
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objExamWiseMarkDetailsService.paginationNext(null, pagination,
						searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objExamWiseMarkDetailsService.paginationNext(null, pagination,
						searchText, model);
			}
		} catch (Exception ex) {
			LOGGER.error("Exception in nextGet TestReportControler mapping: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/Reports/ExamWiseMarkDetails";
	}

	/**
	 * Post method for Exam wise Marks Details List Pagination - Previous
	 * @param model
	 * @param pagination
	 * @param searchText
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/prev" }, method = RequestMethod.POST)
	public String prevGet(Model model,
			@ModelAttribute("pagination") Pagination pagination,
			String searchText, HttpServletRequest request) {
		pagination.setListName(LISTEXAMWISEMARKDETAILS);
		ExamWiseMarkDetailsReportServicesImpl objExamWiseMarkDetailsService = new ExamWiseMarkDetailsReportServicesImpl();
		try {			
			Long examEventId = 0l;
			Long paperId = 0l;
			String strExamEventId = request.getParameter("examEventId");
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				examEventId = Long.valueOf(strExamEventId);
			}

			String strPaperId = request.getParameter("paperId");
			if (strPaperId != null && !(strPaperId.equals(""))) {
				paperId = Long.valueOf(strPaperId);
			}

			ExamWiseMarkDetailsViewModel objExamWiseMarkDetails = objExamWiseMarkDetailsService.getExamWiseMarkDetailsInfo(examEventId, paperId);
			model.addAttribute(OBJEXAMWISEMARKDETAILS, objExamWiseMarkDetails);
			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);

			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName(CANDIDATEFIRSTNAME);
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objExamWiseMarkDetailsService.paginationPrev(null, pagination,
						searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objExamWiseMarkDetailsService.paginationPrev(null, pagination,
						searchText, model);
			}
		} catch (Exception ex) {
			LOGGER.error("Exception in prevGet TestReportControler mapping: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/Reports/ExamWiseMarkDetails";
	}

		
/*	@RequestMapping(value = { "/ExamWiseMarkDetails" }, method = RequestMethod.POST)
	public String listGet(Model model, HttpServletRequest request, Locale locale) {

		EligibilityCertificateServicesImpl objEligibilityCertificateServicesImpl = new EligibilityCertificateServicesImpl();
		List<CandidateExam> listCandidateExam = new LinkedList<CandidateExam>();
		try {
			Long examEventId = 0l;
			Long paperId = 0l;
			String strExamEventId = request.getParameter("examEventSelect");
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				examEventId = Long.valueOf(strExamEventId);
			}

			String strPaperId = request.getParameter("paperSelect");
			if (strPaperId != null && !(strPaperId.equals(""))) {
				paperId = Long.valueOf(strPaperId);
			}

			String strAttemptDate = request.getParameter("paperAttemptDateSelect");

			*//** Add message into model. *//*
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}

			listCandidateExam = objEligibilityCertificateServicesImpl.getCandidateEligibilityReport(examEventId, paperId,strAttemptDate);
			// for display message of record not found
			if (listCandidateExam == null || listCandidateExam.size() == 0) {

				model.addAttribute("errorclass", "notDisplayInfo");
				model.addAttribute("message", "info");
				model.addAttribute("messageText", "<b>Record not found</b>");
			}

			// Get paper passing marks
			ExamEventConfigurationServiceImpl objEventConfigurationServiceImpl = new ExamEventConfigurationServiceImpl();
			Double objPassingMarks = objEventConfigurationServiceImpl.getPassingMarksForPaper(examEventId, paperId);

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(PAPERID, paperId);
			model.addAttribute("paperAttemptDate", strAttemptDate);
			model.addAttribute(LISTCANDIDATEEXAM, listCandidateExam);
			model.addAttribute("objPassingMarks", objPassingMarks);
			return ELIGIBILITYCERTIFICATE;
		} catch (Exception ex) {
			LOGGER.error("Exception in listGet EligibilityCertificateController:",ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
	}*/

}
