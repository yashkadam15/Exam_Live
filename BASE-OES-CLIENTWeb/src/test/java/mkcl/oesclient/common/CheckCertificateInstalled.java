/**
 * 
 */
package mkcl.oesclient.common;

import java.net.InetAddress;
import java.util.Arrays;

import org.junit.Test;

/**
 * @author virajd
 *
 */
public class CheckCertificateInstalled {

	@Test
	public void test() {
		
		try {
			InetAddress address = InetAddress.getLocalHost();
		    byte[] byteAddress = address.getAddress();
		    System.out.println(Arrays.toString(byteAddress));
		    System.out.println(address.getHostAddress());
		    System.out.println("Testing");
		} catch (Exception e) {
			System.out.println("Exception:"+e);
		}
	}

}
