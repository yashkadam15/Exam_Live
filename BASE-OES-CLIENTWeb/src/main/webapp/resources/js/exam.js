var isScreenSharingOn=false;
var screenshotInterval;
var dataURL='';
var model=null; 
//var csRes = 0;
var ssRes = 0;
var isPopupOn = false;
var uploadedCCI=false;		
var uploadedCSI=false;		
var ccsInterval;		
var cssInterval;		
var pBtnInterval;		
var pbe=false;
var video = null;
var modelCoco=null;
var children = [];
var csidcInterval;
var retakeIdc=false;
var uploadedCID=false;
var w1=300;	
var h1=300;
var l1=0;	
var t1=0;	
let isCamConnected=false;

$(window).on('beforeunload', function ()
{
//    if($('#captureScreenShot').val() == 'true' && navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
//	{
//		js.stopEvidenceCapture();
//	}
	if($('#captureScreenShot').val() == 'true')
	{		
		clearInterval(screenshotInterval);		
	}
});
$(window).blur(function()
{
	if(navigator.userAgent.search('MOSB') < 0 && typeof js == "undefined")
	{
		setTimeout(function()
		{ 
			if (document.activeElement.tagName != 'IFRAME' && document.activeElement.tagName != 'BODY') 
		    {	
		    	if($('#captureScreenShot').val() == 'true' && document.activeElement.tagName != 'INPUT')
		    	{
			    	userAwayFromExamScreen(document.activeElement.tagName);
				}
				else if($('#captureScreenShot').val() == 'false')
				{
					userAwayFromExamScreen(document.activeElement.tagName);
				}
		    }
		 }, 2000);
	}
});
$('#QuestionContainer').on('load',function() 
{
	if(typeof this.contentWindow.canformsubmit == "undefined")
	{
		alert("Somthing went wrong! Unable to proceed with exam, please try again or report the issue with screenshot.");
		window.location.href = "../candidateModule/homepage?changeLocale";		
	}
});
function IframeBlur()
{
	if(navigator.userAgent.search('MOSB') < 0 && typeof js == "undefined" && document.activeElement.tagName != 'BODY')
	{
		if($('#captureScreenShot').val() == 'true' && document.activeElement.tagName != 'INPUT')
		{
			userAwayFromExamScreen(document.activeElement.tagName);
		}
		else if($('#captureScreenShot').val() == 'false')
		{
			userAwayFromExamScreen(document.activeElement.tagName);
		}
	}
}
$(document).ready(function()
{
	$('#msgModal').modal('hide');
	//Piyusha
	ssRes = +$('#ssresolution').val();
	
	$(window).on('resize', function(){
		adjustHeight();		
	});
	 if($('html').css('direction')=='ltr' && $('.scrollbar-outer').length>0)
	 {
	 $('.scrollbar-outer').scrollbar();
	 }
	/*if (navigator.userAgent.search('MOSB') == -1 && window.opener && !window.opener.closed) {
		window.opener.location.href = window.opener.location.href;
	}*/
	 
 	$('#time-text').trigger('updateDBTime');
	$('#to-top').click(function() {
		$('html, body').animate({scrollTop : 0}, 600);
		return false;
	});
	
    $('#hidOperations').hide();
    $('#hidOperations_TimeUp').hide();
    
	$('#closemodal').click(function(e){
		e.preventDefault();
		if (window.opener && !window.opener.closed) {
			window.opener.location.href = $(this).attr('href');
			window.close();
		} else {
			window.location.href = $(this).attr('href');
		}
	}); 
	
	$('#camPrcd').click(function(e)
	{
		e.preventDefault();
		if(isCamConnected && !pbe){	
			return;	
		}
		
		if (!$("#cbCam").is(':checked')) 
		{			
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#ins_confirmlan').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
		    triggerMsgLoader('on',function () 
			{    	
				triggerMsgLoader('off');
		    });
					
			return;
		}
		if($('#cameraCompulsory').val() == 'false' && (window.stream === undefined || !window.stream.active || document.getElementById('previewCam').paused))
		{
			$('#captureCameraImage').val('false');
			$('#camPage').hide();
			$("#examPage").show();
			adjustHeight();
			$('#QuestionContainer').prop("src","").prop("src", $('#frmLink').val());
			return;
		}
		if(window.stream === undefined || !window.stream.active || document.getElementById('previewCam').paused)
		{
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#cameraAndPosition').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
		    triggerMsgLoader('on',function () 
			{    	
				triggerMsgLoader('off');
		    });
			
			return;
		}
				
		$('#camPage').hide();
		$("#examPage").show();
		document.querySelector('video#livecam').srcObject = window.stream;
		adjustHeight();
		$('#QuestionContainer').prop("src","").prop("src", $('#frmLink').val());
	});
	
    $("#submitTestBeforetimesUp").click(function(e) {
    	e.preventDefault();
    	$('#time-text').trigger('updateDBTime');
		if (window.opener && !window.opener.closed) {
			window.opener.location.href = $(this).attr('href');
			window.close();
		} else {
			window.location.href = $(this).attr('href');
		}
	});
    
    
    $("#quesChangeModalYes").click(function(e) {
    	if($(this).data('info')=='i')
		{
    		$('#QuestionContainer').contents().find('#curitemID').val($(this).data('item')); 
        	$('#QuestionContainer').contents().find('#hidExt').val('loadItem'); 
        	$('#QuestionContainer').contents().find('#frmQues').submit(); 
        	QuestionContainer(e);
		}
		else if($(this).data('info')=='cmpsmqtsi')
		{
			$('#QuestionContainer').contents().find('#hidExt').val('loadCMPSMQTSubItem'); 
			$('#QuestionContainer').contents().find('#curitemID').val($(this).data('item')); 
			$('#QuestionContainer').contents().find('#cursubitemID').val($(this).data('subitem')); 
        	$('#QuestionContainer').contents().find('#frmQues').submit(); 
        	QuestionContainer(e);
		}
    	else if($(this).data('info')=='s')
		{
	    	$('[id^=secNM]').trigger('ChangeActiveSection',[$(this).data('item'),'y']);
		}
    	else if($(this).data('info')=='et')
		{
    		$("#quesChangeModal").modal('hide');
    		var qno,qno1;
    		if($('#sectionRequired').val()=="true" || $('#includesSubItems').val()=="true")
    		{
				qno = $('#HdrttlAnscount').text();
				qno1=$('#Hdrttlcount').text();		    				
    		}
			else
			{
				qno = parseInt($('#Cntans').text());
				qno1=$('#ttlcount').text();
			}				
			
			$("#endTestConfirmTest").html("");
			$("#endTestConfirmTest").html($('#SoloEndConfirm').val().replace(/\^value1\^|\^value2\^/g, function findAndReplace(val){if(val == "^value1^"){return qno;} if(val == "^value2^"){return qno1;}}));
			$("#endTestConfirmModal").modal({ backdrop: 'static', keyboard: true });			
			return false;
		}
    	
    	$("#quesChangeModal").modal('hide');		 
	});
    $('#msgModal').on('hidden.bs.modal', function (e) {
    	if($('#msgModalLoader').attr('data-displaymodal') == 'off')
		{
			$('#msgModal a').each(function(){
				$(this).unbind();
			});
		}
    	else
		{
    		console.error('Unable to hide modal, "off" action of msgModalLoader is not called.');
    		e.preventDefault();
		}
		
	});    
	 if($('#testType').val() === 'solo')
	 {
 
		   	$('a[id^=lnk]').each(function(i,e){
		   		if($('#palletFwdOnly').val() == 'true')
	   			{		   			
		   			$(this).attr('data-fwdlk',1);
	   			}
		   		$('#qpStatus'+$(this).data('qid')).text($(this).attr('title'));
		   		$('#qpStatus'+$(this).data('qid')).removeClass();
		   		$('#QP'+$(this).data('qid')).attr('data-status',$(this).data('status'));
		   		$('#QP'+$(this).data('qid')).attr('data-sec',$(this).data('section'));
		   		$('#qpStatus'+$(this).data('qid')).addClass($(this).attr('class'));   	
		   		$('#frmQP'+$(this).data('qid')).text("Question " + $(this).text()+" ");		   		
		   		$('.QPsubitem'+$(this).data('qid')).each(function(){		   			
		   			$(this).text(
		   					$(this).text().replace('@',e.text)
		   			);
		   		});

		   	});

		   	$('.filterQp').click(function(){
		   		//qpStatus
		   		if($(this).data('status') === 'all')
					{
		   			$('div[id^=QP]').hide();
		   			$('div[id^=QP][data-sec="'+$('a[id^=secNM][data-active=1]').data('id')+'"]').show();
					$('#filterMsg').text('');
					}
		   		else
		   			{
		   				if($('div[id^=QP][data-sec="'+$('a[id^=secNM][data-active=1]').data('id')+'"][data-status="'+$(this).data('status') +'"]').length == 0)
		   				{
		   					$('#filterMsg').text('0 '+$(this).text());
		   				}
		   				else
		 				{
		   					$('#filterMsg').text('');
		 				}
		   			$('div[id^=QP][data-sec="'+$('a[id^=secNM][data-active=1]').data('id')+'"][data-status="'+$(this).data('status') +'"]').show();
		   	   		$('div[id^=QP][data-status!="'+$(this).data('status') +'"]').hide();
		   			}
		   	});
		   	
		    $('a[id^=lnk]').click(function(e)
			{
		    	e.preventDefault(); 		    	
		    	if($(this).attr('data-fwdlk') == '1')
		    		return;
		    	if($('#QuestionContainer')[0].contentWindow.isAnswerSaved())
		   		{ 
		   			
		    		$('#QuestionContainer').contents().find('#curitemID').val($(this).data('qid')); 
		        	$('#QuestionContainer').contents().find('#hidExt').val('loadItem'); 
		        	$('#QuestionContainer').contents().find('#frmQues').submit(); 
		        	QuestionContainer(e);
		   		}    
		    	else
	    		{
		    		confrimQusChange($('#AttemptWithoutSaving').val(),$(this).data('qid'),"i",0);
	    		}
		    });
		    $('a[id^=frmQP]').click(function(e){
		    	e.preventDefault();
		    	if($('#QuestionContainer')[0].contentWindow.isAnswerSaved())
		   		{
			    	$('#QuestionContainer').contents().find('#curitemID').val($(this).data('qpqid')); 
			    	$('#QuestionContainer').contents().find('#hidExt').val('loadItem'); 
			    	$('#QuestionContainer').contents().find('#frmQues').submit(); 
			    	QuestionContainer(e);
		   		}
		    	else
	    		{
		    		confrimQusChange($('#AttemptWithoutSaving').val(),$(this).data('qpqid'),"i",0);
	    		}
		    	
		    });
		   
		    
		    $('#endTest').click(function(e){
		    	if($(this).hasClass("disabled"))
	    		{
		    		e.preventDefault();
	    		}
		    	else
	    		{
		    		if($('#QuestionContainer')[0].contentWindow.isAnswerSaved())
			   		{
		    			var qno,qno1;
		    			if($('#sectionRequired').val()=="true" || $('#includesSubItems').val()=="true")
		        		{
		    				qno = $('#HdrttlAnscount').text();
		    				qno1=$('#Hdrttlcount').text();		    				
		        		}
		    			else
	    				{
		    				qno = parseInt($('#Cntans').text());
		    				qno1=$('#ttlcount').text();
	    				}	
		    			
		    			$("#endTestConfirmTest").html("");
						$("#endTestConfirmTest").html($('#SoloEndConfirm').val().replace(/\^value1\^|\^value2\^/g, function findAndReplace(val){if(val == "^value1^"){return qno;} if(val == "^value2^"){return qno1;}}));
						$("#endTestConfirmModal").modal({ backdrop: 'static', keyboard: true });			
						return false;
			   		}
		    		else
	    			{
		    			confrimQusChange($('#EndTestWithoutSaving').val(),0,"et",0);
		    			e.preventDefault();
	    			}
	    		}					
			});
		    
		    $('[id^=secNM]').click(function(e){
		    	e.preventDefault();
		    	if($(this).attr('data-active')=='1' || $(this).attr('data-lk')=="1")
	    		{
		    		return false;  
	    		}
		    	else
	    		{
		    		if($('#QuestionContainer')[0].contentWindow.isAnswerSaved())
		    			$('[id^=secNM]').trigger('ChangeActiveSection',[$(this).data('id'),'y']);
		    		else
		    			$('[id^=secNM]').trigger('ChangeActiveSection',[$(this).data('id'),'n']);		    			    		
	    		}
		    	
		    });
		    
		    $('[id^=secNM]').bind('ChangeActiveSection',function(e,id,force){	
		    	if(force=='y')
		   		{
	    			$('#QuestionContainer').contents().find('#sectionID').val(id);
			    	$('#QuestionContainer').contents().find('#hidExt').val('loadSec'); 
			    	$('#QuestionContainer').contents().find('#frmQues').submit(); 
			    	QuestionContainer(e);			    	
		   		}
		    	else
	    		{
		    		confrimQusChange($('#AttemptWithoutSaving').val(),id,"s",0);
		    		return false;
	    		}	
		    	if($('a[id^=secNM][data-id="'+id+'"]').data('restrict')==true)
	    		{
		    		$('a[id^=secNM]:not([id=secNM'+id+'])').attr('data-lk','1');
		    		$('a[id=secNM'+id+']').attr('data-lk','0');
	    		}
		    	else
	    		{
		    		$('a[id^=secNM]').attr('data-lk','0');
		    		$('a[id^=secNM][data-restrict=true]').attr('data-lk','1');
	    		}
		    	$('a[id^=secNM]').find('span').remove();
		    	$('a[id^=secNM]').attr('data-active','0');
		    	$('a[id^=secNM][data-id="'+id+'"]').attr('data-active','1');		    	
		    	$('a[id^=lnk]:not([data-section="'+id+'"])').hide();
		    	$('a[id^=lnk][data-section="'+id+'"]').show();
		    	$('#secName').text($('a[data-id="'+id+'"]').text());	
		    	$('a[data-showqp="all"]').trigger('click');
		    	$('#QuestionContainer').contents().find('#sectionID').val(id); 
		    	$('#ttlcount').text($('a[id^=lnk][data-section="'+id+'"]').length);
		    	if($('#includesSubItems').val()=="true")
	    		{		    		
		    		$('#ttlSubcount').text(($('a[id^=lnk][data-section="'+id+'"][data-subcnt=0]').length+getSubcount(id)));
	    		}	    	
		    	$('a[id^=secNM][data-id="'+id+'"][data-restrict="true"]').append('<span class="label"></span>');
		    	$('a[id^=secNM]:not([data-restrict="true"])').find('i').remove();
			});	
		    $('[id^=secNM]').trigger('ChangeActiveSection',[$('a[id^=secNM][data-active=1]').data('id'),'y']);	
		    if($('#sectionRequired').val()=="true" || $('#includesSubItems').val()=="true")
    		{
		    	$('#Hdrttlcount').text($('a[id^=lnk][data-subcnt=0]').length);
		    	$('[id^=secNM]').each(function(){
		    		$('#Hdrttlcount').text(parseInt($('#Hdrttlcount').text())+ getSubcount($(this).data('id')));
		    	});
    		}
		    $('#anscnt').bind('updateAllCount',function(e){
		    	$('#HdrttlAnscount').text($('#anscnt').val());
			});	
		    $('#anscnt').trigger('updateAllCount');
		    $('.BackBtn').click(function(e){
		    	e.preventDefault();
		    	QuestionContainer(e);
		    });
		    if($('#showWatermark').val()=='true')
		    {
			    var canvas = document.createElement('canvas');
				canvas.width = $('#waterMarkTxt').width();
				canvas.height = $('#waterMarkTxt').width()-5 ;
				var context = canvas.getContext('2d');
				context.globalAlpha = 0.7;
				context.fillStyle = "rgba(189, 185, 185,0.23)";
				context.rotate((30 * Math.PI / 180));
				context.font = "20px Arial";
				context.fillText($('#waterMarkTxt').text(), 10, 12);			
				context.globalCompositeOperation = "destination-over";
				dataURL = canvas.toDataURL();
				canvas.remove();
		    }
	 }
	 else if ($('#testType').val() === 'group')
	 {
			// equal height columns for the blocks above the question
			$('.reported').equalize();
		
			$('#endTest').click(function(e){
				if($(this).hasClass("disabled"))
	    		{
		    		e.preventDefault();
	    		}
		    	else
	    		{
					var qno=parseInt($("#itemSequenaceNumberText").text())-1;					
					$("#endTestConfirmTest").html("");
					$("#endTestConfirmTest").html($('#SoloEndConfirm').val().replace(/\^value1\^|\^value2\^/g, function findAndReplace(val){if(val == "^value1^"){return qno;} if(val == "^value2^"){return $('#ttlcount').text();}}));
					$("#endTestConfirmModal").modal({
						backdrop : 'static',
						keyboard : true
					});
					return false;
	    		}
			});
			
			 $('.example-css').barrating('show', {
				  onSelect: function(value, text, event) {
				    if (typeof(event) !== 'undefined') 
				    {
				    	$('#QuestionContainer').contents().find(text).val(value);				    	
				    }
				  }
			});
			 
			$('#ratingfinish').click(function(){
				$('#ratepeer').modal('hide');
				$('#QuestionContainer').contents().find('#ratingdone').val("Low");	
				$('#QuestionContainer').contents().find('#ratingdone').attr("checked","true");	
				$('#QuestionContainer').contents().find('#Save').trigger('click');	
			});
	 }
	 
	 $('#takeCE').click(function(e)		
		{		
			e.preventDefault();		
			if (!$("#cbCam").is(':checked')) 		
			{					
				$('#msgModalLoader').attr('data-msgmodalbodytext',$('#ins_confirmlan').val());		
				$('#msgModalLoader').attr('data-footerbtn1text',"OK");		
				$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');		
						
			    triggerMsgLoader('on',function () 		
				{    			
					triggerMsgLoader('off');		
			    });		
								
				return;		
			}		
			if($('#cameraCompulsory').val() == 'false' && (window.stream === undefined || !window.stream.active || document.getElementById('previewCam').paused))		
			{		
				$('#captureCameraImage').val('false');		
			}		
					
			if($('#captureCameraImage').val()=='true' && (window.stream === undefined || !window.stream.active || document.getElementById('previewCam').paused))		
			{		
				$('#msgModalLoader').attr('data-msgmodalbodytext',$('#cameraAndPosition').val());		
				$('#msgModalLoader').attr('data-footerbtn1text',"OK");		
				$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');		
						
			    triggerMsgLoader('on',function () 		
				{    			
					triggerMsgLoader('off');		
			    });		
				return;		
			}		
			if( !pbe && $('#captureCameraImage').val() == 'true'){	
				onPreviewLiveStreamStarted();	
			}	
			if(!pbe && $('#captureScreenShot').val() == 'true'){	
				onPreviewScreenSharingStarted();	
			}	
			if(!pbe && ($('#captureCameraImage').val() == 'true' || $('#captureScreenShot').val() == 'true')){	
				pBtnInterval=setInterval(proceedBtnEnable, 100);		
			}	
				
		});
		
		$('#takeID').on('click', function() {
		   	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#holdId').val());		
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");		
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');		
					
		    triggerMsgLoader('on',function () 		
			{    		
				
				showIdCard();	
		    });		
		    
		});
 });
 
 function triggerMsgLoader(action,btn1Click,btn2Click) 
 {
 	switch (action) {
     case 'on':
     case 'On':
     case 'ON':     
     	$('#msgModalBodyText')[0].innerHTML = $('#msgModalLoader').attr('data-msgmodalbodytext');
     	$('#MsgModalbtn1').text($('#msgModalLoader').attr('data-footerbtn1text'));
     	$('#MsgModalbtn2').text($('#msgModalLoader').attr('data-footerbtn2text'));
     	$('#MsgModalbtn1').attr('class',$('#msgModalLoader').attr('data-footerbtn1class'));
     	$('#MsgModalbtn2').attr('class',$('#msgModalLoader').attr('data-footerbtn2class'));
     	$("#msgModal").modal({
				backdrop : 'static',
				keyboard : true
			});
     	$('#msgModalLoader').attr('data-displaymodal','on');
     	isPopupOn = true;
     	if(btn1Click)
		{		    		
     		$('#MsgModalbtn1').show();
	 		$('#MsgModalbtn1').click(function(){
	 			btn1Click();
	 		});
		}
 	
	 	if(btn2Click)
		{
	 		$('#MsgModalbtn2').show();
	 		$('#MsgModalbtn2').click(function(){
	 			btn2Click();
	 		});
		} 
         break;
     case 'off':
     case 'Off':
     case 'OFF':     	
    	$('#msgModalLoader').attr('data-displaymodal','off');   
    	$('#msgModalLoader').attr('data-msgmodalbodytext','');    
     	$('#msgModalLoader').attr('data-footerbtn1class','');    
     	$('#msgModalLoader').attr('data-footerbtn2class','');    
     	$('#msgModalLoader').attr('data-footerbtn1text','');    
     	$('#msgModalLoader').attr('data-footerbtn2text','');    
    	$('#msgModalBodyText')[0].innerHTML = '';
    	$('#MsgModalbtn1').text('');
     	$('#MsgModalbtn2').text('');
     	$('#MsgModalbtn1').hide();
     	$('#MsgModalbtn2').hide();   
     	$('#MsgModalbtn1').removeAttr('class');
     	$('#MsgModalbtn2').removeAttr('class');
     	$('#msgModal').modal('hide');  
     	isPopupOn = false;   	
         break;
     default:
     	console.error('No action is defined for message modal.');	        	
 	} 	
 		
 }
 function getSubcount(id)
 {
	 var cnt=0;
	 $('a[id^=lnk][data-section="'+id+'"][data-subcnt!=0]').each(function(){
		 cnt += $(this).data('subcnt');
	 });
	 return cnt;
 }
 
 function confrimQusChange(msg,item,info,subitem=0)
 {
 	/*if($('#QuestionContainer').contents().find('#mode').val() === 'off' && $('#QuestionContainer').contents().find('input[id^=optionsAns]:checked').length > 0)
 	{
 		   return confirm("You are changing question without saving selected answer(s)!! Are you sure to change question?");
 	}*/	 
	 $("#quesChangeModalText").html("");
	 $('#quesChangeModalYes').data('item',item);
	 $('#quesChangeModalYes').data('subitem',subitem);
	 $('#quesChangeModalYes').data('info',info);
	 $("#quesChangeModalText").html(msg);
	 $("#quesChangeModal").modal({
		backdrop : 'static',
		keyboard : true
	 });
 }
 
 function QuestionContainer(e)
 {
 	e.preventDefault();	
 	$('#instruction').hide();
 	$('#question').hide();
 	$('#profile').hide();
 	$('#QuestionContainer').show();
 	$('a[data-showqp="all"]').trigger('click');
 }

 function showInstruction(e)
 {
 	e.preventDefault();	
 	$('#QuestionContainer').hide();
 	$('#question').hide();
 	$('#profile').hide();
 	if($('#instruction').css('display') != 'none')
 	{
 		QuestionContainer(e);
 	}
 	else
 	{
 		$('#instruction').show();
 	}	
 }
 function showQuestionPaper(e)
 {
 	e.preventDefault();
 	$('#QuestionContainer').hide();
 	$('#instruction').hide();
 	$('#profile').hide();
 	if($('#question').css('display') != 'none')
 	{
 		QuestionContainer(e);		
 	}
 	else
 	{
 	$('#question').show();
 	$('a[data-status="all"]').trigger('click');
 	}
 }
 function showProfile(e)
 {
 	e.preventDefault();
 	$('#QuestionContainer').hide();
 	$('#instruction').hide();
 	if($('#profile').css('display') != 'none')
 	{
 		QuestionContainer(e);
 	}
 	else
 	{
 	$('#profile').show();
 	}
 	$('#question').hide();
 }
 
	function triggerModalIfrm()
	{		
		$('#BtnmodalEndTest').trigger('click');
	}
 
	
