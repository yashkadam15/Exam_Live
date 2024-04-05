<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>

<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">

		<title><spring:message code="adminLogin.adminLogin"></spring:message></title>
		<spring:theme code="captchatheme" var="captchatheme" />

		<link rel="stylesheet" type="text/css" href="<c:url value='${captchatheme}'></c:url>" />
		<script type="text/javascript" src="<c:url value='/resources/js/md5_encrypt.js'></c:url>"></script>
	</head>

	<body>
		<form:form modelAttribute="user" action="../adminLogin/loginpage" method="POST" id="loginform">
<br>
<br>
				<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}" />
				<input type="hidden" id="loginType" name="loginType" value="${loginType}" />
				<div class="login-type">
					<!-- <span class="btn btn-login-type-small"><i class="icon-osp-large icon-us"></i> </span> --> <spring:message code="adminLogin.adminLogin"></spring:message>
				</div>
				<br>
				<div class="controls">
					<i class="icon-greyer icon-user"></i>
					<spring:message code="incompleteexams.Username" var="usernameMsg"/>
					<form:input path="userName" id="userid" placeholder="${usernameMsg}" autocomplete="off" />
				</div>
				<div class="controls">
					<i class="icon-greyer icon-lock"></i>
					<spring:message code="incompleteexams.Password" var="passwordMsg"/>
					<form:password path="password" id="pass" placeholder='${passwordMsg}' />
				</div>

				<div class="catcha">
					<input type="text" name="captcha" id="UserCaptchaCode" class="CaptchaTxtField"	placeholder='Enter Captcha - Case Sensitive' autocomplete="off">
					<p><span id="WrongCaptchaError" class="error"></span></p>
					<div class='CaptchaWrap'>
						<div id="CaptchaImageCode" class="CaptchaTxtField">
							<img alt="captcha" src="../captcha/getCaptcha">
						</div>
						<div>
							<button type="button" class="ReloadBtn" onclick='callGenerateCaptcha();'></button>
						</div>
					</div>
				</div>

		<div class="controls text-center">
					<button class="btn btn-primary" type="submit" id="btnSave"><spring:message code="adminLogin.login"></spring:message></button>
				</div>
				<!-- Start :02 Feb 2016 :Reena : Exam Venue Forget Password Services for SOLAR Venues -->
				<div class="controls text-center">
					<b><a href="../login/changeAdminPassword">
				<spring:message code="adminpasswordchange.forgotpwd"/>
				</a></b>
				</div>
				<!-- End :02 Feb 2016 :Reena : Exam Venue Forget Password Services for SOLAR Venues -->
			</form:form>


			<p class="version">
			<b>
				<c:if test="${webVersion !=null}">
					<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
				</c:if>
				<a class="pull-right" href="../login/eventSelection"><%-- <spring:message code="adminLogin.back"></spring:message> --%>
				<spring:message code="soloLoginPage.SingleUserLogin"/>
				</a></b>
			</p>
 <script>
	$(document)
			.ready(
					function() {
						$('#btnSave').click(function() {
							var userid = $("#userid").val();
							var pass = $("#pass").val();
							var msg = "";
							var i = 0;
							if (userid == '') {
								//var m=
								msg += '<spring:message code="soloLoginPage.PleaseenterUsername"/>';
								msg +='\n\n';
								i = 1;
							}
							if (pass == '') {
								msg += '<spring:message code="soloLoginPage.PleaseenterPassword"/>';
								msg +='\n';
								i = 1;
							}
							if (i == 1) {
								alert(msg);
								return false;
							}
							
						
							
							var hashMD5 = hex_md5($("#pass").val());
							var salt = ${adminRnum};
							var saltHash = hex_md5(hashMD5 + salt);
							$('#pass').val(saltHash);
							return true;
						});
						
						setInterval(callGenerateCaptcha, 270000);
					});

	function callGenerateCaptcha()
	{
		$('#CaptchaImageCode > img').attr('src', '../captcha/getCaptcha?' + new Date().getTime());
	}
	
</script>
		
</body>
</html>