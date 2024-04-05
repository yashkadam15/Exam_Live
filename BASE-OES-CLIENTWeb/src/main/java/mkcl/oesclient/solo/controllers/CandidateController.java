package mkcl.oesclient.solo.controllers;

//Modified by Reena for setting based client 03-dec2013
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import mkcl.oesclient.commons.controllers.ExamLocaleThemeResolver;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oesclient.commons.services.ItemBankImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.solo.services.BonusWeekServiceImpl;
import mkcl.oesclient.solo.services.CandidateServiceImpl;
import mkcl.oesclient.solo.services.IBonusWeekService;
import mkcl.oesclient.solo.services.ISchedulePaperAssociationServices;
import mkcl.oesclient.solo.services.SchedulePaperAssociationServicesImpl;
import mkcl.oesclient.systemaudit.AuditVerificationMethods;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModel;
import mkcl.oesclient.viewmodel.GroupMasterCandidatesViewModel;
import mkcl.oesclient.viewmodel.PaperSectionItemBankViewModel;
import mkcl.oespcs.model.AssessmentType;
import mkcl.oespcs.model.DaysOfWeek;
import mkcl.oespcs.model.DisplayCategoryLanguage;
import mkcl.oespcs.model.EventCategory;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamEventScheduleTypeAssociation;
import mkcl.oespcs.model.ExamVenue;
import mkcl.oespcs.model.LocalSchedular;
import mkcl.oespcs.model.ScheduleMaster;
import mkcl.oespcs.model.ScheduleType;

