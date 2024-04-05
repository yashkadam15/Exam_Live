/**
 * 
 */
package mkcl.oesclient.security;

import java.io.IOException;
import java.util.Arrays;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;

/**
 * @author priyankakondke
 *
 */
public class RequestParamValidatorFilter implements Filter {

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException 
	{
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		if("GET".equalsIgnoreCase(req.getMethod()))
		{
			Map<String, String[]> params = req.getParameterMap();
			
//			if (!params.isEmpty() && !params.entrySet().stream().anyMatch(entry -> Arrays.stream(entry.getValue()).anyMatch(value -> Jsoup.isValid(value, Whitelist.none())))) 
			if (!params.isEmpty() && !params.entrySet().stream().allMatch(entry -> Arrays.stream(entry.getValue()).allMatch(value -> Jsoup.isValid(value, Whitelist.none())))) 
			{
				res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Requested URL Has Some Malicious Parameters");
			} 
			else 
			{
				chain.doFilter(request, response);
			}
		}
		else 
		{
			chain.doFilter(new EscapedParamsRequestWrapper(req), response);
		}
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub

	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

}
