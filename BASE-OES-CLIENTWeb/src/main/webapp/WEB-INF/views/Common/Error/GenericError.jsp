<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page isErrorPage="true" import="java.io.*"%>
<html>
<head>
</head>
<body>
		<div id="msgDiv">
			
			<form:form id="loginform">
				<div>
					<div class="intro">
					</div>
					<div class="login-form">
						<div class="holder">
							<legend id="lblMessage">
							</legend>
							<p style="text-align: center;">
								<b>${errorMsg}</b><br>
							</p>
							
							<p style="text-align: center;">
								<b><spring:message code="global.contactadmin" /></b>
							</p>
							
						</div>
					</div>
				</div>
			</form:form>
			
			</div>
		
		
		<div id="divBackToPrtnr" align="center">
			<br>
			<c:if
				test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and sessionScope.user.object.rUrl !=null}">
				<a class="btn btn-purple lnkbackpbtn btn-small"
					href="<c:url value="/gateway/backtopartner"></c:url>"><spring:message
						code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
			</c:if>
		</div>
		<br>
		
		<p class="version" style="text-align: center;">
			<b> <c:if test="${webVersion !=null}">
				<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
			</c:if>
				
			</b>
			
		</p>
		
	
</body>
</html>