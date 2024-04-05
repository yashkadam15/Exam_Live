<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%-- <%@ page errorPage="../common/jsperror.jsp"%> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title><spring:message code="questionByquestion.header"></spring:message></title>

<style type="text/css">
 /*img.resize { 
 	height: auto; 
 	width: 50px; 
 } 

 img.resize {
 	height: 50px;
 	width: auto;
 }*/
 
  a.disablelink:hover {   
    color: #333;
    background-color: #E6E6E6;   
}
 .roundAnalysis {border-radius:50%; border:1px solid #A8A8A8  ;
  background-color: #A8A8A8  ;  
    }
 .lineColor 
{
border-color: #3A87AD;
}
.tab-content {
    overflow: inherit;
}
</style>
<spring:message code="project.resources" var="resourcespath" />

</head>
<body>
	<fieldset class="well">
		<a style="display: none;" id="lnk" href="#" download>click me</a>
		<legend>
			<span><spring:message code="viewtestscore.YourScoreCard" /> - ${candidateName}</span> <span class="pull-right"> 
			<a class="btn btn-blue btn-small" id="generatepdfBtn1" href="#"> <spring:message code="global.exportToPDF" /></a>
			<%-- <a class="btn btn-blue btn-small"
				href="../ResultAnalysis/AnalysisBooklet_${fn:replace(examDisplayCategoryPaperViewModelObj.paper.name,' ','')}_${fn:replace(candidateLoginId,' ','')}.pdf?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&candidateLoginId=${candidateLoginId}&attemptNo=${attemptNo}"
				target="blank"><spring:message code="global.exportToPDF" /></a> --%>
				<c:if test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}"> 
				<a class="btn btn-purple lnkbackpbtn btn-small" href="<c:url value="/gateway/backtopartner"></c:url>" ><spring:message code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
			</c:if> 
			</span>	
		</legend>
		
		<c:if test="${examDisplayCategoryPaperViewModelObj.paper.isSectionRequired == true}">
		 <!-- Section list -->
		 <form:form action="questionByquestion" method="POST">
		 <div class="control-group form-horizontal">
					<label class="control-label" for="inputEmail"><b><spring:message code="questionByquestion.selectSection"/></b></label>
					<div class="controls">
						<select class="span4" id="sectionId" name="sectionId">
							<option value="0" selected="selected" ><spring:message code="questionByquestion.all"/></option>	
							<c:forEach items="${sectionList}" var="section">
								 <c:choose>
									<c:when test="${section.sectionID==sectionId}">
										<option value="${section.sectionID}" selected="selected">${section.sectionName}</option>
									</c:when>
									<c:otherwise>
										<option value="${section.sectionID}">${section.sectionName}</option>
									</c:otherwise>	
								</c:choose> 								
							
							</c:forEach>
						</select>
					&nbsp;<button type="submit" class="btn btn-blue"><spring:message code="questionByquestion.proceed"/></button>	
					</div>				
				</div>		
				  <input type="hidden" name="sectionId" id="sectionId" value="${sectionId}">
			         <input type="hidden" name="examEventId" id="examEventId" value="${examEventId}">
					<input type="hidden" name="paperId" id="paperId" value="${paperId}">
					<input type="hidden" name="candidateId" id="candidateId" value="${candidateId}">
					<input type="hidden" name="itemBankID" id="itemBankID" value="${itemBankID}">
					<input type="hidden" name="loginType" id="loginType" value="${loginType}">
					<input type="hidden" name="displayCategoryId" id="displayCategoryId" value="${displayCategoryId}">
					<input type="hidden" name="collectionId" id="collectionId" value="${collectionId}">	
					<input type="hidden" name="attemptNo" id="attemptNo" value="${attemptNo}">	
					<input type="hidden" name="showBriefAnalysis" id="showBriefAnalysis" value="1">
		 </form:form>
		 </c:if>
		 
		<div id="tabbable" class="holder">
			<ul class="nav nav-tabs" id="myTab">
				<c:if test="${sectionId=='0'}">
				<li ><a href="../ResultAnalysis/viewtestscore?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}" > 
				<spring:message code="viewtestscore.BriefAnalysis" /></a></li>
				</c:if>
				
				<li class="active"><a href="../ResultAnalysis/questionByquestion?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}" data-toggle="tab">
				<spring:message code="viewtestscore.QuestionWiseAnalysis" /></a></li>
				
				<li ><a href="../ResultAnalysis/topicwise?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}" >
				<spring:message code="viewtestscore.TopicWiseAnalysis" /></a></li>
				
				<li><a href="../ResultAnalysis/difficultylevelwise?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}">
				<spring:message code="viewtestscore.LevelwiseAnalysis" /> </a></li>
			</ul>

			<fieldset><legend style="line-height: 12px;"><span></span></legend> </fieldset>
			<div class="tab-content holder" >
				<div id="tab1" class="tab-pane active" >				
					<%@include file="testdetails.jsp"%>
			   <form:form action="questionByquestion" method="POST">	
               <div class="control-group form-horizontal">
					<label class="control-label" for="inputEmail"><b><spring:message code="questionByquestion.selectTopic"/></b></label>
					<div class="controls">
						<select class="span4" id="itemBankSelect" name="itemBankSelect">
							<option value="0" selected="selected" ><spring:message code="questionByquestion.all"/></option>	
							<c:forEach items="${examDisplayCategoryPaperViewModelObj.listItemBanks}" var="eObj">
								 <c:choose>
									<c:when test="${eObj.itemBankID==itemBankID}">
										<option value="${eObj.itemBankID}" selected="selected">${eObj.name}</option>
									</c:when>
									<c:otherwise>
										<option value="${eObj.itemBankID}">${eObj.name}</option>
									</c:otherwise>	
								</c:choose> 								
							
							</c:forEach>
						</select>
					&nbsp;<button type="submit" class="btn btn-blue"><spring:message code="questionByquestion.proceed"/></button>	
					</div>
				
				</div>
				 <input type="hidden" name="sectionId" id="sectionId" value="${sectionId}">
				   <input type="hidden" name="examEventId" id="examEventId" value="${examEventId}">
					<input type="hidden" name="paperId" id="paperId" value="${paperId}">
					<input type="hidden" name="candidateId" id="candidateId" value="${candidateId}">
					<input type="hidden" name="itemBankID" id="itemBankID" value="${itemBankID}">
					<input type="hidden" name="loginType" id="loginType" value="${loginType}">
					<input type="hidden" name="displayCategoryId" id="displayCategoryId" value="${displayCategoryId}">
					<input type="hidden" name="collectionId" id="collectionId" value="${collectionId}">	
					<input type="hidden" name="attemptNo" id="attemptNo" value="${attemptNo}">					
				
				</form:form>
		
		    <c:choose>
			<c:when test="${itemBankID!=null && fn:length(itemList)==0 && itemBankID!=0}">
			<div style="background-color: white;">
			<legend><spring:message code="questionByquestion.noQuestionavailablemsg"/></legend></div>
			</c:when>
			<c:otherwise>					
                <div style="background-color: white;">
					<c:choose>
					<c:when test="${fn:length(itemAnswerMap)!=0 && itemAnswerMap!=null}">
					<p>
						<spring:message code="questionByquestion.question"></spring:message>
						${itemNo}
						<spring:message code="questionByquestion.outof"></spring:message>
						${fn:length(itemAnswerMap)}
					</p>
					
						<div class="quick-ques" style="height:auto;overflow:hidden;background-color: white">
						<c:choose>
						<c:when test="${fn:length(itemList)!=0}"><!-- show item of selected topic only -->
							<c:forEach var="itemresult" items="${itemAnswerMap}"
								varStatus="i">	                                         
                               
								<c:if test="${itemresult.value==11 }">							
									<a class="btn btn-greener " id="${itemresult.key}" data-toggle="tooltip" data-placement="top" title="<spring:message code="questionByquestion.correct" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&itemBankSelect=${itemBankID}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==10}">
									<a class="btn btn-red " id="${itemresult.key}" data-toggle="tooltip" data-placement="top" title="<spring:message code="questionByquestion.incorrect" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&itemBankSelect=${itemBankID}&attemptNo=${attemptNo}&sectionId=${sectionId}" >
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==21 }">								
									<a class="btn " id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="scoreCard.NotAttempted" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&itemBankSelect=${itemBankID}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>						
							
							    <c:if test="${itemresult.value==31}">
									<a class="btn   roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="questionByquestion.Comprehension" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&itemBankSelect=${itemBankID}&attemptNo=${attemptNo}&sectionId=${sectionId}" >
										${i.count}</a>
								</c:if>	 
								
								<c:if test="${itemresult.value==41}">
									<a class="btn   " id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="questionByquestion.matchingpair" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&itemBankSelect=${itemBankID}&attemptNo=${attemptNo}&sectionId=${sectionId}" >
										${i.count}</a>
								</c:if>	
							 
							    <c:if test="${itemresult.value==811}">
									<a class="btn   roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="analysisbooklet.multimediatypeAudio" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&itemBankSelect=${itemBankID}&attemptNo=${attemptNo}&sectionId=${sectionId}" >
										${i.count}</a>
								</c:if>	 
								
								 <c:if test="${itemresult.value==821}">
									<a class="btn   roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="analysisbooklet.multimediatypeVideo" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&itemBankSelect=${itemBankID}&attemptNo=${attemptNo}&sectionId=${sectionId}" >
										${i.count}</a>
								</c:if>	  
								
								<!-- added new status for RIFORM -->  
								<c:if test="${itemresult.value==91}">							
									<a class="btn " id="${itemresult.key}"  style="color: black;background-color: #C0C0C0;" data-toggle="tooltip" data-placement="top" title="<spring:message code="viewtestscore.evaluationPending"/>"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&itemBankSelect=${itemBankID}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>
								
								<!-- show disabled -->
								<c:if test="${itemresult.value==1}">
									<a class="btn btn-greener disablelink" id="${itemresult.key}"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==0}">
									<a class="btn btn-red disablelink" id="${itemresult.key}"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==2}">
									<a class="btn disablelink" id="${itemresult.key}" style="color: black;"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>	
								<c:if test="${itemresult.value==3}">
									<a class="btn disablelink roundAnalysis" id="${itemresult.key}" style="color: black;"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==4}">
									<a class="btn disablelink " id="${itemresult.key}" style="color: black;"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>		
								
								<c:if test="${itemresult.value==81}">
									<a class="btn  item roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="analysisbooklet.multimediatypeAudio" />"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==82}">
									<a class="btn  item roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="analysisbooklet.multimediatypeVideo" />"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>		
								
								<!-- added new status for RIFORM -->
								<c:if test="${itemresult.value==9}">
									<a class="btn disablelink " id="${itemresult.key}" style="color: black;"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>	
								
								<!-- added new status for CMPSMQT -->
								<c:if test="${itemresult.value==25}">
									<a class="btn  item roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="Comprehension - Sequential Question"
										href="javascript:void(0);" disabled="true">
										${i.count}</a>
								</c:if>	
								
								<!-- added new status for CMPSMQT -->
								<c:if test="${itemresult.value==251}">
									<a class="btn  item roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="Comprehension - Sequential Question"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>	
																			
							 </c:forEach>							
							</c:when>
							<c:otherwise>
							<c:forEach var="itemresult" items="${itemAnswerMap}"
								varStatus="i">
								<c:if test="${itemresult.value==1}">
									<a class="btn btn-greener item" id="${itemresult.key}" data-toggle="tooltip" data-placement="top" title="<spring:message code="questionByquestion.correct" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==0}">
									<a class="btn btn-red item" id="${itemresult.key}" data-toggle="tooltip" data-placement="top" title="<spring:message code="questionByquestion.incorrect" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}" >
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==2}">
									<a class="btn item" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="scoreCard.NotAttempted" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>	
								<c:if test="${itemresult.value==3}">
									<a class="btn  item roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="questionByquestion.Comprehension" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>	
								
								<c:if test="${itemresult.value==4}">
									<a class="btn  item " id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="questionByquestion.matchingpair" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>	
								
								<c:if test="${itemresult.value==81}">
									<a class="btn  item roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="analysisbooklet.multimediatypeAudio" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>
								<c:if test="${itemresult.value==82}">
									<a class="btn  item roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="<spring:message code="analysisbooklet.multimediatypeVideo" />"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>	
								
								<!-- added new status for RIFORM -->
								<c:if test="${itemresult.value==9}">
									<a class="btn  item" id="${itemresult.key}" style="color: black;background-color: #C0C0C0;" data-toggle="tooltip" data-placement="top" title="<spring:message code="viewtestscore.evaluationPending"/>"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>
								
								<!-- added new status for CMPSMQT -->
								<c:if test="${itemresult.value==25}">
									<a class="btn  item roundAnalysis" id="${itemresult.key}" style="color: black;" data-toggle="tooltip" data-placement="top" title="Comprehension - Sequential Question"
										href="../ResultAnalysis/questionByquestion?itemID=${itemresult.key}&itemNo=${i.count}&examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${attemptNo}&sectionId=${sectionId}">
										${i.count}</a>
								</c:if>
														
								</c:forEach>
							</c:otherwise>
							</c:choose>											
						</div>
					
                    <!-- Show marks obtained -->
                   
					<c:if test="${itemstatus==1 || itemstatus==11}">
						<legend style="color: green;">
							<span><spring:message code="questionByquestion.correct"></spring:message></span>
							<span class="pull-right"><spring:message code="questionByquestion.marksObtainedForItem" /> : ${examViewModel.candidateItemAssociation.marksObtained}</span>
						</legend>
					</c:if>
					<c:if test="${itemstatus==0 || itemstatus==10}">
						<legend style="color: red;">
							<span><spring:message code="questionByquestion.incorrect"></spring:message></span>
							<span class="pull-right"><spring:message code="questionByquestion.marksObtainedForItem" />  : ${examViewModel.candidateItemAssociation.marksObtained}</span>
						</legend>
					</c:if>
					<c:if test="${itemstatus==2 || itemstatus==21}">
						<legend style="color: grey;">
							<span><spring:message	code="questionByquestion.notattempted"></spring:message></span>
						</legend>
					</c:if>	
					
					<c:if test="${itemstatus==9 || itemstatus==91}">
						<legend style="color: grey">
							<span><spring:message code="viewtestscore.evaluationPending"/></span>		
							<span class="pull-right"><spring:message code="questionByquestion.marksObtainedForItem" /> :NA</span>					
						</legend>
					</c:if>							
					
					 <!-- end of Show marks obtained -->			

                    <!-- MCSC START -->
					<c:if test="${examViewModel!=null && fn:length(examViewModel.multipleChoiceSingleCorrects)!=0}">
					<c:if test="${itemType=='MCSC' || itemType=='TRUEFALSE' || itemType=='YN'}">
					<%@include file="MCSC_QuestionAnalysis.jsp"%>							
					</c:if>
					</c:if>
					<!-- MCSC END-->

                   <!-- MCMC START -->	
                   <c:if test="${examViewModel!=null && fn:length(examViewModel.multipleChoiceMultipleCorrects)!=0}">
					<c:if test="${itemType=='MCMC'}">
					<%@include file="MCMC_QuestionAnalysis.jsp"%>	
					</c:if>
					</c:if>
					<!-- MCMC END-->


					<!--PI START  -->					
					<c:if test="${examViewModel!=null && fn:length(examViewModel.pictureIdentifications)!=0}">
					<c:if test="${itemType=='PI'}">
                    <%@include file="PI_QuestionAnalysis.jsp"%>							
					</c:if>	
					</c:if>
					<!-- PI END -->					
				
					
					<!--  COMP START -->
					<c:if test="${itemType=='CMPS'}">
					<%@include file="COMP_QuestionAnalysis.jsp"%>
					</c:if>
					<!-- COMP END -->	
					
					<!--  CMPSMQT START -->
					<c:if test="${itemType=='CMPSMQT'}">
						<%@include file="CMPSMQT_QuestionAnalysis.jsp"%>
					</c:if>
					<!-- CMPSMQT END -->	
					
					<!--  MM START -->
					<c:if test="${itemType=='MM'}">
					  <%@include file="MM_QuestionAnalysis.jsp"%>				
					</c:if>
					<!-- MM END -->
		
				
				    <!-- Matching Pairs -->
					<c:if test="${itemType=='MP'}">
			        <%@include file="MP_QuestionAnalysis.jsp"%> 
			        </c:if>			
				    <!-- Matching Pairs END-->
				
				    <!-- Practical -->
				 	<c:if test="${itemType=='PRT'}">
			        <%@include file="PRT_QuestionAnalysis.jsp"%> 
			        </c:if> 
			        <!-- Practical End-->
					
					 <!-- Simulation -->
				 	<c:if test="${itemType=='SML'}">
			        <%@include file="SML_QuestionAnalysis.jsp"%> 
			        </c:if> 
			        <!-- Simulation End-->
			        
			         <!-- ResponseIn Form of Recorded Media -->
				 	<c:if test="${itemType=='RIFORM'}">
			        <%@include file="RIFORM_QuestionAnalysis.jsp"%> 
			        </c:if> 
			        <!-- ResponseIn Form of Recorded Media End-->
			        
			         <!-- Match The Column -->
				 	<c:if test="${itemType=='MTC' || itemType=='SQ'}">
			        <%@include file="MTC_QuestionAnalysis.jsp"%> 
			        </c:if> 
			        <!-- Match The Column End -->
			        
			         <!-- Error Correction -->
				 	<c:if test="${itemType=='EC' || itemType=='RWP' || itemType=='FQFA'}">
			        <%@include file="EC_QuestionAnalysis.jsp"%> 
			        </c:if> 
			        <!--Error Correction End -->
			        
			         <!-- Essay Writing -->
				 	<c:if test="${itemType=='EW'}">
			        <%@include file="EW_QuestionAnalysis.jsp"%> 
			        </c:if> 
			        <!--Essay Writing End -->
			        
			        <!-- Hot Spot -->
				 	<c:if test="${itemType=='HS'}">
			        <%@include file="HS_QuestionAnalysis.jsp"%> 
			        </c:if> 
			        <!--Hot Spot End -->
			        
			        <!-- Word Cloud -->
				 	<c:if test="${itemType=='WC'}">
			        <%@include file="WC_QuestionAnalysis.jsp"%> 
			        </c:if> 
			        <!--Word Cloud End -->
					
					<!-- Two Stage Reasoning -->
					<c:if test="${itemType=='TSR'}">
					<c:if test="${examViewModel.twoStageReasoning!=null}">
				      <b> <spring:message code="questionByquestion.question"></spring:message>
									${itemNo}:&nbsp;
						</b><p class="question-wrap">${examViewModel.twoStageReasoning.itemText }</p><br/>
						<c:if test="${examViewModel.twoStageReasoning.itemImage!=null && fn:length(examViewModel.twoStageReasoning.itemImage)!=0}">								
							 <img src="../exam/displayImage?disImg=${examViewModel.twoStageReasoning.itemImage}" class="resize" />	
							 <br/>
						</c:if>	
						
					<b><br/> <spring:message code="questionByquestion.option"></spring:message></b>
					<table class="table table-bordered">
					<tr>
					<th style="width: 40px;"><spring:message
												code="questionByquestion.sr.no"></spring:message></th>
										<th>
												<spring:message code="questionByquestion.optiontext"></spring:message>
											</th>
										<th style="width: 150px; float: rigth;"><spring:message
												code="questionByquestion.candidateselection"></spring:message></th>												
					        </tr>	
					          <c:forEach var="twoStageOptionObj" items="${examViewModel.twoStageReasoning.optionList}" varStatus="i">					
					         <c:choose>
									<c:when test="${twoStageOptionObj.optionLanguage.option.isCorrect==true}">
                                    <tr>
										 <td>${i.count}&nbsp;<img src="${resourcespath}images/tick.png"></td>
										<td>
										<p class="question-wrap">${twoStageOptionObj.optionText}</p>  
										<c:if test="${fn:length(twoStageOptionObj.optionImage)!=0}">
										<br />
								 <img src="../exam/displayImage?disImg=${twoStageOptionObj.optionImage}" />
										</c:if>
										</td>
										 <td>
									<c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
								
									<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">																			
									<c:if test="${candidateAnsObj.optionID==twoStageOptionObj.optionLanguage.fkOptionID}">										
									<c:choose>
									<c:when test="${candidateAnsObj.isCorrect==true}">
										<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/tick.png">
										</center>									
									</c:when>
									<c:otherwise>
									<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/wrong.png">
										</center>
									</c:otherwise>
									</c:choose>								
									</c:if>
									</c:forEach>										
										</c:if>
										</td>  
										</tr>
                                  </c:when>
                                  <c:otherwise>
                                   <tr>
										<td>${i.count}&nbsp;</td>
									<td>
										<p class="question-wrap">${twoStageOptionObj.optionText} </p>
										<c:if test="${fn:length(twoStageOptionObj.optionImage)!=0}">
										<br />
								 <img src="../exam/displayImage?disImg=${twoStageOptionObj.optionImage}" />
										</c:if>
									 </td>
									<td>
									 <c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">	
									<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">	
									<c:if test="${candidateAnsObj.optionID==twoStageOptionObj.optionLanguage.fkOptionID}">									
									
									<c:choose>
									<c:when test="${candidateAnsObj.isCorrect==true}">
										<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/tick.png">
										</center>									
									</c:when>
									<c:otherwise>
									<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/wrong.png">
										</center>
									</c:otherwise>
									</c:choose>
									</c:if>
									</c:forEach>										
										</c:if>
										</td>
										</tr>
                                  </c:otherwise>
                                  </c:choose>						
					  </c:forEach><!-- main item option list end here -->	  
					
					</table>
					
					 <!-- Answer Explanation of main item options -->   
                             <c:set var="Occured" value="0"/>	
                           <c:forEach var="subitemObj" items="${examViewModel.twoStageReasoning.optionList}" varStatus="j"> 						
								 <c:if test="${Occured!=1 && ((subitemObj.optionLanguage.justification !=null && fn:length(subitemObj.optionLanguage.justification)!=0)|| (subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0))}">	
									<c:set var="Occured" value="1"/>
									<p>
							       <b><spring:message
								 	code="questionByquestion.answerexplanation"></spring:message></b>
						           </p>							           
								 </c:if>								 				
								  
								<c:if
									test="${subitemObj.optionLanguage.option.isCorrect==true}">									
									<c:if test="${(subitemObj.optionLanguage.justification !=null && fn:length(subitemObj.optionLanguage.justification)!=0)
									|| (subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0)}">																		
									
									<b><spring:message code="questionByquestion.option"></spring:message>  ${i.count} </b>
									<br/>
									<p class="question-wrap">${subitemObj.optionLanguage.justification}</p>
									<c:if
										test="${subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0}">									

										<img src="../exam/displayImage?disImg=${subitemObj.optionLanguage.justificationImage}" />

										<br />
									</c:if>
									</c:if>
								</c:if>
								<c:if test="${itemstatus==0 || itemstatus==10}">
								
									 <c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
										  <c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">
											<c:if test="${candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID && candidateAnsObj.isCorrect==false}">
											
											<c:if test="${(subitemObj.optionLanguage.justification !=null && fn:length(subitemObj.optionLanguage.justification)!=0)
									    || (subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0)}">
												<b> <spring:message code="questionByquestion.option"></spring:message> ${i.count}</b>
												<br />
												<p class="question-wrap">${subitemObj.optionLanguage.justification}</p>
												<c:if test="${subitemObj.optionLanguage.justificationImage!=null && fn:length(subitemObj.optionLanguage.justificationImage)!=0}">

												  <img src="../exam/displayImage?disImg=${subitemObj.optionLanguage.justificationImage}" />
													<br />
												</c:if>	
										    </c:if><!-- check whetherjustification image or text is exist or not -->																						
										       </c:if>
										  </c:forEach> 
									  </c:if>
								  </c:if>						
							</c:forEach>
					<hr class="lineColor"/>
					
				
				         	<c:forEach var="twoStageOptionObj" items="${examViewModel.twoStageReasoning.optionList}" varStatus="i1">
									<c:set var="answer" value="0" scope="page"/>
								<b>SubItem ${i1.count} : </b><p class="question-wrap"> ${twoStageOptionObj.subItemID.subItemText} </p>								
								<c:if test="${twoStageOptionObj.subItemID.subItemImage!=null && fn:length(twoStageOptionObj.subItemID.subItemImage)!=0}">
								 <br/>
								 <img src="../exam/displayImage?disImg=${twoStageOptionObj.subItemID.subItemImage}" class="resize" />								
								</c:if>
								
								<b><br/> <br/><spring:message code="questionByquestion.option"></spring:message></b>
								<table class="table table-bordered">
								<tr>
								<th style="width: 40px;"><spring:message
												code="questionByquestion.sr.no"></spring:message></th>
										<th>
												<spring:message code="questionByquestion.optiontext"></spring:message>
											</th>
										<th style="width: 150px; float: rigth;"><spring:message
												code="questionByquestion.candidateselection"></spring:message></th>											
								<tr>
								<c:forEach var="suboptionObj" items="${twoStageOptionObj.subItemID.optionList}" varStatus="i">
								
								<c:choose>
									<c:when test="${suboptionObj.optionLanguage.option.isCorrect==true}">
										<c:set var="answer" value="1"/>			
                                    <tr>
										 <td>${i.count}&nbsp;<img src="${resourcespath}images/tick.png"></td>
										<td>
										<p class="question-wrap">${suboptionObj.subOptionText}</p>
										<c:if test="${fn:length(suboptionObj.subOptionImage)!=0}">
										<br />
								 <img src="../exam/displayImage?disImg=${suboptionObj.subOptionImage}" />
										</c:if>
										</td>
										 <td>
									<c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">	
									<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">								
									<c:if test="${candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID}">
									<c:set var="answer" value="1"/>																	
									<c:choose>
									<c:when test="${candidateAnsObj.isCorrect==true}">
										<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/tick.png"> 
										</center>									
									</c:when>
									<c:otherwise>
									<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/wrong.png">
										</center>
									</c:otherwise>
									</c:choose>																
									</c:if>
									</c:forEach>										
										</c:if>
										</td>  
										</tr>
                                  </c:when>
                                  <c:otherwise>
                                   <tr>
										<td>${i.count}&nbsp;</td>
									<td>
										<p class="question-wrap">${suboptionObj.subOptionText}</p>
										<c:if test="${fn:length(suboptionObj.subOptionImage)!=0}">
										<br />
								 <img src="../exam/displayImage?disImg=${suboptionObj.subOptionImage}" />
										</c:if>
									 </td>
									<td>
									 <c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">	
									<c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">	
									<c:if test="${ candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID}">	
									<c:set var="answer" value="1"/>															
									<c:choose>
									<c:when test="${candidateAnsObj.isCorrect==true}">
										<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/tick.png">
										</center>									
									</c:when>
									<c:otherwise>
									<center>
									<i class="icon-user"></i>&nbsp;
									<img src="${resourcespath}images/wrong.png">
										</center>
									</c:otherwise>
									</c:choose>								
									</c:if>
									</c:forEach>										
										</c:if>
										</td>
										</tr>
                                  </c:otherwise>
                                  </c:choose>                                  
                               </c:forEach>	                   
                               
								</table>
								
								 <!-- Answer Explanation of sub item option -->   
                             <c:set var="Occured" value="0"/>	                                 									      
							 <c:forEach var="suboptionObj" items="${twoStageOptionObj.subItemID.optionList}" varStatus="i">                    
								
								 <c:if test="${(Occured!=1  && answer==1) && ((suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)|| (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0))}">	
									<c:set var="Occured" value="1"/>
									<p>
							       <b><spring:message
								 	code="questionByquestion.answerexplanation"></spring:message></b>
						           </p>							           
								 </c:if>								 				
								  
								<c:if
									test="${suboptionObj.optionLanguage.option.isCorrect==true}">									
									<c:if test="${(suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)
									|| (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0)}">																		
									
									<b><spring:message code="questionByquestion.option"></spring:message>  ${i.count} </b>
									<br/>
									<p class="question-wrap">${suboptionObj.optionLanguage.justification}</p>
									<c:if
										test="${suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0}">									

										<img src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" />

										<br />
									</c:if>
									</c:if>
								</c:if>
								<c:if test="${itemstatus==0 || itemstatus==10}">
								
									 <c:if test="${fn:length(examViewModel.candidateAnswerList)!=0 && examViewModel.candidateAnswerList!=null}">
										  <c:forEach var="candidateAnsObj" items="${examViewModel.candidateAnswerList}">
											<c:if test="${candidateAnsObj.optionID==suboptionObj.optionLanguage.fkOptionID && candidateAnsObj.isCorrect==false}">
											
											<c:if test="${(suboptionObj.optionLanguage.justification !=null && fn:length(suboptionObj.optionLanguage.justification)!=0)
									    || (suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0)}">
												<b> <spring:message code="questionByquestion.option"></spring:message> ${i.count}</b>
												<br />
												<p class="question-wrap">${suboptionObj.optionLanguage.justification}</p>
												<c:if test="${suboptionObj.optionLanguage.justificationImage!=null && fn:length(suboptionObj.optionLanguage.justificationImage)!=0}">

												  <img src="../exam/displayImage?disImg=${suboptionObj.optionLanguage.justificationImage}" />
													<br />
												</c:if>	
										    </c:if><!-- check whetherjustification image or text is exist or not -->																						
										       </c:if>
										  </c:forEach> 
									  </c:if>
								  </c:if>
							</c:forEach>						
										
								<c:if test="${fn:length(examViewModel.twoStageReasoning.optionList)!=i1.count}">
							<hr class="lineColor"/>
							</c:if>	   			
								</c:forEach>  
								
								
					</c:if>
					</c:if>
					

					<!--NFIB START  -->					
					<c:if test="${itemType=='NFIB'}">
                    	<%@include file="NFIB_QuestionAnalysis.jsp"%>							
					</c:if>	
					<!-- NFIB END -->		
					
					<br/>
										
				 <table align="center">
				<tr><td><i class="icon-user"></i>&nbsp;</td>
				<td><spring:message code="questionByquestion.indicatescandidateanswer"></spring:message>&nbsp;&nbsp;</td>
				<td><img src="${resourcespath}images/tick.png">&nbsp;</td>
				<td><spring:message code="questionByquestion.indicatecorrectanswer"></spring:message>&nbsp;&nbsp;</td>
				<td><img src="${resourcespath}images/wrong.png">&nbsp;</td>
				<td><spring:message code="questionByquestion.indicateincorrectanswer"></spring:message>&nbsp;&nbsp;</td></tr>
				</table> 
				
					</c:when>
					<c:otherwise>
					<legend style="color: grey;">
							<span><spring:message code="questionByquestion.noitemavailable"></spring:message></span>
						</legend>
					</c:otherwise>
					</c:choose>
					</div>
					</c:otherwise>
					</c:choose>
					
					
					<!-- Display Back to result button to admin -->
					<c:if test="${isAdmin==1 || isAdmin==2}">
					<center>
						<a class="btn btn-blue" href="../TestReport/AttemptedPaperTestReport?examEventId=${examEventId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&candidateId=${candidateId}&attemptNo=${attemptNo}"><spring:message code="global.backToSearch" /></a>
					</center>
					</c:if>
					
					<!-- Display back button for Group analysis -->
				<c:if test="${sessionScope.user.loginType =='Group'}">
					<center>
						<a class="btn btn-blue"
							href="../GroupResultAnalysis/groupAnalysisCandidateList?examEventId=${examEventId}&paperId=${paperId}"><spring:message code="global.back" /></a>
					</center>
				</c:if>

				</div>
			</div>
			
			
			<!-- PDF Button -->
			<div class="pull-right">
			<%-- 		<a class="btn btn-blue btn-small"
						href="../ResultAnalysis/AnalysisBooklet_${fn:replace(examDisplayCategoryPaperViewModelObj.paper.name,' ','')}_${fn:replace(candidateLoginId,' ','')}.pdf?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&candidateLoginId=${candidateLoginId}&attemptNo=${attemptNo}" target="blank"><spring:message code="global.exportToPDF" /></a>
			 --%>
			 
			 	<a class="btn btn-blue btn-small" id="generatepdfBtn2" href="#"> <spring:message code="global.exportToPDF" /></a>
			<c:if test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}"> 
				<a class="btn btn-purple lnkbackpbtn btn-small" href="<c:url value="/gateway/backtopartner"></c:url>" ><spring:message code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
			</c:if> 
			</div>
		</div>
	
				<form:form id="generatepdf" target="blank"  action="../ResultAnalysis/generateAnalysisBookletReport" >
			<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}">
			<input type="hidden" id="paperId" name="paperId" value="${paperId}">
			<input type="hidden" id="candidateId" name="candidateId" value="${candidateId}">
			<input type="hidden" id="collectionId" name="collectionId" value="${collectionId}">
			<input type="hidden" id="loginType" name="loginType" value="${loginType}">
			<input type="hidden" id="attemptNo" name="attemptNo" value="${attemptNo}">
			<input type="hidden" id="sectionId" name="sectionId" value="${sectionId}">
			<input type="hidden" id="displayCategoryId" name="displayCategoryId" value="${displayCategoryId}">
			
			<%-- examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&candidateLoginId=${candidateLoginId}&attemptNo=${attemptNo} --%>
			
		</form:form>
		
	</fieldset>

