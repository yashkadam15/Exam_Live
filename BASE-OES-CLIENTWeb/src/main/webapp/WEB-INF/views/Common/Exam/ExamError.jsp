<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title><spring:message code="Exam.Error" /></title>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script type="text/javascript">
$(document).ready(function(){
	if($('#loadParent').val())
	{
		window.parent.location.href = "../commonExam/ExamError";
	}
	if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined" && $('#clientId').val()==14){
		js.stopEvidenceCapture();
	}
});
</script>
</head>
<body>
<h3><spring:message code="Exam.Weresorrytherewasaproblemshowingthispage" /></h3>
<br/>
<br/>
<c:if test="${error != null }">
<div>
${error }
</div>
</c:if>
<br/>
<br/>
<c:choose>
<c:when
				test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true and oesPartnerMaster != null and sessionScope.user.object.rUrl !=null}">
				<a href="<c:url value="/gateway/backtopartner"></c:url>" style="color : red;font-weight: 16px; text-align: center;"><spring:message
						code="oesp.backto" />&nbsp;${oesPartnerMaster.partnerName}</a>
			</c:when>
				<c:when test="${sessionScope.user.loginType == 'Group'}">
					<a href="../groupCandidatesModule/grouphomepage?changeLocale" style="color : red;font-weight: 16px; text-align: center;">	<spring:message code="Exam.Gotohome" />	</a>		
				</c:when>
				<c:otherwise>
					<c:if test="${sessionScope.user.loginType == 'Solo'}">
					<a href="../candidateModule/homepage?changeLocale" style="color : red;font-weight: 16px;text-align: center;" ><spring:message code="Exam.Gotohome" />	</a>				
					</c:if>
				</c:otherwise>
			</c:choose>
<c:if test="${loadParent != null}">
<input type="hidden" id="loadParent" value="${loadParent}"/>
</c:if>

<br><c:set var="IPvar" value="${fn:substringAfter(pageContext.request.localAddr,'.' )}" />

					<label style="font-size:12px; ">${fn:substringAfter(IPvar,'.')}</label>
</body>
</html>