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
	<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.comprehensions[0].itemLanguage.item.itemID }" />
	<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
	<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
	<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
	<form:hidden path="candidateExamItemID"/>
    <form:hidden path="fkCandidateExamID" /> 
    <form:hidden path="fkCandidateID" /> 
    <form:hidden path="fkItemID" /> 
    <form:hidden path="fkParentItemID" /> 
	<form:hidden path="item.Itemtype" value="CMPS" id="itype"/>
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
          	<c:when test="${examViewModel != null && examViewModel.comprehensions != null && fn:length(examViewModel.comprehensions) > 1}">
          		<div class="pull-right">
          	
          	</c:when>
          	<c:otherwise>
          		<div class="pull-right" style="display: none">
          	</c:otherwise>
          </c:choose>
              <spring:message code="Exam.ViewIn" />
               <select id="viewLang"> 
              <c:forEach items="${examViewModel.comprehensions }" var="item" varStatus="i">
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
       						 
      <div class="questiondiv"><!-- removed class 'scrollbar-outer' -->
       	<div class="palette1">                           	
            <div class="quick-ques1" style="padding: 4px">
	           	<c:forEach items="${examViewModel.candidateItemAssociation.candidateSubItemAssociations}" var="cia" varStatus="indx">
	           		<c:if test="${cia.itemStatus == 'NoStatus'}">
	           			<a title="<spring:message code="Exam.NotVisited" />" data-status="nostatus" class="btn btn-mini" id="silnk${cia.fkItemID}" data-item="${cia.fkItemID}">${indx.index+1}</a>
	           		</c:if>
	           		<c:if test="${cia.itemStatus == 'NotAnswered' or cia.itemStatus == 'Skipped'}">
	           			<a title="<spring:message code="Exam.NotAnswered" />"  data-status="noans" class="btn btn-mini btn-red" id="silnk${cia.fkItemID}" data-item="${cia.fkItemID}">${indx.index+1}</a>
	           		</c:if>
	           		<c:if test="${cia.itemStatus == 'MarkedForReview'}">
	           			<a title="<spring:message code="Exam.Marked" />" data-status="marked" class="btn btn-mini btn-purple" id="silnk${cia.fkItemID}" data-item="${cia.fkItemID}">${indx.index+1}</a>
	           		</c:if>
	           		<c:if test="${cia.itemStatus == 'Answered'}">
	           			<a title="<spring:message code="Exam.Answered" />"  data-status="ans" class="btn btn-mini btn-greener" id="silnk${cia.fkItemID}" data-item="${cia.fkItemID}">${indx.index+1}</a>
	           		</c:if>
	           	</c:forEach>
           </div>
		</div>
		
		<c:set var = "isLangItemAva"  value="0" /> 
        <c:forEach items="${examViewModel.comprehensions }" var="item" varStatus="i">  
      		<c:if test="${selectedLang == item.itemLanguage.fkLanguageID}">
      			<c:set var = "isLangItemAva"  value="1" /> 
      		 </c:if>
      	</c:forEach>
		
         <c:forEach items="${examViewModel.comprehensions }" var="item" varStatus="i">      
         	<c:choose>
         		<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">
         			<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
         			
         			    <div class="cq-holder clearfix">
         			        <div class="left-holder">
                          		<div class="comprehension scrollbar-outer">
                          		   <p class="question-wrap">${item.itemText }</p>
                          		     <c:if test="${item.itemFilePath != null && item.itemFilePath != ''  && fn:length(item.itemFilePath) > 0}">
		              	 				<img src="../exam/displayImage?disImg=${item.itemFilePath}"/>
		              	 			 </c:if>
                          		</div>
                        	</div>
         			        <div class="right-holder">
         			           	<div class="cmpsqdiv comprehension-Questions scrollbar-outer">
         			            <c:forEach items="${item.subItemList}" var="subItem" varStatus="j">  
         			                <form:hidden path="candidateSubItemAssociations[${j.index}].candidateExamItemID"/>
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateExamID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkItemID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkParentItemID" /> 
									<form:hidden path="candidateSubItemAssociations[${j.index}].item.Itemtype" value="CMPS" class="itemtype"/>	
         			                <div class="control-holder" id="sidiv${item.itemLanguage.fkLanguageID}${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].fkItemID }">
         			                   <strong><spring:message code="Exam.Question" /> ${j.index+1} : </strong>
         			                    <p class="question-wrap">${subItem.subItemText}</p>
         			                    <c:if test="${subItem.subItemImage != null && subItem.subItemImage != ''  && fn:length(subItem.subItemImage) > 0}">
		              	 				  <img src="../exam/displayImage?disImg=${subItem.subItemImage}"/>
		              	 			    </c:if>
		              	 			    <br>
                                        <%-- <strong><spring:message code="Exam.Options" /> : </strong>
                                        <br> --%>
                                        <c:forEach  items="${subItem.optionList}" var="subItemOption" varStatus="k">
                                          <div class="controls">
                                             <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].candidateExamItemID" id="candidateExamItemID"/>
		                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkcandidateID"/>
		                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkItemID" id="fkItemIdInput"/>
		                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].candidateAnswerID"/>
		                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkParentItemID"/>
		                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkCandidateExamID"/>
		                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkExamEventID"/>
		                    				  
		                    				  <label class="checkbox radio">
		                    				  
		                    				          <c:choose>
				                    				       <c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].object > 1 }">
				                    				          <form:checkbox  path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].optionID" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo}${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }"  />
				                    				       </c:when>
				                    				       <c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].object == 1 }">
				                    				           <c:choose>
				                    								<c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateAnswers[k.index] != null && examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateAnswers[k.index].optionID > 0 }">
			                    									    <form:radiobutton path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID"  checked="checked" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }" data-subidCMPS="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkItemID" data-test="checked"  data-actual="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkItemID"/>
										                    	    </c:when>
										                    	    <c:otherwise>
										                    		    <form:radiobutton path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }" data-subidCMPS="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkItemID" data-test="unchecked" data-actual="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkItemID"/>
										                    	    </c:otherwise>
					                   						</c:choose>	
				                    				       </c:when>
		                    				         </c:choose> 
		                    				     
							                   		<c:if test="${subItemOption.subOptionText != null && subItemOption.subOptionText != ''  && fn:length(subItemOption.subOptionText) > 0}">
							                   		<div class="question-wrap">${subItemOption.subOptionText }</div>		                   		
							                   		</c:if>	
							                   		 <c:if test="${subItemOption.subOptionImage != null && subItemOption.subOptionImage != ''  && fn:length(subItemOption.subOptionImage) > 0}">
							                   		  	<c:if test="${subItemOption.subOptionText != null && subItemOption.subOptionText != ''  && fn:length(subItemOption.subOptionText) > 0}">
							                   		  	  <br>
							                   		  	</c:if>
							              	 			<img src="../exam/displayImage?disImg=${subItemOption.subOptionImage}"/>
							              	 		</c:if>	     
							              	 		              		
							                  </label>
                                          </div>
                                        </c:forEach>
         			                </div>
         			                <br>
         			            </c:forEach>
         			           </div>
         			        </div>
		              	  </div> 
              		</div> 
         		</c:when>
         		<c:when test="${isLangItemAva==0 and isLangItemAva < 2}">
         			<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
         			<c:set var = "isLangItemAva"  value="2" />
         			
	         			 <div class="cq-holder clearfix">
	         			        <div class="left-holder">
	                          		<div class="comprehension scrollbar-outer">
	                          		   <p class="question-wrap">${item.itemText }</p>
	                          		     <c:if test="${item.itemFilePath != null && item.itemFilePath != ''  && fn:length(item.itemFilePath) > 0}">
			              	 				<img src="../exam/displayImage?disImg=${item.itemFilePath}"/>
			              	 			 </c:if>
	                          		</div>
	                        	</div>
	         			        <div class="right-holder"> 
	         			           	<div class="cmpsqdiv comprehension-Questions scrollbar-outer" >
	         			           	
		         			            <c:forEach items="${item.subItemList}" var="subItem" varStatus="j">  	
	         			                <form:hidden path="candidateSubItemAssociations[${j.index}].candidateExamItemID"/>
									    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateExamID" /> 
									    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateID" /> 
									    <form:hidden path="candidateSubItemAssociations[${j.index}].fkItemID" /> 
									    <form:hidden path="candidateSubItemAssociations[${j.index}].fkParentItemID" /> 
										<form:hidden path="candidateSubItemAssociations[${j.index}].item.Itemtype" value="CMPS" class="itemtype"/>	
	         			                
	         			                <div class="control-holder" id="sidiv${item.itemLanguage.fkLanguageID}${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].fkItemID }">
	         			                   <strong><spring:message code="Exam.Question" /> ${j.index+1} : </strong>
	         			                    <p class="question-wrap">${subItem.subItemText}</p>
	         			                    <c:if test="${subItem.subItemImage != null && subItem.subItemImage != ''  && fn:length(subItem.subItemImage) > 0}">
			              	 				  <img src="../exam/displayImage?disImg=${subItem.subItemImage}"/>
			              	 			    </c:if>
			              	 			    <br>
	                                        <%-- <strong><spring:message code="Exam.Options" /> : </strong>
	                                        <br> --%>
	                                        <c:forEach  items="${subItem.optionList}" var="subItemOption" varStatus="k">
	                                          <div class="controls">
	                                             <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].candidateExamItemID"/>
			                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkcandidateID"/>
			                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkItemID"/>
			                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].candidateAnswerID"/>
			                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkParentItemID"/>
			                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkCandidateExamID"/>
			                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkExamEventID"/>
			                    				 
			                    				 
			                    				  <label  class="checkbox radio">
			                    				        
			                    				       <c:choose>
				                    				       <c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].object > 1 }">
				                    				          <form:checkbox  path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].optionID" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo}${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }" />
				                    				       </c:when>
				                    				       <c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].object == 1 }">
				                    				           <c:choose>
				                    								<c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateAnswers[k.index] != null && examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateAnswers[k.index].optionID > 0 }">
			                    									    <form:radiobutton path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID"  checked="checked" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }"/>
										                    	    </c:when>
										                    	    <c:otherwise>
										                    		    <form:radiobutton path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }"/>
										                    	    </c:otherwise>
					                   						</c:choose>	
				                    				       </c:when>
		                    				          </c:choose> 
			                    				      
			                    				     
								                   		<c:if test="${subItemOption.subOptionText != null && subItemOption.subOptionText != ''  && fn:length(subItemOption.subOptionText) > 0}">
								                   		<div class="question-wrap">${subItemOption.subOptionText }</div>		                   		
								                   		</c:if>	
								                   		 <c:if test="${subItemOption.subOptionImage != null && subItemOption.subOptionImage != ''  && fn:length(subItemOption.subOptionImage) > 0}">
								                   		  	<c:if test="${subItemOption.subOptionText != null && subItemOption.subOptionText != ''  && fn:length(subItemOption.subOptionText) > 0}">
								                   		  	  <br>
								                   		  	</c:if>
								              	 			<img src="../exam/displayImage?disImg=${subItemOption.subOptionImage}"/>
								              	 		</c:if>	     
								              	 		              		
								                  </label>
	                                          </div>
	                                        </c:forEach>
	         			                </div>
	         			                <br>
	         			            </c:forEach>
	         			            
	         			           </div>
	         			        </div>
			              	  </div> 
			              	  
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
     		<button class="btn btn-lblue pull-right" name="Skip" id="Skip" type="button" onclick="window.parent.skipThis();"><spring:message code="Exam.Skip" /></button>
     	</c:if>
     	<button class="btn btn-lblue pull-left" name="Save" id="Save" type="submit"><spring:message code="Exam.SaveNext" /></button>
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