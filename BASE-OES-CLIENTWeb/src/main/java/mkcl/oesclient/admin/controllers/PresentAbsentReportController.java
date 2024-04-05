/**
 * 
 */
package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.admin.services.PresentAbsentReportServicesImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.Pagination;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.PresentAbsentReportViewModel;
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
 * @author amitk
 *
 */
@Controller
@RequestMapping("report")
public class PresentAbsentReportController  {
	Logger LOGGER = LoggerFactory.getLogger(PresentAbsentReportServicesImpl.class);

	private static final String PRESENT_ABSENT_REPORT = "Admin/presentAbsentReport/presentAbsentReport";
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final String EXCEPTIONSTRING = Constants.EXCEPTIONSTRING;
	
	
	
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
			
			//code to set records per page

		} catch (Exception e) {
			LOGGER.error("Exception occured in getActiveExamEventList", e);
		}
		return activeExamEventList;
	}

	/**
	 * Post method to fetch Paper List
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
	 * Post method for Present Absent Report 
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/prAbsReport" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String presentAbsentReportGet(Model model,HttpServletRequest request) {
		try {
			if(request.getMethod().equalsIgnoreCase(RequestMethod.GET.toString())){
				return PRESENT_ABSENT_REPORT;
			}else{
				String paperID = request.getParameter("paperSelect");
				String eventID = request.getParameter("examEventSelect");
				LOGGER.info("paper ID :: "+paperID+" and event ID ::"+eventID);
				model.addAttribute("prAbsReportVM", new PresentAbsentReportServicesImpl().getPaperAndAllocatedCandidatesDetails(Long.parseLong(eventID),Long.parseLong(paperID)));
				model.addAttribute("paperId", paperID);
				model.addAttribute("examEventId", eventID);
			} 
		}catch (Exception e) {
			LOGGER.error("Exception in listGet presentAbsentReportPost:",e);
			model.addAttribute(EXCEPTIONSTRING, e);
			return ERRORPAGE;
		}
		return PRESENT_ABSENT_REPORT;

	}

	/**
	 * Get method for Candidate wise Present Absent Report
	 * @param model
	 * @param request
	 * @param paperId
	 * @param eventID
	 * @param flag
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/candidateWiseprAbsReport" }, method = RequestMethod.GET)
	public String getCandidateWiseDetails(Model model,HttpServletRequest request,String paperId,String eventID,String flag) {
		PresentAbsentReportServicesImpl servicesObj = new PresentAbsentReportServicesImpl();
		PresentAbsentReportViewModel prAbsViewModel = null;
		try {
			
			long examEventID = Long.parseLong(request.getParameter("eventID"));
			long paperID = Long.parseLong(request.getParameter("paperID"));
			prAbsViewModel = servicesObj.getPaperAndAllocatedCandidatesDetails(examEventID, paperID);
	
			byte presentAbsentFlag =Byte.parseByte(request.getParameter("flag"));
			model.addAttribute("prAbsViewModel", prAbsViewModel);
			model.addAttribute("centerName", new ExamVenueActivationServicesImpl().getExamVenue().getExamVenueName());
			model.addAttribute("examEventId", examEventID);
			model.addAttribute("paperId", paperID);
			model.addAttribute("flag", presentAbsentFlag);
			
			/** 2 Get searchText. */
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName("presentAbsentVMList");
			
			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				/*pagination.setPropertyName(CANDIDATEFIRSTNAME);*/
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				servicesObj.pagination(null, pagination,searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				servicesObj.pagination(null, pagination,searchText, model);
			}
			
			
		}catch (Exception e) {
			LOGGER.error("Exception in getCandidateWiseDetails:",e);
			model.addAttribute(EXCEPTIONSTRING, e);
			return ERRORPAGE;
		}
		return PRESENT_ABSENT_REPORT;
	}
	
	
	/**
	 * Post method for Present Absent VM List Pagination - Next
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
		PresentAbsentReportServicesImpl servicesObj = new PresentAbsentReportServicesImpl();
		PresentAbsentReportViewModel prAbsViewModel = null;
		try {
			
			long examEventID = Long.parseLong(request.getParameter("examEventId"));
			long paperID = Long.parseLong(request.getParameter("paperId"));
			prAbsViewModel = servicesObj.getPaperAndAllocatedCandidatesDetails(examEventID, paperID);
	
			byte presentAbsentFlag =Byte.parseByte(request.getParameter("flag"));
			model.addAttribute("prAbsViewModel", prAbsViewModel);
			model.addAttribute("centerName", new ExamVenueActivationServicesImpl().getExamVenue().getExamVenueName());
			model.addAttribute("examEventId", examEventID);
			model.addAttribute("paperId", paperID);
			model.addAttribute("flag", presentAbsentFlag);

			pagination.setListName("presentAbsentVMList");
			
			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				/*pagination.setPropertyName(CANDIDATEFIRSTNAME);*/
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				servicesObj.paginationNext(null, pagination,searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				servicesObj.paginationNext(null, pagination,searchText, model);
			}
			
			
		}catch (Exception e) {
			LOGGER.error("Exception in getCandidateWiseDetails:",e);
			model.addAttribute(EXCEPTIONSTRING, e);
			return ERRORPAGE;
		}
		return PRESENT_ABSENT_REPORT;
	}

	/**
	 * Post method for Present Absent VM List Pagination - Previous
	 * @param model
	 * @param pagination
	 * @param searchText
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/prev" }, method = RequestMethod.POST)
	public String prevGet(Model model,
			@ModelAttribute("pagination") Pagination pagination,String searchText, HttpServletRequest request,String paperId,String eventID,String flag) {
		PresentAbsentReportServicesImpl servicesObj = new PresentAbsentReportServicesImpl();
		PresentAbsentReportViewModel prAbsViewModel = null;
		try {
			
			long examEventID = Long.parseLong(request.getParameter("examEventId"));
			long paperID = Long.parseLong(request.getParameter("paperId"));
			prAbsViewModel = servicesObj.getPaperAndAllocatedCandidatesDetails(examEventID, paperID);
	
			byte presentAbsentFlag =Byte.parseByte(request.getParameter("flag"));
			model.addAttribute("prAbsViewModel", prAbsViewModel);
			model.addAttribute("centerName", new ExamVenueActivationServicesImpl().getExamVenue().getExamVenueName());
			model.addAttribute("examEventId", examEventID);
			model.addAttribute("paperId", paperID);
			model.addAttribute("flag", presentAbsentFlag);

			pagination.setListName("presentAbsentVMList");

			
			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				/*pagination.setPropertyName(CANDIDATEFIRSTNAME);*/
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				servicesObj.paginationPrev(null, pagination,searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				servicesObj.paginationPrev(null, pagination,searchText, model);
			}
			
			
		}catch (Exception e) {
			LOGGER.error("Exception in getCandidateWiseDetails:",e);
			model.addAttribute(EXCEPTIONSTRING, e);
			return ERRORPAGE;
		}
		return PRESENT_ABSENT_REPORT;
	}

}