$(function(){
	$("#askforpswGet").click(function(){
		   	$("#endTestConfirmTest").hide();
		   	//get btn
			$("#askforpswGet").hide();
			//post btn
			$("#askforpswPost").show();
			//wait label show
			$("#pleasewaiteld").show();
			//iframe load
			$("#verifypswIframe").prop("src","").prop("src","../endexam/verify");
			var qno,qno1;
			if($('#sectionRequired').val()=="true" || $('#includesSubItems').val()=="true")
    		{
				qno = $('#HdrttlAnscount').text();
				qno1=$('#Hdrttlcount').text();		    				
    		}
			else
			{
				qno = parseInt($('#Cntans').text());
				qno = parseInt($('#CntTotal').text());
				qno1=$('#ttlcount').text();
			}	
			$('#verifypswIframe').load(function() {
				$("#pleasewaiteld").hide();
				$("#verifypswIframe").contents().find('span:first').children('span:first').text(qno);
		    	$("#verifypswIframe").contents().find('span:first').children('span:last').text(qno1);
		    	$("#verifypswIframe").css('height','160px');
			 });
			//iframe show			
			$("#verifypswIframe").show();		
			
	});
	$("#askforpswPost").click(function(){
		   var cpsw = $("#verifypswIframe").contents().find("#cpsw");
		   var spsw = $("#verifypswIframe").contents().find("#spsw");
		   var cerror = 0;
		   if($(cpsw).length > 0){
			   if($(cpsw).val()){ cerror = 0;}
			   else{ cerror = 1;}
		   }
		   
		   var serror = 0;
		   if($(spsw).length > 0){
			   if($(spsw).val()){ serror = 0;}
			   else{ serror = 1;}
		   }
		   
		   if(cerror == 0 && serror == 0)
		   {
			   if($(cpsw).length > 0)
			   {
				   var hashMD5 = hex_md5($(cpsw).val());
				   var salt = $("#verifypswIframe").contents().find("#soloRnum").val();
				   var saltHash = hex_md5(hashMD5 + salt);
				   $(cpsw).val(saltHash);
			   }

			   if($(spsw).length > 0)
			   {
				   var hashMD5 = hex_md5($(spsw).val());
				   var salt = $("#verifypswIframe").contents().find("#soloRnum").val();
				   var saltHash = hex_md5(hashMD5 + salt);
				   $(spsw).val(saltHash);
			   }			   
			   $("#verifypswIframe").contents().find("#pswform").submit();
		   }
		   else{
			   if(serror == 1){$("#verifypswIframe").contents().find("#serrormsg").show();}
			   if(cerror == 1){$("#verifypswIframe").contents().find("#cerrormsg").show();}
		   }
	});
	$(".endTestConfirmModalClose").click(function(){
		
			//hidden part
			$("#verifypswIframe").hide();
			$("#askforpswPost").hide();
			$("#pleasewaiteld").hide();
		   	$("#endTestConfirmModal").modal("hide");
		   	
			$("#endTestConfirmTest").show();
			$("#askforpswGet").show();
	});
});  	


