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

<script type="text/javascript" src="<c:url value='/resources/js/md5_encrypt.js'></c:url>"></script>
</head>

<body>
	<fieldset class="well">
		<legend>
			<span><spring:message code="passwordchange.title"/></span>
		</legend>
		<div class="holder">
			<form:form modelAttribute="objUser" action="changePassword"
				method="POST" onsubmit="return validate(this);">

			<spring:message code="passwordchange.username"/> : <b>${sessionScope.user.venueUser[0].userName}</b>
				<br>
				<br>
				<div class="control-group">
					<div class="control-label">
						<label id="username-lbl" for="userName" class=" required"><spring:message code="passwordchange.oldpassword"/> <span class="star">&#160;*</span>
						</label>
					</div>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-lock"></i></span>
						<form:password path="password" id="password" value="" class="text" size="25"
							required="required" placeholder="Old password" />

					</div>
					<form:errors path="password" cssClass="error"></form:errors>
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
						<button type="submit" class="button btn btn-primary active">
							<spring:message code="passwordchange.changebtn"/>
						</button>
					</div>
				</div>
				
				<p>
					<spring:message code="supPassChange.newPassStrong"/>
					<ul>
						<li><spring:message code="supPassChange.eightCharactersLong"/></li>
						<li><spring:message code="supPassChange.oneLowerCaseLetter"/></li>
						<li><spring:message code="supPassChange.oneUpperCaseLetter"/></li>
						<li><spring:message code="supPassChange.oneDigit"/></li>
						<li><spring:message code="supPassChange.oneSpecialCharacter"/></li>
					</ul>  
				</p>
				
			</form:form>
			</div>
	</fieldset>


	<script type="text/javascript">
		function validate(form) 
		{
			var first = $("#passwordStrength").val();
			var second = $("#confirm-password").val();
			
			/* if (first == "" || first == null) {
				alert('Please enter password.');
				return false;
			}	 */		
			if (first != second) 
			{
				$("#errordiv").text("Your new Password and confirm password do not match. Please type more carefully.");
				return false;
			}
			else
			{
				let strongPassword = new RegExp('(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})');
				if(!strongPassword.test(first))
				{
					$("#errordiv").text("Password must be strong.");
					return false;
				}
			}
			
			var OldhashValue = hex_md5($("#password").val());
			var newHashValue = hex_md5($("#passwordStrength").val());
			
			var salt = ${adminRnum};
			var saltHash = hex_md5(OldhashValue + salt);
			
			$("#password").val(saltHash);
			$("#passwordStrength").val(newHashValue); 
		
			
			return true;
		}

		$(document).ready(function() {

		});
	</script>



	</div>
</body>
</html>
