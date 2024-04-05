 var clsbase = ['nostatus','btn'];
 var clsnotans = ['noans','btn btn-red'];
 var clsans = ['ans','btn btn-greener'];
 var clsPans = ['parans','btn btn-dblue'];
 var clssub = ' round';
 var parentItemNoDiv;
 var curitemID;
 var q=[];
 var qIndex=0;
 var qusIndex=0;
 $(document).ready(function()
{	 
	 parent.$("#time-text").trigger( 'updateDBTime' );
	 $("#examineeImageRef",window.parent.document).hide();
	 if($('#testType',window.parent.document).val() === 'solo')
	 {
		 $('#sectionID').val($('a[id^=secNM][data-active=1]',window.parent.document).data('id'));
		//to show currect ques number
		 $('#quesnoText').text($('#quesnoText').text() + $('#lnk'+$('#curitemID').val(),window.parent.document).text());
		 
		 getsetStatusCount();
		//to show ques status on main jsp
		 curitemID = $('#curitemID').val();
		 parentItemNoDiv = $('#lnk'+curitemID,window.parent.document);
		if($(parentItemNoDiv).data('status') === clsbase[0])
		   {
				applyCls(clsnotans);			
		   }	
		$('[id^=lnk]',window.parent.document).removeClass('current');
		$(parentItemNoDiv).addClass('current');	
		$('.palette .quick-ques',window.parent.document).scrollTo( $('#lnk' +curitemID,window.parent.document), 800 );		
		if(parentItemNoDiv.data('type') == 'CMPSMQT')
		{
			$('[id^=Sublnk]').removeClass('current');
			$('#Sublnk'+($('#cursubitemID').val())).addClass('current');	
			$('#cbReview').prop('checked', ($("#cbreviewValue").val() == 'true' ? true : false));
		}
	 }
	 else if ($('#testType',window.parent.document).val() === 'group')
	 {		
		//get candidateID
		var candDivID=$("#attempterCandidateID").val();
		//examinee candidateID
		var examineeCanID = $("#examineeCandidateID").val();
		
		
		//if attempter and examinee are same : change Examinee Information
		$("#examineeImageRef",window.parent.document).show();
		//hide do you agree DIV's
		$("#"+candDivID+" .doyouagreeQ",window.parent.document).hide();
		if(candDivID==examineeCanID){
			$("#examineeImageRef img",window.parent.document).prop("src",$("#"+examineeCanID+" img",window.parent.document).prop("src"));
			$("#examineeImageRef span.showExamineeName",window.parent.document).text("").text($("#candidateName"+examineeCanID,window.parent.document).val());
			$(".showExamineeChosenOption",window.parent.document).hide();
			//set examinee
			$("#"+candDivID+" .examineeJudgefor",window.parent.document).text("").text("EXAMINEE");
			
			$("#"+candDivID,window.parent.document).removeAttr('data-examinee');
			$("#"+candDivID,window.parent.document).attr('data-examinee',"true");			
			
			//start animation
			$('.question-overlay',window.parent.document).fadeIn(500).delay(200).fadeOut(500);
			$('.osp-question-for',window.parent.document).animate({top: '105%', right: '50%', 'margin-right': '-16.5%'}, 500).delay(200).animate({top: '0%', right: '0%', 'margin-right': '1px'}, 500);
			
		}
		else{
			 var examineeSelOpSeqNo="";
			 if($("#examineeSelOpIDs").val().trim() != ""){
				var arrayOptIDs=$("#examineeSelOpIDs").val().split(",");
				for(var i=0;i<arrayOptIDs.length;i++){  
					examineeSelOpSeqNo=examineeSelOpSeqNo+$("input[id^=optionsAns][value="+arrayOptIDs[i]+"]").prop("class")+",";
				}
				examineeSelOpSeqNo=examineeSelOpSeqNo.substring(0, examineeSelOpSeqNo.length - 1);
				$("#examineeImageRef .examineeOptonSeqNo",window.parent.document).text("").text(examineeSelOpSeqNo);
				//set confidance level if available
				if($("#examineeSelConfLevel").val().trim() != "" && $('#isConfidenceLevelsetting').val() == "1"){
					$("#examineeImageRef .examineeConfLevel",window.parent.document).text("").text("with "+$("#examineeSelConfLevel").val()+" confidence");
				}
		     }
			$(".showExamineeChosenOption",window.parent.document).show();
			//set Peer
			$("#"+candDivID+" .examineeJudgefor",window.parent.document).text("").text("PEER ASSESSOR");
			
			//show do you agree option div
			$("#"+candDivID+" .doyouagreeQ.question",window.parent.document).show();
			//stop animation for PEER
			$('.question-overlay',window.parent.document).fadeIn(500);
			$('.osp-question-for',window.parent.document).animate({top: '105%', right: '50%', 'margin-right': '-16.5%'}, 500);
		}
		
		//change body class w.r.t Candidate 
		var bdClass="osp-user-"+$("#sequenceNo"+candDivID,window.parent.document).val();
		$("body").removeClass().addClass(bdClass);
		bdClass="osp exam exam-page "+bdClass;
		$("body",window.parent.document).removeClass().addClass(bdClass);
		//show candidate info div
		$("div.osp-question-for",window.parent.document).hide();
		$("#"+candDivID,window.parent.document).show();  
		
		//$('.question-overlay',window.parent.document).fadeIn(500).delay(200).fadeOut(500);
		//$('.osp-question-for',window.parent.document).animate({top: '105%', right: '50%', 'margin-right': '-16.5%'}, 500).delay(200).animate({top: '0%', right: '0%', 'margin-right': '1px'}, 500);
		if($('#itype').val() == 'NOOPT')
		{
			q.push($('div.osp-question-for[data-seq]:visible',window.parent.document).attr('id'));
			$('div.osp-question-for[data-seq]:hidden',window.parent.document).sort(function(a,b){
			   return +a.dataset.seq - +b.dataset.seq;
			}).each(function(){
			  q.push($(this).attr('id'));
			});
			for(var i=0; i< ($('div.box').length*q.length); i++ )
			{
				if(qIndex==q.length)
				{
				  qusIndex++;
				  qIndex=0;
				  q.push(q.shift());
				}
				if(qIndex==0)
				$('div.box[data-seq='+ qusIndex +']').addClass('bg-user-' + $('#sequenceNo' + q[qIndex],window.parent.document).val());
				$('#userdivs div#'+q[qIndex]).clone().appendTo('div.box[data-seq='+ qusIndex +']');
				$('div.box[data-seq='+ qusIndex +'] div[id='+q[qIndex]+'] div.user-img').addClass('user-' + $('#sequenceNo' + q[qIndex],window.parent.document).val());
				if(qIndex!=0)
				$('div.box[data-seq='+ qusIndex +'] div[id='+q[qIndex]+'] span.notification').addClass("pull-right");
				if(qIndex==0)
				$('div.box[data-seq='+ qusIndex +']').show();
				$('div.box[data-seq='+ qusIndex +'] div[id='+q[qIndex]+']').insertAfter('div.box[data-seq='+ qusIndex +'] div.lastAdded');
				$('div.box[data-seq='+ qusIndex +'] div.lastAdded').removeClass('lastAdded');
				$('div.box[data-seq='+ qusIndex +'] div[id='+q[qIndex]+']').addClass('lastAdded');
				$('div.box[data-seq='+ qusIndex +'] div[id='+q[qIndex]+'] img').attr('src',$('div[id='+ q[qIndex] + '] img',window.parent.document).attr('src'));
				$('div.box[data-seq='+ qusIndex +'] div[id='+q[qIndex]+'] span[id=fullname]').html($('div[id='+ q[qIndex] +'] p',window.parent.document).html());
				//$('div.box[data-seq='+ qusIndex +'] div[id='+q[qIndex]+']').show();
				
				qIndex++;
			}
			if(qIndex==q.length)
			{
			  qusIndex=0;
			  qIndex=0;
			  q.push(q.shift());
			}
			nextChatPerson();
		 }
	      //set item sequence Index number count
	      var curItemValue=$("#curitemID").val();
	      var itemSequenaceNumberValue=$("#itemSequenaceNumberValue",window.parent.document).val();
	      var indexValue=parseInt($("#itemSequenaceNumberText",window.parent.document).text());
	      if(indexValue < parseInt($("#ttlcount",window.parent.document).text()) && curItemValue!=itemSequenaceNumberValue){	    	  
	    	  $("#itemSequenaceNumberText",window.parent.document).text(indexValue+1);
	    	  $("#itemSequenaceNumberValue",window.parent.document).val(curItemValue);
	      }
	      //FIXME TODO ghisada solution to support one question in paper need to change
	      if(parseInt($("#ttlcount",window.parent.document).text()) == 1)
    	  {
	    	  $("#noTimesQuestionAsked",window.parent.document).val(parseInt($("#noTimesQuestionAsked",window.parent.document).val())+1);
    	  }
	      if(indexValue == parseInt($("#ttlcount",window.parent.document).text()) && (curItemValue!=itemSequenaceNumberValue || parseInt($("#noTimesQuestionAsked",window.parent.document).val()) > $('.osp-question-for',window.parent.document).length)){
	    	$('#hidOperations',window.parent.document).attr('src','../commonExam/hidFrameendTest');
	  		$('#hidOperations',window.parent.document).load();
	  		$('#modalEndTestMSG',window.parent.document).text($('#GroupEndTest',window.parent.document).val());
	    	window.parent.triggerModalIfrm();
	      }
	      //END FIXME TODO
	 }
 });
 
 function applyCls(clsToApply) {
	 if($('#testType',window.parent.document).val() === 'solo')
	 {		 
		 var cls="";
		 if($(parentItemNoDiv).hasClass('round'))
		 {
			 cls = clsToApply[1] +  clssub;
		 }
		 else
		 {
			 cls = clsToApply[1];
		 }
		 $(parentItemNoDiv).removeClass();
		 $(parentItemNoDiv).addClass(cls);
		 if($('#cbReview').is(":checked"))
		 {
			$(parentItemNoDiv).addClass('forreview');
		 }	
		 $(parentItemNoDiv).attr('data-status',clsToApply[0]);
		 getsetStatusCount();
		 
		 $('#QP'+curitemID,window.parent.document).attr('data-status',clsToApply[0]);
		 $('#qpStatus'+curitemID,window.parent.document).removeClass();
		 $('#qpStatus'+curitemID,window.parent.document).addClass(cls);	

	 	if(clsToApply[0] === clsnotans[0])
		 {	 		
			$(parentItemNoDiv).removeClass('forreview');
	 		//$(parentItemNoDiv).attr('title',$('#NotAnswered',window.parent.document).val());
	 		$('#qpStatus'+curitemID,window.parent.document).text($('#NotAnswered',window.parent.document).val());	 
		 }
	 	if(clsToApply[0] === clsans[0])
		 {
	 		//$(parentItemNoDiv).attr('title',$('#Answered',window.parent.document).val());
	 		$('#qpStatus'+curitemID,window.parent.document).text($('#Answered',window.parent.document).val());	 	
		 }
	 	if(clsToApply[0] === clsPans[0])
		 {
	 		//$(parentItemNoDiv).attr('title',$('#PartiallyAnswered',window.parent.document).val());
	 		$('#qpStatus'+curitemID,window.parent.document).text($('#PartiallyAnswered',window.parent.document).val());	 	
		 }	 
	 }
}
function getsetStatusCount() {
	if($('#testType',window.parent.document).val() === 'solo')
	 {
		$('#Cntntvisited',window.parent.document).text($("a[data-status="+ clsbase[0] +"][id^=lnk][data-section="+$('#sectionID').val()+"]",window.parent.document).length);
		$('#Cntmarked',window.parent.document).text(0);
		$('#CntNans',window.parent.document).text($("a[data-status="+ clsnotans[0] +"][id^=lnk][data-section="+$('#sectionID').val()+"]",window.parent.document).length);
		$('#Cntans',window.parent.document).text($("a[data-status="+ clsans[0] +"][id^=lnk][data-section="+$('#sectionID').val()+"]",window.parent.document).length);
		if($('#includesSubItems',window.parent.document).val()=="true")
		{
		$('#CntPattempt',window.parent.document).text($("a[data-status="+ clsPans[0] +"][id^=lnk][data-section="+$('#sectionID').val()+"]",window.parent.document).length);
		}
	 }
}
function doYouAgreeAnswer(answerAgreed,candDivID){
	//hide do you agree options div
	$("#"+candDivID+" .doyouagreeQ.question",window.parent.document).hide();
	
	if(answerAgreed==1){
		if($('#isConfidenceLevelsetting').val()==1)
		{
			$("input[name=confidenceLevel][value="+$("#examineeSelConfLevel").val()+"]").prop("checked",true);
			$("label."+$("#examineeSelConfLevel").val()).addClass("selected");			
		}		
		$("#"+candDivID+" .doyouagreeQ.yes",window.parent.document).show();
	}else{
		//reset the options
		$( "input[id^=optionsAns]" ).prop( "checked", false );
		$("#"+candDivID+" .doyouagreeQ.no",window.parent.document).show();
	}
	//reset animation for peer
	$('.question-overlay',window.parent.document).fadeOut(500);
	$('.osp-question-for',window.parent.document).animate({top: '0%', right: '0%', 'margin-right': '1px'}, 500);
}

