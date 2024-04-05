package mkcl.oesclient.commons.controllers;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * @author Reena
 * This customized ExamLocaleThemeResolver allows setting Locale and Theme 
 * for Exam Interface as per Medium of Paper.
 * Also setting the application default Locale except Exam interface.
 */

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mkcl.oesclient.commons.services.ExamEventConfigurationServiceImpl;
import mkcl.oesserver.model.NaturalLanguage;
import mkcl.os.localdal.model.ISqlOperation;
import mkcl.os.localdal.model.ISqlOperationImpl;

import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ThemeResolver;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.springframework.web.util.WebUtils;


public class ExamLocaleThemeResolver {
	
	
	private Locale defaultLocale;
	
	
	protected Locale getDefaultLocale() {
		return defaultLocale;
	}

	public void setDefaultLocale(Locale defaultLocale) {
		this.defaultLocale = defaultLocale;
	}

	private ISqlOperation examEventConfigCRUD = new ISqlOperationImpl();

	/**
	 * Method to get Locale for Exam
	 * @param ceid
	 * @param pid
	 * @return String this returns the ISO Code of locale
	 * @throws Exception
	 */
	private String getLocaleforExam(Long ceid,Long pid) throws Exception
	{
		PreparedStatement ps = null;
		ResultSet resultSet=null;
		try (Connection dbConnection = examEventConfigCRUD.getConnection();)
		{
			if(ceid != null)
			{
				ps = dbConnection.prepareStatement("SELECT N.ISOCODE AS ISOCODE FROM MEDIUMOFPAPER M INNER JOIN NATURALLANGUAGE N ON M.FKLANGUAGEID=N.ID INNER JOIN CANDIDATEEXAM C ON C.FKPAPERID=M.FKPAPERID WHERE C.CANDIDATEEXAMID=? LIMIT 1");
				ps.setLong(1,ceid.longValue());
			}
			if(pid != null)
			{
				ps = dbConnection.prepareStatement("SELECT N.ISOCODE AS ISOCODE FROM MEDIUMOFPAPER M INNER JOIN NATURALLANGUAGE N ON M.FKLANGUAGEID=N.ID WHERE M.FKPAPERID=? LIMIT 1");
				ps.setLong(1,pid.longValue());
			}
		
			resultSet = ps.executeQuery();
			
			if (resultSet.next()) 
			{				
				return resultSet.getString("ISOCODE");			
			}
			
			if(ps!=null)
			{
				ps.close();
			}
		}
		catch(Exception e)
		{
			throw e;
		}
		return null;
	}
	
	/**
	 * Method to set Exam Locale and Theme
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void setExamLocaleAndTheme(HttpServletRequest request,HttpServletResponse response) throws Exception 
	{		
			try
			{	String examLocale=null;
				
				if(request.getParameter("ceid")!=null)
				{
					// get Medium(language) of Paper for solo Exam
					examLocale=getLocaleforExam(Long.parseLong(request.getParameter("ceid")), null);					
				}
				else if(request.getParameter("paperID")!=null)
				{
					// get Medium(language) of Paper for Group exam
					examLocale=getLocaleforExam(null, Long.parseLong(request.getParameter("paperID")));
				}
			
			// Set ExamLocale only if examLocale and Default Locale are different
			if (examLocale != null && (examLocale.equals("ar") || examLocale.equals("en")) && !examLocale.equals(getDefaultLocale().toString())) {
				LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
				ThemeResolver themeResolver = RequestContextUtils.getThemeResolver(request);
				
				if (localeResolver == null) {
					throw new IllegalStateException("No LocaleResolver found: not in a DispatcherServlet request?");
				}
					// set Locale as per Medium of Paper
					localeResolver.setLocale(request, response, StringUtils.parseLocaleString(examLocale));			
						
				if (themeResolver == null) {
					throw new IllegalStateException("No ThemeResolver found: not in a DispatcherServlet request?");
				}			
					// Set theme for respective examLocale
					themeResolver.setThemeName(request, response, examLocale);
			
			}
			
			}
			catch(Exception ex)
			{
				throw ex;
			}		
		
	}
	
	/**
	 * Method to set Application Default Locale and Theme
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void setApplicationDefaultLocaleAndTheme(HttpServletRequest request,HttpServletResponse response) throws Exception 
	{		
			try
			{
				//Locale locale=LocaleContextHolder.getLocale();
				// Set Default Locale only if current request Locale and Default Locale are different
				if(!LocaleContextHolder.getLocale().toString().equals(getDefaultLocale().toString()))
				{
				LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
				ThemeResolver themeResolver = RequestContextUtils.getThemeResolver(request);
				
				if (localeResolver == null) {
					throw new IllegalStateException("No LocaleResolver found: not in a DispatcherServlet request?");
				}				
				//set Application Default Locale 
				localeResolver.setLocale(request,response,StringUtils.parseLocaleString(getDefaultLocale().toString()));
			
				if (themeResolver == null) {
					throw new IllegalStateException("No ThemeResolver found: not in a DispatcherServlet request?");
				}			
				// set Application Default Theme as per Default Locale
				themeResolver.setThemeName(request, response, getDefaultLocale().toString());
				}
			}
			catch(Exception ex)
			{
				throw ex;
			}		
	}
	

	
	
}
