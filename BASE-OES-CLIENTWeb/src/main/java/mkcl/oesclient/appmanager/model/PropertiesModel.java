package mkcl.oesclient.appmanager.model;

import java.util.HashMap;
import java.util.Map;

public class PropertiesModel {
	
	private Map<String, String> map = new HashMap();
	private static String selectedFile;
	

	
	public void setMap(Map<String, String> map) {
		this.map = map;
	}

	public Map<String, String> getMap() {
		return map;
	}
		
	 public String getSelectedFile() {
	      return this.selectedFile;
	   }

	   public void setSelectedFile(String selectedFile) {
	      this.selectedFile = selectedFile;
	   }
	   
		
}
