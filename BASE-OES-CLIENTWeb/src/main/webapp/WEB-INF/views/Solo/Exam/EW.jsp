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
<script src="<c:url value='/resources/js/ckeditor.js'></c:url>"></script>
<script src="<c:url value='/resources/js/Legends.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/QuestionRender.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/longAnswer.js?${jsTime }'></c:url>"></script>
<script	src="<c:url value='/resources/js/darkModeTheme.js'></c:url>"></script>
<script	src="<c:url value='/resources/js/screenshotPrevention.js'></c:url>"></script>
<script	src="<c:url value='/resources/js/stopwatchTimer.js'></c:url>"></script>
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
			<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.essayWriting.itemLanguage.item.itemID }" />
			<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
			<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
			<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
			<form:hidden path="candidateExamItemID"/>	
			<form:hidden path="item.Itemtype" value="EW" id="itype"/>
			<form:hidden path="fkItemID"/>
			<form:hidden path="candidateExam.candidatePaperLanguage" value="${selectedLang}" />
			<input type="hidden" id="sectionID" name="sectionID" value="0" />
			<input type="hidden" id="isLastItem" value="${candidateItemAssociation.isLastItem}">
			<input type="hidden" id="saveEW" name="saveEW" value="0"/>
			<input type="hidden" id="candidateExamID" name="candidateExamID" value="${examViewModel.candidateItemAssociation.fkCandidateExamID}"/>
			<input type="hidden" id="answerfilename" name="answerfilename"/>
			
		      <div class="question">
		          <div class="pull-left">
		              <strong id="quesnoText"><spring:message code="Exam.QuestionNo" /> </strong>
		          </div>
		          <div class="pull-right">
		          	<a id="btn-decrease" class="btn btn-mini btn-info btn-default2" href="#">A<sup>-</sup></a>
				    <a id="btn-orig" class="btn btn-mini btn-info btn-default2" href="#">A</a>
				    <a id="btn-increase" class="btn btn-mini btn-info btn-default2" href="#">A<sup>+</sup></a>
		          </div>
		      </div>
		      <div class="questiondiv scrollbar-outer">
		         <div id="${examViewModel.essayWriting.itemLanguage.fkLanguageID}" class="qdiv">
		          	 <p class="question-wrap">${examViewModel.essayWriting.itemText }</p>
		          	 <c:if test="${examViewModel.essayWriting.itemImage != null && examViewModel.essayWriting.itemImage != ''  && fn:length(examViewModel.essayWriting.itemImage) > 0}">
		          	 	<img src="../exam/displayImage?disImg=${examViewModel.essayWriting.itemImage}"/>
		          	 </c:if>
		          	 <br/>
		          	 <br/>	
		          	 <div id="longtextanswer">
		          	  	<!-- <span><span id="charText">Total word count:</span>&nbsp;<span id="charCount">0</span></span> -->
		          	  	<form:textarea path="candidateAnswers[0].typedText" autoComplete="off" autoCorrect="off" autoCapitalize="off" spellCheck="false" onselectstart="return false" class="form-control answerdata markdown" id="optionsAns"></form:textarea>
		          	 </div> 
		          	
 		          	<input type="file" id="ansfile" name="ansfile" multiple style="display: none;"> 
		          		<input type="file" id="selAnsfile" name="selAnsfile" onchange="changeInputValue()" multiple  style="display: none;">
		          		<small class="text-warning"><spring:message code="Exam.EW_selectAllFilesBeforeSave"/></small>
		          		<br/>
					    <button type="button" onclick="selectImage()"><spring:message code="Exam.EW_selectFile"/></button>&nbsp;
					    <br/>
					    <div id="imageList"></div>
					    <br/>
		          	 <c:if test="${examViewModel.candidateItemAssociation.candidateAnswers[0].answerFileName != null}">
	          	 	<spring:message code="Exam.EW_AlreadyUploadedFile"/> <%-- 	<strong>${examViewModel.candidateItemAssociation.candidateAnswers[0].answerFileName}</strong> --%>
			          	 	<c:forEach var="fileName" items="${fn:split(examViewModel.candidateItemAssociation.candidateAnswers[0].answerFileName,',')}">
							    <strong> <br> ${fileName}</strong>
							</c:forEach>
		          	 	<input type="hidden" id="savedAnswerFileName" value="${examViewModel.candidateItemAssociation.candidateAnswers[0].answerFileName}"/>
		          	 </c:if>
		          	<form:hidden path="candidateAnswers[0].candidateExamItemID" />
					<form:hidden path="candidateAnswers[0].fkcandidateID" />
					<form:hidden path="candidateAnswers[0].fkItemID" />
					<form:hidden path="candidateAnswers[0].candidateAnswerID" />
					<form:hidden path="candidateAnswers[0].fkCandidateExamID" />
					<form:hidden path="candidateAnswers[0].fkExamEventID" />           	       	  
		        </div>
		     </div> 
		     <div class="action" style="position:fixed; width: 90%">  
		     	<c:if test="${sessionScope.exampapersetting.showReset}">
		     		<button class="btn btn-lblue pull-right" name="Reset" id="Reset" type="submit"><spring:message code="Exam.Reset" /></button>
		     	</c:if>
		     	<c:if test="${sessionScope.exampapersetting.showSkip}">
		     		<button class="btn btn-lblue pull-right" name="Skip" id="Skip" type="button" onclick="window.parent.skipThis()"><spring:message code="Exam.Skip" /></button>
		     	</c:if>
<%-- 		     	<button class="btn btn-lblue pull-left" name="Save" id="Save" type="submit"><spring:message code="Exam.SaveNext" /></button> --%>
				<button class="btn btn-lblue pull-left" name="Save" id="Save" type="button" onclick="resetStopwatch()"><spring:message code="Exam.SaveNext" /></button>
		     	<c:if test="${sessionScope.exampapersetting.showMarkForReview}">
		     		<div id="markr">
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