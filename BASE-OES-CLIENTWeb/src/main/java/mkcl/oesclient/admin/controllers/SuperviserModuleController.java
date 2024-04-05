package mkcl.oesclient.admin.controllers;
//Modified by Reena for setting based client 03-dec2013
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.WeekPaperDivisionAssociationViewModel;
import mkcl.oespcs.model.AssessmentType;
import mkcl.oespcs.model.DisplayCategory;
import mkcl.oespcs.model.DisplayCategoryLanguage;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.ScheduleLocation;
import mkcl.oespcs.model.ScheduleMaster;
import mkcl.oespcs.model.SchedulePaperAssociation;
import mkcl.oespcs.model.ScheduleType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("superviserModule")
public class SuperviserModuleController {

	private static final Logger LOGGER = LoggerFactory
			.getLogger(SuperviserModuleController.class);
	private static final String SCHEDULEEXAM = "Admin/superviserModule/scheduleExam";
	private static final String EXAMEVENTID="examEventID";
	
	
	/**
	 * Method to bind date with with given format.
	 *
	 * @param dataBinder the data binder
	 * @param locale the locale
	 * @param request the request
	 */
	@InitBinder
	public void initBinder(WebDataBinder dataBinder, Locale locale,
			HttpServletRequest request) {
		Properties properties = null;
		String dateFormatString;
		SimpleDateFormat dateFormat;

		properties = MKCLUtility.loadMKCLPropertiesFile();

		dateFormatString = properties
				.getProperty("global.dateFormatWithTime");

		dateFormat = new SimpleDateFormat(dateFormatString);
		dateFormat.setLenient(false);
		dataBinder.registerCustomEditor(Date.class, new CustomDateEditor(
				dateFormat, true));
	}
	
	/**
	 * Get method for Test Scheduling
	 * @param model
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/scheduleTest" }, method = RequestMethod.GET)
	public String testScheduling(Model model) {
		return "Admin/superviserModule/scheduleTest";
	}

	/**
	 * Get method to View Exam Schedule
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewExamSchedule" }, method = RequestMethod.GET)
	public String selectScheduling(Model model, HttpServletRequest request) {
		model.addAttribute("flagCreateMode", true);
		return "Admin/superviserModule/viewExamSchedule";
	}

	/**
	 * Post method to View Exam Schedule
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewExamSchedule" }, method = RequestMethod.POST)
	public String viewScheduling(Model model, HttpServletRequest request) {
		try {
			String examEventID = request.getParameter("examEventSelect");
			String collectionID = request.getParameter("collectionId");

			model.addAttribute("examEventID", examEventID);
			model.addAttribute("collectionID", collectionID);
			
			VenueUser user = SessionHelper.getLogedInUser(request);
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			getAlreadyDefinedSchedule(model, request, examEventID, collectionID,
					eServiceObj, user,null);
		} catch (Exception ex) {
			LOGGER.error("Exception occured in viewScheduling: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return "Admin/superviserModule/viewExamSchedule";
	}

	/**
	 * Get method for Schedule Exam
	 * @param model
	 * @param request
	 * @param locale
	 * @param messageid
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/scheduleExam" }, method = RequestMethod.GET)
	public String examScheduling(Model model, HttpServletRequest request,Locale locale,String messageid) {
		try {
			if (messageid!=null && messageid!="") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
		} catch (Exception ex) {
			LOGGER.error("Exception occured in examScheduling: ",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return SCHEDULEEXAM;
	}

	/**
	 * Method to fetch the Active Exam Event List
	 * @param request
	 * @return List<ExamEvent> this returns the Active Exam Event List
	 */
	@ModelAttribute("activeExamEventList")
	public List<ExamEvent> getactiveExamEventList(HttpServletRequest request) {
		List<ExamEvent> activeExamEventList = null;
		ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
		VenueUser user=SessionHelper.getLogedInUser(request);
		/* Active exam Event List */
		activeExamEventList = eServiceObj.getActiveExamEventList(user);
		return activeExamEventList;
	}

	/**
	 * Method to fetch the Active Exam Event List for Scheduling
	 * @param request
	 * @return List<ExamEvent> this returns the ExamEventList
	 */
	@ModelAttribute("activeEventListForScheduling")
	public List<ExamEvent> getactiveExamEventListForScheduling(HttpServletRequest request) {
		List<ExamEvent> activeExamEventList = null;
		ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
		VenueUser user=SessionHelper.getLogedInUser(request);
		/* Active exam Event List */
		activeExamEventList = eServiceObj.getActiveExamEventListForScheduling(user);
		return activeExamEventList;
	}
	
