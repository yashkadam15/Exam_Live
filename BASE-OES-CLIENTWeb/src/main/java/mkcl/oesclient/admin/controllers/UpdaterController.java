/**
 * 
 */
package mkcl.oesclient.admin.controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.commons.services.ExamVenueActivationServicesImpl;
import mkcl.oespcs.model.ExamVenue;
import mkcl.os.localdal.model.ISqlOperationImpl;
import mkcl.os.localdal.model.LocalDALException;
import mkcl.os.security.AESHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author amitk
 * 
 */
@Controller
@RequestMapping("credentials")
public class UpdaterController {

	private static Logger LOGGER = LoggerFactory
			.getLogger(UpdaterController.class);

	/**
	 * Get method for Credentials
	 * @param request
	 * @return HashMap<String, Object> this returns the hashmap of credentials
	 */
	@ResponseBody
	@RequestMapping(value = { "/getcredentials" }, method = RequestMethod.GET)
	public HashMap<String, Object> getCredentails(HttpServletRequest request) {
		Map<String, String> mapOfDBinfo = null;
		HashMap<String, Object> credentialsMap = null;
		ExamVenueActivationServicesImpl examVenueServicesobj = null;
		String dbUsername = null;
		String dbPassword = null;
		String dbName = null;
		String dbPort = null;
		String encryptionKey = null;
		String centerCode = null;
		String clientDeployedPath = null;
		ExamVenue examVenueobj = null;
		String encCenterCode = null;
		// code to retrieve clientDeployedPath

		// add them to hash map
		try {
			LOGGER.info("updater getCredentails method of UpdaterController  started");
			clientDeployedPath = request.getSession().getServletContext()
					.getRealPath("");

			mapOfDBinfo = getMapOfDataBaseInfo(clientDeployedPath);
			if (mapOfDBinfo != null && !mapOfDBinfo.isEmpty()) {
				dbUsername = mapOfDBinfo.get("dbUsername");
				dbName = mapOfDBinfo.get("dbName");
				dbPort = mapOfDBinfo.get("dbport");
				dbPassword = mapOfDBinfo.get("dbPassword");
				encryptionKey = EncryptionHelper.encryptDecryptKey;
				// code to fetch venue code
				examVenueServicesobj = new ExamVenueActivationServicesImpl();
				examVenueobj = examVenueServicesobj.getExamVenue();
				centerCode = examVenueobj.getExamVenueCode();

				// code to encrypt all credentials and info
				String encDbUsername = AESHelper.encrypt(dbUsername,
						encryptionKey);

				String encDbPassword = AESHelper.encrypt(dbPassword,
						encryptionKey);

				String encDbName = AESHelper.encrypt(dbName, encryptionKey);
				if (centerCode != null) {
					encCenterCode = AESHelper
							.encrypt(centerCode, encryptionKey);
				}
				String encClientDeployedPath = AESHelper.encrypt(
						clientDeployedPath, encryptionKey);
				String encdbPort = AESHelper.encrypt(dbPort, encryptionKey);

				// code to add credentials into map as required by updater
				credentialsMap = new HashMap<String, Object>();
				credentialsMap.put("dbUsername", encDbUsername);
				credentialsMap.put("dbPassword", encDbPassword);
				credentialsMap.put("dbName", encDbName);
				credentialsMap.put("encryptionKey", encryptionKey);
				credentialsMap.put("clientDeployedPath", encClientDeployedPath);
				if (centerCode != null) {
					credentialsMap.put("centerCode", encCenterCode);
				}
				credentialsMap.put("dbPort", encdbPort);
				credentialsMap.put("testParameter", "testParameter");

				List<String> skipFileList = new ArrayList<String>();
				skipFileList.add("/resources/WebFiles");
				skipFileList.add("/resources/content");
				skipFileList.add("/examClient/resources");
				credentialsMap.put("skipFileList", skipFileList);
				examVenueobj = null;
				examVenueServicesobj = null;
				LOGGER.info("updater getCredentails method of UpdaterController  ends");
			}
			return credentialsMap;
		} catch (Exception e) {
			LOGGER.error(
					"Exception generated in getCredentails of UpdaterController",
					e);
			return null;
		}

	}

