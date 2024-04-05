/**
 * Author : ReenaK
 * Created on: 12-dec-2013
 * This service is used to Schedule Lab Session for Group assessment.
 */

package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import mkcl.baseoesclient.model.GroupCandidateAssociation;
import mkcl.baseoesclient.model.GroupCollectionAssociation;
import mkcl.baseoesclient.model.ScheduleAbsentCandidates;
import mkcl.oesclient.admin.services.GroupScheduleServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.utilities.Constants;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.GroupMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.pdfviewmodel.ScheduleMasterViewModelPDF;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.GroupScheduleViewModel;
import mkcl.oesclient.viewmodel.LabSAbsentViewModel;
import mkcl.oesclient.viewmodel.WeekPaperDivisionAssociationViewModel;
import mkcl.oespcs.model.AssessmentType;
import mkcl.oespcs.model.DisplayCategory;
import mkcl.oespcs.model.DisplayCategoryLanguage;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.Paper;
import mkcl.oespcs.model.ScheduleMaster;
import mkcl.oespcs.model.SchedulePaperAssociation;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
@RequestMapping("groupSchedule")
public class GroupScheduleController{

	private static final Logger LOGGER = LoggerFactory
			.getLogger(GroupScheduleController.class);
	private static final String SCHEDULELABSESSION = "Admin/GroupSchedule/ScheduleGroups";
	private static final String EXAMEVENTID="examEventID";
	private ExamEventServiceImpl examEventService;
	
	@InitBinder
	public void initBinder(WebDataBinder dataBinder) {
	dataBinder.setAutoGrowCollectionLimit(1500);
	}

	/**
	 * Get method for Test Confirm Dialog
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/confirmDialog" }, method = RequestMethod.GET)
	public String testconfirmDialog(Model model, HttpServletRequest request) {
		return "Admin/GroupSchedule/ConfirmationDialog";
	}
	
	/**
	 * Get method for Test View
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewTest" }, method = RequestMethod.GET)
	public String testView(Model model, HttpServletRequest request) {
		return "Admin/GroupSchedule/TestView";
	}
	
	/**
	 * Get method for Display of Lab Session Schedule
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewLabSessionSchedule" }, method = RequestMethod.GET)
	public String selectScheduling(Model model, HttpServletRequest request) {
		model.addAttribute("flagCreateMode", true);
		return "Admin/GroupSchedule/ViewGroupSchedule";
	}

	/**
	 * Post method for Display of Lab Session Schedule
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/viewLabSessionSchedule" }, method = RequestMethod.POST)
	public String viewScheduling(Model model, HttpServletRequest request) {
		try {
			String examEventID = request.getParameter("examEventSelect");
			String collectionID = request.getParameter("collectionId");
			
			model.addAttribute("examEventID", examEventID);
			model.addAttribute("collectionID", collectionID);
			
			VenueUser user=SessionHelper.getLogedInUser(request);
			GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
			
			getAlreadyDefinedSchedule(model, request, examEventID, collectionID,labServiceObj,user);
		} catch (Exception ex) {
			LOGGER.error("Exception in viewLabSessionSchedule method...",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex.getMessage());
			return  "Common/error";
		}
		return "Admin/GroupSchedule/ViewGroupSchedule";
	}

	/**
	 * Get method to Schedule Lab Session
	 * @param model
	 * @param request
	 * @param message
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/scheduleLabSession" }, method = RequestMethod.GET)
	public String examScheduling(Model model, HttpServletRequest request,
			String message, String messageid,Locale locale) {
		try {
			if (messageid!=null && messageid!="") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
		} catch (Exception ex) {
			LOGGER.error("Exception in examScheduling method...",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex.getMessage());
			return  "Common/error";
		}
		return SCHEDULELABSESSION;
	}

	/**
	 * Method to fetch the Active Exam Event List
	 * @param request
	 * @return List<ExamEvent> this returns the ExamEventList
	 */
	@ModelAttribute("activeExamEventList")
	public List<ExamEvent> getactiveExamEventList( HttpServletRequest request) {
		List<ExamEvent> activeExamEventList = null;
		GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
		VenueUser user=SessionHelper.getLogedInUser(request);
		 /*Active exam Event List */
		activeExamEventList = labServiceObj.getActiveExamEventList(user);
	
		return activeExamEventList;
	}

	/**
	 * Post method to fetch Division List Associated to Exam Event and Roles
	 * @param examEventID
	 * @param request
	 * @return List<CollectionMaster> this returns the Division List
	 */
	@RequestMapping(value = "/divisionAccEventRole.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<CollectionMaster> getDivisionList(
		@RequestBody ExamEvent examEventID, HttpServletRequest request) {
		
		VenueUser user=SessionHelper.getLogedInUser(request);
		GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
		
		List<CollectionMaster> divisionList =null;
		
		divisionList = labServiceObj.getCollectionMasterAccRole(user,
				examEventID.getExamEventID());
		return divisionList;
	}
	
	/**
	 * Post method to fetch Weekly Schedule List Associated to the Exam Event and Divisions
	 * @param association
	 * @param request
	 * @return List<ScheduleMaster> this returns the weekly schedule list
	 */
	@RequestMapping(value = "/WeekAccEventDivision.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<ScheduleMaster> getWeekList(@RequestBody SchedulePaperAssociation association,HttpServletRequest request) {
		List<ScheduleMaster> scheduleList =null;
		GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
		
		scheduleList = labServiceObj.getNotScheduledScheduleList(
				association.getFkExamEventID(), association.getFkCollectionID());
		return scheduleList;
	}
	
