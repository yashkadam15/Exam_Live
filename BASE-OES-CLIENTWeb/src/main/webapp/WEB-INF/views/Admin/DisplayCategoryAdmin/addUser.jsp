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
<script type="text/javascript" src="<c:url value='/resources/js/utilities.js'></c:url>"></script>
</head>
<body>


	<fieldset class="well">
		<legend>
			<span> <spring:message code="DisplayCategory.addUser" /></span>
		</legend>
		<div class="holder">
		
			<spring:message code="global.typeSomething" var="typeSomething"></spring:message>
			<spring:message code="global.selectDate" var="selectDateMessage"></spring:message>
			<spring:message code="global.dateFormatClientSide" var="dateFormat"></spring:message>

			<form:form modelAttribute="user" enctype="multipart/form-data" action="add"
				method="POST" id="addform" class="toggleableForm ${formlayout}">
			
				<%-- <form:hidden path="divisionID" name="divisionID" id="divisionID" /> --%>
				
					<div class="alert alert-info">
						<spring:message code="reset.Note" />
						<br>
						<ul>
						<li><spring:message code="password.note1" />
						<li><spring:message code="password.note" />
						<li><spring:message code="password.note2" />
						</ul>
					</div>

				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"> <spring:message code="DisplayCategory.firstName" /><span class="star">&#160;*</span> </label>
					<div class="controls">
						<form:input path="firstName" name="fname" id="fname" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="firstName" cssClass="error"></form:errors>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"> <spring:message code="DisplayCategory.middleName" /> </label>
					<div class="controls">
						<form:input path="middleName" name="mname" id="mname" value=""
							class="text" size="25" 
							placeholder="${typeSomething}" />
						<%-- <form:errors path="lastName" cssClass="error"></form:errors> --%>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"> <spring:message code="DisplayCategory.lastName" /><span class="star">&#160;*</span> </label>
					<div class="controls">
						<form:input path="lastName" name="lname" id="lname" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="lastName" cssClass="error"></form:errors>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userEmail" /> </label>
					<div class="controls">
						<form:input path="email" name="userEmail" id="userEmail" value=""
							class="text" size="25"
							placeholder="${typeSomething}" />
						<%-- <form:errors path="email" cssClass="error"></form:errors> --%>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userMobileNumber" /> </label>
					<div class="controls">
						<form:input path="mobileNumber" name="userMobile" id="userMobile" value=""
							class="allnum" size="25" 
							placeholder="${typeSomething}" maxlength="10"/>
						<%-- <form:errors path="mobileNumber" cssClass="error"></form:errors> --%>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userName" /><span class="star">&#160;*</span> </label>
					<div class="controls">
						<form:input path="userName" name="username" id="username" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="userName" cssClass="error"></form:errors>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userPassword" /><span class="star">&#160;*</span> </label>
					<div class="controls">
						
						<%-- <form:password path="password" name="password" id="password" 
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="password" cssClass="error"></form:errors> --%>

						<div class="controls">
							<span id="popovermeter"> <form:password
									path="password" value="" class="text" size="25"
									required="required" placeholder="${typeSomething}"
									id="passwordStrength" /> <form:errors path="password"
									cssClass="error" />
						</div>

					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userConfirmPassword" /><span class="star">&#160;*</span> </label>
					<div class="controls">
						<input type="password" name="confirmpassword" id="confirmpassword" class="text" size="25"/>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userPhoto" /></label>
					<div class="controls">
					<input class="span4" type="file" name="file" id="file"/>
					</div>
				</div>
				
				<!-- For Save button -->
				<div class="control-group">
					<div class="controls">
						<button type="submit" class="btn btn-blue" id="btnSuccess">
							 <spring:message code="addUser.saveProceed" /> 
						</button>
					</div>
				</div>
			</form:form>
		</div>
	</fieldset>
	
		<div id="data-content" style="display: none">
		<div class="span2">
			<div class="progress progress-striped active">
				<div id="progressDIV"></div>
			</div>
		</div>
		<div class="span1">
			<label for="passwordStrength" class="help-inline passwordStrongLabel"
				id="passwordStrengthLabel"> </label>
		</div>
	</div>
	<script type="text/javascript">
		$(document).ready(function(){	
			
		$("#btnSuccess").click(function(){	
			var pass = $('#passwordStrength').val();
			var confirmPass = $('#confirmpassword').val();
			var semail = $('#userEmail').val();
			
			 if($('#userMobile').val().length >0 && $('#userMobile').val().length < 10)
			{
				alert('<spring:message code="DisplayCategory.invalidMobileNumberAlert" />');
				return false;
			} 
			 
			var first = $("#passwordStrength").val();
			var regex1 = RegExp('/^[a-zA-Z0-9!@#$]+$/');
			if(first.length<8){
				alert('<spring:message code="addUser.passLength" />');
				 return false;
			}	
			if(/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$])(?!.*\s).{8,16}$/.test(first) == false ) {
			    alert('<spring:message code="addUser.enterValidPass" />');
			    return false;
			} 
			 
			if (first == "" || first == null) {
				alert('<spring:message code="appManagerLogin.enterPassword" />');
				return false;
			}
			
			
			if(pass != confirmPass)
			{
			   alert('<spring:message code="DisplayCategory.pwdMatchAlert" />');
			   return false; 
			}
			
			var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			if(semail != ""){
			if (filter.test(semail)) {
				    }
			else {
					 alert('<spring:message code="DisplayCategory.invalidEmailAlert" />');
					 return false;
				  } 
	
			}});
		
		
			$('#passwordStrength').bind("cut copy paste", function(e) {
				
				e.preventDefault();
				return false;
			});
			
			
			$('#popovermeter').popover({
				html : true,
				placement : 'right',
				trigger : '',
				selector : true,
				title : 'Password Strength',
				content : function() {
					return $('#data-content').html();
				}
			});
			
			$("#passwordStrength").focusout(function() {
				$('#popovermeter').popover('hide');
			});
			
			$("#passwordStrength").focusin(checkstrength);
			$("#passwordStrength").keyup(checkstrength);
			$("#passwordStrength").focusout(function(){return $("#passwordStrengthLabel").text("")});
		
			function checkstrength(){
				var b=0;password=$("#passwordStrength").val();
				$("#passwordStrength").removeClass();
				$("#passwordStrengthLabel").removeClass();
				$("#progressDIV").removeClass();
				if(1>password.length) return;
				$('#popovermeter').popover('show');
				if(6>password.length){
						$("#passwordStrength").removeClass().addClass("passwordWeak");
						$("#passwordStrengthLabel").text("Weak");
						$("#passwordStrengthLabel").removeClass().addClass("passwordWeakLabel");
						$("#progressDIV").removeClass().addClass("bar bar-danger progress-striped");
						$("#progressDIV").width("25%");
				}
				if(7<password.length) b+=1;
				// If password contains both lower and uppercase characters, increase strength value.
				if (/([a-z])/.test(password)) b += 1;
				// If it has numbers, increase strength value.
				if (/([0-9])/.test(password)) b += 1
				// If it has one special character, increase strength value.
				if (/([!,@,#,$])/.test(password)) b += 1
				// If it has one uppercase letter, increase strength value.
				if (/(?=.*[A-Z])/.test(password)) b += 1;
				if(b<=3){
					$("#passwordStrength").removeClass().addClass("passwordWeak");
					$("#passwordStrengthLabel").text("Weak");
					$("#passwordStrengthLabel").removeClass().addClass("passwordWeakLabel");
					$("#progressDIV").removeClass().addClass("bar bar-danger progress-striped");
					$("#progressDIV").width("25%");
				}
				else if(b<=4){
					$("#passwordStrength").removeClass().addClass("passwordMedium");
					$("#passwordStrengthLabel").text("Medium");
					$("#passwordStrengthLabel").removeClass().addClass("passwordMediumLabel");
					$("#progressDIV").removeClass().addClass("bar bar-warning progress-striped");
					$("#progressDIV").width("60%");
				}
				else {
	 				$("#passwordStrength").removeClass().addClass("passwordStrong");
					$("#passwordStrengthLabel").text("Strong");
					$("#progressDIV").removeClass().addClass("bar bar-success progress-striped");
					$("#progressDIV").width("100%");
					$("#passwordStrengthLabel").removeClass().addClass("passwordStrongLabel");
				}			
			}
			
		});
		
	</script>
</body>
</html>
