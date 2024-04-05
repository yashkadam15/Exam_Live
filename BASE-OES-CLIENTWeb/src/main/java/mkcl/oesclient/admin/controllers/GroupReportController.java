package mkcl.oesclient.admin.controllers;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oesclient.admin.services.GroupReportServicesImpl;
import mkcl.oesclient.admin.services.GroupScheduleServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.utilities.FileUploadHelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.model.Candidate;
import mkcl.oesclient.model.CollectionMaster;
import mkcl.oesclient.model.GroupMaster;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.pdfgenerator.PDFComponent;
import mkcl.oesclient.pdfviewmodel.CollectionMasterViewModelPDF;
import mkcl.oesclient.pdfviewmodel.GroupMasterViewModelPDF;
import mkcl.oesclient.pdfviewmodel.GroupReportViewModelPDF;
import mkcl.oesclient.pdfviewmodel.ScheduleMasterViewModelPDF;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ScheduleMaster;
import mkcl.oespcs.model.SchedulePaperAssociation;

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
 * @author priyankag
 *
 */
@Controller
@RequestMapping("GroupReport")
public class GroupReportController {
	
	private static Logger LOGGER = LoggerFactory.getLogger(LoginReportController.class);
	
	
	
	/**
	 * Get method for Group Lab Session Report
	 * @param model
	 * @param request
	 * @param locale
	 * @param pdfmsg
	 * @return String this returns the path of a view
	 */
	@RequestMapping(value = { "/groupReport" }, method = {RequestMethod.GET})
	public String getLabSessionReport(Model model,HttpServletRequest request,Locale locale,String pdfmsg) {
		GroupReportServicesImpl groupReportServices= new GroupReportServicesImpl();	
		ExamEventServiceImpl eventServiceImpl= new ExamEventServiceImpl();
		String examEventID=request.getParameter("examEventSelect");
		String collectionID=request.getParameter("collectionID");
		String weekID=request.getParameter("weekSelect");
		String type=request.getParameter("type");
		Map<ScheduleMaster, Map<CollectionMaster, Map<GroupMaster, List<Candidate>>>> reportMap=null;
		
		
		String imgrelativePath = FileUploadHelper.getRelativeFolderPath(request, "UserPhotoUploadPath");
		model.addAttribute("imgPath", imgrelativePath);
		
		String pdfMsg = request.getParameter("pdfmsg");
		if(pdfMsg!=null)
		{
			model.addAttribute("pdfMsg", pdfMsg);
		}
		
		if(examEventID!=null && type.equals("1") && collectionID!=null && weekID!=null)	
		{
		reportMap= groupReportServices.getGroupReportViewModelList(Long.parseLong(examEventID), Long.parseLong(collectionID),Long.parseLong(weekID),1l,request,locale);
		ExamEvent event=eventServiceImpl.getExamEventByID(Long.parseLong(examEventID));
		model.addAttribute("event", event);
		model.addAttribute("reportMap", reportMap);
		model.addAttribute("reportSize", reportMap.size());
		model.addAttribute("type", 1);
		model.addAttribute("examEventID", examEventID);
		model.addAttribute("collectionID", collectionID);
		model.addAttribute("weekID", weekID);		
		}
		else if(type !=null && type.equals("1") )
		{
			model.addAttribute("type", 1);
		}
		else if(examEventID!=null)
		{			
			reportMap= groupReportServices.getGroupReportViewModelList(Long.parseLong(examEventID), 0, 0,0,request,locale);
			ExamEvent event=eventServiceImpl.getExamEventByID(Long.parseLong(examEventID));
			model.addAttribute("event", event);
			model.addAttribute("reportMap", reportMap);	
			model.addAttribute("reportSize", reportMap.size());
			model.addAttribute("examEventID", examEventID);
			model.addAttribute("type", 0);
		}
		
		return "Admin/GroupReport/GroupReport";
		
	}
	
	/**
	 * Method to fetch the Active Exam Event List 
	 * @param request
	 * @return List<ExamEvent> this returns the active exam event list
	 */
	@ModelAttribute("activeExamEventList")
	public List<ExamEvent> getactiveExamEventList( HttpServletRequest request) {
		List<ExamEvent> activeExamEventList = null;
		GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();	
		VenueUser venueUser=SessionHelper.getLogedInUser(request);
		activeExamEventList = labServiceObj.getActiveExamEventList(venueUser);
	
		return activeExamEventList;
	}

