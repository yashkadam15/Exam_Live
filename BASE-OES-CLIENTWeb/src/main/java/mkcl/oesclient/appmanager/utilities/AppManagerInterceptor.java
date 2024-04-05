/**
 * 
 */
package mkcl.oesclient.appmanager.utilities;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import mkcl.oesclient.commons.utilities.MessageConstants;
import mkcl.oesclient.utilities.SessionHelper;

/**
 * @author rakeshb
 *
 */
public class AppManagerInterceptor extends HandlerInterceptorAdapter {
	private static final Logger LOGGER = LoggerFactory.getLogger(AppManagerInterceptor.class);
	
	@Override
	public boolean preHandle(HttpServletRequest request,HttpServletResponse response, Object handler) throws Exception {
				
		try {
			if(!SessionHelper.getLoginStatus(request))
			{	
				response.sendRedirect(request.getContextPath()+"/appmanager/login?messageid="+MessageConstants.LOGIN_FIRST);
				return false;		
			}
		} catch (Exception e) {
			LOGGER.error("Exception in AppManagerInterceptor..",e);	
			return false;
		}
		return true;
	}

}
