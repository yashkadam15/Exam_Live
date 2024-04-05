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
<title><spring:message code="adminpasswordchange.title" /></title>
<script type="text/javascript" src="<c:url value='/resources/js/md5_encrypt.js'></c:url>"></script>
</head>

<body>	
		<form:form action="changeAdminPasswordPost" method="POST"
				onsubmit="return validate(this);">
				<br>
				<br>

					<div class="login-type">						
							<span style="font-size: 1.0em;"><spring:message code="adminpasswordchange.title" /></span>&nbsp;<span style="font-style: italic; font-size: 0.6em;"><spring:message code="adminpasswordchange.subtitle" /></span>
						</div>
			
		<br>
			<div class="control-group">
					<div class="control-label">
						<label id="username-lbl" ><spring:message code="adminpasswordchange.alccode" /><span class="star">&#160;*</span>
						</label>
					</div>
					<div class="controls">
					<i class="icon-greyer icon-user"></i>
						<input name="examVenueCode" id="examVenueCode" type="text" />
					</div>
				</div>
				<div class="control-group">
					<div class="control-label">
						<label id="password-lbl">
							<spring:message code="adminpasswordchange.solarpwd" /><span class="star">&#160;*</span>
						</label>
					</div>
					<div class="controls">
						<i class="icon-greyer icon-lock"></i>
						 <input name="password" type="password" id="password" />
					</div>
					
				</div>
				
				<div class="control-group text-center">
					<div class="controls">
						<button id="proceedbtn" type="submit" class="button btn btn-primary active">
							<spring:message code="adminpasswordchange.proceed" /></button>
					</div>
				</div>
				
			</form:form>
			<p class="version">
				<b>
					<c:if test="${webVersion !=null}">
						<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
					</c:if>
					<%-- <a class="pull-right" href="../adminLogin/loginpage"><spring:message code="EventSelection.WebAdmin"/></a> --%> </b>
				</p>
		
	


	<script type="text/javascript">
	function validate(form) {		
				
		if ($('#examVenueCode').val()=='') {
			$('#proceedbtn').text("Proceed");
		    $('#proceedbtn').prop('disabled', false);
			alert('<spring:message code="adminpasswordchange.alcalertMessage" />');
			$("#examVenueCode").focus();			
			return false;
		}

		else if ($('#password').val() =='') {
			$('#proceedbtn').text("Proceed");
		    $('#proceedbtn').prop('disabled', false);
			alert('<spring:message code="adminpasswordchange.pwdalertMessage" />');
			$("#password").focus();			
			return false;
		}
		$('#proceedbtn').text("Please Wait...");
	    $('#proceedbtn').prop('disabled', true);
	    
	    var hashMD5 = hex_md5($("#password").val());
		var salt = ${soloRnum};
		var saltHash = hex_md5(hashMD5 + salt);
		$('#password').val(saltHash);
		//alert(saltHash);
		return true;
	}
	</script>
</body>
</html>
