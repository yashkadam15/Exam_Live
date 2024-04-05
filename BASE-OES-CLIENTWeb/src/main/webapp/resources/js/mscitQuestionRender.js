var canformsubmit=true;
var submit=0;
$(document).ready(function(){
	 if($('html').css('direction')=='ltr' && $('.scrollbar-outer').length>0)
	 {
	 $('.scrollbar-outer').scrollbar();
	 }
	parent.$('#time-text').trigger('updateDBTime');
	document.getElementById("lvlNmbrQtype").innerHTML = $('.lvlbtn[data-active=1]',window.parent.document).data('displaylvl') +" : "+ $('.lvlbtn[data-active=1]',window.parent.document).data('qtype')  ;
	if(document.getElementById("lvlNmbrQtype1")!=null)
	{
	document.getElementById("lvlNmbrQtype1").innerHTML= document.getElementById("lvlNmbrQtype").innerHTML;
	}
	$('button[id^=Save]').click(function(e){	
		
		var form = $(this).parents('form:first');
		
			if($('input[id^=optionsAns]',form).length > 0 && $('input[id^=optionsAns]:checked',form).length <= 0)
			{
				
				e.preventDefault();
				$('#msgModalLoader',window.parent.document).attr('data-msgmodalbodytext',"Please Select Option!!!");
				$('#msgModalLoader',window.parent.document).attr('data-footerbtn1text',"OK");
				$('#msgModalLoader',window.parent.document).attr('data-footerbtn1class','btn btn-default');
			
				window.parent.triggerMsgLoader('on',function () {
			        //OK button
					window.parent.triggerMsgLoader('off');
			    });
				canformsubmit=false;
			}
			else if($('input[id^=optionsAns]',form).length > 0 && $('input[id^=optionsAns]:checked',form).length > 0)
			{					
				parent.$('#qusInfoTable').trigger('updateInfoTable');
				canformsubmit=true;						
					
			}
			else if($('#itype').val()=='PRT')
			{
				canformsubmit=true;			
			}
		
	});
	$('form[id^=frmQues]').submit(function(e){
		
		if(!canformsubmit)
		{
			canformsubmit=true;
			return false;
		}
		else if(submit==0)
		{
			submit=1;				
			return true;
		}
		else
		{
			return false;
		}
	});	
	

    $('.prtbtn').click(function(e) {	
    	e.preventDefault();
			if(e.which != 2 && !$(this).hasClass("disable")){			
				if(navigator.userAgent.search('MOSB') >= 0){
					window.location.href=$(this).data("lnk");		
		 		}else {		 			 			
		 			window.parent.triggerExamClientModalIfrm();		 
		 		}
			}
		});  
});
	