	/**
	 * Post method for Exam schedule of Lab Session
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/scheduleLabSession" }, method = RequestMethod.POST)
	public String showexamSchedule(Model model, HttpServletRequest request) {

		String examEventID = request.getParameter("examEventSelect");
		String collectionID = request.getParameter("collectionId");
		String weekID = request.getParameter("weekSelect");
		GroupScheduleServiceImpl serviceImpl=new GroupScheduleServiceImpl();
		if(serviceImpl.checkScheduleExistForScheduleID(Long.parseLong(examEventID),Long.parseLong(collectionID),Long.parseLong(weekID)))
		{
			return "redirect:../groupSchedule/editSubjectWisePaper?examEventID="
					+ Long.parseLong(examEventID) + "&collectionID="
					+ Long.parseLong(collectionID) + "&weekID="
					+ Long.parseLong(weekID)+"&isForEdit=true";
		}
		else
		{
			return "redirect:../groupSchedule/getSubjectWisePaper?examEventID="
					+ examEventID + "&collectionID=" + collectionID + "&weekID="
					+ weekID+"&isForEdit=false";
		}
	}

	/**
	 * Get method for Subject wise Paper
	 * @param model
	 * @param request
	 * @param locale
	 * @param message
	 * @param messageText
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/getSubjectWisePaper" }, method = RequestMethod.GET)
	public String getSubjectWisePaper(Model model, HttpServletRequest request,
			Locale locale, String message, String messageText) {
		try {
			String examEventID = request.getParameter(EXAMEVENTID);
			String collectionID = request.getParameter("collectionID");
			String scheduleID = request.getParameter("weekID");
			String isForEdit=request.getParameter("isForEdit");
			
			model.addAttribute(EXAMEVENTID, Long.parseLong(examEventID));
			model.addAttribute("collectionID", Long.parseLong(collectionID));
			model.addAttribute("weekID", Long.parseLong(scheduleID));
			model.addAttribute("isForEdit", isForEdit);
			
			VenueUser user=SessionHelper.getLogedInUser(request);
			GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
			examEventService=new ExamEventServiceImpl();
		
			if(readGroupCreationMode()==1)
			{
				//check group exist for current scheduleID
				if(labServiceObj.checkGroupExistForCurrentSchedule(Long.parseLong(collectionID),Long.parseLong(scheduleID)))
				{
					model.addAttribute("groupExist",true);
				}
				else
				{
					//get latest fkScheduleID and check group exist for rataining previous group
					ScheduleMaster scheMaster=labServiceObj.getScheduleMasterForGroupRetain(Long.parseLong(scheduleID),Long.parseLong(collectionID));
					if(scheMaster!=null)
					{
						model.addAttribute("labSessionGroup",true);
					}
				}
			}
			
			ExamEvent eobj=examEventService.getExamEventByID(Long.parseLong(examEventID));
			ScheduleMaster smObj = null;
			List<DisplayCategoryLanguage> displayCategoryLanguageList = null;
			List<Paper> paperList = null;

			Map<ScheduleMaster, Map<DisplayCategoryLanguage, List<Paper>>> scheduleWiseDispCategoryPaperAssociationMap = new LinkedHashMap<ScheduleMaster, Map<DisplayCategoryLanguage, List<Paper>>>();
			Map<DisplayCategoryLanguage, List<Paper>> subjectLanguagePaperList = new LinkedHashMap<DisplayCategoryLanguage, List<Paper>>();
	
			if (examEventID != null && collectionID != null && scheduleID != null) {
				if (Long.parseLong(scheduleID) != -1) {
					smObj = labServiceObj.getScheduleMasterOne(Long.parseLong(scheduleID));
			
					displayCategoryLanguageList = labServiceObj.getDisplayCategoryListByUserRole(user, eobj,Long.parseLong(collectionID));
					
					for (DisplayCategoryLanguage subObj : displayCategoryLanguageList) {
						paperList = labServiceObj.getDisplayCategoryPaperListByDisplayCategoryID(
								subObj.getFkDisplayCategoryID(),
								Long.parseLong(examEventID),
								Long.parseLong(collectionID));
						subjectLanguagePaperList.put(subObj, paperList);
					}
					scheduleWiseDispCategoryPaperAssociationMap.put(smObj,subjectLanguagePaperList);
					model.addAttribute("weekWiseSubjectPaperMap",scheduleWiseDispCategoryPaperAssociationMap);
					model.addAttribute("groupCreateMode",readGroupCreationMode());
				}
			}  //end of if 
		} catch (Exception ex) {
			LOGGER.error("Exception in getSubjectWisePaper...",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex.getMessage());
			return "Common/error";
		}
		return SCHEDULELABSESSION;
	}
	
	/**
	 * Post method for Subject wise Paper
	 * @param subjectPaperList
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/getSubjectWisePaper" }, method = RequestMethod.POST)
	public String saveSubjectWisePaper(@RequestParam("paperList") String subjectPaperList,Model model, HttpServletRequest request) {
		String examEventID=null;
		String collectionID=null;
		String scheduleID=null;
		List<SchedulePaperAssociation> wPDivisionAssociation=null;
		
		try {
			 examEventID = request.getParameter(EXAMEVENTID);
			 collectionID = request.getParameter("collectionID");
			 scheduleID=request.getParameter("weekID");
			 
			 if(subjectPaperList!=null && !subjectPaperList.isEmpty())
			 {
				  wPDivisionAssociation=saveSchedulePaperAssociation(subjectPaperList,request, examEventID, collectionID, scheduleID,wPDivisionAssociation);
			 }

			 GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
			 Boolean retainGroup=Boolean.parseBoolean(request.getParameter("retainGroup"));
			 Boolean groupExist=Boolean.parseBoolean(request.getParameter("groupExist"));
			 
			 // if groupCreationMode is system generated then only show popup's for retain group or absent candidate.
			 if(readGroupCreationMode()==1)
			 {
				 // if group already exist for given schedule then save schdulepaperAssociation and update candidateExam and redirect to groupReport
				 if(groupExist)
				 {
					 labServiceObj.addSchedulePaperAssUpdateCandidateExam(wPDivisionAssociation);
				 	 return "redirect:../GroupReport/groupReport?examEventSelect="+examEventID+"&collectionID="+collectionID+"&weekSelect="+scheduleID+"&type=1";
				 }
				 else{
				 // Retain previous Group
				 if(retainGroup)
				 {
					 List<Object> previousGroups=getPreviousGroupsForScheduling(request,Long.parseLong(examEventID),Long.parseLong(collectionID),Long.parseLong(scheduleID));
					 labServiceObj.saveScheduleAbsentCandidates((List<ScheduleAbsentCandidates>) previousGroups.get(0));
					 
					 //First Save schedulePaperAssociation and then after group formation update candidateExam 
					 List<SchedulePaperAssociation> associations=labServiceObj.saveSchedulePaperAssociation(wPDivisionAssociation);
					 labServiceObj.saveGroupScheduleViewModelListUpdateCExam((List<GroupScheduleViewModel>) previousGroups.get(1),associations);
					 return "redirect:../GroupReport/groupReport?examEventSelect="+examEventID+"&collectionID="+collectionID+"&weekSelect="+scheduleID+"&type=1";
					 
				 }
				 else
				 {
					//First Save schedulePaperAssociation and then redirect to either absentcandidate or groupreport
					 List<SchedulePaperAssociation> associations=labServiceObj.saveSchedulePaperAssociation(wPDivisionAssociation);
					 
					 	// MARK Absent Candidate ANd Generate group
						Boolean markAbsentCandidate=Boolean.parseBoolean(request.getParameter("markAbsentCandidate"));
						
						//IF true send to markAbsentCandidate Page AND Generate Group
						if(markAbsentCandidate)
						{
							return "redirect:../groupSchedule/markAbsentCandidate?examEventID="+examEventID+"&collectionID="+collectionID+"&fkScheduleID="+scheduleID+"&markAbsentCandidate=true";
						}
						//Generate Group
						else
						{
							return "redirect:../groupSchedule/createLabGroup?examEventID="+examEventID+"&collectionID="+collectionID+"&fkScheduleID="+scheduleID+"&markAbsentCandidate=false";
						}
				 }
			 }
		   }
		  else
		  {
			  // if GroupCreationMode is Manual then delete previous schedules groupIdentity and save schedulePaperAssociation and then update CandidateExam
			  ScheduleMaster sObj=labServiceObj.getScheduleMasterOne(Long.parseLong(scheduleID));
			  labServiceObj.addSchedulePaperAssUpdateALLCollectionCExam(wPDivisionAssociation, sObj);
			  return "redirect:../groupSchedule/editSubjectWisePaper?examEventID="
						+ Long.parseLong(examEventID) + "&collectionID="
						+ Long.parseLong(collectionID) + "&weekID="
						+ Long.parseLong(scheduleID)+"&isForEdit=true";
		  }
		} catch (Exception ex) {
			LOGGER.error("Exception in saveSubjectWisePaper",ex);
			model.addAttribute(Constants.EXCEPTIONSTRING, ex.getMessage());
			return  "Common/error";
		}
	}

	/**
	 * Method to fetch Previous Groups for Scheduling
	 * @param request
	 * @param examEventID
	 * @param divisionID
	 * @param scheduleID
	 * @return List<Object> this returns the previous groups list
	 */
	private List<Object> getPreviousGroupsForScheduling(
			HttpServletRequest request, Long examEventID,Long divisionID, Long scheduleID) {
		
		VenueUser user=SessionHelper.getLogedInUser(request);
		GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
		
		List<Object> previousGroupList=null;
		
		//get latest fkScheduleID and check group exist
		ScheduleMaster scheMaster=labServiceObj.getScheduleMasterForGroupRetain(scheduleID,divisionID);
		if(scheMaster!=null)
		{
			previousGroupList=labServiceObj.getPrevioustGroupList(scheMaster.getScheduleID(), divisionID);
			
			List<ScheduleAbsentCandidates> absentCandidates=(List<ScheduleAbsentCandidates>) previousGroupList.get(0);
			List<GroupScheduleViewModel> scheduleViewModels=(List<GroupScheduleViewModel>) previousGroupList.get(1);
			
			for(ScheduleAbsentCandidates  candidates: absentCandidates)
			{
				candidates.setFkScheduleID(scheduleID);
				candidates.setCreatedBy(user.getUserName());
				candidates.setDateCreated(new Date());
			}
			for(GroupScheduleViewModel scheduleViewModel: scheduleViewModels)
			{
				scheduleViewModel.getGrpCollecAssociation().setFkScheduleID(scheduleID);
				scheduleViewModel.getGrpCollecAssociation().setCreatedBy(user.getUserName());
				scheduleViewModel.getGrpCollecAssociation().setDateCreated(new Date());
				
				for(GroupCandidateAssociation association: scheduleViewModel.getGrAssociations())
				{
					association.setFkScheduleID(scheduleID);
					association.setCreatedBy(user.getUserName());
					association.setDateCreated(new Date());
				}
			}
		}
		return previousGroupList;
	}

