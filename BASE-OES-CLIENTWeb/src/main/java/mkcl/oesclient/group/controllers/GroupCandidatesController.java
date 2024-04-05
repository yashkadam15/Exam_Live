package mkcl.oesclient.group.controllers;

//Modified by Reena for setting based client 03-dec2013
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.baseoesclient.model.UserColor;
import mkcl.oesclient.commons.controllers.ExamLocaleThemeResolver;
import mkcl.oesclient.commons.services.ItemBankImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.group.services.IScheduleGroupAssociationServices;
import mkcl.oesclient.group.services.ScheduleGroupAssociationServicesImpl;
import mkcl.oesclient.model.GroupMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamDisplayCategoryPaperViewModel;
import mkcl.oesclient.viewmodel.GroupCandidatesScheduledPapersViewModel;
import mkcl.oesclient.viewmodel.PaperSectionItemBankViewModel;
import mkcl.oespcs.model.DaysOfWeek;
import mkcl.oespcs.model.DisplayCategoryLanguage;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamEventScheduleTypeAssociation;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.PaperItemBankAssociation;
import mkcl.oespcs.model.ScheduleMaster;
import mkcl.oespcs.model.ScheduleType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("groupCandidatesModule")
public class GroupCandidatesController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GroupCandidatesController.class);
	private static final String EXCEPTIONSTR = "Exception Occured : ";
	private static final String UNCHECKED = "unchecked";
	private static final int SCHEDULELENGTH = 6;
	private static final int SCHEDULEREPEAT = -1;
	private static final int SCHEDULESINC = 1;
	@Autowired
	private ExamLocaleThemeResolver examLocaleThemeResolver;
	
	/**
	 * Get method for Group Home Page
	 * @param model
	 * @param locale
	 * @param req
	 * @param response
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/grouphomepage" }, method = RequestMethod.GET)
	public String groupHomepageGet(Model model, Locale locale, HttpServletRequest req,HttpServletResponse response) {
		List<ExamDisplayCategoryPaperViewModel> activePapers = null;
		//Map<Long, PaperSectionItemBankViewModel> paperSectionItemBankAssoc = null;
		long examEventID = 0l;
		long labSessionGroupID = 0l;
		try {

			try {
				
				/* Added by Reena : 24 July 2015
				 * This call should always be on the top of each function as locale further 
				 accessed will not behave as required 
				 This call will set back Locale to application Default if Candidate comes from Exam Interface
				 */
				
				if(req.getParameter("changeLocale")!=null)
				examLocaleThemeResolver.setApplicationDefaultLocaleAndTheme(req, response);	
				
				String messageid = req.getParameter("messageId");
				if (messageid != null && !messageid.isEmpty()) {
					MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
				}
			} catch (Exception e1) {
				LOGGER.error("Exception occured in grouphomepage: ", e1);
			}

			// get LabSessionGroup
			GroupMaster labSessionGroup = SessionHelper.getGroupMaster(req);
			// get Exam Event
			ExamEvent examEvent = SessionHelper.getExamEvent(req);
			
			// get CollectionID
			long collectionID = SessionHelper.getCollectionID(req);
			
			IScheduleGroupAssociationServices scheduleGroupAssociationServices = new ScheduleGroupAssociationServicesImpl();
			// get Candidate IDs
			List<Long> candidateIDs=null;
			if(labSessionGroup != null && examEvent != null && collectionID > 0){
				candidateIDs= scheduleGroupAssociationServices.getCandidatesOfEachGroup(labSessionGroup.getGroupID(),examEvent.getExamEventID(),collectionID);
			}
			
			if (labSessionGroup != null && examEvent != null && candidateIDs != null && candidateIDs.size() > 0 && collectionID > 0) {

				
				labSessionGroupID = labSessionGroup.getGroupID();
				examEventID = examEvent.getExamEventID();
				

				// active paper item bank association
				Map<Long, String> allPaperIDs = new HashMap<Long, String>();

				// get all active papers
				// get list Of Active papers
				activePapers = scheduleGroupAssociationServices.getScheduledPapersOfLabSessionGroup(labSessionGroupID, examEventID, candidateIDs, collectionID);
				activePapers = getActivePapers(activePapers, allPaperIDs, model);

				// get syllabus of all papers irrespective of schedule
				//List<Long> allPaperiDsList = new ArrayList<Long>(allPaperIDs.keySet());
				//paperSectionItemBankAssoc = itemBankImpl.getPaperItemBankAssociationListByPaperID(allPaperiDsList);
				//getPapersAssociatedItemBanks(paperSectionItemBankAssoc, allPaperIDs, model);

				model.addAttribute("activePapers", activePapers);
				String imgrelativePath = FileUploadHelper.getRelativeFolderPath(req, "UserPhotoUploadPath");
				model.addAttribute("imgPath", imgrelativePath);
				model.addAttribute("userColors", UserColor.values());

			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in grouphomepage: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}

		return "Group/candidateModule/grouphomepage";
	}
	
	/**
	 * Get method to View Active exam Event 
	 * @param model
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewActiveExamEvent" }, method = { RequestMethod.GET })
	public String viewActiveExamEvent(Model model, HttpServletRequest req) {
		long examEventID = 0l;
		try {
			ExamEvent examEvent = SessionHelper.getExamEvent(req);
			if (examEvent != null) {
				examEventID = examEvent.getExamEventID();
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in viewActiveExamEvent: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "redirect:groupviewActivityCalendar?examEventID=" + examEventID;
	}

	/**
	 * Post method for Group Activity Calendar
	 * @param model
	 * @param examEvantID
	 * @param inCollapse
	 * @param req
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/groupviewActivityCalendar" }, method = { RequestMethod.POST, RequestMethod.GET })
	public String groupActivityCalendar(Model model, @RequestParam(value = "examEventID",required = false) Long examEvantID, @RequestParam(value = "inCollapse", required = false, defaultValue = "1") String inCollapse, HttpServletRequest req) {
		//Map<Long,PaperSectionItemBankViewModel> paperSectionItemBankAssoc = null;
		long candidateID = 0l;
		Map<Integer, Object> scheduleWisePapers = null;
		try {
			// get LabSessionGroup
			GroupMaster labSessionGroup = SessionHelper.getGroupMaster(req);
			// get Exam Event
			ExamEvent examEvent = SessionHelper.getExamEvent(req);
			// get Candidate
			List<VenueUser> candidates = SessionHelper.getLogedInUsers(req);
			// get CollectionID
			long collectionID = SessionHelper.getCollectionID(req);
			if (labSessionGroup != null && examEvent != null && candidates != null && candidates.size() > 0 && collectionID > 0) {
				IScheduleGroupAssociationServices scheduleGroupAssociationServices = new ScheduleGroupAssociationServicesImpl();
				List<ExamEventScheduleTypeAssociation> eventScheduleTypeAssociations = scheduleGroupAssociationServices.getExamEvantScheduleTypeList(examEvent.getExamEventID());
				
				//get candidateList of respective Group
				List<Long> groupCandidateIDs = scheduleGroupAssociationServices.getCandidatesOfEachGroup(labSessionGroup.getGroupID(),examEvent.getExamEventID(),collectionID);
				
				if (eventScheduleTypeAssociations != null && eventScheduleTypeAssociations.size() > 0) {
					// active paper item bank association
					Map<Long, String> allPaperIDs = new HashMap<Long, String>();

					// get Activity calender with respective to user
					GroupCandidatesScheduledPapersViewModel candidateCalender = null;
					List<GroupCandidatesScheduledPapersViewModel> candidateCalenders=new ArrayList<GroupCandidatesScheduledPapersViewModel>();
					for (VenueUser candidate : candidates) {
						candidateID = Long.parseLong(candidate.getObject().toString());
						candidateCalender = new GroupCandidatesScheduledPapersViewModel();
						//put candidate to Model
						candidateCalender.setVenueUser(candidate);
						scheduleWisePapers = scheduleGroupAssociationServices.getScheduledPapersFromExamEventID(candidateID, examEvent.getExamEventID(), collectionID,groupCandidateIDs, labSessionGroup.getGroupID());
						if (scheduleWisePapers != null) {
							// get previous schedule papers List
							getPreviousSchedulePapers(scheduleWisePapers, candidateCalender, allPaperIDs);
							// get next schedule papers List
							getNextSchedulePapers(scheduleWisePapers, candidateCalender, allPaperIDs);
							// get current schedule paper list
							getCurrentSchedulePapers(scheduleWisePapers, candidateCalender, req, allPaperIDs, eventScheduleTypeAssociations);
						}
						candidateCalenders.add(candidateCalender);
					}
					model.addAttribute("candidateCalenders",candidateCalenders);
					// get active exam event
					model.addAttribute("currentActiveExamEvent", examEvent);
					// add candidate List
					model.addAttribute("candidates", candidates);
					model.addAttribute("userColors", UserColor.values());
					// get syllabus of all papers irrespective of schedule
					//List<Long> allPaperiDsList = new ArrayList<Long>(allPaperIDs.keySet());
					//paperSectionItemBankAssoc = itemBankImpl.getPaperItemBankAssociationListByPaperID(allPaperiDsList);
					//getPapersAssociatedItemBanks(paperSectionItemBankAssoc, allPaperIDs, model);
				}
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in grouphomepage: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Group/candidateModule/groupViewActivityCalendar";
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
		return "Group/candidateModule/showSyllabus";
	}

	/**
	 * Method to fetch Active Papers List
	 * @param activePapers
	 * @param allPaperIDs
	 * @param model
	 * @return List<ExamDisplayCategoryPaperViewModel> this returns the ExamDisplayCategoryPaperViewModelList
	 */
	public List<ExamDisplayCategoryPaperViewModel> getActivePapers(List<ExamDisplayCategoryPaperViewModel> activePapers, Map<Long, String> allPaperIDs, Model model) {
		try {

			if (activePapers != null) {

				Map<Long, String> examEventMap = new LinkedHashMap<Long, String>();
				Map<Long, String> displayCategoryMap = new LinkedHashMap<Long, String>();
				for (ExamDisplayCategoryPaperViewModel paper : activePapers) {
					// get all Exam Events
					examEventMap.put(paper.getExamEvent().getExamEventID(), paper.getExamEvent().getName());

					// get all display Category Events
					displayCategoryMap.put(paper.getDisplayCategoryLanguage().getFkDisplayCategoryID(), paper.getDisplayCategoryLanguage().getDisplayCategoryName());

					// get paper ids
					if (paper.getPaper().getName() != null && !paper.getPaper().getName().isEmpty()) {
						allPaperIDs.put(paper.getPaper().getPaperID(), paper.getPaper().getName());
					}

				}
				model.addAttribute("examEventMap", examEventMap);
				model.addAttribute("displayCategoryMap", displayCategoryMap);

				// get relation between exam And display Category On The basis
				// Of Papers
				Map<Long, Set<Long>> examDisplayCategoryRelationMap = new LinkedHashMap<Long, Set<Long>>();
				Set<Long> examIDset = examEventMap.keySet();

				for (Long id : examIDset) {
					Set<Long> displayCategoryIDs = new LinkedHashSet<Long>();
					for (ExamDisplayCategoryPaperViewModel displayCategory : activePapers) {
						if (id == displayCategory.getExamEvent().getExamEventID()) {
							displayCategoryIDs.add(displayCategory.getDisplayCategoryLanguage().getFkDisplayCategoryID());
						}
					}
					examDisplayCategoryRelationMap.put(id, displayCategoryIDs);
				}
				model.addAttribute("examDisplayCategoryRelationMap", examDisplayCategoryRelationMap);
			}
		} catch (Exception e) {
			LOGGER.error("Exception occured in getActivePapers: ", e);
		}
		return activePapers;
	}

	/**
	 * Method to fetch all current schedule papers for an exam event
	 * @param scheduleWisePapers
	 * @param candidateCalender
	 * @param req
	 * @param allPaperIDs
	 * @param eventScheduleTypeAssociations
	 */
	@SuppressWarnings(UNCHECKED)
	public void getCurrentSchedulePapers(Map<Integer, Object> scheduleWisePapers,GroupCandidatesScheduledPapersViewModel candidateCalender, HttpServletRequest req, Map<Long, String> allPaperIDs, List<ExamEventScheduleTypeAssociation> eventScheduleTypeAssociations) {
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
						//for non-free paper
						if (papers.getScheduleMaster().getScheduleType() == scheduleType && papers.getDisplayCategoryLanguage().getDisplayCategoryName() != null) {
							// create display Category Object
							DisplayCategoryLanguage displayCategory = new DisplayCategoryLanguage();
							displayCategory.setFkDisplayCategoryID(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID());
							displayCategory.setDisplayCategoryName(papers.getDisplayCategoryLanguage().getDisplayCategoryName());
							displayCategoryMap.put(papers.getDisplayCategoryLanguage().getFkDisplayCategoryID(), displayCategory);
						}else if(papers.getFreePaperStatus()==1 && scheduleType == ScheduleType.Week){
						//if it is free paper then add it in WEEK panel	
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
				candidateCalender.setCurrentScheduleDisplayCategoryRelMap(currentScheduleDisplayCategoryRelMap);
				candidateCalender.setCurrentScheduleMasters(getCurrentSheduleMasterList(examEvent, eventScheduleTypeAssociations, forCustomTypeScheduleMaster));
				for (ExamDisplayCategoryPaperViewModel displayCategory : currentSchedulePapers) {
					// get all current paper IDs and name
					if (displayCategory.getPaper().getName() != null && !displayCategory.getPaper().getName().isEmpty()) {
						allPaperIDs.put(displayCategory.getPaper().getPaperID(), displayCategory.getPaper().getName());
					}

				}
				candidateCalender.setCurrentSchedulePapers(currentSchedulePapers);
			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONSTR + "-getCurrentSchedulePapers: ", e);
		}
	}

	/**
	 * Method to fetch all the previously scheduled papers for an Exam Event
	 * @param scheduleWisePapers
	 * @param candidateCalender
	 * @param allPaperIDs
	 */
	@SuppressWarnings(UNCHECKED)
	public void getPreviousSchedulePapers(Map<Integer, Object> scheduleWisePapers,GroupCandidatesScheduledPapersViewModel candidateCalender, Map<Long, String> allPaperIDs) {
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

				}
				candidateCalender.setPreviousScheduleMasterMap(previousScheduleMasterMap);
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
				candidateCalender.setPreviousScheduleDisplayCategoryRelMap(previousScheduleDisplayCategoryRelMap);
				candidateCalender.setPreviousSchedulePapers(previousSchedulePapers);
			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONSTR + "-getPreviousSchedulePapers: ", e);
		}
	}

	/**
	 * Method to fetch next schedule papers
	 * @param scheduleWisePapers
	 * @param candidateCalender
	 * @param allPaperIDs
	 */
	@SuppressWarnings(UNCHECKED)
	public void getNextSchedulePapers(Map<Integer, Object> scheduleWisePapers, GroupCandidatesScheduledPapersViewModel candidateCalender, Map<Long, String> allPaperIDs) {
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

				}
				candidateCalender.setNextScheduleMasterMap(nextScheduleMasterMap);
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
				candidateCalender.setNextScheduleDisplayCategoryRelMap(nextScheduleDisplayCategoryRelMap);
				candidateCalender.setNextSchedulePapers(nextSchedulePapers);
			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONSTR + "-getNextSchedulePapers: ", e);
		}

	}

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
	 * Method to fetch Current Schedules List
	 * @param examEvent
	 * @param eventScheduleTypeAssociations
	 * @param forCustomTypeScheduleMaster
	 * @return List<ScheduleMaster> this returns the Current Schedules List
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
					if (forCustomTypeScheduleMaster != null) {
						forCustomTypeScheduleMaster.setScheduleName("");
						scheduleMasters.add(forCustomTypeScheduleMaster);
					}
				}
			}
		}
		return scheduleMasters;
	}

	/**
	 * Method to fetch Calendar for a Week
	 * @param scheduleStart
	 * @return Calendar this returns Calendar for a week
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
	 * Method to fetch Date and Time of the Start of a Week
	 * @param scheduleStart
	 * @return Date this returns Date
	 */
	private Date getStartOfWeek(int scheduleStart) {
		Calendar calendar = getCalenderForWeek(scheduleStart);
		return calendar.getTime();
	}

	/**
	 * Method to fetch Date and Time of the End of a Week
	 * @param scheduleStart
	 * @return Date this returns Date
	 */
	private Date getEndOfWeek(int scheduleStart) {
		Calendar calendar = getCalenderForWeek(scheduleStart);
		calendar.add(Calendar.DATE, SCHEDULELENGTH);
		return calendar.getTime();
	}

	/**
	 * Method to fetch the Date and Time of the Start of a Day
	 * @return Date this returns Date
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
	 * Method to fetch  the Date and Time of the End of the Day
	 * @return Date this returns Date
	 */
	private Date getEndOfDay() {
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH);
		int day = calendar.get(Calendar.DATE);
		calendar.set(year, month, day, 23, 59, 59);
		return calendar.getTime();
	}

}
