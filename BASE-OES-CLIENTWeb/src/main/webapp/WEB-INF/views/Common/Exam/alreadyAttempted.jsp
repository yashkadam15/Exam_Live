<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script type="text/javascript">
$(document).ready(function(){	
	if (window.opener && !window.opener.closed) {
		window.opener.location.href = $("#loginType").val();
		window.close();
	} else {
		window.parent.location.href = $("#loginType").val();
	}
});
</script>
<title><spring:message code="Exam.Title" /></title>

<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">
		<div class="holder">		
			Redirecting...
			<c:choose>
			<c:when	test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}">
				<input type="hidden" value="../gateway/backtopartner" id="loginType"/>
			</c:when>
				<c:when test="${sessionScope.user.loginType == 'Group'}">
					<input type="hidden" value="../groupCandidatesModule/grouphomepage?messageId=91" id="loginType"/>					
				</c:when>
				<c:otherwise>
					<c:if test="${sessionScope.user.loginType == 'Solo'}">
					<input type="hidden" value="../candidateModule/homepage?messageId=91" id="loginType"/>					
					</c:if>
				</c:otherwise>
			</c:choose>
		</div>
	</fieldset>

</body>
</html>