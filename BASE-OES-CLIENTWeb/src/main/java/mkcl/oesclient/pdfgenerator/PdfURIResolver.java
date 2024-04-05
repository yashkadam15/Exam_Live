package mkcl.oesclient.pdfgenerator;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

import mkcl.oes.commons.EncryptionHelper;
import mkcl.os.security.AESHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PdfURIResolver implements URIResolver{
	private static Logger LOGGER = LoggerFactory.getLogger(PdfURIResolver.class);
	@Override
	public Source resolve(String href, String base) throws TransformerException {
		Source source = null;		
		File file=null;
		OutputStream os=null;
		ByteArrayOutputStream baos=null;
		InputStream is=null;
	    try { 		
	    	if (href.contains("decImg:")) {		
	    		file = new File(new URI(base+href.substring(href.indexOf(":")+1)));
	    		if(file !=null && file.exists())
	    		{
					os = AESHelper.decryptAsStream(file,
							EncryptionHelper.encryptDecryptKey);
					baos = new ByteArrayOutputStream();
					baos = (ByteArrayOutputStream) os;
					byte[] imageBytes = baos.toByteArray();
					is = new ByteArrayInputStream(imageBytes);
					source = new StreamSource(is);
					
	    		}
	    		else
	    		{
	    			LOGGER.error("file not found or null in PdfURIResolver");
	    		}
			}	    	
	
		} catch (Exception e) {
			LOGGER.error("error occured in PdfURIResolver ",e);
		}
	    finally
	    {
	    	if(file!=null)
	    	{
	    		file =null;
	    	}
	    	try {
	    		if(baos!=null)  
	    		{
				  baos.close();
				  baos.flush();
	    		}
	    		if(is!=null)
	    		{
				is.close();
	    		}
	    		if(os!=null)
	    		{
				os.close();
				os.flush();
	    		}
			} catch (Exception e2) {
				LOGGER.error("error occured in PdfURIResolver for closing strems",e2);
			}
	    }
		return source;
	}

}
