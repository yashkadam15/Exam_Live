var canformsubmit=true;
var submit=0;
var mpc=0;
var isplaying=0;
var isplayallowed=false;
var curRecording=0;
var $FontSizeaffectedElements;
var wc=[];
var hs_nonA_pts=[];
var isResetClik=false;
var dualRecn = {};
let selectedFilesArr = [];

$(window).blur(function() 
{
	parent.IframeBlur();
});

$(document).ready(function(){

	var langflag=$('#langflag',window.parent.document).val();
		$('.markdown').each(function(){
			ClassicEditor.create(this, {
			    toolbar: {
			        items: [
			        	'heading',
			            '|',
			            'fontFamily',
			            'fontSize',
			            'fontColor',
			            'bold',
			            'italic',
			            'bulletedList',
			            'numberedList',
			            '|',
			            'alignment',
			            'outdent',
			            'indent',
			            '|',
			            'blockQuote',
			            'insertTable',
			            'undo',
			            'redo',
			            'specialCharacters',
			            'codeBlock'
			            
			        ]
			    },
				language: {
					// The UI will be English.
					ui: 'en',

					// But the content will be edited in Arabic.
					content: langflag
				}
			})
			.then( editor => {				
				
				editor.model.document.on( 'change', () => 
				{					
					editor.updateSourceElement();
				});

				editor.editing.view.document.on('paste', (evt,data) =>
				{			
					data.preventDefault();
					evt.stop();					 
				}, { priority: 'highest' } );

			})
			.catch(error => {
				console.log(error);				
			});
		
	});
		
		
$FontSizeaffectedElements = $(".questiondiv *").not('.palette1, .palette1 *');
$FontSizeaffectedElements.each(function() {
    var $this = $(this);
    $this.data("orig-size", $this.css("font-size"));
});
$("#btn-increase").click(function() {
    changeFontSize(1);
});

$("#btn-decrease").click(function() {
    changeFontSize(-1);
});

$("#btn-orig").click(function() {
	$FontSizeaffectedElements.each(function() {
        var $this = $(this);
        $this.css("font-size", $this.data("orig-size"));
    });
});
if(window.parent.dataURL!='')
{
	$("div.main").css("background-image", "url('"+ window.parent.dataURL + "')");
}
$('.playbtn').hide();
$('#anscnt',window.parent.document).val($('#dbanscnt').val());
$('#notepad',window.parent.document).hide();
parent.$('#anscnt').trigger('updateAllCount');
if(navigator.userAgent.search('MOSB') >= 0){
	$('select').each(function(){
		$(this).fixCEFSelect();
	});
}
mpc = parseInt($('#mpc').val());	
if($('html').css('direction')=='ltr' && $('.scrollbar-outer').length>0)
{
	$('.scrollbar-outer').scrollbar();	
}
$.ajaxSetup({ cache: false });
	$(document).mousedown(function(event){	
		if(event.which!=1)
			{
			return false;
			}
	});
	
	
	document.oncontextmenu = function() {return false;};
	if( ($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') || ($('#palletFwdOnly',window.parent.document).val()=='true' && $('#isLastItem').val()=='true'))
	{
		submit=1;
		$('[id^=optionsAns]').prop('disabled',true);		
		$('#Save, #cbReview, #Reset').addClass('disabled');
		$('#Save, #cbReview, #Reset').attr('disabled', true);
		//for praticle button
		$('.prtbtn, .openFlashbtn').addClass('disabled');
		$('.prtbtn, .openFlashbtn').attr('disabled', true);
		$('.openFlashbtn').removeClass('openFlashbtn');
	}
	$('#error',window.parent.document).hide();
	$('#error',window.parent.document).text('');
	$('#lblmessage',window.parent.document).hide();
	$('#lblmessage',window.parent.document).text('');	
	$('a[id^=Sublnk]').click(function(e)
	{
		e.preventDefault(); 		    	
    	if($(parentItemNoDiv).attr('data-fwdlk') == '1')
    		return;
    	if(isAnswerSaved())
   		{ 
        	$('#hidExt').val('loadCMPSMQTSubItem'); 
			$('#curitemID').val($(this).attr('data-parent')); 
			$('#cursubitemID').val($(this).data('subqid')); 
			isResetClik = true; 
        	$('#frmQues').submit(); 
        	window.parent.QuestionContainer(e);
   		}    
    	else
		{
    		confrimQusChange($('#AttemptWithoutSaving').val(),$(this).attr('data-parent'),"cmpsmqtsi", $(this).data('subqid'));
		}
	});	
	$('#Reset').click(function(e){
		isResetClik=true;
		if($(this).hasClass('disabled'))
		{
			canformsubmit=false;
			e.preventDefault();			
		}
		if(submit==0)
		{			
			if(e.modal==null && $('#lnk'+$('#curitemID').val(),window.parent.document).attr('data-status') != clsnotans[0])
			{
				var event = jQuery.Event("click");
				event.target=e.target;
				event.modal='0';
				e.preventDefault();
				$('#msgModalLoader',window.parent.document).attr('data-msgmodalbodytext',$('#resetConfirmMsg',window.parent.document).val());
				$('#msgModalLoader',window.parent.document).attr('data-footerbtn1text',$('#resetYesButton',window.parent.document).val());
				$('#msgModalLoader',window.parent.document).attr('data-footerbtn2text',$('#resetNoButton',window.parent.document).val());
				$('#msgModalLoader',window.parent.document).attr('data-footerbtn1class','btn btn-red');
				$('#msgModalLoader',window.parent.document).attr('data-footerbtn2class','btn btn-success');
				
			    window.parent.triggerMsgLoader('on',function () {
			        //yes button
					window.parent.triggerMsgLoader('off');				
					$('#Reset').trigger(event);
			    },function () {
			    	//no button		   
			    	window.parent.triggerMsgLoader('off');
			    });
			}
			else
			{
					if($('#itype').val() == 'CMPSMQT'){
						dualRecn.ceiid = $('#ceiid').val();
			     	}else{
			     		dualRecn.ceiid = $('#candidateExamItemID').val();
			     	}
				
				
				$('#frmQues')[0].reset();
				applyCls(clsnotans);
				if($('#itype').val() == 'CMPSMQT' && ($('[id^=Sublnk][data-status=ans]').length - 1)  > 0)
				{
					applyCls(clsPans);
				}
				
				window.parent.captureEvidence('Reset',dualRecn);
			}
		}
	});
	$('#Skip').click(function(e){		
		if($(this).hasClass('disabled'))
		{
			canformsubmit=false;
			e.preventDefault();			
		}
		if(submit==1)
		{
			e.preventDefault();
		}
	});
	$('#Next').click(function(e){	
		//for practical & simulation interface only.
		if($(this).hasClass('disabled'))
		{
			canformsubmit=false;
			e.preventDefault();			
		}
		if((submit==1) && (!$('#itype').val()=='PRT'))
		{
			e.preventDefault();
		}
	});
	$('#Save').click(function(e){
	
		//var dualRecn = {};
		
		//adding sub item type of CMPSMQT
		dualRecn.subItemTypeofCMPSMQT=$('#itype').val() == 'CMPSMQT' ? $('#subitype').val() : $('#itype').val();
		
		if($(this).hasClass('disabled'))
		{
			canformsubmit=false;
			e.preventDefault();			
		}
		else if(submit==0)
		{				
		// used instances in dualRec object
		//subItemTypeofCMPSMQT= used for CMPSMQT sub item type
		//ceiid= used as candidate exam item id	for each item type except MM,CMPS & MP
		//subItemid= used only for CMPSMQT current sub item id 	
		//options= used for optionid's 
		//dataofCMPS=used for only MM,CMPS and MP item type in that getting currentSubItemId ,candidateExamItemId and optionid's and making one string by concatinating these three attribute
		//typedTxt=used for those item type whose answer in text format.
			switch($('#itype').val() == 'CMPSMQT' ? $('#subitype').val() : $('#itype').val()) 
			{
			    case "MCSC":
			    case "MCMC":
			    case "PI":
			    case "CMPS":
			    case "MM":
			    case "SCS":
			    case "TRUEFALSE":
			    case "YN":
			    
			     	
			     	if($('#itype').val() == 'CMPSMQT'){
						dualRecn.ceiid = $('#ceiid').val();
						//cursubitemID this id already use in some files and controller 
						dualRecn.subItemid =$('#cursubitemID').val();
			     	}else{
			     		dualRecn.ceiid = $('#candidateExamItemID').val();
			     	}
			     	
			     // this is for option ids
			     
			   		var formElement = $('#frmQues');
			   		
					var selOptions=[];
					var cmpstxt='';
					formElement.find('input[id^=optionsAns]:checked').each(function() {					      
					 
					    if(($('#itype').val() == 'CMPS') || ($('#itype').val() == 'MM')){
					     
 						 cmpstxt += ((cmpstxt.length > 0) ? '|||' : '') + $(this).parent().closest('div').find('#candidateExamItemID').val()+"_"+$(this).parent().closest('div').find('#fkItemIdInput').val()+"_"+$(this).val();
 						 
 						
 						 
					    }else{
					         selOptions.push( $(this).val());
					    }
					 });
			   		dualRecn.options=selOptions;
			    	dualRecn.dataofCMPS=cmpstxt;
			   
			    
			    	if($('input[id^=optionsAns]').length > 0 && $('input[id^=optionsAns]:checked').length <= 0)
					{
						showError($('#SelectOption',window.parent.document).val());
						canformsubmit=false;
					}
					else if($('input[id^=optionsAns]').length > 0 && $('input[id^=optionsAns]:checked').length > 0)
					{				
						if($(parentItemNoDiv).data('subcnt') > 0)
						{					
							if(e.modal==null && applypartialAns() && $('#palletFwdOnly', window.parent.document).val() == 'false')
							{
								var event = jQuery.Event("click");
								event.target=e.target;
								event.modal='0';

								$('#msgModalLoader',window.parent.document).attr('data-msgmodalbodytext',$('#Partialsolve',window.parent.document).val());
								$('#msgModalLoader',window.parent.document).attr('data-footerbtn2text',$('#stayOnSameQ',window.parent.document).val());
								$('#msgModalLoader',window.parent.document).attr('data-footerbtn1text',$('#ProceedToNextQ',window.parent.document).val());
								$('#msgModalLoader',window.parent.document).attr('data-footerbtn1class','btn btn-red');
								$('#msgModalLoader',window.parent.document).attr('data-footerbtn2class','btn btn-success');
								
							    window.parent.triggerMsgLoader('on',function () {
							        //yes button
									window.parent.triggerMsgLoader('off');				
									$('#Save').trigger(event);
							    },function () {
							    	//no button		   
							    	window.parent.triggerMsgLoader('off');
							    });
							    return false;
							} 
							else if(e.modal==null && applypartialAns() && ('#palletFwdOnly', window.parent.document).val() == 'true')
							{
								showError($('#SelectOption',window.parent.document).val());
								canformsubmit=false;
							}
							else
							{
								canformsubmit=true;
								applyCls(applypartialAns() ? clsPans : clsans);	
							}
						}
						else
						{
							canformsubmit=true;
							applyCls(clsans);	
						}	
					}
			        break;
			    case "MP":
			    	 var formElement = $('#frmQues');
			   		 var cmpstxt='';
			   		 formElement.find('option[id^=selOpt]:selected').each(function() {					      
 						 
 						var candidateExamItemID = $(this).closest('tr').find('#candidateExamItemID').val();
					    var fkItemIdInput = $(this).closest('tr').find('#fkItemIdInput').val();
					    var optionID = $(this).val();
					    
					    if (candidateExamItemID && fkItemIdInput && optionID) {
					        cmpstxt += ((cmpstxt.length > 0) ? '|||' : '') + candidateExamItemID + "_" + fkItemIdInput + "_" + optionID;
					    }
					    
					 });
			   		
			    	dualRecn.dataofCMPS=cmpstxt;
			    	if($('option[id^=selOpt]').length > 0 && $('option[id^=selOpt]:selected').length <= 0)
					{
						showError($('#SelectOption',window.parent.document).val());
						canformsubmit=false;
					}
					else if($('option[id^=selOpt]').length > 0 && $('option[id^=selOpt]:selected').length > 0)
					{				
						if($(parentItemNoDiv).data('subcnt') > 0)
						{					
							if(e.modal==null && applypartialAns() && ('#palletFwdOnly', window.parent.document).val() == 'false')
							{
								var event = jQuery.Event("click");
								event.target=e.target;
								event.modal='0';

								$('#msgModalLoader',window.parent.document).attr('data-msgmodalbodytext',$('#Partialsolve',window.parent.document).val());
								$('#msgModalLoader',window.parent.document).attr('data-footerbtn2text',$('#stayOnSameQ',window.parent.document).val());
								$('#msgModalLoader',window.parent.document).attr('data-footerbtn1text',$('#ProceedToNextQ',window.parent.document).val());
								$('#msgModalLoader',window.parent.document).attr('data-footerbtn1class','btn btn-red');
								$('#msgModalLoader',window.parent.document).attr('data-footerbtn2class','btn btn-success');
								
							    window.parent.triggerMsgLoader('on',function () {
							        //yes button
									window.parent.triggerMsgLoader('off');				
									$('#Save').trigger(event);
							    },function () {
							    	//no button		   
							    	window.parent.triggerMsgLoader('off');
							    });		
							    return false;
							}
							else if(e.modal==null && applypartialAns() && ('#palletFwdOnly', window.parent.document).val() == 'true')
							{
								canformsubmit=false;
								showError($('#SelectOption',window.parent.document).val());
							}
							else
							{
								canformsubmit=true;
								applyCls(applypartialAns() ? clsPans : clsans);	
							}			
						}
						else
						{
							canformsubmit=true;
							applyCls(clsans);	
						}	
						//This code is added to select multiple language select box on submit
						$('select option[id^=selOpt]:selected').each(function(){
							$('tr[id^=sidiv]').find("select option[id="+ $(this).attr('id') +"]").prop('selected', true);
						});
					}
			        break;
			    case "MTC":
			    case "SQ":
					var noOfColumn = $('#noOfColumn').val();
					if($('#ans > div[id^=div] > div[id^=opt]').length == Number(noOfColumn)) 
					{
						var typedTxt = "";
						for (var i = 0; i < noOfColumn; i++) {
							if($('#itype').val()=="SQ" && $('#sequencingType').val()=="IMAGE"){
								typedTxt += ($('#ans > div[id=div'+i+'] > div[id^=opt]').attr('column'))+(i==Number(noOfColumn)-1 ? " " : ",");
							
							}
							else{
								typedTxt += " " + $("#div" + i).text();
								
							}
								dualRecn.typedText=typedTxt;
								dualRecn.ceiid = $('#candidateExamItemID').val();
						}
						$('#answerdata').val(typedTxt.trim());
						canformsubmit=true;
						applyCls(clsans);					
					}
					else
					{
						showError($('#SelectMTC_SQ',window.parent.document).val());
						canformsubmit=false;
					}
					
			        break;
			    case "EC":			    
			    case "RWP":
			    case "FQFA":
			    	var typedTxt = $('[id^=optionsAns]').val().trim();
			    	dualRecn.typedText=typedTxt;
			    	dualRecn.ceiid = $('#candidateExamItemID').val();
					if(typedTxt.length == 0)
					{
						showError($('#SelectEC_EW',window.parent.document).val());
						canformsubmit=false;
					}
					else
					{				
						canformsubmit=true;
						applyCls(clsans);	
					}
			    	break;			   
			    case "EW":	
			    	if($('#itype').val() == 'EW')	//Long answer type main question
			    	{
				    	e.preventDefault();		   
				    	var typedTxt = $('[id^=optionsAns]').val().trim();
				    	dualRecn.typedText=typedTxt;
				    	dualRecn.ceiid = $('#candidateExamItemID').val();
						
						if(typedTxt.length == 0)
						{
							showError($('#SelectEC_EW',window.parent.document).val());
							canformsubmit=false;
							return false;
						}	
									
						if(selectedFilesArr == null || selectedFilesArr.length==0) {
							canformsubmit=true;
							applyCls(clsans);											
							window.parent.runThis('Save',dualRecn);
						}
						else{
							var fileTypeAllowed = validateFileType(selectedFilesArr);
							var fileSizeCheck = validateFileSize(selectedFilesArr);
							
							var maxNoOfFilesAllowed = $('#longAnswerMaxNoOfFilesAllowed',window.parent.document).val();
							if (selectedFilesArr.length > maxNoOfFilesAllowed) {
								showError($('#EW_exceededAllowedLimit',window.parent.document).val());
					   			return false;
					  		}
					  		
							if(!fileTypeAllowed)
							{
								showError($('#EW_FileTypeNotAllowed',window.parent.document).val());
								canformsubmit=false;
								return false;
							}
							else if(!fileSizeCheck)
							{
								showError($('#EW_FileSizeExceed',window.parent.document).val());
								canformsubmit=false;
								return false;
							}
							else{
								uploadLongAnswerFile(selectedFilesArr).done(function(e){							
								if(e.includes("uploadStatus=true") == true)
								{								
									canformsubmit=true;
									applyCls(clsans);	
									dualRecn.selectedFiles=selectedFilesArr;										
									window.parent.runThis('Save',dualRecn);
								}	
								else{								
									showError($('#EW_FileUploadingFailed',window.parent.document).val());
									canformsubmit=false;
								}		
								
								})
							}					
							
						}
			    	}	
			    	else //Long answer type sub question of CMPSMQT
			    	{
				    	var typedTxt = $('[id^=optionsAns]').val().trim();
				    	dualRecn.typedText=typedTxt;
				    	dualRecn.ceiid = $('#ceiid').val();
				     	
				    	if($('#itype').val()=='CMPSMQT'){
				    		dualRecn.subItemid =$('#cursubitemID').val();
				    	}
						if(typedTxt.length == 0)
						{
							showError($('#SelectEC_EW',window.parent.document).val());
							canformsubmit=false;
						}
						else
						{				
							canformsubmit=true;
							applyCls(clsans);	
						}
			    	}		
			    	break;
			    case "WC":
			  		    var typedTxt = $('[id^=optionsAns]').val().trim();
				    	dualRecn.typedText=typedTxt;
				    	dualRecn.ceiid = $('#candidateExamItemID').val();
			    	if($('[id^=optionsAns]').val().trim().length == 0)
					{
						showError($('#SelectOption',window.parent.document).val());
						canformsubmit=false;
					}
					else
					{				
						canformsubmit=true;
						applyCls(clsans);	
					}
			    	break;
			    case "HS":
			    	if($('div.hs_pointer_di').length == 0)
		    		{
			    		showError($('#SelectHS',window.parent.document).val());
						canformsubmit=false;
		    		}
			    	else
		    		{
			    		$('div.hs_pointer_di[data-areafor="NA"]').each(function(i,p)
			    		{
			    			$('div.areaDivs:has(input:hidden[id^="x1_"][value="0"], input:hidden[id^="y1_"][value="0"])').each(function()
			    			{
			    				$(this).find('input:hidden[id^="x1_"]').val($(p).attr('data-x1'));
			    				$(this).find('input:hidden[id^="x2_"]').val($(p).attr('data-x1'));
			    				$(this).find('input:hidden[id^="y1_"]').val($(p).attr('data-y1'));
			    				$(this).find('input:hidden[id^="y2_"]').val($(p).attr('data-y1'));
			    				return false;
			    			})
			    		});
			    		canformsubmit=true;
						applyCls(clsans);
		    		}
			    	break;
			    case "SML":
			    case "RIFORM":
			    	canformsubmit=true;
					applyCls(clsans);
					break;
			    case "PRT":
			    	canformsubmit=true;
					applyCls(clsans);
			    	break;
			    case "NFIB":
			    	var fibAnsCnt=0;
			    	var jsonResult=[];
			    	var seqCount=1;
			    	$('input[id^=optionsAns]').each(function() {
			    	 var blankObject = {
								    blankText: $(this).val().trim(),
								    blankSequence: seqCount++
						 };
						 jsonResult.push(blankObject);
			    	 
					  if ($(this).val().trim() !== '') {
					    fibAnsCnt++;
					  }
					});
					 var jsonString = JSON.stringify(jsonResult);
					 dualRecn.typedText=jsonString;
					 dualRecn.ceiid = $('#candidateExamItemID').val();
					 
			   		if($('input[id^=optionsAns]').length > 0 && fibAnsCnt <= 0)
					{
						showError($('#SelectEC_EW',window.parent.document).val());
						canformsubmit=false;
					}					
			    	else if($('input[id^=optionsAns]').length > 0 && fibAnsCnt > 0)
					{				
						if(e.modal==null && applypartialAns() && $('#palletFwdOnly', window.parent.document).val() == 'false')
						{
							var event = jQuery.Event("click");
							event.target=e.target;
							event.modal='0';

							$('#msgModalLoader',window.parent.document).attr('data-msgmodalbodytext',$('#PartialsolveFIB',window.parent.document).val());
							$('#msgModalLoader',window.parent.document).attr('data-footerbtn2text',$('#stayOnSameQ',window.parent.document).val());
							$('#msgModalLoader',window.parent.document).attr('data-footerbtn1text',$('#ProceedToNextQ',window.parent.document).val());
							$('#msgModalLoader',window.parent.document).attr('data-footerbtn1class','btn btn-red');
							$('#msgModalLoader',window.parent.document).attr('data-footerbtn2class','btn btn-success');
							
						    window.parent.triggerMsgLoader('on',function () {
						        //yes button
								window.parent.triggerMsgLoader('off');				
								$('#Save').trigger(event);
						    },function () {
						    	//no button		   
						    	window.parent.triggerMsgLoader('off');
						    });
						    return false;
						} 
						else if(e.modal==null && applypartialAns() && ('#palletFwdOnly', window.parent.document).val() == 'true')
						{
							showError($('#SelectOption',window.parent.document).val());
							canformsubmit=false;
						}
						else
						{
							canformsubmit=true;
							applyCls(applypartialAns() ? clsPans : clsans);	
						}
					}
			    	break;
			    default:
			    	canformsubmit=false;
			    	console.log('Form submit values not found: ' + $('#itype').val());
			    	e.preventDefault();
			} 
			
			if($('#itype').val() == 'CMPSMQT' && canformsubmit && ($('[id^=Sublnk][data-status=ans]').length + 1)  != $('[id^=Sublnk]').length)
			{
				applyCls(clsPans);
			}
			
			if (canformsubmit && $('input[name="confidenceLevel"]').length > 0 && $('input[name="confidenceLevel"]:checked').length <= 0)
			{
				showError($('#SelectConfLevel',window.parent.document).val());
				canformsubmit=false;
			}
			else if (canformsubmit && $('input[name="confidenceLevel"]').length > 0 && $('input[name="confidenceLevel"]:checked').length > 0)
			{
				applyCls(clsans);
				canformsubmit=true;
			}
			
			if(canformsubmit && $('#itype').val() != 'EW'){			
				window.parent.runThis('Save',dualRecn);	
			}
		}
				
	});
	$('#frmQues').submit(function(e)
	{		
		if(!isResetClik && $('#itype').val() == 'CMPSMQT')
		{
			var nxtel = $('a[id^=Sublnk].current').next('a[id^=Sublnk]');
			if(nxtel.length > 0)
			{
				$('#cursubitemID').val($(nxtel).data('subqid'));
			}
			else
			{
				$('#Save').attr('name', 'Save');
				$('#Skip').attr('name', 'Skip');
			}
		}
		
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
		else if ((submit==1) && ($('#itype').val()=='PRT'))
		{
			return true;
		}
		else
		{
			return false;
		}
	});
	$('a[id^=silnk]').click(function(e){
    	e.preventDefault();
    	$('.cmpsqdiv').scrollTo( $('#sidiv' +$('#viewLang option:selected').val() + $(this).data('item')), 500 );
    });
    // confidence level selection
    $('input[name="confidenceLevel"]').click(function() {
  	  $(this).prop("checked",true);
  	  $('input[name="confidenceLevel"]').parent().removeClass('selected');
  	  $(this).parent().addClass('selected');
    });   
    
   
    $('#chkpwd').click(function(e){    	
    	if($('#takepwd').val().length == 0)
		{
    		$('#askPwdModalErrMsg').show();
    		$('#askPwdModalErrMsg').text('');
    		$('#askPwdModalErrMsg').text('supervisor password cannot be blank.');
    		e.preventDefault();
		}
    	else
		{
    		$('#takepwd').hide();
    		$('#chkpwd').hide();
    		$('#cancelpwd').hide();
    		var response=0;
    		$('#hidOperations').attr('src','../commonExam/hiddenOperation?supwd='+$('#takepwd').val());	
    		$('#waitforprocess').show();    		
    		$('#hidOperations').load(function(e){
    			if($('#hidOperations').contents().find('#data').val() && $('#hidOperations').contents().find('#data').val().length > 0)
				{
    				response = $('#hidOperations').contents().find('#data').val();
    				if(response==200)
    	    		{	    		
    		    		isplayallowed=true;
    		    		//$("div[id^="+$('#viewLang option:selected').val()+"]").find('.jp-play').trigger('click');
    		    		$("#askPwdsModal").modal('hide');
    		    		$('#takepwd').show();
    		    		$('#chkpwd').show();
    		    		$('#cancelpwd').show();
    		    		$('#takepwd').val('');
    		    		$('#waitforprocess').hide();    
    	    		}
    	    		else if(response==404)
    				{
    	    			$('#askPwdModalErrMsg').text('');
    	    			$('#askPwdModalErrMsg').text('Supervisor Password is incorrect');
    	    			$('#askPwdModalErrMsg').show();
    	    			$('#takepwd').show();
    	    			$('#chkpwd').show();
    	    			$('#cancelpwd').show();
    	    			$('#waitforprocess').hide();  
    	    			$('#takepwd').val('');
    				}
    	    		else
    				{
    	    			$('#askPwdModalErrMsg').text('');
    	    			$('#askPwdModalErrMsg').text('Error while checking supervisor password.');
    	    			$('#askPwdModalErrMsg').show();
    	    			$('#takepwd').show();
    	    			$('#chkpwd').show();
    	    			$('#cancelpwd').show();
    	    			$('#waitforprocess').hide();  
    	    			$('#takepwd').val('');
    				}
    				$('#hidOperations').contents().find('#data').val('');    				
				}    			
			});
		}    	
    });
    $('.askPwdsModalClose').click(function(){
    	$("#askPwdsModal").modal('hide');
    	$('#takepwd').prop('readonly',false);
    	$('#takepwd').val('');
		$('#chkpwd').prop('disabled',false);
		$('#takepwd').val('');
    });
    $('.prtbtn').click(function(e) {	
    	e.preventDefault();
			if(e.which != 2 && !$(this).hasClass("disabled")){			
				if(navigator.userAgent.search('MOSB') >= 0){
					window.location.href=$(this).data("lnk");		
		 		}else {		 			 			
		 			window.parent.triggerExamClientModalIfrm();		 
		 		}
			}
		});
    //check all questions in current section are in answered mode or not; if yes show modal
    if($('a[id^=secNM][data-active=1]',window.parent.document).data('restrict')==false && $('a[id^=lnk][data-status=ans][data-section='+ $('a[id^=secNM][data-active=1]',window.parent.document).data('id') + ']',window.parent.document).length == $('a[id^=lnk][data-section='+ $('a[id^=secNM][data-active=1]',window.parent.document).data('id') + ']',window.parent.document).length)
	{		
		$('#msgModalLoader',window.parent.document).attr('data-msgmodalbodytext',$('#SectionCmplt',window.parent.document).val());
		$('#msgModalLoader',window.parent.document).attr('data-footerbtn1text',"OK");
		$('#msgModalLoader',window.parent.document).attr('data-footerbtn1class','btn btn-success');
		
	    window.parent.triggerMsgLoader('on',function () {
	        //yes button
			window.parent.triggerMsgLoader('off');
	    });
	}
    
    $('#RecordAnswer').click(function(e){
    	e.preventDefault();    	
    	if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined"){
    		var hidRecordedFileName=$('#hidRecordedFileName',window.parent.document).val()+"_"+$('#curitemID').val();
    		js.showRIFORMRecordingWindow(false,hidRecordedFileName ,parseInt($('#hidAnsDuration').val()),$('#hidAnsMode').val(),"RIFORM");
    		
    	}
    }); 
  //for group exam purpose    
    $('.recordbtn').click(function(e){
    	e.preventDefault();
    	if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined"){
    		var hidRecordedFileName=$('#hidRecordedFileName'+ $(this).data('candid'),window.parent.document).val()+"_"+$(this).data('itemid');
    		js.showRIFORMRecordingWindow(false,hidRecordedFileName ,parseInt($(this).data('ansduration')),$(this).data('ansmode'),"ChatWindow");
    		curRecording = $(this);
    		if(($('div.box').length * q.length) == chatcnt)
    		{
    			$('#ratepeer').prop('disabled', false);
    		}
    	}
    }); 
    $('.playbtn').click(function(e){
    	e.preventDefault();
    	window.parent.Player($(this).data('filename'));
    	window.parent.$('#playCandVdoModal').modal('show');
    	
    }); 
    $('#ratepeer').click(function(e){
    	e.preventDefault();
    	window.parent.$('#ratepeer').modal('show');    	
    }); 
    $('#longtextanswer > #optionsAns').focus();
    if($('#longtextanswer > #optionsAns').length > 0 && $('#longtextanswer > #optionsAns').val().length > 0 && $('#charCount').length > 0)
	{    	 
    	$('#charCount').text($('#longtextanswer > #optionsAns').val().match(/\S+/g).length);
	}
    $('#longtextanswer > #optionsAns').keyup(function(e){
        if (Number($(this).attr('maxlength') - $(this).val().length) == 0) {
        	showError($('#inputLimit',window.parent.document).val());
        }
        else {
        	$('#error',window.parent.document).css('display','none');
            $('#charCount').text(this.value.match(/\S+/g).length);
        }
    });
    $('#hs_img, area').click(function(event) {
    	if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
    		event.preventDefault();
    		return false;
    	}
    	if($('div.hs_pointer_di').length < $('area').length)
    	{    	
	        let di = document.createElement('div');
	        let im = document.createElement('img');
	        let cim = document.createElement('a');
	        $(di).addClass("hs_pointer_di");
	        $(im).addClass("hs_pointer");
	        $(cim).addClass("close_hs_pointer_di");
	        $(cim).attr('title','remove');
	        $(im).attr('src','../resources/images/hs_pointer.png')
	        $(di).css("left",Math.round(event.pageX - $('#hs_img').offset().left) - 21);
	        $(di).css("top",Math.round(event.pageY - $('#hs_img').offset().top) - 5);
	        $(di).css("position",'absolute');
	        $(di).attr("data-x1",Math.round(event.pageX - $('#hs_img').offset().left ));
	        $(di).attr("data-y1",Math.round(event.pageY - $('#hs_img').offset().top ));
	        $(di).attr("data-areafor",$(event.target).is('area') ? $(event.target).attr('class') : 'NA');
	        $(di).append(cim);
	        $(di).append(im);
	        
	        $('#hs_img').after(di);
	        if($(event.target).is('area'))
        	{
	        	$('#optionsAns'+$(this).attr('class')).prop('checked',true);
	        	$('#x1_'+$(this).attr('class')).val($(di).attr("data-x1"));
	            $('#x2_'+$(this).attr('class')).val($(di).attr("data-x1"));
	            $('#y1_'+$(this).attr('class')).val($(di).attr("data-y1"));
	            $('#y2_'+$(this).attr('class')).val($(di).attr("data-y1"));
        	}	        
    	}
    	else
		{
    		showError("Only " + $('area').length + " point(s) are allowed to select.");
		}
    });
    
    $(document).on('click','.close_hs_pointer_di',function(){
    	//if($('#optionsAns'+$(this).parent().attr('data-areafor')) != 'NA' )
    	//{
	    	$('#optionsAns'+$(this).parent().attr('data-areafor')).prop('checked',false);
	    	$('#x1_'+$(this).parent().attr('data-areafor')).val(0);
	        $('#x2_'+$(this).parent().attr('data-areafor')).val(0);
	        $('#y1_'+$(this).parent().attr('data-areafor')).val(0);
	        $('#y2_'+$(this).parent().attr('data-areafor')).val(0);
    	//}
        $(this).parent().remove();
    });
	allOKStartTimer();
});

