<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
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


	<fieldset class="well">
		<legend>
			<span><spring:message
					code="DivisionMasteradd.AddDivisionMasterKey" /></span>
		</legend>
		<div class="holder">
		
			<spring:message code="global.typeSomething" var="typeSomething"></spring:message>
			<spring:message code="global.selectDate" var="selectDateMessage"></spring:message>
			<spring:message code="global.dateFormatClientSide" var="dateFormat"></spring:message>

			<form:form modelAttribute="divisionmasterObj" action="add"
				method="POST" id="addform" class="toggleableForm ${formlayout}">
			
				<form:hidden path="divisionID" name="divisionID" id="divisionID" />


				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message
							code="DivisionMasteradd.divisionKey" /></label>
					<div class="controls">
						<form:input path="division" name="division" id="division" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="division" cssClass="error"></form:errors>
					</div>
				</div>

				<!-- For Save button -->
				<div class="control-group">
					<div class="controls">
						<button type="submit" class="btn btn-blue">
							<spring:message code="global.save" />
						</button>
					</div>
				</div>
			</form:form>
		</div>
	</fieldset>
	<script type="text/javascript">
		$(function() {

			$('#changeLayout').click(function() {
				$(".toggleableForm").toggleClass("form-horizontal");
				return false;
			});

			$('.add-on').click(function() {
				$('.table-condensed').show();
				$('.bootstrap-datetimepicker-widget').show();

			});
		});
	</script>
</body>
</html>
