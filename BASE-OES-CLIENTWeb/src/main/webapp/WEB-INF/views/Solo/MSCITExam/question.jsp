<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="MSCITExam.Title" /></title>
<link rel="stylesheet" href="<c:url value='/resources/style/bootstrap_mscit.min.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/style_mscit.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css" />
</head>
<body class="exampage-iframe" style="background-color:#ebebeb;">
    <script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
    <script src="<c:url value='/resources/js/jquery.scrollbar.min.js'></c:url>"></script>
    <script src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>
    <script src="<c:url value='/resources/js/mscitQuestionRender.js?${jsTime }'></c:url>"></script>
    <script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>

    <div class="main">
    <section id="content-iframe" class="container-fluid">
          <div class="section lightBlue-wrapper">
           <div class="cotainer-fluid">
                <div class="row">
                    <div class="lightBlueHeader subheader2 clearfix">
                        <div class="col-md-12">
                            <div class="btn-group1">
                                <h5 class=""><spring:message code="question.level" /> <span id="lvlNmbrQtype" class="lvlNmbrQtype"></span>  <spring:message code="question.questions" /></h5>
                                 <c:set var="AnsweredQuesCnt" value="0"></c:set>
                                <c:if test="${examViewModelList != null && fn:length(examViewModelList)>0 }">
                                <c:forEach items="${examViewModelList}" var="examViewModel" varStatus="i" >                                
                                <c:choose>
                                <c:when test="${examViewModelList[i.index].candidateItemAssociation.itemStatus=='Answered'}">
                                <c:set var="AnsweredQuesCnt" value="${AnsweredQuesCnt+1}"></c:set>                                
                                <a class="btn btn-default btn-xs answered">Q${i.index+1 }</a>
                                </c:when>
                                <c:otherwise>
                                <a class="btn btn-default btn-xs">Q${i.index+1 }</a>
                                </c:otherwise>
                                </c:choose>                                
                                </c:forEach>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
          </div>
         
    <%-- <form:form class="form-horizontal" action="ProcessQuestion" method="POST" id="hidFrmQues" >
    <input type="hidden" id="hidExt" name="hidExt" value="-1"/>
    <input type="hidden" id="qtype" name="qtype" value=""/>
    <input type="hidden" id="level" name="level" value=""/>
    <input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
    <button class="btn btn-lblue pull-left" name="Next" id="Next" type="submit"><spring:message code="Exam.Next" /></button>  	
    </form:form>   --%>      
            <div class="row">
                <div class="col-md-12">                
                <c:choose>
                <c:when test="${examViewModelList != null && fn:length(examViewModelList)>0 && AnsweredQuesCnt!=fn:length(examViewModelList)}">
                
                <c:forEach items="${examViewModelList}" var="examViewModel" varStatus="i"  >               
                <!-- MULTIPLECHOICESINGLECORRECT ITEM BLOCK-->
                <c:if test="${examViewModel.multipleChoiceSingleCorrect != null  && examViewModel.candidateItemAssociation.itemStatus=='NotAnswered'}" >
                		<form:form class="form-horizontal" action="ProcessQuestion" method="POST" id="frmQues${examViewModel.candidateItemAssociation.fkItemID}" modelAttribute="candidateItemAssociation">
               	<!-- start hid block -->				      	
					<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}"/>				
					<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
					<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
					<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>	
					<form:hidden path="candidateExamItemID" value="${examViewModel.candidateItemAssociation.candidateExamItemID }"/>
					<form:hidden path="item.Itemtype" value="MCSC" id="itype"/>
					<form:hidden path="fkItemID" value="${examViewModel.candidateItemAssociation.fkItemID}"/>					
				<!-- End hid block -->				
				<!-- Question Text Block -->
               		 <div class="form-group">
                            <div class="col-sm-2 control-label"><spring:message code="MSCITExam.Question" /> ${i.index +1} :</div>
                            <div class="col-sm-10" style="padding-bottom: 5px;">
                                <p class="form-control-static ">${examViewModel.multipleChoiceSingleCorrect.itemText }</p>
                                 <c:if test="${examViewModel.multipleChoiceSingleCorrect.itemImage != null && examViewModel.multipleChoiceSingleCorrect.itemImage != ''  && fn:length(examViewModel.multipleChoiceSingleCorrect.itemImage) > 0}">
		              	 	<img src="../exam/displayImage?disImg=${examViewModel.multipleChoiceSingleCorrect.itemImage}"/>
		              	 </c:if>                                
                            </div>
                        </div>
                        <!-- Option Block -->
                         <div class="form-group">
                            <div class="col-sm-2 control-label"><spring:message code="MSCITExam.Answer" /></div>
                            <div class="col-sm-10">
                            <c:forEach items="${examViewModel.multipleChoiceSingleCorrect.optionList}" var="option" varStatus="j"> 
                           		<form:hidden path="candidateAnswers[${j.index }].candidateExamItemID" value="${examViewModel.candidateItemAssociation.candidateExamItemID}"/>
			                    <form:hidden path="candidateAnswers[${j.index }].fkcandidateID" value="${examViewModel.candidateItemAssociation.fkCandidateID}"/>
			                    <form:hidden path="candidateAnswers[${j.index }].fkItemID" value="${examViewModel.candidateItemAssociation.fkItemID}"/>
			                    <form:hidden path="candidateAnswers[${j.index }].candidateAnswerID"/>
			                    <form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID" value="${examViewModel.candidateItemAssociation.fkCandidateExamID}"/>
			                    <form:hidden path="candidateAnswers[${j.index }].fkExamEventID" value="${sessionScope.examEvent.examEventID}"/>
	                           		<div class="radio">
	                                    <label>
	                                       <form:radiobutton path="candidateAnswers[0].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
	                                    ${option.optionText }
	                                    </label>
	                                     <c:if test="${option.optionImage != null && option.optionImage != ''  && fn:length(option.optionImage) > 0}">
		                   		 	<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
		                   		 	<br/>
		                   		 	</c:if>
		              	 			<img src="../exam/displayImage?disImg=${option.optionImage}" />
		              	 			
		              	 		</c:if>
	                                </div>
                            </c:forEach>          
                            <input type="hidden" id="hidExt" name="hidExt" value="-1"/>
						    <input type="hidden" id="qtype" name="qtype" value=""/>
						    <input type="hidden" id="level" name="level" value=""/>
						    <input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />                     
                            </div>
                        </div>
                        <!-- Submit Answer Block -->
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <button type="submit" class="btn btn-submit" id="Save${examViewModel.candidateItemAssociation.fkItemID}" name="Save"><spring:message code="MSCITExam.SubmitAnswer" /></button>
                            </div>
                        </div>                        
                </form:form>
                </c:if>             
          		
          		<!-- MULTIPLECHOICEMULTIPLECORRECT ITEM BLOCK-->
                <c:if test="${examViewModel.multipleChoiceMultipleCorrect != null && examViewModel.candidateItemAssociation.itemStatus=='NotAnswered' }">
                <form:form class="form-horizontal" action="ProcessQuestion" method="POST" id="frmQues${examViewModel.candidateItemAssociation.fkItemID}" modelAttribute="candidateItemAssociation">
                <!-- start hid block -->				    						
					<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}"/>					
					<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
					<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
					<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>	
					<form:hidden path="candidateExamItemID" value="${examViewModel.candidateItemAssociation.candidateExamItemID }"/>
					<form:hidden path="item.Itemtype" value="MCMC" id="itype"/>
					<form:hidden path="fkItemID" value="${examViewModel.candidateItemAssociation.fkItemID}"/>					
				<!-- End hid block -->				
				<!-- Question Text Block -->
                		 <div class="form-group">
                            <div class="col-sm-2 control-label"><spring:message code="MSCITExam.Question" /> ${i.index +1 } :</div>
                            <div class="col-sm-10" style="padding-bottom: 5px;">
                                <p class="form-control-static ">${examViewModel.multipleChoiceMultipleCorrect.itemText }</p>
                                 <c:if test="${examViewModel.multipleChoiceMultipleCorrect.itemImage != null && examViewModel.multipleChoiceMultipleCorrect.itemImage != ''  && fn:length(examViewModel.multipleChoiceMultipleCorrect.itemImage) > 0}">
		              	 	<img src="../exam/displayImage?disImg=${examViewModel.multipleChoiceMultipleCorrect.itemImage}"/>
		              	 </c:if>                                
                            </div>
                        </div>
                <!-- Option Block -->
                         <div class="form-group">
                            <div class="col-sm-2 control-label"><spring:message code="MSCITExam.Answer" /></div>
                            <div class="col-sm-10">
                            <c:forEach items="${examViewModel.multipleChoiceMultipleCorrect.optionList}" var="option" varStatus="j"> 
                           		<form:hidden path="candidateAnswers[${j.index }].candidateExamItemID" value="${examViewModel.candidateItemAssociation.candidateExamItemID}"/>
			                    <form:hidden path="candidateAnswers[${j.index }].fkcandidateID" value="${examViewModel.candidateItemAssociation.fkCandidateID}"/>
			                    <form:hidden path="candidateAnswers[${j.index }].fkItemID" value="${examViewModel.candidateItemAssociation.fkItemID}"/>
			                    <form:hidden path="candidateAnswers[${j.index }].candidateAnswerID"/>
			                    <form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID" value="${examViewModel.candidateItemAssociation.fkCandidateExamID}"/>
			                    <form:hidden path="candidateAnswers[${j.index }].fkExamEventID" value="${sessionScope.user.examEvent.examEventID}"/>
	                           		<div class="checkbox">
                                    <label>
                                       <form:checkbox path="candidateAnswers[${j.index }].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
                                     	${option.optionText }
                                      </label>
                                       <c:if test="${option.optionImage != null && option.optionImage != ''  && fn:length(option.optionImage) > 0}">
		                   		 	<c:if test="${option.optionText != null && option.optionText != ''  && fn:length(option.optionText) > 0}">
		                   		 	<br/>
		                   		 	</c:if>
		              	 			<img src="../exam/displayImage?disImg=${option.optionImage}"/>
		              	 			
		              	 		</c:if>
                                </div>	                           		
                            </c:forEach>   
                            <input type="hidden" id="hidExt" name="hidExt" value="-1"/>
						    <input type="hidden" id="qtype" name="qtype" value=""/>
						    <input type="hidden" id="level" name="level" value=""/>
						    <input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />                            
                            </div>
                        </div>                        
                       <!-- Submit Answer Block -->
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <button type="submit" class="btn btn-submit" id="Save${examViewModel.candidateItemAssociation.fkItemID}" name="Save"><spring:message code="MSCITExam.SubmitAnswer" /></button>
                            </div>
                        </div>
                </form:form>
                </c:if>   
                
                <!-- practical item block-->
                <c:if test="${examViewModel.practical != null && examViewModel.candidateItemAssociation.itemStatus=='NotAnswered' }">
                <form:form class="form-horizontal" action="ProcessQuestion" method="POST" id="frmQues${examViewModel.candidateItemAssociation.fkItemID}" modelAttribute="candidateItemAssociation">
                <!-- start hid block -->				    						
					<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}"/>					
					<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
					<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
					<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>	
					<form:hidden path="item.Itemtype" value="PRT" id="itype"/>
					<form:hidden path="candidateAnswers[0].candidateExamItemID" value="${examViewModel.candidateItemAssociation.candidateExamItemID}"/>
                    <form:hidden path="candidateAnswers[0].fkcandidateID" value="${examViewModel.candidateItemAssociation.fkCandidateID}"/>
                    <form:hidden path="candidateAnswers[0].fkItemID" value="${examViewModel.candidateItemAssociation.fkItemID}"/>
                    <form:hidden path="candidateAnswers[0].candidateAnswerID"/>
                    <form:hidden path="candidateAnswers[0].fkCandidateExamID" value="${examViewModel.candidateItemAssociation.fkCandidateExamID}"/>
                    <form:hidden path="candidateAnswers[0].fkExamEventID" value="${sessionScope.user.examEvent.examEventID}"/>		
					<form:hidden path="candidateAnswers[0].isCorrect" id="prtAnswer"/>
    				<form:hidden path="candidateAnswers[0].typedText" id="prtAnswerTxt"/>	
    				<input type="hidden" id="hidExt" name="hidExt" value="-1"/>
				    <input type="hidden" id="qtype" name="qtype" value=""/>
				    <input type="hidden" id="level" name="level" value=""/>
				    <input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
    				<button class="btn btn-lblue pull-left" style="display: none;" name="Save" id="Save" type="submit"><spring:message code="Exam.SaveNext" /></button>		
                		 <div class="form-group">
                            <div class="col-sm-2 control-label"><spring:message code="MSCITExam.Question" /> ${i.index +1 } :</div>
                            <div class="col-sm-10">
                                <p class="form-control-static ">${examViewModel.practical.itemText }</p>                                                               
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                            
                            <a class="btn btn-green prtbtn" data-lnk="prq:url?uid=${sessionScope.user.venueUser[0].userName}&ceid=${examViewModel.candidateItemAssociation.fkCandidateExamID}&cid=${examViewModel.candidateItemAssociation.fkCandidateID}&iid=${examViewModel.candidateItemAssociation.fkItemID}&ciaid=${examViewModel.candidateItemAssociation.candidateExamItemID}&lid=${examViewModel.practical.itemLanguage.fkLanguageID}&lname=${examViewModel.practical.itemLanguage.language.languageName}&eid=${sessionScope.user.examEvent.examEventID}&sessionId=${sessionId}" class="btn btn-greener prtbtn"><spring:message code="Exam.StartPractical" /></a>
                            </div>
                        </div>
                </form:form>
                </c:if> 
                </c:forEach>               
                </c:when>
                <c:when test="${AnsweredQuesCnt > 0 && AnsweredQuesCnt==fn:length(examViewModelList) }">
                <div class="text-attmptinfo"><spring:message code="MSCITExam.AllQuestionAttemptedInfo" /></div>
                </c:when>
                <c:otherwise>                
                	<p class="text-attmptinfo"><spring:message code="MSCITExam.NoQuestionsDefinedInfo" /></p>
                </c:otherwise>
                </c:choose> 
                </div>
            </div>
    </section>
    </div>
</body>
</html>