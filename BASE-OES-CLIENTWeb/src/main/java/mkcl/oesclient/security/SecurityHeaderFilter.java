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

public class SecurityHeaderFilter implements Filter {
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		HttpServletRequest httpServletRequest = (HttpServletRequest) request;
		HttpServletResponse securedRes = (HttpServletResponse) response;
		
		

		if(!httpServletRequest.getServletPath().contains("/resources/") &&
			!httpServletRequest.getServletPath().contains("/examClient/") &&
			!httpServletRequest.getServletPath().contains("/Logs/") &&
			!httpServletRequest.getServletPath().contains("/webjars/")) {
			securedRes.addHeader("Cache-Control", "no-cache, no-store, max-age=0, must-revalidate");
			securedRes.addHeader("Pragma", "no-cache");
			securedRes.addHeader("Expires", "0");
		}

		securedRes.addHeader("X-Content-Type-Options", "nosniff");
		securedRes.addHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
		// securedRes.addHeader("X-Frame-Options", "SAMEORIGIN");
		securedRes.addHeader("X-XSS-Protection", "1; mode=block");
		securedRes.addHeader("Feature-Policy", "interest-cohort 'self'");
		securedRes.addHeader("Referrer-Policy", "strict-origin-when-cross-origin");
		securedRes.addHeader("Content-Security-Policy", 
			"default-src 'self'; " + 
			// "frame-src 'self'; " +
			"object-src 'self'; " +
			"script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://www.wiris.net https://cdn.skypack.dev/; " +
			"child-src 'self' prq:; " +
			"form-action 'self'; " +
			// "frame-ancestors 'self'; " +
			"style-src 'self' 'unsafe-inline'; " +
			"img-src 'self' 'unsafe-inline' data:; " +
			"connect-src 'self' https:;" +
			"font-src https://fonts.gstatic.com https://themes.googleusercontent.com;"
		);

		chain.doFilter(request, securedRes);
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
	}
}
