package mkcl.oesclient.dailybackup;

import java.util.Properties;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.SchedulerException;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.quartz.QuartzJobBean;

import mkcl.oesclient.commons.utilities.MKCLUtility;


public class DatabaseAutoBackupJob extends QuartzJobBean {
	private DatabaseAutoBackupTask databaseAutoBackupTask;

	/**
	 * @param frameworkFileCheckingTask
	 *            the frameworkFileCheckingTask to set
	 */
	public void setDatabaseAutoBackupTask(DatabaseAutoBackupTask databaseAutoBackupTask) {
		this.databaseAutoBackupTask = databaseAutoBackupTask;
	}

	@Override
	protected void executeInternal(JobExecutionContext arg0)throws JobExecutionException {
		boolean AutoBackupDB;
		Properties properties = null;
		try {
			properties = MKCLUtility.loadMKCLPropertiesFile();
		} catch (Exception e) {
			properties = null;
		}
		if (properties == null || properties.isEmpty()) {
			AutoBackupDB = false;
		}
		AutoBackupDB = Boolean.parseBoolean(properties.getProperty("AutoBackupDB") == null ? "false" : properties.getProperty("AutoBackupDB"));
		if(!AutoBackupDB)
		{
			try 
			{
				arg0.getScheduler().shutdown(false);
			} catch (SchedulerException e) {
				LoggerFactory.getLogger(DatabaseAutoBackupJob.class).error("" , e);
			}
		}
		else
		{
			LoggerFactory.getLogger(DatabaseAutoBackupJob.class).info("Job scheduled"); 
			databaseAutoBackupTask.databaseAutoBackup();
		}
	}

}