<link rel="stylesheet" href="<c:url value='/resources/style/jqcloud.min.css'></c:url>" type="text/css">
<script src="<c:url value='/resources/js/jqcloud.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.imagemapster.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.rwdImageMaps.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/ios-orientationchange-fix.min.js'></c:url>"></script>
	<script type="text/javascript">
		$('.loadImg').click(function(e) {
			e.preventDefault();
			$("#paperModalImg").find('#imgid').attr('src', $(this).attr('id'));
			$("#paperModalImg").hide().fadeIn('fast');
		});
		
		
		$(document).ready(function() {
			
			$('[id^=generatepdfBtn]').click(function(){ 
				var examEventId = $('#examEventId').val();
				var paperId=$('#paperId').val();
				var candidateId=$("#candidateId").val();
				var collectionId=$("#collectionId").val();
				var loginType=$("#loginType").val();
				var attemptNo = $("#attemptNo").val();
				var displayCategoryId = $("#displayCategoryId").val();
				var sectionId = $("#sectionId").val();
			
				//String candidateId,String examEventID,String attemptNO,String paperID,String candidateLoginId,String attemptNo
				//examEventId=69&paperId=1223&candidateId=464215&collectionId=276&displayCategoryId=0&loginType=&attemptNo=1&sectionId=0
				//?examEventId=69&paperId=1223&candidateId=464215&collectionId=276&displayCategoryId=0&loginType=&attemptNo=1&sectionId=0
				var dat = JSON.stringify({ "examEventID" : examEventId, "paperID":paperId, "candidateId":candidateId, "collectionId":collectionId, "displayCategoryId":displayCategoryId,"attemptNo":attemptNo,"sectionId":0 }); 
				// console.log(dat);
				$.ajax({
					url : "generateAnalysisBookletReport",
					type : "POST",
					data : dat,
					contentType : "application/json",
					/* dataType : "json", */
					success : function(response) {
						if(response)
						{
							  $('#lnk').attr('href', "../" + response);
				            $('#lnk')[0].click();
						}
						else
						{
							alert('<spring:message code="candidateAttempt.noDataFound"/>');
						}
					},
					error : function() {
						alert('<spring:message code="candidateAttempt.errorGeneratingPDF"/>');
					}
				}); /* end of ajax */	
				
				
			});
			
			
		  	var itemId="${itemId}";   
			$('.quick-ques').find('a[href]')  // only target <a>s which have a href attribute
                            .each(function() {
                   var id=$(this).attr("id");         
                    if(id==itemId)
                    {        	
                  $(this).addClass("current");          
                    }
        	  });
			
		}); /* End of document ready */
		
		
		
	</script>
	<script type="text/javascript">

