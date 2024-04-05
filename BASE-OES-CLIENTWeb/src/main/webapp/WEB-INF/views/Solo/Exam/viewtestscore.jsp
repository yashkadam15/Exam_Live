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
.modal.fade.in {
    top: 10%;
}
table {
            margin: auto; /* Center align the table */
        }

.modal {
    position: fixed;
    top: 10%;
    left: 35%;
    z-index: 1050;
    width: 920px;
    margin-left: -280px;
    background-color: #ffffff;
    border: 1px solid #999;
    border: 1px solid rgba(0, 0, 0, 0.3);
    *border: 1px solid #999;
    -webkit-border-radius: 6px;
    -moz-border-radius: 6px;
    border-radius: 6px;
    -webkit-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
    -moz-box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
    box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3);
    -webkit-background-clip: padding-box;
    -moz-background-clip: padding-box;
    background-clip: padding-box;
    outline: none;
}
</style>
</head>
<body>

	<fieldset class="well">
   <div>
   
   <table border="1">
   <h4 style="text-align: center;">Candidate Assigned Questions</h4>
        <thead>
            <tr>
                <th>Sr.No.</th>
                <th>Questions</th>
                <th>Answer Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${questReport}" var="report"  varStatus="loop">
                <tr>
                     <td>${loop.index + 1}</td> 
                    <td>${report.itemText}</td>
                    <td>${report.answerStatus}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
   
    </div>
    
		<div class="pull-right">
		
			<c:if test="${showAnalysis =='true'}">
				<a class="btn btn-warning btn-small"
					href="../ResultAnalysis/viewtestscore?examEventId=${examEventId}&paperId=${paperId}&attemptNo=${attemptNo}&candidateId=${candidateId}">
					<spring:message code="homepage.historyViewAnalysis" />
				</a>
			</c:if>
			<c:if
				test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}">
				<a class="btn btn-purple lnkbackpbtn btn-small"
					href="<c:url value="/gateway/backtopartner"></c:url>"><spring:message
						code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
				<!-- Added on 08 Dec 2016 By Reena here to avoid extra condition based on hardcoded partner id =1 and make it generic for different partners   -->
				<input type="hidden" id="eraSentFlag" name="eraSentFlag"
					value="true" />
			</c:if>
			&nbsp;&nbsp;&nbsp;&nbsp;
		</div>
		
		
		<c:choose>
			<c:when test="${showResultType=='No'}">
				<!--Start :Added by Reena on 27-june-2014 :Legend and View Log button -->
				<legend>
					<c:if
						test="${sessionScope.user.examEvent.enableLog == true  && sessionScope.user.examEvent.displayToCandidate == true}">

						<span class="pull-right"> <a class="btn btn-red btn-small"
							href="#modal-LogCandidate" data-toggle="modal"
							data-backdrop="static"><spring:message
									code="examlog.viewexamlog" /></a>
						</span>
					</c:if>
				</legend>
				<!--end -->


				


				<div style="margin-left: 10px;">${resultText}</div>
			</c:when>
			<c:when test="${showResultType=='Yes'}">

				<legend>
					<span><spring:message code="viewtestscore.YourScoreCard" />
						- ${paper.name }</span> <span class="pull-right"> <c:if
							test="${showAnalysis =='true'}">
							<a class="btn btn-blue btn-small"
								href="../ResultAnalysis/AnalysisBooklet_${fn:replace(paper.name,' ','')}_${fn:replace(candidateId,' ','')}.pdf?examEventId=${examEventId}&paperId=${paperId}&candidateId=${candidateId}&attemptNo=${examDisplayCategoryPaperViewModelObj.candidateExam.attemptNo}"
								target="blank"><spring:message code="viewTestScore.exportPDF" /></a>
						</c:if> <!--start :Added by Reena on 27-june-2014 :Legend and View Log button -->
						<c:if
							test="${sessionScope.user.examEvent.enableLog == true  && sessionScope.user.examEvent.displayToCandidate == true}">
							<a class="btn btn-red btn-small" href="#modal-LogCandidate"
								data-toggle="modal" data-backdrop="static"><spring:message
									code="examlog.viewexamlog" /></a>
						</c:if> <!--end -->
					</span>

				</legend>
    
				<div class="holder">

					<div style="border-color: blue; margin-left: 1px">
						<%@include file="../candidateModule/testdetails.jsp"%>

						<table class="table table-bordered table-condenesed"
							style="background-color: white" style="background-color: white">
							<tbody>
								<tr>
									<th colspan="6"
										style="text-align: center; background-color: #E6E6E6;"><spring:message
											code="viewtestscore.Questions" /></th>
								</tr>
								<c:choose>
									<c:when
										test="${resultAnalysisViewModelObj.paperContainCMPSItem==true}">
										<tr style="background-color: #FBFBFB;">
											<th colspan="2" width="170px;"><spring:message
													code="viewtestscore.Questions" /></th>
											<th><spring:message code="viewtestscore.Attempted" /></th>
											<th><spring:message code="viewtestscore.Correct" /></th>
											<th><spring:message code="viewtestscore.Incorrect" /></th>
											<th width="140px;"><spring:message
													code="viewtestscore.evaluationPending" /></th>
										</tr>
										<tr>
											<td style="text-align: center;" width="50px;"><b><spring:message
														code="viewtestscore.mainQuestions" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItemCorrectAnswer}</td>
											<td style="text-align: center;">${(resultAnalysisViewModelObj.totalAttemptedMainItem-resultAnalysisViewModelObj.totalMainItemCorrectAnswer)-resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingMainItem}</td>
										</tr>
										<tr>
											<td style="text-align: center;"><b><spring:message
														code="viewtestscore.subQuestions" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalSubItemCorrectAnswer}</td>
											<td style="text-align: center;">${(resultAnalysisViewModelObj.totalAttemptedSubItem-resultAnalysisViewModelObj.totalSubItemCorrectAnswer)-resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
										</tr>
										<tr>
											<td style="text-align: center;"><b><spring:message
														code="difficultylevelwise.Total" /></b></td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItem+resultAnalysisViewModelObj.totalSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalAttemptedMainItem+resultAnalysisViewModelObj.totalAttemptedSubItem}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalMainItemCorrectAnswer+resultAnalysisViewModelObj.totalSubItemCorrectAnswer}</td>
											<td style="text-align: center;">${((resultAnalysisViewModelObj.totalAttemptedMainItem-resultAnalysisViewModelObj.totalMainItemCorrectAnswer)+(resultAnalysisViewModelObj.totalAttemptedSubItem-resultAnalysisViewModelObj.totalSubItemCorrectAnswer))-(resultAnalysisViewModelObj.totalEvaluationPendingMainItem+resultAnalysisViewModelObj.totalEvaluationPendingSubItem)}</td>
											<td style="text-align: center;">${resultAnalysisViewModelObj.totalEvaluationPendingMainItem + resultAnalysisViewModelObj.totalEvaluationPendingSubItem}</td>
										</tr>
									</c:when>
									<c:otherwise>
										<tr style="background-color: #FBFBFB;">
											<th colspan="2"><spring:message
													code="viewtestscore.TotalQuestions" /></th>
											<th><spring:message code="viewtestscore.Attempted" /></th>
											<th><spring:message code="viewtestscore.Correct" /></th>
											<th><spring:message code="viewtestscore.Incorrect" /></th>
											<th><spring:message
													code="viewtestscore.evaluationPending" /></th>
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
									<th colspan="6"
										style="text-align: center; background-color: #E6E6E6;"><spring:message
											code="viewtestscore.Marks" /></th>
								</tr>
								<tr style="background-color: #FBFBFB;">
									<th colspan="2"><spring:message
											code="viewtestscore.TotalMarks" /></th>
									<th><spring:message code="correctquestionmarks.lable" /></th>
									<th><spring:message code="incorrectquestionmarks.lable" /></th>
									<th><spring:message
											code="viewtestscore.MarksObtained" />&nbsp;&nbsp;<span
										class="text-error"><b>*</b></span></th>
									<th><spring:message code="viewtestscore.MinimumPassing" /></th>
								</tr>
								<tr class="text-center">
									<td style="text-align: center;" class="text-center" colspan="2">${resultAnalysisViewModelObj.totalMarks}</td>
									<td style="text-align: center;" class="text-center">${resultAnalysisViewModelObj.totalMarksObtainedForCorrect}</td>
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
						<p>
							<span class="text-error"><b>*</b></span>
							<spring:message code="viewtestscore.marksCalculationFormula" />
						</p>

						<br>

						<div class="row-fluid">
							<div class="span2">
								<b><spring:message code="viewtestscore.Percentage" /></b>
							</div>
							<div class="span6">
								<div class="progress">
									<c:choose>
										<c:when
											test="${resultAnalysisViewModelObj.totalMarks==null || resultAnalysisViewModelObj.totalMarks==0 }">
											<div class="bar " style="width: 0%; color: black;">0%</div>
										</c:when>
										<c:otherwise>
											<!-- Set color to black if percentage less than equal to 0 -->
											<c:choose>
												<c:when
													test="${((resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100)<=0}">
													<div class="bar "
														style="width:${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}%;color:black;">
														<fmt:formatNumber type="number" maxFractionDigits="2"
															value="${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}" />
														%
													</div>
												</c:when>
												<c:otherwise>
													<div class="bar "
														style="width:${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}%;">
														<fmt:formatNumber type="number" maxFractionDigits="2"
															value="${(resultAnalysisViewModelObj.totalObtainedMarks/resultAnalysisViewModelObj.totalMarks)*100}" />
														%
													</div>
												</c:otherwise>
											</c:choose>

										</c:otherwise>
									</c:choose>

								</div>
							</div>
						</div>
						<!-- <div class="row-fluid">
							<div class="span2">
								<b>Percentile</b>
							</div>
							<div class="span6">
								<div class="progress">

									<div class="bar " style="width: 75%;">75%</div>
								</div>
							</div>
						</div> -->

						<div class="row-fluid">
							<div class="span2">
								<b><spring:message code="viewtestscore.ResultStatus" /></b>
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
							<div class="span2">
								<b><spring:message code="viewtestscore.Rank" /></b>
							</div>
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
									<div class="span6">Candidate not eligible for rank.</div>
								</c:otherwise>
							</c:choose>
						</div> --%>
						<br>

					</div>

					<c:if test="${sessionScope.user.loginType =='Group'}">
						<center>
							<a class="btn btn-blue "
								href="../GroupResultAnalysis/groupScoreCardCandidateList?examEventId=${examEventId}&paperId=${paperId}&attemptNo=${attemptNo}"><spring:message code="viewtestScore.back" /></a>
						</center>
					</c:if>
				</div>


			</c:when>
		</c:choose>


		<!--Start Block Exam Log Modal: Added by Reena on 27-june-2014 Show Candidate Exam Log in Modal -->
		<div id="modal-LogCandidate" class="modal modal-lg hide fade" tabindex="-1"	role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
			<div class="modal-header">
				<h3 id="myModalLabel">
					<spring:message code="examlog.examactivitylog" />
				</h3>
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

		<%-- <div class="pull-right">
			<c:if test="${showAnalysis =='true'}">
				<a class="btn btn-warning btn-small"
					href="../ResultAnalysis/viewtestscore?examEventId=${examEventId}&paperId=${paperId}&attemptNo=${attemptNo}&candidateId=${candidateId}">
					<spring:message code="homepage.historyViewAnalysis" /></a>
			</c:if>

			<c:if
				test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}">
				<a class="btn btn-purple lnkbackpbtn btn-small"
					href="<c:url value="/gateway/backtopartner"></c:url>"><spring:message
						code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
						<!-- Added on 08 Dec 2016 By Reena here to avoid extra condition based on hardcoded partner id =1 and make it generic for different partners   -->
						<input type="hidden" id="eraSentFlag" name="eraSentFlag" value="true" />
			</c:if>
			&nbsp;&nbsp;&nbsp;&nbsp;
		</div> --%>
		
		<div id="sb_info_div">
			<input type="hidden" id="sbHidpid" value="${paperId }" /> <input
				type="hidden" id="sbHidcnm"
				value="${sessionScope.user.venueUser[0].userName }" />
		</div>


		<!-- Added on 12-Aug-2015 By sapanag to call result data transfer to ERA  -->
		<input type="hidden" id="candidateId" name="candidateId"
			value="${candidateId}" /> <input type="hidden" id="examEventId"
			name="examEventId" value="${examEventId}" /> <input type="hidden"
			id="paperId" name="paperId" value="${paperId}" /> <input
			type="hidden" id="attemptNo" name="attemptNo" value="${attemptNo}" />
	<!-- Commented on 08 Dec 2016 By Reena here to avoid extra condition based on hardcoded partner id =1 and make it generic for different partners,written above   -->
		<%-- <c:if
			test="${oesPartnerMaster.partnerId==1 && examDisplayCategoryPaperViewModelObj.examEventPaperDetails.paperDeliveredThrough==1}">
			<input type="hidden" id="eraSentFlag" name="eraSentFlag" value="true" />
		</c:if> --%>



	</fieldset>

	<script type="text/javascript">
		function setShowSBInfo(msg) {
			$('#sb_info_div').append(msg);
		}

		//Added on 12-Aug-2015 By sapanag to call result data transfer to ERA
		$(document).ready(
				function() {

					//if partnerID and paperDeliveryThrough mode is era then only send marks to ERA

					if ($('#eraSentFlag').val() == 'true') {
						candidateId = $('#candidateId').val();
						examEventId = $('#examEventId').val();
						paperId = $('#paperId').val();
						attemptNo = $('#attemptNo').val();

						$.ajax({
							url : "../gateway/sendCandMarksToEra",
							type : "POST",
							data : JSON.stringify({
								fkCandidateID : candidateId,
								fkExamEventID : examEventId,
								fkPaperID : paperId,
								attemptNo : attemptNo
							}),
							contentType : "application/json",
							dataType : "json",							
							success : function(response) {
								console.log(response);
								//alert('success');
							},
							error : function(err) {
								console.log(err);
								//alert("opps.....");
							}
						}); /* end of ajax */
					}
					/*26 Apr 2016 : RIFORM Item Type File Upload */
					if (navigator.userAgent.search('MOSB') >= 0
							&& typeof js != "undefined") {
						
						js.stopEvidenceCapture();
					}
				});
	</script>
</body>
</html>