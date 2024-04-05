package mkcl.oesclient.utilities;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class md5Helper {

	private static final Logger LOGGER = LoggerFactory.getLogger(md5Helper.class);
	
	public String getsaltMD5(String input,String saltKey) throws Exception
	{
		String saltMd5 = null;
		String salt = input+saltKey;
		MessageDigest digest;
		try {
			digest = MessageDigest.getInstance("MD5");  
			digest.update(salt.getBytes(), 0, salt.length());  
			saltMd5 = new BigInteger(1, digest.digest()).toString(16);
			while (saltMd5.length() < 32) { 
				saltMd5 = "0" + saltMd5; 
            } 
			return saltMd5;
		} catch (Exception e) {
			throw e;
		}   
	}
	
	public static String getMd5(String input) throws Exception 
	{ 
        try 
        { 
            MessageDigest md = MessageDigest.getInstance("MD5"); 
            byte[] messageDigest = md.digest(input.getBytes()); 
            BigInteger no = new BigInteger(1, messageDigest); 
            String hashtext = no.toString(16); 
            while(hashtext.length() < 32) { 
                hashtext = "0" + hashtext; 
            } 
            return hashtext; 
        }  
        catch (Exception e) 
        { 
            throw e;
        }
	}
	
}
