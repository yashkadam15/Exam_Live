<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<title></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
.error {
	color: red;
}
</style>
</head>
<body>

	<div class="well">
		<legend>
			<span><spring:message
					code="DivisionMasterupdate.DivisionMasterUpdateKey" /></span>
		</legend>
		<div class="holder">


			<form:form modelAttribute="divisionmasterObj" action="update"
				method="POST" class="form-horizontal">

                <input type="hidden" value="${earlierDivisionName}" name="earlierDivisionName"/>

				<form:hidden path="divisionID" name="divisionID" id="divisionID" />


				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message
							code="DivisionMasterupdate.divisionKey" /></label>
					<div class="controls">
						<form:input path="division" name="division" id="division" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="division" cssClass="error"></form:errors>
					</div>
				</div>



				<!-- Button -->
				<div class="control-group">
					<div class="controls">
						<button type="submit" class="btn btn-blue">
							<spring:message code="global.update" />
						</button>
					</div>
				</div>
			</form:form>
		</div>
	</div>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#changeLayout').click(function() {
				$(".toggleableForm").toggleClass("form-horizontal");
				return false;
			});

		});
	</script>
</body>
</html>
