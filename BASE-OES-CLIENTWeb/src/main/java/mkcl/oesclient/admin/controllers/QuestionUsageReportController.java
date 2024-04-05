package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oesclient.admin.services.ExamScheduleServiceImpl;
import mkcl.oesclient.admin.services.QuestionUsageReportServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.PaperServiceImpl;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.QuestionUsageReportViewModel;
import mkcl.oespcs.model.Client;
import mkcl.oespcs.model.ExamEvent;
import mkcl.oespcs.model.ExamVenue;
import mkcl.oespcs.model.Paper;
import mkcl.oesserver.model.ItemType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("QuestionUsageReport")
public class QuestionUsageReportController  {

	
	/*private IPaperServices paperServiceImpl;
    private ExamEventServiceImpl eventServiceImpl;    
    private IVenueActivityLogService venueActivityLogServiceImplObj;
    private IOESMonitoringReportServices oesMonitoringReportServicesImplObj;
    private IQuestionUsageReportService questionUsageReportServiceImpl; 
	private IExportPaperDetailsService paperDetailsService*/;    
	private static final Logger LOGGER = LoggerFactory.getLogger(QuestionUsageReportController.class);
 
   
	
   /**
    * Post method to fetch the Exam Venue List
    * @param examEventID
    * @param request
    * @return List<ExamVenue> this returns the ExamVenueList
    */
	@RequestMapping(value = "/examVenueList.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<ExamVenue> getExamVenueList(
			@RequestParam("examEventID") Long examEventID,			
			HttpServletRequest request) {	
		List<ExamVenue> examVenueList = new ArrayList<ExamVenue>();    		
		QuestionUsageReportServiceImpl questionUsageReportServiceImpl= new QuestionUsageReportServiceImpl();
		
		examVenueList = questionUsageReportServiceImpl.getExamVenueListByDistrictandExamEventID(examEventID,"0");
		return examVenueList;
	}
    // End
	
	/**
	 * Get method for Question Usage Report
	 * @param model
	 * @param request
	 * @param response
	 * @param locale
	 * @return String this returns the path of a view
	 */
    @RequestMapping(value = { "/questionUsageReport" }, method = {RequestMethod.GET})
public String getuploadReport(Model model,HttpServletRequest request,HttpServletResponse response, Locale locale) {
	String examEventID=request.getParameter("examEventSelect");
	String paperId=request.getParameter("selectPaper");	
	
	String examvenueID=request.getParameter("selectVenue");		
	
	ExamScheduleServiceImpl eServiceObj = new ExamScheduleServiceImpl();
	List<ExamEvent>  examEventList=eServiceObj.getActiveExamEventList(SessionHelper.getLogedInUser(request));
	
	model.addAttribute("examEventList", examEventList);		
	model.addAttribute("examEventId", examEventID);
	model.addAttribute("paperID", paperId);	
	model.addAttribute("examvenueID", examvenueID);
		
	
	if(examEventID!=null && paperId!=null)
	{
		/*ExamEvent event= eventServiceImpl.getExamEventByID(Long.parseLong(examEventID));
		List<QuestionUsageReportViewModel> questionUsageReportViewModelList= new ArrayList<QuestionUsageReportViewModel>();		
		List<ItemType> itemTypeList=paperDetailsService.getPaperItemTypesByPaperId(Long.parseLong(paperId));
		
		for (ItemType itemType : itemTypeList) {
			questionUsageReportViewModelList.addAll(questionUsageReportServiceImpl.getQuestionItemText(itemType, Long.parseLong(examEventID), Long.parseLong(paperId), event.getDefaultLanguageID()));
		}
		
		List<QuestionUsageReportViewModel> finalquestionUsageReportViewModelList=questionUsageReportServiceImpl.getQuestionUsageDetails(questionUsageReportViewModelList,Long.parseLong( examEventID),Long.parseLong(paperId),Long.parseLong(examvenueID));
		
		model.addAttribute("questionUsageReportViewModelList", finalquestionUsageReportViewModelList);*/
		
	}
	
	return "Admin/QuestionUsageReport/questionUsageReport";		
}
    
    /**
     * Post method for Question Usage Report in Excel
     * @param model
     * @param request
     * @param response
     * @param locale
     */
    @RequestMapping(value = { "/questionUsageReportExcel" }, method = {RequestMethod.POST})
    public void getExcelReport(Model model,HttpServletRequest request,HttpServletResponse response, Locale locale) {
    	
    	String examEventID=request.getParameter("examEventSelect");
    	String paperId=request.getParameter("selectPaper");	
    	
    	String examvenueID=request.getParameter("selectVenue");		
    	model.addAttribute("examEventId", examEventID);
    	model.addAttribute("paperID", paperId);	
    	model.addAttribute("examvenueID", examvenueID);
    		
    
    	if(examEventID!=null && paperId!=null)
    	{   PaperServiceImpl paperServiceImpl= new PaperServiceImpl();
    		ExamEventServiceImpl eventServiceImpl= new ExamEventServiceImpl();
    		QuestionUsageReportServiceImpl questionUsageReportServiceImpl= new QuestionUsageReportServiceImpl();
    		
    		ExamEvent event= eventServiceImpl.getExamEventByID(Long.parseLong(examEventID));
    		List<QuestionUsageReportViewModel> questionUsageReportViewModelList= new ArrayList<QuestionUsageReportViewModel>();		
    		List<ItemType> itemTypeList=questionUsageReportServiceImpl.getPaperItemTypesByPaperId(Long.parseLong(paperId));
    		
    		for (ItemType itemType : itemTypeList) {
    			questionUsageReportViewModelList.addAll(questionUsageReportServiceImpl.getQuestionItemText(itemType, Long.parseLong(examEventID), Long.parseLong(paperId), event.getDefaultLanguageID()));
    		}
    		
    		List<QuestionUsageReportViewModel> finalquestionUsageReportViewModelList=questionUsageReportServiceImpl.getQuestionUsageDetails(questionUsageReportViewModelList,Long.parseLong( examEventID),Long.parseLong(paperId),Long.parseLong(examvenueID));
    		
    		model.addAttribute("questionUsageReportViewModelList", finalquestionUsageReportViewModelList);
    		
    		try {
    		
    		questionUsageReportServiceImpl.getExcelWithQuestionUsage( Long.parseLong(examEventID), Long.parseLong(paperId), Long.parseLong(examvenueID), request, response, finalquestionUsageReportViewModelList);
    		
    		} catch (Exception e) {
    			LOGGER.error("error in Question Usage report createExcel:", e);    		 
    		
    		}
    }
	
	
 }
    
/**
 * Post method to fetch Paper List
 * @param examEventID
 * @param request
 * @return List<Paper> this returns PaperList
 */
@RequestMapping(value = "/paperList.ajax", method = RequestMethod.POST)
@ResponseBody
public List<Paper> getPaperList(
		@RequestBody ExamEvent examEventID, HttpServletRequest request) {	
	List<Paper> paperList = new ArrayList<Paper>();
	PaperServiceImpl paperServiceImpl= new PaperServiceImpl();
	paperList = paperServiceImpl.getPapersByEventId(examEventID.getExamEventID());
	return paperList;
}



	
}
