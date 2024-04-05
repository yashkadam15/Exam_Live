package mkcl.oesclient.security;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;

public class CSRFStatelessInterceptor extends HandlerInterceptorAdapter 
{
	public boolean preHandle(final HttpServletRequest httpRequest,final HttpServletResponse httpResponse, Object handler) throws Exception 
	{
		List<VenueUser> users = SessionHelper.getLogedInUsers(httpRequest);
		
		if(users == null || users.isEmpty() || users.get(0).getUserName() == null || users.get(0).getUserName().isEmpty())
		{
			return true;
		}
		
		final CSRFStatus status = computeCSRFStatus(httpRequest);
		
		switch (status) 
		{
		case COOKIE_NOT_PRESENT:
		case COOKIE_TOKEN_MISMATCH:
		case UNABLE_TO_VALIDATE_TOKEN:
			httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, status.getStatusMessage());
			return false;
		case COOKIE_TOKEN_MATCH:
			final List<Cookie> oldCookies = Arrays.stream(httpRequest.getCookies()).filter(a -> a.getName().equals(CSRFResponseBuilder.csrfCookieName)).collect(Collectors.toList());
			oldCookies.forEach(c -> {
				c.setPath("/");
				c.setMaxAge(0);
				c.setValue(null);
				c.setHttpOnly(true);
				httpResponse.addCookie(c);
			});
			CSRFResponseBuilder.createCSRFCookie(httpRequest, httpResponse);
			return true;
		default:
			httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Unknown CSRF token status");
			return false;
		}
	}
	
	private CSRFStatus computeCSRFStatus(final HttpServletRequest httpRequest) 
	{
		if (httpRequest.getCookies() == null ||  httpRequest.getCookies().length == 0) 
		{
			return CSRFStatus.COOKIE_NOT_PRESENT;
        }
		
		final List<Cookie> cookies = Arrays.stream(httpRequest.getCookies()).filter(a -> a.getName().equals(CSRFResponseBuilder.csrfCookieName)).collect(Collectors.toList());

		if (cookies.isEmpty()) 
		{
			return CSRFStatus.COOKIE_NOT_PRESENT;
		}
		
		try 
		{
			if (AESHelperExtended.decryptAsRandom(URLDecoder.decode(cookies.get(0).getValue(), "UTF-8"), EncryptionHelper.encryptDecryptKey).equals(SessionHelper.getLogedInUsers(httpRequest).get(0).getUserName()))
			{
				return CSRFStatus.COOKIE_TOKEN_MATCH;
			}
		} 
		catch (Exception e) 
		{
			return CSRFStatus.UNABLE_TO_VALIDATE_TOKEN;
		}

		return CSRFStatus.COOKIE_TOKEN_MISMATCH;
	}
}