	/**
	 * Post method to fetch the Division List Associated to Exam Event and Role
	 * @param examEventID
	 * @param request
	 * @return List<CollectionMaster> this returns the Division List
	 */
	@RequestMapping(value = "/divisionAccEventRole.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<CollectionMaster> getDivisionList(
			@RequestBody ExamEvent examEventID, HttpServletRequest request) {
		VenueUser user = SessionHelper.getLogedInUser(request);

		ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
		List<CollectionMaster> collectionList =null;
		collectionList = eServiceObj.getCollectionMasterAccRole(user,
				examEventID.getExamEventID());
		return collectionList;
	}

	/**
	 * Post method to fetch the Weekly Schedule List Associated to the Exam Event Division  
	 * @param fkExamEventID
	 * @param fkCollectionID
	 * @param scheduleType
	 * @param request
	 * @return List<ScheduleMaster> this returns the weekly schedule list
	 */
	@RequestMapping(value = "/WeekAccEventDivision.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<ScheduleMaster> getScheduleList(
			Long fkExamEventID,Long fkCollectionID,String scheduleType,HttpServletRequest request) {
		ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
		List<ScheduleMaster> weekList = null;
		weekList=eServiceObj.getNotScheduledScheduleList(fkExamEventID,fkCollectionID,ScheduleType.valueOf(scheduleType));
		return weekList;
	}

