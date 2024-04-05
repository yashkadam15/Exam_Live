<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="Exam.Title" /></title>

<spring:theme code="curdetailtheme" var="curdetailtheme"/>
<spring:theme code="playertheme" var="playertheme"/>

<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<!--[if IE 7]>
<style>
.exam-info .exam-ins .span5 {margin-left:0}
.exam-info .exam-ins .span7 .btn {margin-top: 4px; padding-top: 0; height:5px}
.quick-ques > .btn {border:1px solid #ccc}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.scrollbar.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/Legends.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/QuestionRender.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script	src="<c:url value='/resources/js/darkModeTheme.js'></c:url>"></script>
<script>
darkModeCheck();
</script>
<style>
body {
  -webkit-user-select: none;  /* Chrome all / Safari all */
  -moz-user-select: none;     /* Firefox all */
  -ms-user-select: none;      /* IE 10+ */
 
  /* No support for these yet, use at own risk */
  -o-user-select: none;
  user-select: none;
}
</style>
</head>
<body class="exampage exampage-hgt">
<div class="main container-fluid bg1" style=" background-image: none;">
	<div id="askPwdsModal" class="modal hide fade in examModal" style="display: none;width: 57%;">
		<div class="modal-header">
			<h3><spring:message code="Exam.entersupervisorpassword" /></h3>
		</div>
		<div class="modal-body">
			<p id="askPwdsmodalMsg"><spring:message code="Exam.Media.PasswordLabel" /></p>
			<iframe src="" id="hidOperations" style="display: none;height: 0px;width: 0px"> </iframe>
			<label id="waitforprocess" style="display: none;font-weight: bold;"><spring:message code="Exam.Pleasewaitwhileprocessing" /></label>	
			<input type="password" id="takepwd">
			
			<p id="askPwdModalErrMsg" style="display: none; color: red;"><spring:message code="Exam.incorrectsuppsw" /></p>

		</div>
		<div class="modal-footer">
		   	  <a class="btn btn-success" id="chkpwd"><spring:message code="Exam.Yes" /></a> 	  		
			  <a class="btn askPwdsModalClose" id="cancelpwd"><spring:message code="Exam.No" /></a>
		</div>
	</div>
	<input type="hidden" id="dbanscnt" name="dbanscnt" value="${examViewModel.openObject}"/>
<form:form action="ProcessQuestion" method="POST" id="frmQues" modelAttribute="candidateItemAssociation">
<div class="inner-questions-area">	
	<input type="hidden" id="hidExt" name="hidExt" value="-1"/>
		<c:choose>
		<c:when test="${mode != null}">
			<input type="hidden" id="mode" name="mode" value="${mode }"/>
		</c:when>
		<c:otherwise>
			<input type="hidden" id="mode" name="mode" value="off"/>
		</c:otherwise>
	</c:choose>	
	<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}"/>
	<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.riformItems[0].itemLanguage.item.itemID }" />
	<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
	<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
	<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
	<form:hidden path="candidateExamItemID" id="ceiid"/>
    <form:hidden path="fkCandidateExamID" /> 
    <form:hidden path="fkCandidateID" /> 
    <form:hidden path="fkItemID" /> 
    <form:hidden path="fkParentItemID" /> 
	<form:hidden path="item.Itemtype" value="RIFORM" id="itype"/>
	<input type="hidden" value="${examViewModel.candidateItemAssociation.mediaPlayedCount}" id="mpc"/>
	<input type="hidden" id="sectionID" name="sectionID" value="0" />
	
	<input type="hidden" id="hidAnsDuration" value="${examViewModel.riformItems[0].answerDuration}"/>
	<input type="hidden" id="hidAnsMode" value="${examViewModel.riformItems[0].answeringMode}"/>
	<input type="hidden" id="hidRecordedFileName" name="hidRecordedFileName" value="${candidate.userName }_${paper.code}" />
    <form:hidden path="timeTakenInSeconds" id="timeTakenInSec" />
    <form:hidden path="candidateAnswers[0].optionFilePath" id="optionFilePath"/>
    <form:hidden path="candidateAnswers[0].candidateExamItemID" />
	<form:hidden path="candidateAnswers[0].fkcandidateID" />
	<form:hidden path="candidateAnswers[0].fkItemID" />
	<form:hidden path="candidateAnswers[0].candidateAnswerID" />
	
	<form:hidden path="candidateAnswers[0].fkCandidateExamID"/>
    <form:hidden path="candidateAnswers[0].fkExamEventID"/>
	<input type="hidden" id="isLastItem" value="${candidateItemAssociation.isLastItem}">
      <div class="question">
          <div class="pull-left">
              <strong id="quesnoText"><spring:message code="Exam.QuestionNo" /> </strong>
          </div>
          <div class="pull-right">
          	<a id="btn-decrease" class="btn btn-mini btn-info btn-default2" href="#">A<sup>-</sup></a>
		    <a id="btn-orig" class="btn btn-mini btn-info btn-default2" href="#">A</a>
		    <a id="btn-increase" class="btn btn-mini btn-info btn-default2" href="#">A<sup>+</sup></a>
          </div>
          <c:choose>
          	<c:when test="${examViewModel != null && examViewModel.riformItems != null && fn:length(examViewModel.riformItems) > 1}">
          		<div class="pull-right">
          	
          	</c:when>
          	<c:otherwise>
          		<div class="pull-right" style="display: none">
          	</c:otherwise>
          </c:choose>
              <spring:message code="Exam.ViewIn" />
               <select id="viewLang"> 
              <c:forEach items="${examViewModel.riformItems }" var="item" varStatus="i">
              	<c:choose>
              		<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">
              			<option selected="selected" value="${item.itemLanguage.fkLanguageID}">${item.itemLanguage.language.languageName }</option>
              		</c:when>
              		<c:otherwise>
              			<option value="${item.itemLanguage.fkLanguageID}">${item.itemLanguage.language.languageName }</option>
              		</c:otherwise>
              	</c:choose>                 
              </c:forEach>
              </select>
             <!--  <span class="fs"><a class="btn fs-minus" href="#">A<sup>-</sup></a><a class="btn fs-reset" href="#">A</a><a class="btn fs-plus" href="#">A<sup>+</sup></a></span>
              Time : <strong>0.5</strong> -->
          </div>
      </div>       		
       						 
      <div class="questiondiv scrollbar-outer">
         <c:forEach items="${examViewModel.riformItems }" var="item" varStatus="i">      
         	<c:choose>
         		<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">
         			<div id="${item.itemLanguage.fkLanguageID}_1" class="qdiv">    

         			     <c:if test="${item.itemText != null && item.itemText != ''  && fn:length(item.itemText) > 0}">
	              	 				<p class="question-wrap">${item.itemText }</p>
	              	 			 </c:if>
         			        <div class="controls">
                         		 <c:if test="${item.itemFilePath != null && item.itemFilePath != ''  && fn:length(item.itemFilePath) > 0}">
		              	 			
		              	 			<c:if test="${item.multimediaType =='AUDIO'}">
		              	 				<div id="MMplayer_${i.index+1}" data-mediamode="exam" data-mediatype="audio" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="false" data-mediatitle=" "></div>
		              	 			 </c:if>
		              	 			 <c:if test="${item.multimediaType =='VIDEO'}">
		              	 				<div id="MMplayer_${i.index+1}" data-mediamode="exam" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="false" data-mediatitle=" "></div>
		              	 			 </c:if>
		              	 			 <c:if test="${item.multimediaType =='IMAGE'}">
		              	 				<img src="../exam/displayImage?disImg=${item.itemFilePath}"/>
		              	 			 </c:if>
	              	 			 
	              	 			 </c:if>
	              	 			
                        	</div>         			        
							<!-- <button class="btn btn-lblue openFlashbtn" name="startRecord" id="startRecord" type="button">Start Recording</button>  -->
              		</div> 
         		</c:when>
         		<c:otherwise>
         			<div id="${item.itemLanguage.fkLanguageID}_1" class="qdiv">         			
							<c:if test="${item.itemText != null && item.itemText != ''  && fn:length(item.itemText) > 0}">
	              	 				<p class="question-wrap">${item.itemText }</p>
	              	 		 </c:if>  
         			        <div class="controls">
                   		     <c:if test="${item.itemFilePath != null && item.itemFilePath != ''  && fn:length(item.itemFilePath) > 0}">
              	 				<c:if test="${item.multimediaType =='AUDIO'}">
		              	 				<div id="MMplayer_${i.index+1}" data-mediamode="exam" data-mediatype="audio" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="false" data-mediatitle=" "></div>
		              	 			 </c:if>
		              	 			 <c:if test="${item.multimediaType =='VIDEO'}">
		              	 				<div id="MMplayer_${i.index+1}" data-mediamode="exam" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="false" data-mediatitle=" "></div>
		              	 			 </c:if>
		              	 			 <c:if test="${item.multimediaType =='IMAGE'}">
		              	 				<img src="../exam/displayImage?disImg=${item.itemFilePath}"/>
		              	 			 </c:if>
              	 			 </c:if>  
              	 			                     		
                        	</div>	         			        
			              	<!-- <button class="btn btn-lblue" name="startRecord" id="startRecord" type="button">Record Answer</button> -->     
              		</div>
         		</c:otherwise>         		
         	</c:choose>
         </c:forEach>  
         <!-- "username_papercode_timestamp" -->  
         <!-- answerduration,answeringmode"username_papercode_timestamp" -->
     </div> 
    
     <div class="action" style="position:fixed;background-color: #ffffff; width: 90%">
     	<%-- <c:if test="${sessionScope.exampapersetting.showReset}">
     		<button class="btn btn-lblue pull-right" name="Reset" id="Reset" type="submit"><spring:message code="Exam.Reset" /></button>
     	</c:if> --%>
     	<c:if test="${sessionScope.exampapersetting.showSkip}">
     		<button class="btn btn-lblue pull-right" name="Skip" id="Skip" type="button" onclick="window.parent.skipThis()"><spring:message code="Exam.Skip" /></button>
     	</c:if>
     	<button class="btn btn-lblue pull-left" name="Save" id="Save" style="display: none;" type="submit" >
				<spring:message code="Exam.SaveNext" />
			</button>
     		<button class="btn btn-lblue pull-left" name="Next" id="Next" type="submit"><spring:message code="Exam.Next" /></button>
     		  <c:choose>
	                            <c:when test="${examViewModel.candidateItemAssociation.itemStatus != 'Answered'}">
	                            <button class="btn btn-lblue pull-left" name="RecordAnswer" id="RecordAnswer" type="button"><spring:message code="Exam.recordAnswer"/></button>	                            	
	                            </c:when>
	                            <c:otherwise> 
	                            <button class="btn btn-lblue pull-left btn disabled" name="RecordAnswer" id="RecordAnswer" type="button" disabled><spring:message code="Exam.recordAnswer"/></button>	                            	
	                            </c:otherwise>
                            </c:choose>
     		
     		
     </div>
    
     </form:form>   
     </div> 
   </div>
   <script>
   $(window).load(function(){
	   var qphght = $('.qdiv-player').height();
	   var phght = $('.palette1').height();
	   $('.palette1').css({ 'top': qphght });
	   if($('html').css('direction')=='rtl')
	   {
		   $('.qdiv-questions').css({ 'padding-top': phght+5 });
	   }	   
	   if($('html').css('direction')=='ltr')
	   {
		   $('.qdiv-questions').css({ 'padding-top': qphght+phght+5 });
	   }
   });
  
   </script>
</body>
</html>                       