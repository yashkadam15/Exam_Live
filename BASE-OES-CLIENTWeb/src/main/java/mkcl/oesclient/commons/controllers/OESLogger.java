package mkcl.oesclient.commons.controllers;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Date;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import mkcl.baseoesclient.model.LogType;
import mkcl.baseoesclient.model.LoginType;
import mkcl.baseoesclient.model.OESExamLog;
import mkcl.baseoesclient.model.OESLog;
import mkcl.oesclient.commons.services.OESLogServices;
import mkcl.oesclient.model.VenueUser;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public final class OESLogger {

	private static final Logger LOGGER = LoggerFactory
			.getLogger(OESLogger.class);
	
	static OESLogServices oesLogServicesObj=new OESLogServices();
	private static String  serverAddress="";
	
	
	private OESLogger(){}
	
	
	/**
	 * Method to fetch the Current Machine IP Address
	 * @return String this returns host address
	 */
	private static String getCurrentMachineIPaddress()
	{
	
	try
	{
	// Get Current machine address	
	Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
	while (interfaces.hasMoreElements()){
	    NetworkInterface current = interfaces.nextElement();
	    //System.out.println(current);
	    if (!current.isUp() || current.isLoopback() || current.isVirtual()) continue;
	    Enumeration<InetAddress> addresses = current.getInetAddresses();
	    while (addresses.hasMoreElements()){
	        InetAddress current_addr = addresses.nextElement();
	        if (current_addr.isLoopbackAddress()) continue;
	        serverAddress=current_addr.getHostAddress().toString();
	        //System.out.println(current_addr.getHostAddress());
	        }

		}
	}
	catch(SocketException e)
	{
		e.printStackTrace();
	}
	return serverAddress;
}
	

	/**
	 * Method to log login and logout activity of user 
	 * @param venueUser
	 * @param examEventID
	 * @param logType
	 * @param loginType
	 * @param hostAddress
	 * @return boolean this returns true if the user is logged in 
	 */
	public static boolean logLoginActivity( VenueUser venueUser ,long  examEventID,LogType logType,LoginType loginType,String hostAddress)
	{
		OESLog oesLog=new OESLog();			
		Boolean isLogged=false;
		
	/*	if(hostAddress.isEmpty())
		{
			hostAddress=getCurrentMachineIPaddress();
		}*/
		oesLog.setUserName(venueUser.getUserName());
		oesLog.setFkExamVenueId(venueUser.getFkExamVenueID());
		oesLog.setFkExamEventId(examEventID);
		oesLog.setLogDateTimeStamp(new Date());
		oesLog.setLogType(logType);
		oesLog.setUserIPAddress(hostAddress);			
		
		isLogged=oesLogServicesObj.logUserLoginOrLogoutTime(oesLog);			
		return isLogged;
	}
	
	/**
	 * Method to log Exam activities of user(test start/end/itemRendering/instructionRendering)
	 * @return boolean this returns true if the user is logged in
	 * 
	 */
	public static boolean logExamActivity( VenueUser venueUser ,long  examEventID,LogType logType,LoginType loginType,long candidateExamID,long itemID,String hostAddress)
	{
	OESExamLog oesExamLog=new OESExamLog();		
	Boolean isLogged=false;
/*		if(hostAddress.isEmpty())
		{
			hostAddress=getCurrentMachineIPaddress();
		}
*/		//CandidateExam candidateExam =new CandidateExamServiceImpl().getCandidateExamByEventIDandPaperID(candidateID,examEventID, paperID);
	
	oesExamLog.setUserName(venueUser.getUserName());
	oesExamLog.setFkExamVenueId(venueUser.getFkExamVenueID());
	oesExamLog.setFkExamEventId(examEventID);
	oesExamLog.setLogDateTimeStamp(new Date());
	oesExamLog.setLogType(logType);
	oesExamLog.setUserIPAddress(hostAddress);		
	oesExamLog.setFkCandidateExamId(candidateExamID);
	oesExamLog.setFkItemId(itemID);

	isLogged=oesLogServicesObj.saveExamLog(oesExamLog);
	
	
	return isLogged;
	}
	
	/**
	 * Method to fetch Remote Client IP Address 
	 * @param request
	 * @return String this returns the host address
	 */
	
	public static String getHostAddress(HttpServletRequest request){
		 String hostAddress = null;
		try {
			hostAddress = request.getHeader("X-FORWARDED-FOR");  
			  if (hostAddress == null) {  
				   hostAddress = request.getRemoteAddr();  
			   }
		} catch (Exception e) {
			LOGGER.error("Exception generated in getHostAddress of OESLogger",e);
			}
			return hostAddress;
		}
		
}