@Controller
@RequestMapping("candidateModule")
public class CandidateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CandidateController.class);
	private static final String EXCEPTIONSTR = "Exception Occured : ";
	private static final String UNCHECKED = "unchecked";
	private static final int SCHEDULELENGTH = 6;
	private static final int SCHEDULEREPEAT = -1;
	private static final int SCHEDULESINC = 1;
	private static final int FIVE = 5;
	private static final int FIVEHUNDRED = 500;
	
	@Autowired
	private ExamLocaleThemeResolver examLocaleThemeResolver;
	
	/**
	 * Get method for Home 
	 * @param model
	 * @param locale
	 * @param req
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/homepage" }, method = RequestMethod.GET)
	public String homepageGet(Model model, Locale locale, HttpServletRequest req,HttpServletResponse response) {

		List<ExamDisplayCategoryPaperViewModel> activePapers = null;
		List<ExamDisplayCategoryPaperViewModel> nonActivePapers = null;
		Candidate candidate = null;
		String messageid=null;
		try {
			
			/* Added by Reena : 24 July 2015
			 * This call should always be on the top of each function as locale further 
			 accessed will not behave as required 
			 This call will set back Locale to application Default if Candidate comes from Exam Interface
			 */
			
			if(req.getParameter("changeLocale")!=null)
			examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(req, response);	
			
			
			try {
				messageid= req.getParameter("messageId");
				if (messageid != null && !messageid.isEmpty()) {
					MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
				}
			} catch (Exception e1) {
				// exception skiped
			}

			// get candidate ID from Session
			candidate = SessionHelper.getCandidate(req);
			// get Exam Event
			ExamEvent examEvent = SessionHelper.getExamEvent(req);
			if(examEvent != null && examEvent.getEventCategory()==EventCategory.ConfidentialExam){
				return "redirect:/candidateModule/confExamHomePage?messageId="+messageid;
			}
					
			
			// Code to get client Id
			ExamVenueActivationServicesImpl examVenueActivationServicesImpl=new ExamVenueActivationServicesImpl();
			long clientId=examVenueActivationServicesImpl.getExamVenueClientID();
			model.addAttribute("clientId", clientId);
			
			ISchedulePaperAssociationServices schedulePaperAssociationServices = new SchedulePaperAssociationServicesImpl();
			//ItemBankImpl itemBankImpl = new ItemBankImpl();
			IBonusWeekService bonusWeekService = new BonusWeekServiceImpl();
			// get CollectionID
			long collectionID = SessionHelper.getCollectionID(req);
			if (candidate != null && examEvent != null && collectionID > 0) {
				long candidateID = candidate.getCandidateID();

				// paper groups
				Set<Long> paperGroupIds = new HashSet<Long>();
				// active paper item bank association
				Map<Long, String> allPaperIDs = new HashMap<Long, String>();
				// get all active papers
				// get list Of Active papers
				activePapers = schedulePaperAssociationServices.getActivePapersFromCandidateID(candidateID, examEvent.getExamEventID(), collectionID, EventCategory.TestSeries);
				activePapers = getActivePapers(activePapers, allPaperIDs, paperGroupIds, model);
				model.addAttribute("activePapers", activePapers);
				// show history papers if showAllPapers attribute is not set
				// if (!examEvent.getShowAllPapers()) {
				// Non - Active Paper Item Banks Association
				// get all non active papers
				// get list Of Non-Active papers
				nonActivePapers = schedulePaperAssociationServices.getHistoryPapersFromCandidateID(candidateID, examEvent.getExamEventID(), collectionID, FIVE);
				nonActivePapers = getNonActivePapers(nonActivePapers, allPaperIDs, model);
				model.addAttribute("nonActivePapers", nonActivePapers);
				// }
				// Syllabus for active papers
				//List<Long> paperIDs = new ArrayList<Long>(allPaperIDs.keySet());
				//paperSectionItemBankAssocMap = itemBankImpl.getPaperItemBankAssociationListByPaperID(paperIDs);
				//getPapersAssociatedItemBanks(paperSectionItemBankAssocMap, allPaperIDs, model);

				// get Exam Event
				model.addAttribute("currentExamEvent", examEvent);

				// get special week info if local schedular ins candidate
				if (examEvent.getLocalSchedular() == LocalSchedular.Candidate) {

					// get available number of bonus week
					long availableNumberOfBonusWeek = bonusWeekService.getAvailedNumberOfBonusWeeksByCandidateId(candidateID, examEvent.getExamEventID(), examEvent.getMaxPapersScheduleByCandidate());
					model.addAttribute("availableNumberOfBonusWeek", availableNumberOfBonusWeek);

					// get Display category wise paper count schedule by
					// candidate
					long currentScheduleID = schedulePaperAssociationServices.getTodaysScheduleIdByScheduleType(ScheduleType.Week, examEvent.getExamEventID());
					Map<Long, Long> displayCategoryWiseAttemptsMap = bonusWeekService.getCandidateDisplayCategoryAttemptDetails(candidateID, examEvent.getExamEventID(), currentScheduleID);
					model.addAttribute("displayCategoryWiseAttemptsMap", displayCategoryWiseAttemptsMap);

					// check current week is bonus week
					boolean isBonusWeek = bonusWeekService.isBonusWeek(candidateID, examEvent.getExamEventID(), currentScheduleID, examEvent.getMaxPapersScheduleByCandidate());
					model.addAttribute("isBonusWeek", isBonusWeek);

					// get remaining week count
					int remainingWeekCount = bonusWeekService.getRemainingWeeksCount(examEvent.getExamEventID(), ScheduleType.Week);
					model.addAttribute("remainingWeekCount", remainingWeekCount);

					// get total papers and attempted papers by candidate
					List<String> attemptedPaper = bonusWeekService.getAttemptedPaperVsTotalPaperCounts(candidateID, examEvent.getExamEventID());
					String attemptedPaperCnt = "0";
					String totalPaperCnt = "0";
					if (attemptedPaper != null && attemptedPaper.size() > 0) {
						attemptedPaperCnt = attemptedPaper.get(0);
						totalPaperCnt = attemptedPaper.get(1);
					}
					model.addAttribute("attemptedPaperCnt", attemptedPaperCnt);
					model.addAttribute("totalPaperCnt", totalPaperCnt);

				}

				// get candidates associated groups
				// if (paperGroupIds != null && paperGroupIds.size() > 0) {
				// List<GroupMasterCandidatesViewModel> labSessionGroups =
				// schedulePaperAssociationServices.getCandidatesOfEachGroup(paperGroupIds,
				// examEvent.getExamEventID(), collectionID);
				// model.addAttribute("labSessionGroups", labSessionGroups);
				// }
				GroupMasterCandidatesViewModel labSessionGroupInfo = schedulePaperAssociationServices.getGroupInfoFromCandidateID(candidateID, examEvent.getExamEventID(), collectionID);
				model.addAttribute("labSessionGroupInfo", labSessionGroupInfo);

				// send show all papers parameter
				model.addAttribute("examEventShowAllPapapers", examEvent.getShowAllPapers());
                //send reqUserAgent for Secured Browser checking
				model.addAttribute("reqUserAgent", AuditVerificationMethods.getCompatibleSecuredBrowserUserAgent());
				
				int countOfCompletedPapers=0;
				if (examEvent !=null && (examEvent.getExamEventID()==54 || examEvent.getExamEventID()==1025)) {
					countOfCompletedPapers= schedulePaperAssociationServices.getCountOfCompletedPaper(candidateID, examEvent.getExamEventID());
				}
				
				CandidateServiceImpl candidateServiceImpl=new CandidateServiceImpl();
				candidate= candidateServiceImpl.getCandidateByCandidateID(candidateID);
				
				model.addAttribute("countOfCompletedPapers", countOfCompletedPapers);
				model.addAttribute("candidate", candidate);
								
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in homepageGet: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Solo/candidateModule/homepage";
	}

	/* handler for reattempt test */
	/**
	 * Get method for Re-attempt Home Page
	 * @param model
	 * @param locale
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/reattempthomepage" }, method = RequestMethod.GET)
	public String reAttempthomepageGet(Model model, Locale locale, HttpServletRequest req) {

		ISchedulePaperAssociationServices schedulePaperAssociationServices = new SchedulePaperAssociationServicesImpl();
		//ItemBankImpl itemBankImpl = new ItemBankImpl();
		IBonusWeekService bonusWeekService = new BonusWeekServiceImpl();
		List<ExamDisplayCategoryPaperViewModel> nonActivePapers = null;
		Candidate candidate = null;
		List<ExamDisplayCategoryPaperViewModel> papersForreattempting = null;
		//Map<Long, PaperSectionItemBankViewModel> paperSectionItemBankAssocMap = null;
		try {
			try {
				String messageid = req.getParameter("messageId");
				if (messageid != null && !messageid.isEmpty()) {
					MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
				}
			} catch (Exception e1) {
				// exception skiped
			}

			// get candidate ID from Session
			candidate = SessionHelper.getCandidate(req);
			// get Exam Event
			ExamEvent examEvent = SessionHelper.getExamEvent(req);
			// get CollectionID
			long collectionID = SessionHelper.getCollectionID(req);
			if (candidate != null && examEvent != null && collectionID > 0) {
				long candidateID = candidate.getCandidateID();
				// paper groups
				Set<Long> paperGroupIds = new HashSet<Long>();
				// active paper item bank association
				Map<Long, String> allPaperIDs = new HashMap<Long, String>();
				// get all active papers
				// get list Of Active papers
				papersForreattempting = schedulePaperAssociationServices.getReAttemptActivePapersFromCandidateID(candidateID, examEvent.getExamEventID(), collectionID);
				papersForreattempting = getActivePapers(papersForreattempting, allPaperIDs, paperGroupIds, model);
				model.addAttribute("activeReattemptPapers", papersForreattempting);

				// if (!examEvent.getShowAllPapers()) {
				// Non - Active Paper Item Banks Association
				// get all non active papers
				// get list Of Non-Active papers
				nonActivePapers = schedulePaperAssociationServices.getHistoryPapersFromCandidateID(candidateID, examEvent.getExamEventID(), collectionID, FIVE);
				nonActivePapers = getNonActivePapers(nonActivePapers, allPaperIDs, model);
				model.addAttribute("nonActivePapers", nonActivePapers);
				// }

				// get Exam Event
				model.addAttribute("currentExamEvent", examEvent);

				// get special week info if local schedular ins candidate
				if (examEvent.getLocalSchedular() == LocalSchedular.Candidate) {

					// get available number of bonus week
					long availableNumberOfBonusWeek = bonusWeekService.getAvailedNumberOfBonusWeeksByCandidateId(candidateID, examEvent.getExamEventID(), examEvent.getMaxPapersScheduleByCandidate());
					model.addAttribute("availableNumberOfBonusWeek", availableNumberOfBonusWeek);

					// get remaining week count
					int remainingWeekCount = bonusWeekService.getRemainingWeeksCount(examEvent.getExamEventID(), ScheduleType.Week);
					model.addAttribute("remainingWeekCount", remainingWeekCount);

					// get total papers and attempted papers by candidate
					List<String> attemptedPaper = bonusWeekService.getAttemptedPaperVsTotalPaperCounts(candidateID, examEvent.getExamEventID());
					String attemptedPaperCnt = "0";
					String totalPaperCnt = "0";
					if (attemptedPaper != null && attemptedPaper.size() > 0) {
						attemptedPaperCnt = attemptedPaper.get(0);
						totalPaperCnt = attemptedPaper.get(1);
					}
					model.addAttribute("attemptedPaperCnt", attemptedPaperCnt);
					model.addAttribute("totalPaperCnt", totalPaperCnt);

				}

				// Syllabus for active papers
				//List<Long> paperIDs = new ArrayList<Long>(allPaperIDs.keySet());
				//paperSectionItemBankAssocMap = itemBankImpl.getPaperItemBankAssociationListByPaperID(paperIDs);
				//getPapersAssociatedItemBanks(paperSectionItemBankAssocMap, allPaperIDs, model);
				
				// Code to get client Id
				ExamVenueActivationServicesImpl examVenueActivationServicesImpl=new ExamVenueActivationServicesImpl();
				long clientId=examVenueActivationServicesImpl.getExamVenueClientID();
				model.addAttribute("clientId", clientId);
				
				//send reqUserAgent for Secured Browser checking
				model.addAttribute("reqUserAgent", AuditVerificationMethods.getCompatibleSecuredBrowserUserAgent());
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in reAttempthomepageGet: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Solo/candidateModule/reattemptehomepage";
	}

	/**
	 * Get method to View Active Exam Event
	 * @param model
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewActiveExamEvent" }, method = { RequestMethod.GET })
	public String viewActiveExamEvent(Model model, HttpServletRequest req) {
		long examEventID = 0l;
		try {
			Candidate candidate = SessionHelper.getCandidate(req);
			ExamEvent examEvent = SessionHelper.getExamEvent(req);
			if (candidate != null && examEvent != null) {
				examEventID = examEvent.getExamEventID();
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in viewActiveExamEvent: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "redirect:viewActivityCalendar?examEventID=" + examEventID;
	}

	/**
	 * Post method to View Activity Calendar
	 * @param model
	 * @param examEvantID
	 * @param inCollapse
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewActivityCalendar" }, method = { RequestMethod.POST, RequestMethod.GET })
	public String viewActivityCalendar(Model model, @RequestParam(value = "examEventID", required = false) Long examEvantID, @RequestParam(value = "inCollapse", required = false, defaultValue = "1") String inCollapse, HttpServletRequest req) {
		ISchedulePaperAssociationServices schedulePaperAssociationServices = new SchedulePaperAssociationServicesImpl();
		//ItemBankImpl itemBankImpl = new ItemBankImpl();
		//IBonusWeekService bonusWeekService = new BonusWeekServiceImpl();
		Map<Integer, Object> scheduleWisePapers = null;
		Candidate candidate = null;
		Map<Long, String> allPaperIDs = null;
		// Set<Long> labSessionGroupIDs = null;
		//Map<Long, PaperSectionItemBankViewModel> paperSectionItemBankAssocMap = null;
		Long candidateID = 0l;
		try {
			// get candidate ID from Session
			candidate = SessionHelper.getCandidate(req);
			ExamEvent examEventSession = SessionHelper.getExamEvent(req);
			long collectionID = SessionHelper.getCollectionID(req);

			// Code to get client Id
			ExamVenueActivationServicesImpl examVenueActivationServicesImpl=new ExamVenueActivationServicesImpl();
			long clientId=examVenueActivationServicesImpl.getExamVenueClientID();
			model.addAttribute("clientId", clientId);
			
			if (candidate != null && examEventSession != null && collectionID > 0) {
				List<ExamEventScheduleTypeAssociation> eventScheduleTypeAssociations = schedulePaperAssociationServices.getExamEvantScheduleTypeList(examEventSession.getExamEventID());
				if (eventScheduleTypeAssociations != null && eventScheduleTypeAssociations.size() > 0) {
					allPaperIDs = new HashMap<Long, String>();
					// labSessionGroupIDs = new HashSet<Long>();
					candidateID = candidate.getCandidateID();
					scheduleWisePapers = schedulePaperAssociationServices.getScheduledPapersFromExamEventID(candidateID, examEventSession.getExamEventID(), collectionID);
					if (scheduleWisePapers != null) {
						// get previous schedule papers List
						getPreviousSchedulePapers(scheduleWisePapers, model, allPaperIDs);
						// get next schedule papers List
						getNextSchedulePapers(scheduleWisePapers, model, allPaperIDs);
						// get current schedule paper list
						getCurrentSchedulePapers(scheduleWisePapers, model, req, allPaperIDs, eventScheduleTypeAssociations);
						// get active exam event
						model.addAttribute("currentExamEvent", examEventSession);
						// make collapse panel open
						if (inCollapse != null) {
							if (inCollapse.equals("1")) {
								model.addAttribute("currentCollapse", "in");
							} else {
								model.addAttribute("previousCollapse", "in");
							}
						}

						// get available number of bonus week
						// long
						// availableNumberOfBonusWeek=bonusWeekService.getAvailedNumberOfBonusWeeksByCandidateId(candidateID,
						// examEventSession.getExamEventID(),
						// examEventSession.getMaxPapersScheduleByCandidate());
						// model.addAttribute("availableNumberOfBonusWeek",
						// availableNumberOfBonusWeek);

						// get Display category wise paper count schedule by
						// candidate
						// long
						// currentScheduleID=schedulePaperAssociationServices.getTodaysScheduleIdByScheduleType(ScheduleType.Week,
						// examEventSession.getExamEventID());
						// Map<Long,Long>
						// displayCategoryWiseAttemptsMap=bonusWeekService.getCandidateDisplayCategoryAttemptDetails(candidateID,
						// examEventSession.getExamEventID(),
						// currentScheduleID);
						// model.addAttribute("displayCategoryWiseAttemptsMap",
						// displayCategoryWiseAttemptsMap);

						// boolean
						// isBonusWeek=bonusWeekService.isBonusWeek(candidateID,
						// examEventSession.getExamEventID(), currentScheduleID,
						// examEventSession.getMaxPapersScheduleByCandidate());
						// model.addAttribute("isBonusWeek", isBonusWeek);

						// get syllabus of all papers irrespective of schedule
						//List<Long> allPaperiDsList = new ArrayList<Long>(allPaperIDs.keySet());
						//paperSectionItemBankAssocMap = itemBankImpl.getPaperItemBankAssociationListByPaperID(allPaperiDsList);
						//getPapersAssociatedItemBanks(paperSectionItemBankAssocMap, allPaperIDs, model);
						// get Lab Session Groups of Papers
						// get candidates associated groups
						GroupMasterCandidatesViewModel labSessionGroupInfo = schedulePaperAssociationServices.getGroupInfoFromCandidateID(candidateID, examEventSession.getExamEventID(), collectionID);
						model.addAttribute("labSessionGroupInfo", labSessionGroupInfo);
						
						 //send reqUserAgent for Secured Browser checking
						model.addAttribute("reqUserAgent", AuditVerificationMethods.getCompatibleSecuredBrowserUserAgent());
					}
				}
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in viewActivityCalendar: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Solo/candidateModule/viewActivityCalendar";

	}
	
	/**
	 * Get method to View Paper Syllabus 
	 * @param model
	 * @param request
	 * @param paperID
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = "/viewPaperSyllabus", method = RequestMethod.GET)
	public String viewPaperSyllabus(Model model, HttpServletRequest request, @RequestParam(value = "paperID") long paperID) {
		ItemBankImpl itemBankImpl = new ItemBankImpl();
		PaperSectionItemBankViewModel paperSectionItemBankViewModel = itemBankImpl.getPaperItemBankAssociationByPaperID(paperID);
		model.addAttribute("paperWiseSyllabus", paperSectionItemBankViewModel);
		return "Solo/candidateModule/showSyllabus";
	}

	/**
	 * Method to get Active Papers
	 * @param activePapers
	 * @param allPaperIDs
	 * @param paperGroupIds
	 * @param model
	 * @return List<ExamDisplayCategoryPaperViewModel> this returns the ExamDisplayCategoryPaperViewModelList
	 */
	public List<ExamDisplayCategoryPaperViewModel> getActivePapers(List<ExamDisplayCategoryPaperViewModel> activePapers, Map<Long, String> allPaperIDs, Set<Long> paperGroupIds, Model model) {
		try {

			if (activePapers != null) {

				// Map<Long, String> examEventMap = new LinkedHashMap<Long,
				// String>();
				Map<Long, String> displayCategoryMap = new LinkedHashMap<Long, String>();
				for (ExamDisplayCategoryPaperViewModel paper : activePapers) {
					// get all Exam Events
					// examEventMap.put(paper.getExamEvent().getExamEventID(),
					// paper.getExamEvent().getName());
					// get all display Category Events
					displayCategoryMap.put(paper.getDisplayCategoryLanguage().getFkDisplayCategoryID(), paper.getDisplayCategoryLanguage().getDisplayCategoryName());

					// get paper ids
					if (paper.getPaper().getName() != null && !paper.getPaper().getName().isEmpty()) {
						allPaperIDs.put(paper.getPaper().getPaperID(), paper.getPaper().getName());
					}

					// get group IDs
					// if paper is GROUP paper
					if (paper.getExamEventPaperDetails() != null && (paper.getExamEventPaperDetails().getAssessmentType() == AssessmentType.Group || paper.getExamEventPaperDetails().getAssessmentType() == AssessmentType.Both) && paper.getAssessmentType() == AssessmentType.Group) {
						paperGroupIds.add(paper.getLabSessionGroupID());
					}

				}
				// model.addAttribute("examEventMap", examEventMap);
				model.addAttribute("displayCategoryMap", displayCategoryMap);

				// get relation between exam And display Category On The basis
				// Of Papers
				// Map<Long, Set<Long>> examDisplayCategoryRelationMap = new
				// LinkedHashMap<Long, Set<Long>>();
				// Set<Long> examIDset = examEventMap.keySet();

				/*
				 * for (Long id : examIDset) { Set<Long> displayCategoryIDs =
				 * new LinkedHashSet<Long>(); for
				 * (ExamDisplayCategoryPaperViewModel displayCategory :
				 * activePapers) { if (id ==
				 * displayCategory.getExamEvent().getExamEventID()) {
				 * displayCategoryIDs
				 * .add(displayCategory.getDisplayCategoryLanguage
				 * ().getFkDisplayCategoryID()); } }
				 * examDisplayCategoryRelationMap.put(id, displayCategoryIDs); }
				 * model.addAttribute("examDisplayCategoryRelationMap",
				 * examDisplayCategoryRelationMap);
				 */
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getActivePapers: ", e);
		}
		return activePapers;
	}

	/**
	 * Method to Get List Of All Non Active papers Recent completed papers
	 * @param nonActivePapers
	 * @param allPaperIDs
	 * @param model
	 * @return List<ExamDisplayCategoryPaperViewModel> this returns ExamDisplayCategoryPaperViewModelList
	 */
	public List<ExamDisplayCategoryPaperViewModel> getNonActivePapers(List<ExamDisplayCategoryPaperViewModel> nonActivePapers, Map<Long, String> allPaperIDs, Model model) {

		try {
			if (nonActivePapers != null) {

				// Map<Long, String> nonActiveExamEventMap = new
				// LinkedHashMap<Long, String>();
				Map<Long, String> nonActiveDisplayCategoryMap = new LinkedHashMap<Long, String>();
				for (ExamDisplayCategoryPaperViewModel paper : nonActivePapers) {
					// get all Exam Events
					// nonActiveExamEventMap.put(paper.getExamEvent().getExamEventID(),
					// paper.getExamEvent().getName());

					// get paper ids
					if (paper.getPaper().getName() != null && !paper.getPaper().getName().isEmpty()) {
						allPaperIDs.put(paper.getPaper().getPaperID(), paper.getPaper().getName());
					}

					// get all display Category Events
					nonActiveDisplayCategoryMap.put(paper.getDisplayCategoryLanguage().getFkDisplayCategoryID(), paper.getDisplayCategoryLanguage().getDisplayCategoryName());

				}
				// model.addAttribute("nonActiveExamEventMap",
				// nonActiveExamEventMap);

				model.addAttribute("nonActiveDisplayCategoryMap", nonActiveDisplayCategoryMap);

				// get relation between exam And display Category On The basis
				// Of Papers
				/*
				 * Map<Long, Set<Long>> nonActiveExamDisplayCategoryRelationMap
				 * = new LinkedHashMap<Long, Set<Long>>(); Set<Long>
				 * nonActiveExamIDset = nonActiveExamEventMap.keySet();
				 * 
				 * for (Long id : nonActiveExamIDset) { Set<Long>
				 * nonActiveDisplayCategoryIDs = new LinkedHashSet<Long>(); for
				 * (ExamDisplayCategoryPaperViewModel displayCategory :
				 * nonActivePapers) { if (id ==
				 * displayCategory.getExamEvent().getExamEventID()) {
				 * nonActiveDisplayCategoryIDs
				 * .add(displayCategory.getDisplayCategoryLanguage
				 * ().getFkDisplayCategoryID());
				 * 
				 * } } nonActiveExamDisplayCategoryRelationMap.put(id,
				 * nonActiveDisplayCategoryIDs); }
				 * model.addAttribute("nonActiveExamDisplayCategoryRelationMap",
				 * nonActiveExamDisplayCategoryRelationMap);
				 */
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getNonActivePapers: ", e);
		}
		return nonActivePapers;
	}

	/**
	 * Method to get all current schedule papers from exam event ID
	 * @param scheduleWisePapers
	 * @param model
	 * @param req
	 * @param allPaperIDs
	 * @param eventScheduleTypeAssociations
	 */
	@SuppressWarnings(UNCHECKED)
	public void getCurrentSchedulePapers(Map<Integer, Object> scheduleWisePapers, Model model, HttpServletRequest req, Map<Long, String> allPaperIDs, List<ExamEventScheduleTypeAssociation> eventScheduleTypeAssociations) {
		List<ExamDisplayCategoryPaperViewModel> currentSchedulePapers = null;

		try {
			// 0 For Current
			// get previous schedule papers
			currentSchedulePapers = (List<ExamDisplayCategoryPaperViewModel>) scheduleWisePapers.get(0);
			ExamEvent examEvent = SessionHelper.getExamEvent(req);
			if (currentSchedulePapers != null && examEvent != null) {

				// schedule Master object only for Custom Schedule Type
				ScheduleMaster forCustomTypeScheduleMaster = null;

				// map for schedule-display Category relation
				Map<ScheduleType, List<DisplayCategoryLanguage>> currentScheduleDisplayCategoryRelMap = new LinkedHashMap<ScheduleType, List<DisplayCategoryLanguage>>();
				for (ScheduleType scheduleType : ScheduleType.values()) {
					Map<Long, DisplayCategoryLanguage> displayCategoryMap = new LinkedHashMap<Long, DisplayCategoryLanguage>();
					for (ExamDisplayCategoryPaperViewModel papers : currentSchedulePapers) {

						// for non-free paper
						if (papers.getScheduleMaster().getScheduleType() == scheduleType && papers.getDisplayCategoryLanguage().getDisplayCategoryName() != null) {
							// create display Category Object
							DisplayCategoryLanguage displayCategory = new DisplayCategoryLanguage();
							displayCategory.setFkDisplayCategoryID(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID());
							displayCategory.setDisplayCategoryName(papers.getDisplayCategoryLanguage().getDisplayCategoryName());
							displayCategoryMap.put(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID(), displayCategory);
						} else if (papers.getFreePaperStatus() == 1 && scheduleType == ScheduleType.Week) {
							// if it is free paper then add it in WEEK panel
							// create display Category Object
							DisplayCategoryLanguage displayCategory = new DisplayCategoryLanguage();
							displayCategory.setFkDisplayCategoryID(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID());
							displayCategory.setDisplayCategoryName(papers.getDisplayCategoryLanguage().getDisplayCategoryName());
							displayCategoryMap.put(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID(), displayCategory);
						}

						// if schedule type is custom then Make Schedule master
						// Object
						if (papers.getScheduleMaster().getScheduleType() == ScheduleType.Custom && forCustomTypeScheduleMaster == null) {
							forCustomTypeScheduleMaster = papers.getScheduleMaster();
						}
					}
					List<DisplayCategoryLanguage> displayCategories = new ArrayList<DisplayCategoryLanguage>(displayCategoryMap.values());
					currentScheduleDisplayCategoryRelMap.put(scheduleType, displayCategories);
				}
				model.addAttribute("currentScheduleDisplayCategoryRelMap", currentScheduleDisplayCategoryRelMap);
				model.addAttribute("currentScheduleMasters", getCurrentSheduleMasterList(examEvent, eventScheduleTypeAssociations, forCustomTypeScheduleMaster));
				for (ExamDisplayCategoryPaperViewModel displayCategory : currentSchedulePapers) {
					// get all current paper IDs and name
					if (displayCategory.getPaper().getName() != null && !displayCategory.getPaper().getName().isEmpty()) {
						allPaperIDs.put(displayCategory.getPaper().getPaperID(), displayCategory.getPaper().getName());
					}

					// get lab session Groups for paper
					// if (displayCategory.getExamEventPaperDetails() != null &&
					// (displayCategory.getExamEventPaperDetails().getAssessmentType()
					// == AssessmentType.Group ||
					// displayCategory.getExamEventPaperDetails().getAssessmentType()
					// == AssessmentType.Both)
					// && displayCategory.getAssessmentType() ==
					// AssessmentType.Group) {
					// labSessionGroupIDs.add(displayCategory.getLabSessionGroupID());
					// }
				}

				model.addAttribute("currentSchedulePapers", currentSchedulePapers);

			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONSTR + "-getCurrentSchedulePapers: ", e);
		}
	}

	
	/**
	 * This method gives all previous schedule papers from exam event ID
	 * @param scheduleWisePapers
	 * @param model
	 * @param allPaperIDs
	 */
	@SuppressWarnings(UNCHECKED)
	public void getPreviousSchedulePapers(Map<Integer, Object> scheduleWisePapers, Model model, Map<Long, String> allPaperIDs) {
		List<ExamDisplayCategoryPaperViewModel> previousSchedulePapers = null;
		try {
			// -1 For previous
			// get previous schedule papers
			previousSchedulePapers = (List<ExamDisplayCategoryPaperViewModel>) scheduleWisePapers.get(-1);
			if (previousSchedulePapers != null) {
				Map<Long, ScheduleMaster> previousScheduleMasterMap = new LinkedHashMap<Long, ScheduleMaster>();

				// create schedule master map
				for (ExamDisplayCategoryPaperViewModel papers : previousSchedulePapers) {
					previousScheduleMasterMap.put(papers.getScheduleMaster().getScheduleID(), papers.getScheduleMaster());
					// adding all papers IDs and paper name
					if (papers.getPaper().getName() != null && !papers.getPaper().getName().isEmpty()) {
						allPaperIDs.put(papers.getPaper().getPaperID(), papers.getPaper().getName());
					}
					// get lab session Groups for paper
					// if (papers.getExamEventPaperDetails() != null &&
					// (papers.getExamEventPaperDetails().getAssessmentType() ==
					// AssessmentType.Group ||
					// papers.getExamEventPaperDetails().getAssessmentType() ==
					// AssessmentType.Both) && papers.getAssessmentType() ==
					// AssessmentType.Group) {
					// labSessionGroupIDs.add(papers.getLabSessionGroupID());
					// }
				}
				model.addAttribute("previousScheduleMasterMap", previousScheduleMasterMap);
				// map for schedule-display Category relation
				Map<Long, List<DisplayCategoryLanguage>> previousScheduleDisplayCategoryRelMap = new LinkedHashMap<Long, List<DisplayCategoryLanguage>>();
				Set<Long> scheduleIDs = previousScheduleMasterMap.keySet();
				for (Long id : scheduleIDs) {
					Map<Long, DisplayCategoryLanguage> displayCategoryMap = new LinkedHashMap<Long, DisplayCategoryLanguage>();
					for (ExamDisplayCategoryPaperViewModel papers : previousSchedulePapers) {
						if (papers.getScheduleMaster().getScheduleID() == id && papers.getDisplayCategoryLanguage().getDisplayCategoryName() != null) {

							// create display Category Object
							DisplayCategoryLanguage displayCategory = new DisplayCategoryLanguage();
							displayCategory.setFkDisplayCategoryID(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID());
							displayCategory.setDisplayCategoryName(papers.getDisplayCategoryLanguage().getDisplayCategoryName());
							displayCategoryMap.put(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID(), displayCategory);
						}
					}
					List<DisplayCategoryLanguage> displayCategories = new ArrayList<DisplayCategoryLanguage>(displayCategoryMap.values());
					previousScheduleDisplayCategoryRelMap.put(id, displayCategories);
				}

				model.addAttribute("previousScheduleDisplayCategoryRelMap", previousScheduleDisplayCategoryRelMap);
				model.addAttribute("previousSchedulePapers", previousSchedulePapers);
			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONSTR + "-getPreviousSchedulePapers: ", e);
		}
	}

	/**
	 * This method gives all next schedule papers from Exam event ID
	 * @param scheduleWisePapers
	 * @param model
	 * @param allPaperIDs
	 */
	@SuppressWarnings(UNCHECKED)
	public void getNextSchedulePapers(Map<Integer, Object> scheduleWisePapers, Model model, Map<Long, String> allPaperIDs) {
		List<ExamDisplayCategoryPaperViewModel> nextSchedulePapers = null;

		try {
			// 1 For Next
			// get previous schedule papers
			nextSchedulePapers = (List<ExamDisplayCategoryPaperViewModel>) scheduleWisePapers.get(1);
			if (nextSchedulePapers != null) {
				Map<Long, ScheduleMaster> nextScheduleMasterMap = new LinkedHashMap<Long, ScheduleMaster>();

				// create schedule master map
				for (ExamDisplayCategoryPaperViewModel papers : nextSchedulePapers) {
					nextScheduleMasterMap.put(papers.getScheduleMaster().getScheduleID(), papers.getScheduleMaster());
					// adding all papers IDs and paper name
					if (papers.getPaper().getName() != null && !papers.getPaper().getName().isEmpty()) {
						allPaperIDs.put(papers.getPaper().getPaperID(), papers.getPaper().getName());
					}
					// get lab session Groups for paper
					// if (papers.getExamEventPaperDetails() != null &&
					// (papers.getExamEventPaperDetails().getAssessmentType() ==
					// AssessmentType.Group ||
					// papers.getExamEventPaperDetails().getAssessmentType() ==
					// AssessmentType.Both) && papers.getAssessmentType() ==
					// AssessmentType.Group) {
					// labSessionGroupIDs.add(papers.getLabSessionGroupID());
					// }
				}

				model.addAttribute("nextScheduleMasterMap", nextScheduleMasterMap);
				// map for schedule-display Category relation
				Map<Long, List<DisplayCategoryLanguage>> nextScheduleDisplayCategoryRelMap = new LinkedHashMap<Long, List<DisplayCategoryLanguage>>();
				Set<Long> scheduleIDs = nextScheduleMasterMap.keySet();

				for (Long id : scheduleIDs) {
					Map<Long, DisplayCategoryLanguage> displayCategoryMap = new LinkedHashMap<Long, DisplayCategoryLanguage>();
					for (ExamDisplayCategoryPaperViewModel papers : nextSchedulePapers) {
						if (papers.getScheduleMaster().getScheduleID() == id && papers.getDisplayCategoryLanguage().getDisplayCategoryName() != null) {
							// create display Category Object
							DisplayCategoryLanguage displayCategory = new DisplayCategoryLanguage();
							displayCategory.setFkDisplayCategoryID(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID());
							displayCategory.setDisplayCategoryName(papers.getDisplayCategoryLanguage().getDisplayCategoryName());
							displayCategoryMap.put(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID(), displayCategory);
						}
					}
					List<DisplayCategoryLanguage> displayCategories = new ArrayList<DisplayCategoryLanguage>(displayCategoryMap.values());
					nextScheduleDisplayCategoryRelMap.put(id, displayCategories);
				}
				model.addAttribute("nextScheduleDisplayCategoryRelMap", nextScheduleDisplayCategoryRelMap);
				model.addAttribute("nextSchedulePapers", nextSchedulePapers);
			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONSTR + "-getNextSchedulePapers: ", e);
		}

	}

	/*
	 * This method associates all item banks to each papers in all schedules
	 * 
	 * @param paperItemBankAssoc
	 * @param allPaperIDs
	 * @param model
	 */
	/*public void getPapersAssociatedItemBanks(Map<Long, PaperSectionItemBankViewModel> paperSectionItemBankAssoc, Map<Long, String> allPaperIDs, Model model) {

		try {
			List<PaperSectionItemBankViewModel> allPaperSyllabus = new ArrayList<PaperSectionItemBankViewModel>();
			Set<Long> paperIDs = allPaperIDs.keySet();

			for (Long paperID : paperIDs) {
				PaperSectionItemBankViewModel viewModel = paperSectionItemBankAssoc.get(paperID);

				if (viewModel == null || viewModel.getPaper() == null) {
					// create paper if its syllabus not found
					Paper paper = new Paper();
					paper.setName(allPaperIDs.get(paperID));
					paper.setPaperID(paperID);
					viewModel.setPaper(paper);
				}
				
				allPaperSyllabus.add(viewModel);
			}
			model.addAttribute("paperWiseSyllabus", allPaperSyllabus);
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONSTR + "-getPapersAssociatedItemBanks: ", e);
		}
	}*/

	/**
	 * Method to get the Exam Event wise Current Schedules List
	 * @param examEvent
	 * @param eventScheduleTypeAssociations
	 * @param forCustomTypeScheduleMaster
	 * @return List<ScheduleMaster> this returns the Schedules List
	 */
	private List<ScheduleMaster> getCurrentSheduleMasterList(ExamEvent examEvent, List<ExamEventScheduleTypeAssociation> eventScheduleTypeAssociations, ScheduleMaster forCustomTypeScheduleMaster) {
		List<ScheduleMaster> scheduleMasters = null;
		if (eventScheduleTypeAssociations != null && eventScheduleTypeAssociations.size() > 0) {
			scheduleMasters = new ArrayList<ScheduleMaster>();
			ScheduleMaster scheduleMaster = null;
			for (ExamEventScheduleTypeAssociation eventScheduleTypeAssociation : eventScheduleTypeAssociations) {
				if (eventScheduleTypeAssociation.getScheduleType() == ScheduleType.Week) {
					// Schedule Master For Week
					scheduleMaster = new ScheduleMaster();
					scheduleMaster.setScheduleID(UUID.randomUUID().getLeastSignificantBits());
					DaysOfWeek dayofWeekStart = eventScheduleTypeAssociation.getWeekStartDay();
					// scheduleMaster.setScheduleName("WEEK");
					scheduleMaster.setScheduleStart(getStartOfWeek(dayofWeekStart.ordinal()));
					scheduleMaster.setScheduleEnd(getEndOfWeek(dayofWeekStart.ordinal()));
					scheduleMaster.setScheduleType(ScheduleType.Week);
					scheduleMasters.add(scheduleMaster);

				} else if (eventScheduleTypeAssociation.getScheduleType() == ScheduleType.Day) {
					// Schedule Master For Day
					scheduleMaster = new ScheduleMaster();
					scheduleMaster.setScheduleID(UUID.randomUUID().getLeastSignificantBits());
					// scheduleMaster.setScheduleName("DAY");
					scheduleMaster.setScheduleStart(getStartOfDay());
					scheduleMaster.setScheduleEnd(getEndOfDay());
					scheduleMaster.setScheduleType(ScheduleType.Day);
					scheduleMasters.add(scheduleMaster);

				} else if (eventScheduleTypeAssociation.getScheduleType() == ScheduleType.Custom) {
					/*
					 * if(forCustomTypeScheduleMaster==null){ // Schedule Master
					 * For custom scheduleMaster = new ScheduleMaster();
					 * scheduleMaster
					 * .setScheduleID(UUID.randomUUID().getLeastSignificantBits
					 * ()); scheduleMaster.setScheduleName("---");
					 * scheduleMaster.setScheduleStart(getStartOfDay());
					 * scheduleMaster.setScheduleEnd(getEndOfDay());
					 * scheduleMaster.setScheduleType(ScheduleType.Custom);
					 * scheduleMasters.add(scheduleMaster); }else{
					 */
					if (forCustomTypeScheduleMaster != null) {
						forCustomTypeScheduleMaster.setScheduleName("");
						scheduleMasters.add(forCustomTypeScheduleMaster);
					}
					/* } */
				}
			}
		}
		return scheduleMasters;
	}

	/**
	 * Method to get Calendar for Week
	 * @param scheduleStart
	 * @return Calendar this returns the Weekly Calendar
	 */
	private Calendar getCalenderForWeek(int scheduleStart) {
		// fault handler
		if (scheduleStart == 0) {
			scheduleStart = scheduleStart + SCHEDULESINC;
		}
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
		while (calendar.get(Calendar.DAY_OF_WEEK) != scheduleStart) {
			calendar.add(Calendar.DATE, SCHEDULEREPEAT);
		}
		return calendar;
	}

	/**
	 * Method to get the Start of a Week Date and Time
	 * @param scheduleStart
	 * @return Date this returns the Start of a Week Date and Time
	 */
	private Date getStartOfWeek(int scheduleStart) {
		Calendar calendar = getCalenderForWeek(scheduleStart);
		return calendar.getTime();
	}

	/**
	 * Method to get the End of a Week Date and Time
	 * @param scheduleStart
	 * @return Date this returns the End of a Week Date and Time
	 */
	private Date getEndOfWeek(int scheduleStart) {
		Calendar calendar = getCalenderForWeek(scheduleStart);
		calendar.add(Calendar.DATE, SCHEDULELENGTH);
		return calendar.getTime();
	}

	/**
	 * Method to get the Start of the Day Date and Time
	 * @param scheduleStart
	 * @return Date this returns the Start of a Day Date and Time
	 */
	private Date getStartOfDay() {
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH);
		int day = calendar.get(Calendar.DATE);
		calendar.set(year, month, day, 0, 0, 1);
		return calendar.getTime();
	}

	/**
	 * Method to get the End of the Day Date and Time
	 * @param scheduleStart
	 * @return Date this returns the End of the Day Date and Time
	 */
	private Date getEndOfDay() {
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH);
		int day = calendar.get(Calendar.DATE);
		calendar.set(year, month, day, 23, 59, 59);
		return calendar.getTime();
	}
	
	/**
	 * Get method to Configure Exam Home Page
	 * @param model
	 * @param locale
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/confExamHomePage" }, method = RequestMethod.GET)
	public String confExamHomePage(Model model, Locale locale, HttpServletRequest req) {

		ISchedulePaperAssociationServices schedulePaperAssociationServices = new SchedulePaperAssociationServicesImpl();
		//ItemBankImpl itemBankImpl = new ItemBankImpl();
		List<ExamDisplayCategoryPaperViewModel> activePapers = null;
		List<ExamDisplayCategoryPaperViewModel> nonActivePapers = null;
		//Map<Long, PaperSectionItemBankViewModel> paperSectionItemBankAssocMap = null;
		Candidate candidate = null;
		try {
			try {
				String messageid = req.getParameter("messageId");
				if (messageid != null && !messageid.isEmpty()) {
					MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
				}
			} catch (Exception e1) {
				// exception skiped
			}

			// get candidate ID from Session
			candidate = SessionHelper.getCandidate(req);
			// get Exam Event
			ExamEvent examEvent = SessionHelper.getExamEvent(req);
			// get CollectionID
			long collectionID = SessionHelper.getCollectionID(req);
			if (candidate != null && examEvent != null && collectionID > 0) {
				long candidateID = candidate.getCandidateID();
				model.addAttribute("candidate", candidate);

				// paper groups
				Set<Long> paperGroupIds = new HashSet<Long>();
				// active paper item bank association
				Map<Long, String> allPaperIDs = new HashMap<Long, String>();
				// get all active papers
				// get list Of Active papers
				activePapers = schedulePaperAssociationServices.getActivePapersFromCandidateID(candidateID, examEvent.getExamEventID(), collectionID, EventCategory.ConfidentialExam);
				activePapers = getActivePapers(activePapers, allPaperIDs, paperGroupIds, model);
				model.addAttribute("activePapers", activePapers);
				
				// get paper history
				nonActivePapers = schedulePaperAssociationServices.getHistoryPapersFromCandidateID(candidateID, examEvent.getExamEventID(), collectionID, FIVEHUNDRED);
				nonActivePapers = getNonActivePapers(nonActivePapers, allPaperIDs, model);
				model.addAttribute("nonActivePapers", nonActivePapers);
				
				// get Exam Event
				model.addAttribute("currentExamEvent", examEvent);

				// send show all papers parameter
				model.addAttribute("examEventShowAllPapapers", examEvent.getShowAllPapers());
				model.addAttribute("imgPath", FileUploadHelper.getRelativeFolderPath(req, "CandidatePhotoUploadPath"));
				
				//send reqUserAgent for Secured Browser checking
				model.addAttribute("reqUserAgent", AuditVerificationMethods.getCompatibleSecuredBrowserUserAgent());
				
				ExamVenue examcenter=new CandidateServiceImpl().getCandidateAndVenueDetails(candidateID, examEvent.getExamEventID());
				model.addAttribute("examcenter", examcenter);
			}
			
			// Code to get client Id
			ExamVenueActivationServicesImpl examVenueActivationServicesImpl=new ExamVenueActivationServicesImpl();
			long clientId=examVenueActivationServicesImpl.getExamVenueClientID();
			model.addAttribute("clientId", clientId);
		} catch (Exception ex) {
			LOGGER.error("Exception occured in confExamHomePage: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Solo/candidateModule/confExamHomePage";
	}

}
