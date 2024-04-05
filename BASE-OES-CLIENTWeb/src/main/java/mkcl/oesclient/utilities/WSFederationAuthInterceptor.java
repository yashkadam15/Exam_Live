package mkcl.oesclient.utilities;

import java.util.Arrays;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import mkcl.baseoesclient.model.LoginType;
import mkcl.oesclient.commons.utilities.MKCLUtility;

public class WSFederationAuthInterceptor extends HandlerInterceptorAdapter 
{
	private static final Logger LOGGER = LoggerFactory.getLogger(WSFederationAuthInterceptor.class);
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
	{
		try 
		{
			Properties prop=MKCLUtility.loadMKCLPropertiesFile();
			if(prop!=null && Boolean.parseBoolean(prop.getProperty("enableWsFederationAuth", "false")))
			{
				if(request.getRequestURI().contains("/login/eventSelection"))
				{
					response.sendRedirect(request.getContextPath()+"/wsfAuth/login");
					return false;
				}
				else if(request.getRequestURI().contains("/login/logout"))
				{
					if((SessionHelper.getLoginStatus(request) && SessionHelper.getLoginType(request) == LoginType.Admin) || (!Arrays.stream(request.getCookies()).anyMatch(c -> c.getName().equals("referer"))))
					{
						return true;
					}
					
					if(request.getQueryString() != null && !request.getQueryString().isEmpty())
					{
						response.sendRedirect(request.getContextPath()+"/wsfAuth/logout?"+request.getQueryString());
					}
					else
					{
						response.sendRedirect(request.getContextPath()+"/wsfAuth/logout");
					}
					return false;
				}
			}
		} 
		catch (Exception e) 
		{
			LOGGER.error("Exception generated in preHandle of WSFederationAuthInterceptor",e);
			return true;
		}
		return true;
	}
}
