<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<html>
<head>

<title><spring:message code="attemptReport.title"></spring:message></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
.error {
	color: red;
}

a:hover {
	text-decoration: none;
}
</style>

</head>
<body>


	<fieldset class="well">

	<div>
	<legend>
		<span><spring:message code="attemptReport.title"></spring:message></span>
	</legend>
	</div>
	
	<div class="holder">
		<form:form class="form-horizontal"  action="attemptDetails" method="POST" onsubmit="return validate(this);">
			<div class="control-group">
				<div class="control-label">
					<label class=" required"><spring:message code="attemptReport.candidateUserName"></spring:message><span class="star">&#160;*</span> </label>
				</div>
				<div class="controls">
					<input type="text" id="candidateUserName" name="candidateUserName" value="${candidateUserName}"/>
				</div>
				<br>
				<div class="control-group">
					<div class="controls">
						<button class="btn btn-success btn-small" type="submit"><spring:message code="attemptReport.proceed"></spring:message></button>
						<%-- <form:button class="offset1 btn btn-success btn-small " id="proceedBtn"><spring:message code="exportPaperCanAttmpt.Proceed"></spring:message></form:button> --%>
					</div>
				</div>
			</div>

		</form:form>

		<a style="display: none;" id="lnk" href="#" download>click me</a>
			<c:if test="${fn:length(candidateExamList)>0}">
				<form:form class="form-horizontal" id="selectPaperFrm" action="" method="POST">
				<table class="table table-striped table-bordered">
					<tbody>
						<tr>
							<th width="40%"><spring:message code="attemptReport.eventName"></spring:message></th>
							<th width="40%"><spring:message code="attemptReport.paperName"></spring:message></th>
							<th width="10%"><spring:message code="attemptReport.atmptNo"></spring:message></th>
							<th width="10%"><spring:message code="attemptReport.view"></spring:message></th>
						</tr>
						<c:forEach items="${candidateExamList}" var="obj">
							<tr>
								<td>${obj.examEvent.name}</td>
								<td>${obj.paper.name}</td>
								<td align="center">${obj.attemptNo}</td>
								<td>
								    <a href="../candidateAttempt/exportAttemptDetailToPdf?candidateID=${obj.fkCandidateID}&eventID=${obj.fkExamEventID}&paperID=${obj.fkPaperID}&attemptNo=${obj.attemptNo}" class="btn btn-blue getPdf" style="cursor: pointer;display: none;" target="_blank">View</a> 
								    
									<a href="#" class="btn btn-blue pdfBtn" style="cursor: pointer;"  onclick="generateAttempDetailsPDF(${obj.fkCandidateID},${obj.fkExamEventID},${obj.fkPaperID},${obj.attemptNo});">View</a> 
									
									<!-- <a href="/BASE-OES-CLIENTWeb/src/main/webapp/WEB-INF/views/CandidateAttemptReport/candidateAttemptDetailsHTML.jsp">PDF</a> -->
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				</form:form>
			</c:if>
			</div>
	</fieldset>

<script type="text/javascript">
	function validate(form) {
		var e = form.elements;
		if(e['candidateUserName'].value=="")
		{
			alert('<spring:message code="candidateAttempt.enterUsername"/>');
			return false;
		}
		return true;
	}
	
	function generateAttempDetailsPDF(candidateID,eventID,paperID,attemptNo)
	{	
	 	var dat = JSON.stringify({
				"candidateID":candidateID,	
		 		"examEventID" : eventID,
						"paperID" : paperID,
						"attemptNo" : attemptNo
					});
					$.ajax({
						url : "../candidateAttempt/exportAttemptDetailToPdf_wkhtml",
						type : "POST",
						data : dat,
						contentType : "application/json",

						success : function(response) {
							console.log("response :: "+response);
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
					});
 	}
	
</script>

</body>
</html>
