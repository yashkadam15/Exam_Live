package mkcl.oesclient.common;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.junit.Test;
import org.slf4j.LoggerFactory;

public class TestPartnerApiController {

	@Test
	public  void testsyncEventData() {
		Map<String , Object> requestparams=new HashMap<String, Object>();
		requestparams.put("pecids", "1,2");		
		String result = makeRequest("http://10.2.1.71:8080/OES-CLIENTWeb/OESApi/syncEventData",requestparams,"POST");
		System.out.println("Result :: ");
		System.out.println(result);
		LoggerFactory.getLogger(TestPartnerApiController.class).error("Result 2");
		LoggerFactory.getLogger(TestPartnerApiController.class).error(result);
		
	}
	
	
	
	
	private static String makeRequest(String urlString,Map<String , Object> requestparams,String requestMethod){
		String result = null;
		try {
			URL url = new URL(urlString);
			HttpURLConnection httpCon = (HttpURLConnection) url.openConnection();

			StringBuilder postData = new StringBuilder();
			for (Map.Entry<String,Object> param : requestparams.entrySet()) {
				if (postData.length() != 0) postData.append('&');
				postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
				postData.append('=');
				postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
			}
			byte[] postDataBytes = postData.toString().getBytes("UTF-8");

			httpCon.setRequestMethod(requestMethod);
			httpCon.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			httpCon.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
			httpCon.setDoOutput(true);
			httpCon.getOutputStream().write(postDataBytes);
			OutputStreamWriter out = new OutputStreamWriter(httpCon.getOutputStream());
			InputStream in = httpCon.getInputStream();
			String encoding = httpCon.getContentEncoding();
			encoding = encoding == null ? "UTF-8" : encoding;
			String body = IOUtils.toString(in, encoding);
			System.out.println(body);
			result = body;
			out.close();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		return result;
	}
	
	
}
