package mkcl.oesclient.pdfgenerator;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * The Class PDFComponent.
 *
 * @param <T> the generic type
 */
public class PDFComponent<T> {

	/** The style sheet xsl name. */
	private String styleSheetXSLName;

	/** The inputs to xml. */
	private T inputsToXML;

	/** The pdf file name. */
	private String pdfFileName;

	/** The title. */
	private String title = "MKCL-OESClient PDF";

	/** The producer name. */
	private String producerName = "MKCL-OES";

	/** The creater name. */
	private String createrName = "MKCL-OES Administrator";

	/** The author name. */
	private String authorName = "MKCL-OES Administrator";
	
	/** The Subject name. */
	private String subjectName = "MKCL-OES Report";

	/** The http request. */
	private HttpServletRequest httpRequest;

	/** The http response. */
	private HttpServletResponse httpResponse;

	/** The semaphore. */
	private int semaphore = 0;

	/**
	 * Instantiates a new pDF component.
	 *
	 * @param httpRequest the http request
	 * @param httpResponse the http response
	 */
	public PDFComponent(HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
		this.httpRequest = httpRequest;
		this.httpResponse = httpResponse;
	}

	/**
	 * Gets the http request.
	 *
	 * @return the http request
	 */
	protected HttpServletRequest getHttpRequest() {
		return httpRequest;
	}

	/**
	 * Gets the http response.
	 *
	 * @return the http response
	 */
	protected HttpServletResponse getHttpResponse() {
		return httpResponse;
	}

	/**
	 * Gets the style sheet xsl name.
	 *
	 * @return the style sheet xsl name
	 */
	protected String getStyleSheetXSLName() {
		return styleSheetXSLName;
	}

	/**
	 * Sets the style sheet xsl name.
	 *
	 * @param styleSheetXSLName the new style sheet xsl name
	 */
	public void setStyleSheetXSLName(String styleSheetXSLName) {
		this.styleSheetXSLName = styleSheetXSLName;
	}

	/**
	 * Gets the inputs to xml.
	 *
	 * @return the inputs to xml
	 */
	protected T getInputsToXML() {
		return inputsToXML;
	}

	/**
	 * Sets the inputs to xml.
	 *
	 * @param inputsToXML the new inputs to xml
	 */
	public void setInputsToXML(T inputsToXML) {
		this.inputsToXML = inputsToXML;
	}

	/**
	 * Gets the pdf file name.
	 *
	 * @return the pdf file name
	 */
	protected String getPdfFileName() {
		return pdfFileName;
	}

	/**
	 * Sets the pdf file name.
	 *
	 * @param pdfFileName the new pdf file name
	 */
	public void setPdfFileName(String pdfFileName) {
		this.pdfFileName = pdfFileName;
	}

	/**
	 * Gets the title.
	 *
	 * @return the title
	 */
	protected String getTitle() {
		return title;
	}

	/**
	 * Sets the title.
	 *
	 * @param title the new title
	 */
	public void setTitle(String title) {
		this.title = title;
	}

	/**
	 * Gets the producer name.
	 *
	 * @return the producer name
	 */
	protected String getProducerName() {
		return producerName;
	}

	/**
	 * Sets the producer name.
	 *
	 * @param producerName the new producer name
	 */
	public void setProducerName(String producerName) {
		this.producerName = producerName;
	}

	/**
	 * Gets the creater name.
	 *
	 * @return the creater name
	 */
	protected String getCreaterName() {
		return createrName;
	}

	/**
	 * Sets the creater name.
	 *
	 * @param createrName the new creater name
	 */
	public void setCreaterName(String createrName) {
		this.createrName = createrName;
	}

	/**
	 * Gets the author name.
	 *
	 * @return the author name
	 */
	protected String getAuthorName() {
		return authorName;
	}

	/**
	 * Sets the author name.
	 *
	 * @param authorName the new author name
	 */
	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}
	
	

	/**
	 * Gets the subject name.
	 *
	 * @return the subject name
	 */
	protected String getSubjectName() {
		return subjectName;
	}

	/**
	 * Sets the subject name.
	 *
	 * @param subjectName the new subject name
	 */
	public void setSubjectName(String subjectName) {
		this.subjectName = subjectName;
	}

	/**
	 * Start pdf generator.
	 *
	 * @return true, if successful
	 */
	public boolean startPDFGeneratorEngine() {
		if (semaphore == 0) {
			PDFGenerator<T> engine = new PDFGenerator<T>(this);
			semaphore=1;
			return engine.generatePDFUsingFOP();
		}
		return false;
	}
	
	
	public void writeErrorResponseContent() throws IOException {
		httpResponse.setContentType("text/html");
		PrintWriter out = httpResponse.getWriter();
	    out.println("<html><head><title>Oops!</title></head><body>");
	    out.println("<div class=\"alert alert-error\">");
	    out.println("<h4 class=\"alert-heading\">Oops !</h4>");
	    out.println("<div>");
	    out.println("<p>Something went wrong !.We've logged unexpected error while generating PDF document</p>");
	    out.println("</div></div>");
	    out.println("</body></html>");
	}

}