function shuffle(array) 
{
	  var currentIndex = array.length, temporaryValue, randomIndex;
	
	  while (0 !== currentIndex) {
	
	    randomIndex = Math.floor(Math.random() * currentIndex);
	    currentIndex -= 1;
	
	    temporaryValue = array[currentIndex];
	    array[currentIndex] = array[randomIndex];
	    array[randomIndex] = temporaryValue;
	  }
	
	  return array;
}

function loadWords()
{
	$('div.wcDiv').each(function()
	{		var ca = $("#hdn" + $(this).attr('id')).val();
		var wc=[];
		var arr =shuffle($(this).data('text').split(","));
		$.each(arr,function(i,v) {
			wc.push({ text: v, weight: i, html:{class: v==ca ? 'wc-selectedAnswer' : '' , style: i%3==0 ? 'writing-mode: tb-rl' : ''} });
		});
		//console.log(wc);
		$(this).jQCloud(wc, {
			  height: 400,
			  removeOverflowing: false,
			  steps: 20,
			  colors: ["#e6194B", "#3cb44b", "#ffe119", "#4363d8", "#f58231", "#911eb4", "#42d4f4", "#f032e6", "#bfef45", "#fabebe", "#469990", "#e6beff", "#9A6324", "#800000", "#aaffc3", "#808000", "#ffd8b1", "#000075", "#a9a9a9", "#000000"],
			  fontSize: {
			        from: 0.05,
			        to: 0.02
			      },		  
			  
			  center: {x: 0.5, y:0.5},
			  autoResize:	true,
			  afterCloudRender: function()
			  {
				  $(this).find('span.wc-selectedAnswer').each(function(){
					  $(this).css('background-color', $(this).css('color'));
					  $(this).css('color', 'rgb(255,255,255)');
				  });
			  }
		});
	});
}

