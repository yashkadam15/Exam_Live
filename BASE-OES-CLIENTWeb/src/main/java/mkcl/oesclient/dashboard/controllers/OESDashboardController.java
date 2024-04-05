package mkcl.oesclient.dashboard.controllers;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.databind.ObjectMapper;

import mkcl.oesclient.dashboard.services.LiveDashboardServicesImpl;
import mkcl.oesclient.dashboard.services.OtherDashboardServicesImpl;
import mkcl.oesdashboard.model.LiveDashboard;
import mkcl.oesdashboard.model.OtherDashboards;
import mkcl.os.security.AESHelper;


@Controller
@RequestMapping("oesDashboard")
public class OESDashboardController {

	private static final Logger LOGGER = LoggerFactory.getLogger(OESDashboardController.class);
	private static final String AESDECRYPTKEY = "MKCLSecurity$#@!";
	
	/**
	 * Post method for Live Dashboard Data
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getLiveDashboardData" }, method = RequestMethod.POST)
	public void getLiveDashboardData(HttpServletRequest request, HttpServletResponse response) {
	
		try {
			LiveDashboardServicesImpl liveDashboardServicesImpl= new LiveDashboardServicesImpl();			
			
			
			String compressedJsonStr=null;
			List<LiveDashboard> liveDashboardList= liveDashboardServicesImpl.getLiveDashboardData();
			if(liveDashboardList!=null)
			{				
				// get viewModel Compressed JSON String
				 compressedJsonStr = getLiveDashboardJsonStrCompressed(liveDashboardList, AESDECRYPTKEY);
			}				
			
			if (compressedJsonStr.length() > 2) {			
				response.getWriter().write(compressedJsonStr);
			}							
			
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getLiveDashboardData: " , ex);			
			
		}
		
	}
	
	/**
	 * Post method for Other Dashboard Data
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = { "getOtherDashboardData" }, method = RequestMethod.POST)
	public void getOtherDashboardData(HttpServletRequest request, HttpServletResponse response) {
		try {
			OtherDashboardServicesImpl otherDashboardServicesImpl= new OtherDashboardServicesImpl();			
			
			
			String compressedJsonStr=null;
			List<OtherDashboards> otherDashboardList= otherDashboardServicesImpl.getOtherDashboardData();
			if(otherDashboardList!=null)
			{				
				// get viewModel Compressed JSON String
				 compressedJsonStr = getOtherDashboardsJsonStrCompressed(otherDashboardList, AESDECRYPTKEY);
			}
					
			
			if (compressedJsonStr.length() > 2) {			
				response.getWriter().write(compressedJsonStr);
			}							
			
		} catch (Exception ex) {
			LOGGER.error("Exception occured in getOtherDashboardData: " , ex);			
			
		}
	}
	
	/**
	 * Method to fetch Live Dashboard JSON String Compressed
	 * @param liveDashboardList
	 * @param key
	 * @return String this returns the path of a view
	 */
	public String getLiveDashboardJsonStrCompressed(List<LiveDashboard> liveDashboardList ,String key) {
		String jsonStrCopmpressed = "";
		try {
			if ( liveDashboardList != null) {
				ObjectMapper mapper = new ObjectMapper();
				jsonStrCopmpressed = AESHelper.encryptAsCompress(mapper.writeValueAsString(liveDashboardList),key);
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while Parsing getLiveDashboardJsonStrCompressed: " , e);
		}
		return jsonStrCopmpressed;
	}
	
	/**
	 * Method to fetch Other Dashboards JSON String Compressed
	 * @param otherDashboardList
	 * @param key
	 * @return String this returns the path of a view
	 */
	public String getOtherDashboardsJsonStrCompressed(List<OtherDashboards> otherDashboardList ,String key) {
		String jsonStrCopmpressed = "";
		try {
			if ( otherDashboardList != null) {
				ObjectMapper mapper = new ObjectMapper();
				jsonStrCopmpressed = AESHelper.encryptAsCompress(mapper.writeValueAsString(otherDashboardList),key);
			}
		} catch (Exception e) {
			LOGGER.error("Exception Occured while Parsing getOtherDashboardsJsonStrCompressed: " , e);
		}
		return jsonStrCopmpressed;
	}
}