//scrollTo Code


;(function(d){var k=d.scrollTo=function(a,i,e){d(window).scrollTo(a,i,e)};k.defaults={axis:'xy',duration:parseFloat(d.fn.jquery)>=1.3?0:1};k.window=function(a){return d(window)._scrollable()};d.fn._scrollable=function(){return this.map(function(){var a=this,i=!a.nodeName||d.inArray(a.nodeName.toLowerCase(),['iframe','#document','html','body'])!=-1;if(!i)return a;var e=(a.contentWindow||a).document||a.ownerDocument||a;return d.browser.safari||e.compatMode=='BackCompat'?e.body:e.documentElement})};d.fn.scrollTo=function(n,j,b){if(typeof j=='object'){b=j;j=0}if(typeof b=='function')b={onAfter:b};if(n=='max')n=9e9;b=d.extend({},k.defaults,b);j=j||b.speed||b.duration;b.queue=b.queue&&b.axis.length>1;if(b.queue)j/=2;b.offset=p(b.offset);b.over=p(b.over);return this._scrollable().each(function(){var q=this,r=d(q),f=n,s,g={},u=r.is('html,body');switch(typeof f){case'number':case'string':if(/^([+-]=)?\d+(\.\d+)?(px|%)?$/.test(f)){f=p(f);break}f=d(f,this);case'object':if(f.is||f.style)s=(f=d(f)).offset()}d.each(b.axis.split(''),function(a,i){var e=i=='x'?'Left':'Top',h=e.toLowerCase(),c='scroll'+e,l=q[c],m=k.max(q,i);if(s){g[c]=s[h]+(u?0:l-r.offset()[h]);if(b.margin){g[c]-=parseInt(f.css('margin'+e))||0;g[c]-=parseInt(f.css('border'+e+'Width'))||0}g[c]+=b.offset[h]||0;if(b.over[h])g[c]+=f[i=='x'?'width':'height']()*b.over[h]}else{var o=f[h];g[c]=o.slice&&o.slice(-1)=='%'?parseFloat(o)/100*m:o}if(/^\d+$/.test(g[c]))g[c]=g[c]<=0?0:Math.min(g[c],m);if(!a&&b.queue){if(l!=g[c])t(b.onAfterFirst);delete g[c]}});t(b.onAfter);function t(a){r.animate(g,j,b.easing,a&&function(){a.call(this,n,b)})}}).end()};k.max=function(a,i){var e=i=='x'?'Width':'Height',h='scroll'+e;if(!d(a).is('html,body'))return a[h]-d(a)[e.toLowerCase()]();var c='client'+e,l=a.ownerDocument.documentElement,m=a.ownerDocument.body;return Math.max(l[h],m[h])-Math.min(l[c],m[c])};function p(a){return typeof a=='object'?a:{top:a,left:a}}})(jQuery);
var chatcnt=0;
function nextChatPerson()
{
	if(qIndex==q.length)
	  {
	    qusIndex++;
	    qIndex=0;
	    q.push(q.shift());
	  }
	$('div.box[data-seq='+ qusIndex +'] div[id='+q[qIndex]+']').show();
	qIndex++;
	chatcnt++;	
}

