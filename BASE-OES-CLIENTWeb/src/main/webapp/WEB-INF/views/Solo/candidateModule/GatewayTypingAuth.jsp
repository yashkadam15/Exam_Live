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
<title><spring:message code="soloLoginPage.Title" /></title>
</head>
<body>

	<a id="lnkTakeTest" class="lnkTakeTestbtn typingTest" href="${turl}"></a>
	<input type="hidden" id="redirectUrl" name="redirectUrl" value="${turl}">
	<input type="hidden" id="opnTyp" name="opnTyp" value="${opnTyp}">
	<input type="hidden" id="errorMsg" name="opnTyp" value="${errorMsg}">
	
		<div id="msgDiv" style="display: none;">
			
			<form:form id="loginform">
				<div>
					<div class="intro">
						<!--  <img alt="Introduction" src="../resources/images/login-img.jpg"> -->
					</div>
					<div class="login-form">
						<div class="holder">
							<legend id="lblMessage">
								<%-- ${message} --%>
							</legend>
							<p style="text-align: center;">
								<b><spring:message code="audit.accessrestricted" /></b><br>
							</p>
							<%-- <h3>Your are currently using browser <b style="text-decoration:underline;">${browser} ${version}</b></h3> --%>
							<b><spring:message code="audit.secureinstall.2" /> &nbsp; <spring:message code="audit.secureinstall.3" />
							<spring:message code="audit.secureinstall.4" />
							</b><br><br>
							
							<spring:message code="audit.secureinstall.1" /> <br> <br>
							<p style="text-align: center;">
								<b><spring:message code="global.contactadmin" /></b>
							</p>
							
						</div>
					</div>
				</div>
			</form:form>
			
			</div>
			
			<div id="divErrMsgs" style="text-align: center;display: none;">
				<br>
				<b><label id="lblErrMsg"></label></b>
			</div>
			
			<div id="divInfoMsgs" style="text-align: center;display: none;">
				<br>
				<b><label id="lblInfoMsg"></label></b>
			</div>
			<!-- Back To Partner -->
			
			<div id="divBackToPrtnr" style="display: none;" align="center">
				<br>
				<c:if test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and sessionScope.user.object.rUrl !=null}">
					<a class="btn btn-purple lnkbackpbtn btn-small"  href="<c:url value="/gateway/backtopartner"></c:url>"  ><spring:message code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
				</c:if>
			</div>
			<br>
			<p class="version" style="text-align: center;">
				<b>
					<c:if test="${webVersion !=null}">
						<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
					</c:if>
					</b>
				</p>
		
<script type="text/javascript">

$(document).ready(function() {
	var opnTyp=$("#opnTyp").val();
	var url=$("#redirectUrl").val();
	
	// If page refresh or back from typing test
	if (! opnTyp && ! url) {		
		$("#divBackToPrtnr").show();
	}
	if(opnTyp=="1"){		
		if(checkForExamClient()){
			
			window.location.href = $('#lnkTakeTest').attr('href');
		}else{			
			$("#divBackToPrtnr").show();
		}
	}
});

function sendTypingMarkstoPartner(ceid)
{
	
	$("#lblInfoMsg").text('<spring:message code="gatway.typing.transferInfo" />');
	$("#divInfoMsgs").show();
	$("#divBackToPrtnr").hide();
	$.ajax({
		url : "../gateway/sendCandMarksToEra",
		type : "POST",
		data : JSON.stringify({
			candidateExamID : ceid			
		}),
		contentType : "application/json",
		dataType : "json",
		success : function(response) {
			$("#lblInfoMsg").text('<spring:message code="gatway.typing.transferSuccess" />');
			$("#divBackToPrtnr").show();
		},
		error : function(e) {
			$("#divInfoMsgs").hide();
			$("#divBackToPrtnr").show();
		}
	});
}

function checkForExamClient(){
	
	//if paper is typing and browser is Secured
	//then allow for test
	//otherwise prevent for test
	if(navigator.userAgent.search('MOSB') < 0){
		$("#msgDiv").show();		
		return false;
	}
	var errorMsg=$("#errorMsg").val();
	var redirectUrl=$("#redirectUrl").val();	
	if (!redirectUrl) {
		$("#divErrMsgs").show();
		if (errorMsg!==null || errorMsg!=null) {			
			$("#lblErrMsg").html(errorMsg);
		}
		return false;
	}
	
	
	return true;
}
</script>

</body>
</html>