//let prtAnswer = "";	
//let prtAnswerTxt = "";
function savePRTQuestionAnswerandNext(answerStatus, answerJSONText,itemID,saveStatus)
{	
	if(saveStatus == 'True')
	{	
	$('#lnk'+itemID).removeClass();
	$('#lnk'+itemID).addClass('btn');
	$('#lnk'+itemID).addClass('btn-greener');
	$('#lnk'+itemID).attr('data-status','ans');
	}		
	$('#QuestionContainer').prop("src","").prop("src", $('#frmLink').val());
	//prtAnswer = answerStatus;
	//prtAnswerTxt = answerJSONText;
	
	//$('#QuestionContainer').contents().find('#prtAnswer').val(answerStatus);
	//$('#QuestionContainer').contents().find('#prtAnswerTxt').val(answerJSONText);
	//$('#QuestionContainer').contents().find('#hidExt').val('loadNextItem');
	//$('#QuestionContainer').contents().find('#frmQues').submit();
	//$('#QuestionContainer').contents().find('#Save').click();
	//$($('#QuestionContainer')[0].contentWindow.applyCls($($('#QuestionContainer')[0].contentWindow.clsans)));	
}


/*function savePRTAnswer(){

	$('#QuestionContainer').contents().find('#prtAnswer').val(prtAnswer);
	$('#QuestionContainer').contents().find('#prtAnswerTxt').val(prtAnswerTxt);
	$('#QuestionContainer').contents().find('#hidExt').val('loadNextItem');
	
	if(prtAnswer != null && prtAnswer != ''){
		prtAnswer = '';
		prtAnswerTxt = '';
		$('#QuestionContainer').contents().find('#Save').click();
	}
}*/

function cancelAndLoadItem(itemID){

	$('#QuestionContainer').prop("src","").prop("src", $('#frmLink').val()+ '&itemID=' +itemID);
}

