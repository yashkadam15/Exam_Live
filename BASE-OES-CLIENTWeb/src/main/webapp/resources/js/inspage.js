
$(document).ready(function() 
{			

	var isMicrophoneAvailable = false;
	if($('#isVoiceRecordingEnabled').val() == 'true') {
		var isFirefox = typeof InstallTrigger !== 'undefined';
		
		if(isFirefox) {
			navigator.mediaDevices.getUserMedia({audio: true}).then( ( stream ) => {
	           // microphone available
	           isMicrophoneAvailable = true;
	      },
	      e => {
	           // microphone not available
	      });
		} else {
			isMicrophoneAvailable = true;
		}	
	}
	
	if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
	{
		js.getEventId($('#eventId').val());
	}

	if(isRIFORMItem== true)
	{				
		$("#proceed").prop('disabled',true);
	}			
	
	$(window).on('resize', function()
	{
		if($('#firstPage').is(':visible'))
		{
			adjustHeightOfFirstPage();
			return true;
		}
		
		if($('#secondPage').is(':visible'))
		{
			adjustHeightOfSecondPage();
			return true;
		}		
	});
	
	var pevnt = jQuery.Event('initPlayer');	
	pevnt.end = function()
	{	
		$("#AudioOk").prop('disabled',false);
		$("#AudioNotOk").prop('disabled',false);
	};
	
	$('#MMplayer_1').trigger(pevnt);
	
	$("#AudioOk").click(function()
	{
		$("#disclaimer").prop('disabled',false);
		$('#modal-MMplayer_1').modal('hide');
	});
	
	$("#instForm").hide();
	$("#instPrev").hide();
	
	$('input:checkbox').removeAttr('checked');

	$("#secondPage").hide();

	$('.declm p').contents().unwrap();
	
	$("#firstPage, #profileinfopage").show();
	adjustHeightOfFirstPage();
	
	$('#cancelTest').click(function(e) 
	{
		e.preventDefault();
		if (window.opener && !window.opener.closed) 
		{
			window.opener.location.href = $(this).attr('href');
			window.close();
		} 
		else
		{
			window.location.href = $(this).attr('href');
		}
	});

	$("#proceed").click(function() 
	{
		if (!$("#disclaimer").is(':checked')) 
		{					
			$("#intrAlertModal").modal({ backdrop: 'static', keyboard: true });
			$("#alertSpan").html("").html($('#ins_confirmlan').val());
			return false;
		}
		if ($("#disclaimer").is(':checked')) 
		{
			if ($("#language").val() == 0) {						
				$("#intrAlertModal").modal({ backdrop: 'static', keyboard: true });
				$("#alertSpan").html("").html($('#ins_chooselang').val());
				return false;
			}
		}
		
		if($('#isVoiceRecordingEnabled').val() == 'true' && !isMicrophoneAvailable) 
		{
			$("#microphoneAlertModal").modal({ backdrop: 'static', keyboard: true });
			$("#alertSpanMicrophone").html("").html($('#ins_confirmMicrophone').val());
			return false;
		}
	});

	//disable button second click
	$("#readyToBeginForm").on('submit', function() 
	{
		$("#proceed").prop('disabled', true);
		if($('#captureScreenShot').val() == 'true' && !isRIFORMItem && navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
		{					
			js.initEvidence($('#candidateCode').val(),parseInt($('#eventId').val()),parseInt($('#paperId').val()), "OES",parseInt($('#screenShotCaptureInterval').val()),$('#vc').val(), $('#captureScreenShot').val(), parseInt($('#candidateId').val()), parseInt($('#vi').val()));
		}
		if($("#paperType").val()=='DifficultyLevelWiseExam')
		{
		 	$(this).attr('action','../MSCITExam/TakeTest');
		}
	});
	
	//Reena : 20 Apr 2016 : Configure Web cam in case of RIFORM Item Type
	$("#configureWebCam").click(function(e) 
	{
		e.preventDefault();
		if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
		{
    		js.showRIFORMRecordingWindow(true, null, 0,"VIDEO","");
    	}
		else
		{
			$('#modal-examclientallowed').modal('show');
		}
	});
	
	$("#configureMic").click(function(e) 
	{
		e.preventDefault();
		if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined")
		{
    		js.showRIFORMRecordingWindow(true, null, 0,"AUDIO","");
    	}
		else
		{
			$('#modal-examclientallowed').modal('show');
		}
	});
	
	$("#configureAudio").click(function(e) 
	{
		e.preventDefault();
		$('#modal-MMplayer_1').modal('show');				
	});

	$('#instNext, #instPrev').click(function(e)
	{
		e.preventDefault();
		switch($(this).attr('id'))
		{
		case 'instNext':
			$("#firstPage").hide();
			$("#secondPage").show();
			$("#instForm").show();
			$("#instPrev").show();	
			adjustHeightOfSecondPage();
			break;
		case 'instPrev':
			$("#firstPage, #profileinfopage").show();
			$("#secondPage").hide();
			$("#instForm").hide();
			$("#instPrev").hide();
			adjustHeightOfFirstPage();
			break;
		}
	});
	
	// On Modal Close Take Microphone permissiom
	
	 $('#microphoneAlertModal').on('hidden.bs.modal', function (e) {
  		var isFirefox = typeof InstallTrigger !== 'undefined';
		
		if(isFirefox) {
			navigator.mediaDevices.getUserMedia({audio: true}).then( ( stream ) => {
	           // microphone available
	           isMicrophoneAvailable = true;
	      },
	      e => {
	           // microphone not available
	      });
		} else {
			isMicrophoneAvailable = true;
		}	
     })
	
});				

function onStreamStopped()
{
	$('#faceMaskOverlay').hide();
}

function adjustHeightOfFirstPage()
{
	var wHgt = $(window).height();
	var headerHgt = $('.header').outerHeight();
	
	var quesHgt = $('#firstPage .question').outerHeight();
	var btnHgt = $('#firstPage > .pull-right').outerHeight();
	
	var ansHgt = wHgt - headerHgt - 40 - quesHgt - 10 - btnHgt - $('div.footer').outerHeight() - 20 - 25 - 10;
	$('#firstPage .qanswer').css({ height: ansHgt });
}

function adjustHeightOfSecondPage()
{
	var wHgt = $(window).height();
	var headerHgt = $('.header').outerHeight();
	
	var quesHgt2 = $('#secondPage .question').outerHeight();
	var formHgt = $('#secondPage #readyToBeginForm').outerHeight();

	var ansHgt2 = wHgt - headerHgt - 40 - quesHgt2 - 10 - formHgt - $('div.footer').outerHeight() - 20 - 25 - 10;
	$('#secondPage .qanswer').css({ height: ansHgt2 });
}
