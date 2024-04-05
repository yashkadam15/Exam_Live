<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
<script src="<c:url value='/resources/js/simulation.js?${jsTime }'></c:url>"></script>
<script	src="<c:url value='/resources/js/darkModeTheme.js'></c:url>"></script>
<script	src="<c:url value='/resources/js/screenshotPrevention.js'></c:url>"></script>
<script	src="<c:url value='/resources/js/stopwatchTimer.js'></c:url>"></script>
<script>
darkModeCheck();
</script>
<style>
body {
	-webkit-user-select: none; /* Chrome all / Safari all */
	-moz-user-select: none; /* Firefox all */
	-ms-user-select: none; /* IE 10+ */
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
				<input type="hidden" id="hidExt" name="hidExt" value="-1" />
				<c:choose>
					<c:when test="${mode != null}">
						<input type="hidden" id="mode" name="mode" value="${mode }" />
					</c:when>
					<c:otherwise>
						<input type="hidden" id="mode" name="mode" value="off" />
					</c:otherwise>
				</c:choose>
				<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}" />
				<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.simulations[0].itemLanguage.item.itemID }" />
				<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
				<input type="hidden" id="itemBankID" name="itemBankID" value="${examViewModel.itemBankItemAssociation.fkItemBankID}" />
				<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}" />
				<form:hidden path="candidateExamItemID" />
				<!-- set Item type to Default Simulation -->
				<form:hidden path="item.Itemtype" value="SML" id="itype"/>
				<form:hidden path="fkItemID"/>
				<!-- set is correct to true -->
				<form:hidden path="isCorrect" value="false" class="ca-iscorrect"/>
				<input type="hidden" id="sectionID" name="sectionID" value="0" />
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
						<c:when test="${examViewModel != null && examViewModel.simulations != null && fn:length(examViewModel.simulations) > 1}">
							<div class="pull-right">
						</c:when>
						<c:otherwise>
							<div class="pull-right" style="display: none">
						</c:otherwise>
					</c:choose>
					<spring:message code="Exam.ViewIn" />
					<select id="viewLang">
						<c:forEach items="${examViewModel.simulations}" var="item" varStatus="i">
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
			<c:forEach items="${examViewModel.simulations}" var="item" varStatus="i">
				<c:choose>
					<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">

						<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
							<p class="question-wrap">${item.itemText }</p>
							<c:if test="${item.itemImage != null && item.itemImage != ''  && fn:length(item.itemImage) > 0}">
								<img src="../exam/displayImage?disImg=${item.itemImage}" />
							</c:if>
							<br /> <br />
							<%--   <strong><spring:message code="Exam.Options" /> :</strong> --%>
							<br /> <br />
							<div class="controls">
								<%--  <form:hidden path="candidateAnswers[0].candidateExamItemID"/>
			                    <form:hidden path="candidateAnswers[0].fkcandidateID"/>
			                    <form:hidden path="candidateAnswers[0].fkItemID"/>
			                    <form:hidden path="candidateAnswers[0].candidateAnswerID"/>
			                    <form:hidden path="candidateAnswers[0].isCorrect" value="true"/>
			                      <!-- simulation related attributes -->
				                <form:hidden path="candidateAnswers[0].totalSteps" value="0" class="ca-totalSteps"/>
				                <form:hidden path="candidateAnswers[0].rightSteps" value="0" class="ca-rightSteps"/>
				                <form:hidden path="candidateAnswers[0].wrongSteps" value="0" class="ca-wrongSteps"/>
				                <form:hidden path="candidateAnswers[0].marksInPercentage" value="0" class="ca-marksInPercentage"/> --%>
							</div>
						 
                           <%--  <c:choose>
	                            <c:when test="${examViewModel.candidateItemAssociation.itemStatus != 'Answered'}">
	                            	<a class="btn openFlashbtn" data-src="../exam/decruptDecompressfile?encfile=${item.itemFilePath}" data-psw="${item.password}"><spring:message code="Exam.StartPractical" /></a>
	                            </c:when>
	                            <c:otherwise> 
	                            	<a class="btn disabled"><spring:message code="Exam.StartPractical" /></a>
	                            </c:otherwise>
                            </c:choose> --%>
							<a class="btn openFlashbtn" data-src="../exam/decruptDecompressfile?encfile=${item.itemFilePath}" data-psw="${item.password}"><spring:message code="Exam.StartPractical" /></a>
						</div>


					</c:when>
					<c:otherwise>
						<c:set value="${item.itemFilePath}" var="itemfilepath" scope="page" />
						<c:set value="${item.fileTypeExtension}" var="fileTypeExtension" scope="page" />
						<c:set value="${item.numberOfSteps}" var="numberOfSteps" scope="page" />
						<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
							<p class="question-wrap">${item.itemText }</p>
							<c:if test="${item.itemImage != null && item.itemImage != ''  && fn:length(item.itemImage) > 0}">
								<img src="../exam/displayImage?disImg=${item.itemImage}" />
							</c:if>
							<br /> <br />
							<%--  <strong><spring:message code="Exam.Options" /> :</strong>	 --%>
							<br /> <br />
							<div class="controls">
								<%--  <form:hidden path="candidateAnswers[0].candidateExamItemID"/>
			                    <form:hidden path="candidateAnswers[0].fkcandidateID"/>
			                    <form:hidden path="candidateAnswers[0].fkItemID"/>
			                    <form:hidden path="candidateAnswers[0].candidateAnswerID"/>
			                    <form:hidden path="candidateAnswers[0].isCorrect" value="true"/>
			                      <!-- simulation related attributes -->
				                <form:hidden path="candidateAnswers[0].totalSteps" value="0" class="ca-totalSteps"/>
				                <form:hidden path="candidateAnswers[0].rightSteps" value="0" class="ca-rightSteps"/>
				                <form:hidden path="candidateAnswers[0].wrongSteps" value="0" class="ca-wrongSteps"/>
				                <form:hidden path="candidateAnswers[0].marksInPercentage" value="0" class="ca-marksInPercentage"/> --%>
							</div>
   							<%--  <c:choose>
   							   <c:when test="${examViewModel.candidateItemAssociation.itemStatus != 'Answered'}">
                            		<a class="btn openFlashbtn" data-src="../exam/decruptDecompressfile?encfile=${item.itemFilePath}" data-psw="${item.password}"><spring:message code="Exam.StartPractical" /></a>
                               </c:when>
                            	<c:otherwise> 
                            		<a class="btn disabled"><spring:message code="Exam.StartPractical" /></a>
                            	</c:otherwise>
                            </c:choose> --%>
							<a class="btn openFlashbtn" data-src="../exam/decruptDecompressfile?encfile=${item.itemFilePath}" data-psw="${item.password}"><spring:message code="Exam.StartPractical" /></a>
						</div>

					</c:otherwise>
				</c:choose>
			</c:forEach>
			
			<input type="hidden" value="" id="swfpassword"/>	
			<!-- candidate answer -->
			<form:hidden path="candidateAnswers[0].candidateExamItemID" />
			<form:hidden path="candidateAnswers[0].fkcandidateID" />
			<form:hidden path="candidateAnswers[0].fkItemID" />
			<form:hidden path="candidateAnswers[0].candidateAnswerID" />
			<!-- iscorrect by default true -->
			<form:hidden path="candidateAnswers[0].isCorrect" value="false" class="ca-iscorrect"/>
			<!-- simulation related attributes -->
			<form:hidden path="candidateAnswers[0].totalSteps" class="ca-totalSteps" />
			<form:hidden path="candidateAnswers[0].rightSteps" class="ca-rightSteps" />
			<form:hidden path="candidateAnswers[0].wrongSteps"  class="ca-wrongSteps" />
			<form:hidden path="candidateAnswers[0].marksInPercentage" class="ca-marksInPercentage" value="0"/>
			<form:hidden path="candidateAnswers[0].fkCandidateExamID"/>
		    <form:hidden path="candidateAnswers[0].fkExamEventID"/>
		</div>
		<div class="action" style="position: fixed; width: 90%">
			<c:if test="${sessionScope.exampapersetting.showReset}">
     		<button class="btn btn-lblue pull-right" name="Reset" id="Reset" type="submit"><spring:message code="Exam.Reset" /></button>
     	</c:if>
     	<c:if test="${sessionScope.exampapersetting.showSkip}">
     		<button class="btn btn-lblue pull-right" name="Skip" id="Skip" type="button" onclick="window.parent.skipThis()"><spring:message code="Exam.Skip" /></button>
     	</c:if>
     		<button class="btn btn-dblue pull-right" name="Save" id="Save" style="display: none;" type="submit" onclick="resetStopwatch()">
				<spring:message code="Exam.SaveNext" />
			</button>
     		<button class="btn btn-lblue pull-left" name="Next" id="Next" type="submit"><spring:message code="Exam.Next" /></button>
		</div>
		
		</form:form>
	</div>
	</div>


</body>
</html>
