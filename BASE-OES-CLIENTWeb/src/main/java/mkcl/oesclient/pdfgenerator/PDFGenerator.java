package mkcl.oesclient.pdfgenerator;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.FopFactoryBuilder;
import org.apache.fop.apps.MimeConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * The Class PDFfopGenerator.
 * 
 * @param <T>
 *            the generic type
 */
public class PDFGenerator<T> {

	private static Logger LOGGER = LoggerFactory.getLogger(PDFGenerator.class);

	private static final String EXCEPTIONMSG = "Exception Occured  In PDFGenerator : ";

	/** The component. */
	private PDFComponent<T> component;

	/**
	 * Instantiates a new PDF fop generator.
	 * 
	 * @param component
	 *            the component
	 */
	public PDFGenerator(PDFComponent<T> component) {
		this.component = component;
	}

	public Boolean generatePDFUsingFOP() {

		ByteArrayOutputStream out = null;
		Boolean pdfGenerationProcessStatus = false;
		HttpServletRequest httpRequest = component.getHttpRequest();
		HttpServletResponse httpResponse = component.getHttpResponse();
		try {
			// reuse this instance
			//FopFactory fopFactory =PDFComponentFactory.getFopFactory(httpRequest);
			
			FopFactoryBuilder fopFactoryBuilder = PDFComponentFactory.getFopFactoryBuilder(httpRequest);
			FopFactory fopFactory = fopFactoryBuilder.build();
			
			// user agent
			// set PDF file properties
			FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
			
			foUserAgent.setTitle(component.getTitle());
			foUserAgent.setProducer(component.getProducerName());
			foUserAgent.setCreator(component.getCreaterName());
			foUserAgent.setAuthor(component.getAuthorName());
			foUserAgent.setSubject(component.getSubjectName());
			foUserAgent.setCreationDate(new Date());
			foUserAgent.setTargetResolution(70);

			// get output Stream
			out = new ByteArrayOutputStream();
			Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, out);
			// Resulting SAX events (the generated FO) pipe through to FOP
			Result res = new SAXResult(fop.getDefaultHandler());
			// read XML style sheet from cache template : XSL
			Transformer transformer = PDFComponentFactory.getStyleSheetTemplate(component.getStyleSheetXSLName(), httpRequest).newTransformer();
			StreamSource streamSourceXMLData = getSourceStremOFXMLData();
			if (streamSourceXMLData != null) {
				
				// Start XSLT transformation and FOP processing
				transformer.transform(streamSourceXMLData, res);

				// PDF generation process status
				pdfGenerationProcessStatus = true;

				// set response
				httpResponse.setContentType("application/pdf");
				httpResponse.setCharacterEncoding("UTF-8");
				// if file name is Available from Controller URL
				// otherwise set given File name
				if (component.getPdfFileName() != null && !component.getPdfFileName().isEmpty()) {
					httpResponse.setHeader("Content-Disposition", "attachment; filename=\"" + component.getPdfFileName().replace(" ", "_") + ".pdf\"");
				}
				out.writeTo(httpResponse.getOutputStream());
				streamSourceXMLData = null;

			}

		} catch (Exception e) {
			LOGGER.error(EXCEPTIONMSG, e);
		} finally {
			try {
				out.flush();
				out.close();
				out = null;
			} catch (Exception ex) {
				LOGGER.error(EXCEPTIONMSG, ex);
			}
		}
		return pdfGenerationProcessStatus;
	}

	/**
	 * Gets the source stream of xml data.
	 * 
	 * @return the source stream of xml data
	 */
	private StreamSource getSourceStremOFXMLData() {
		StreamSource source = null;
		try {
		T data = component.getInputsToXML();
			// convert data to XML
			ByteArrayOutputStream outStream = new ByteArrayOutputStream();
			PDFComponentFactory.getJAXbMarshaller(data.getClass()).marshal(data, outStream);
			source = new StreamSource(new ByteArrayInputStream(outStream.toByteArray()));
			outStream.close();
		} catch (Exception e) {
			LOGGER.error(EXCEPTIONMSG, e);
		}
		return source;
	}


}