	/**
	 * Method to fetch Schedule Paper Association List
	 * @param subjectPaperList
	 * @param request
	 * @param examEventID
	 * @param divisionID
	 * @param scheduleID
	 * @param wPDivisionAssociation
	 * @return List<SchedulePaperAssociation> this returns the SchedulePaperAssociationList
	 */
	private List<SchedulePaperAssociation> saveSchedulePaperAssociation(String subjectPaperList,
			HttpServletRequest request, String examEventID, String divisionID,
			String scheduleID,
			List<SchedulePaperAssociation> wPDivisionAssociation) {
		VenueUser user=SessionHelper.getLogedInUser(request);
		
		if(subjectPaperList!=null)
		{
			wPDivisionAssociation=new ArrayList<SchedulePaperAssociation>();
			String subjectPaper[]=subjectPaperList.split(",");
			for(String subPob:subjectPaper)
			{
				String subID=subPob.substring(0,subPob.indexOf("||"));
				String paperID=subPob.substring(subPob.indexOf("||")+2);
				
				SchedulePaperAssociation association=new SchedulePaperAssociation();
				association.setFkExamEventID(Long.parseLong(examEventID));
				association.setFkCollectionID(Long.parseLong(divisionID));
				association.setFkScheduleID(Long.parseLong(scheduleID));
				association.setFkDisplayCategoryID(Long.parseLong(subID));
				association.setFkPaperID(Long.parseLong(paperID));
				//For groupScheduling scheduleExtension set to 0
				association.setScheduleExtension(0);
				association.setCreatedBy(user.getUserName());
				association.setDateCreated(new Date());
				association.setAssessmentType(AssessmentType.Group);
				//Set attemptNo to 1 by default while saving
				association.setAttemptNo(1l);
				
				//Set isActive to true by default while saving
				association.setisActive(true);
				
				wPDivisionAssociation.add(association);
			}
		}
		return wPDivisionAssociation;
	}

