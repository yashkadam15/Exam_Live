<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<html>
<head>

<title>Personality Profiling Report</title>
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



	<legend>
		<span><spring:message code="getCandidate.profilingReport"/></span>
	</legend>




	<div class="holder">


		<form:form class="form-horizontal"  action="candidateProfilingTestReport" method="GET" onsubmit="return validate(this);" target="_blank">
			<div class="control-group">
				<div class="control-label">
					<label class=" required"><spring:message code="candidateDetails.candidateCode"></spring:message><span class="star">&#160;*</span> </label>
				</div>
				<div class="controls">
					<input type="text" id="candidateUserName" name="candidateUserName" value="${fn:escapeXml(candidateUserName)}"/>
				</div>
				<br>
				<div class="control-group">
					<div class="controls">
						<button class="btn btn-success btn-small" type="submit"><spring:message code="attemptReport.proceed"></spring:message></button>
						
					</div>
				</div>
			</div>

		</form:form>		
			
	</div>

<script type="text/javascript">
	function validate(form) {
		var e = form.elements;
		if(e['candidateUserName'].value=="")
		{
			alert('<spring:message code="getCandidate.enterCandCode"/>');
			return false;
		}
		return true;
	}
</script>

</body>
</html>
