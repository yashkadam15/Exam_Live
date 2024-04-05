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
	<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.matchingPairsList[0].itemLanguage.item.itemID }" />
	<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
	<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
	<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
	<form:hidden path="candidateExamItemID"/>
    <form:hidden path="fkCandidateExamID" /> 
    <form:hidden path="fkCandidateID" /> 
    <form:hidden path="fkItemID" /> 
    <form:hidden path="fkParentItemID" />
	<form:hidden path="item.Itemtype" value="MP" id="itype"/>
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
          	<c:when test="${examViewModel != null && examViewModel.matchingPairsList != null && fn:length(examViewModel.matchingPairsList) > 1}">
          		<div class="pull-right">
          	
          	</c:when>
          	<c:otherwise>
          		<div class="pull-right" style="display: none">
          	</c:otherwise>
          </c:choose>          	
              <spring:message code="Exam.ViewIn" />
               <select id="viewLang"> 
              <c:forEach items="${examViewModel.matchingPairsList }" var="item" varStatus="i">
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
      
      <c:set var = "isLangItemAva"  value="0" /> 
        <c:forEach items="${examViewModel.matchingPairsList }" var="item" varStatus="i">
      		<c:if test="${selectedLang == item.itemLanguage.fkLanguageID}">
      			<c:set var = "isLangItemAva"  value="1" /> 
      		 </c:if>
      	</c:forEach>
      	
         <c:forEach items="${examViewModel.matchingPairsList }" var="item" varStatus="i">      
         	<c:choose>
         		<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">
         			<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
         			
         			
		              	 <p class="question-wrap">${item.itemText }</p>
		              	 <c:if test="${item.itemImage != null && item.itemImage != ''  && fn:length(item.itemImage) > 0}">
		              	 	<img src="../exam/displayImage?disImg=${item.itemImage}"/>
		              	 </c:if>
		              	 <br/>
		              	 <br/>		
		             
		              	 <table class="table table-bordered table-striped table-match-pairs">
			             <tbody>
		              	 <c:forEach items="${item.subItemList}" var="subItem" varStatus="j">  
		              	 <tr id="sidiv${item.itemLanguage.fkLanguageID}${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].fkItemID }">
		              	 
		              	       <td class="number" >${j.index + 1})</td>
		              	       <td class="statement" width="20px">
			              	        <form:hidden path="candidateSubItemAssociations[${j.index}].candidateExamItemID" />
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateExamID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkItemID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkParentItemID" /> 
									<form:hidden path="candidateSubItemAssociations[${j.index}].item.Itemtype" value="MP" class="itemtype"/>	
	         			                
	      			                <p class="question-wrap">${subItem.subItemText}</p>
	      			                <c:if test="${subItem.subItemImage != null && subItem.subItemImage != ''  && fn:length(subItem.subItemImage) > 0}">
	             	 				  	<img src="../exam/displayImage?disImg=${subItem.subItemImage}"/>
	             	 			    </c:if>
		              	       
		              	       </td>
		              	       <td class="answer">
		              	             <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].candidateExamItemID" id="candidateExamItemID"/>
                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkcandidateID"/>
                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkItemID" id="fkItemIdInput"/>
                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].candidateAnswerID"/>
                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkParentItemID"/>
                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkCandidateExamID"/>
                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkExamEventID"/>
		              	               
		              	             <form:select  path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID" id="optionsAns${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateExamItemID}" class="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateExamItemID}" >
   											<form:option value="0">--- <spring:message code="global.select" /> ---</form:option>
   											<c:forEach  items="${subItem.optionList}" var="subItemOption" varStatus="k">
		                    				 	 <form:option value="${subItemOption.optionLanguage.option.optionID }" id="selOpt${subItemOption.optionLanguage.option.optionID}${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateExamItemID}">
		                    				 	 	${subItemOption.subOptionText}
		                    				 	 </form:option>
                                  			
                                  			</c:forEach>
									 </form:select>									 
                               </td>
         			           <td class="option"></td>
         			          </tr>
         			          </c:forEach>
         			          </tbody>
         			          </table>
		              	               	
		              	 
              		</div> 
         		</c:when>
         		<c:when test="${isLangItemAva==0 and isLangItemAva < 2}">
         			<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
		              	<c:set var = "isLangItemAva"  value="2" />
		              	
		               <p class="question-wrap">${item.itemText }</p>
		              	 <c:if test="${item.itemImage != null && item.itemImage != ''  && fn:length(item.itemImage) > 0}">
		              	 	<img src="../exam/displayImage?disImg=${item.itemImage}"/>
		              	 </c:if>
		              	 <br/>
		              	 <br/>		
		             
		              	 <table class="table table-bordered table-striped table-match-pairs">
			             <tbody>
		              	 <c:forEach items="${item.subItemList}" var="subItem" varStatus="j">  
		              	 <tr id="sidiv${item.itemLanguage.fkLanguageID}${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].fkItemID }">
		              	 
		              	       <td class="number" >${j.index + 1})</td>
		              	       <td class="statement" width="20px">
			              	        <form:hidden path="candidateSubItemAssociations[${j.index}].candidateExamItemID"/>
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateExamID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkItemID"/> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkParentItemID" /> 
									<form:hidden path="candidateSubItemAssociations[${j.index}].item.Itemtype" value="MP" class="itemtype"/>	
	         			                
	      			                <p class="question-wrap">${subItem.subItemText}</p>
	      			                <c:if test="${subItem.subItemImage != null && subItem.subItemImage != ''  && fn:length(subItem.subItemImage) > 0}">
	             	 				  	<img src="../exam/displayImage?disImg=${subItem.subItemImage}"/>
	             	 			    </c:if>
		              	       
		              	       </td>
		              	       <td class="answer">
		              	             <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].candidateExamItemID" id="candidateExamItemID"/>
                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkcandidateID"/>
                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkItemID" id="fkItemIdInput"/>
                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].candidateAnswerID"/>
                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkParentItemID"/>
                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkCandidateExamID"/>
                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkExamEventID"/>
		              	               
		              	             <form:select  path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID" id="optionsAns${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateExamItemID}" class="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateExamItemID}" >
   											<form:option value="0" label="--- Select ---" />
   											<c:forEach  items="${subItem.optionList}" var="subItemOption" varStatus="k">
		                    				 	 <form:option value="${subItemOption.optionLanguage.option.optionID }" id="selOpt${subItemOption.optionLanguage.option.optionID}${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateExamItemID}" label="${subItemOption.subOptionText}" />
                                  			</c:forEach>
									 </form:select>
                               </td>
         			           <td class="option"></td>
         			          </tr>
         			          </c:forEach>
         			          </tbody>
         			          </table>
         			          
              		</div>
         		</c:when>         		
         	</c:choose>
         </c:forEach>
     </div> 
     <div class="action" style="position:fixed; width: 90%">
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
</div>
</body>
</html>                       