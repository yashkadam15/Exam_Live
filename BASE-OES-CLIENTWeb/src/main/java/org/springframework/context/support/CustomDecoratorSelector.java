package org.springframework.context.support;

import java.io.File;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.sitemesh.DecoratorSelector;
import org.sitemesh.content.Content;
import org.sitemesh.webapp.WebAppContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import mkcl.oesclient.utilities.SessionHelper;

public class CustomDecoratorSelector implements DecoratorSelector<WebAppContext> {
	private static final Logger LOGGER = LoggerFactory.getLogger(CustomDecoratorSelector.class);
	private static final XPathFactory xpathFactory = XPathFactory.newInstance();
	private static final XPath xpath = xpathFactory.newXPath();
	private static Document doc = null;	
	@Override
	public String[] selectDecoratorPaths(Content content,WebAppContext context) throws IOException {
		
		HttpServletRequest request = context.getRequest();
		String serveletPath=request.getServletPath();			
		String module;
		String[] decorators;
		if(serveletPath.equals("/"))  
		{
			return new String[]{"/WEB-INF/views/decorators/homeTheme.jsp"};
		}
		
		decorators = findDecoratorByModule(request, serveletPath, "Common");
		if(decorators.length > 0)
		{
			if(decorators[0].equals("true"))
			{
				decorators[0] = null;
			}
			return decorators;
		}
		else
		{
			if(SessionHelper.getSiteMeshModule(request.getSession(false))!=null)
			{
				module = SessionHelper.getSiteMeshModule(request.getSession(false));
			}
			else
			{
				return new String[]{"/","/WEB-INF/views/decorators/homeTheme.jsp"};
			}
			decorators = findDecoratorByModule(request, serveletPath, module);
			if(decorators[0].equals("true"))
			{
				decorators[0] = null;
			}
			return decorators;
		}
		
	}
	
	private String[] findDecoratorByModule(HttpServletRequest request,
			String serveletPath, String module) {
		String decorator = "";
		try
		{						
			if(doc==null)
			{
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		        DocumentBuilder builder;	        
		    	
		        builder = factory.newDocumentBuilder();
		        doc = builder.parse(request.getSession().getServletContext().getRealPath("") + File.separator + "WEB-INF" + File.separator + "classes" + File.separator + "sitemesh.xml");
			}
	        
	    	XPathExpression expr = xpath.compile("sitemesh/module[@id='"+module+"']/mapping[@path='"+serveletPath+"']");
	    	Node node = (Node) expr.evaluate(doc, XPathConstants.NODE);
	    	if(node!=null)
	    	{
	    		decorator = (node.getAttributes().getNamedItem("decorator") != null  ? node.getAttributes().getNamedItem("decorator").getNodeValue() : node.getAttributes().getNamedItem("exclude").getNodeValue());
	    	}
	    	LOGGER.info("Decorator file found by first step elimination :" + decorator);
	        
	        if(decorator.isEmpty())
	        {
	            expr = xpath.compile("sitemesh/module[@id='"+module+"']/mapping/@path[contains(.,'*')]/..");
	            NodeList attributeElement = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);
	            if(attributeElement!=null)
	            {
		            for (int i = 0; i < attributeElement.getLength(); i++) {	            	
		                Pattern r = Pattern.compile("^" + attributeElement.item(i).getAttributes().getNamedItem("path").getNodeValue().replace("*", "."));
		                Matcher m = r.matcher(serveletPath);
		                if(m.find())
		                {	           
		                	decorator = (attributeElement.item(i).getAttributes().getNamedItem("decorator") != null  ? attributeElement.item(i).getAttributes().getNamedItem("decorator").getNodeValue() : attributeElement.item(i).getAttributes().getNamedItem("exclude").getNodeValue());
		                	LOGGER.info("Decorator file found by second step elimination :" + decorator);
		                    break;
		                }
		            }
	            }
	            
	            if(decorator.isEmpty())
	            {
	            	expr = xpath.compile("sitemesh/module[@id='"+module+"']/@defaultDecorator");
	                decorator = (String) expr.evaluate(doc, XPathConstants.STRING);	 
	                LOGGER.info("Default Decorator file found :" + decorator);
	                if(!decorator.isEmpty())
	                {
	                	return new String[]{decorator};
	                }	                
	            }
	            else
		        {
		        	return new String[]{decorator};
		        }
	        }
	        else
	        {
	        	return new String[]{decorator};
	        }
		}
		catch(Exception e)
		{
			LOGGER.error("error in selecting decorator::",e);
		}		
		return new String[] {};
	}
}
