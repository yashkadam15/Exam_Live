package mkcl.oesclient.dailybackup;

import java.util.Date;

import mkcl.oesclient.commons.services.LoginServiceImpl;
import mkcl.oesclient.commons.utilities.AppInfoHelper;

import org.slf4j.LoggerFactory;

public class DatabaseAutoBackupTask {

	public void databaseAutoBackup() {
		LoggerFactory.getLogger(DatabaseAutoBackupTask.class).info("database backup method called at time :"+new Date());
		try {
			if(AppInfoHelper.appInfo.getExamVenueId() > 0 && new BackUpServices().createBackupFile()){
				LoggerFactory.getLogger(DatabaseAutoBackupTask.class).info("Backup done successfully by schedular");
			}else{
				LoggerFactory.getLogger(DatabaseAutoBackupTask.class).info("Auto Backup failed");
			}
		} catch (Exception e) {
		LoggerFactory.getLogger(DatabaseAutoBackupTask.class).error("exception in databaseAutoBackup ",e);	
		}
	}

}