	/**
	 * Method to fetch the map of Database Information
	 * @param serverPath
	 * @return Map<String, String>  this returns the map of database information
	 */
	public Map<String, String> getMapOfDataBaseInfo(String serverPath) {

		Map<String, String> mapOfDBinfo = null;
		String propertyFilepath = null;
		Properties prop = null;
		InputStream input = null;
		InputStream inputDalPropFilePath = null;
		String dbUserName = null, db_name = null, db_port = null;
		String db_URL = null;
		String dbPassword = null;
		String encrpytedFilePath = null;
		ISqlOperationImpl dalServicesObj = null;
		String dalPropertyFilepath = null;

		try {
			propertyFilepath = serverPath + File.separator + "WEB-INF"
					+ File.separator + "classes" + File.separator
					+ "connection.properties";
			if (!new File(propertyFilepath).exists()) {
				return null;
			}
			input = new FileInputStream(propertyFilepath);
			prop = new Properties();
			prop.load(input);
			if (!prop.isEmpty()) {
				mapOfDBinfo = new HashMap<String, String>();
				dbUserName = prop.getProperty("USERNAME");
				db_URL = prop.getProperty("DB_URL");
				LOGGER.info("Data Base URL ::" + db_URL);
				if (db_URL.indexOf("?") != -1) {
					db_name = db_URL.substring(db_URL.lastIndexOf("/") + 1,
							db_URL.indexOf("?"));
				} else {
					db_name = db_URL.substring(db_URL.lastIndexOf("/") + 1);
				}

				// db port
				db_port = db_URL.substring(db_URL.lastIndexOf(":") + 1,
						db_URL.lastIndexOf("/"));

				LOGGER.info("Data Base Name :: " + db_name
						+ "\n Data Base Port ::" + db_port);
				prop = null;

			}

			// code to retrieve dbPassword
			prop = new Properties();
			dalPropertyFilepath = serverPath + File.separator + "WEB-INF"
					+ File.separator + "classes" + File.separator
					+ "dal.properties";
			if (!new File(dalPropertyFilepath).exists()) {
				return null;
			}
			inputDalPropFilePath = new FileInputStream(dalPropertyFilepath);
			prop.load(inputDalPropFilePath);
			if (!prop.isEmpty()) {

				encrpytedFilePath = serverPath + File.separator + "WEB-INF"
						+ File.separator + "classes"
						+ prop.getProperty("path.value");
				dalServicesObj = new ISqlOperationImpl();
				dbPassword = dalServicesObj.getPassword(encrpytedFilePath);
				prop = null;
			}
			mapOfDBinfo.put("dbUsername", dbUserName);
			mapOfDBinfo.put("dbName", db_name);
			mapOfDBinfo.put("dbport", db_port);
			mapOfDBinfo.put("dbPassword", dbPassword);
			return mapOfDBinfo;

		} catch (FileNotFoundException e) {
			LOGGER.error("Exception generated in getMapOfDataBaseInfo", e);
			return null;
		} catch (IOException e) {
			LOGGER.error("Exception generated in getMapOfDataBaseInfo", e);
			return null;
		} catch (LocalDALException e) {
			LOGGER.error("LocalDALException generated in getMapOfDataBaseInfo",
					e);
			return null;
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					LOGGER.error("Exception generated in getMapOfDataBaseInfo",
							e);
				}
			}

			if (inputDalPropFilePath != null) {
				try {
					inputDalPropFilePath.close();
				} catch (IOException e) {
					LOGGER.error("Exception generated in getMapOfDataBaseInfo",
							e);
				}
			}
		}

	}

}
