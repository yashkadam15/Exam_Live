<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="difficultylevelwise.title" /></title>
</head>
<body>

<script type="text/javascript">
$(document).ready(function() {
	//disable back anchor tag second click
	$(".lnkbackpbtn").on('click', function() {
		$(".lnkbackpbtn").addClass("btn-btn-disabled");
	});
});
</script>
		
	<fieldset class="well">
		<a style="display: none;" id="lnk" href="#" download><spring:message code="difficultylevelwise.clickMe" /></a>
	<legend>
			<span><spring:message code="viewtestscore.YourScoreCard" /> - ${candidateName}</span> <span class="pull-right">
			<%--  <a class="btn btn-blue btn-small"
				href="../ResultAnalysis/AnalysisBooklet_${fn:replace(examDisplayCategoryPaperViewModelObj.paper.name,' ','')}_${fn:replace(candidateLoginId,' ','')}.pdf?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&candidateLoginId=${candidateLoginId}&attemptNo=${attemptNo}"
				target="blank"><spring:message code="global.exportToPDF" /></a> --%>
				<a class="btn btn-blue btn-small" id="generatepdfBtn1" href="#"> <spring:message code="global.exportToPDF" /></a>
			 <c:if test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}"> 
				<a class="btn btn-purple lnkbackpbtn btn-small" href="<c:url value="/gateway/backtopartner"></c:url>" ><spring:message code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
		    </c:if> 
			</span>
		</legend>
		
		<c:if test="${examDisplayCategoryPaperViewModelObj.paper.isSectionRequired == true}">
		 <!-- Section list -->
		 <form:form action="difficultylevelwise" method="POST">
		 <div class="control-group form-horizontal">
					<label class="control-label" for="inputEmail"><b><spring:message code="difficultylevelwise.selectSection" /></b></label>
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
					<input type="hidden" name="loginType" id="loginType" value="${loginType}">
					<input type="hidden" name="displayCategoryId" id="displayCategoryId" value="${displayCategoryId}">
					<input type="hidden" name="collectionId" id="collectionId" value="${collectionId}">	
					<input type="hidden" name="attemptNo" id="attemptNo" value="${attemptNo}">	
					<input type="hidden" name="showBriefAnalysis" id="showBriefAnalysis" value="1">
		 </form:form>
		 </c:if>

		<div id="tabbable"  class="holder">
			<ul class="nav nav-tabs" id="myTab">
				<c:if test="${sectionId=='0'}">
					<li><a	href="../ResultAnalysis/viewtestscore?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}">
					<spring:message code="viewtestscore.BriefAnalysis" /></a></li>				
				</c:if>
				
				<li><a	href="../ResultAnalysis/questionByquestion?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}">
				<spring:message code="viewtestscore.QuestionWiseAnalysis" /></a></li>
				
				<li><a href="../ResultAnalysis/topicwise?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}&sectionId=${sectionId}"> 
				<spring:message	code="viewtestscore.TopicWiseAnalysis" /></a></li>
				
				<li class="active"><a href="#" data-toggle="tab">
				<spring:message code="viewtestscore.LevelwiseAnalysis" /></a></li>
			</ul>
			<fieldset><legend style="line-height: 12px;"><span></span></legend> </fieldset>

			<div class="tab-content holder">
				<div id="tab1" class="tab-pane active" >
						
					<%@include file="testdetails.jsp"%>					

					<table class="table  table-bordered table-condenesed" style="background-color: white">
					<thead>
						<tr class="info">
							<th><spring:message code="difficultylevelwise.DifficultyLevel" /></th>
							<th><spring:message code="difficultylevelwise.Total" /></th>
							<th><spring:message code="difficultylevelwise.Correct_Attempt" /></th>
							<th><spring:message code="viewtestscore.evaluationPending"/></th>
							<th><spring:message code="difficultylevelwise.Accuracy" /></th>							
							
						</tr>
						</thead>
						<tbody>
						<tr>
							<c:choose>
								<c:when
									test="${fn:length(itemBankAndDifficultyLevelViewModelObj.listResultAnalysisViewModel)> 0}">
									<c:forEach var="ResultAnalysisViewModel"
										items="${itemBankAndDifficultyLevelViewModelObj.listResultAnalysisViewModel}" varStatus="itemBankWise">
										<tr class="percentage">
											<td>${ResultAnalysisViewModel.difficultyLevel}</td>
											<td>${ResultAnalysisViewModel.totalItem}</td>
											<td>${ResultAnalysisViewModel.totalCorrectAnswer}/${ResultAnalysisViewModel.totalAttemptedItem}</td>
											<td>${ResultAnalysisViewModel.totalEvaluationPendingItem}</td>
											<td class="accuracy"><c:choose>
													<c:when	test="${ResultAnalysisViewModel.totalCorrectAnswer==null || ResultAnalysisViewModel.totalCorrectAnswer==0 }">
														<div class="progress" data-toggle="tooltip"	title="Acccuracy : 0%">
															<div class="bar  bar-success" style="width: 0%;color:black;">0%</div>
														</div>														
														</c:when>
													<c:otherwise>
													<!-- Set color to black if percentage less than equal to 0 -->
														<c:choose>
															<c:when test="${((ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100)<=0}">
																<div class="progress" data-toggle="tooltip"	title="Acccuracy : ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%">
																	<div class="bar  bar-success" style="width: ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%;color:black;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}" />%</div>
																</div>	
															</c:when>
															<c:otherwise>
																<div class="progress" data-toggle="tooltip"	title="Acccuracy : ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%">
																	<div class="bar  bar-success" style="width: ${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}%;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(ResultAnalysisViewModel.totalCorrectAnswer/(ResultAnalysisViewModel.totalAttemptedItem-ResultAnalysisViewModel.totalEvaluationPendingItem))*100}" />%</div>
																</div>
															</c:otherwise>
														</c:choose>
																											
													</c:otherwise>
												</c:choose>
											</td>												
										</tr>
										</c:forEach>
								</c:when>
							</c:choose>
						</tr>						
						</tbody>
					</table>

				
					<!-- Display Back to result button to admin -->
					<c:if test="${isAdmin==1 || isAdmin==2}">
					<center>
						<a class="btn btn-blue" href="../TestReport/AttemptedPaperTestReport?examEventId=${examEventId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&candidateId=${candidateId}&attemptNo=${attemptNo}"><spring:message code="global.backToSearch" /></a>
					</center>
					</c:if>	
					
					<!-- Display back button for Group analysis -->
				<c:if test="${loginType=='Group'}">
					<center>
						<a class="btn btn-blue"
							href="../GroupResultAnalysis/groupAnalysisCandidateList?examEventId=${examEventId}&paperId=${paperId}"><spring:message code="global.back" /></a>
					</center>
				</c:if>			

				</div>
				<!-- tab close -->
			</div>
			
			<!-- PDF Button -->
			<div class="pull-right">
			<%-- <a class="btn btn-blue btn-small""
						href="../ResultAnalysis/AnalysisBooklet_${fn:replace(examDisplayCategoryPaperViewModelObj.paper.name,' ','')}_${fn:replace(candidateLoginId,' ','')}.pdf?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&candidateLoginId=${candidateLoginId}&attemptNo=${attemptNo}"  target="blank"><spring:message code="global.exportToPDF" /></a> --%>
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
	
	<script type="text/javascript">
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
			
			
							
		});					
					
	</script>
</body>
</html>