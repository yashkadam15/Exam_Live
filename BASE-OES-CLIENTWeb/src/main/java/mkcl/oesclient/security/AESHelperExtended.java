package mkcl.oesclient.security;

import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.log4j.Logger;

public final class AESHelperExtended 
{
	private static final Logger LOGGER = Logger.getLogger(AESHelperExtended.class);
	
	/** The transformation. */
	private static String transformation = "AES/CBC/PKCS5Padding";

	/** The encryption algorithm. */
	private static String encryptionAlgorithm = "AES";

	private static byte[] generateSalt() 
	{
		SecureRandom random = new SecureRandom();
		byte[] salt = new byte[16];
		random.nextBytes(salt);
		return salt;
	}
	
	private static byte[] coreEncrypt(byte[] inputText, byte[] keyBytes) throws Exception 
	{
		byte[] IVBytes = generateSalt();
		
		SecretKeySpec key = new SecretKeySpec(keyBytes, encryptionAlgorithm);
		Cipher cipher = Cipher.getInstance(transformation, "SunJCE");
		cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(IVBytes));

		byte[] result = cipher.doFinal(inputText);

		
		byte[] output = new byte[IVBytes.length + result.length];
		System.arraycopy(IVBytes, 0, output, 0, IVBytes.length);
		System.arraycopy(result, 0, output, IVBytes.length, result.length);
		return output;
	}
	
	public static String encryptAsRandom(String inputText, String encryptionKey) throws Exception
	{
		byte[] encBytes = coreEncrypt(inputText.getBytes("UTF-8"), encryptionKey.getBytes("UTF-8"));
		return Base64.getEncoder().encodeToString(encBytes);
	}
	
	private static byte[] coreDecrypt(byte[] inputText, byte[] keyBytes) throws Exception 
	{
		byte[] IVBytes = null;
		IVBytes = Arrays.copyOfRange(inputText, 0, 16);
		
		SecretKeySpec key = new SecretKeySpec(keyBytes, encryptionAlgorithm);
		Cipher cipher = Cipher.getInstance(transformation, "SunJCE");
		cipher.init(Cipher.DECRYPT_MODE, key, new IvParameterSpec(IVBytes));
		
		inputText = Arrays.copyOfRange(inputText, 16, inputText.length);
		
		return cipher.doFinal(inputText);
	}
	
	public static String decryptAsRandom(String cipherText, String decryptionKey) throws Exception
	{
		byte[] dncBytes = coreDecrypt(Base64.getDecoder().decode(cipherText), decryptionKey.getBytes("UTF-8"));
		return new String(dncBytes, "UTF-8");
	}
}
