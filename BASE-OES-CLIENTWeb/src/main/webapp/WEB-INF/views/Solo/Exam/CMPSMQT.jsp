<%@page contentType="text/html;charset=UTF-8"%>
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
<script src="<c:url value='/resources/js/ckeditor.js'></c:url>"></script>
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
		<input type="hidden" id="dbanscnt" name="dbanscnt" value="${examViewModel.openObject}"/>
		<form:form action="ProcessQuestion" method="POST" id="frmQues" modelAttribute="candidateItemAssociation">
			<div class="inner-questions-area">	
				<input type="hidden" id="hidExt" name="hidExt" value="-1"/>
				<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}"/>
				<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.comprehensionMixQT.itemLanguage.item.itemID }" />
				<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
				<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
				<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
				<form:hidden path="candidateExamItemID"/>
			    <form:hidden path="fkCandidateExamID" /> 
			    <form:hidden path="fkCandidateID" /> 
			    <form:hidden path="fkItemID" /> 
			    <form:hidden path="fkParentItemID" /> 
				<form:hidden path="item.Itemtype" value="CMPSMQT" id="itype"/>
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
			      </div>       		
			       						 
			      <div class="questiondiv">
			      	<div class="palette1">
			      		<div class="quick-ques1 cmpsmqtsubpallet" style="padding: 4px">
			      			Sub-Questions:
							<c:forEach items="${subItemAssociations}" var="subItem" varStatus="i">
								<a data-subqid="${(subItem.fkItemID)}" id="Sublnk${subItem.fkItemID}" data-parent="${(subItem.fkParentItemID)}" href="../exam/TakeTest" class="btn btn-mini ${(subItem.itemStatus == 'NotAnswered' ? 'btn-red' : 'btn-greener')}${(subItem.isMarkedForReview ? ' forreview' : '')}" data-status="${(subItem.itemStatus == 'NotAnswered' or cia.itemStatus == 'Skipped' ? 'noans' : 'ans')}">${i.index+1}</a>
							</c:forEach>
			      		</div>
			      	</div>
					<div id="${examViewModel.comprehensionMixQT.itemLanguage.fkLanguageID}" class="qdiv">
						<div class="cq-holder cmpsmqtnopad clearfix">
					        <div class="left-holder">
			              		<div class="comprehension scrollbar-outer">
			              		   <p class="question-wrap">${examViewModel.comprehensionMixQT.itemText }</p>
			              		    <c:if test="${examViewModel.comprehensionMixQT.itemFilePath != null && examViewModel.comprehensionMixQT.itemFilePath != ''  && fn:length(examViewModel.comprehensionMixQT.itemFilePath) > 0}">
				               		   	<c:if test="${examViewModel.comprehensionMixQT.multimediaType == 'IMAGE'}">
				               		   		<img src="<c:url value="/exam/displayImage?disImg=${examViewModel.comprehensionMixQT.itemFilePath}"></c:url>"/>
				               		   	</c:if>
				               		   	<c:if test="${examViewModel.comprehensionMixQT.multimediaType == 'VIDEO'}">
				      	 						<div id="MMplayer_${i.index+1}" data-mediamode="exam" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${examViewModel.comprehensionMixQT.itemFilePath}&e=${examViewModel.comprehensionMixQT.fileTypeExtension}" data-mediaext="${examViewModel.comprehensionMixQT.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>
				               		   	</c:if>
				               		   	<c:if test="${examViewModel.comprehensionMixQT.multimediaType == 'AUDIO'}">
				      	 						<div id="MMplayer_${i.index+1}" class="mediaplayer" data-mediamode="exam" data-mediatype="audio" data-mediaurl="../exam/getmedia?f=${examViewModel.comprehensionMixQT.itemFilePath}&e=${examViewModel.comprehensionMixQT.fileTypeExtension}" data-mediaext="${examViewModel.comprehensionMixQT.fileTypeExtension}" data-medialoadonready="true"></div>
				               		   	</c:if>
			              		   	</c:if>
			              		</div>
				            </div>
					        <div class="right-holder">
					           	<jsp:include page="${request.contextPath}/exam/sub_QuestionContainer/${examViewModel.comprehensionMixQT.nextSubQId}/${selectedLang}"></jsp:include>
					        </div>
				        </div> 
			   		</div> 
			     </div>
			     <div class="action" style="position:fixed; width: 90%">
			     	<c:if test="${sessionScope.exampapersetting.showReset}">
			     		<button class="btn btn-lblue pull-right" name="Reset" id="Reset" type="submit"><spring:message code="Exam.Reset" /></button>
			     	</c:if>
			     	<c:if test="${sessionScope.exampapersetting.showSkip}">
			     		<button class="btn btn-lblue pull-right" name="SkipLoadNextSub" id="Skip" type="button" onclick="window.parent.skipThis()"><spring:message code="Exam.Skip" /></button>
			     	</c:if>
			     	<button class="btn btn-lblue pull-left" name="SaveLoadNextSub" id="Save" type="submit"><spring:message code="Exam.SaveNext" /></button>
			     	<c:if test="${sessionScope.exampapersetting.showMarkForReview}">
			     		<div id="markr">
			     			<span class="btn markreview-btn ">
				          		<form:checkbox path="candidateSubItemAssociation.isMarkedForReview" id="cbReview"/>
				          		
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