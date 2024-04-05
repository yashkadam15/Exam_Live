package mkcl.oesclient.security;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.os.localdal.model.DBPoolDestroyer;

public class DBandMasterRecordsCheckerFilter implements Filter 
{
	private FilterConfig filterConfig;
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException 
	{
		// TODO Auto-generated method stub
		this.filterConfig = filterConfig;
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException 
	{
		boolean VenueNOTRegistered;
		boolean DBNOTExists;
		
		HttpServletRequest httpServletRequest = (HttpServletRequest) request;
		HttpServletResponse httpServletResponse = (HttpServletResponse) response;
		if(httpServletRequest.getRequestURI().contains("/resources/") || httpServletRequest.getRequestURI().contains("/Logs/") || httpServletRequest.getRequestURI().contains("/activateVenue/") || httpServletRequest.getRequestURI().contains("/SyncApi/"))
		{
			chain.doFilter(request, response);
			return;
		}
		
		VenueNOTRegistered = Boolean.parseBoolean(filterConfig.getServletContext().getAttribute(DBPoolDestroyer.Attr_VenueNOTRegistered) == null ? "false" :filterConfig.getServletContext().getAttribute(DBPoolDestroyer.Attr_VenueNOTRegistered).toString());
		DBNOTExists = Boolean.parseBoolean(filterConfig.getServletContext().getAttribute(DBPoolDestroyer.Attr_DBNOTExists) == null ? "false" : filterConfig.getServletContext().getAttribute(DBPoolDestroyer.Attr_DBNOTExists).toString());
		
		if(!VenueNOTRegistered && !DBNOTExists)
		{
			chain.doFilter(request, response);
			return;
		}
		
		if(DBNOTExists)
		{
			httpServletResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Unable to connect to database.");
			return;
		}
		if(VenueNOTRegistered)
		{
			httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + "/activateVenue/venueRegistration");
			return;
		}
		chain.doFilter(request, response);
	}

	@Override
	public void destroy() 
	{
		// TODO Auto-generated method stub
		
	}

}
