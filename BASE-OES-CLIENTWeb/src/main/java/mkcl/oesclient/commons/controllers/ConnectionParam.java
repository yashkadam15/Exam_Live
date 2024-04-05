package mkcl.oesclient.commons.controllers;

import java.io.OutputStream;
import java.net.InetAddress;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oesclient.commons.services.OESAppInfoServicesImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/*
 * Author 			: Sonam Mohite, Viraj
 * Purpose 			: Read connection properties from property file
 * Date of creation : 06 Aug 2013
 */
@Controller
@RequestMapping("connectionParam")
public class ConnectionParam {

	private static final Logger LOGGER = LoggerFactory.getLogger(ConnectionParam.class);


	/**
	 * Post method for Connection
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "/PostCon" }, method = RequestMethod.POST)
	public void getconnection(HttpServletRequest request, HttpServletResponse response) {

		/**
		 * 
		 * code commented by amoghs;new added to snd properties file as xml.
		 * 
		 */
/*		Properties property=new Properties();

		try {
			property.load(ConnectionParam.class.getClassLoader().getResourceAsStream("connection.properties"));
		} catch (IOException e) {
			LOGGER.error(e.getMessage());
		}

		// get ip address of current machine
		String serverIPAddress="";
        InetAddress ip;
        try {
            ip = InetAddress.getLocalHost();
            serverIPAddress=ip.getHostAddress();

        } catch (UnknownHostException e) {
        	LOGGER.error(e.getMessage());
        }
		
		
		//reading proeprty

		String driver = property.getProperty("JDBC_DRIVER");
		String dbURL = property.getProperty("DB_URL");
		String username = property.getProperty("USERNAME");
		String minpoolsize = property.getProperty("MINPOOLSIZE");
		String aquireincrement = property.getProperty("ACQUIREINCREMENT");
		String maxpoolsize = property.getProperty("MAXPOOLSIZE");
		String esbURL = property.getProperty("ESBURL");
		String oesServerURL = property.getProperty("OESSERVERURL");
				
		String serverpath = request.getSession().getServletContext().getRealPath("");
		String physicalpath = serverpath;		
		serverpath=serverpath+"\\WEB-INF\\classes\\text.txt";
		
		StringBuffer strMain=new StringBuffer();
		strMain.append(driver);
		strMain.append(",");
		strMain.append(dbURL);
		strMain.append(",");
		strMain.append(username);
		strMain.append(",");
		strMain.append(serverpath);
		strMain.append(",");
		strMain.append(physicalpath);
		strMain.append(",");
		strMain.append(minpoolsize);
		strMain.append(",");
		strMain.append(aquireincrement);
		strMain.append(",");
		strMain.append(maxpoolsize);
		strMain.append(",");
		strMain.append(esbURL);
		strMain.append(",");
		strMain.append(oesServerURL);
		strMain.append(",");
		strMain.append(serverIPAddress);
		
		return strMain.toString();*/
		OESAppInfoServicesImpl appInfoServicesImpl=new OESAppInfoServicesImpl();
		Properties property=new Properties();
		try {
			//Added By Sonam
			String venueCode=appInfoServicesImpl.getExamVenueCode();
			//
			String venueCodeURL=request.getParameter("venueCode");
			
			
			property.load(ConnectionParam.class.getClassLoader().getResourceAsStream("connection.properties"));			
		
			String serverpath = request.getSession().getServletContext().getRealPath("");
			String physicalpath = serverpath;		
			serverpath=serverpath+"\\WEB-INF\\classes\\text.txt";
			
			String serverIPAddress="";
	        InetAddress ip;	       
            ip = InetAddress.getLocalHost();
            serverIPAddress=ip.getHostAddress();
            
            String supervisorPassword;
			supervisorPassword=appInfoServicesImpl.getSupervisorPassword(venueCodeURL);
			if(supervisorPassword == null)
			{
				supervisorPassword="";
			}
			
	        
	        OutputStream outs = response.getOutputStream();
			property.put("*textFilePath", serverpath);
			property.put("*serverIP", serverIPAddress);
			property.put("PHYSICALPATH", physicalpath);
			property.put("*venueCode", venueCode);
			property.put("*supervisorPassword", supervisorPassword);
			property.storeToXML(outs, null, "UTF-8");			
			outs.close();
			
		} catch (Exception e) {
			LOGGER.error("Error in connectionParam",e);
		}
	}




}

