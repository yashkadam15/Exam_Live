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
.panel-primary {
	border-color: #428BCA;
}

.table {
	margin-bottom: 12px;
}

.panel {
	padding-bottom: 0.6px;
	padding-top: 5px;
	padding-left: 10px;
	padding-right: 10px;
	margin-bottom: 20px;
	background-color: white;
	border: 1px solid #DDD;
	border-radius: 10px;
	border-color: #428BCA;
	-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
	box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
}

.panel-title {
	margin-top: 0;
	margin-bottom: 0;
	font-size: 17.5px;
	font-weight: 500;
}

.panel-primary .panel-heading {
	color: white;
	background-color: #428BCA;
	border-color: #428BCA;
}

.panel-heading {
	padding: 10px 15px;
	margin: -15px -11px 15px;
	background-color: whiteSmoke;
	border-bottom: 1px solid #DDD;
	border-top-right-radius: 12px;
	border-top-left-radius: 12px;
}
</style>

<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">
		<legend>
			<span><spring:message code="viewTestScoreTyping.scoreCard"/>
				-${resultAnalysisViewModel.firstname}&nbsp;${resultAnalysisViewModel.middleName}&nbsp;${resultAnalysisViewModel.lastName}

			</span>
		</legend>
		<div class="holder">
		<c:choose>
			<c:when test="${showtypscorecard==1}">
				<c:choose>
				<c:when test="${examEventPaperDetails.showResultType=='Yes'}">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<h4 class="panel-title" style="text-align: center">
								${resultAnalysisViewModel.paperName} (Attempt
								#${resultAnalysisViewModel.attemptNumber})</h4>
						</div>
						<table class="table table-bordered table-complex ">
							<tr>
								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="testdetails.TestDate" /></font>
								</b></td>
								<td width="25%"><font size="2"><fmt:formatDate
											type="date" pattern="dd-MM-yyyy"
											value="${resultAnalysisViewModel.testDate}" /> </font></td>
								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message
												code="testdetails.TestDuration" /></font> </b></td>
								<td width="25%"><font size="2">
										${resultAnalysisViewModel.duration}&nbsp;<spring:message code="viewTestScoreTyping.mins"/> </font></td>

							</tr>
							<tr>
								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="viewTestScoreTyping.grossSpeed"/> </font> </b></td>
								<td width="25%"><font size="2"> <fmt:formatNumber
											type="number" maxFractionDigits="0"
											value="	${resultAnalysisViewModel.grossSpeed}" />&nbsp;<spring:message code="viewTestScoreTyping.wpm"/>
								</font></td>

								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="viewTestScoreTyping.accuracy"/></font> </b></td>
								<td width="25%"><font size="2">${resultAnalysisViewModel.accuracy}%

								</font></td>
							</tr>
							<tr>
								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="viewTestScoreTyping.netSpeed"/> </font> </b></td>
								<td width="25%"><font size="2"> <fmt:formatNumber
											type="number" maxFractionDigits="0"
											value="${resultAnalysisViewModel.netSpeed}" /> &nbsp;<spring:message code="viewTestScoreTyping.wpm"/>
								</font></td>

								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="viewTestScoreTyping.errors"/> </font> </b></td>
								<td width="25%"><font size="2">${resultAnalysisViewModel.totalIncorrectChars}&nbsp;<spring:message code="viewTestScoreTyping.words"/>

								</font></td>
							</tr>
						</table>
						<p>
							<strong><spring:message code="viewTestScoreTyping.wordspermin"/></strong>
						</p>
					</div>
				</c:when>
				<c:otherwise>
					<div class="alert alert-success" role="alert"><b>${resultText}</b></div>
					
				</c:otherwise>
			</c:choose>
			</c:when>
			<c:otherwise>
				<div class="panel panel-primary">
						<div class="panel-heading">
							<h4 class="panel-title" style="text-align: center">
								${resultAnalysisViewModel.paperName} (Attempt
								#${resultAnalysisViewModel.attemptNumber})</h4>
						</div>
						<table class="table table-bordered table-complex ">
							<tr>
								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="testdetails.TestDate" /></font>
								</b></td>
								<td width="25%"><font size="2"><fmt:formatDate
											type="date" pattern="dd-MM-yyyy"
											value="${resultAnalysisViewModel.testDate}" /> </font></td>
								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message
												code="testdetails.TestDuration" /></font> </b></td>
								<td width="25%"><font size="2">
										${resultAnalysisViewModel.duration}&nbsp;<spring:message code="viewTestScoreTyping.mins"/> </font></td>

							</tr>
							<tr>
								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="viewTestScoreTyping.grossSpeed"/> </font> </b></td>
								<td width="25%"><font size="2"> <fmt:formatNumber
											type="number" maxFractionDigits="0"
											value="	${resultAnalysisViewModel.grossSpeed}" />&nbsp;<spring:message code="viewTestScoreTyping.wpm"/>
								</font></td>

								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="viewTestScoreTyping.accuracy"/></font> </b></td>
								<td width="25%"><font size="2">${resultAnalysisViewModel.accuracy}%

								</font></td>
							</tr>
							<tr>
								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="viewTestScoreTyping.netSpeed"/> </font> </b></td>
								<td width="25%"><font size="2"> <fmt:formatNumber
											type="number" maxFractionDigits="0"
											value="${resultAnalysisViewModel.netSpeed}" /> &nbsp;<spring:message code="viewTestScoreTyping.wpm"/>
								</font></td>

								<td class="highlight" width="25%" style="color: #297DBC"><b><font
										size="2"><spring:message code="viewTestScoreTyping.errors"/> </font> </b></td>
								<td width="25%"><font size="2">${resultAnalysisViewModel.totalIncorrectChars}&nbsp;<spring:message code="viewTestScoreTyping.words"/>

								</font></td>
							</tr>
						</table>
						<p>
							<strong><spring:message code="viewTestScoreTyping.wordspermin"/></strong>
						</p>
					</div>
			</c:otherwise>
		</c:choose>
				
			
			

		</div>
		<!-- Display Back to result button to admin -->
		<c:if test="${isAdmin==1 || isAdmin==2}">
			<%-- <center>
				<a class="btn btn-blue"
					href="../TestReport/AttemptedPaperTestReport?examEventId=${examEventId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&candidateId=${candidateId}&attemptNo=${attemptNo}"><spring:message
						code="global.backToSearch" /></a>
			</center> --%>

			<center>
				<a class="btn btn-blue"
					href="../TestReport/AttemptedPaperTestReport?examEventId=${examEventId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&candidateId=${candidateId}&attemptNo=${attemptNo}"><spring:message
						code="global.backToSearch" /></a>
				<!--  back to partener button -->
				<c:if
					test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}">
					<a class="btn btn-purple lnkbackpbtn btn-small"
						href="<c:url value="/gateway/backtopartner"></c:url>"><spring:message
							code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
				</c:if>
			</center>
		</c:if>
	</fieldset>

</body>
</html>