//function to show modal for Practical Test
//which show not allows without Exam Client
function triggerExamClientModalIfrm()
{		
	$('#modal-examclientallowed').modal('show');
}




	 //JS code for Simulation Item Type Only	
	 var iframeDoc;
	 $(function(){
		//var iframeS  = $('#QuestionContainer')[0];
		//Iframe Object
		var iframeS =  document.getElementById("QuestionContainer");
		//create Iframe document
		iframeDoc = (iframeS.contentWindow || iframeS.contentDocument);
	 });     
	 //JavaScript function for non-IE browser support
	 function callmarks(e)      { iframeDoc.executeCommands("saveMarks",e);          }
	 function stepsSummary(e)   { iframeDoc.executeCommands("saveStepsSummary",e);   }
	 function callright(e)      { iframeDoc.executeCommands("saveRightSteps",e);     }
	 function callwrong(e)      { iframeDoc.executeCommands("saveWrongSteps",e);     }
	 function calltotalsteps(e) { iframeDoc.executeCommands("saveTotalSteps",e);     }
	 function calltime(e)       { iframeDoc.executeCommands("closeFlashAndSubmit",e);}
	 function callloaded(e)     { }
	 
	 // send password to SWF
	 function calllms(e)        { return iframeDoc.executeCommands("getPassword",e); }
	 // DoFSCommand for IE Support
	 // objTag is object tag ID
	 function objTag_DoFSCommand(command, args) { doFSCommandCallbacks(command, args);}
	 // dofscommand callback functions
	 var doFSCommandCallbacks = function(command, args) {
		//flashtype
		// called at start-up
		//if (command == 'calltype')       {}
		// marks : 0 to 100
		if (command == 'callmarks')      { iframeDoc.executeCommands("saveMarks",args);          }
		// right steps performed in number
		if (command == 'callright')      { iframeDoc.executeCommands("saveRightSteps",args);     }
		// wrong steps performed in number
		if (command == 'callwrong')      { iframeDoc.executeCommands("saveWrongSteps",args);     }
		// total number of steps in number
		if (command == 'calltotalsteps') { iframeDoc.executeCommands("saveTotalSteps",args);     }
		//call time and it is called at End of frame
		if (command == 'calltime')       { iframeDoc.executeCommands("closeFlashAndSubmit",args);}
		// callcontent
		//if (command == 'callcontent')    {}
	 };
	 //JS code for Simulation Item Type Only
	
function Player(fileName)
{
	$('#MMplayer_1').data('mediaurl','../resources/WebFiles/QuestionData/ChatWindow/'+ $('#examEventID').val() + '/' +fileName);
	$('#MMplayer_1').data('mediaext','mp4');
	var pevnt = jQuery.Event('initPlayer');	
	pevnt.end = function(){		
		$('#playCandVdoModal').modal('hide');
		$('#MMplayer_1').data('mediaurl','');
		$('#MMplayer_1').data('mediaext','');    
		$('#MMplayer_1').trigger('destroy');
	};		
	$('#MMplayer_1').trigger(pevnt);	
}

function showNotepad(e)
{
	e.preventDefault();	
	$('#notepad').css('top','');
	$('#notepad').css('left','');
	$('#notepad').toggle();
}


function throwOutSinceScreenNotShared()
{

	isScreenSharingOn = false;
	$('#msgModalScreenShare').modal('hide');
	isPopupOn = false;
	$('div.questions-area, div.palette').hide();
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#screenSharing').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
	triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale';
    });

}


async function checkConfig()
{
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#examEnvironment').val());	
    triggerMsgLoader('on',undefined, undefined);
   	
	if($('#evidencePackageType').val() > '0')
	{
		$('#camPrcd').attr('disabled', true);
		$('#camPage').show();
		if($('#evurl').val() == '')
		{
			triggerMsgLoader('off',undefined, undefined);
			
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#evidenceURL').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
		    triggerMsgLoader('on',function () {    	
				triggerMsgLoader('off');
				window.location.href = '../candidateModule/homepage?changeLocale';
		    });
			return;
		}
		
		if($('#captureScreenShot').val() == 'true')
		{
	    	$('#camPrcd').attr('disabled', true);
	    	var screenSharingOnWithRequiredSource = false;
	    	screenSharingOnWithRequiredSource = await checkScreenSharingOnWithRequiredSource();    	
	        if(screenSharingOnWithRequiredSource == false){
	        	if(navigator.userAgent.search('MOSB') >= 0){
	        		var result = false;		
	        		await startScreenCapture();
	        		result = await checkScreenSharingOnWithRequiredSource();
	        		if(result==true){
	        			//closing the initalize exam environment popup on successful screen sharing
	                	if($('#captureCameraImage').val() == 'false'){
	                		triggerMsgLoader('off',undefined, undefined);	
	                	}
	        			isScreenSharingOn = true;
	        			if(typeof onScreenSharingStreamEjected === "function")
	        			{
	        				videoScreenElem.srcObject.getVideoTracks()[0].addEventListener('ended', onScreenSharingStreamEjected);
	        			}
	        		}
	        		else if(result==false){
	        			throwOutSinceScreenNotShared();
	        		}
	        	}
	        	else{
	        		triggerMsgLoader('off',undefined, undefined);
	        		if ((navigator.userAgent.toLowerCase().includes("windows") || navigator.userAgent.toLowerCase().includes("macintosh")) ){
	        		$('#msgModalScreenShare').modal('show'); 
	        		isPopupOn = true;        		        		
	        		}else{
	        		isScreenSharingOn=true; 
	        		uploadedCSI=true;  
	        		}           	            	
	        	}
		
	        }
	        else {
	        	//closing the initalize exam environment popup on successful screen sharing
	        	if($('#captureCameraImage').val() == 'false'){
	        		triggerMsgLoader('off',undefined, undefined);	
	        	}        	
	        	isScreenSharingOn = true;
	        }
		}
	
		if($('#captureCameraImage').val() == 'true')
		{				
			initFaceAPI();
			videoElement = document.querySelector('video#previewCam');	
			isWebcamConnected(function(hasWebcam)
			{					
				triggerMsgLoader('off',undefined, undefined);	
				if(hasWebcam)
				{
					startCam(undefined);
					isCamConnected=true;
					//add condition if id capture if optionl
					if($('#isIDCardRequired').val()=='true')
					{
						initCocoAPI();
					}
				}				
				else if($('#cameraCompulsory').val()=='true')
				{
					pauseTimer();
					$('div.questions-area, div.palette').hide();
					$('#msgModalLoader').attr('data-msgmodalbodytext',$('#webCamMust').val());
					$('#msgModalLoader').attr('data-footerbtn1text',"OK");
					$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
					
					triggerMsgLoader('on',function () {    	
						triggerMsgLoader('off');
						window.location.href = '../candidateModule/homepage?changeLocale';
				    });
				}
				else
				{
					triggerMsgLoader('off',undefined, undefined);
					$('#camPrcd').attr('disabled', false);
					$('#preSec').hide();
					$('#takeCE').hide();
					$('#takeID').hide();
				}
			}, undefined);
					
		}
		
//		if($('#captureScreenShot').val() == 'true' && navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
//		{
//			js.startEvidenceCapture();
//			triggerMsgLoader('off',undefined, undefined);
//			$("#examPage").show();
//			adjustHeight();
//			$('#QuestionContainer').prop("src","").prop("src", $('#frmLink').val());
//		}	
	}
	else
	{
		triggerMsgLoader('off',undefined, undefined);
		$("#examPage").show();
		adjustHeight();
		$('#QuestionContainer').prop("src","").prop("src", $('#frmLink').val());
	}
}


async function acceptScreenSharing()
{	
		var result = false;		
		await startScreenCapture();
		result = await checkScreenSharingOnWithRequiredSource();		
		if(result==true){
			//closing the initalize exam environment popup on successful screen sharing
        	if($('#captureCameraImage').val() == 'false'){
        		triggerMsgLoader('off',undefined, undefined);	
        	}
			isScreenSharingOn = true;
			if(typeof onScreenSharingStreamEjected === "function")
			{
				videoScreenElem.srcObject.getVideoTracks()[0].addEventListener('ended', onScreenSharingStreamEjected);
			}
			$('#msgModalScreenShare').modal('hide');
			isPopupOn = false;
		}
		else if(result==false){
			throwOutSinceScreenNotShared();
		}
		
		
}



function denyScreenSharing()
{
	isPopupOn = false;
	throwOutSinceScreenNotShared();
}
	
	


function onLiveStreamStarted()
{
	setInterval(function() {ImgCpture('c');}, parseInt($('#cameraImageCaptureInterval').val()) * 1000);
	setInterval(ImgUpload, (parseInt($('#cameraImageCaptureInterval').val()) + 5) * 1000);
}

function onStreamEjected()
{
	pauseTimer();
	$('div.questions-area, div.palette').hide();
//	if($('#captureScreenShot').val() == 'true' && navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
//	{
//		js.stopEvidenceCapture();
//	}
	if($('#captureScreenShot').val() == 'true')
	{
		clearInterval(screenshotInterval);		
	}
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#webCamReconnect').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
    triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale'
    });
}

function onCamError()
{
	if($('#camPage').is(':visible'))
	{
		$('#camPrcd').attr('disabled', true);
		if($('#captureCameraImage').val() == 'true' && window.deviceInfos != 'undefined' && window.deviceInfos.length > 0 && window.deviceInfos.some(device => 'videoinput' === device.kind) && $('#videoSource > option[value=""]').length > 0)
		//if($('#captureCameraImage').val() == 'true')
		{
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#browserAllowToCamera').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
		    triggerMsgLoader('on',function () 
			{    	
				triggerMsgLoader('off');
		    });
		}
		else
		{
			$('#camPage').hide();
			$("#examPage").show();
			adjustHeight();
			$('#QuestionContainer').prop("src","").prop("src", $('#frmLink').val());
		}
		return;
	}
	if($('#examPage').is(':visible'))
	{
		pauseTimer();
		$('#examPage').hide();
//		if($('#captureScreenShot').val() == 'true' && navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
//		{
//			js.stopEvidenceCapture();	
//		}		
		if($('#captureScreenShot').val() == 'true')
		{			
			clearInterval(screenshotInterval);			
		}
		$('#msgModalLoader').attr('data-msgmodalbodytext',$('#webCamDisconnectedDuetoHalted').val());
		$('#msgModalLoader').attr('data-footerbtn1text',"OK");
		$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
		
	    triggerMsgLoader('on',function () {    	
			triggerMsgLoader('off');
			window.location.href = '../candidateModule/homepage?changeLocale';
	    });
		return;
	}
}

function onStreamStopped()
{
	$('#camPrcd').attr('disabled', true);
//	if($('#captureScreenShot').val() == 'true' && navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
//	{
//		js.stopEvidenceCapture();	
//	}
	if($('#captureScreenShot').val() == 'true')
	{		
		clearInterval(screenshotInterval);		
	}
}

