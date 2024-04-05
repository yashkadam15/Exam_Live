package mkcl.oesclient.common;

import java.net.HttpURLConnection;
import java.net.URL;

import javax.net.ssl.SSLException;
import javax.net.ssl.SSLHandshakeException;

import org.junit.Test;

public class CheckSSLURL {

	@Test
	public void test() {
	
			try {
				URL url = new URL("http://esbinternational.mkcl.org/BASEESB");
				HttpURLConnection connection = (HttpURLConnection)url.openConnection();
				connection.setRequestMethod("GET");
				connection.connect();

				int code = connection.getResponseCode();
				System.out.println("response code :: "+code);
			}catch (SSLException e) {
				e.printStackTrace();
			}catch (Exception e) {
				e.printStackTrace();
			}

	}

}
