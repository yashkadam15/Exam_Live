
package mkcl.oesclient.security;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections4.CollectionUtils;

import mkcl.oesclient.utilities.SessionHelper;
/**
 * @author virajd
 *
 */
public class RequestAuthorizationFilter implements Filter {
	
	private List<String> adminRequests;
	private List<String> candidateRequests;
	private List<String> ddtAdminRequests;
	private Map<Long, List<String>> mapRoleId_PathList=new HashMap<Long, List<String>>();

	@Override
	public void init(FilterConfig filterConfig) throws ServletException 
	{
		String adminPattern= filterConfig.getInitParameter("adminRequests");
		String candidatePattern= filterConfig.getInitParameter("candidateRequests");
		String ddtAdminPattern= filterConfig.getInitParameter("ddtAdminRequests");
		
		adminRequests = Arrays.asList(adminPattern.replaceAll("\\s+","").replace("*", "(.*)").split(","));
		candidateRequests = Arrays.asList(candidatePattern.replaceAll("\\s+","").replace("*", "(.*)").split(","));
		ddtAdminRequests= Arrays.asList(ddtAdminPattern.replaceAll("\\s+","").replace("*", "(.*)").split(","));
		// 0 role id treated as excluded urls
		mapRoleId_PathList.put(1l, adminRequests);
		mapRoleId_PathList.put(3l, candidateRequests);
		mapRoleId_PathList.put(5l, ddtAdminRequests);
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException 
	{
		HttpServletRequest httpServletRequest = (HttpServletRequest) request;
		HttpServletResponse httpServletResponse = (HttpServletResponse) response;
		//System.out.println(httpServletRequest.getServletPath());		
		if(SessionHelper.getLogedInUser(httpServletRequest) != null) {
			// As per discussion only admin and candidate roles are considered (Subject admin and call center roles are depricated)
			long roleId=SessionHelper.getLogedInUser(httpServletRequest).getFkRoleID();
			if(CollectionUtils.emptyIfNull(mapRoleId_PathList.get(roleId)).stream().anyMatch(s -> httpServletRequest.getServletPath().matches(s)))
			{
				chain.doFilter(request, response);
			} else {
				httpServletResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to access this page");
			}
		} else {
			httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + "/login/logoutMsg");
		}
	}

	@Override
	public void destroy() 
	{

	}

}
