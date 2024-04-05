var x="";
var ExamDuration = 0;
var TimeSpent = 0;
var up;
var timerID = null;
var min1, sec1;
var cmin1, csec1, cmin2, csec2;
var updateCandTime=0;
var configUpdatetime = 60;
var isReady = false;

//Start by harshadd
var endExamEnable;
//End by harshadd

$(document).ready(function(){
	if ($('#updateElapsedTime').val()) 
	{
		configUpdatetime = $('#updateElapsedTime').val();
	}
	ExamDuration = parseInt($('#hidTtlDuration').val());
	endExamEnable = parseInt(((parseFloat($('#endExamEnablePercentage').val()) / 100) * ExamDuration) / 60);
	TimeSpent = $('#hidelapsedTimeDuration').val();
	x = $('#timeLeft').val();
	//Down();		
	RegEvent();
	isReady = true;
});

window.onbeforeunload = function()
{
    $('#time-text').trigger('updateDBTime');
}

function RegEvent()
{
	$('#time-text').bind('updateDBTime',function(e)
	{
		$.ajax('../commonExam/hidTops/'+TimeSpent, 
		{
		    dataType: 'json',
		    success: function (data,status,xhr) 
			{
		    },
		    error: function (jqXhr, textStatus, errorMessage) 
			{ 
				console.error('Error in time sync');
		    }
		});
	});	
}

function pauseTimer()
{
	clearTimeout(timerID);
	timerID = null;
	$('#time-text').trigger('updateDBTime');
	x = `${cmin2}:${csec2}`;
}

function resumeTimer()
{
	if(timerID == null)
	{
		Down();
	}
}

//Timer functions
function Minutes(data) {
    for (var i = 0; i < data.length; i++) if (data.substring(i, i + 1) == ":") break;
    return (data.substring(0, i));
}

function Seconds(data) {
    for (var i = 0; i < data.length; i++) if (data.substring(i, i + 1) == ":") break;
    return (data.substring(i + 1, data.length));
}

function Display(min, sec) {
    var disp;
    if (min <= 9) disp = " 0";
    else disp = " ";
    disp += min + ":";
    if (sec <= 9) disp += "0" + sec;
    else disp += sec;
    return (disp);
}

function Down() {
    //alert(x);
    //cmin2=1*Minutes(document.sw.beg2.value);
    cmin2 = 1 * Minutes(x);
    //csec2=0+Seconds(document.sw.beg2.value);
    csec2 = 0 + Seconds(x);
    ++csec2; //by zaheer 23-06-05
    timerID = setInterval(DownRepeat, 1000);
}

var flgshwd = false;
function DownRepeat() {

	//section check
	if($('a[id^=secNM][data-active=1]').next('[id^=secNM]').length > 0 && $('a[id^=secNM][data-active=1]').data('restrict') == true && TimeSpent == $('a[id^=secNM][data-active=1]').data('time'))
	{
		$('[id^=secNM]').trigger('ChangeActiveSection',[$('a[id^=secNM][data-active=1]').next('[id^=secNM]').data('id'),'y']);	
		$('#time-text').trigger('updateDBTime');		
	}	

	//to update elapsed time
	if(TimeSpent == 0 || updateCandTime == configUpdatetime)
		{		
		$('#time-text').trigger('updateDBTime');
		updateCandTime=0;
		}	
	
    if (TimeSpent < (ExamDuration)) {
        TimeSpent++;
        updateCandTime++;       
        //alert(TimeSpent);
        document.getElementById("time-text").innerHTML = TimeSpent;        
        /* document.getElementById("hdnTime").value = TimeSpent */
    }
    csec2--;
    if (csec2 == -1) {
        csec2 = 59;
        cmin2--;
    }

    //start harshadd
	//allow end test with help of EndExamEnablePercentage
    if (cmin2 == (endExamEnable) && csec2 == 0) {
    	$('#endTest').removeClass("disabled");
	 }
    
    if (cmin2 < (endExamEnable) && $('#endTest').hasClass("disabled")) {
    	$('#endTest').removeClass("disabled");
	 }
    
    if (cmin2 > (endExamEnable) && $('#endTest').hasClass("disabled")==false) {
    	$('#endTest').addClass("disabled");
	 }
    //end harshadd
    
   //Added by Vikas for change the timer color while 30 sec remain
    if (cmin2 == 0 && csec2 < 30) {
        document.getElementById("time-text").innerHTML = Display(cmin2, csec2);
        var lbl = document.getElementById("time-text");
        lbl.style.color = "red";
        if ($('#testType').val() === 'group')
   	 	{
	        $('#clkImg').hide();
	        $('#clkImgWarn').show();
   	 	}
    }
    else {
        document.getElementById("time-text").innerHTML = Display(cmin2, csec2);        
    }
    cmin1=Math.floor(($('a[id^=secNM][data-active=1]').data('time') - TimeSpent)/60);
    $('a[id^=secNM][data-active=1]').find('span').text(Display(cmin1, csec2));
    
    if ((cmin2 == 0) && (csec2 == 0)) {
    	clearTimeout(timerID);
    	//hide all modals
		$(".examModal").modal("hide");
		//hide simulation modal START
		$(".flashContentOverleyDiv").hide();
		$(".mainFlashContentDiv").hide();
		//hide simulation modal END
		$('#TimeUpplzWait').show();
		$('#TimeUpproceed').hide();
		$('#closemodal').hide();
		$('#BtnmodalEndTest').trigger('click');
    	
    	if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined"){
    		js.forceCloseApp();
    	}
    	//this IF condition is for autosave mode functionality
    	if($('#testType').val() === 'solo' &&
    	   $('#autoSaveItem').val() == 'true' &&
    	   $('#QuestionContainer').contents().find('input[id^=optionsAns]').length > 0 &&
    	   $('#QuestionContainer').contents().find('input[id^=optionsAns]:checked').length > 0){
	    		
    		    $('#QuestionContainer').contents().find('#hidExt').val("autoSaveItem"+"|"+TimeSpent); 
	        	$('#QuestionContainer').contents().find('#frmQues').submit(); 
    	} else if($('#testType').val() === 'solo' &&
	    	      $('#autoSaveItem').val() == 'true' &&
	    	      $('#QuestionContainer').contents().find('option[id^=selOpt]').length > 0 &&
	    	      $('#QuestionContainer').contents().find('option[id^=selOpt]:selected').length > 0){
    		
    		     //This code is added to select multiple language select box on submit
    		     $('#QuestionContainer').contents().find('select option[id^=selOpt]:selected').each(function(){
    		    	 $('#QuestionContainer').contents().find("select option[id="+ $(this).attr('id') +"]").prop('selected', true);
  			     });  
    		
    		 	$('#QuestionContainer').contents().find('#hidExt').val("autoSaveItem"+"|"+TimeSpent); 
	        	$('#QuestionContainer').contents().find('#frmQues').submit(); 
    	} else{
	    		//$('#time-text').trigger('updateDBTime');   	
	        	$('#hidOperations_TimeUp').attr('src','../commonExam/hidFrameendTest?t='+TimeSpent);
	    		$('#hidOperations_TimeUp').load(function(e){
	    			if($('#hidOperations_TimeUp').contents().find('#data').val() && $('#hidOperations_TimeUp').contents().find('#data').val().length > 0)
					{
	    				response = $('#hidOperations_TimeUp').contents().find('#data').val();
	    				if(response==200)
	    	    		{
	    					$('#TimeUpplzWait').hide();
	    					$('#TimeUpproceed').show();
	    					$('#closemodal').show();
	    	    		}
					}
	    		});
    	}
    }   
}