function applypartialAns()
{
	var partialAns=false;
	
	$('div[id^=sidiv' +$('#viewLang option:selected').val()+']').each(function(){
		
		if($(this).find('input[id^=optionsAns]:checked').length <= 0)
		{			
			partialAns = true;			
			return false;			
		}
		
	});
	
	//START
	//This code added for select box of match the pair
	$('tr[id^=sidiv' +$('#viewLang option:selected').val()+']').each(function(){
		if($(this).find('option[id^=selOpt]:selected').length <= 0){			
			partialAns = true;
			return false;
		}
	});
	//END
	
	if($('#itype').val()==='NFIB') {
		$('input[id^=optionsAns]').each(function() {
		  if ($(this).val().trim() === '') {
		    partialAns = true;
		   return false;
		  }
		});
	}
	
	return partialAns;
}

function chkIfPartial()
{
	if(parseInt($('#lnk' + $('#curitemID').val(),window.parent.document).data('subcnt')) > 0)
	{
		
	}
}

function showQuesDiv(langDiv)
{	
	//if($('#mode').val() === "update")
	//{		
		$('input[id^=optionsAns]:checked').each(function(){
			$(this).prop('checked', false);
			if($('#'+$(langDiv).val()).find('input.'+$(this).attr('class')).not(':checked'))
			{
				$('#'+$(langDiv).val()).find('input.'+$(this).attr('class')).prop('checked', true);
			}
		});
		
		//START
	    //This code added for Match the pair
		//as match the pair has select box
		$('select option[id^=selOpt]:selected').each(function(){
			$(this).prop('selected', false);
			if($('#'+$(langDiv).val()).find("select option[id="+ $(this).attr('id') +"]").not(':selected'))
			{
				$('#'+$(langDiv).val()).find("select option[id="+ $(this).attr('id') +"]").prop('selected', true);
			}
		});
		//END
		
	//}
	
	if($('#itype').val() === 'CMPS' || $('#itype').val() === 'MM')
	{
		$('.cmpsqdiv').scrollTo( $('div[id^=sidiv'+ $(langDiv).val() +']:first'),1);
	}	
	$('[id^='+$(langDiv).val()+']').show();		

	if($('#itype').val() === 'MM')
	{
		var pevnt = jQuery.Event('initPlayer');	
		pevnt.play = function(){
			$(this).jPlayer("pauseOthers", 0);
			if(($('#mediaRepeatCount',window.parent.document).val()==0 || mpc<parseInt($('#mediaRepeatCount',window.parent.document).val())))
			{
				$('.jp-play').hide();		
				mpc++;			
				$('.jp-title').html($(this).parents('div[id^=MMplayer_]').data('mediatitle') + 'Number of times media played: '+ mpc);
				$.ajax('../commonExam/hidMPC/'+mpc, 
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
				isplaying=1;
			}
			else if((!isplayallowed && $('#mediaRepeatCount',window.parent.document).val()>0 && mpc>=parseInt($('#mediaRepeatCount',window.parent.document).val())))
			{
	    		$(this).jPlayer("pause",0);    		
				$("#askPwdsModal").modal({ backdrop: 'static', keyboard: false });
				$('#askPwdModalErrMsg').text('');
				$('#askPwdModalErrMsg').hide();
				$('#waitforprocess').hide();
			}
			else if(isplayallowed)
			{
				$('.jp-play').hide();		
				mpc++;			
				$('.jp-title').html($(this).parents('div[id^=MMplayer_]').data('mediatitle') + 'Number of times media played: '+ mpc);
				$.ajax('../commonExam/hidMPC/'+mpc, 
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
				isplaying=1;
				isplayallowed=false;
			}
			
		};
		pevnt.end = function(){		
			$('.jp-play').show();
			//$(this).jPlayer("destroy");
			isplaying=0;
			//$('#'+$(this).attr('id')).parents('div[id^=MMplayer_]').trigger(pevnt);	
			$('.jp-title').html($('#'+$(this).attr('id')).parents('div[id^=MMplayer_]').data('mediatitle') + 'Number of times media played: '+ mpc);
		};
		
		$('div[id^='+$(langDiv).val()+']').find('div[id^="MMplayer_"][data-medialoadonready=false][data-ready=false]').each(function(){
			$(this).trigger(pevnt);		
			if(isplaying==1)
			{
				$('.jp-play').hide();
			}
			$('.jp-title').html($(this).data('mediatitle') + 'Number of times media played: '+ mpc);
		});
	}
	
	if($('#itype').val() === 'RIFORM' || $('#itype').val() === 'NOOPT')
	{
		var pevnt = jQuery.Event('initPlayer');	
		pevnt.end = function(){		
		};
		$('div[id^='+$(langDiv).val()+']').find('div[id^="MMplayer_"][data-medialoadonready=false][data-ready=false]').each(function(){
			$(this).trigger(pevnt);		
			if(isplaying==1)
			{
				$('.jp-play').hide();
			}
			
		});
	}
}
function showError(errorText)
{
	$('#lblmessage',window.parent.document).hide();
	$('#error',window.parent.document).text(errorText);
	if($('#error',window.parent.document).css('display') != 'none')
		{
		$('#error',window.parent.document).css('display','none');
		}
	$('#error',window.parent.document).fadeToggle("fast", "linear");
	$('#error',window.parent.document).fadeToggle("fast", "linear");
	$('#error',window.parent.document).fadeToggle("fast", "linear");
	$('#error',window.parent.document).fadeToggle("fast", "linear");	
	$('#error',window.parent.document).fadeToggle("fast", "linear");
}

function showMessage(MessageText)
{
	$('#error',window.parent.document).hide();
	$('#lblmessage',window.parent.document).text(MessageText);
	$('#lblmessage',window.parent.document).show();
}

function submitRIFORMAnswer(timetaken,fileName)
{
	if($('#itype').val() == 'RIFORM')
	{
		$('#timeTakenInSec').val(timetaken);
		$('#optionFilePath').val(fileName);
		$('#Save').click();
		applyCls(clsans);
	}
	if($('#itype').val() == 'NOOPT')
	{
		$(curRecording).parents('.box').find('input.optionFilePath'+$(curRecording).data('candid')).val(fileName);
		$(curRecording).hide();
		$(curRecording).parent().parent().next('.notification').hide();
		$(curRecording).next('button.playbtn').data('filename',fileName);
		$(curRecording).next('button.playbtn').show();
		nextChatPerson();
	}
}

function isAnswerSaved()
{
	if($('#mode').val() === 'update')
		return true;
	
	switch($('#itype').val() == 'CMPSMQT' ? $('#subitype').val() : $('#itype').val()) 
	{
	    case "MCSC":
	    case "MCMC":
	    case "PI":
	    case "CMPS":
	    case "MM":
	    case "SCS":
	    case "TRUEFALSE":
	    case "YN":
			if($('input[id^=optionsAns]').length > 0 && $('input[id^=optionsAns]:checked').length > 0)
			{				
				return false;
			}
	        break;
	    case "MP":
	    	if($('option[id^=selOpt]').length > 0 && $('option[id^=selOpt]:selected').length > 0)
			{				
				return false;
			}
	        break;
	    case "MTC":
	    case "SQ":			
			if($('#ans > div[id^=div] > div[id^=opt]').length > 0) 
			{
				return false;			
			}			
	        break;
	    case "EC":
	    case "EW":
	    case "RWP":
	    case "FQFA":
	    case "WC":
			if($('[id^=optionsAns]').val().trim().length > 0)
			{
				return false;
			}			
	    	break;	   
	    case "HS":
	    	if($('div.hs_pointer_di').length > 0)
    		{
	    		return false;
    		}
	    	break;
	    case "NFIB":
			if($('[id^=optionsAns]').val().trim().length > 0)
			{
				return false;
			}			
	    	break;
	    default:	    	
	}
	return true;
}

function changeFontSize(direction) {
	$FontSizeaffectedElements.each(function() {
		
        var $this = $(this);
        $this.css("font-size", parseInt($this.css("font-size")) + direction);
    });
}

function shuffle(array) 
{
	  var currentIndex = array.length, temporaryValue, randomIndex;
	
	  // While there remain elements to shuffle...
	  while (0 !== currentIndex) {
	
	    // Pick a remaining element...
	    randomIndex = Math.floor(Math.random() * currentIndex);
	    currentIndex -= 1;
	
	    // And swap it with the current element.
	    temporaryValue = array[currentIndex];
	    array[currentIndex] = array[randomIndex];
	    array[randomIndex] = temporaryValue;
	  }
	
	  return array;
}

function showSpotData(img)
{
	$('img[usemap]').rwdImageMaps();
	$('div.areaDivs:has(input:hidden[id^="x1_"][value!="0"], input:hidden[id^="y1_"][value!="0"])').each(function()
	{
		let di = document.createElement('div');
        let im = document.createElement('img');
        let cim = document.createElement('a');
        $(di).addClass("hs_pointer_di");
        $(im).addClass("hs_pointer");
        $(cim).addClass("close_hs_pointer_di");
        $(cim).attr('title','remove');
        $(im).attr('src','../resources/images/hs_pointer.png')
        $(di).css("left",parseInt($(this).find('input:hidden[id^="x1_"]').val())-20);
        $(di).css("top",parseInt($(this).find('input:hidden[id^="y1_"]').val())-6);
        $(di).css("position",'absolute');
        $(di).attr("data-x1",$(this).find('input:hidden[id^="x1_"]').val());
        $(di).attr("data-y1",$(this).find('input:hidden[id^="y1_"]').val());
        $(di).attr("data-areafor",$(this).find('input:checkbox').attr('class'));
        $(di).append(cim);
        $(di).append(im);
        
        $('#hs_img').after(di);
	});
	if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
		$('a.close_hs_pointer_di').remove();
	}
}

function loadWords()
{
	var arr =shuffle($('#wcDiv').data('text').split(","));
	$.each(arr,function(i,v) {
		wc.push({text: v, weight: i, html:{class: v==$("#optionsAns").val() ? 'wc-selectedAnswer' : '' , style: i%3==0 ? 'writing-mode: tb-rl' : ''} ,handlers: {click: function() 
			{ 
				if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
					return false;
				}
				$('#optionsAns').val($(this).text());
				$('#wcDiv > span.wc-selectedAnswer').each(function(){
					$(this).css('color', $(this).css('background-color'));
					$(this).css('background-color','rgb(255,255,255)');
					$(this).removeClass('wc-selectedAnswer'); 
				});
				
				$(this).css('background-color', $(this).css('color'));
				$(this).css('color', 'rgb(255,255,255)');
				$(this).addClass('wc-selectedAnswer'); 
				
				showMessage('Selected option:' + $(this).text());
			}
		}});
	});
	
	$('#wcDiv').jQCloud(wc, {
		  height: ($('.qdiv').height() - $('.qdiv > p').height() - $('.qdiv > br').height()),
		  removeOverflowing: false,
		  steps: 20,
		  colors: ["#e6194B", "#3cb44b", "#ffe119", "#4363d8", "#f58231", "#911eb4", "#42d4f4", "#f032e6", "#bfef45", "#fabebe", "#469990", "#e6beff", "#9A6324", "#800000", "#aaffc3", "#808000", "#ffd8b1", "#000075", "#a9a9a9", "#000000"],
		  fontSize: {
		        from: 0.05,
		        to: 0.02
		      },		  
		  delay	: 30,
		  center: {x: 0.5, y:0.5},
		  autoResize:	true,
		  afterCloudRender: function()
		  {
			  $('#wcDiv > span.wc-selectedAnswer').each(function(){
				  $(this).css('background-color', $(this).css('color'));
				  $(this).css('color', 'rgb(255,255,255)');
				  showMessage('Selected option:' + $(this).text());
			  });
		  }
	});
}

