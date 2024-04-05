package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.admin.services.ExameventCertificateServicesImpl;
import mkcl.oesclient.commons.services.ExamEventConfigurationServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.IExamEventService;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.Pagination;
import mkcl.oesclient.commons.utilities.SmartTagHelper;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamEventPaperDetails;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.PaperType;
import mkcl.oespcs.model.ShowResultType;
import mkcl.oespcs.model.TemplateType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("certificate")
public class ExameventCertificateController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ExameventCertificateController.class);
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final String EXCEPTIONSTRING = Constants.EXCEPTIONSTRING;
	private static final String LISTCANIDATEEXAM="listCandidateExam";
	
	/**
	 * Post method for Eligibility Certificate Candidate List
	 * @param model
	 * @param request
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/candidateList" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String eligibilityCertificateGet(Model model,
			HttpServletRequest request, String messageid, Locale locale) {

		ExameventCertificateServicesImpl exameventCertificateServicesImpl= new ExameventCertificateServicesImpl();
		
		try {
			
			String examEventId = request.getParameter("examEventSelect");
			String paperId = request.getParameter("paperSelect");	
			
			/** Add message into model. */
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}		

			/** 2 Get searchText. */
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName(LISTCANIDATEEXAM);
			/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
			
			model.addAttribute("examEventId", examEventId);
			model.addAttribute("paperId", paperId);
			//model.addAttribute("paperType", request.getParameter("paperType")); 
			
			
			if(examEventId !=null && paperId !=null)
			{
				
		    PaperServiceImpl paperServiceImpl= new PaperServiceImpl();
		    Paper paper=paperServiceImpl.getpaperByPaperID(Long.valueOf(paperId));		    
			model.addAttribute("paperType",paper.getPaperType()); 	
				
			IExamEventService eventService= new ExamEventServiceImpl();
			ExamEventPaperDetails eventPaperDetails= eventService.getExamEventPaperDetails(Long.valueOf(examEventId),Long.valueOf(paperId));
			
			model.addAttribute("failCertificateTemplateID", eventPaperDetails.getFailCertificateTemplateID());
			model.addAttribute("isPassingConcept", eventPaperDetails.getisPassingConcept());
			model.addAttribute("certificateTemplateID", eventPaperDetails.getCertificateTemplateID());	
			model.addAttribute("showResultType", eventPaperDetails.getShowResultType());	
			
			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");				
				exameventCertificateServicesImpl.pagination(null, pagination,
						searchText, model);
			} else {
                exameventCertificateServicesImpl.pagination(null, pagination,
						searchText, model);
			}
			// Get paper passing marks
			ExamEventConfigurationServiceImpl objEventConfigurationServiceImpl = new ExamEventConfigurationServiceImpl();
			
			Double objPassingMarks = objEventConfigurationServiceImpl.getPassingMarksForPaper(Long.parseLong(examEventId),Long.parseLong(paperId));
			model.addAttribute("objPassingMarks", objPassingMarks);
			}

		
			


		} catch (Exception ex) {
			LOGGER.error("Exception in listGet EligibilityCertificateController:",ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
		return "Admin/ExamEventCertificate/ExamEventCertificate";
	}

	/**
	 * Post method for Candidate Exam Details List Pagination - Next 
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
		try {
			
		String examEventId = request.getParameter("examEventId");
		String paperId = request.getParameter("paperId");			
		
		
		pagination.setListName(LISTCANIDATEEXAM);
		
		model.addAttribute("examEventId", examEventId);
		model.addAttribute("paperId", paperId);		
		ExameventCertificateServicesImpl exameventCertificateServicesImpl= new ExameventCertificateServicesImpl();
		
		if(examEventId !=null && paperId !=null)
		{
			
			PaperServiceImpl paperServiceImpl= new PaperServiceImpl();
		    Paper paper=paperServiceImpl.getpaperByPaperID(Long.valueOf(paperId));		    
			model.addAttribute("paperType",paper.getPaperType()); 
			
			IExamEventService eventService= new ExamEventServiceImpl();
			ExamEventPaperDetails eventPaperDetails= eventService.getExamEventPaperDetails(Long.valueOf(examEventId),Long.valueOf(paperId));
			
			model.addAttribute("failCertificateTemplateID", eventPaperDetails.getFailCertificateTemplateID());
			model.addAttribute("isPassingConcept", eventPaperDetails.getisPassingConcept());
			model.addAttribute("certificateTemplateID", eventPaperDetails.getCertificateTemplateID());	
			model.addAttribute("showResultType", eventPaperDetails.getShowResultType());	
			
		/** 3 Get Object list. */
		if (searchText != null && !(searchText.equals(""))) {
			pagination.setPropertyName("CANDIDATEFIRSTNAME");
			/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
			exameventCertificateServicesImpl.paginationNext(null, pagination,
					searchText, model);
		} else {
			/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
			exameventCertificateServicesImpl.paginationNext(null, pagination,
					searchText, model);
		}
		
		ExamEventConfigurationServiceImpl objEventConfigurationServiceImpl = new ExamEventConfigurationServiceImpl();
		
		Double objPassingMarks = objEventConfigurationServiceImpl.getPassingMarksForPaper(Long.parseLong(examEventId),Long.parseLong(paperId));
		model.addAttribute("objPassingMarks", objPassingMarks);
		}	
		
			
		} catch (Exception ex) {
			LOGGER.error("Exception in prevGet TestReportControler mapping: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/ExamEventCertificate/ExamEventCertificate";
	}
	
	/**
	 * Post method for Candidate Exam Details List Pagination - Previous 
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
		try {
			String examEventId = request.getParameter("examEventId");
			String paperId = request.getParameter("paperId");			
		
			
			pagination.setListName(LISTCANIDATEEXAM);			
			
			model.addAttribute("examEventId", examEventId);
			model.addAttribute("paperId", paperId);		
			ExameventCertificateServicesImpl exameventCertificateServicesImpl= new ExameventCertificateServicesImpl();
			
			if(examEventId !=null && paperId !=null)
			{
				
				PaperServiceImpl paperServiceImpl= new PaperServiceImpl();
			    Paper paper=paperServiceImpl.getpaperByPaperID(Long.valueOf(paperId));		    
				model.addAttribute("paperType",paper.getPaperType()); 
				
				IExamEventService eventService= new ExamEventServiceImpl();
				ExamEventPaperDetails eventPaperDetails= eventService.getExamEventPaperDetails(Long.valueOf(examEventId),Long.valueOf(paperId));
				
				model.addAttribute("failCertificateTemplateID", eventPaperDetails.getFailCertificateTemplateID());
				model.addAttribute("isPassingConcept", eventPaperDetails.getisPassingConcept());
				model.addAttribute("certificateTemplateID", eventPaperDetails.getCertificateTemplateID());	
				model.addAttribute("showResultType", eventPaperDetails.getShowResultType());	
				
			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName("CANDIDATEFIRSTNAME");
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				exameventCertificateServicesImpl.paginationPrev(null, pagination,
						searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				exameventCertificateServicesImpl.paginationPrev(null, pagination,
						searchText, model);
			}
			
			ExamEventConfigurationServiceImpl objEventConfigurationServiceImpl = new ExamEventConfigurationServiceImpl();
			
			Double objPassingMarks = objEventConfigurationServiceImpl.getPassingMarksForPaper(Long.parseLong(examEventId),Long.parseLong(paperId));
			model.addAttribute("objPassingMarks", objPassingMarks);
			
			}			
			
			} catch (Exception ex) {
				LOGGER.error("Exception in prevGet TestReportControler mapping: ",ex);
				model.addAttribute(Constants.EXCEPTIONSTRING, ex);
				return Constants.ERRORPAGE;
			}
		return "Admin/ExamEventCertificate/ExamEventCertificate";
	}
	
	/**
	 * Get method to Search Candidate
	 * @param model
	 * @param request
	 * @param searchText
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/searchCandidate" }, method = {RequestMethod.GET})
	public String searchCandidate(Model model,
			HttpServletRequest request, String searchText, Locale locale) {
		
		String examEventId = request.getParameter("examEventId");
		String paperId = request.getParameter("paperId");	
		
		IExamEventService eventService= new ExamEventServiceImpl();
		ExamEventPaperDetails eventPaperDetails= eventService.getExamEventPaperDetails(Long.valueOf(examEventId),Long.valueOf(paperId));
		
		model.addAttribute("failCertificateTemplateID", eventPaperDetails.getFailCertificateTemplateID());
		model.addAttribute("isPassingConcept", eventPaperDetails.getisPassingConcept());
		model.addAttribute("certificateTemplateID", eventPaperDetails.getCertificateTemplateID());	
		model.addAttribute("showResultType", eventPaperDetails.getShowResultType());
		
		long failCertificateTemplateID= eventPaperDetails.getFailCertificateTemplateID();
		boolean isPassingConcept=eventPaperDetails.getisPassingConcept();
		long certificateTemplateID=eventPaperDetails.getCertificateTemplateID();	
		ShowResultType showResultType=eventPaperDetails.getShowResultType();
		
		return "redirect:candidateList?searchText="+searchText+"&examEventSelect="+examEventId+"&paperSelect="+paperId+
				"&failCertificateTemplateID="+failCertificateTemplateID+"&isPassingConcept="+isPassingConcept+"&certificateTemplateID="+certificateTemplateID+"&showResultType="+showResultType;
	}
	
	/**
	 * Method to fetch Active Exam Event List
	 * @param request
	 * @return List<ExamEvent> this returns the Active Exam Event List
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
	 * Post method to List Paper Associated to Event
	 * @param examEvent
	 * @param request
	 * @return List<ExamEventPaperDetails> the returns the ExamEventPaperDetailsList
	 */
	@RequestMapping(value = "/listPaperAssociatedToEvent.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<ExamEventPaperDetails> getPaperList(@RequestBody ExamEvent examEvent,
			HttpServletRequest request) {
		List<ExamEventPaperDetails> paperList = null;
		try {
			ExameventCertificateServicesImpl exameventCertificateServicesImpl= new ExameventCertificateServicesImpl();
			paperList = new ArrayList<ExamEventPaperDetails>();
			paperList = exameventCertificateServicesImpl.getPaperAssociatedWithEvent(examEvent.getExamEventID());
		} catch (Exception e) {
			LOGGER.error("Exception in getPaperList: ", e);
		}
		return paperList;
	}

	/**
	 * Post method to Print Certificate
	 * @param model
	 * @param request
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/printCertificate" }, method = {RequestMethod.POST})
	public String printCertificatePost(Model model,HttpServletRequest request, String messageid, Locale locale) {
		List<String> templateTextList = null;
		try {
			LOGGER.debug("Paper Type ::"+request.getParameter("paperType"));
			String hdncandExamIdList= request.getParameter("hdncandExamIdList");
			String[] candidateArry= hdncandExamIdList.split("\\|");
			Map<String,String> templateCandidateExamMap= new LinkedHashMap<String, String>();;
			String[] passCandidateExamIDAndtemplateIDArr = null;
			for (String string : candidateArry) {
				passCandidateExamIDAndtemplateIDArr=string.split("-");
				templateCandidateExamMap.put(passCandidateExamIDAndtemplateIDArr[1],passCandidateExamIDAndtemplateIDArr[0]);
			}
			templateTextList = SmartTagHelper.getListOfReplacedTemplateTextForCertificate(TemplateType.Certificate,templateCandidateExamMap,request,PaperType.valueOf(request.getParameter("paperType")));
			model.addAttribute("templateTextList",templateTextList);
		} catch (Exception e) {
			LOGGER.error("Exception in getPaperList: ", e);
		}
		return "Admin/ExamEventCertificate/certificates";
	}
}
