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
			<span><spring:message code="menu.supervisorPwdChange"/></span>
		</legend>
		<div class="holder">
			<form:form modelAttribute="examCenterSupervisorAssociation" action="SupervisorchangePwd"
				method="POST" onsubmit="return validate(this);">

			<%-- <spring:message code="passwordchange.username"/> : <b>${sessionScope.user.venueUser[0].userName}</b> --%>

				<br>
				<div class="control-group">
					<div class="control-label">
						<label id="username-lbl"  class=" required"><spring:message code="passwordchange.oldpassword"/> <span class="star">&#160;*</span>
						</label>
					</div>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-lock"></i></span>
						<form:password path="supervisorPassword" value="" class="text" size="25"
							required="required" placeholder="Old password" id="oldPwd" />

					</div>
					<form:errors path="supervisorPassword" cssClass="error"></form:errors>
				</div>



				<div class="control-group">
					<div class="control-label">
						<label id="username-lbl" for="username" class=" required">
							<spring:message code="passwordchange.newpassword"/> <span class="star">&#160;*</span>
						</label>
					</div>
					<div class="input-prepend">
						<span id="popovermeter"><span class="add-on"><i
								class="icon-lock"></i></span> <input name="newpassword" type="password"
							size="25" required="required" placeholder="New Password"
							id="passwordStrength" /></span>
					</div>
					<span Class="error">${blankNewPasswordError}</span>
				</div>

				<div class="control-group">
					<div class="control-label">
						<label id="username-lbl" for="username" class=" required">
							<spring:message code="passwordchange.confirmpassword"/> <span
							class="star">&#160;*</span>
						</label>
					</div>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-lock"></i></span> <input
							name="newpasswordconfirm" type="password" size="25"
							required="required" placeholder="Confirm New Password"
							id="confirm-password" />
					</div>

					<span class="error" id="errordiv"></span>
				</div>



				<div class="control-group">
					<div class="controls">
						<button type="submit"  class="btn btn-blue">
							<spring:message code="passwordchange.changebtn"/>
						</button>
					</div>
				</div>
			</form:form>
			</div>
	</fieldset>


	<script type="text/javascript">
		function validate(form) {
			var first = $("#passwordStrength").val();
			var second = $("#confirm-password").val();
			if (first != second) {
				$("#errordiv")
						.text('<spring:message code="passWord.confirmPwd"/>');
				return false;
			}
			return true;
		}

		$(document).ready(function() {
			$('#oldPwd').attr("autocomplete", "off");
		/* 	$('input[type^="password"]').each(function(){
			   $(this).val(''); 
			});
 $("#oldPwd").val('');  */
		});
	</script>


</body>
</html>
