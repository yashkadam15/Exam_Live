package mkcl.oesclient.common;

import mkcl.oesclient.commons.controllers.UploadOESLogDataController;

import org.junit.Test;

public class TestUploadOESLogDataController {

	
	@Test
	public void testUploadOESLogData() {
		UploadOESLogDataController upLogDataController =new UploadOESLogDataController();
		upLogDataController.uploadOESLogData(360l, 7l);
		
	}
	
}
