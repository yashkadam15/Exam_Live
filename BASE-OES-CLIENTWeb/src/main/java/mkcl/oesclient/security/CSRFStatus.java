package mkcl.oesclient.security;

public enum CSRFStatus 
{
	COOKIE_NOT_PRESENT("CSRF token is missing."), 
	COOKIE_TOKEN_MISMATCH("CSRF token mismatch found."), 
	COOKIE_TOKEN_MATCH("CSRF header and cookie are mathing."),
	UNABLE_TO_VALIDATE_TOKEN("CSRF token is found but got exception while validating.");
	
	private final String statusMessage;
	
	CSRFStatus(String statusMessage) {
		this.statusMessage = statusMessage;
		
	}

	public String getStatusMessage() {
		return statusMessage;
	}
}
