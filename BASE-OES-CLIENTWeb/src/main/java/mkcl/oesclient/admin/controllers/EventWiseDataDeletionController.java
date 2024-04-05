package mkcl.oesclient.admin.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mkcl.baseoesclient.model.EventArchivalStatus;
import mkcl.baseoesclient.model.EventArchivalTables;
import mkcl.baseoesclient.model.ExamEventDataDeletion;
import mkcl.baseoesclient.model.ExamEventDataDeletionTables;
import mkcl.oesclient.commons.controllers.LoginController;
import mkcl.oesclient.commons.services.EventwiseDataDeletionServiceImpl;
import mkcl.oesclient.commons.services.ExamEventServiceImpl;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oespcs.model.ExamEvent;
import mkcl.os.localdal.model.LocalDALException;

@Controller
@RequestMapping("eventDeletion")
public class EventWiseDataDeletionController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EventWiseDataDeletionController.class);
	private static final String USER="user";
	
	EventwiseDataDeletionServiceImpl eventwiseDataDeletionServiceImpl=new EventwiseDataDeletionServiceImpl();
	@RequestMapping(value = { "/expiredEventList"}, method = RequestMethod.GET)
	public String expiredEventList(Model model, Locale locale,HttpServletRequest request) throws LocalDALException
	{
				
		boolean isActiveEvent=false;
		String examEventName=null;
		
		List<ExamEvent> examEventList=eventwiseDataDeletionServiceImpl.getExamEventListForDeletion();
		
		EventArchivalStatus eventArchivalStatus =null;
		eventArchivalStatus=eventwiseDataDeletionServiceImpl.getEventArchivalStatus();	
		
		if(eventArchivalStatus!=null) {
			examEventName = eventwiseDataDeletionServiceImpl.getEventINameFromStatusTable(eventArchivalStatus.getFkExamEventId());
		}
		
		isActiveEvent=new EventwiseDataDeletionServiceImpl().getActiveEvent();

		model.addAttribute("isActiveEvent", isActiveEvent);
		model.addAttribute("examEventList", examEventList);
		model.addAttribute("examEventName", examEventName);
		
		model.addAttribute("enumExamEventDataDeletionTables", ExamEventDataDeletionTables.values());
		model.addAttribute("eventArchivalStatus", eventArchivalStatus);
		model.addAttribute("examEventDataDeletion", ExamEventDataDeletion.values());
		
		return "EventWiseDataDeletion/eventWiseDeletion";
	}
	
	@RequestMapping(value = "/eventDataDeletion.ajax", method = RequestMethod.POST)
	@ResponseBody
	public boolean deleteEventData (@RequestBody ExamEvent examEventID, Model model,HttpServletRequest request) {
		boolean isDataDelete=false;
		try
		{
			VenueUser currentuser = SessionHelper.getLogedInUser(request);
			String user = currentuser.getFirstName();
			//  System.out.println("--eventDataDeletionUSER--->> " + user);
			 
			eventwiseDataDeletionServiceImpl.archivalExamEventRelatedTablesData(examEventID.getExamEventID(),user);
			
		}
		catch(Exception e)
		{
			System.out.println("Exception occured in eventDataDeletion POST: " +e);
			LOGGER.error("Exception occured in eventDataDeletion POST: ", e);
			e.getMessage();
			
		}
		return isDataDelete;
	}
	
	@RequestMapping(value = "/deletionStatus.ajax", method = RequestMethod.POST)
	@ResponseBody
	public List<EventArchivalTables> getStatatusOfTablesOpertaion (@RequestBody ExamEvent examEvent, Model model,HttpServletRequest request) {
		List<EventArchivalTables> eventArchivalTablesList=null;
	
		try
		{
			eventArchivalTablesList = eventwiseDataDeletionServiceImpl.getEventArchivalTables(examEvent.getExamEventID());
			
			
		}
		catch(Exception e)
		{
			System.out.println("Exception occured in deletionStatus POST: " +e);
			LOGGER.error("Exception occured in deletionStatus POST: ", e);
			return eventArchivalTablesList;
		}
		return eventArchivalTablesList;
	}
	
	@RequestMapping(value = "/eventDeletionStatusList.ajax", method = RequestMethod.GET)
	@ResponseBody
	public List<EventArchivalStatus> getStatusOfDeletion () {
		
		List<EventArchivalStatus> eventArchivalStatusList=null;
		
		try
		{
			eventArchivalStatusList = eventwiseDataDeletionServiceImpl.getEventArchivalStatusList();
			
		}
		catch(Exception e)
		{
			System.out.println("Exception occured in eventDeletionStatusList GET: " +e);
			LOGGER.error("Exception occured in eventDeletionStatusList GET: ", e);
			return eventArchivalStatusList;
		}
		
		return eventArchivalStatusList;
	}

}