	/**
	 * Get method to Mark Absent Candidate
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/markAbsentCandidate" }, method = RequestMethod.GET)
	public String markAbsentCandidate(Model model, HttpServletRequest request) {
		String examEventID=null;
		String collectionID=null;
		String fkScheduleID=null;
		List<Candidate> candidateList=null;
		List<ScheduleAbsentCandidates> labSessionAbsentCandidates=null;
		try
		{
			GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
			 examEventID = request.getParameter(EXAMEVENTID);
			 collectionID = request.getParameter("collectionID");
			 fkScheduleID=request.getParameter("fkScheduleID");
			 
			 model.addAttribute("fkScheduleID",fkScheduleID);
			 model.addAttribute("examEventID",examEventID);
			 model.addAttribute("collectionID",collectionID);
			 
			candidateList=labServiceObj.getcandidateListForGroupScheduling(Long.parseLong(examEventID), Long.parseLong(collectionID));
			
			if(candidateList!=null && candidateList.size()!=0)
			{
				labSessionAbsentCandidates=new ArrayList<ScheduleAbsentCandidates>();
				for(Candidate candidate: candidateList)
				{
					ScheduleAbsentCandidates labObj=new ScheduleAbsentCandidates();
					labObj.setfKCandidateID(candidate.getCandidateID());
					labObj.setFkScheduleID(Long.parseLong(fkScheduleID));
					labObj.setCandidate(candidate);
					labSessionAbsentCandidates.add(labObj);
				}
			}
			LabSAbsentViewModel absentViewModel=new LabSAbsentViewModel();
			absentViewModel.setLabSessionAbsentCanididates(labSessionAbsentCandidates);
			
			model.addAttribute("absentViewModel",absentViewModel);
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in markAbsentCandidate...",e);
		}
		return "Admin/GroupSchedule/MarkAbsentCandidate";
	}
	
	/**
	 * Post method to Save Absent Candidates
	 * @param absentViewModel
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/saveAbsentCandidates" }, method = RequestMethod.POST)
	public String saveAbsentCandidates(@ModelAttribute("absentViewModel") LabSAbsentViewModel absentViewModel,Model model, HttpServletRequest request) {
		String examEventID=null;
		String collectionID=null;
		String fkScheduleID=null;
		
		List<ScheduleAbsentCandidates> absentCandidates=null;
		List<ScheduleAbsentCandidates> candidates=null;
		try
		{
			 examEventID = request.getParameter(EXAMEVENTID);
			 collectionID = request.getParameter("collectionID");
			 fkScheduleID=request.getParameter("fkScheduleID");
			 
			VenueUser user=SessionHelper.getLogedInUser(request);
			absentCandidates=absentViewModel.getLabSessionAbsentCanididates();
			
			if(absentCandidates!=null && absentCandidates.size()!=0)
			{
				candidates=new ArrayList<ScheduleAbsentCandidates>();
				for(ScheduleAbsentCandidates obj:absentCandidates)
				{
					if(obj.getfKCandidateID()!=0)
					{
						obj.setCreatedBy(user.getUserName());
						obj.setDateCreated(new Date());
						candidates.add(obj);
					}
				}
			}
			GroupScheduleServiceImpl labService=new GroupScheduleServiceImpl();
			labService.saveScheduleAbsentCandidates(candidates);
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in saveAbsentCandidate...",e);
		}
		return "redirect:../groupSchedule/createLabGroup?examEventID="+examEventID+"&collectionID="+collectionID+"&fkScheduleID="+fkScheduleID+"&markAbsentCandidate=true";
	}
	
	/**
	 * Get method to Create Lab Session Group
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/createLabGroup" }, method = RequestMethod.GET)
	public String createLabSessionGroup(Model model, HttpServletRequest request) {
		List<Candidate> candidateList=null;
		String examEventID=null;
		String collectionID=null;
		String fkScheduleID=null;
		try
		{
			examEventID = request.getParameter(EXAMEVENTID);
			collectionID = request.getParameter("collectionID");
			fkScheduleID=request.getParameter("fkScheduleID");
			String markAbsentCandidate=request.getParameter("markAbsentCandidate");
			
			VenueUser user=SessionHelper.getLogedInUser(request);
			GroupScheduleServiceImpl labService=new GroupScheduleServiceImpl();
			ExamEventServiceImpl eService=new ExamEventServiceImpl();
			
			if(examEventID!=null && collectionID!=null && fkScheduleID!=null && markAbsentCandidate!=null)
			{
				if(markAbsentCandidate.equals("true"))
				{
					candidateList=labService.getPresentCandidateListForGroupScheduling(Long.parseLong(examEventID),Long.parseLong(collectionID),Long.parseLong(fkScheduleID));
				}
				else
				{
					candidateList=labService.getcandidateListForGroupScheduling(Long.parseLong(examEventID), Long.parseLong(collectionID));
				}
			}

			ExamEvent examEvent=eService.getExamEventByID(Long.parseLong(examEventID));
			if(candidateList==null)
			{
				return "Admin/GroupSchedule/ScheduleGroups?messageid=40";
			}
			
			if(candidateList!=null && candidateList.size()<examEvent.getGroupMinSize())
			{
				return "Admin/GroupSchedule/ScheduleGroups?messageid=43";
			}
			//getNoOfBucket*min>total :: group can not be formed
			if(getNoOfBucket(candidateList.size(), examEvent.getGroupMaxSize(), examEvent.getGroupMinSize())*examEvent.getGroupMinSize()>candidateList.size())
			{
				return "Admin/GroupSchedule/ScheduleGroups?messageid=44";
			}
			//check if enough no. of group exists.
			List<GroupMaster> groupMasters=labService.getGroupMasterList();
			if(getNoOfBucket(candidateList.size(), examEvent.getGroupMaxSize(), examEvent.getGroupMinSize())>groupMasters.size())
			{
				return "Admin/GroupSchedule/ScheduleGroups?messageid=45";
			}
			
			List<GroupScheduleViewModel> groupScheduleViewModels=createGroupsForScheduling(examEvent,Long.parseLong(collectionID),Long.parseLong(fkScheduleID),candidateList,user);
			LOGGER.info("GroupScheduleViewModel List..."+groupScheduleViewModels.size());
			List<SchedulePaperAssociation> associations=labService.getSPAByEventCollectionScheduleID(Long.parseLong(examEventID), Long.parseLong(collectionID),Long.parseLong(fkScheduleID));
			boolean saveGroups=labService.saveGroupScheduleViewModelListUpdateCExam(groupScheduleViewModels,associations);
			
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in createLabSessionGroup...",e);
		}
		return "redirect:../GroupReport/groupReport?examEventSelect="+examEventID+"&collectionID="+collectionID+"&weekSelect="+fkScheduleID+"&type=1";
	}

	/**
	 * Method to Create Group for Scheduling 
	 * @param examEvent
	 * @param collectionID
	 * @param fkScheduleID
	 * @param candidateList
	 * @param user
	 * @return List<GroupScheduleViewModel> this returns the GroupScheduleViewModelList
	 */
	private List<GroupScheduleViewModel> createGroupsForScheduling(	ExamEvent examEvent, Long collectionID, Long fkScheduleID,
			List<Candidate> candidateList, VenueUser user) 
	{
		int min=examEvent.getGroupMinSize();
		int max=examEvent.getGroupMaxSize();
		int total=candidateList.size();
		
		long noOfBucket = getNoOfBucket(total, max, min); 
		LOGGER.info("Total Candidate:"+total);
		
		 int groupMasterIndex = (int) noOfBucket-1;
		 
		List<GroupScheduleViewModel> groupScheduleViewModels=null;
		List<GroupCandidateAssociation> groupCandidateAssociations=null;
		
		GroupScheduleServiceImpl labServiceImpl=new GroupScheduleServiceImpl();
		List<GroupMaster> groupMasters=labServiceImpl.getGroupMasterList();
		
		groupScheduleViewModels=new ArrayList<GroupScheduleViewModel>();
		
		if (total % max != 0) {
			for (long i = noOfBucket; i >= 1;i--) {
				
				GroupScheduleViewModel scheduleViewModel=new GroupScheduleViewModel();
				
				GroupCollectionAssociation collectionAssociation=new GroupCollectionAssociation();
				collectionAssociation.setFkScheduleID(fkScheduleID);
				collectionAssociation.setFkCollectionID(collectionID);
				collectionAssociation.setFkGroupID(groupMasters.get(groupMasterIndex).getGroupID());
				collectionAssociation.setCreatedBy(user.getUserName());
				collectionAssociation.setDateCreated(new Date());
				groupCandidateAssociations=new ArrayList<GroupCandidateAssociation>();
				
			      if (total % max < min && total % max !=0) {
	                    total = total - min;
	                    int tempVar = total;
	                    for (long j = 0; j < min; j++) {
	                    	LOGGER.info("TempBucket...."+tempVar);
	                    	
	                    	GroupCandidateAssociation association=new GroupCandidateAssociation();
	    					association.setCandidate(candidateList.get(tempVar));
	    					association.setFkCandidateID(candidateList.get(tempVar).getCandidateID());
	    					association.setCandidateSequenceNo(j+1);
	    					association.setCreatedBy(user.getUserName());
	    					association.setDateCreated(new Date());
	    			
	    					association.setFkCollectionID(collectionID);
	    					association.setFkScheduleID(fkScheduleID);
	    					association.setFkGroupID(groupMasters.get(groupMasterIndex).getGroupID());
	    					
	    					//Added into groupCandidateAssociation list
	    					groupCandidateAssociations.add(association);
	                        tempVar++;
	                    }
	                    LOGGER.info("Group ::"+collectionAssociation.getFkGroupID());
	                    LOGGER.info("-----------------------");
	                 
	                    //Set list to GroupScheduleViewModel object and add it to GroupScheduleViewModel list
	                    scheduleViewModel.setGrpCollecAssociation(collectionAssociation);
	                    scheduleViewModel.setGrAssociations(groupCandidateAssociations);
	                    groupScheduleViewModels.add(scheduleViewModel);
	                    
	                    groupMasterIndex--;
	                } 
			      else {
	                    int tempmax = 0;
	                    if(total%max == 0){
	                        tempmax = max;
	                    }else{
	                        tempmax = total%max;
	                    }
	                    total = total - tempmax;
	                    int tempVar = total;
	                    for (int j = 0; j < tempmax; j++) {
	                    	LOGGER.info("TempBucket...."+tempVar);
	                    	
	                    	GroupCandidateAssociation association=new GroupCandidateAssociation();
	    					association.setCandidate(candidateList.get(tempVar));
	    					association.setFkCandidateID(candidateList.get(tempVar).getCandidateID());
	    					association.setCandidateSequenceNo(j+1);
	    					association.setCreatedBy(user.getUserName());
	    					association.setDateCreated(new Date());
	    					
	    					association.setFkCollectionID(collectionID);
	    					association.setFkScheduleID(fkScheduleID);
	    					association.setFkGroupID(groupMasters.get(groupMasterIndex).getGroupID());
	    					
	    					//Added into groupCandidateAssociation list
	    					groupCandidateAssociations.add(association);
	    			        tempVar++;
	                    }
	                    LOGGER.info("Group ::"+collectionAssociation.getFkGroupID());
	                    LOGGER.info("-----------------------");
	                  //Set list to GroupScheduleViewModel object and add it to GroupScheduleViewModel list
	                    scheduleViewModel.setGrpCollecAssociation(collectionAssociation);
	                    scheduleViewModel.setGrAssociations(groupCandidateAssociations);
	                    groupScheduleViewModels.add(scheduleViewModel);
	                    
	                    groupMasterIndex--;
	                }
				}
			}
		else{
	        for (long i = noOfBucket; i >= 1; i--) {
	        	
	        	GroupScheduleViewModel scheduleViewModel=new GroupScheduleViewModel();

	        	GroupCollectionAssociation collectionAssociation=new GroupCollectionAssociation();
				collectionAssociation.setFkScheduleID(fkScheduleID);
				collectionAssociation.setFkCollectionID(collectionID);
				collectionAssociation.setFkGroupID(groupMasters.get(groupMasterIndex).getGroupID());
				collectionAssociation.setCreatedBy(user.getUserName());
				collectionAssociation.setDateCreated(new Date());
				
				groupCandidateAssociations=new ArrayList<GroupCandidateAssociation>();
				
	            total = total - max;
	            int tempVar = total;
	            for (int j = 0; j < max; j++) {
	            	LOGGER.info("TempBucket...."+tempVar);
	            	
	            	GroupCandidateAssociation association=new GroupCandidateAssociation();
					association.setCandidate(candidateList.get(tempVar));
					association.setFkCandidateID(candidateList.get(tempVar).getCandidateID());
					association.setCandidateSequenceNo(j+1);
					association.setCreatedBy(user.getUserName());
					association.setDateCreated(new Date());
					
					association.setFkCollectionID(collectionID);
					association.setFkScheduleID(fkScheduleID);
					association.setFkGroupID(groupMasters.get(groupMasterIndex).getGroupID());
					
					//Added into groupCandidateAssociation list
					groupCandidateAssociations.add(association);
			        tempVar++;
	            }
	            LOGGER.info("Group ::"+collectionAssociation.getFkGroupID());
                LOGGER.info("-----------------------");
                //Set list to GroupScheduleViewModel object and add it to GroupScheduleViewModel list
                scheduleViewModel.setGrpCollecAssociation(collectionAssociation);
                scheduleViewModel.setGrAssociations(groupCandidateAssociations);
                groupScheduleViewModels.add(scheduleViewModel);
                
                groupMasterIndex--;
	         }
	     }
		 Collections.reverse(groupScheduleViewModels);
		return groupScheduleViewModels;
	}

