package mkcl.os.localdal.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.EnumSet;


import javax.servlet.DispatcherType;
import javax.servlet.FilterRegistration;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import mkcl.oesclient.security.DBandMasterRecordsCheckerFilter;

public class DBPoolDestroyer implements ServletContextListener 
{
	public static String Attr_VenueNOTRegistered = "mkcl.os.localdal.model.VenueNOTRegistered";
	public static String Attr_DBNOTExists = "mkcl.os.localdal.model.DBNOTExists";
	
	@Override
	public void contextInitialized(ServletContextEvent sce) 
	{
		boolean regFilter = false;
		
		try (Connection con = new ISqlOperationImpl().getConnection();
			PreparedStatement ps = con.prepareStatement("SELECT EXAMVENUEID FROM EXAMVENUE"))
		{
			ResultSet rs = ps.executeQuery();
			if(!rs.next())
			{
				sce.getServletContext().setAttribute(Attr_VenueNOTRegistered, true);
				regFilter = true;
			}
		} 
		catch (Exception e) 
		{
			sce.getServletContext().setAttribute(Attr_DBNOTExists, true);
			regFilter = true;
		}
		finally 
		{
			if(regFilter)
			{
				FilterRegistration fr=sce.getServletContext().addFilter("DBandMasterRecordsCheckerFilter", DBandMasterRecordsCheckerFilter.class);
				fr.addMappingForUrlPatterns(EnumSet.of(DispatcherType.REQUEST), true, "/*");
			}
		}
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("Shutting down DB pool.");
		try {
			new ISqlOperationImpl().closeDataSource();
		} catch (Exception e) {
			System.out.println("*****************Error while closing c3p0.*****************");
		}
		System.out.println("DB pool shutdown complete.");
	}

}