function onSBEvidenceError()
{
	pauseTimer();
	$('div.questions-area, div.palette').hide();
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#internalBrowserError').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
    triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale';
    });
}


function skipThis(){
	/*if(!isPopupOn){
		$('#QuestionContainer').contents().find('#onSkipModalBodyText').html($('#onSkipWarningMsg').val());
		$('#QuestionContainer').contents().find('#onSkipWarningModal').css('display','block');
		isPopupOn=true;
	}
	else{
		return false;
	}*/
	if(!isPopupOn){
		isPopupOn=true;
		$('#msgModalLoader',window.parent.document).attr('data-msgmodalbodytext',$('#onSkipWarningMsg').val());
		$('#msgModalLoader',window.parent.document).attr('data-footerbtn1text','Yes');
		$('#msgModalLoader',window.parent.document).attr('data-footerbtn2text','No');
		$('#msgModalLoader',window.parent.document).attr('data-footerbtn1class','btn btn-success');
		$('#msgModalLoader',window.parent.document).attr('data-footerbtn2class','btn btn-red');
		
	    window.parent.triggerMsgLoader('on',function () {
	    	window.parent.runThis('Skip');
	    },function () {   
	    	window.parent.noSkip();	
	    });
	} else {
		return false;
	}
    
}

function noSkip(){
	triggerMsgLoader('off',undefined, undefined);
	isPopupOn=false;
	return false;
}
 
function runThis(action,dualRecn){
	captureEvidence(action,dualRecn);
	 
	if(action != 'Save' && $('#QuestionContainer').contents().find('#itype').val() == 'CMPSMQT')
	{
		var nxtel = $('#QuestionContainer').contents().find('a[id^=Sublnk].current').next('a[id^=Sublnk]');
		if(nxtel.length > 0)
		{
			$('#QuestionContainer').contents().find('#cursubitemID').val($(nxtel).data('subqid'));
			$('#QuestionContainer').contents().find('#hidExt').val('loadCMPSMQTSubItem'); 
		}
		else
		{
			$('#QuestionContainer').contents().find('#hidExt').val('Skip'); 
		}
	}
	else if(action != 'Save')
	{
		$('#QuestionContainer').contents().find('#hidExt').val('Skip'); 
	}
	if($('#QuestionContainer').contents().find('#itype').val() == 'EW' && action == 'Save')
	{	
	
	//if(!($('#QuestionContainer').contents().find('#ansfile').get(0).files.length === 0)) //if some file is selected for uploading
	var fileList = dualRecn.selectedFiles;
	if(!(fileList === undefined))
	{
		//var fileList = $('#QuestionContainer').contents().find('#ansfile').get(0).files;
		var ansFileNames='';
		var examVenueCode = $('#vc',window.parent.document).val();
		var candidateId = $('#ci',window.parent.document).val();
		var candidateExamID = $('#QuestionContainer').contents().find('#candidateExamID').val();
		var candidateExamItemID = $('#QuestionContainer').contents().find('#candidateExamItemID').val();
		
		for(var i=0; i<fileList.length; i++){
			var file = fileList[i];
			var filename = file.name;
			var extension = filename.substring(filename.lastIndexOf('.')+1, filename.length).toLowerCase();	
			var val = examVenueCode + '_' + candidateId + '_' + candidateExamID + '_' + candidateExamItemID +'_' + (i+1) + '.' + extension;
			ansFileNames =ansFileNames+','+val ;
			}
		
		$('#QuestionContainer').contents().find('#answerfilename').val(ansFileNames.substring(1));
	}
	else
	{
		
		$('#QuestionContainer').contents().find('#answerfilename').val($('#QuestionContainer').contents().find('#savedAnswerFileName').val());
	}

	$('#QuestionContainer').contents().find('#saveEW').val('1');
	}
	$('#QuestionContainer').contents().find('#frmQues').submit();
  	return true;
}

function captureEvidence(action,dualRecn){
	if(action=='Save')
	{
		processImage('ssisb',0,dualRecn);
		processImage('csisb',0,null);
	}
	else if(action=='Skip')
	{
		processImage('ssisk',0,null);
		processImage('csisk',0,null);
		triggerMsgLoader('off',undefined, undefined);
		isPopupOn=false;
	}
	else if(action=='Reset')
	{
		processImage('ssirst',0,dualRecn);
		processImage('csirst',0,null);
		triggerMsgLoader('off',undefined, undefined);
		isPopupOn=false;
	}
}

