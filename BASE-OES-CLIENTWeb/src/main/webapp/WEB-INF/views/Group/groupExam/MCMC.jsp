<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html lang="en">
<head>

<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="Exam.Title" /></title>
<spring:theme code="curdetailtheme" var="curdetailtheme"/>
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
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
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/Legends.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/QuestionRender.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
</head>
<body class="osp-user-one" style="background-color: transparent">

<form:form action="ProcessQuestion" method="POST" id="frmQues" modelAttribute="candidateItemAssociation">

	<!-- Hidden Start -->
	<input type="hidden" id="hidExt" name="hidExt" value="-1"/>
	<c:choose>
		<c:when test="${mode != null}">
			<input type="hidden" id="mode" name="mode" value="${mode }"/>
		</c:when>
		<c:otherwise>
			<input type="hidden" id="mode" name="mode" value="off"/>
		</c:otherwise>
	</c:choose>	
	<input type="hidden" id="examineeCandidateID" name="examineeCandidateID" value="${examineeCandidateID}"/>
	<input type="hidden" id="attempterCandidateID" name="attempterCandidateID" value="${attempterCandidateID}"/>
	<input type="hidden" id="candidateExamID" name="candidateExamID" value="${candidateExamID}"/>
	<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}"/>
	<input type="hidden" id="examEventID" name="examEventID" value="${examEventID }" />
	<input type="hidden" id="paperID" name="paperID" value="${paperID }" />
	<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.multipleChoiceMultipleCorrects[0].itemLanguage.item.itemID }" />
	<input type="hidden" id="examineeSelOpIDs" name="examineeSelOpIDs" value="${examineeSelOpIDs}"/>
	<input type="hidden" id="examineeSelConfLevel" name="examineeSelConfLevel" value="${examineeSelConfLevel}"/>
	<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}"/>
	<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
	<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
	<form:hidden path="candidateExamItemID"/>
	<form:hidden path="fkCandidateExamID" value="${candidateExamID}" />
	<form:hidden path="item.Itemtype" value="MCMC"/>
	<form:hidden path="fkItemID"/>
	<input type="hidden" id="sectionID" name="sectionID" value="${activeSec}" />
	<!-- Hidden End -->


