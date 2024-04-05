/**
 * @author virajd
 */
//Modified by Reena for setting based client 03-dec2013
package mkcl.oesclient.solo.controllers;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import mkcl.baseoesclient.model.AdminDisplayCategoryCollectionAssociation;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.Pagination;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.solo.services.QuestAtmptCntRptServiceImpl;
import mkcl.oesclient.solo.services.ResultAnalysisServicesImpl;
import mkcl.oesclient.solo.services.TestReportServicesImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModel;
import mkcl.oesclient.viewmodel.MultipleChoiceSingleCorrectViewModelPDF;
import mkcl.oespcs.model.DisplayCategoryLanguage;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamVenue;
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
@RequestMapping("TestReport")
public class TestReportController {
	private static final Logger LOGGER = LoggerFactory.getLogger(TestReportController.class);
	private static final String ERRORPAGE = Constants.ERRORPAGE;
	private static final String EXCEPTIONSTRING = Constants.EXCEPTIONSTRING;
	
	private static final String ISADMIN="isAdmin";
	private static final String EXAMEVENTID="examEventId";	
	private static final String COLLECTIONID="collectionId";
	private static final String DISPLAYCATEGORYID="displayCategoryId";
	private static final String CANDIDATEID="candidateId";
	private static final String LISTCANDIDATETESTREPORTVIEWMODELS="listCandidateTestReportViewModels";
	private static final String CANDIDATEFIRSTNAME="CANDIDATEFIRSTNAME";
	private static final String TESTREPORTCANDIDATETESTREPORT="Solo/TestReport/CandidateTestReport";
	
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
			LOGGER.error("Exception occured in getActiveExamEventList",e);
		}
		return activeExamEventList;
	}

	/**
	 * Get method for Candidate Test Report
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/CandidateTestReport" }, method = RequestMethod.GET)
	public String candidateTestReport(Model model, HttpServletRequest request) {
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, 1);
			} else {
				model.addAttribute(ISADMIN, 0);
			}

		} catch (Exception ex) {
			LOGGER.error("Exception in candidateTestReportGet: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

		return TESTREPORTCANDIDATETESTREPORT;

	}

	/**
	 * Post method for Collection Master List Associated to the Exam Event and Role
	 * @param examEventID
	 * @param request
	 * @return List<CollectionMaster> this returns collection list
	 */
	@RequestMapping(value = "/collectionMasterAccEventRole.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<CollectionMaster> getCollectionMasterList(
			@RequestBody ExamEvent examEventID, HttpServletRequest request) {
		List<CollectionMaster> collectionMasterList = null;
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);

			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			collectionMasterList = new ArrayList<CollectionMaster>();
			collectionMasterList = eServiceObj.getCollectionMasterAccRole(user,	examEventID.getExamEventID());
		} catch (Exception e) {
			LOGGER.error("Exception in getCollectionMasterList: ",e);
		}
		return collectionMasterList;
	}

	/**
	 * Post method to fetch Display Category List Associated to an Exam Event and its Divisions
	 * @param objAdminDisplayCategoryCollectionAssociation
	 * @param request
	 * @return List<DisplayCategoryLanguage> this returns the DisplayCategoryLanguageList
	 */
	@RequestMapping(value = "/DisplayCategoryLanguageAccEventDivision.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<DisplayCategoryLanguage> getDisplayCategoryList(
			@RequestBody AdminDisplayCategoryCollectionAssociation objAdminDisplayCategoryCollectionAssociation,
			HttpServletRequest request) {

		List<DisplayCategoryLanguage> listDispalyCategoryLanguages = null;
		try {
			ExamEventServiceImpl examEventServiceImpl = new ExamEventServiceImpl();
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();

			listDispalyCategoryLanguages = new ArrayList<DisplayCategoryLanguage>();
			VenueUser user = SessionHelper.getLogedInUser(request);

			ExamEvent examEvent = examEventServiceImpl.getExamEventByID(objAdminDisplayCategoryCollectionAssociation.getFkExamEventID());
			listDispalyCategoryLanguages = eServiceObj.getDisplayCategoryListByUserRole(user, examEvent, objAdminDisplayCategoryCollectionAssociation.getFkCollectionID());
		} catch (Exception e) {
			LOGGER.error("Exception in getDisplayCategoryList: ",e);
		}
		return listDispalyCategoryLanguages;
	}
	
	/**
	 * Post method for Candidate Test Report List
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/CandidateTestReportlist" }, method = { RequestMethod.POST, RequestMethod.GET })
	public String listGet(Model model, HttpServletRequest request, Locale locale) {
		
		TestReportServicesImpl objTestReportServicesImpl = new TestReportServicesImpl();
		try {
			Long examEventId =0l;
			Long collectionId =0l;
			Long displayCategoryId =0l;
			
			String strExamEventId=request.getParameter("examEventSelect");
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				 examEventId =Long.valueOf(strExamEventId);
			}
			
			String strCollectionId=request.getParameter(COLLECTIONID);
			if (strCollectionId != null && !(strCollectionId.equals(""))) {
				collectionId =Long.valueOf(strCollectionId);
			}
			
			String strDisplayCategoryId=request.getParameter("displayCategorySelect");
			if (strDisplayCategoryId != null && !(strDisplayCategoryId.equals(""))) {
				displayCategoryId =Long.valueOf(strDisplayCategoryId);
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
			pagination.setListName(LISTCANDIDATETESTREPORTVIEWMODELS);

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, 1);
			} else {
				model.addAttribute(ISADMIN, 0);
			}

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);

			/** 3 Get Object list. */
			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName(CANDIDATEFIRSTNAME);
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objTestReportServicesImpl.pagination(null, pagination,
						searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objTestReportServicesImpl.pagination(null, pagination,
						searchText, model);
			}
			return TESTREPORTCANDIDATETESTREPORT;
		} catch (Exception ex) {
			LOGGER.error("Exception in listGet TestReportControler mapping",ex);
			model.addAttribute(EXCEPTIONSTRING, ex);
			return ERRORPAGE;
		}
	}

	/**
	 * Post method for Candidate Report View Model List Pagination - Next
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
		pagination.setListName(LISTCANDIDATETESTREPORTVIEWMODELS);
		TestReportServicesImpl objTestReportServicesImpl = new TestReportServicesImpl();
		try {			
			Long examEventId =0l;
			Long collectionId =0l;
			Long displayCategoryId =0l;
			
			String strExamEventId=request.getParameter(EXAMEVENTID);
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				 examEventId =Long.valueOf(strExamEventId);
			}
			
			String strCollectionId=request.getParameter(COLLECTIONID);
			if (strCollectionId != null && !(strCollectionId.equals(""))) {
				collectionId =Long.valueOf(strCollectionId);
			}
			
			String strDisplayCategoryId=request.getParameter(DISPLAYCATEGORYID);
			if (strDisplayCategoryId != null && !(strDisplayCategoryId.equals(""))) {
				displayCategoryId =Long.valueOf(strDisplayCategoryId);
			}

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, 1);
			} else {
				model.addAttribute(ISADMIN, 0);
			}

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);

			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName(CANDIDATEFIRSTNAME);
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objTestReportServicesImpl.paginationNext(null, pagination,
						searchText, model);
			} else {
			/*	pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objTestReportServicesImpl.paginationNext(null, pagination,
						searchText, model);
			}
		} catch (Exception ex) {
			LOGGER.error("Exception in nextGet TestReportControler mapping: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return TESTREPORTCANDIDATETESTREPORT;
	}

	/**
	 * Post method for Candidate Report View Model List Pagination - Previous
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
		pagination.setListName(LISTCANDIDATETESTREPORTVIEWMODELS);
		TestReportServicesImpl objTestReportServicesImpl = new TestReportServicesImpl();
		try {			
			Long examEventId =0l;
			Long collectionId =0l;
			Long displayCategoryId =0l;
			
			String strExamEventId=request.getParameter(EXAMEVENTID);
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				 examEventId =Long.valueOf(strExamEventId);
			}
			
			String strCollectionId=request.getParameter(COLLECTIONID);
			if (strCollectionId != null && !(strCollectionId.equals(""))) {
				collectionId =Long.valueOf(strCollectionId);
			}
			
			String strDisplayCategoryId=request.getParameter(DISPLAYCATEGORYID);
			if (strDisplayCategoryId != null && !(strDisplayCategoryId.equals(""))) {
				displayCategoryId =Long.valueOf(strDisplayCategoryId);
			}

			// get user form session to find user role
			VenueUser user = SessionHelper.getLogedInUser(request);
			if (user.getFkRoleID() == 1) {
				model.addAttribute(ISADMIN, 1);
			} else {
				model.addAttribute(ISADMIN, 0);
			}

			model.addAttribute(EXAMEVENTID, examEventId);
			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);

			if (searchText != null && !(searchText.equals(""))) {
				pagination.setPropertyName(CANDIDATEFIRSTNAME);
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objTestReportServicesImpl.paginationPrev(null, pagination,
						searchText, model);
			} else {
				/*pagination.setRecordsPerPage(RECORDSPERPAGE);*/
				objTestReportServicesImpl.paginationPrev(null, pagination,
						searchText, model);
			}
		} catch (Exception ex) {
			LOGGER.error("Exception in prevGet TestReportControler mapping: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return TESTREPORTCANDIDATETESTREPORT;
	}

	/**
	 * Get method for Attempted Paper Test Report
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/AttemptedPaperTestReport" }, method = RequestMethod.GET)
	public String getAttemptedTestReport(Model model, HttpServletRequest request) {
		try {			
			Long examEventId =0l;
			Long collectionId =0l;
			Long displayCategoryId =0l;
			Long candidateId=0l;
			
			String strExamEventId=request.getParameter(EXAMEVENTID);
			if (strExamEventId != null && !(strExamEventId.equals(""))) {
				 examEventId =Long.valueOf(strExamEventId);
			}
			
			String strCollectionId=request.getParameter(COLLECTIONID);
			if (strCollectionId != null && !(strCollectionId.equals(""))) {
				collectionId =Long.valueOf(strCollectionId);
			}
			
			String strDisplayCategoryId=request.getParameter(DISPLAYCATEGORYID);
			if (strDisplayCategoryId != null && !(strDisplayCategoryId.equals(""))) {
				displayCategoryId =Long.valueOf(strDisplayCategoryId);
			}
						
			String strCandidateId=request.getParameter(CANDIDATEID);
			if (strCandidateId != null && !(strCandidateId.equals(""))) {
				candidateId =Long.valueOf(strCandidateId);
			}

			// get list of ExamSubjectPaperViewModel of attempted paper details
			TestReportServicesImpl objTestReportServicesImpl = new TestReportServicesImpl();
			List<ExamDisplayCategoryPaperViewModel> listExamDisplayCategoryPaperViewModel = new ArrayList<ExamDisplayCategoryPaperViewModel>();
			listExamDisplayCategoryPaperViewModel = objTestReportServicesImpl.getAttemptedPapersDetails(examEventId, displayCategoryId, candidateId);

			// mapDisplayCategory- keep details of display category(subject)
			Map<Long, String> mapDisplayCategory = new HashMap<Long, String>();
			
			// mapDisplayCategoryExamDisplayCategoryPaper- keep details of subject id and attempted paper for that subject
			Map<Long, List<ExamDisplayCategoryPaperViewModel>> mapDisplayCategoryExamDisplayCategoryPaper = new HashMap<Long, List<ExamDisplayCategoryPaperViewModel>>();
			if (listExamDisplayCategoryPaperViewModel != null
					&& listExamDisplayCategoryPaperViewModel.size() > 0) {
				for (int i = 0; i < listExamDisplayCategoryPaperViewModel.size(); i++) {
					mapDisplayCategory.put(listExamDisplayCategoryPaperViewModel.get(i).getDisplayCategoryLanguage().getDisplayCategoryLanguageID(),
							listExamDisplayCategoryPaperViewModel.get(i).getDisplayCategoryLanguage().getDisplayCategoryName());
				}
			}

			// fill mapSubjectPaper using mapSubject
			if (mapDisplayCategory != null && mapDisplayCategory.size() > 0	&& listExamDisplayCategoryPaperViewModel != null
					&& listExamDisplayCategoryPaperViewModel.size() > 0) {
				Set<Long> keys = mapDisplayCategory.keySet();
				Iterator<Long> itr = keys.iterator();
				Long key;

				// fill list of paper (ExamDisplayCategoryPaperViewModel used for paper details and its configuration) for display category(subject)
				while (itr.hasNext()) {
					key = (Long) itr.next();
					List<ExamDisplayCategoryPaperViewModel> listPaper=new ArrayList<ExamDisplayCategoryPaperViewModel>();
					for (int i = 0; i < listExamDisplayCategoryPaperViewModel.size(); i++) {
						if (key.equals(listExamDisplayCategoryPaperViewModel.get(i).getDisplayCategoryLanguage().getDisplayCategoryLanguageID())) {
							listPaper.add(listExamDisplayCategoryPaperViewModel.get(i));
						}
					}
					mapDisplayCategoryExamDisplayCategoryPaper.put(key, listPaper);

				}
			}

			// get exam event
			ExamEventServiceImpl examEventServiceImpl = new ExamEventServiceImpl();
			ExamEvent examEvent = examEventServiceImpl.getExamEventByID(examEventId);

			// get candidate object
			CandidateServiceImpl objCandidateServiceImpl = new CandidateServiceImpl();
			Candidate objCandidate = objCandidateServiceImpl.getCandidateByCandidateID(candidateId);
			String szCandidateName = "";
			if (objCandidate != null) {
				if (objCandidate.getCandidateFirstName() !=null) {
					szCandidateName = objCandidate.getCandidateFirstName() + " ";
				}
				if (objCandidate.getCandidateLastName() !=null) {
					szCandidateName = szCandidateName+objCandidate.getCandidateLastName();
				}						
			}
			model.addAttribute("candidateName", szCandidateName);

			model.addAttribute("examEvent", examEvent);
			model.addAttribute(CANDIDATEID, candidateId);

			model.addAttribute(COLLECTIONID, collectionId);
			model.addAttribute(DISPLAYCATEGORYID, displayCategoryId);

			model.addAttribute("mapDisplayCategory", mapDisplayCategory);
			model.addAttribute("mapDisplayCategoryExamDisplayCategoryPaper", mapDisplayCategoryExamDisplayCategoryPaper);

		}catch (Exception ex) {
			LOGGER.error("Exception in getAttemptedTestReport TestReportControler mapping: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Solo/TestReport/AttemptedPaperTestReport";
	}

	/**
	 * Get method for Section wise Marks	
	 * @param model
	 * @param request
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/sectionwisemarks" }, method = RequestMethod.GET)
	public String sectionwisemarks(Model model, HttpServletRequest request,Locale locale) {
		//List<PaperSectionMarksViewModel> paperSectionMarksViewModelList=null;
		Long eventid=0l;
		Long paperid=0l;
		try 
		{
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}

			/** 2 Get searchText. */
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName("viewModelList");
			/*pagination.setRecordsPerPage(50000);*/

			if(request.getParameter("examEventSelect")!=null && request.getParameter("paperSelect")!=null)
			{
				eventid=Long.parseLong(request.getParameter("examEventSelect"));
				paperid=Long.parseLong(request.getParameter("paperSelect"));
				model.addAttribute("paperId", paperid);
				model.addAttribute("examEventId", eventid);
				/** 3 Get Object list. */
				if (searchText != null && !(searchText.equals(""))) 
				{
					pagination.setPropertyName("candidateCode");
					new ResultAnalysisServicesImpl().pagination(null, pagination, searchText, model);
				} 
				else 
				{
					new ResultAnalysisServicesImpl().pagination(null, pagination, searchText, model);
				}
			}
				
			List<ExamEvent> examEventList=new ExamEventServiceImpl().getExamEventList();
			model.addAttribute("activeExamEventList", examEventList);
			ExamVenue examVenue=new ExamVenueActivationServicesImpl().getExamVenue();
			model.addAttribute("venue", examVenue);
			
			//paperSectionMarksViewModelList=new ResultAnalysisServicesImpl().getPaperSectionMarks(eventid, paperid);
			//model.addAttribute("paperId", paperid);
			//model.addAttribute("examEventId", eventid);
			//model.addAttribute("viewModelList",paperSectionMarksViewModelList);

		} catch (Exception ex) {
			LOGGER.error("Exception in sectionwisemarks: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

		return "Solo/TestReport/sectionwiseMarkDistributionReport";

	}
	
	/**
	 * Post method for Section wise Marks List Pagination - Previous	
	 * @param model
	 * @param request
	 * @param locale
	 * @param pagination
	 * @param searchText
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/sectionwisemarksprev" }, method = RequestMethod.POST)
	public String sectionwisemarksPrev(Model model, HttpServletRequest request,Locale locale,@ModelAttribute("pagination") Pagination pagination,String searchText)
	{
		//List<PaperSectionMarksViewModel> paperSectionMarksViewModelList=null;
		Long eventid=0l;
		Long paperid=0l;
		try 
		{
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}

			/** 2 Get searchText. */
			
			pagination.setListName("viewModelList");
			if(request.getParameter("examEventSelect")!=null && request.getParameter("paperSelect")!=null)
			{
				eventid=Long.parseLong(request.getParameter("examEventSelect"));
				paperid=Long.parseLong(request.getParameter("paperSelect"));
				model.addAttribute("paperId", paperid);
				model.addAttribute("examEventId", eventid);
				/** 3 Get Object list. */
				if (searchText != null && !(searchText.equals(""))) 
				{
					pagination.setPropertyName("candidateCode");
					new ResultAnalysisServicesImpl().paginationPrev(null, pagination, searchText, model);
				} 
				else 
				{
					new ResultAnalysisServicesImpl().paginationPrev(null, pagination, null, model);
				}
			}
				
			List<ExamEvent> examEventList=new ExamEventServiceImpl().getExamEventList();
			model.addAttribute("activeExamEventList", examEventList);
			ExamVenue examVenue=new ExamVenueActivationServicesImpl().getExamVenue();
			model.addAttribute("venue", examVenue);

		} catch (Exception ex) {
			LOGGER.error("Exception in sectionwisemarks Prev: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

		return "Solo/TestReport/sectionwiseMarkDistributionReport";

	}
	
	/**
	 * Post method for Section wise Marks List Pagination - Next	
	 * @param model
	 * @param request
	 * @param locale
	 * @param pagination
	 * @param searchText
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/sectionwisemarksnext" }, method = RequestMethod.POST)
	public String sectionwisemarksNext(Model model, HttpServletRequest request,Locale locale,@ModelAttribute("pagination") Pagination pagination,String searchText)
	{
		//List<PaperSectionMarksViewModel> paperSectionMarksViewModelList=null;
		Long eventid=0l;
		Long paperid=0l;
		try 
		{
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}

			/** 2 Get searchText. */
			
			pagination.setListName("viewModelList");
			if(request.getParameter("examEventSelect")!=null && request.getParameter("paperSelect")!=null)
			{
				eventid=Long.parseLong(request.getParameter("examEventSelect"));
				paperid=Long.parseLong(request.getParameter("paperSelect"));
				model.addAttribute("paperId", paperid);
				model.addAttribute("examEventId", eventid);
				/** 3 Get Object list. */
				if (searchText != null && !(searchText.equals(""))) 
				{
					pagination.setPropertyName("candidateCode");
					new ResultAnalysisServicesImpl().paginationNext(null, pagination, searchText, model);
				} 
				else 
				{
					new ResultAnalysisServicesImpl().paginationNext(null, pagination, null, model);
				}
			}
				
			List<ExamEvent> examEventList=new ExamEventServiceImpl().getExamEventList();
			model.addAttribute("activeExamEventList", examEventList);
			ExamVenue examVenue=new ExamVenueActivationServicesImpl().getExamVenue();
			model.addAttribute("venue", examVenue);

		} catch (Exception ex) {
			LOGGER.error("Exception in sectionwisemarks Prev: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

		return "Solo/TestReport/sectionwiseMarkDistributionReport";

	}
	
	/**
	 * Post method for Non-typing Paper List 
	 * @param examEvent
	 * @param request
	 * @return List<Paper> this returns the Paper List
	 */
	@RequestMapping(value = "/listEventPapers.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<Paper> getPaperListNoTyping(@RequestBody ExamEvent examEvent,
			HttpServletRequest request) {
		List<Paper> paperList = null;
		try {
			PaperServiceImpl objPaperServiceImpl = new PaperServiceImpl();
			paperList = new ArrayList<Paper>();
			paperList = objPaperServiceImpl.getPaperAssociatedWithEvent(examEvent.getExamEventID(),false);
		} catch (Exception e) {
			LOGGER.error("Exception in getPaperList: ", e);
		}
		return paperList;
	}
	
	/**
	 * Get method for Question Attempt Count Report
	 * @param model
	 * @param request
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/questAtmptCntRpt" }, method = RequestMethod.GET)
	public String getQuestAtmptCntRpt(Model model, HttpServletRequest request,String messageid, Locale locale) {
		if (messageid != null && !messageid.isEmpty()) {
			MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
		}
		List<ExamEvent> examEventList=new ExamEventServiceImpl().getExamEventList();
		model.addAttribute("activeExamEventList", examEventList);
		return "Solo/TestReport/QuestAtmptCntReport";
	}
	
	/**
	 * Post method for Question Attempt Count Report
	 * @param model
	 * @param request
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/questAtmptCntRpt" }, method = RequestMethod.POST)
	public String postQuestAtmptCntRpt(Model model, HttpServletRequest request,String messageid, Locale locale) {
		//List<PaperSectionMarksViewModel> paperSectionMarksViewModelList=null;
		Long eventid=0l;
		Long paperid=0l;
		try 
		{
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}

			/** 2 Get searchText. */
			String searchText = request.getParameter("searchText");
			Pagination pagination = new Pagination();
			pagination.setListName("viewModelList");
			/*pagination.setRecordsPerPage(50000);*/

			if(request.getParameter("examEventSelect")!=null && request.getParameter("paperSelect")!=null)
			{
				eventid=Long.parseLong(request.getParameter("examEventSelect"));
				paperid=Long.parseLong(request.getParameter("paperSelect"));
				model.addAttribute("paperId", paperid);
				model.addAttribute("examEventId", eventid);
				/** 3 Get Object list. */
				if (searchText != null && !(searchText.equals(""))) 
				{
					pagination.setPropertyName("candidateCode");
					new QuestAtmptCntRptServiceImpl().pagination(null, pagination, searchText, model);
				} 
				else 
				{
					new QuestAtmptCntRptServiceImpl().pagination(null, pagination, searchText, model);
				}
			}
				
			List<ExamEvent> examEventList=new ExamEventServiceImpl().getExamEventList();
			model.addAttribute("activeExamEventList", examEventList);
			ExamVenue examVenue=new ExamVenueActivationServicesImpl().getExamVenue();
			model.addAttribute("venue", examVenue);
	
		} catch (Exception ex) {
			LOGGER.error("Exception in getQuestAtmptCntRpt: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

		return "Solo/TestReport/QuestAtmptCntReport";

	}
	
	/**
	 * Post method for Question Attempt Count List Pagination - Previous
	 * @param model
	 * @param request
	 * @param locale
	 * @param pagination
	 * @param searchText
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/showQuestAtmptCntRptPrev" }, method = RequestMethod.POST)
	public String showQuestAtmptCntRptPrev(Model model, HttpServletRequest request,Locale locale,@ModelAttribute("pagination") Pagination pagination,String searchText) {
		//List<PaperSectionMarksViewModel> paperSectionMarksViewModelList=null;
				Long eventid=0l;
				Long paperid=0l;
				try 
				{
					String messageId = request.getParameter("messageid");
					if (messageId != null && !(messageId.equals(""))) {
						MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
					}

					/** 2 Get searchText. */
					
					pagination.setListName("viewModelList");
					if(request.getParameter("examEventSelect")!=null && request.getParameter("paperSelect")!=null)
					{
						eventid=Long.parseLong(request.getParameter("examEventSelect"));
						paperid=Long.parseLong(request.getParameter("paperSelect"));
						model.addAttribute("paperId", paperid);
						model.addAttribute("examEventId", eventid);
						/** 3 Get Object list. */
						if (searchText != null && !(searchText.equals(""))) 
						{
							pagination.setPropertyName("candidateCode");
							new QuestAtmptCntRptServiceImpl().paginationPrev(null, pagination, searchText, model);
						} 
						else 
						{
							new QuestAtmptCntRptServiceImpl().paginationPrev(null, pagination, null, model);
						}
					}
						
					List<ExamEvent> examEventList=new ExamEventServiceImpl().getExamEventList();
					model.addAttribute("activeExamEventList", examEventList);
					ExamVenue examVenue=new ExamVenueActivationServicesImpl().getExamVenue();
					model.addAttribute("venue", examVenue);

				} catch (Exception ex) {
					LOGGER.error("Exception in sectionwisemarks Prev: ",ex);
					model.addAttribute(Constants.EXCEPTIONSTRING, ex);
					return Constants.ERRORPAGE;
				}

				return "Solo/TestReport/QuestAtmptCntReport";

	}
	
	/**
	 * Post method for Question Attempt Count List Pagination - Next
	 * @param model
	 * @param request
	 * @param locale
	 * @param pagination
	 * @param searchText
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/showQuestAtmptCntRptNext" }, method = RequestMethod.POST)
	public String showQuestAtmptCntRptNext(Model model, HttpServletRequest request,Locale locale,@ModelAttribute("pagination") Pagination pagination,String searchText)
	{
		//List<PaperSectionMarksViewModel> paperSectionMarksViewModelList=null;
		Long eventid=0l;
		Long paperid=0l;
		try 
		{
			String messageId = request.getParameter("messageid");
			if (messageId != null && !(messageId.equals(""))) {
				MKCLUtility.addMessage(Integer.parseInt(messageId), model,locale);
			}

			/** 2 Get searchText. */
			
			pagination.setListName("viewModelList");
			if(request.getParameter("examEventSelect")!=null && request.getParameter("paperSelect")!=null)
			{
				eventid=Long.parseLong(request.getParameter("examEventSelect"));
				paperid=Long.parseLong(request.getParameter("paperSelect"));
				model.addAttribute("paperId", paperid);
				model.addAttribute("examEventId", eventid);
				/** 3 Get Object list. */
				if (searchText != null && !(searchText.equals(""))) 
				{
					pagination.setPropertyName("candidateCode");
					new QuestAtmptCntRptServiceImpl().paginationNext(null, pagination, searchText, model);
				} 
				else 
				{
					new QuestAtmptCntRptServiceImpl().paginationNext(null, pagination, null, model);
				}
			}
				
			List<ExamEvent> examEventList=new ExamEventServiceImpl().getExamEventList();
			model.addAttribute("activeExamEventList", examEventList);
			ExamVenue examVenue=new ExamVenueActivationServicesImpl().getExamVenue();
			model.addAttribute("venue", examVenue);

		} catch (Exception ex) {
			LOGGER.error("Exception in showQuestAtmptCntRptNext: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Solo/TestReport/QuestAtmptCntReport";
	}
}
