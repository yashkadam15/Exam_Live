package mkcl.oesclient.sync.controllers;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.UnknownHostException;
import javax.net.ssl.SSLException;

import mkcl.oesclient.commons.utilities.MKCLUtility;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author reenak/YOGRAJS
 * 01 DEC 2014
 */
public class ServerConnectionCheckHelper 
{
    
       private static final Logger LOGGER = LoggerFactory.getLogger(ServerConnectionCheckHelper.class);
        
       /*
        * Check connection to ESB server and OES Server
        */
    /**
     * Method to check connection to ESB
     * @return int this returns the Certificate Install Status
     * @throws IOException
     */
	public int checkConnectionToESB() throws IOException {          
        int oesCertStatus=0;        
	int esbCertStatus=0;
	int certInstallStatus=0;         
       	
		oesCertStatus=isSSLCertficateInstalled(MKCLUtility.loadConnectionPropertiesFile().getProperty("OESSERVERURL"));
		esbCertStatus=isSSLCertficateInstalled(MKCLUtility.loadConnectionPropertiesFile().getProperty("ESBURL"));
		
		if (oesCertStatus==0 && esbCertStatus==0) {
			certInstallStatus=0;
		}else if (oesCertStatus==2 || esbCertStatus==2) {
			certInstallStatus=2;
		}else if (oesCertStatus==1 || esbCertStatus==1) {
			certInstallStatus=1;
		}else if (oesCertStatus==3 || esbCertStatus==3) {
			certInstallStatus=3;
		}
		return certInstallStatus;
        
        }       

     /**
	 * Method to check if the SSL Certficate is installed.
	 *
	 * @param URL the url(esb/oes-server)
	 * 
	 * @return int this returns 
	 * 0 when Certificate installed
	 * 1 when SSLException
	 * 2 when UnknownHostException
	 * 3 when any other exception
	 */
        private int isSSLCertficateInstalled(String URL)
        {
			URL url =null;
	        InputStream is=null;
	        StringWriter writer=null;
	                
			try {
				url = new URL(URL);
				HttpURLConnection connection = (HttpURLConnection)url.openConnection();
				connection.setRequestMethod("GET");
				connection.connect(); 
	            if(URL.toLowerCase().contains("esb"))
	            {
	                is=connection.getInputStream();
	                writer = new StringWriter();
	                IOUtils.copy(is, writer,"utf8");
	                String value = writer.toString();
	                if(value.contains("true"))
	                {
	                    return 0;
	                }
	                else
	                {
	                    return 1;
	                }
	            }
	                        
	            /*if(URL.contains("NEWESB"))
	            {
	            HttpGet postRequest = new HttpGet(URL);
	            HttpResponse response = MKCLHttpClient.sendRequest(postRequest);
	            // Reading the JSON response
	            HttpEntity httpEntity = response.getEntity();
	            InputStream inputStream = httpEntity.getContent();
	            BufferedReader reader = new BufferedReader(new InputStreamReader(
	                    inputStream));
	            StringBuilder sb = new StringBuilder();
	            String line = null;
	            while ((line = reader.readLine()) != null) {
	                sb.append(line + "\n");
	            }
	            System.out.println(sb.toString());
	            inputStream.close();
	            }*/
	                        
			}catch (SSLException e) {			
				LOGGER.error("Certificate for "+ url + " not found",e);
				return 1;
			}catch (UnknownHostException e) {			
				LOGGER.error("Internet connection not found for "+ url,e);
				return 2;
			}catch (Exception e) {			
				LOGGER.error("Error occured to find Certificate for "+ url,e);
				return 3;
			}
	                finally{
	                    try
	                    {
	                        if(writer!=null)
	                        {
	                            writer.close();
	                        }
	                        if(is!=null)
	                        {
	                            is.close();
	                        }
	                    }
	                    catch(Exception e)
	                    {
	                        LOGGER.error("Error in isSSLCertficateInstalled while releasing objects  "+ e);
	                    }
	                }
			return 0;
	}
        
}
