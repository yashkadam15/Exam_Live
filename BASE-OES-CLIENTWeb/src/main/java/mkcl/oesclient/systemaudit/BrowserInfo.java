package mkcl.oesclient.systemaudit;

public class BrowserInfo {

	private String browserName;
	private String browserVersion;
	private boolean compatibilityStatus;

	public String getBrowserName() {
		return browserName;
	}

	public void setBrowserName(String browserName) {
		this.browserName = browserName;
	}

	public String getBrowserVersion() {
		return browserVersion;
	}

	public void setBrowserVersion(String browserVersion) {
		this.browserVersion = browserVersion;
	}

	public boolean isCompatibilityStatus() {
		return compatibilityStatus;
	}

	public void setCompatibilityStatus(boolean compatibilityStatus) {
		this.compatibilityStatus = compatibilityStatus;
	}
}
