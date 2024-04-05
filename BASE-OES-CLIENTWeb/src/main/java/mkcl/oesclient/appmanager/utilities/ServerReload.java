/**
 * 
 */
package mkcl.oesclient.appmanager.utilities;

import java.lang.management.ManagementFactory;
import java.util.Hashtable;

import javax.management.MBeanServerConnection;
import javax.management.ObjectName;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



/**
 * @author rakeshb
 *
 */
public final class ServerReload {
	private static final Logger LOGGER = LoggerFactory.getLogger(ServerReload.class);
	
	public static void  shutdownApp(HttpServletRequest request) {
	    try {
	    	 String serviceName = "Catalina"; // @see server.xml
		    /* String hostName = "localhost"; // @see server.xml
		     String contextName = "OES-CLIENTWeb"; // the name of your application in the URL
		     */	
	    	String hostName = request.getServerName();
	    	String contextName =  request.getSession().getServletContext().getContextPath();
			if(contextName != null && contextName != "") {
				contextName = contextName.substring(1);
			}

	        Hashtable<String, String> keys = new Hashtable<String, String>();
	        keys.put("j2eeType", "WebModule");
	        keys.put("name", "//" + hostName + "/" + contextName);
	        keys.put("J2EEApplication", "none");
	        keys.put("J2EEServer", "none");

	        MBeanServerConnection mbeanServer = ManagementFactory.getPlatformMBeanServer();
	        ObjectName appObject = ObjectName.getInstance(serviceName, keys);
	        	       
	        mbeanServer.invoke(appObject, "reload", null, null);
	       // mbeanServer.invoke(appObject, "stop", null, null);
	        //mbeanServer.invoke(appObject, "start", null, null);
	       
	    } catch (Exception e) {
	    	LOGGER.error("Exception occured in shutdownApp... ",e);
	    }
	   
	}
}