	/**
	 * Post method to fetch the Division List Associated to Exam Event for a Role
	 * @param examEventID
	 * @param request
	 * @return List<CollectionMaster> this returns the division list
	 */
	@RequestMapping(value = "/divisionAccEventRole.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<CollectionMaster> getDivisionList(
		@RequestBody ExamEvent examEventID, HttpServletRequest request) {
		
		VenueUser user=SessionHelper.getLogedInUser(request);
		GroupScheduleServiceImpl labServiceObj=new GroupScheduleServiceImpl();
		
		List<CollectionMaster> divisionList = new ArrayList<CollectionMaster>();
		
		divisionList = labServiceObj.getCollectionMasterAccRole(user,examEventID.getExamEventID());
		return divisionList;
	}
	
	/**
	 * Post method to fetch the Weekly Schedule List Associated to the Exam Event Divisions
	 * @param association
	 * @param request
	 * @return List<ScheduleMaster> this returns the weekly schedule list
	 */
	@RequestMapping(value = "/WeekAccEventDivision.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<ScheduleMaster> getWeekList(@RequestBody SchedulePaperAssociation association,HttpServletRequest request) {
		List<ScheduleMaster> scheduleList =null;		
		GroupReportServicesImpl groupReportServices= new GroupReportServicesImpl();
		scheduleList = groupReportServices.getSchedulMasterList(association.getFkExamEventID(),association.getFkCollectionID());		
		return scheduleList;
	}
	
