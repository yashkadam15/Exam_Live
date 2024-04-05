package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.admin.services.CandidateCollectionAssociationServicesImpl;
import mkcl.oesclient.admin.services.CollectionMasterServicesImpl;
import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.admin.services.ICollectionMasterServices;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.IExamEventService;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.commons.validators.CandidateCollectionAssociationValidator;
import mkcl.oesclient.model.CandidateCollectionAssociation;
import mkcl.oesclient.model.CandidateExam;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.solo.services.CandidateExamServiceImpl;
import mkcl.oesclient.solo.services.ICandidateExamService;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ViewModelDivisonExamEvenAssociation;
import mkcl.oespcs.model.ExamEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author Sonam
 * 
 */
@Controller
@RequestMapping("candidateCollectionAssociation")
public class CandidateCollectionAssociationController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CandidateCollectionAssociationController.class);
	private static ICollectionMasterServices collectionmasterObjService = new CollectionMasterServicesImpl();
	private static IExamEventService examEventService = new ExamEventServiceImpl();
	private static ICandidateExamService candidateExamService = new CandidateExamServiceImpl();
	private CandidateCollectionAssociationValidator associationValidator = null;
	private CandidateCollectionAssociationServicesImpl candidateCollectionAssociationServiceObj = null;
	
	private static final String COLLECTIONMASTERLIST="CollectionMasterList";
	private static final String EXAMEVENTLIST="examEventList";
	private static final String CANDIDATEDCOLLECTIONASSOCIATION="candidateCollectionAssociation";
	private static final String CANDIDATECOLLECTIONASSOCIATION_ADDCANDIDATE="Admin/candidateCollectionAssociation/addcandidate";

	@InitBinder
	public void initBinder(WebDataBinder dataBinder) {
	dataBinder.setAutoGrowCollectionLimit(1500);
	}
	
	/**
	 * Method to fetch the Active Exam Event List 
	 * @param request
	 * @return List<ExamEvent> this returns the active exam event list
	 */
	@ModelAttribute("activeExamEventList")
	public List<ExamEvent> getactiveExamEventList(HttpServletRequest request) {
		List<ExamEvent> activeExamEventList = null;
		try {
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			/* Active exam Event List */
			activeExamEventList = eServiceObj.getActiveExamEventList(SessionHelper.getLogedInUser(request));
		} catch (Exception e) {
		LOGGER.error("Exception occured in getactiveExamEventList",e);
		}
		return activeExamEventList;
	}

	
	/**
	 * Post method to fetch the Division List
	 * @param examEventID
	 * @param request
	 * @return List<CollectionMaster> this returns the division list
	 */
	@RequestMapping(value = "/collectionAccEventRole.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<CollectionMaster> getDivisionList(
			@RequestBody ExamEvent examEventID, HttpServletRequest request) {
		List<CollectionMaster> collectionList=null;
		try {
			VenueUser user = SessionHelper.getLogedInUser(request);

			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			collectionList = new ArrayList<CollectionMaster>();
			collectionList = eServiceObj.getCollectionMasterAccRole(user,
					examEventID.getExamEventID());
		} catch (Exception e) {
		LOGGER.error("Exception occured in LoginReportController - getDivisionList ",e);
		}
		return collectionList;
	}
	
	/**
	 * Get method to Add Candidate
	 * @param model
	 * @param request
	 * @param locale
	 * @param session
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/addcandidate" }, method = RequestMethod.GET)
	public String listGet(Model model, HttpServletRequest request,
			Locale locale, SessionHelper session) {		

		try {
			CandidateCollectionAssociation candidateCollectionAssociation = new CandidateCollectionAssociation();
			model.addAttribute(CANDIDATEDCOLLECTIONASSOCIATION,
					candidateCollectionAssociation);

		} catch (Exception ex) {
			LOGGER.error("Exception occured in addcandidate: " , ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return CANDIDATECOLLECTIONASSOCIATION_ADDCANDIDATE;
	}
	
	/**
	 * Post method to display Candidate Details
	 * @param model
	 * @param request
	 * @param candidateCollectionAssociation
	 * @param errors
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/showCandidate" }, method = RequestMethod.POST)
	public String showCandidate(
			Model model,
			HttpServletRequest request,
			@ModelAttribute(CANDIDATEDCOLLECTIONASSOCIATION) CandidateCollectionAssociation candidateCollectionAssociation,
			BindingResult errors, Locale locale) {
		
		LinkedHashMap<Long, String> mapCandidateList = new LinkedHashMap<Long, String>();
		List<CandidateCollectionAssociation> candidateCollectionAssociationsList = new ArrayList<CandidateCollectionAssociation>();
		boolean showCandidate = true;
		ViewModelDivisonExamEvenAssociation viewDivisonExamEvenAssociation = new ViewModelDivisonExamEvenAssociation();
		List<CollectionMaster> collectionMastersList = new ArrayList<CollectionMaster>();
		List<ExamEvent> examEventList = new ArrayList<ExamEvent>();
		
		List<CandidateExam> candidateExamList = new ArrayList<CandidateExam>();
		CollectionMaster collectionMaster = new CollectionMaster();
		ExamEvent examEvent = new ExamEvent();
		
		boolean result = false;
		String message = "";
		candidateCollectionAssociationServiceObj=new CandidateCollectionAssociationServicesImpl();
		List<CandidateCollectionAssociation> candidateHaveDivisionList = new ArrayList<CandidateCollectionAssociation>();
		try {
			
			collectionMastersList = collectionmasterObjService.getCollectionMaster();
			candidateExamList = candidateExamService
					.getCandidateByEventID(candidateCollectionAssociation
							.getFkExamEventID());
			
			examEventList = examEventService.getExamEventList();
			candidateCollectionAssociationsList = candidateCollectionAssociationServiceObj
					.getCandidateCollectionAssociationByEventCollectionID(
							candidateCollectionAssociation.getFkExamEventID(),
							candidateCollectionAssociation.getFkCollectionID());
			if (candidateCollectionAssociationsList.size() == 0) {
				candidateCollectionAssociationsList = candidateCollectionAssociationServiceObj
						.getCandidateCollectionAssociationByCollectionID(candidateCollectionAssociation
								.getFkCollectionID());
				if (candidateCollectionAssociationsList.size() > 0) {
					message = "Do you want to associate previous division candidate for this event also.";
					model.addAttribute("message", message);
				}
			}
			candidateHaveDivisionList = candidateCollectionAssociationServiceObj
					.getAllCandidateCollectionAssociation();

			for (int i = 0; i < candidateExamList.size(); i++) {

				result = false;

				for (CandidateCollectionAssociation divisionAssociation : candidateHaveDivisionList) {
					if ((candidateExamList.get(i).getFkCandidateID() == divisionAssociation
							.getFkCandidateID())
							&& (divisionAssociation.getFkCollectionID() != candidateCollectionAssociation
									.getFkCollectionID())) {
						result = true;
					}
				}
				if (result) {
					candidateExamList.get(i).setFkCandidateID(0);

				}

			}
			if (candidateCollectionAssociation != null) {
				associationValidator=new CandidateCollectionAssociationValidator();
				associationValidator.validate(candidateCollectionAssociation,
						errors);
				if (errors.hasErrors()) {
					model.addAttribute(COLLECTIONMASTERLIST,
							collectionMastersList);
					model.addAttribute(EXAMEVENTLIST, examEventList);
					return CANDIDATECOLLECTIONASSOCIATION_ADDCANDIDATE;
				}

				if (candidateExamList.size() > 0) {
					for (CandidateExam candidateExam : candidateExamList) {
						if (candidateExam.getFkCandidateID() != 0) {
							mapCandidateList.put(candidateExam.getCandidate()
									.getCandidateID(), candidateExam
									.getCandidate().getCandidateFirstName()
									+ " "
									+ candidateExam.getCandidate()
											.getCandidateLastName());
						}
					}
				}

				model.addAttribute(COLLECTIONMASTERLIST, collectionMastersList);
				model.addAttribute(EXAMEVENTLIST, examEventList);
				model.addAttribute("candidateExamList", candidateExamList);
				model.addAttribute("mapCandidateList", mapCandidateList);
				model.addAttribute("showCandidate", showCandidate);
				model.addAttribute("candidateHaveDivisionList",
						candidateHaveDivisionList);

				viewDivisonExamEvenAssociation
						.setCandidateCollectionAssociationList(candidateCollectionAssociationsList);

				collectionMaster.setCollectionID(candidateCollectionAssociation
						.getFkCollectionID());
				examEvent.setExamEventID(candidateCollectionAssociation
						.getFkExamEventID());

				viewDivisonExamEvenAssociation
						.setCollectionMaster(collectionMaster);
				viewDivisonExamEvenAssociation.setExamEvent(examEvent);
				model.addAttribute(CANDIDATEDCOLLECTIONASSOCIATION,
						candidateCollectionAssociation);
				model.addAttribute("viewDivisonExamEvenAssociation",
						viewDivisonExamEvenAssociation);
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in showCandidate: " , ex);
			model.addAttribute(COLLECTIONMASTERLIST, collectionMastersList);
			model.addAttribute(EXAMEVENTLIST, examEventList);			
			return CANDIDATECOLLECTIONASSOCIATION_ADDCANDIDATE;
		}
		model.addAttribute("examEventId", candidateCollectionAssociation
							.getFkExamEventID());
		model.addAttribute("collectionID", candidateCollectionAssociation.getFkCollectionID());
		return CANDIDATECOLLECTIONASSOCIATION_ADDCANDIDATE;
	}

	/**
	 * Post method to Add Candidate
	 * @param model
	 * @param request
	 * @param viewModelDivisonExamEvenAssociation
	 * @param examEventId
	 * @param collectionID
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/addCandidate" }, method = RequestMethod.POST)
	public String addCandidate(
			Model model,
			HttpServletRequest request,
			@ModelAttribute("viewDivisonExamEvenAssociation") ViewModelDivisonExamEvenAssociation viewModelDivisonExamEvenAssociation,Long examEventId,Long collectionID,
			Locale locale) {
		
		VenueUser user = SessionHelper.getLogedInUser(request);
		List<CandidateCollectionAssociation> candidateDivisionAssociationList = new ArrayList<CandidateCollectionAssociation>();
		CandidateCollectionAssociation objCandidateCollectionAssociation = new CandidateCollectionAssociation();
		CandidateCollectionAssociation candidateDivisionAssociation = new CandidateCollectionAssociation();
		List<CollectionMaster> divisionMastersList = new ArrayList<CollectionMaster>();
		List<ExamEvent> examEventList = new ArrayList<ExamEvent>();
		candidateCollectionAssociationServiceObj=new CandidateCollectionAssociationServicesImpl();
		boolean isCandidateSave = false;
		try {
			divisionMastersList = collectionmasterObjService.getCollectionMaster();
			examEventList = examEventService.getExamEventList();
			model.addAttribute(COLLECTIONMASTERLIST, divisionMastersList);
			model.addAttribute(EXAMEVENTLIST, examEventList);
			model.addAttribute(CANDIDATEDCOLLECTIONASSOCIATION,
					candidateDivisionAssociation);
			if (viewModelDivisonExamEvenAssociation != null) {
				for (CandidateCollectionAssociation association : viewModelDivisonExamEvenAssociation
						.getCandidateCollectionAssociationList()) {
					if (association.getFkCandidateID() != null) {
						isCandidateSave = true;
						objCandidateCollectionAssociation = new CandidateCollectionAssociation();
						objCandidateCollectionAssociation
								.setFkCandidateID(association
										.getFkCandidateID());
						objCandidateCollectionAssociation
								.setFkCollectionID(viewModelDivisonExamEvenAssociation
										.getCollectionMaster().getCollectionID());
						objCandidateCollectionAssociation
								.setFkExamEventID(viewModelDivisonExamEvenAssociation
										.getExamEvent().getExamEventID());
						// For setting value of Created date,CreatedBy,Deleted,odifiedDate,ModifiedBy
						objCandidateCollectionAssociation
								.setDateCreated(new Date());
						objCandidateCollectionAssociation.setCreatedBy(user
								.getUserName());

						candidateDivisionAssociationList
								.add(objCandidateCollectionAssociation);
					}
				}
			}
			viewModelDivisonExamEvenAssociation
					.setCandidateCollectionAssociationList(candidateDivisionAssociationList);
			candidateCollectionAssociationServiceObj
					.addCandidateCollectionAssociation(viewModelDivisonExamEvenAssociation);

			if (isCandidateSave) {
				MKCLUtility.addMessage(
						MessageConstants.SUCCESSFULLY_ADDED_RECORD, model,
						locale);

			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in addCandidate: " , ex);
			MKCLUtility.addMessage(MessageConstants.FAILED_TO_ADD, model,
					locale);			
			return CANDIDATECOLLECTIONASSOCIATION_ADDCANDIDATE;

		}
		model.addAttribute("examEventId", examEventId);
		model.addAttribute("collectionID", collectionID);
		return CANDIDATECOLLECTIONASSOCIATION_ADDCANDIDATE;
	}

}
