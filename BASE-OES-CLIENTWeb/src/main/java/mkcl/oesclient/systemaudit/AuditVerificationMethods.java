package mkcl.oesclient.systemaudit;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import mkcl.oesclient.commons.services.DBCheckImpl;
import mkcl.oesclient.commons.services.IOESAppInfoServices;
import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.services.OESAppInfoServicesImpl;
import mkcl.oes.commons.EncryptionHelper;
import mkcl.oesclient.commons.utilities.FileCheckSumhelper;
import mkcl.oesclient.commons.utilities.MKCLUtility;
import mkcl.oesclient.commons.utilities.SSLCertificateHelper;
import mkcl.os.security.AESHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class AuditVerificationMethods {

	private static final Logger LOGGER = LoggerFactory.getLogger(AuditVerificationMethods.class);
	private static List<String[]> dataBrowser;

	static {
		// 1.subString 2.identity 3.versionSearch 4.version supported
		String[] db1 = { "Chrome", "Chrome", "", "20" };
		String[] db2 = { "MSIE", "Explorer", "MSIE", "9" };
		String[] db3 = { "Firefox", "Firefox", "", "22" };
		String[] db4 = { "Trident", "Explorer", "rv", "9" };

		// OES Secure Browser
		String[] db5 = { "MOSB", "MOSB", "", "1" };

		dataBrowser = new ArrayList<String[]>();
		dataBrowser.add(db1);
		dataBrowser.add(db2);
		dataBrowser.add(db3);
		dataBrowser.add(db4);
		dataBrowser.add(db5); //Array INDEX = 4 for secured Browser
	}

	private AuditVerificationMethods() {
	}

	public static boolean verifyMD5(HttpServletRequest request) {
		return FileCheckSumhelper.isTempered(request.getSession().getServletContext().getRealPath(""));
	}

	public static boolean verifyApplicationVersion() {
		try {
			Properties propertiesSys = new Properties();
			propertiesSys.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("sys.properties"));
			String webVersion = propertiesSys.getProperty("WEBVERSION");
			Double dWebVersion = 0.0;
			if (webVersion != null && !webVersion.isEmpty()) {
				dWebVersion = Double.valueOf(AESHelper.decrypt(webVersion, EncryptionHelper.encryptDecryptKey));
			}
			IOESAppInfoServices objOesAppInfoServices = new OESAppInfoServicesImpl();
			return objOesAppInfoServices.compareWebVesion(dWebVersion);
		} catch (Exception e) {
			LOGGER.error("Exception in verifyApplicationVersion :", e);
		}
		return false;
	}

	public static boolean verifyDbForAllTablesCreated() {
		IOESAppInfoServices objOesAppInfoServices = new OESAppInfoServicesImpl();
		return objOesAppInfoServices.verifyDbForAllTablesCreated();
	}

	public static BrowserInfo verifySecureBrowser(String userAgent) {
		String browserName = null;
		String version = null;
		double browserVersion = -1;
		double compatibleBaseVersion = 0.0;
		boolean browserfound = false;
		String versionSearchString = null;
		try {
			if (userAgent != null && !userAgent.isEmpty()) {
				versionSearchString = dataBrowser.get(4)[0];
				
				if(userAgent.contains(versionSearchString))
				{
					// get browser version
					version = userAgent.substring(userAgent.indexOf(versionSearchString) + versionSearchString.length() + 1);
					
					// get version number from version search string
					version =	version.split(" ")[0];					
					
					// split version if '.' is present
					if(version.contains(".")){
						version= version.split("\\.")[0];
					}

					browserVersion = Double.parseDouble(version);
					// get compatible browser version
					compatibleBaseVersion = Double.parseDouble(dataBrowser.get(4)[3]);
					// set browser name
					browserName = dataBrowser.get(4)[1];
					browserfound = true;
				}
			}

			// if secured browser not found
			// check for other browser info
			if (!browserfound) {
				BrowserInfo browserInfo = verifyCompatibleBrowser(userAgent);
				browserName = browserInfo.getBrowserName();
				version = browserInfo.getBrowserVersion();
			}

		} catch (Exception e) {
			LOGGER.error("Exception in verifySecureBrowser :", e);
			// skip exception
		}

		BrowserInfo browserInfo = new BrowserInfo();
		if (browserVersion >= compatibleBaseVersion) {
			browserInfo.setCompatibilityStatus(true);
		} else {
			browserInfo.setCompatibilityStatus(false);
		}
		browserInfo.setBrowserName(browserName);
		browserInfo.setBrowserVersion(version);
		return browserInfo;
	}

	public static String getCompatibleSecuredBrowserUserAgent(){
		//Secured Browser String At INDEX = 4
		String[] data = dataBrowser.get(4);
		//create string BorwserName=BorwserVersion
		return data[0]+"="+data[3];
	}

	public static BrowserInfo verifyCompatibleBrowser(String userAgent) {
		String browserName = null;
		String version = null;
		int browserVersion = 0;
		int compatibleBaseVersion = 0;
		try {
			String versionSearchString = null;
			if (userAgent != null && !userAgent.isEmpty()) {
				for (String[] data : dataBrowser) {
					// find browser name
					if (userAgent.indexOf(data[0]) != -1) {
						// get version search string
						if (data[2] == "") {
							versionSearchString = data[1];
						} else {
							versionSearchString = data[2];
						}
						// get compatible base version
						compatibleBaseVersion = Integer.parseInt(data[3]);
						// get browser name
						browserName = data[1];
						break;
					}
				}
				if (versionSearchString != null && !versionSearchString.isEmpty()) {
					int index = userAgent.indexOf(versionSearchString);
					if (index != -1) {
						version = userAgent.substring(index + versionSearchString.length() + 1);

						// get version number from version search string
						String[] versionStringArr =	version.split(" ");
						version = versionStringArr[0];
						// split version if '.' is present
						if(version.contains(".")){
							String[] versionArr = version.split("\\.");
							version = versionArr[0];
						}


						/*	// get first two numbers
						if(version.length() >= 2){
							version = version.substring(0, 2);
						}
						// remove . in single digit if present
						version = version.replace(".", "");*/
						browserVersion = Integer.parseInt(version);
					}
				}
			}
		} catch (Exception e) {
			LOGGER.error("Exception in verifyCompatibleBrowser :", e);
			// skip exception
			compatibleBaseVersion = 0;
			browserVersion = 0;
		}

		BrowserInfo browserInfo = new BrowserInfo();
		if (browserVersion >= compatibleBaseVersion) {
			browserInfo.setCompatibilityStatus(true);
		} else {
			browserInfo.setCompatibilityStatus(false);
		}
		browserInfo.setBrowserName(browserName);
		browserInfo.setBrowserVersion(version);
		return browserInfo;
	}

	public static boolean verifyTimeZone() {
		boolean status = false;
		Properties properties = null;
		try {
			properties = MKCLUtility.loadMKCLPropertiesFile();
			if (properties != null && !properties.isEmpty()) {
				String reqTimeZones = properties.getProperty("systemTimeZone");
				if(reqTimeZones != null && !reqTimeZones.isEmpty()){
					String dbTimeZone = new OESAppInfoServicesImpl().getTimeZoneFromDb();
					if(dbTimeZone != null && !dbTimeZone.isEmpty()){
						for(String zone : reqTimeZones.split("\\|")){
							if(zone.trim().equalsIgnoreCase(dbTimeZone)){
								status=true;
								break;
							}
						}
					}
				}
			}
		} catch (Exception e) {
			LOGGER.error("Exception in verifyTimeZone :", e);
			status = false;
		}finally{
			properties=null;
		}
		return status;
	}
}
