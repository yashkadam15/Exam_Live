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

<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css"/>
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
/* .modal-backdrop {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1040;
  background-color: #000000;
}

.modal-backdrop, .modal-backdrop.fade.in {
  opacity: 0.8;
  filter: alpha(opacity=80);
} */

.p-l1 {
margin-top:4px;
}

.dropdown-item1 {
    display: block;                                                                                                                                                                                                                                                                   ;
    padding:6px 0px 6px 0px !important;                                                                            
    clear: both;
    font-weight: 400;
    color: #212529;
    text-align: inherit;
    white-space: nowrap;
    background-color: transparent;
    border: 0;
}

.action .dropdown-menu {
	top: -115px !important;
}




/** new classes for Report ***/ 

.dropdown-item1 {
    display: block;                                                                                                                                                                                                                                                                   ;
    padding:6px 0px 6px 0px !important;                                                                            
    clear: both;
    font-weight: 400;
    color: #212529;
    text-align: inherit;
    white-space: nowrap;
    background-color: transparent;
    border: 0;
}


.report-text{
 	font-size: 12px;
    font-style: normal;
    color: #0677d7; /*#3b02c1;*/
    font-family: monospace;
    font-weight: 600;
}

.report-btn {
	background-color: #f36745;
    padding-top: 0px;
    padding-bottom: 0px;
}
.btn-group.open .btn.dropdown-toggle {
background-color:#f97656; 
}

.style-1 {
	border-bottom: 1px solid #ccc;
    padding: 5px 11px;
    font-weight: 600;
}
.dropdown-item1:hover{
	background-color:#ccc; 
	text-decoration:none;
}

.dropdown-item1:focus {
text-decoration:none; }

.pd-4 {
padding:10px;  
}


