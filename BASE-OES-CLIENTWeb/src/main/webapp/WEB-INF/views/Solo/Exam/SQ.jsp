<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="utf-8" />
<title>Assessment</title>
<spring:theme code="curdetailtheme" var="curdetailtheme"/>

<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/plugins/font-awesome/css/font-awesome.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/sequencing.css'></c:url>" type="text/css"/>

<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.scrollbar.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/Legends.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/QuestionRender.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/sq.js?${jsTime }'></c:url>"></script>
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

        <!-- BEGIN PAGE CONTAINER-->
        <div class="main container-fluid bg1" style=" background-image: none;">
<input type="hidden" id="dbanscnt" name="dbanscnt" value="${examViewModel.openObject}"/>
            <!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
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
	<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.matchTheColumnList[0].itemLanguage.item.itemID }" />
	<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
	<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
	<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
	<form:hidden path="candidateExamItemID"/>	
	<form:hidden path="item.Itemtype" value="SQ" id="itype"/>
	<form:hidden path="fkItemID"/>
	<form:hidden path="candidateExam.candidatePaperLanguage" value="${selectedLang}" />
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
          	<c:when test="${examViewModel != null && examViewModel.matchTheColumnList != null && fn:length(examViewModel.matchTheColumnList) > 1}">
          		<div class="pull-right">
          	
          	</c:when>
          	<c:otherwise>
          		<div class="pull-right" style="display: none">
          	</c:otherwise>
          </c:choose>          	
              <spring:message code="Exam.ViewIn" />
               <select id="viewLang"> 
              <c:forEach items="${examViewModel.matchTheColumnList }" var="item" varStatus="i">
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
          </div>
            	</div>
            
            
            <div class="questiondiv scrollbar-outer">
            		<c:forEach items="${examViewModel.matchTheColumnList}" var="item" varStatus="i">
                       	<c:choose>
							<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">
								<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
								<%-- <p class="question-wrap"><spring:message code="sq.maintext"></spring:message></p> --%>
								
                                <p class="question-wrap">${item.itemText }</p>
                                    <c:if test="${item.itemImage != null && item.itemImage != ''  && fn:length(item.itemImage) > 0}">
										<img class="que-image w-100" src="../exam/displayImage?disImg=${item.itemImage}" />
									</c:if>
									
									 <div id="ans" class="ansCircle">
					                                                   <input type="hidden" id="noOfColumn" value="${item.noOfColumns}"/>
					                                                    <c:forEach begin="0" end="${item.noOfColumns-1}" var="i">
					                                                    	<div id="div${i}" ondrop="drop(event)" ondragover="allowDrop(event)" class="border"></div>
					                                                    </c:forEach>
					                                                    
					                                                  <br/>  
					                                                  <%--   <button type="button" class="btn btn-lblue m-l-20" id="btnReset" name="btnReset" onclick="resetOptions()"><img
						src="<c:url value="../resources/images/reset-icon.png" ></c:url>"
						alt="reset" style="width:18px;"> Reset</button> --%>
					                                                    <!-- <button type="button" class="btn reset btn-primary btn-cons m-l-10" onclick="resetOptions()" id="btnReset">Reset</button> -->
					                                                </div>
                                    <br>
                                                <!--end -->
                                    <input type="hidden" id="celldata" name="item.cellData" value='${item.cellData}'/>
                                    <input type="hidden" id="sequencingType" name="item.sequencingType" value='${item.sequencingType}'/>
                                                
	                                <form:hidden path="candidateAnswers[0].typedText" id="answerdata" name="answerdata"/>
	                                <form:hidden path="candidateAnswers[0].candidateExamItemID" />
									<form:hidden path="candidateAnswers[0].fkcandidateID" />
									<form:hidden path="candidateAnswers[0].fkItemID" />
									<form:hidden path="candidateAnswers[0].candidateAnswerID" />
									<form:hidden path="candidateAnswers[0].fkCandidateExamID" />
									<form:hidden path="candidateAnswers[0].fkExamEventID" />
												
                                    <div id="matrixDiv" name="matrixDiv">
                                    </div>
                                </div>
                             </c:when>
						</c:choose>
					</c:forEach>
            	</div>
            
            
            
 
            	<div class="action" style="position:fixed;background-color: #ffffff; width: 90%">  
			     	<c:if test="${sessionScope.exampapersetting.showReset}">
			     		<button class="btn btn-lblue pull-right" name="Reset" id="Reset" type="submit"><spring:message code="Exam.Reset" /></button>
			     	</c:if>
			     	<c:if test="${sessionScope.exampapersetting.showSkip}">
			     		<button class="btn btn-lblue pull-right" name="Skip" id="Skip" type="button" onclick="window.parent.skipThis()"><spring:message code="Exam.Skip" /></button>
			     	</c:if>
			     	<button class="btn btn-lblue pull-left" name="Save" id="Save" type="submit" onclick="resetStopwatch()"><spring:message code="Exam.SaveNext" /></button>
			     	<c:if test="${sessionScope.exampapersetting.showMarkForReview}">
			     		<div id="markr">
			     			<span class="btn markreview-btn ">
				          		<form:checkbox path="isMarkedForReview" id="cbReview"/>
				          		
				          		<label for="cbReview"><spring:message code="Exam.MarkforReview" /></label>
			       			</span>
			       		</div>
			     	</c:if>
			     </div>
			     
            </form:form>
         
        </div>
</body>

</html>
