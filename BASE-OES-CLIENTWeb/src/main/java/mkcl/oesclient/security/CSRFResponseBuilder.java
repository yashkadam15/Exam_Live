package mkcl.oesclient.security;

import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.model.VenueUser;
import mkcl.oesclient.utilities.SessionHelper;

public final class CSRFResponseBuilder 
{
	protected static final String csrfCookieName = "oescxft";
	public static void createCSRFCookie(final HttpServletRequest request, final HttpServletResponse httpResponse) throws Exception
	{
		List<VenueUser> users = SessionHelper.getLogedInUsers(request);
		if(users != null && !users.isEmpty())
		{
			
			httpResponse.addHeader("Set-Cookie", String.format("oescxft=%s; Path=/;%s HttpOnly; SameSite=Lax;", URLEncoder.encode(AESHelperExtended.encryptAsRandom(users.get(0).getUserName(), EncryptionHelper.encryptDecryptKey), "UTF-8"), request.getServletContext().getSessionCookieConfig().isSecure() ? "Secure;" : ""));
			
//			final Cookie c = new Cookie(csrfCookieName,	URLEncoder.encode(AESHelperExtended.encryptAsRandom(users.get(0).getUserName(), EncryptionHelper.encryptDecryptKey), "UTF-8"));
//			c.setHttpOnly(true);
//			c.setPath("/");
//			httpResponse.addCookie(c);
		}
	}
}