function processImage(evidenceType, fc_len,dualRecn) {
	var toProcessImage = ((isCamConnected == true || $('#captureScreenShot').val() == 'true') ? true : false);
	if(toProcessImage == true){
		try
		{
			var base64 = '';
			var height = 0;
			var width = 0;
			var data='';
			
			if(evidenceType=='c' || evidenceType=='csisk' || evidenceType=='csisb' || evidenceType=='cswmf' || evidenceType=='cswnf' || evidenceType=='csc' || evidenceType=='cswfo' || evidenceType=='cswp' || evidenceType=='csidc' || evidenceType=='csirst')
			{
				base64 = getImageFromVideoAsBase64('image/jpeg', document.querySelector("video#livecam"));
				if(evidenceType=='csc' || (base64 == "data:," && !$('#examPage').is(':visible')))
				{
					base64 = getImageFromVideoAsBase64('image/jpeg', document.querySelector("video#previewCam"));
				}
			}
			else
			{
				base64 = getImageFromVideoAsBase64ForScreenshot('image/jpeg', document.querySelector("video#videoScreen"));
			}
			if(base64 != null && model != null)
			{
				var img = document.createElement("IMG");
				loadImage(base64).then(img=>
				{		
					if(evidenceType=='c' || evidenceType=='s' || evidenceType=='csisk' || evidenceType=='csisb' || evidenceType=='cswmf' || evidenceType=='cswnf' || evidenceType=='cswfo' || evidenceType=='csc' || evidenceType=='cswp' || evidenceType=='csidc' || evidenceType=='csirst')
					{
						if(evidenceType=='csidc')
						{
							height = img.height;
							width = img.width;
						}else{
							height = 300;
							width = 300;
						}
					}
					else if(evidenceType=='ssisk' || evidenceType=='ssisb' || evidenceType=='sswmf' || evidenceType=='sswnf' || evidenceType=='sswfo' || evidenceType=='ssc' || evidenceType=='sswp' || evidenceType=='ssirst')
					{
						height = (ssRes * img.height)/100;
						width = (ssRes * img.width)/100;
					}
					var canvas = document.createElement('canvas');
					canvas.width = width;
					canvas.height = height+20;
					var ctx = canvas.getContext('2d');		
					//ctx.drawImage(img, 0, 0, width, height);
					if(evidenceType=='csidc'){
						
					ctx.filter = 'contrast(1.6 ) brightness(1.1) saturate(1.4) ';
					ctx.drawImage(img,l1-5,t1-5,w1+10,h1+10,0,0,img.width,img.height);
					}else
					{
						ctx.drawImage(img, 0, 0, width,height);
					}
					
					ctx.font = "10pt Arial";
					ctx.fillStyle = "White";
					
					/*var options = {
					  year: 'numeric',
					  month: '2-digit',
					  day: '2-digit',
					  hour: '2-digit',
					  minute: '2-digit',
					  second: '2-digit',
					  hour12: true
					};
					var dt = new Date().toLocaleString('en-IN', options).replace(',',' ');*/
					ctx.fillText(sdt, 0, height+15);						
					
					ctx.font = "10pt Arial";
					ctx.fillStyle = "White";
					
					if(evidenceType == "sswnf" || evidenceType == "sswmf" || evidenceType == "cswnf" || evidenceType == "cswmf")
					{
						ctx.beginPath();
						ctx.lineWidth = "5";
						ctx.strokeStyle = "orange";
						ctx.rect(2, 2, width-4, height-5);
						ctx.stroke();
					}
					if(evidenceType == "c" && (fc_len == 0 || fc_len > 1))
					{
						ctx.beginPath();
						ctx.lineWidth = "5";
						if(fc_len == 0)
						{
							ctx.strokeStyle = "red";
						}	
						
						if(fc_len > 1)
						{
							ctx.strokeStyle = "blue";
						}
						ctx.rect(2, 2, width-4, height-5); 
						ctx.stroke(); 
					}	
					var exif = {};
					
					
					var iid=$('#QuestionContainer').contents().find('#curitemID').val();
					itype=$('#QuestionContainer').contents().find('#itype').val()
					
					
					var refkey1=$('#refKey1').val(),refkey2=$('#refKey2').val(),refkey3=$('#refKey3').val(),refkey4=$('#refKey4').val(),refkey5=$('#refKey5').val(),refkey6=$('#refKey6').val(),refkey7=$('#refKey7').val(),refkey8=$('#refKey8').val(),refkey9=$('#refKey9').val(),refkey10=$('#refKey10').val();
					var partnerId=$('#partnerId').val();
					if(partnerId==0){
						if(iid==null || iid=='')
						{
							iid=0;
						}
						if(evidenceType=='c' || evidenceType=='s' || evidenceType=='csc' || evidenceType=='ssc' || evidenceType=='csidc')
						{
							data = `ty=`+evidenceType+`,fc=${fc_len},bl=0,wh=0,vc=${$('#vc').val()},vi=${$('#vi').val()},cc=${$('#cc').val()},ci=${$('#ci').val()},ei=${$('#ei').val()},pi=${$('#pi').val()},ef=e,ts=${sdt}`;
						}
						else if(evidenceType=='ssisb' || evidenceType=='ssirst'){ //for itemsave candidateAnswer
							data = `ty=`+evidenceType+`,fc=${fc_len},bl=0,wh=0,vc=${$('#vc').val()},vi=${$('#vi').val()},cc=${$('#cc').val()},ci=${$('#ci').val()},ei=${$('#ei').val()},pi=${$('#pi').val()},ef=e,ts=${sdt},iid=${iid},oid=${dualRecn.options},ceid=${$('#ceid').val()},subiid=${dualRecn.subItemid},ceiid=${dualRecn.ceiid},itype=${itype},typedTxt=${dualRecn.typedText},cmpsData=${dualRecn.dataofCMPS},subTypeCMPSMQT=${dualRecn.subItemTypeofCMPSMQT}`;
						}
						else{// with ItemID
							data = `ty=`+evidenceType+`,fc=${fc_len},bl=0,wh=0,vc=${$('#vc').val()},vi=${$('#vi').val()},cc=${$('#cc').val()},ci=${$('#ci').val()},ei=${$('#ei').val()},pi=${$('#pi').val()},ef=e,ts=${sdt},iid=${iid}`;
						}
					}else{
						/*
							pti (Partner ID): Identifies the Partner platform where the image is captured, such as ExamLive, ERA, or SOLAR.
							ty (Evidence Type): Indicates the type of evidence captured, distinguishing between a Camshot (c) and a Screenshot (s).
							fc (Face Count): Represents the number of faces detected in the image.
							bl (Black Color %): Indicates the percentage of black color in the image.
							wh (White Color %): Represents the percentage of white color in the image.
							ef (Exam Type): Specifies the type of academic activity associated with the image, such as Challenge (c), Assignment (a), or Exam (e).
							ts (Date Time Stamp): Refers to the date and time when the image was captured, formatted as d/M/yyyy hh:mm:ss tt.
							refKey to refKey10 would set third party application
						*/
						data = `ty=`+evidenceType+`,fc=${fc_len},bl=0,wh=0,ef=e,ts=${sdt},refkey1=${refkey1},refkey2=${refkey2},refkey3=${refkey3},refkey4=${refkey4},refkey5=${refkey5},refkey6=${refkey6},refkey7=${refkey7},refkey8=${refkey8},refkey9=${refkey9},refkey10=${refkey10},pti=${partnerId}`;
					}
					
					
					exif[piexif.ImageIFD.XPKeywords] = toUTF8Array(data);
					var exifObj = {"0th":exif};
					var exifStr = piexif.dump(exifObj);
					img.src = piexif.insert(exifStr, canvas.toDataURL('image/jpeg'));
					img.setAttribute('data-vc', `${$('#vc').val()}`);
					img.setAttribute('data-ei', `${$('#ei').val()}`);
					img.setAttribute('data-pi', `${$('#pi').val()}`);
					img.setAttribute('data-us', '0');
					
					
					
					var refkeys = [refkey1, refkey2, refkey3, refkey4, refkey5, refkey6, refkey7, refkey8, refkey9, refkey10];
					
					var refKeyStr = refkeys.filter(refkey => refkey !== null).join('/');
					
					if(partnerId==0 && (evidenceType=='c' || evidenceType=='s')){
					
								img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/${$('#ei').val()}/${$('#vc').val()}/${$('#pi').val()}/Thumbnails`);
							
					}else if(partnerId==0){
						if(evidenceType=='cswmf' || evidenceType=='cswnf' || evidenceType=='sswmf' || evidenceType=='sswnf' || evidenceType=='cswfo' || evidenceType=='sswfo' || evidenceType=='cswp' || evidenceType=='sswp')
						{
							img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/${$('#ei').val()}/${$('#vc').val()}/${$('#pi').val()}/Warnings`);
						}
						else if(evidenceType=='csisk' || evidenceType=='csisb' || evidenceType=='ssisk' || evidenceType=='ssisb' || evidenceType=='ssirst')
						{
							img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/${$('#ei').val()}/${$('#vc').val()}/${$('#pi').val()}/Item`);
						}
						else if(evidenceType=='csc' || evidenceType=='ssc' || evidenceType=='csidc' )
						{
							if(evidenceType!='csidc'){
								img.setAttribute('data-btn', '1'); // data-btn value 1 means capture photo, 2 means capture id card
							}else{
								img.setAttribute('data-btn', '2');
							}
							img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/${$('#ei').val()}/${$('#vc').val()}/${$('#pi').val()}/Candidate`);
						}
					}else{
						img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/pti=${partnerId}/${refKeyStr}/Thumbnails`);
					}
					
					if(partnerId!=0 && (evidenceType=='c' || evidenceType=='s')){
					
						img.id = `bci_${refkey1}_${new Date().getTime()}.jpg`;
					}else{
						img.id = `bci_${$('#cc').val()}_${new Date().getTime()}.jpg`;
					}
					
					if(evidenceType=='c' || evidenceType=='csisk' || evidenceType=='csisb' || evidenceType=='cswmf' || evidenceType=='cswnf' || evidenceType=='csc' || evidenceType=='cswfo' || evidenceType=='cswp' ||evidenceType=='csidc' || evidenceType=='csirst')
					{
						$('#upldArea').append(img);
					}
					else{
						$('#upldAreaScreenShot').append(img);
					}
					img.onload=null;
					img = null;	
				})
			}
		}
		catch(e)
		{
			//ignore
		}
	}
}

function loadImage(url) {
        return new  Promise(resolve => {
            const image = new Image();
            image.addEventListener('load', () => {
                resolve(image);
            });
            image.src = url; 
        });
}
//Piyusha

async function ImgCpture(et)
{
	var showMultiFaceNoFacePopup=$("#showMultiFaceNoFacePopup").val();
	var base64 = getImageFromVideoAsBase64('image/jpeg', document.querySelector("video#livecam"));
	if(et=='csc' || base64 == "data:,")
	{
		base64 = getImageFromVideoAsBase64('image/jpeg', document.querySelector("video#previewCam"));
	}
	if(base64 != null && model != null)
	{
		var img = document.createElement("IMG");
		img.src = base64;			
		img.onload = async() =>
		{
			const predictions = await model.estimateFaces(img, false);
			var fc_len = predictions.length;
			if(fc_len == 0)
			{
				processImage('cswnf', fc_len,null);
				if(showMultiFaceNoFacePopup=='true' && !isPopupOn)
				{
					$('#msgModalLoader').attr('data-msgmodalbodytext',$('#NoFaceWarningMsg').val());
					$('#msgModalLoader').attr('data-footerbtn1text',"OK");
					$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
					triggerMsgLoader('on',function () {    	
						triggerMsgLoader('off');
						if($('#captureScreenShot').val() == 'true'){
							processImage('sswnf',0,null);
						}
			    	});
				}
			}
			else if(fc_len > 1)
			{
				processImage('cswmf', fc_len,null);
				if(showMultiFaceNoFacePopup=='true' && !isPopupOn)
				{
					$('#msgModalLoader').attr('data-msgmodalbodytext',$('#MultiFaceWarningMsg').val());
					$('#msgModalLoader').attr('data-footerbtn1text',"OK");
					$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
					triggerMsgLoader('on',function () {    	
						triggerMsgLoader('off');
						if($('#captureScreenShot').val() == 'true'){
							processImage('sswmf',0,null);
						}
			    	});
				}
			}
			if(et=='csc' && (fc_len > 1 || fc_len == 0)){
				return;
			}else{
				processImage(et, fc_len,null);
			}
			
		}
	}
}

function DataURIToBlob(dataURI) 
{
    const splitDataURI = dataURI.split(',');
    const byteString = splitDataURI[0].indexOf('base64') >= 0 ? atob(splitDataURI[1]) : decodeURI(splitDataURI[1]);
    const mimeString = splitDataURI[0].split(':')[1].split(';')[0];

    const ia = new Uint8Array(byteString.length);
    for (let i = 0; i < byteString.length; i++)
        ia[i] = byteString.charCodeAt(i);

    return new Blob([ia], { type: mimeString });
}

function toUTF8Array(str) 
{
    let utf8 = [];
    for (let i = 0; i < str.length; i++) {
        let charcode = str.charCodeAt(i);
        if (charcode < 0x80) utf8.push(charcode);
        else if (charcode < 0x800) {
            utf8.push(0xc0 | (charcode >> 6),
                      0x80 | (charcode & 0x3f));
        }
        else if (charcode < 0xd800 || charcode >= 0xe000) {
            utf8.push(0xe0 | (charcode >> 12),
                      0x80 | ((charcode>>6) & 0x3f),
                      0x80 | (charcode & 0x3f));
        }
        // surrogate pair
        else {
            i++;
            // UTF-16 encodes 0x10000-0x10FFFF by
            // subtracting 0x10000 and splitting the
            // 20 bits of 0x0-0xFFFFF into two halves
            charcode = 0x10000 + (((charcode & 0x3ff)<<10)
                      | (str.charCodeAt(i) & 0x3ff));
            utf8.push(0xf0 | (charcode >>18),
                      0x80 | ((charcode>>12) & 0x3f),
                      0x80 | ((charcode>>6) & 0x3f),
                      0x80 | (charcode & 0x3f));
        }
    }
    return utf8;
}

async function initFaceAPI()
{	
	tf.setBackend('wasm').then(() => console.log('backend changed to wasm!!'));
	/*let img = new Image();
	img.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWP4////fwAJ+wP9CNHoHgAAAABJRU5ErkJggg==";
	await faceapi.nets.tinyFaceDetector.loadFromUri("../resources/weights");
	var det = await faceapi.detectAllFaces(img, new faceapi.TinyFaceDetectorOptions());*/
	model = await blazeface.load();
}

function ImgUpload()
{
		var uploadFor=0; //0 Other, 1 csc, 2 csidc
	$('#upldArea > img[data-us=0]').each(function()
	{
		// us values
		// 0 Not yet uploaded
		// -1 upload failed
		// 1 current upload
		var formData = new FormData();
		var imgUrl=null;
		var uploadFor=0; 

		formData.append('file', DataURIToBlob($(this).attr('src')), $(this).attr('id'));
	
		$(this).attr('data-us', '1');
		if( $(this).attr('data-btn')!=undefined && $(this).attr('data-btn')!=null && $(this).attr('data-btn')=='1'){
			imgUrl=$(this).attr('src');
			uploadFor=1;
		}else if($(this).attr('data-btn')!=undefined && $(this).attr('data-btn')!=null && $(this).attr('data-btn')=='2'){
			imgUrl=$(this).attr('src');
			uploadFor=2;
		}
		
		$.ajax({
		    url: $(this).data('upurl'), 
		    type: "POST", 
		    cache: false,
		    contentType: false,
		    processData: false,
		    data: formData})
	        .done(function(e)
			{
				if(e.includes("uploadStatus=true") == true)
				{
					if( uploadFor==1)
					{
						uploadedCCI=true;
						$("#capImg img").attr('src', imgUrl);
						$('#cmsg').show();	
						$("#capImg img").show();	
						$('#faceMaskOverlay').hide();
						$('#takeID').hide();
						$('#takeCE').attr('disabled',true);
						
						if($('#isIDCardRequired').val()=='true')	
						{
							$('#msgModalLoader').attr('data-msgmodalbodytext',$('#holdId').val());		
							$('#msgModalLoader').attr('data-footerbtn1text',"OK");		
							$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');		
								
						    triggerMsgLoader('on',function () 		
							{    			
								showIdCard();	
						    });
						}					
					  
					}
					else if(uploadFor==2)
					{
						$("#capId img").attr('src', imgUrl);
						uploadedCID=true;
						$("#capId img").show();	
						$('#takeID').show();
						$('#imsg').show();
						$('#camPrcd').attr('disabled',false);
						
					}
					
					$('#' + (e.split(',')[0].split('=')[1]).replace('.', '\\.')).remove();
				}
				else
				{
					$('#' + (e.split(',')[0].split('=')[1]).replace('.', '\\.')).attr('data-us','-1');
				}
	        })
			.fail(function(jqXHR, textStatu)
			{
				$('#upldArea > img[data-us=1]').attr('data-us','-1');;
			});
	});
}

function onPreviewStreamStarted()
{
	isPossibleVirtualCam(function(isVirtualCam)
	{
		if(isVirtualCam)
		{
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#staticImageShows').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
		    triggerMsgLoader('on',function () {    	
				triggerMsgLoader('off');
				window.location.href = '../login/logout';
		    });
		}
		else
		{
			//$('#faceMaskOverlay').width(($('video').width()-20));
			//$('#faceMaskOverlay').height(($('video').height()-20));
			$('#faceMaskOverlay').show();
			//onLiveStreamStarted();     //Piyusha
			//$('#camPrcd').attr('disabled', false);
		}
	});
}

function adjustHeight()
{
	var wHgt = $(window).height();
	var headerHgt = $('.header').outerHeight(true);
	
	var secHgt = $('.sections').outerHeight(true);

	var hdrIfoDiv = $('#HdrInfoDiv').outerHeight(true);
	
	var frameHgt = wHgt - headerHgt - hdrIfoDiv - $('div.footer').outerHeight() - secHgt + 10;
	// frameHeight = windowHeight - headerHeight - [2 brs] - sectionHeight - [other adjustments]
	$('.main-content .questions-area iframe, #instruction, #question, #profile').css({ height: frameHgt });
	
	var proHgt = $('.profile-timer').outerHeight();
	var tqHgt=0;
	$('.totalq').each(function(){
		if($(this).find('#Hdrttlcount').length==0)
		{
			tqHgt = tqHgt + $(this).outerHeight(true);				
		}
	});
	//var tqHgt = $('.totalq').outerHeight() + 10;// + [line-height of text for label (loads after height is calculated)] + [bottom margin]
	var actHgt = $('.palette .actions').outerHeight() + 20 + 10 + 10;// + [questionArea top + bottom padding] + [pallete bottom padding] + [pallete bottom margin]
	
	var qaHgt = wHgt - headerHgt - $('div.footer').outerHeight() - proHgt - tqHgt - actHgt;
	// questionAreaHeight = windowHeight - headerHeight - profileHeight - totalQuestionsHeight - palleteActionsHeight - [other adjustments]
	$('.exampage .palette .quick-ques').css({ height: qaHgt});
}
adjustHeight();

function getImageFromVideoAsBase64(format, video)
{
	if(window.stream && window.stream.active)
	{
		var canvas = document.createElement('canvas');
		canvas.width = video.videoWidth;
		canvas.height = video.videoHeight;
		canvas.getContext('2d').drawImage(video, 0, 0);
		return canvas.toDataURL(format);	
	}
	return null;
}

function userAwayFromExamScreen(activeElementTagName)
{
	console.log(activeElementTagName);
	if($('#examPage').is(':visible') && $('#evidencePackageType').val() > '0') 
	{
		triggerMsgLoader('off');
		setTimeout(function()
		{
			pauseTimer();
			$('div.questions-area, div.palette').hide();
			$('#msgModalLoader').attr('data-msgmodalbodytext',$('#awayFromExam').val());
			$('#msgModalLoader').attr('data-footerbtn1text',"OK");
			$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
			
	    	triggerMsgLoader('on',function () {    	
	    		triggerMsgLoader('off');
	    		setTimeout(function()
				{
					window.location.href = '../login/logout';
				}, 2000);
	    	});
		}, 300);
		setTimeout(function()
		{ 
			processImage('cswfo',0,null);
		   	processImage('sswfo',0,null);
		   	ImgUploadScreenShot();
		   	ImgUpload();
		}, 600);
	}
}



function onScreenSharingStreamEjected()
{	
	isScreenSharingOn=false;
	
	ImgUploadScreenShot(); //calling this method before throwing out of exam so as to try and upload any pending screenshots to be uploaded
	pauseTimer();
	$('div.questions-area, div.palette').hide();
	$('#msgModalLoader').attr('data-msgmodalbodytext',$('#ifScreenSharingStop').val());
	$('#msgModalLoader').attr('data-footerbtn1text',"OK");
	$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
	
	triggerMsgLoader('on',function () {    	
		triggerMsgLoader('off');
		window.location.href = '../candidateModule/homepage?changeLocale';
    });
	

}

// declared this function separately for screenshot since it should not use the check for window.stream which is applicable for webcam implementation 
function getImageFromVideoAsBase64ForScreenshot(format, video)
{	
		var canvas = document.createElement('canvas');
		canvas.width = video.videoWidth;
		canvas.height = video.videoHeight;
		canvas.getContext('2d').drawImage(video, 0, 0);
		return canvas.toDataURL(format);	
}


async function ImgCptureScreenShot(et)
{
	if($('#examPage').is(':visible'))		
	{
		processImage('s',0,null);
	}
	else if(et=='ssc'){
		processImage('ssc',0,null);
	}
}
	

function ImgUploadScreenShot()
{	
	$('#upldAreaScreenShot > img[data-us=0]').each(function()
	{
		// us values
		// 0 Not yet uploaded
		// -1 upload failed
		// 1 current upload
		var formData = new FormData();
		formData.append('file', DataURIToBlob($(this).attr('src')), $(this).attr('id'));
		$(this).attr('data-us', '1');
		$.ajax({
		    url: $(this).data('upurl'), 
		    type: "POST", 
		    cache: false,
		    contentType: false,
		    processData: false,
		    data: formData})
	        .done(function(e)
			{
				if(e.includes("uploadStatus=true") == true)
				{
					uploadedCSI=true;// check here only set true when et is ssc is uploaded
					$('#' + (e.split(',')[0].split('=')[1]).replace('.', '\\.')).remove();
				}
				else
				{
					$('#' + (e.split(',')[0].split('=')[1]).replace('.', '\\.')).attr('data-us','-1');
				}
	        })
			.fail(function(jqXHR, textStatu)
			{
				$('#upldAreaScreenShot > img[data-us=1]').attr('data-us','-1');;
			});
	});	
}


function checkScreenSharedAndCaptureScreenShot(et){	
	if(!isScreenSharingOn){				
		ImgUploadScreenShot(); //calling this method before throwing out of exam so as to try and upload any pending screenshots to be uploaded
		pauseTimer();
		$('div.questions-area, div.palette').hide();
		$('#msgModalLoader').attr('data-msgmodalbodytext',$('#screenSharingStop').val());
		$('#msgModalLoader').attr('data-footerbtn1text',"OK");
		$('#msgModalLoader').attr('data-footerbtn1class','btn btn-error');
		
		triggerMsgLoader('on',function () {    	
			triggerMsgLoader('off');
			window.location.href = '../candidateModule/homepage?changeLocale';
	    });
		
	}					
	else{
		ImgCptureScreenShot(et);
	}
}


function onScreenSharingStarted()
{
	// enable the Proceed button once screen sharing is started
	/*if($('#captureScreenShot').val() == 'true' || $('#captureCameraImage').val() == 'false'){
		$('#camPrcd').attr('disabled', false);	
	}*/	
	screenshotInterval = setInterval(function() {checkScreenSharedAndCaptureScreenShot('s');}, parseInt($('#screenShotCaptureInterval').val()) * 1000);
	setInterval(ImgUploadScreenShot, (parseInt($('#screenShotCaptureInterval').val()) + 5) * 1000);
}

function onPreviewLiveStreamStarted()		
{		
	ImgCpture('csc');		
	ccsInterval = setInterval(ImgUpload, 100);		
}		
function onPreviewScreenSharingStarted()		
{		
	checkScreenSharedAndCaptureScreenShot('ssc');		
	cssInterval = setInterval(ImgUploadScreenShot, 100);		
}

function proceedBtnEnable() {		
	if(!pbe && $('#captureScreenShot').val() == 'true' && $('#captureCameraImage').val() == 'true' && uploadedCCI && uploadedCSI && ( $('#isIDCardRequired').val()=='true'  ? uploadedCID : true)){		
		$('#camPrcd').attr('disabled', false);		
		pbe=true;		
		clearInterval(pBtnInterval);		
		clearInterval(ccsInterval);		
		clearInterval(cssInterval);		
	} else if(!pbe && $('#captureScreenShot').val() == 'false' && $('#captureCameraImage').val() == 'true' && uploadedCCI && ( $('#isIDCardRequired').val()=='true' ? uploadedCID : true)){		
		$('#camPrcd').attr('disabled', false);		
		pbe=true;		
		clearInterval(pBtnInterval);		
		clearInterval(ccsInterval);			
	}else if(!pbe && $('#captureScreenShot').val() == 'true' && $('#captureCameraImage').val() == 'false' && uploadedCSI){		
		$('#camPrcd').attr('disabled', false);		
		pbe=true;		
		clearInterval(pBtnInterval);			
		clearInterval(cssInterval);		
	}
		
	if(pbe){	
		$('#takeCE').attr('disabled', true);	
	}	
}

async function initCocoAPI()
{
	cocoSsd.load().then(function (loadedModel) {
		modelCoco = loadedModel;
	});
	video = document.querySelector("video#previewCam");
	
}

function showIdCard()
{
	$('#camPrcd').attr('disabled', true);	
	triggerMsgLoader('off');
	$('#faceMaskOverlay').hide();
	$("#capId img").hide();
	$("#capId img").attr('src', '');
	retakeIdc=true;
	uploadedCID=false;
	$('#imsg').hide();
	pbe=false;
	pBtnInterval=setInterval(proceedBtnEnable, 100);
	predictWebcam();
	
}

function predictWebcam() 
{
	if(retakeIdc)	
	{
   		modelCoco.detect(video).then(function (predictions) {
	    for (let n = 0; n < predictions.length; n++) {
	      if (predictions[n].score > 0.80) {
			console.log("outer : "+predictions[n].class);
	    	if(predictions[n].class=='book' || predictions[n].class=='microwave' || predictions[n].class=='refrigerator') 
	    	{
				retakeIdc=false;
				console.log("type : "+predictions[n].class);
		      	const highlighter = document.createElement('div');
		        highlighter.setAttribute('class', 'highlighter');
		        highlighter.style = 'left: 325px; top: 356px; width: 275px; height: 192px; position: absolute;';
		    
		l1=predictions[n].bbox[0];	
		t1=predictions[n].bbox[1];
		w1=predictions[n].bbox[2];	
		h1=predictions[n].bbox[3];
		        vidDiv.appendChild(highlighter);
		        children.push(highlighter);
		        
		        onPreviewLiveStreamIDCapture();
		        $('.highlighter').remove();
      	 	}//book
   		 }//loop
   	 	}// Call this function again to keep predicting when the browser is ready.
    	window.requestAnimationFrame(predictWebcam);
 	 });
  }
}

function onPreviewLiveStreamIDCapture()		
{		
	processImage('csidc',0,null);		
	csidcInterval = setInterval(ImgUpload, 100);		
}

function captureEvidenceOfPractical(action,itemID){

	if(action=='Save')
	{
		processImageOfPractical('ssisb',0,itemID);
		processImageOfPractical('csisb',0,itemID);
	}	
}

function processImageOfPractical(evidenceType, fc_len,itemID) {
	var toProcessImage = ((isCamConnected == true || $('#captureScreenShot').val() == 'true') ? true : false);
	if(toProcessImage == true){
		try
		{
			var base64 = '';
			var height = 0;
			var width = 0;
			var data='';
			var dualRecn = null;
			
			if(evidenceType=='csisb')
			{
				base64 = getImageFromVideoAsBase64('image/jpeg', document.querySelector("video#livecam"));
				if((base64 == "data:," && !$('#examPage').is(':visible')))
				{
					base64 = getImageFromVideoAsBase64('image/jpeg', document.querySelector("video#previewCam"));
				}
			}
			else
			{
				base64 = getImageFromVideoAsBase64ForScreenshot('image/jpeg', document.querySelector("video#videoScreen"));
			}
			if(base64 != null && model != null)
			{
				var img = document.createElement("IMG");
				loadImage(base64).then(img=>
				{		
					if(evidenceType=='csisb')
					{						
							height = 300;
							width = 300;
						
					}
					else if(evidenceType=='ssisb')
					{
						height = (ssRes * img.height)/100;
						width = (ssRes * img.width)/100;
					}
					var canvas = document.createElement('canvas');
					canvas.width = width;
					canvas.height = height+20;
					var ctx = canvas.getContext('2d');		
					//ctx.drawImage(img, 0, 0, width, height);
					if(evidenceType=='csidc'){
						
					ctx.filter = 'contrast(1.6 ) brightness(1.1) saturate(1.4) ';
					ctx.drawImage(img,l1-5,t1-5,w1+10,h1+10,0,0,img.width,img.height);
					}else
					{
						ctx.drawImage(img, 0, 0, width,height);
					}
					
					ctx.font = "10pt Arial";
					ctx.fillStyle = "White";										
					ctx.fillText(sdt, 0, height+15);						
					
					ctx.font = "10pt Arial";
					ctx.fillStyle = "White";
															
					var exif = {};
										
					//var iid=$('#QuestionContainer').contents().find('#curitemID').val();
				//	itype=$('#QuestionContainer').contents().find('#itype').val();
				
					var iid=itemID;
					itype='PRT';
					if(iid==null || iid=='')
					{
						iid=0;
					}
					
					if(evidenceType=='ssisb'){ //for itemsave candidateAnswer
						//data = `ty=`+evidenceType+`,fc=${fc_len},bl=0,wh=0,vc=${$('#vc').val()},vi=${$('#vi').val()},cc=${$('#cc').val()},ci=${$('#ci').val()},ei=${$('#ei').val()},pi=${$('#pi').val()},ef=e,ts=${sdt},iid=${iid},oid=${dualRecn.options},ceid=${$('#ceid').val()},subiid=${dualRecn.subItemid},ceiid=${dualRecn.ceiid},itype=${itype},typedTxt=${dualRecn.typedText},cmpsData=${dualRecn.dataofCMPS},subTypeCMPSMQT=${dualRecn.subItemTypeofCMPSMQT}`;
						data = `ty=`+evidenceType+`,fc=${fc_len},bl=0,wh=0,vc=${$('#vc').val()},vi=${$('#vi').val()},cc=${$('#cc').val()},ci=${$('#ci').val()},ei=${$('#ei').val()},pi=${$('#pi').val()},ef=e,ts=${sdt},iid=${iid},ceid=${$('#ceid').val()},itype=${itype}`;
					}
					else{// with ItemID
						data = `ty=`+evidenceType+`,fc=${fc_len},bl=0,wh=0,vc=${$('#vc').val()},vi=${$('#vi').val()},cc=${$('#cc').val()},ci=${$('#ci').val()},ei=${$('#ei').val()},pi=${$('#pi').val()},ef=e,ts=${sdt},iid=${iid}`;
					}
					exif[piexif.ImageIFD.XPKeywords] = toUTF8Array(data);
					var exifObj = {"0th":exif};
					var exifStr = piexif.dump(exifObj);
					img.src = piexif.insert(exifStr, canvas.toDataURL('image/jpeg'));
					img.setAttribute('data-vc', `${$('#vc').val()}`);
					img.setAttribute('data-ei', `${$('#ei').val()}`);
					img.setAttribute('data-pi', `${$('#pi').val()}`);
					img.setAttribute('data-us', '0');
									
					 if(evidenceType=='csisb' || evidenceType=='ssisb' )
					{
						img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/${$('#ei').val()}/${$('#vc').val()}/${$('#pi').val()}/Item`);
					}
					else
					{
						img.setAttribute('data-upurl', `${$('#evurl').val()}FileUploader/uploadEvidences/${$('#ei').val()}/${$('#vc').val()}/${$('#pi').val()}/Thumbnails`);
					}
					img.id = `bci_${$('#cc').val()}_${new Date().getTime()}.jpg`;
					if(evidenceType=='csisb')
					{
						$('#upldArea').append(img);
					}
					else{
						$('#upldAreaScreenShot').append(img);
					}
					img.onload=null;
					img = null;	
				})
			}
		}
		catch(e)
		{
			//ignore
		}
	}
	
}