	/**
	 * Post method to Display Exam Schedule
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/scheduleExam" }, method = RequestMethod.POST)
	public String showexamSchedule(Model model, HttpServletRequest request) {

		String examEventID = request.getParameter("examEventSelect");
		String collectionID = request.getParameter("collectionId");
		String weekID = request.getParameter("weekSelect");
		String scheduleType=request.getParameter("type");
		
		return "redirect:../superviserModule/getSubjectWisePaper?examEventID="
				+ examEventID + "&collectionID=" + collectionID + "&weekID="
				+ weekID+"&scheduleType="+scheduleType;
	}

	/**
	 * Get method for Subject wise Paper
	 * @param model
	 * @param request
	 * @param locale
	 * @param messageid
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/getSubjectWisePaper" }, method = RequestMethod.GET)
	public String getDisplayCategoryWisePaper(Model model, HttpServletRequest request,
			Locale locale, String messageid) {
		try {
			
			if (messageid!=null && messageid!="") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
			String examEventID = request.getParameter(EXAMEVENTID);
			String collectionID = request.getParameter("collectionID");
			String scheduleID = request.getParameter("weekID");
			String scheduleType=request.getParameter("scheduleType");
			String isForEdit = request.getParameter("isForEdit");
			Boolean hideDiv=Boolean.parseBoolean(request.getParameter("hideDiv"));
			
			model.addAttribute("isForEdit", isForEdit);
			model.addAttribute("hideDiv", hideDiv);
			model.addAttribute(EXAMEVENTID, Long.parseLong(examEventID));
			model.addAttribute("collectionID", Long.parseLong(collectionID));
			model.addAttribute("weekID", Long.parseLong(scheduleID));
			model.addAttribute("scheduleType", scheduleType);
			
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			ExamEventServiceImpl examEventService = new ExamEventServiceImpl();
			VenueUser user = SessionHelper.getLogedInUser(request);

			ScheduleMaster wmObj = null;
			List<DisplayCategoryLanguage> displayCategoryLanguageList = null;
			List<Paper> paperList = null;

			List<SchedulePaperAssociation> wpdObj = null;

			Map<ScheduleMaster, Map<DisplayCategoryLanguage, List<Paper>>> scheduleWiseSubjectPaperAssociationMap = new LinkedHashMap<ScheduleMaster, Map<DisplayCategoryLanguage, List<Paper>>>();
			Map<DisplayCategoryLanguage, List<Paper>> displayCategoryLanguagePaperList = new LinkedHashMap<DisplayCategoryLanguage, List<Paper>>();

			WeekPaperDivisionAssociationViewModel wpdAssociationViewModel = new WeekPaperDivisionAssociationViewModel();
			List<SchedulePaperAssociation> weekPaperDivisionAssociationList = new ArrayList<SchedulePaperAssociation>();

			if (examEventID != null && collectionID != null && scheduleID != null) {
				if (Long.parseLong(scheduleID) != -1) {
					wmObj = eServiceObj.getScheduleMasterOne(Long.parseLong(scheduleID));

					if (isForEdit != null) {
						/* checking for past week */
						if ((wmObj.getScheduleStart().before(new Date()))
								&& (wmObj.getScheduleEnd().before(new Date()))) {
							MKCLUtility.addMessage(37, model, locale);
							getAlreadyDefinedSchedule(model, request, examEventID,
									collectionID, eServiceObj, user,scheduleType);
							return SCHEDULEEXAM;
						}
					}
					ExamEvent examEvent = examEventService.getExamEventByID(Long
							.parseLong(examEventID));
			
					displayCategoryLanguageList = eServiceObj
							.getDisplayCategoryListByUserRole(user, examEvent,
									Long.parseLong(collectionID));
					for (DisplayCategoryLanguage subObj : displayCategoryLanguageList) {
						paperList = eServiceObj.getDisplayCategoryPaperListByDisplayCategoryID(
								subObj.getFkDisplayCategoryID(),
								Long.parseLong(examEventID),
								Long.parseLong(collectionID));
						displayCategoryLanguagePaperList.put(subObj, paperList);

						wpdObj = eServiceObj
								.getSchedulePaperAssociationByEventDivisionScheduleDisplayCategoryID(
										Long.parseLong(examEventID),
										Long.parseLong(collectionID),
										Long.parseLong(scheduleID),
										subObj.getFkDisplayCategoryID());
						if (wpdObj != null) {
							weekPaperDivisionAssociationList.addAll(wpdObj);
							
							//if maxNoofPaper's is not equal to 1 then only add blank object(works for edit mode)
							if(wmObj.getMaxNumberOfPapers()!=1)
							{
								SchedulePaperAssociation wObj = new SchedulePaperAssociation();
								wObj.setFkExamEventID(Long.parseLong(examEventID));
								wObj.setFkCollectionID(Long.parseLong(collectionID));
								wObj.setFkScheduleID(Long.parseLong(scheduleID));
								wObj.setFkDisplayCategoryID(subObj.getFkDisplayCategoryID());
								weekPaperDivisionAssociationList.add(wObj);
							}
						} else {
							SchedulePaperAssociation wObj = new SchedulePaperAssociation();
							wObj.setFkExamEventID(Long.parseLong(examEventID));
							wObj.setFkCollectionID(Long.parseLong(collectionID));
							wObj.setFkScheduleID(Long.parseLong(scheduleID));
							wObj.setFkDisplayCategoryID(subObj.getFkDisplayCategoryID());
							weekPaperDivisionAssociationList.add(wObj);
						}
					}
					wpdAssociationViewModel
							.setWeekPaperDivisionAssoiciationList(weekPaperDivisionAssociationList);
					scheduleWiseSubjectPaperAssociationMap.put(wmObj,
							displayCategoryLanguagePaperList);

					model.addAttribute("wpdAssociationViewModel",
							wpdAssociationViewModel);
					model.addAttribute("weekWiseSubjectPaperMap",
							scheduleWiseSubjectPaperAssociationMap);
				}
				getAlreadyDefinedSchedule(model, request, examEventID, collectionID,
						eServiceObj, user,scheduleType);
			} /* end of if */
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getDisplayCategoryWisePaper: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		return SCHEDULEEXAM;
	}

	/**
	 * Post method for Subject wise Paper
	 * @param subjectPaperList
	 * @param model
	 * @param request
	 * @param examEventID
	 * @param collectionID
	 * @param weekID
	 * @param scheduleType
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/getSubjectWisePaper" }, method = RequestMethod.POST)
	public String saveDisplayCategoryWisePaper(
			@RequestParam("paperList") String subjectPaperList,
			Model model, HttpServletRequest request,String examEventID,String collectionID,String weekID,String scheduleType) {
		boolean saveFlag=false;
		try {
			List<SchedulePaperAssociation> associations=null;
			
			 if(subjectPaperList!=null && !subjectPaperList.isEmpty() && subjectPaperList!="")
			 {
				 saveFlag=saveSchedulePaperAssociation(subjectPaperList,request, examEventID, collectionID, weekID,associations);
			 }
		} catch (Exception ex) {
			LOGGER.error("Exception occured in saveDisplayCategoryWisePaper: ", ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex);
			return Constants.ERRORPAGE;
		}
		if(saveFlag)
		{
			return "redirect:../superviserModule/getSubjectWisePaper?examEventID="+examEventID+"&collectionID="+collectionID+"&weekID="+weekID+"&scheduleType="+scheduleType+"&hideDiv=true&messageid=1";
		}
		else
		{
			return "redirect:../superviserModule/getSubjectWisePaper?examEventID="+examEventID+"&collectionID="+collectionID+"&weekID="+weekID+"&scheduleType="+scheduleType+"&hideDiv=true&messageid=21";
		}
	}
	
	/**
	 * Method to Save Schedule Paper Association 
	 * @param subjectPaperList
	 * @param request
	 * @param examEventID
	 * @param divisionID
	 * @param scheduleID
	 * @param wPDivisionAssociation
	 * @return boolean this returns true on success
	 */
	private boolean saveSchedulePaperAssociation(String subjectPaperList,
			HttpServletRequest request, String examEventID, String divisionID,
			String scheduleID,
			List<SchedulePaperAssociation> wPDivisionAssociation) {
		VenueUser user=SessionHelper.getLogedInUser(request);
		boolean flag=false;
		ExamScheduleServiceImpl eServiceObj=new ExamScheduleServiceImpl();
		
		if(subjectPaperList!=null)
		{
			wPDivisionAssociation=new ArrayList<SchedulePaperAssociation>();
			String subjectPaper[]=subjectPaperList.split(",");
			for(String subPob:subjectPaper)
			{
				String subID=subPob.substring(0,subPob.indexOf("||"));
				String paperExtension=subPob.substring(subPob.indexOf("||")+2);
				String paperID=paperExtension.substring(0,paperExtension.indexOf("||"));
				String scheduleExtension=paperExtension.substring(paperExtension.indexOf("||")+2);
				
				SchedulePaperAssociation association=new SchedulePaperAssociation();
				association.setFkExamEventID(Long.parseLong(examEventID));
				association.setFkCollectionID(Long.parseLong(divisionID));
				association.setFkScheduleID(Long.parseLong(scheduleID));
				association.setFkDisplayCategoryID(Long.parseLong(subID));
				association.setFkPaperID(Long.parseLong(paperID));
				ScheduleMaster sMaster=eServiceObj.getScheduleMasterOne(Long.parseLong(scheduleID));
				//if scheduleType is week then multiply scheduleExtension by 7 days.
				if(sMaster.getScheduleType()==ScheduleType.Week)
				{
					association.setScheduleExtension(Integer.parseInt(scheduleExtension)*7);
				}
				else
				{
					association.setScheduleExtension(Integer.parseInt(scheduleExtension));
				}
				association.setCreatedBy(user.getUserName());
				association.setDateCreated(new Date());
				association.setAssessmentType(AssessmentType.Solo);
				//Set attemptNo to 1 by default while saving
				association.setAttemptNo(1l);
				
				//Set isActive to true by default while saving
				association.setisActive(true);
				
				wPDivisionAssociation.add(association);
			}
		}
		if(wPDivisionAssociation!=null && wPDivisionAssociation.size()!=0)
		{
			flag=eServiceObj.addSchedulePaperAssociation(wPDivisionAssociation);
		}
		return flag;
	}
	
	/**
	 * Method to fetch the Already Defined Schedule
	 * @param model
	 * @param request
	 * @param examEventID
	 * @param collectionID
	 * @param eServiceObj
	 * @param user
	 * @param scheduleType
	 */
	private void getAlreadyDefinedSchedule(Model model,
			HttpServletRequest request, String examEventID, String collectionID,
			ExamScheduleServiceImpl eServiceObj, VenueUser user,String scheduleType) {
		/****************** Already defined schedule *************************** */
		List<CollectionMaster> collectionList = null;
		List<ScheduleMaster> weekList = null;
		List<DisplayCategory> displayCategoryList = null;
		ExamEventServiceImpl examEventService = new ExamEventServiceImpl();

		model.addAttribute(EXAMEVENTID, Long.parseLong(examEventID));
		if(collectionID!=null && !collectionID.isEmpty())
		{
			model.addAttribute("collectionID", Long.parseLong(collectionID));
		}
		model.addAttribute("scheduleType",scheduleType);
		
		/* Division List according to role */
		collectionList = eServiceObj.getCollectionMasterAccRole(user,
				Long.parseLong(examEventID));
		model.addAttribute("collectionList", collectionList);

		Map<ScheduleMaster, List<SchedulePaperAssociation>> definedSheduleMap = new LinkedHashMap<ScheduleMaster, List<SchedulePaperAssociation>>();
		Map<Long, DisplayCategoryLanguage> displayCategoryIDLanguageMap = new LinkedHashMap<Long, DisplayCategoryLanguage>();
		Map<Long,ScheduleLocation> paperScheduleLocationMap=new LinkedHashMap<Long,ScheduleLocation>();
		List<DisplayCategoryLanguage> subjectLanguageList=null;
		
		
		ExamEvent examEvent = examEventService.getExamEventByID(Long
				.parseLong(examEventID));
		displayCategoryList = eServiceObj.getDisplayCategoryList(Long
				.parseLong(examEventID));
		if(displayCategoryList!=null && displayCategoryList.size()!=0)
		{
			subjectLanguageList=new ArrayList<DisplayCategoryLanguage>();
			for (DisplayCategory sub : displayCategoryList) {
				DisplayCategoryLanguage sublan = eServiceObj
						.getDisplayCategoryLanguageByDisplayCategoryIDexamEventDefaultLanguage(
								sub.getDisplayCategoryID(),
								examEvent.getDefaultLanguageID());
					displayCategoryIDLanguageMap.put(sub.getDisplayCategoryID(), sublan);
				if(sublan!=null)
				{
					subjectLanguageList.add(sublan);
				}
				
			}
		}
		
		/*code for subject paperlist in weekpaperDivisionAssociation*/
		Map<String,Long> weekWiseSubjectPaperListMap = new LinkedHashMap<String,Long>();
		
		if(scheduleType!=null)
		{
			// for Schedule
			weekList = eServiceObj.getScheduleByEventIDSchduleType(Long.parseLong(examEventID),ScheduleType.valueOf(scheduleType),Long.parseLong(collectionID));
			// don't show centrally scheduled paper's
			getDefinedScheduledMap(examEventID, collectionID, eServiceObj,
					weekList, definedSheduleMap, paperScheduleLocationMap,subjectLanguageList,
					weekWiseSubjectPaperListMap,false);
		}
		else
		{
			// for view Schedule
			weekList=eServiceObj.getAllSchedules(Long.parseLong(examEventID),Long.parseLong(collectionID));
			// show centrally scheduled paper's
			getDefinedScheduledMap(examEventID, collectionID, eServiceObj,
					weekList, definedSheduleMap, paperScheduleLocationMap,subjectLanguageList,
					weekWiseSubjectPaperListMap,true);
		}
		model.addAttribute("definedSheduleMap", definedSheduleMap);
		model.addAttribute("subjectIDLanguage", displayCategoryIDLanguageMap);
		model.addAttribute("weekWiseSubjectPaperListMap", weekWiseSubjectPaperListMap);
		model.addAttribute("paperSchedule",paperScheduleLocationMap);
	}


	/**
	 * Method to fetch the Map of Defined Schedule 
	 * @param examEventID
	 * @param collectionID
	 * @param eServiceObj
	 * @param weekList
	 * @param definedSheduleMap
	 * @param paperScheduleLocationMap
	 * @param subjectLanguageList
	 * @param weekWiseSubjectPaperListMap
	 * @param centralSchFlag
	 */
	private void getDefinedScheduledMap(String examEventID,String collectionID,ExamScheduleServiceImpl eServiceObj,
			List<ScheduleMaster> weekList,Map<ScheduleMaster, List<SchedulePaperAssociation>> definedSheduleMap,
			Map<Long,ScheduleLocation>paperScheduleLocationMap,
			List<DisplayCategoryLanguage> subjectLanguageList,Map<String, Long> weekWiseSubjectPaperListMap,boolean centralSchFlag) {
		List<SchedulePaperAssociation> weekPaperDivisionAssociations;
		List<SchedulePaperAssociation> wpdObj;
		for (ScheduleMaster weekObj : weekList) {
			weekPaperDivisionAssociations = new ArrayList<SchedulePaperAssociation>();
			for (DisplayCategoryLanguage subObj : subjectLanguageList) {
			wpdObj = eServiceObj.getSPAListByEDSD(Long.parseLong(examEventID),Long.parseLong(collectionID),
								weekObj.getScheduleID(),subObj.getFkDisplayCategoryID(),centralSchFlag);
			long paperIDListSize=0;
				if(wpdObj!=null && wpdObj.size()!=0)
				{
					paperIDListSize=wpdObj.size();
					for(SchedulePaperAssociation association:wpdObj)
					{
						ScheduleLocation scheduleLocation=eServiceObj.getScheduleLocationByPaperID(association.getFkExamEventID(),association.getFkPaperID());
						paperScheduleLocationMap.put(association.getFkPaperID(), scheduleLocation);
					}
				}
				weekWiseSubjectPaperListMap.put(String.valueOf(weekObj.getScheduleID())+"||"+String.valueOf(subObj.getFkDisplayCategoryID()),paperIDListSize);
				if(wpdObj!=null)
				{
					weekPaperDivisionAssociations.addAll(wpdObj);
				}
			}
			definedSheduleMap.put(weekObj, weekPaperDivisionAssociations);
		}
	}

	/**
	 * Post method to Delete Schedule
	 * @param model
	 * @param request
	 * @param fkPaperID
	 * @param fkWeekID
	 * @param fkCollectionID
	 * @param fkExamEventID
	 * @param scheduleType
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/deleteSchedule" }, method = RequestMethod.POST)
	public String deleteDisplayCategoryWisePaper(Model model, HttpServletRequest request,String fkPaperID,String fkWeekID,
			String fkCollectionID,String fkExamEventID,String scheduleType) {
		boolean deleteFlag=false;
		try
		{
			ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
			VenueUser user = SessionHelper.getLogedInUser(request);

			if (fkPaperID != null && fkWeekID != null && fkCollectionID != null
					&& fkExamEventID != null) {
				if (fkWeekID != null && Long.parseLong(fkWeekID) != -1) {
					/* checking for current week */
					ScheduleMaster wmObj = eServiceObj.getScheduleMasterOne(Long
							.parseLong(fkWeekID));

					if (wmObj.getScheduleStart().equals(new Date())
							|| wmObj.getScheduleEnd().equals(new Date())
							|| (wmObj.getScheduleStart().before(new Date()) && wmObj
									.getScheduleEnd().after(new Date()))) {
						/*
						 * (wmObj.getWeekStart()>=new Date &&
						 * wmObj.getWeekEnd()<=new Date())
						 */
						int count = eServiceObj
								.getNoOfAttemptsInCurentSchedulebyPaperID(
										Long.parseLong(fkExamEventID),
										Long.parseLong(fkCollectionID),
										Long.parseLong(fkPaperID));
						if (count > 0) {
							return "redirect:../superviserModule/getSubjectWisePaper?examEventID="
									+ Long.parseLong(fkExamEventID)
									+ "&collectionID="
									+ Long.parseLong(fkCollectionID)
									+ "&weekID="
									+ Long.parseLong(fkWeekID)
									+"&scheduleType="+scheduleType+"&isForEdit=true&messageid=38";
						}
					}
				}
				/* delete paper from schedule */
				deleteFlag=eServiceObj.deleteSchedulePaperAssociation(
						Long.parseLong(fkExamEventID),
						Long.parseLong(fkCollectionID), Long.parseLong(fkWeekID),
						Long.parseLong(fkPaperID));
				getAlreadyDefinedSchedule(model, request, fkExamEventID,
						fkCollectionID, eServiceObj, user,scheduleType);
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in deleteSchedulepaperAssociation...",e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e.getMessage());
			return Constants.ERRORPAGE;
		}
		if(deleteFlag)
		{
			return "redirect:../superviserModule/getSubjectWisePaper?examEventID="
					+ Long.parseLong(fkExamEventID) + "&collectionID="
					+ Long.parseLong(fkCollectionID) + "&weekID="
					+ Long.parseLong(fkWeekID)+"&scheduleType="+scheduleType+"&isForEdit=true&messageid=3";
		}
		else
		{
			return "redirect:../superviserModule/getSubjectWisePaper?examEventID="
					+ Long.parseLong(fkExamEventID) + "&collectionID="
					+ Long.parseLong(fkCollectionID) + "&weekID="
					+ Long.parseLong(fkWeekID)+"&scheduleType="+scheduleType+"&isForEdit=true&messageid=23";
		}
		
	}

} /* End of class */