<!-- Q Container -->
<div class="osp-question" >
    <!-- Q Box -->
    <div class="osp-question-holder">
     <!-- Language Select Box -->
          <c:choose>
          	<c:when test="${examViewModel != null && examViewModel.multipleChoiceSingleCorrects != null && fn:length(examViewModel.multipleChoiceSingleCorrects) > 1}">
          		<div class="lang-div">
          	
          	</c:when>
          	<c:otherwise>
          		<div class="lang-div" style="display: none">
          	</c:otherwise>
          </c:choose>
              <spring:message code="Exam.ViewIn" />
               <select id="viewLang" name="viewLang"> 
              <c:forEach items="${examViewModel.multipleChoiceMultipleCorrects }" var="item" varStatus="i">
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
    
    <c:forEach items="${examViewModel.multipleChoiceMultipleCorrects }" var="item" varStatus="i">   
    <c:choose>
    <c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">	
    
           <table class="table qdiv" id="${item.itemLanguage.fkLanguageID}">
            <thead>
                <tr>
                    <th class="ques">
                         <p><spring:message code="Exam.gpQuestion" /></p>
                         ${item.itemText }
		              	 <c:if test="${item.itemImage != null && item.itemImage != ''  && fn:length(item.itemImage) > 0}">
		              	 	<c:if test="${item.itemText != null && item.itemText != ''  && fn:length(item.itemText) > 0}">
		              	 	<br/>	
		              	 	</c:if>
		              	 	<img src="../groupExam/displayImage?disImg=${item.itemImage}"/>
		              	 </c:if>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="answer">
                    <p><spring:message code="Exam.Options" /></p>
                     <div class="controls" >
                       	 <c:forEach items="${item.optionList}" var="option" varStatus="j">              	
		                   
		                    <form:hidden path="candidateAnswers[${j.index }].candidateExamItemID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].fkcandidateID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].fkItemID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].candidateAnswerID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].fkExamEventID"/>
		                    <label class="checkbox">
		                    <form:checkbox path="candidateAnswers[${j.index }].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>		                    
		                   		<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
		                   		${option.optionText }		                   		                   		
		                   		</c:if>	
		                   		 <c:if test="${option.optionImage != null && option.optionImage != ''  && fn:length(option.optionImage) > 0}">
		                   		 	<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
		                   		 	<br/>
		                   		 	</c:if>
		              	 			<img src="../groupExam/displayImage?disImg=${option.optionImage}"/>
		              	 		</c:if>
		                    </label>
		              	 </c:forEach>
		              	  </div>
                    </td>
                </tr>
            </tbody>
         </table>
         
         </c:when>
         <c:otherwise>
         
           <table class="table qdiv" id="${item.itemLanguage.fkLanguageID}">
            <thead>
                <tr>
                    <th class="ques">
                         <p><spring:message code="Exam.gpQuestion" /></p>
                         ${item.itemText }
		              	  <c:if test="${item.itemImage != null && item.itemImage != ''  && fn:length(item.itemImage) > 0}">
		              	  	<c:if test="${item.itemText != null && item.itemText != ''  && fn:length(item.itemText) > 0}">
		              	 	<br/>	
		              	 	</c:if>
		              	 	<img src="../groupExam/displayImage?disImg=${item.itemImage}"/>
		              	 </c:if>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="answer">
                    <p><spring:message code="Exam.Options" /></p>
                       	  <c:forEach items="${item.optionList}" var="option" varStatus="j">              	
		                    <div class="controls">
		                    <form:hidden path="candidateAnswers[${j.index }].candidateExamItemID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].fkcandidateID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].fkItemID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].candidateAnswerID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID"/>
		                    <form:hidden path="candidateAnswers[${j.index }].fkExamEventID"/>
		                    <label class="checkbox">
		                    <form:checkbox path="candidateAnswers[${j.index }].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>		                    
		                   		<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
		                   		${option.optionText }		                   		
		                   		</c:if>	
		                   		<c:if test="${option.optionImage != null && option.optionImage != ''  && fn:length(option.optionImage) > 0}">
		                   			<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
		                   		 	<br/>
		                   		 	</c:if>
		              	 			<img src="../groupExam/displayImage?disImg=${option.optionImage}"/>
		              	 		</c:if>
		                    </label>
		                    </div>
		              	 </c:forEach>
                    </td>
                </tr>
            </tbody>
         </table>
         
         </c:otherwise>
         </c:choose>
         </c:forEach>
    </div>
</div>

<!-- Confidence Level -->
<div class="osp-confidence">
<!-- check confidenece level required or not -->
<c:choose>
<c:when test="${sessionScope.exampapersetting.isConfidenceLevelCheck==true}">
	<input type="hidden" value="1" id="isConfidenceLevelsetting"/>
    <div class="levels cols">
    <c:forEach var="cflevel" items="${confidenceLevels}">
    <c:if test="${cflevel != 'None' && cflevel != 'FiveStars'}">
      <label class="conf ${cflevel} col1-3 radio">
           <form:radiobutton path="confidenceLevel"  value="${cflevel}"  />		                    
            <div class="conf-image"><img src="<c:url value="../resources/images/${cflevel}.png"></c:url>" alt="${cflevel} Confidence"></div>
            <p><c:choose>
            	<c:when test="${cflevel == 'Full' }">
                    <spring:message code="Exam.fullconf" />
           		 </c:when>
            	 <c:when test="${cflevel == 'Partial' }">
                    <spring:message code="Exam.partialconf" />
                 </c:when>
                 <c:when test="${cflevel == 'Low' }">
                    <spring:message code="Exam.lowconf" />
                 </c:when>
                 <c:otherwise>
            		${cflevel}
            	</c:otherwise>
            </c:choose></p>
        </label>
     </c:if>   
    </c:forEach>    
    </div>
</c:when> 
<c:otherwise>
	<input type="hidden" value="0" id="isConfidenceLevelsetting"/>
    <c:forEach var="cflevel" items="${confidenceLevels}">
     <c:if test="${cflevel == 'None' }">
     	   <label style="display: none"><form:radiobutton path="confidenceLevel" value="${cflevel}" checked="checked" /></label>
           <input type="hidden" value="${cflevel}" id="noneConfidenceLevel">
     </c:if>
    </c:forEach>
</c:otherwise>
</c:choose>
</div>

<!-- Submit -->
<div class="pg-controls" >
     <span class="align"></span> <button class="btn btn-success" name="Save" id="Save" type="submit"><spring:message code="Exam.submitAnswerbtn" /></button>
</div>


</form:form>


</body>
</html>                       