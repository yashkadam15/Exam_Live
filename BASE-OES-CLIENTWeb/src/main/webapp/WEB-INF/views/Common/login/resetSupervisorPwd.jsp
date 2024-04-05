<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<html>
<head>
<title><spring:message code="passwordchange.title"/></title>
<style type="text/css">
.error {
	color: red;
}

.popover {
	font-size: 14px;
}
</style>
</head>

<body>
	<fieldset class="well">
		<legend>
			<span><spring:message code="menu.supervisorPwdReset"/></span>
		</legend>
		<div class="holder">
			<!-- <a
					href="resetSupervisorPwdToVenuecode" class="button btn btn-primary active"
					data-toggle="tab"> Reset Password
					</a> -->
					<form:form  action="resetSupervisorPwd"
				method="POST">
					<br>
				<b><spring:message code="passwordReset.confirm"></spring:message></b>
					<br/><br/>
				<div class="control-group">
					<div class="controls">
						<button type="submit"  class="btn btn-blue">
							<spring:message code="password.reset"/>
						</button>
					</div>
				</div>
			</form:form>
			</div>
	</fieldset>

<!-- 
	<script type="text/javascript">
		function validate(form) {
			var first = $("#passwordStrength").val();
			var second = $("#confirm-password").val();
			if (first != second) {
				$("#errordiv")
						.text(
								"Your new passwords do not match. Please type more carefully.");
				return false;
			}
			return true;
		}

		$(document).ready(function() {

$("#oldPwd").val('');
		});
	</script> -->



	</div>
</body>
</html>
