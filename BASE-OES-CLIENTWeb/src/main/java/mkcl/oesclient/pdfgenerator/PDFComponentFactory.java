package mkcl.oesclient.pdfgenerator;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.transform.Templates;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;


import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.FopFactoryBuilder;
import org.apache.fop.configuration.Configuration;
import org.apache.fop.configuration.DefaultConfigurationBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A factory for creating PDFfop objects.
 */
public final class PDFComponentFactory {

	private static Logger LOGGER = LoggerFactory.getLogger(PDFComponentFactory.class);

	/** The fop factory. */
	private static FopFactory fopFactory;
	
	private static FopFactoryBuilder fopFactoryBuilder;

	/** The xsl template. */
	private static Map<String, Templates> templatesCacheMap;

	/** The jaxb marshaller. */
	/*private static Map<String, Marshaller> marshalerMap;*/

	/** The Constant FOP_CONFIG. */
	private static final String FOP_CONFIG = "pdf.fop.cfg.xml";

	private static final String EXCEPTIONMSG = "Exception Occured  In PDFComponentFactory : ";

	/**
	 * Instantiates a new PDF fop factory.
	 */
	private PDFComponentFactory() {
	}

	static {
		templatesCacheMap = new HashMap<String, Templates>();
		/*marshalerMap = new HashMap<String, Marshaller>();*/
	}

	/**
	 * Gets the fop factory.
	 * 
	 * @param request
	 *            the request
	 * @return the fop factory
	 */
	public static FopFactory getFopFactory(HttpServletRequest request) {
		try {
			/*synchronized (PDFComponentFactory.class) {*/
				if (fopFactory == null) {
					/*
					 * fopFactory = FopFactory.newInstance(); // for image base URL //String
					 * serverPath = request.getSession().getServletContext().getRealPath("/");
					 * //disable strict validatetion fopFactory.setStrictValidation(false);
					 * fopFactory.setBaseURL(serverPath); // for fonts base URL
					 * fopFactory.getFontManager().setFontBaseURL(serverPath);
					 * 
					 * fopFactory.setURIResolver(new PdfURIResolver());
					 */
					// read custom font setting
					/*
					 * StreamSource configSrc = new
					 * StreamSource(Thread.currentThread().getContextClassLoader().
					 * getResourceAsStream(PDFComponentFactory.FOP_CONFIG));
					 * DefaultConfigurationBuilder cfgBuilder = new DefaultConfigurationBuilder();
					 * Configuration cfg = cfgBuilder.build(configSrc.getInputStream());
					 * fopFactory.setUserConfig(cfg);
					 */
				
					
			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONMSG, e);
		}
		return fopFactory;
	}
	
	
	public static FopFactoryBuilder getFopFactoryBuilder(HttpServletRequest request) {
		try {
			
				if (fopFactoryBuilder == null) {
					
					// for image base URL
					String serverPath = request.getSession().getServletContext().getRealPath("/");
				
					StreamSource configSrc = new StreamSource(Thread.currentThread().getContextClassLoader().getResourceAsStream(PDFComponentFactory.FOP_CONFIG));
					DefaultConfigurationBuilder cfgBuilder = new DefaultConfigurationBuilder();
					Configuration cfg = cfgBuilder.build(configSrc.getInputStream());
			
					fopFactoryBuilder = new FopFactoryBuilder(new URI(serverPath)).setConfiguration(cfg);
					
			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONMSG, e);
		}
		return fopFactoryBuilder;
	}

	/**
	 * Gets the style sheet template.
	 * 
	 * @param styleSheet
	 *            the style sheet
	 * @return the style sheet template
	 */
	public static Templates getStyleSheetTemplate(String styleSheet, HttpServletRequest request) {
		try {
			if (!templatesCacheMap.containsKey(styleSheet)) {
				// read XML style sheet : XSL
				// create cache template
				String serverpath = request.getSession().getServletContext().getRealPath("/");
				StreamSource templateSrc = new StreamSource(serverpath + "WEB-INF/classes/" + styleSheet);
				//1.  SAXON XSLT Processor
				TransformerFactory factory = TransformerFactory.newInstance();
				//2.  XALON XSLT processor
				//TransformerFactory factory = TransformerFactory.newInstance();
				Templates xslTemplate = factory.newTemplates(templateSrc);
				// adding to map cache
				templatesCacheMap.put(styleSheet, xslTemplate);
			}
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONMSG, e);
		}
		return templatesCacheMap.get(styleSheet);
	}


	/**
	 * Gets the jA xb marshaller.
	 * 
	 * @param clazz
	 *            the clazz
	 * @return the jA xb marshaller
	 */
	public static Marshaller getJAXbMarshaller(Class<?> clazz) {
		Marshaller jaxbMarshaller = null;
		try {
			/*if (!marshalerMap.containsKey(clazz.getName())) {*/
				// create JAXB context
				// initiate marshaller
				JAXBContext ctx = JAXBContext.newInstance(clazz);
				 jaxbMarshaller = ctx.createMarshaller();
				jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
				/*marshalerMap.put(clazz.getName(), jaxbMarshaller);*/
		/*	}*/
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONMSG, e);
		}
		return jaxbMarshaller;
	}

}