function saveReportedItem(selectedClaimKey,selectedClaimText) {
document.getElementById('QuestionContainer').contentDocument.getElementById('spanReportingQuestion').style.display = 'block';
$('#inpSelectedClaimKey').val(selectedClaimKey);
    var item = {        
        fkCandidateExamID: document.getElementById("ceid").value ,
        fkCandidateExamItemID: document.getElementById('QuestionContainer').contentDocument.getElementById('candidateExamItemID').value,
        fkItemID: document.getElementById('QuestionContainer').contentDocument.getElementById('fkItemID').value,
        fkParentItemID: document.getElementById('QuestionContainer').contentDocument.getElementById('fkParentItemID') ? document.getElementById('QuestionContainer').contentDocument.getElementById('fkParentItemID').value : null,
        claimCode:selectedClaimKey,
        createdBy: document.getElementById("ci").value
    };

    $.ajax({
        url: '../exam/saveReportedItem',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(item)
    })
    .done(function(response) {             
        if (response === true) {        
        document.getElementById('QuestionContainer').contentDocument.getElementById('spanReportingQuestion').style.display = 'none';        
        document.getElementById('QuestionContainer').contentDocument.getElementById('divRIIcon').style.display = 'none';
        document.getElementById('QuestionContainer').contentDocument.getElementById('spanReportedItemSuccess').style.display = 'block';                
		var spanElement = document.getElementById('QuestionContainer').contentDocument.getElementById('spanReportedItemSuccess');				
		spanElement.textContent += ' ' + selectedClaimText;        
    } else {       
        document.getElementById('QuestionContainer').contentDocument.getElementById('spanReportingQuestion').style.display = 'none';
        document.getElementById('QuestionContainer').contentDocument.getElementById('spanReportingQuestionError').style.display = 'block';
    }
    })
    .fail(function(jqXHR, textStatus) {        
       document.getElementById('QuestionContainer').contentDocument.getElementById('spanReportingQuestion').style.display = 'none';
       document.getElementById('QuestionContainer').contentDocument.getElementById('spanReportingQuestionError').style.display = 'block';
    });
}