$(document).ready(function() {
	loadWords();
	showSpotData();
	$('[id^=refMatrixDiv]').each(function() {
		console.log("OKK");
		createMatrix(this.id.split("_")[1]);
	});
});
</script>
<script type="text/javascript">
function showSpotData()
{
	$('img[usemap]').each(function(){
		var img=$(this);
		$(img).mapster({
		    areas: [
		        {
		            key: 'XX',
		            fillColor: '00ff00',
		            staticState: true,
		            stroke: true            
		        },
		        {
		            key: 'NV',
		            fillColor: 'ff0000',
		            staticState: true          
		        }
		   ],
		    mapKey: 'state'
		});
		//$('img[usemap]').rwdImageMaps();
	
		$('div.areaDivs'+$(img).attr('id')).each(function()
		{
			var di = document.createElement('div');
	        var im = document.createElement('img');
	        $(di).addClass("hs_pointer_di");
	        $(im).addClass("hs_pointer");
	        $(im).attr('src','../resources/images/hs_pointer.png')
	        $(di).css("left",parseInt($(this).find('input:hidden[id^="x1_"]').val())+Math.round($(img).position().left)-20);
	        $(di).css("top",parseInt($(this).find('input:hidden[id^="y1_"]').val())+Math.round($(img).position().top)-32);
	        $(di).css("position",'absolute');
	        $(di).attr("data-x1",$(this).find('input:hidden[id^="x1_"]').val());
	        $(di).attr("data-y1",$(this).find('input:hidden[id^="y1_"]').val());
	        $(di).append(im);
	        
	        $(img).after(di);
		});
	});
}
function createMatrix(itemID){
	var refCellData = $("#cellData_"+itemID).text();
	
	if(refCellData !='' && refCellData !=undefined){ // if celldata not empty or null
		var jsonCellData=jQuery.parseJSON(refCellData);
		//$("."+idCellData[0]+"tblRefMatrix").remove();
		//var table = $(document.createElement('table')).attr("class",+itemID+'tblRefMatrix').attr("class", "table table-bordered");
		var table = $(document.createElement('table')).attr("id",itemID).attr("class","table table-bordered");
		$.each(jsonCellData, function(key,value) {
			  var newTr = $(document.createElement('tr'));
			  /* console.log("rno:"+value.rno); */
			  var rowno=value.rno;
			  $.each(value.column, function(key,value) {
				  var colmnno=value.cno;					  
				  var newTd = $(document.createElement('td'));
					var newDiv= $(document.createElement('div')).attr("id",'div'+rowno+''+colmnno+'');
					 if('${examViewModel.matchTheColumnList[0].sequencingType}'=='TEXT')
                     {
                          newDiv.append(value.cvalue);  
                     }
                     else
                     {
                          newDiv.append('<img src="../exam/displayImage?disImg='+value.cvalue+'" class="resize" style="max-width:150px; max-height:150px;" />');
                     }
					newTd.append(newDiv);
					/* if(value.checked){
						newTd.attr("style","background-color: #2ECCFA;");
					} */
					newTr.append(newTd);
			});
			  table.append(newTr);
		});
		$("#refMatrixDiv_"+itemID).append(table);
		
	} // end matrix generation
}
</script>

</body>
</html>