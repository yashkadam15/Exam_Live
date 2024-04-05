<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<title></title>
</head>

<body>

	<div class="well">
		<legend>
			<span><spring:message
					code="DivisionMasterdelete.DeleteDivisionMasterKey" /></span>
		</legend>
		<div class="holder">
			<form:form modelAttribute="divisionmasterObj" action="delete"
				method="POST" class="form-horizontal">

				<form:hidden path="divisionID" name="divisionID" id="divisionID" />
					<form:hidden path="division" name="division" id="division" />

				<div class="control-group">
					<div class="control-label">
						<label id="division-lbl" for="division" class=" required">
								<spring:message code="DivisionMasterdelete.divisionKey" />
						</label>
					</div>
					<div class="controls">
						<label id="lbl" class="control-label">${divisionmasterObj.division}</label>
					</div>
				</div>



				<!-- Buttons -->
				<div class="control-group">
					<div class="controls">
						<label class="checkbox">
								<input type="checkbox" name="deleteconfirm" id="deleteconfirm" />
								<spring:message code="global.confirmDelete"></spring:message>
						</label> <br />
						<button type="submit" class="btn btn-red" id="deletebtn"
							name="deletebtn">
							<spring:message code="global.delete" />
						</button>
						&nbsp;&nbsp;&nbsp; <a href="cancel" class="btn btn-blue"
							id="cancelbtn"><spring:message code="global.cancel" /></a>
					</div>
				</div>
			</form:form>
		</div>
	</div>

	<script type="text/javascript">
		$(document)
				.ready(
						function() {
							$('#deletebtn')
									.click(
											function() {
												var isChecked = $(
														'input:checkbox[name=deleteconfirm]')
														.is(':checked');
												if (!isChecked) {
													alert('<spring:message code="global.confirm" />');
													return false;
												}
											});

							$('#changeLayout').click(
									function() {
										$(".toggleableForm").toggleClass(
												"form-horizontal");
										return false;
									});
						});
	</script>
</body>
</html>
