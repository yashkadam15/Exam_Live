package mkcl.oesclient.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.baseoesclient.model.LoginType;

import mkcl.oesclient.admin.services.SuspendCandidateServicesImpl;
import mkcl.oesclient.utilities.SessionHelper;

public class BasicAuthenticationValidatorFilter implements Filter
{
	private List<String> exclusionsRegEx = new ArrayList<>();
	private List<String> supendRegEx = new ArrayList<>();
	
	SuspendCandidateServicesImpl suspendCandidateServicesImpl=new SuspendCandidateServicesImpl();
	@Override
	public void init(FilterConfig filterConfig) throws ServletException 
	{
		exclusionsRegEx.add("^/resources/.*$");
		exclusionsRegEx.add("^/examClient/.*$");
		exclusionsRegEx.add("^/webjars/.*$");
		exclusionsRegEx.add("^/Logs/.*$");
		exclusionsRegEx.add("^/OESApi/.*$");
		exclusionsRegEx.add("^/activateVenue/.*$");
		exclusionsRegEx.add("^/audit/.*$");
		exclusionsRegEx.add("^/gateway/.*$");
		exclusionsRegEx.add("^/FileUploader/.*$");
		exclusionsRegEx.add("^/appmanager/.*$");
		exclusionsRegEx.add("^/SyncApi/.*$");
		exclusionsRegEx.add("^/soloLogin/.*$");
		exclusionsRegEx.add("^/connectionParam/.*$");
		exclusionsRegEx.add("^/decorators/.*$");
		exclusionsRegEx.add("^/oesDashboard/.*$");
		exclusionsRegEx.add("^/preCheck/.*$");
		
		exclusionsRegEx.add("/");
		exclusionsRegEx.add("/wsfAuth/login");
		exclusionsRegEx.add("/wsfAuth/eventSelection");
		exclusionsRegEx.add("/wsfAuth/logout");
		exclusionsRegEx.add("/launcher");
		exclusionsRegEx.add("/captcha/getCaptcha");
		exclusionsRegEx.add("/login/logout");
		exclusionsRegEx.add("/login/logoutMsg");
		exclusionsRegEx.add("/login/eventSelection");
		exclusionsRegEx.add("/adminLogin/loginpage");
		exclusionsRegEx.add("/adminLogin/logout");
		
		supendRegEx.add("/exam/.*$");
		supendRegEx.add("/commonExam/.*$");
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException
	{
		try {
			HttpServletRequest httpServletRequest = (HttpServletRequest) request;
			HttpServletResponse httpServletResponse = (HttpServletResponse) response;
			long candidateExamId = SessionHelper.getExamPaperSetting(httpServletRequest) !=null ? SessionHelper.getExamPaperSetting(httpServletRequest).getCandidateExamID() : 0;
			
			if(exclusionsRegEx.stream().anyMatch(pattern -> httpServletRequest.getServletPath().matches(pattern)))
			{
				chain.doFilter(request, response);
				return;
			}
			
			String sessionID = SessionHelper.getLogedInUser(httpServletRequest)==null?null:SessionHelper.getLoginMapValue(SessionHelper.getLogedInUser(httpServletRequest).getUserName(), httpServletRequest);			
			if(SessionHelper.getLoginType(httpServletRequest) == LoginType.Solo 
					&& sessionID!=null && !sessionID.isEmpty() && !httpServletRequest.getSession(false).getId().equals(sessionID))
			{
				httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + "/login/logout?isDualLogin=1");
				return;
			}


			if (!SessionHelper.getLoginStatus(httpServletRequest)) 
			{
				httpServletResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Your login session is timed out. Please re-login and try again.");
			}
			else if(SessionHelper.getLoginType(httpServletRequest) == LoginType.Solo && supendRegEx.stream().anyMatch(pattern -> httpServletRequest.getServletPath().matches(pattern)) && candidateExamId > 0  &&  suspendCandidateServicesImpl.validateIsCandidateSuspended(candidateExamId)) {
				httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + "/login/logout?isSuspend=1");
				return;
			}
			else 
			{
				chain.doFilter(request, response);
			}
		} catch (ServletException e) {
			throw e;
		} catch (Exception e) {			
			e.printStackTrace();
		} 
	}

	@Override
	public void destroy() 
	{
		// TODO Auto-generated method stub
		
	}

}
