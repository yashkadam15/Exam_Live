<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="viewtestscore.title" /></title>

<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">

<a style="display: none;" id="lnk" href="#" download><spring:message code="difficultylevelwise.clickMe"/></a>
		<legend>
			<span><spring:message code="viewtestscore.YourScoreCard" /> - ${candidateName}</span> <span class="pull-right"> 
			<%-- <a class="btn btn-blue btn-small"
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
		 <form:form action="viewtestscore" method="POST">
		 <div class="control-group form-horizontal">
					<label class="control-label" for="inputEmail"><b><spring:message code="viewtestscore.selectSection" /></b></label>
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

		<div id="tabbable" class="holder">
			<ul class="nav nav-tabs" id="myTab">
				
				<li class="active"><a href="#" data-toggle="tab"> <spring:message
							code="viewtestscore.BriefAnalysis" /></a></li>
				<li><a	href="../ResultAnalysis/questionByquestion?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}">
						<spring:message code="viewtestscore.QuestionWiseAnalysis" />
				</a></li>
				<li><a	href="../ResultAnalysis/topicwise?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}">
						<spring:message code="viewtestscore.TopicWiseAnalysis" />
				</a></li>
				<li><a	href="../ResultAnalysis/difficultylevelwise?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&loginType=${loginType}&attemptNo=${attemptNo}">
						<spring:message code="viewtestscore.LevelwiseAnalysis" />
				</a></li>
				
				
			</ul>
			<fieldset><legend style="line-height: 12px;"><span></span></legend> </fieldset>
			


			<div class="tab-content">
				<div id="tab1" class="tab-pane active">

					<%-- <div>
						<legend>
							<span><spring:message code="viewtestscore.YourScoreCard" />
								- ${candidateName}</span>
						</legend>
					</div>
 --%>
					<div style="border-color: blue; margin-left: 1px;">
						<%@include file="testdetails.jsp"%>
						<div style="background-color: white"
							style="background-color: white">
							<table class="table table-bordered table-condenesed"
								style="background-color: white" style="background-color: white">
								<tbody>
									<tr>
										<th colspan="6" style="text-align: center;background-color: #E6E6E6;"><spring:message
												code="viewtestscore.Questions" /></th>
									</tr>
								<c:choose>
									<c:when test="${resultAnalysisViewModelObj.paperContainCMPSItem==true}">
										<tr style="background-color: #FBFBFB;">
											<th colspan="2" width="170px;"><spring:message code="viewtestscore.Questions" /></th>
											<th><spring:message code="viewtestscore.Attempted" /></th>
											<th><spring:message code="viewtestscore.Correct" /></th>
											<th><spring:message code="viewtestscore.Incorrect" /></th>
											<th width="140px;"><spring:message code="viewtestscore.evaluationPending"/></th>
										</tr>
										<tr>
											<td style="text-align: center;" width="50px;"><b><spring:message code="viewtestscore.mainQuestions" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItemCorrectAnswer}</td>
											<td style="text-align: center;">${(resultAnalysisViewModelObj.totalAttemptedMainItem-resultAnalysisViewModelObj.totalMainItemCorrectAnswer)-resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
										</tr>
										<tr>
											<td style="text-align: center;"><b><spring:message code="viewtestscore.subQuestions" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalSubItemCorrectAnswer}</td>
											<td style="text-align: center;">${(resultAnalysisViewModelObj.totalAttemptedSubItem-resultAnalysisViewModelObj.totalSubItemCorrectAnswer)-resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
										</tr>
										<tr>
											<td style="text-align: center;"><b><spring:message code="difficultylevelwise.Total" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItem+resultAnalysisViewModelObj.totalSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedMainItem+resultAnalysisViewModelObj.totalAttemptedSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItemCorrectAnswer+resultAnalysisViewModelObj.totalSubItemCorrectAnswer}</td>
											<td style="text-align: center;">${((resultAnalysisViewModelObj.totalAttemptedMainItem-resultAnalysisViewModelObj.totalMainItemCorrectAnswer)+(resultAnalysisViewModelObj.totalAttemptedSubItem-resultAnalysisViewModelObj.totalSubItemCorrectAnswer))-(resultAnalysisViewModelObj.totalEvaluationPendingMainItem+resultAnalysisViewModelObj.totalEvaluationPendingSubItem)}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingMainItem + resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
										</tr>
									</c:when>
									<c:otherwise>
										<tr style="background-color: #FBFBFB;">
											<th colspan="2"><spring:message code="viewtestscore.TotalQuestions" /></th>
											<th><spring:message code="viewtestscore.Attempted" /></th>
											<th><spring:message code="viewtestscore.Correct" /></th>
											<th><spring:message code="viewtestscore.Incorrect" /></th>
											<th><spring:message code="viewtestscore.evaluationPending"/></th>
										</tr>
										<tr>
											<td style="text-align: center;" colspan="2">${resultAnalysisViewModelObj.totalMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItemCorrectAnswer}</td>
											<td style="text-align: center;">${(resultAnalysisViewModelObj.totalAttemptedMainItem-resultAnalysisViewModelObj.totalMainItemCorrectAnswer)-resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
										</tr>
									</c:otherwise>
								</c:choose>
								<tr>
									<th colspan="6" style="text-align: center;background-color: #E6E6E6;"><spring:message code="viewtestscore.Marks" /></th>
								</tr>
								<tr style="background-color: #FBFBFB;">
									<th colspan="2"><spring:message code="viewtestscore.TotalMarks" /></th>
									<th><spring:message code="correctquestionmarks.lable" /></th>
									<th><spring:message code="incorrectquestionmarks.lable" /></th>
									<th><spring:message
											code="viewtestscore.MarksObtained" />&nbsp;&nbsp;<span
										class="text-error"><b>*</b></span></th>
									<th><spring:message code="viewtestscore.MinimumPassing" /></th>
								</tr>
								<tr>
									<td style="text-align: center;" colspan="2">${resultAnalysisViewModelObj.totalMarks}</td>
									<td style="text-align: center;">${resultAnalysisViewModelObj.totalMarksObtainedForCorrect}</td>
									<td style="text-align: center;">${resultAnalysisViewModelObj.totalMarksObtainedForInCorrect}</td>
									<td style="text-align: center;">
										${resultAnalysisViewModelObj.totalObtainedMarks}
									</td>
									<td style="text-align: center;"><c:choose>
											<c:when
												test="${resultAnalysisViewModelObj.minimumPassingMarks==null}">
												<spring:message code="viewtestscore.NA" />
											</c:when>
											<c:otherwise>
										${resultAnalysisViewModelObj.minimumPassingMarks}
										</c:otherwise>
										</c:choose></td>
								</tr>
								</tbody>
							</table>
							<p><span class="text-error"><b>*</b></span>
								<spring:message code="viewtestscore.marksCalculationFormula" /></p>
							<br>


							<div class="row-fluid" style="background-color: white"style="background-color: white">
							<div class="span3">
								&nbsp;&nbsp;&nbsp;<b><spring:message code="viewtestscore.Percentage" /></b>
							</div>
							<div class="span6">
								<div class="progress" >
									<c:choose>
										<c:when test="${resultAnalysisViewModelObj.totalMarks==null || resultAnalysisViewModelObj.totalMarks==0 }">
											<div class="bar " style="width:0%;color:black;">0%</div>	
										</c:when>
										<c:otherwise>
										<!-- Set color to black if percentage less than equal to 0 -->
											<c:choose> 
												<c:when test="${((resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100)<=0}">
													<div class="bar " style="width:${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}%;color:black;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}" />% </div>
												</c:when>
												<c:otherwise>
													<div class="bar " style="width:${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}%;"><fmt:formatNumber type="number" maxFractionDigits="2" value="${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}" />% </div>
												</c:otherwise>
											</c:choose>
											
										</c:otherwise>
									</c:choose>
									
								</div>
							</div>
						</div>

							<div class="row-fluid">
								<div class="span3">
									&nbsp;&nbsp;&nbsp;<b><spring:message
											code="viewtestscore.ResultStatus" /></b>
								</div>
								<div class="span6">

									<c:choose>
										<c:when
											test="${resultAnalysisViewModelObj.minimumPassingMarks==null}">
											<font color="green"><spring:message
													code="viewtestscore.NA" /></font>
										</c:when>
										<c:when
											test="${resultAnalysisViewModelObj.totalObtainedMarks >= resultAnalysisViewModelObj.minimumPassingMarks}">
											<font color="green"><spring:message
													code="viewtestscore.Pass" /></font>
										</c:when>
										<c:when
											test="${resultAnalysisViewModelObj.totalObtainedMarks < resultAnalysisViewModelObj.minimumPassingMarks}">
											<font color="red"><spring:message
													code="viewtestscore.Fail" /></font>
										</c:when>
									</c:choose>

								</div>
							</div>

							<%-- <div class="row-fluid">
								<div class="span3">
									&nbsp;&nbsp;&nbsp;<b><spring:message code="viewtestscore.Rank" /></b>
								</div>
								<!-- Display rank if marks obtained -->
								<c:choose>
									<c:when
										test="${resultAnalysisViewModelObj.totalObtainedMarks>=0}">
										<div class="exampage">
											<div class="exampage legend span7">
												<c:forEach var="rankDigit" items="${listRankDigitsWithZero}">
													<span class="btn">${rankDigit}</span>
												</c:forEach>
												<c:forEach var="rankDigit" items="${listRankDigits}">
													<span class="btn btn-red">${rankDigit}</span>
												</c:forEach>
												&nbsp; <b><spring:message code="viewtestscore.OutOf" /></b>
												&nbsp;
												<c:forEach var="rankOutOfDigit"
													items="${listRankOutOfDigits}">
													<span class="btn btn-blue">${rankOutOfDigit}</span>
												</c:forEach>
											</div>
										</div>
									</c:when>
									<c:otherwise>
										<div class="span6">
											<label><spring:message code="viewtestscore.notEligible" /></label>
										</div>
									</c:otherwise>
								</c:choose>
								
							</div> --%>
						</div>
					</div>

					<br>

				</div>
				<!-- Display Back to result button to admin for solo analysis -->
				<c:if test="${isAdmin==1 || isAdmin==2}">
					<center>
						<a class="btn btn-blue"
							href="../TestReport/AttemptedPaperTestReport?examEventId=${examEventId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&candidateId=${candidateId}&attemptNo=${attemptNo}"><spring:message code="global.backToSearch" /></a>
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
			
			<!-- PDF Button -->
			<div class="pull-right">
					<a class="btn btn-blue btn-small" id="generatepdfBtn2" href="#"> <spring:message code="global.exportToPDF" /></a>
			<c:if test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}"> 
				<a class="btn btn-purple lnkbackpbtn btn-small" href="<c:url value="/gateway/backtopartner"></c:url>" ><spring:message code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
			</c:if> 
			</div><br>
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