	/**
	 * Method to fetch No. of Bucket
	 * @param total
	 * @param max
	 * @param min
	 * @return long this returns the bucket count
	 */
	static long getNoOfBucket(long total, int max, int min) {
        if (total % max != 0) {
            return (total / max) + 1;
        } else {
            return total / max;
        }
	}
		
	/**
	 * Get method to edit Subject wise Paper
	 * @param model
	 * @param request
	 * @param examEventID
	 * @param collectionID
	 * @param weekID
	 * @param isForEdit
	 * @param messageid
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/editSubjectWisePaper" }, method = RequestMethod.GET)
	public String editSubjectWisePaper(Model model, HttpServletRequest request,String examEventID,
			String collectionID,String weekID,String isForEdit,String messageid,Locale locale) {
		try
		{
			model.addAttribute(EXAMEVENTID, Long.parseLong(examEventID));
			model.addAttribute("collectionID", Long.parseLong(collectionID));
			model.addAttribute("weekID", Long.parseLong(weekID));
			model.addAttribute("isForEdit", isForEdit);
			model.addAttribute("groupExist",true);
			model.addAttribute("groupCreateMode",readGroupCreationMode());
			
			if (messageid!=null && messageid!="") {
				MKCLUtility.addMessage(Integer.parseInt(messageid), model, locale);
			}
			
			VenueUser user=SessionHelper.getLogedInUser(request);
			GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
			examEventService=new ExamEventServiceImpl();
					
			ExamEvent eobj=examEventService.getExamEventByID(Long.parseLong(examEventID));
			
			ScheduleMaster smObj = null;
			List<DisplayCategoryLanguage> displayCategoryLanguageList = null;
			List<Paper> paperList = null;
			List<SchedulePaperAssociation> wpdObj = null;
			
			Map<ScheduleMaster, Map<DisplayCategoryLanguage, List<Paper>>> scheduleWiseDispCategoryPaperAssociationMap = new LinkedHashMap<ScheduleMaster, Map<DisplayCategoryLanguage, List<Paper>>>();
			Map<DisplayCategoryLanguage, List<Paper>> subjectLanguagePaperList = new LinkedHashMap<DisplayCategoryLanguage, List<Paper>>();
			
			WeekPaperDivisionAssociationViewModel wpdAssociationViewModel = new WeekPaperDivisionAssociationViewModel();
			List<SchedulePaperAssociation> weekPaperDivisionAssociationList = new ArrayList<SchedulePaperAssociation>();

			displayCategoryLanguageList = labServiceObj.getDisplayCategoryListByUserRole(user, eobj,Long.parseLong(collectionID));
			smObj = labServiceObj.getScheduleMasterOne(Long.parseLong(weekID));
			
			for (DisplayCategoryLanguage subObj : displayCategoryLanguageList) {
				paperList = labServiceObj.getDisplayCategoryPaperListForEditingByScheduleID(subObj.getFkDisplayCategoryID(),
						Long.parseLong(examEventID),Long.parseLong(collectionID),Long.parseLong(weekID));
				subjectLanguagePaperList.put(subObj, paperList);

				wpdObj = labServiceObj.getSchedulePaperAssociationByEventDivisionScheduleDisplayCategoryID(Long.parseLong(examEventID),
								Long.parseLong(collectionID),
								Long.parseLong(weekID),
								subObj.getFkDisplayCategoryID());
							if (wpdObj != null && wpdObj.size()!=0) {
							weekPaperDivisionAssociationList.addAll(wpdObj);
							
							//if maxNoofPaper's is not equal to 1 then only add blank object(works for edit mode)
							if(smObj.getMaxNumberOfPapers()!=1)
							{
								SchedulePaperAssociation wObj = new SchedulePaperAssociation();
								wObj.setFkExamEventID(Long.parseLong(examEventID));
								wObj.setFkCollectionID(Long.parseLong(collectionID));
								wObj.setFkScheduleID(Long.parseLong(weekID));
								wObj.setFkDisplayCategoryID(subObj.getFkDisplayCategoryID());
								weekPaperDivisionAssociationList.add(wObj);
							}
						}
						else
						{
							SchedulePaperAssociation wObj = new SchedulePaperAssociation();
							wObj.setFkExamEventID(Long.parseLong(examEventID));
							wObj.setFkCollectionID(Long.parseLong(collectionID));
							wObj.setFkScheduleID(Long.parseLong(weekID));
							wObj.setFkDisplayCategoryID(subObj.getFkDisplayCategoryID());
							weekPaperDivisionAssociationList.add(wObj);
						}
			}

			wpdAssociationViewModel
					.setWeekPaperDivisionAssoiciationList(weekPaperDivisionAssociationList);
			scheduleWiseDispCategoryPaperAssociationMap.put(smObj,subjectLanguagePaperList);

			model.addAttribute("wpdAssociationViewModel",
					wpdAssociationViewModel);
			model.addAttribute("weekWiseSubjectPaperMap",
					scheduleWiseDispCategoryPaperAssociationMap);
		
		}
		catch(Exception e)
		{
			LOGGER.error("Exception in editSubjectWisePaper...",e);
			model.addAttribute(Constants.EXCEPTIONSTRING, e.getMessage());
			return  "Common/error";
		}
		return SCHEDULELABSESSION;
	}

	/**
	 * Post method to Delete Schedule
	 * @param model
	 * @param request
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/deleteSchedule" }, method = RequestMethod.POST)
	public String deleteSubjectWisePaper(Model model, HttpServletRequest request) {
		String fkPaperID = request.getParameter("fkPaperID");
		String fkWeekID = request.getParameter("fkWeekID");
		String fkDivisionID = request.getParameter("fkDivisionID");
		String fkExamEventID = request.getParameter("fkExamEventID");
	
		GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
		
		if (fkPaperID != null && fkWeekID != null && fkDivisionID != null
				&& fkExamEventID != null) {
			// if attempted don't delete add message
			if(labServiceObj.getNoOfAttemptsInCurrentSchedulebyPaperID(Long.parseLong(fkExamEventID),Long.parseLong(fkDivisionID),Long.parseLong(fkPaperID))>0)
			{
				// Add message
				return "redirect:../groupSchedule/editSubjectWisePaper?examEventID="
				+ Long.parseLong(fkExamEventID) + "&collectionID="
				+ Long.parseLong(fkDivisionID) + "&weekID="
				+ Long.parseLong(fkWeekID)+"&isForEdit=true&messageid=38";
			}
			else
			{
				 /*delete paper from schedule */
				labServiceObj.deleteSchedulePaperAssociation(
						Long.parseLong(fkExamEventID),
						Long.parseLong(fkDivisionID), Long.parseLong(fkWeekID),
						Long.parseLong(fkPaperID));
			}
		}
		return "redirect:../groupSchedule/editSubjectWisePaper?examEventID="
				+ Long.parseLong(fkExamEventID) + "&collectionID="
				+ Long.parseLong(fkDivisionID) + "&weekID="
				+ Long.parseLong(fkWeekID)+"&isForEdit=true";
	}

	/**
	 * Method to fetch the Already Defined Schedule
	 * @param model
	 * @param request
	 * @param examEventID
	 * @param collectionID
	 * @param labServiceObj
	 * @param user
	 */
	private void getAlreadyDefinedSchedule(Model model,
			HttpServletRequest request, String examEventID, String collectionID,GroupScheduleServiceImpl labServiceObj,VenueUser user) {
		
		/****************** Already defined schedule *************************** */
		List<ScheduleMaster> weekList = null;
		List<DisplayCategory> displayCategoryList = null;
		
		model.addAttribute(EXAMEVENTID, Long.parseLong(examEventID));
		if(collectionID!=null && !collectionID.isEmpty())
		{
			model.addAttribute("collectionID", Long.parseLong(collectionID));
		}
		
		Map<ScheduleMaster, List<SchedulePaperAssociation>> definedSheduleMap = new LinkedHashMap<ScheduleMaster, List<SchedulePaperAssociation>>();
		Map<Long, DisplayCategoryLanguage> subjectIDLanguageMap = new LinkedHashMap<Long, DisplayCategoryLanguage>();
		List<SchedulePaperAssociation> weekPaperDivisionAssociations =null;
		List<DisplayCategoryLanguage> subjectLanguageList=null;
		examEventService=new ExamEventServiceImpl();
		
		weekList = labServiceObj.getAllSchedules(Long.parseLong(examEventID),Long.parseLong(collectionID));
		ExamEvent examEvent = examEventService.getExamEventByID(Long.parseLong(examEventID));
		
		displayCategoryList = labServiceObj.getDisplayCategoryList(Long.parseLong(examEventID));
		
		if(displayCategoryList!=null && displayCategoryList.size()!=0)
		{
			subjectLanguageList=new ArrayList<DisplayCategoryLanguage>();
			for (DisplayCategory sub : displayCategoryList) {
				DisplayCategoryLanguage sublan = labServiceObj
						.getDisplayCategoryLanguageByDisplayCategoryIDexamEventDefaultLanguage(
								sub.getDisplayCategoryID(),
								examEvent.getDefaultLanguageID());
				subjectIDLanguageMap.put(sub.getDisplayCategoryID(), sublan);
				if(sublan!=null)
				{
					subjectLanguageList.add(sublan);
				}
				
			}
		}
		
		/*code for subject paperlist in weekpaperDivisionAssociation*/
		Map<String,Long> weekWiseSubjectPaperListMap = new LinkedHashMap<String,Long>();
		List<SchedulePaperAssociation> wpdObj=null;
		for (ScheduleMaster scheduleObj : weekList) {
			weekPaperDivisionAssociations = new ArrayList<SchedulePaperAssociation>();
			for (DisplayCategoryLanguage subObj : subjectLanguageList) {
				// getWeekPaperDivisionAssociationByEventDivisionWeekSubjectID
			wpdObj = labServiceObj.getSPAListByEDSD(
								Long.parseLong(examEventID),
								Long.parseLong(collectionID),
								scheduleObj.getScheduleID(),
								subObj.getFkDisplayCategoryID());
				long paperIDListSize=0;
				if(wpdObj!=null && wpdObj.size()!=0)
				{
					paperIDListSize=wpdObj.size();
				}
				weekWiseSubjectPaperListMap.put(String.valueOf(scheduleObj.getScheduleID())+"||"+String.valueOf(subObj.getFkDisplayCategoryID()),paperIDListSize);
				if(wpdObj!=null)
				{
					weekPaperDivisionAssociations.addAll(wpdObj);
				}
			}
			definedSheduleMap.put(scheduleObj, weekPaperDivisionAssociations);
		}
		
		model.addAttribute("definedSheduleMap", definedSheduleMap);
		model.addAttribute("subjectIDLanguage", subjectIDLanguageMap);
		model.addAttribute("weekWiseSubjectPaperListMap", weekWiseSubjectPaperListMap);
	}

	/**
	 * Method to read Group Creation Mode
	 * @return int this returns the group creation mode
	 */
	private int readGroupCreationMode() {
		Properties properties;	
		String mode;
		properties=new Properties();
		int groupCreationMode=0;
		try
		{
			properties.load(Thread.currentThread()
					.getContextClassLoader()
					.getResourceAsStream("mkclproperties.properties"));
			if(properties!=null)
			{			
				mode = properties.getProperty("GroupCreationMode");
				groupCreationMode=Integer.parseInt(mode);
			}
		}
		catch(Exception e)
		{
			properties=null;
			LOGGER.error("Exception in readGroupCreationMode...",e);
		}
		return groupCreationMode;
	}
	
} /* End of class */
