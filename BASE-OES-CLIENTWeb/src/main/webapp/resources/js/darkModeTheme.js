function darkModeCheck(){
	   var isDarkMode = $("#isDarkModeOn").val();
	   var isDarkModeOn = false;
	   var isIFrameHit=false;
	   if(isDarkMode=="true"){isDarkModeOn=true;}
	   else{isDarkModeOn=false;}
	   
	   if(isDarkMode==undefined){
	   		var parentbody=window.parent.document.body;
			isDarkModeOn=$(parentbody).hasClass("dark-mode");
			isIFrameHit=true;
	   }
	   if(isDarkModeOn)
	   {	// set the attributes for link element
	   		var link = document.createElement('link');
	        link.rel = "stylesheet"; 
	        link.type = "text/css";
	        link.id = "darkModeCSS";
	        link.href = "../resources/style/template_darkmode.css";
	 
	        // Get HTML head element to append and link element to it
	        try{
	        	if(isIFrameHit){
	        		document.getElementsByTagName('HEAD')[0].appendChild(link);
	        	}
	        	else{
	        		document.QuestionContainer.document.getElementsByTagName('HEAD')[0].appendChild(link);
	        	}
	        }
	        catch(e)
	        {
		        return true;
		     }
	   }
	   else{
	   		try{
	   			if(isIFrameHit){
	        		$('#darkModeCSS').remove();
	        	}
	        	else{
	        		$('#QuestionContainer').contents().find('#darkModeCSS').remove();
	        	}
	        }
	        catch(e)
	        {
		        return true;
		     }
	   	}
}