function allOKStartTimer()
{
	if(typeof window.parent.resumeTimer === "function" && window.parent.isReady)
	{
		window.parent.resumeTimer();	
	}
	else
	{
		setTimeout(allOKStartTimer, 300);
	}
}

//multiple image selection

function selectImage() {
    const input = document.getElementById('selAnsfile');
    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    
    if(isMobile){
	     input.setAttribute('accept', 'image/*');
	     input.setAttribute('capture', 'camera');
     }
     
    input.click();
    
}

function updateImageList() {
	const input = document.getElementById('selAnsfile');
	const updatedFiles = new DataTransfer();
    const imageList = document.getElementById('imageList');
    imageList.innerHTML = '';

    selectedFilesArr.forEach((image, index) => {
        const listItem = document.createElement('div');
        listItem.innerHTML = image.name+`<button class="btn-sm" type="button" onclick="removeImage(`+index+`)"> x</button>`;
        imageList.appendChild(listItem);
        updatedFiles.items.add(image);
    });
     input.value = '';
   input.files = updatedFiles.files;
}

function removeImage(index) {
var input=document.getElementById('selAnsfile');
console.log("Removal"+input.files);
    selectedFilesArr.splice(index, 1);
    updateImageList();
}

function changeInputValue(){
	var input=document.getElementById('selAnsfile');
	if (input.files && input.files.length > 0) 
	{
		var newFiles = Array.from(input.files);
	    newFiles.forEach(function (newFile) {
	    var isDuplicate = selectedFilesArr.some(function (existingFile) {
	        return (
	          existingFile.name === newFile.name &&
	          existingFile.size === newFile.size
	        );
	      });
	
	      if (!isDuplicate) {
	        selectedFilesArr.push(newFile);
	      }
	    });
        updateImageList();
     }
}

function showSelectedClaim(selectedClaimKey,selectedClaimText){
console.log('selectedClaimKey------>' + selectedClaimKey);
console.log('selectedClaimText------>' + selectedClaimText);
console.log('#inpSelectedClaimKey--->'+$('#inpSelectedClaimKey'));
$('#inpSelectedClaimKey').val(selectedClaimKey);
$("#spanSelectedClaimText").text(selectedClaimText);
}

