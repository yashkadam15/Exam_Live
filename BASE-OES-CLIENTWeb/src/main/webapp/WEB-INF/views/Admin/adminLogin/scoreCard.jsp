<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="scoreCard.title"/></title>
</head>
<body>
	<fieldset class="well">
		<legend>
			<span><spring:message code="scoreCard.title"/></span>
			
		</legend>
		<div class="holder">
		<form:form  action="scoreCard" method="GET" class="form-horizontal">
				<div class="control-group">
					<label class="control-label" id="lbl"><spring:message code="scoreCard.CandidateLoginID"/>&nbsp;:</label>
				<div class="controls">
						<input type="text" id="loginId" value="${fn:escapeXml(loginId)}" name="loginId"/>
					</div>
				</div>
				<div style="padding-left: 200px;padding-top: 20px;">
						<button type="submit" class="btn btn-blue" id="result"
							name="proceedbtn">
							<spring:message code="scoreCard.ShowResult"/>
						</button>
				</div>
				<br>
				<br>
		</form:form>
		<c:if test="${fn:length(candidateExamList) != 0}">
		<table class="table table-striped table-bordered" id="demotable">
				<thead>
					<tr>
					<th colspan="6">${candidateExamList[0].candidateExam.candidate.candidateFirstName}&nbsp;${candidateExamList[0].candidateExam.candidate.candidateMiddleName}&nbsp;${candidateExamList[0].candidateExam.candidate.candidateLastName}</th>
					</tr>
					<tr>
						<th width="7%"><spring:message code="scoreCard.SrNo"/></th>
						<th><spring:message code="scoreCard.Paper"/></th>
						<th width="13%"><spring:message code="scoreCard.ExamStatus"/></th>
						<th width="20%"><spring:message code="scoreCard.AttemptDate"/></th>
						<th width="17%"><spring:message code="scoreCard.MarksObtained"/></th>
						<th width="13%"><spring:message code="scoreCard.TotalMarks"/></th>
						<th width="13%"><spring:message code="attemptedPaperTestReport.Analysis" /></th>
					</tr>
				</thead>
				
				
					<tbody>
					<c:forEach var="candidateExamDetails" items="${candidateExamList}" varStatus="i">
					<tr>
					<td>${i.index+1}</td>
					<td>${candidateExamDetails.candidateExam.paper.name}</td>
					<td>
						<c:if test="${candidateExamDetails.candidateExam.isExamCompleted==true}">
							<spring:message code="scoreCard.Completed"/>
						</c:if>
						<c:if test="${candidateExamDetails.candidateExam.isExamCompleted==false}">
							<div style="color: red;"><spring:message code="scoreCard.InComplete"/></div>
						</c:if>
						<c:if test="${candidateExamDetails.candidateExam.isExamCompleted==null}">
							<spring:message code="scoreCard.NotAttempted"/>
						</c:if>
					
					</td>
					<td><fmt:formatDate value="${candidateExamDetails.candidateExam.attemptDate}" pattern="dd-MMM-yyyy HH:mm:ss" /></td>
					<td>
					${candidateExamDetails.candidateExam.marksObtained}
					</td>
					<td>${candidateExamDetails.candidateExam.paper.totalItem}</td>
					<td>
						<c:if test="${candidateExamDetails.candidateExam.isExamCompleted==true && candidateExamDetails.examEventPaperDetails.showAnalysis==true}">
							<a class="btn btn-warning pull-right" href="../ResultAnalysis/viewtestscore?examEventId=${candidateExamDetails.candidateExam.fkExamEventID}&paperId=${candidateExamDetails.candidateExam.fkPaperID}&candidateId=${candidateExamDetails.candidateExam.fkCandidateID}&attemptNo=${candidateExamDetails.candidateExam.attemptNo}"><spring:message code="attemptedPaperTestReport.Analysis" /></a>
						</c:if>					
					</td>
					</tr>
					</c:forEach>
					</tbody>
			</table>
		
		</c:if>
		<c:if test="${fn:length(candidateExamList) == 0 && loginId!=null && loginId!=''}">
		<br><br>
		<b><spring:message code="scoreCard.Noresultdatafound"/></b>
		</c:if>

		
		</div>


	</fieldset>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#result').click(function() {
			if($.trim($('#loginId').val())=='')
				{
					alert('<spring:message code="scoreCard.PleaseenterthecandidateLoginID"/>');
					return false;
				}
			return true;
			});
		});
	</script>
</body>

</html>