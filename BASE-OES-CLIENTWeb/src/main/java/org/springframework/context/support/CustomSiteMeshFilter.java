package org.springframework.context.support;

import org.sitemesh.DecoratorSelector;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.sitemesh.webapp.WebAppContext;

public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter {
	
	
  
	@Override
	protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {  		
		

		 builder.setCustomDecoratorSelector((DecoratorSelector<WebAppContext>) new CustomDecoratorSelector());
		 
	}
  	
  	
}