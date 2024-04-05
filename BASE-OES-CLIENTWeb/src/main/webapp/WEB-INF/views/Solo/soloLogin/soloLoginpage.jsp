<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html dir="ltr" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="soloLoginPage.Title"/></title>
	<spring:theme code="captchatheme" var="captchatheme" />
	<link rel="stylesheet" href="<c:url value='${captchatheme}'></c:url>" type="text/css" />
	<script src="<c:url value='/resources/js/md5_encrypt.js'></c:url>"></script>
</head>

<body>
<c:choose>
	<c:when test="${noEvent != null }">
		<h2 style="text-align: center;color:#ec3a0f;">${noEvent}</h2>
	</c:when>
	<c:otherwise>
			<c:choose>
				<c:when test="${secureBrowserCompatible eq false}">
					
						<h2 style="text-align: center;color:#ec3a0f;">${eventName}</h2>
						<div>
							<!-- <div class="intro">
								 <img alt="Introduction" src="../resources/images/login-img.jpg">
							</div> -->
							<div class="login-form">
								<div class="holder">
									<p style="text-align: center;">
										<b><spring:message code="audit.accessrestricted" /></b><br>
									</p>
									<%-- <h3>Your are currently using browser <b style="text-decoration:underline;">${browser} ${version}</b></h3> --%>
									 <spring:message code="audit.secureinstall.2" /><b style="text-decoration: underline;">  <spring:message code="audit.secureinstall.3" /> </b>   <spring:message code="audit.secureinstall.4" /> 
									<br><br> 
									<spring:message code="audit.secureinstall.1" /> <br> <br>
									
								</div>
							</div>
						</div>
						
				</c:when>
				<c:otherwise>
					<form:form modelAttribute="user" action="../soloLogin/loginpage" method="POST" id="loginform">
						<h2 style="text-align: center;color:#ec3a0f;">${eventName}</h2>
						<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}" />
						<input type="hidden" id="loginType" name="loginType" value="${loginType}" />
						<div class="login-type">
							<span class="btn btn-login-type-small"><i class="icon-osp-large icon-us"></i></span><spring:message code="soloLoginPage.SingleUserLogin"/>					
						</div>
						<div class="controls">
							<i class="icon-greyer icon-user"></i>
							<spring:message code="incompleteexams.Username" var="usernameMsg"/>
							<c:choose>
								<c:when test="${sessionScope.u!=null}">
									<form:input path="userName" id="userid" value="${sessionScope.u}" readonly="true"/>
								</c:when>
								<c:otherwise>
									<form:input path="userName" id="userid" placeholder="${usernameMsg}" autocomplete="off" />
								</c:otherwise>
							</c:choose>							
						</div>
				
					
						
						
						<div class="controls">
							<div class="col-sm-6 input-group">
								<i class="icon-greyer icon-lock"></i>
								<spring:message code="incompleteexams.Password"
									var="passwordMsg" />
								<form:password path="password" id="passwordStrength" placeholder='${passwordMsg}' />

								
							</div>
						</div>

						<div class="catcha">
							<input type="text" name="captcha" id="UserCaptchaCode" class="CaptchaTxtField" placeholder='Enter Captcha - Case Sensitive' autocomplete="off">
							<p><span id="WrongCaptchaError" class="error"></span></p>
							<div class='CaptchaWrap'>
								<div id="CaptchaImageCode" class="CaptchaTxtField">
									<img alt="captcha" src="../captcha/getCaptcha">
								</div>
								<div>
									<button type="button" class="ReloadBtn"	onclick='callGenerateCaptcha();'></button>
								</div>
							</div>
						</div>

						<div class="text-center">
							<button class="btn btn-primary" type="submit" id="btnSave"><spring:message code="soloLoginPage.Login"/></button>
						</div>
					</form:form>
				</c:otherwise>
			</c:choose>
			
		</c:otherwise>
	</c:choose>
	

			<p class="version" style="text-align: center;">
			<b>
				<c:if test="${hideBack == null}">
				<a class="pull-left" href="../login/eventSelection"><spring:message code="soloLoginPage.Back"/></a>
				</c:if>
				<c:if test="${webVersion !=null}">
					<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
				</c:if>
				<%-- <a class="pull-right" href="../adminLogin/loginpage"><spring:message code="EventSelection.WebAdmin"/></a></b>					 --%>
			</p>
			

    
    
    <script>
	$(document).ready(function(){
						

		$('#btnSave').click(function() {
			var userid = $("#userid").val();
			var pass = $("#passwordStrength").val();
			var msg = "";
			var i = 0;
			if (userid == '') {
				msg += '<spring:message code="soloLoginPage.PleaseenterUsername"/>';
				msg +='\n';
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
			
			var hashMD5 = hex_md5($("#passwordStrength").val());
			var salt = ${soloRnum};
			var saltHash = hex_md5(hashMD5 + salt);
			$('#passwordStrength').val(saltHash);
			
			return true;
		});
		
		
		var dateTimeValues = '${todayDate}'.split(" ");
		if(dateTimeValues.length > 0)
		{
			$('#dtSeprator').show();}
			var monthName = dateTimeValues[1];
			var todayDate = dateTimeValues[2];
			var timeZone = dateTimeValues[4];
			var year = dateTimeValues[5];
			var time = dateTimeValues[3].split(":");
			var hr = parseInt(time[0]);
			var min = parseInt(time[1]);
			var sec = parseInt(time[2]);
			setTimeout(timer, 1);
			function timer() {
				sec++;
				if (sec == 60) {
					sec = 1;
					min++;
					if (min == 60) {
						min = 0;
						hr++;
					}
				}
				var sec1 = ((sec < 10 ? "0" : "") + sec);
				var hr1 = ((hr < 10 ? "0" : "") + hr);
				var min1 = ((min < 10 ? "0" : "") + min);

				$("#Date").text(
					"Server Time: " + hr1 + ":" + min1 + ":" + sec1 + " "+ timeZone +" - " + todayDate
								+ " " + monthName + ", " + year);
			}

			setInterval(timer, 1000);
			
			setInterval(callGenerateCaptcha, 270000);
		
	});

	function callGenerateCaptcha()
	{
		$('#CaptchaImageCode > img').attr('src', '../captcha/getCaptcha?' + new Date().getTime());
	}
</script>
</body>
</html>