.style2 {
	border-bottom: 2px solid #efefef;
  	margin:10px; 
}
</style>
</head>
<body class="exampage exampage-hgt">
<div class="main container-fluid bg1"  style=" background-image: none;">	
<input type="hidden" id="dbanscnt" name="dbanscnt" value="${examViewModel.openObject}"/>
	<form:form action="ProcessQuestion" method="POST" id="frmQues" modelAttribute="candidateItemAssociation">
		<div class="inner-questions-area">	
		<input type="hidden" id="hidExt" name="hidExt" value="-1"/>
		<c:choose>
			<c:when test="${mode != null}">
				<input type="hidden" id="mode" name="mode" value="${mode}"/>
			</c:when>
			<c:otherwise>
				<input type="hidden" id="mode" name="mode" value="off"/>
			</c:otherwise>
		</c:choose>	
		<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}"/>
		<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.multipleChoiceSingleCorrect.itemLanguage.item.itemID }" />
		<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
		<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
		<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
		<form:hidden path="candidateExamItemID"/>	
		<form:hidden path="item.Itemtype" value="MCSC" id="itype"/>
		<form:hidden path="fkItemID"/>
		<input type="hidden" id="sectionID" name="sectionID" value="0" />
		<input type="hidden" id="isLastItem" value="${candidateItemAssociation.isLastItem}">
	      
	      <div class="question">
	          <div class="pull-left">
	              <strong id="quesnoText"><spring:message code="Exam.QuestionNo" /> </strong>
	          </div>
	          
	        <c:if test="${sessionScope.exampapersetting.showReportItem}">
	        &nbsp;
			<c:choose>
			    <c:when test="${reportedItemClaimCode ne null}">
			        <span id="spanReportedClaimCode" class="report-text"><spring:message code="Exam.reportedQuestionAs" /> ${reportedItemClaimCode.displayText}</span>
			    </c:when>
			    <c:otherwise>
					<div id="divRIIcon" class="btn-group" role="group" data-toggle="tooltip" title="<spring:message code='Exam.reportThisQuestion' />">
					    <button id="btnGroupDrop1" type="button" class="btn btn-outline-primary report-btn dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					      <i class="icon-white icon-exclamation-sign Dropdown p-l1"> </i> <span id="spanSelectedClaimText"></span><input type="hidden" id="inpSelectedClaimKey" name="inpSelectedClaimKey">
					    </button>
					    <div class="dropdown-menu " aria-labelledby="btnGroupDrop1">	
					    <span class="style-1"><spring:message code='Exam.reportThisQuestionAs' />	    </span>  
						    <c:forEach var="claimCodeOption" items="${claimCodeOptions}">			    
						    <c:if test="${!(claimCodeOption == 'NOCLAIM' || claimCodeOption == 'OTHER')}">
						    <!-- <a class="dropdown-item1" href="#" onclick="showSelectedClaim('${claimCodeOption}', '${claimCodeOption.displayText}')">${claimCodeOption.displayText}</a> -->
						    <!-- <a class="dropdown-item1" href="#" onclick="window.parent.saveReportedItem('${claimCodeOption}')">${claimCodeOption.displayText}</a>-->
						    <a class="dropdown-item1 " href="#" onclick="window.parent.saveReportedItem('${claimCodeOption}','${claimCodeOption.displayText}')"> <Span class="pd-4">${claimCodeOption.displayText} </Span></a> 
						    </c:if>			    			    	
							</c:forEach>
					    </div>	
					 </div>
			    </c:otherwise>
			</c:choose>   
	        
	        <span id="spanReportingQuestion" style="display: none;"><spring:message code="Exam.reportingQuestion" /></span>
	        <span id="spanReportingQuestionError" style="display: none;"><spring:message code="Exam.errorReportingQuestion" /></span>
	        <span id="spanReportedItemSuccess" style="display: none;"><spring:message code="Exam.reportedQuestionAs" /></span>
	     	
		  	
		  	</c:if>
	          
	          
	          
	          <div class="pull-right">
	          	<a id="btn-decrease" class="btn btn-mini btn-info btn-default2" href="#">A<sup>-</sup></a>
			    <a id="btn-orig" class="btn btn-mini btn-info btn-default2" href="#">A</a>
			    <a id="btn-increase" class="btn btn-mini btn-info btn-default2" href="#">A<sup>+</sup></a>
	          </div>
	          		
	      </div>
	      
	      <div class="questiondiv scrollbar-outer">
	         <div id="${examViewModel.multipleChoiceSingleCorrect.itemLanguage.fkLanguageID}" class="qdiv">
	    	 <p class="question-wrap">${examViewModel.multipleChoiceSingleCorrect.itemText }</p>
	    	 <c:if test="${examViewModel.multipleChoiceSingleCorrect.itemImage != null && examViewModel.multipleChoiceSingleCorrect.itemImage != ''  && fn:length(examViewModel.multipleChoiceSingleCorrect.itemImage) > 0}">
	    	 	<img src="../exam/displayImage?disImg=${examViewModel.multipleChoiceSingleCorrect.itemImage}"/>
	    	 </c:if>
	    	 <br/>
	    	 <br/>		              	
	    	 <c:forEach items="${examViewModel.multipleChoiceSingleCorrect.optionList}" var="option" varStatus="j">              	
		          <div class="controls">
		          <form:hidden path="candidateAnswers[${j.index }].candidateExamItemID"/>
		          <form:hidden path="candidateAnswers[${j.index }].fkcandidateID"/>
		          <form:hidden path="candidateAnswers[${j.index }].fkItemID"/>
		          <form:hidden path="candidateAnswers[${j.index }].candidateAnswerID"/>
		          <form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID"/>
		          <form:hidden path="candidateAnswers[${j.index }].fkExamEventID"/>
		          <label class="radio">
		          <c:choose>
		          	<c:when test="${candidateItemAssociation.candidateAnswers[j.index]  != null && candidateItemAssociation.candidateAnswers[j.index].optionID >0 }">
		          		<form:radiobutton path="candidateAnswers[0].optionID" checked="checked" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
		          	</c:when>
		          	<c:otherwise>
		          		<form:radiobutton path="candidateAnswers[0].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
		          	</c:otherwise>
		          </c:choose>		                    
		         		<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
		         		<div class="question-wrap">${option.optionText }</div>	                   		
		         		</c:if>	
		         		 <c:if test="${option.optionImage != null && option.optionImage != ''  && fn:length(option.optionImage) > 0}">
		         		 	<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
		         		 	<br/>
		         		 	</c:if>
		    	 			<img src="../exam/displayImage?disImg=${option.optionImage}"/>
		    	 		</c:if>
		          </label>
		          </div>
	    	 </c:forEach>
	  		</div>
	     </div> 
	     <div class="action"  style="position:fixed; width: 90%">  
	     	<c:if test="${sessionScope.exampapersetting.showReset}">
	     		<button class="btn btn-lblue pull-right" name="Reset" id="Reset" type="submit"><spring:message code="Exam.Reset" /></button>
	     	</c:if>
	     	<c:if test="${sessionScope.exampapersetting.showSkip}">
	     		<button class="btn btn-lblue pull-right" name="Skip" id="Skip" type="button" onclick="window.parent.skipThis()"><spring:message code="Exam.Skip" /></button>
	     	</c:if>
	     	
	     	<button class="btn btn-lblue pull-left" name="Save" id="Save" type="submit"><spring:message code="Exam.SaveNext" /></button>
	     						      <div class="btn-group" role="group">
    <button id="btnGroupDrop1" type="button" class="btn btn-outline-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      <i class="icon-greyer icon-exclamation-sign Dropdown p-l1"> </i> Report
    </button>
    <div class="dropdown-menu" aria-labelledby="btnGroupDrop1">
      <a class="dropdown-item1" href="#"> Report link 1 </a>
      <a class="dropdown-item1" href="#"> Report link 2 </a>
      <a class="dropdown-item1" href="#"> Report link 3 </a>
    </div>
  </div>
	     	<c:if test="${sessionScope.exampapersetting.showMarkForReview}">
	     		<div id="markr" class="pull-left">
	     			<span class="btn markreview-btn ">
		          		<form:checkbox path="isMarkedForReview" id="cbReview"/>
		          		<label for="cbReview"><spring:message code="Exam.MarkforReview" /></label>
	       			</span>
	       		</div>
	     	</c:if>
	     </div>
	     </div>
	    
     </form:form> 
     </div>
</body>
</html>                       