package mkcl.oesclient.security;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.lang.StringEscapeUtils;

public class EscapedParamsRequestWrapper extends HttpServletRequestWrapper 
{

    public EscapedParamsRequestWrapper(HttpServletRequest request) {
        super(request);
        // TODO Auto-generated constructor stub
    }
    
    @Override
    public String getParameter(String s) 
    {
    	if(s.contains("typedText"))
    	{
    		return super.getParameter(s);
    	}
        String val = super.getParameter(s);
        if(val != null && !val.isEmpty())
        {
            return StringEscapeUtils.escapeXml(val);
        }
        return val; 
    }
    
    @Override
    public Map<String, String[]> getParameterMap()
    {
    	Map<String, String[]> map = super.getParameterMap();
    	if (map != null && !map.isEmpty()) 
    	{
    		Map<String, String[]> Newmap = new HashMap<>();
			for (Entry<String, String[]> entry : map.entrySet()) 
			{
				
				if(entry.getKey().contains("typedText"))
				{
					Newmap.put(entry.getKey(), entry.getValue());
					break;
				}
				
				ArrayList<String> arrlist= new ArrayList<String>();
				for (String value : entry.getValue()) 
				{
					arrlist.add(StringEscapeUtils.escapeXml(value));
				}
				
				if(!arrlist.isEmpty())
				{
					Newmap.put(entry.getKey(), arrlist.toArray(new String[arrlist.size()]));
				}
				arrlist.clear();
				arrlist = null;
			}
			
			return Newmap;
		}
    	
    	return map;
    }
    
    @Override
    public Enumeration<String> getParameterNames()
    {
    	return super.getParameterNames();
    }

    public String[] getParameterValues(String name)
    {
    	String[] arr = super.getParameterValues(name);
    	
    	if(name.contains("typedText"))
    	{
    		return arr;
    	}
    	
    	if(arr != null && arr.length > 0)
    	{
    		String[] newarr = new String[arr.length];
    		for (int i = 0; i < arr.length; i++) 
    		{
    			newarr[i] = StringEscapeUtils.escapeXml(arr[i]);
			}
    		
    		return newarr;
    	}
    	
    	return arr;
    }
    
}
