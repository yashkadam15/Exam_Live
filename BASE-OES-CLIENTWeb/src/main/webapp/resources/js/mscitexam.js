 $(document).ready(function(){	
	 
	 if($('html').css('direction')=='ltr' && $('.scrollbar-outer').length>0)
	 {
	 $('.scrollbar-outer').scrollbar();
	 }
	if (navigator.userAgent.search('MOSB') == -1 && window.opener && !window.opener.closed) {
		window.opener.location.href = window.opener.location.href;
	}
	$('#time-text').trigger('updateDBTime');
	$('#hidOperations').hide();
	 
	$('a[id^=lnk]').click(function(e){
    	e.preventDefault(); 
    	$('#QuestionContainer').contents().find('#qtype').val($(this).data('qtype'));
    	$('#QuestionContainer').contents().find('#level').val($(this).data('level'));
    	$('#QuestionContainer').contents().find('#hidExt').val('loadItem');    		
        $('#QuestionContainer').contents().find('#hidFrmQues').submit(); 
        changeLevelCls($(this));
        
    });
	
	$('#qusInfoTable').bind('updateInfoTable',function(e){
		
			var td = $('tr[id=lvl'+$('.lvlbtn[data-active=1]').data('displaylvl')+']').find('.'+$('.lvlbtn[data-active=1]').data('qtype')+'-Atmpt');		
			$(td).text(parseInt($(td).text())+1);
			$(td).next('.'+ $('.lvlbtn[data-active=1]').data('qtype') + '-Remain').text(parseInt($(td).next('.'+ $('.lvlbtn[data-active=1]').data('qtype') + '-Remain').text())-1);
			$('#lvlSum').find('.'+ $('.lvlbtn[data-active=1]').data('qtype') + '-AtmptSum').text(parseInt($('#lvlSum').find('.'+ $('.lvlbtn[data-active=1]').data('qtype') + '-AtmptSum').text())+1);
			$('#lvlSum').find('.'+ $('.lvlbtn[data-active=1]').data('qtype') + '-RemainSum').text(parseInt($('#lvlSum').find('.'+ $('.lvlbtn[data-active=1]').data('qtype') + '-RemainSum').text())-1);		
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
	
	$('#endMSCITTest').click(function(e){
    	if($(this).hasClass("disabled"))
		{
    		e.preventDefault();
		}
    	else
		{
    		var ttlAtmpted = parseInt($('#lvlSum .OBJECTIVE-AtmptSum').text())+parseInt($('#lvlSum .PRACTICAL-AtmptSum').text());
    		var ttlQues=$('#ttlQues').text();
    		var remainingQues=ttlQues-ttlAtmpted;
    		$('#msgModalBodyText1').html($('#MSCITEndExamConfirm1').val().replace(/\^value1\^|\^value2\^/g, function findAndReplace(val){if(val == "^value1^"){return ttlAtmpted;} if(val == "^value2^"){return remainingQues;}}));
    		$('#modal-endMSCITTest1').modal('show');
    		
				return false;	   		
		}					
	});
	
	 $(function() {
		    $('#btnConfirm1').click(function(){
		        console.log(1);
		        $('#modal-endMSCITTest1').modal('hide');
		        $('#msgModalBodyText2').html($('#MSCITEndExamConfirm2').val());
		        $('#modal-endMSCITTest2').modal('show');
		    });
		});
	 
	 $(function() {
		    $('#btnConfirm2').click(function(){
		        console.log(1);
		        $('#modal-endMSCITTest2').modal('hide');
		        $('#msgModalBodyText3').html($('#MSCITEndExamConfirm3').val());
		        $('#modal-endMSCITTest3').modal('show');
		    });
		});
	 
	 $(function() {
		    $('#btnConfirm3').click(function(){
		        console.log(1);
		        $('#modal-endMSCITTest2').modal('hide');
		        $('#frmendTest').submit();
		    });
		});
	 
 }); //end doc ready

 function changeLevelCls(lvl) {	 
	
	 $('.lvlbtn[data-active=1]').removeClass('btn btn-red');
	 $('.lvlbtn[data-active=1]').addClass('btn btn-blue');
	 $('.lvlbtn[data-active=1]').attr('data-active',0);
	 
	 $(lvl).removeClass();
	 $(lvl).addClass('lvlbtn btn btn-red');
	 $(lvl).attr('data-active',1);	
	 if($(lvl).data('qtype')=='PRACTICAL')
		 {
		 console.log("called PRACTICAL ")
		 $('#ObjectiveInfo').hide();
		 $('#instrcutionInfo').hide();
		 
		 }
	 else
		 {
		 
		 $('#ObjectiveInfo').show();
		 $('#instrcutionInfo').show();
		 }
 }
 
 function triggerMsgLoader(action,btn1Click,btn2Click) 
 {
 	switch (action) {
     case 'on':
     case 'On':
     case 'ON':     
    	 console.log('called on');
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
    	 console.log('called off');
    	$('#msgModalLoader').attr('data-displaymodal','off');   
    	console.log('called off1');
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
     	console.log('called off2');
         break;
     default:
     	console.error('No action is defined for message modal.');	        	
 	} 	
 		
 }
 
 function savePRTQuestionAnswerandNext(answerStatus, answerJSONText)
 {	
	$('#QuestionContainer').contents().find('#prtAnswer').val(answerStatus);
	$('#QuestionContainer').contents().find('#prtAnswerTxt').val(answerJSONText);
 	$('#QuestionContainer').contents().find('#qtype').val($('.lvlbtn[data-active=1]').data('qtype'));
 	$('#QuestionContainer').contents().find('#level').val($('.lvlbtn[data-active=1]').data('level'));
 	//$('#QuestionContainer').contents().find('#hidExt').val('loadPracticalItem'); 
 	$('#qusInfoTable').trigger('updateInfoTable');
     $('#QuestionContainer').contents().find('#Save').click(); 
     /*changeLevelCls($(this));*/
 }
