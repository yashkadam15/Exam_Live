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
		<c:choose>
			<c:when test="${showResultType=='No'}">
			<!--Start :Added by Reena on 27-june-2014 :Legend and View Log button -->
				<legend>	
							<c:if test="${sessionScope.user.examEvent.enableLog == true  && sessionScope.user.examEvent.displayToCandidate == true}">
							
						<span class="pull-right"> <a class="btn btn-red btn-small"
							href="#modal-LogCandidate" data-toggle="modal"
							data-backdrop="static"><spring:message code="examlog.viewexamlog" /></a>
						</span>
					</c:if>
				</legend>
				<!--end -->
				<div class="alert alert-success">${resultText}</div>
			</c:when>
			<c:when test="${showResultType=='Yes'}">

				<legend>
					<span><spring:message code="viewtestscore.YourScoreCard" />
						- ${paper.name }</span>

					
						<span class="pull-right">
						<c:if test="${showAnalysis =='true'}">
						 <a class="btn btn-blue btn-small"
							href="../ResultAnalysis/AnalysisBooklet_${fn:replace(paper.name,' ','')}_${fn:replace(candidateId,' ','')}.pdf?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&attemptNo=${examDisplayCategoryPaperViewModelObj.candidateExam.attemptNo}"
							target="blank"><spring:message code="viewTestScore.exportPDF" /></a> 
							</c:if>
							<!--start :Added by Reena on 27-june-2014 :Legend and View Log button -->
							<c:if test="${sessionScope.user.examEvent.enableLog == true  && sessionScope.user.examEvent.displayToCandidate == true}">
							<a class="btn btn-red btn-small"
							href="#modal-LogCandidate" data-toggle="modal"
							data-backdrop="static"><spring:message code="examlog.viewexamlog" /></a>
							</c:if>
							<!--end -->
						</span>
					
				</legend>

				<div class="holder">

					<div style="border-color: blue; margin-left: 1px">
						<%@include file="../candidateModule/testdetails.jsp"%>

						<%-- <table class="table table-bordered table-condenesed"
							style="background-color: white" style="background-color: white">
							<tbody>
								<tr>
									<th colspan="4"
										style="text-align: center; background-color: #E6E6E6;"><spring:message
											code="viewtestscore.Questions" /></th>
								</tr>
							</tbody>
							<tr style="background-color: #FBFBFB;">
								<th><spring:message code="viewtestscore.TotalQuestions" /></th>
								<th><spring:message code="viewtestscore.Attempted" /></th>
								<th><spring:message code="viewtestscore.Correct" /></th>
								<th><spring:message code="viewtestscore.Incorrect" /></th>
							</tr>
							<tr>
								<td>${resultAnalysisViewModelObj.totalItem}</td>
								<td>${resultAnalysisViewModelObj.totalAttemptedItem}</td>
								<td>${resultAnalysisViewModelObj.totalCorrectAnswer}</td>
								<td>${resultAnalysisViewModelObj.totalAttemptedItem-resultAnalysisViewModelObj.totalCorrectAnswer}</td>
							</tr>
							</table> --%>
							
							<c:if test="${resultAnalysisViewModelObj.sectionwiseMarkViewModelList!=null}">
							<table class="table table-bordered table-condenesed" style="background-color: white" style="background-color: white">
						 	<tr>
								<th colspan="3"	style="text-align: center; background-color: #E6E6E6;"><spring:message code="viewTestScore.scoreDetails"/></th>
							</tr>
							<tr style="background-color: #FBFBFB;">
								<th width="50%"><spring:message code="viewTestScore.section"/></th>
								<th><spring:message code="questionAnalysis.marksObtained" /></th>
								<th><spring:message code="viewTestScore.resultStatus"/></th>
							</tr>
							<c:forEach var="sectinDetails" items="${resultAnalysisViewModelObj.sectionwiseMarkViewModelList}" varStatus="i">
							<tr>
								<td>
									${sectinDetails.sectionName}
								</td>
								<td>
								${sectinDetails.sectionObtMarks}									
								</td>
								<td>
								<c:choose>
								<c:when test="${i.index==0 }">
									<c:choose>
										<c:when test="${sectinDetails.sectionObtMarks<15}">
										<spring:message code="viewTestScore.fail"/>
										</c:when>
										<c:otherwise>
										<spring:message code="viewTestScore.pass"/>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${sectinDetails.sectionObtMarks<35}">
										<spring:message code="viewTestScore.fail"/>
										</c:when>
										<c:otherwise>
										<spring:message code="viewTestScore.pass"/>
										</c:otherwise>
									</c:choose>
								
								</c:otherwise>
								</c:choose>
									
								</td>
							</tr>
							</c:forEach>
							
						</table>
						</c:if> 
						<br>
						<br>

					<div class="alert alert-success" style="border: 1px solid #428BCA;border-radius:10px;">
					<b><spring:message code="grpAnalysisCandList.note" /></b>
					<br/> <spring:message code="viewTestScore.indicativePerformance"/> <a href="http://www.mkcl.org/careers" target="_blank"><spring:message code="viewTestScore.mkclorgcareers"/></a>.
					<div style="text-align: center;"> <b><spring:message code="viewTestScore.allthebest"/></b></div>
					</div>
						<br>

					</div>

					<c:if test="${sessionScope.user.loginType =='Group'}">
						<center>
							<a class="btn btn-blue"
								href="../GroupResultAnalysis/groupScoreCardCandidateList?examEventId=${examEventId}&paperId=${paperId}&attemptNo=${attemptNo}"><spring:message code="viewtestScore.back" /></a>
						</center>
					</c:if>
				</div>


			</c:when>
		</c:choose>


  <!--Start Block Exam Log Modal: Added by Reena on 27-june-2014 Show Candidate Exam Log in Modal -->
		<div id="modal-LogCandidate" Class="modal hide fade" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel" aria-hidden="false"
			data-keyboard="true" data-backdrop="static">
			<div class="modal-header">
				<h3 id="myModalLabel"><spring:message code="examlog.examactivitylog" /></h3>
			</div>
			<div class="modal-body">
				<%@include
					file="../PostLoginActivityLog/CandidateExamActivityLog.jsp"%>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">
					<spring:message code="homepage.Exit" />
				</button>
			</div>
		</div>
		<!--End Block Exam Log Modal-->
		
		<div class="pull-right"><c:if test="${showAnalysis =='true'}">
				<a class="btn btn-warning btn-small" href="../ResultAnalysis/viewtestscore?examEventId=${examEventId}&paperId=${paperId}&attemptNo=${attemptNo}&candidateId=${candidateId}"><spring:message code="homepage.historyViewAnalysis" /></a>
		</c:if>
		
		<c:if test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}">
				<a class="btn btn-purple lnkbackpbtn btn-small"  href="<c:url value="/gateway/backtopartner"></c:url>"  ><spring:message code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
		</c:if>
		&nbsp;&nbsp;&nbsp;&nbsp;
	</div>
	</fieldset>

</body>
</html>