	/**
	 * Post method for Group Report PDF
	 * @param model
	 * @param request
	 * @param response
	 * @param locale
	 * @return String this returns the path of a view
	 */
	@RequestMapping({ "GroupReport.pdf" })
	public String getReportPDF(Model model,HttpServletRequest request,HttpServletResponse response,Locale locale) {
		GroupReportServicesImpl groupReportServices= new GroupReportServicesImpl();
		ExamEventServiceImpl eventServiceImpl= new ExamEventServiceImpl();
		
		try {
			String examEventID=request.getParameter("examEventIDPDF");
			String collectionID=request.getParameter("collectionIDPDF");
			String weekID=request.getParameter("weekIDPDF");
			String type=request.getParameter("typePDF");
			Map<ScheduleMaster, Map<CollectionMaster, Map<GroupMaster, List<Candidate>>>> reportMap=null;
				
			if(examEventID!=null && type.equals("1") )	
			{
		    reportMap= groupReportServices.getGroupReportViewModelList(Long.parseLong(examEventID), Long.parseLong(collectionID),Long.parseLong(weekID),1l,request,locale);				
			}
			else if(type.equals("0"))
			{
			reportMap= groupReportServices.getGroupReportViewModelList(Long.parseLong(examEventID), 0, 0,0,request,locale);
			}
			
			if(reportMap.size()!=0 )
			{
			List<ScheduleMasterViewModelPDF> scheduleMasterViewModelPDFList=getScheduleMasterViewModelPDFList(reportMap);
			GroupReportViewModelPDF groupReportViewModelPDF= new GroupReportViewModelPDF();	
			
			groupReportViewModelPDF.setLocale("messages_"+locale.getLanguage() +".properties"); 
			
			groupReportViewModelPDF.setScheduleMasterViewModelPDFList(scheduleMasterViewModelPDFList);
			if(examEventID.isEmpty() && examEventID=="")
			{
			long examEventId=reportMap.entrySet().iterator().next().getKey().getFkExamEventID();
			groupReportViewModelPDF.setReportName("Group Login Report for "+eventServiceImpl.getExamEventByID(examEventId).getName());
			groupReportViewModelPDF.setExamEventName(eventServiceImpl.getExamEventByID(examEventId).getName());
			}
			else
			{
			groupReportViewModelPDF.setReportName("Group Login Report for "+eventServiceImpl.getExamEventByID(Long.parseLong(examEventID)).getName());
			groupReportViewModelPDF.setExamEventName(eventServiceImpl.getExamEventByID(Long.parseLong(examEventID)).getName());
			}
			
            
			PDFComponent<GroupReportViewModelPDF> pdfGen = new PDFComponent<GroupReportViewModelPDF>(request, response);
				pdfGen.setPdfFileName("Group Login Report");
				pdfGen.setInputsToXML(groupReportViewModelPDF);
				pdfGen.setStyleSheetXSLName("GroupReport.xsl");
				boolean status = pdfGen.startPDFGeneratorEngine();

				//code to display message 
				if (!status) {
					pdfGen.writeErrorResponseContent();
				}		
				return null;	
		}
		else
		{
			MKCLUtility.addMessage(42, model, locale);		
			return "redirect:../GroupReport/groupReport?examEventSelect="+examEventID+"&collectionID="+collectionID+"&weekSelect="+weekID+"&type="+type+"&pdfmsg=1";	
		}
		} catch (Exception e) {
			LOGGER.error("Exception occured in exportCadidateReportToPDF: " , e);
			return null;		
		}
	}
	
	
	/**
	 * Method to fetch the Schedule Details List in a PDF
	 * @param reportMap
	 * @return List<ScheduleMasterViewModelPDF> this returns the ScheduleMasterViewModelPDFList
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<ScheduleMasterViewModelPDF> getScheduleMasterViewModelPDFList(Map<ScheduleMaster, Map<CollectionMaster, Map<GroupMaster, List<Candidate>>>> reportMap)
	{
		List<ScheduleMasterViewModelPDF> scheduleMasterViewModelPDFList= new ArrayList<ScheduleMasterViewModelPDF>();
		List<CollectionMasterViewModelPDF> collectionMasterViewModelPDFList=null;
		List<GroupMasterViewModelPDF> groupMasterViewModelPDFList=null;
		DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		
		
		Iterator iterator = reportMap.entrySet().iterator();
		while (iterator.hasNext()) {
			Map.Entry mapEntry = (Map.Entry) iterator.next();
			ScheduleMaster scheduleMaster=(ScheduleMaster) mapEntry.getKey();
			Map<CollectionMaster,Map<GroupMaster,List<Candidate>>> collectionMap=(Map<CollectionMaster, Map<GroupMaster, List<Candidate>>>) mapEntry.getValue();
			
			   
			ScheduleMasterViewModelPDF scheduleMasterViewModelPDF= new ScheduleMasterViewModelPDF();
		
			
			collectionMasterViewModelPDFList= new ArrayList<CollectionMasterViewModelPDF>();			
			
			Iterator iterator1 = collectionMap.entrySet().iterator();
			while (iterator1.hasNext()) {
				
				Map.Entry mapEntry1 = (Map.Entry) iterator1.next();
				CollectionMaster collectionMaster=(CollectionMaster) mapEntry1.getKey();
				Map<GroupMaster,List<Candidate>> groupMap=( Map<GroupMaster, List<Candidate>>) mapEntry1.getValue();	
				long noOFCandidate=0;
				
				CollectionMasterViewModelPDF collectionMasterViewModelPDF= new CollectionMasterViewModelPDF();
			
				
				groupMasterViewModelPDFList= new ArrayList<GroupMasterViewModelPDF>();
				Iterator iterator2 = groupMap.entrySet().iterator();	
				int flag=0;
				while (iterator2.hasNext()) {
				
					Map.Entry mapEntry2 = (Map.Entry) iterator2.next();
					GroupMaster groupMaster=(GroupMaster) mapEntry2.getKey();
					List<Candidate> candidateList=(List<Candidate>) mapEntry2.getValue();
					GroupMasterViewModelPDF groupReportViewModelPDF= new GroupMasterViewModelPDF();
					
					groupReportViewModelPDF.setGroupName(groupMaster.getGroupName());
					groupReportViewModelPDF.setNoOFCandidate(candidateList.size());
					if(flag==0)
					{						
						candidateList.get(0).setCandidateCode("1");
						flag=1;						
					}
					else
					{				
						candidateList.get(0).setCandidateCode("0");
					}
					noOFCandidate=noOFCandidate+candidateList.size();
					
					groupReportViewModelPDF.setCandidateList(candidateList)	;							
					groupMasterViewModelPDFList.add(groupReportViewModelPDF);
				}//group 
				
				if(groupMasterViewModelPDFList!=null && groupMasterViewModelPDFList.size()!=0)
				{
				collectionMasterViewModelPDF.setCollectionName(collectionMaster.getCollectionName());	
				collectionMasterViewModelPDF.setGroupMasterViewModelPDFList(groupMasterViewModelPDFList);
				collectionMasterViewModelPDF.setNoOfCollectionCandidate(noOFCandidate);
				collectionMasterViewModelPDFList.add(collectionMasterViewModelPDF);
				}			
			}//collection		
		
           if(collectionMasterViewModelPDFList!=null && collectionMasterViewModelPDFList.size()!=0)
           {          	    	   
        	   scheduleMasterViewModelPDF.setScheduleStartDate(df.format(scheduleMaster.getScheduleStart()));
        	   scheduleMasterViewModelPDF.setCollectionMasterViewModelPDFList(collectionMasterViewModelPDFList);
        	   scheduleMasterViewModelPDF.setCollectionType(collectionMap.entrySet().iterator().next().getKey().getCollectionType().name());
        	   scheduleMasterViewModelPDFList.add(scheduleMasterViewModelPDF);
           }
           
		}
		
		return scheduleMasterViewModelPDFList;	
		
	}
	
}
