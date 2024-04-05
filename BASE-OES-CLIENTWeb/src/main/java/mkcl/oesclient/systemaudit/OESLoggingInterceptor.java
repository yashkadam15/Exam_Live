package mkcl.oesclient.systemaudit;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.baseoesclient.model.LogType;
import mkcl.baseoesclient.model.LoginType;
import mkcl.oesclient.commons.controllers.OESLogger;
import mkcl.oesclient.utilities.SessionHelper;
import mkcl.oesclient.viewmodel.ExamViewModel;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class OESLoggingInterceptor extends HandlerInterceptorAdapter {
	private static final Logger LOGGER = LoggerFactory.getLogger(OESLoggingInterceptor.class);
	
	
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
		   {
		try {
			final String hostAddress = OESLogger.getHostAddress(request); 
			if(request.getRequestURI().endsWith("/login/logout")){
				/*Logout Logging*/
				if(SessionHelper.getLoginStatus(request))
				{
			
						if(SessionHelper.getLoginType(request)==LoginType.Admin)
						{
							OESLogger.logLoginActivity(SessionHelper.getLogedInUser(request),0 , LogType.Logout, LoginType.Admin,hostAddress);
						}
						if(SessionHelper.getLoginType(request)==LoginType.Solo)
						{
							OESLogger.logLoginActivity(SessionHelper.getLogedInUser(request),SessionHelper.getExamEvent(request).getExamEventID() , LogType.Logout, LoginType.Solo,hostAddress);
						}
				}

			}
			
			/*Restrict multiple Login Date:30-Apr-2015 Yograjs */
			if(SessionHelper.getLoginStatus(request) && !request.getRequestURI().contains("/login/logout"))
			{
				String sessionID = SessionHelper.getLoginMapValue(SessionHelper.getLogedInUser(request).getUserName(), request);
				if(SessionHelper.getLogedInUser(request)!=null && 
					sessionID!=null && 
					!sessionID.isEmpty() && 
					!request.getSession(false).getId().equals(sessionID))
				{
					LOGGER.error("Concurrent login problem occord in "+SessionHelper.getLogedInUser(request).getUserName()+" login.");
					response.sendRedirect(request.getContextPath()+"/login/logout?isDualLogin=1");
					return false;
				}
			}
			
		} catch (Exception e) {
			LOGGER.error("Exception generated in preHandle of OESLoggingInterceptor",e);
			return true;
		}
			return true;
		}

	
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)
	{
	
		final String hostAddress = OESLogger.getHostAddress(request); 
		  ExamViewModel examViewModelObj = null;
		try {
			/*admin login*/
			if(request.getRequestURI().endsWith("/adminLogin/loginpage")){
				
				if (SessionHelper.getLoginStatus(request)) {
				OESLogger.logLoginActivity(SessionHelper.getLogedInUser(request), 0, LogType.Login, LoginType.Admin,hostAddress);
				
				}

			}
			
			if(request.getRequestURI().endsWith("/soloLogin/loginpage")){
				
				if (SessionHelper.getLoginStatus(request) ) {
					/* Login Logging */
			
					OESLogger.logLoginActivity(SessionHelper.getLogedInUser(request), SessionHelper.getExamEvent(request).getExamEventID(), LogType.Login, LoginType.Solo,hostAddress);
				
				}

			}
			
			if(request.getRequestURI().endsWith("/exam/instruction")){
				
				if (SessionHelper.getLoginStatus(request) && !SessionHelper.getIsLocalCandidate()) {
					/* Login Logging */
					if (SessionHelper.getExamEvent(request).getEnableLog()) {
					
						Map<String,Object> map = modelAndView.getModel();
						
				OESLogger.logExamActivity(SessionHelper.getLogedInUser(request), SessionHelper.getExamEvent(request).getExamEventID(), LogType.InstructionRendering, SessionHelper.getLoginType(request) ,Long.parseLong(map.get("ceid").toString()) , 0,hostAddress);     
						
					}
				}

			}
			
			/*for item rendering*/
		if(request.getRequestURI().endsWith("/exam/QuestionContainer"))
		{
			if (SessionHelper.getLoginStatus(request) && SessionHelper.getExamEvent(request).getEnableLog() && SessionHelper.getExamPaperSetting(request)!=null && !SessionHelper.getIsLocalCandidate()) 
			{
				Map<String,Object> map = modelAndView.getModel();
				examViewModelObj = (ExamViewModel) map.get("examViewModel");
				if(examViewModelObj != null && examViewModelObj.getCandidateItemAssociation() != null )
					OESLogger.logExamActivity(SessionHelper.getLogedInUser(request), SessionHelper.getExamEvent(request).getExamEventID(), LogType.ItemRendering, SessionHelper.getLoginType(request) ,SessionHelper.getExamPaperSetting(request).getCandidateExamID(), examViewModelObj.getCandidateItemAssociation().getFkItemID(),hostAddress);
			}
		}
		
		/*for Exam start*/
		if(request.getRequestURI().endsWith("/exam/TakeTest"))
		{
			if (SessionHelper.getLoginStatus(request) && SessionHelper.getExamEvent(request).getEnableLog() && SessionHelper.getExamPaperSetting(request)!=null && !SessionHelper.getIsLocalCandidate()) 
			{
				OESLogger.logExamActivity(SessionHelper.getLogedInUser(request), SessionHelper.getExamEvent(request).getExamEventID(), LogType.TestStart, SessionHelper.getLoginType(request) ,SessionHelper.getExamPaperSetting(request).getCandidateExamID(), 0,hostAddress);
			}
		}
		
		
		/*for Exam end timeout*/

		if(request.getRequestURI().endsWith("/commonExam/hidFrameendTest"))
		{
			Map<String,Object> map = modelAndView.getModel();
			if (map.containsKey("ceid") && SessionHelper.getLoginStatus(request) && SessionHelper.getExamEvent(request).getEnableLog() && SessionHelper.getLoginType(request)==LoginType.Solo && !SessionHelper.getIsLocalCandidate()) 
			{				
				OESLogger.logExamActivity(SessionHelper.getLogedInUser(request), SessionHelper.getExamEvent(request).getExamEventID(), LogType.ExamTimeUp, SessionHelper.getLoginType(request) ,Long.parseLong(map.get("ceid").toString()), 0,hostAddress); 
			}
		} 
		
		/*for Exam end timeout manual click of end button*/
		if(request.getRequestURI().endsWith("/endexam/FrmendTest"))
		{
			Map<String,Object> map = modelAndView.getModel();
			if (map.containsKey("ceid") && SessionHelper.getLoginStatus(request) && SessionHelper.getExamEvent(request).getEnableLog() && !SessionHelper.getIsLocalCandidate()) 
			{
				OESLogger.logExamActivity(SessionHelper.getLogedInUser(request), SessionHelper.getExamEvent(request).getExamEventID(), LogType.TestEnd, SessionHelper.getLoginType(request) ,Long.parseLong(map.get("ceid").toString()), 0,hostAddress);
			}
		} 
		
		/*for Exam end timeout manual click of end button*/
		if(request.getRequestURI().endsWith("/endexam/FrmendTestGet"))
		{
			Map<String,Object> map = modelAndView.getModel();
			if (map.containsKey("ceid") && SessionHelper.getLoginStatus(request) && SessionHelper.getExamEvent(request).getEnableLog() && !SessionHelper.getIsLocalCandidate()) 
			{				
				OESLogger.logExamActivity(SessionHelper.getLogedInUser(request), SessionHelper.getExamEvent(request).getExamEventID(), LogType.TestEnd, SessionHelper.getLoginType(request) ,Long.parseLong(map.get("ceid").toString()), 0,hostAddress);
			}
		} 
		
		
		} catch (Exception e) {
			LOGGER.error("Exception generated in postHandle of OESLoggingInterceptor",e);
		}
	}
}
