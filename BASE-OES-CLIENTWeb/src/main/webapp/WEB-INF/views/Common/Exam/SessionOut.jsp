<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="Exam.Title" /></title>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script type="text/javascript">
$(document).ready(function(){
	if(!$('#isSessionOut').val())
	{
		window.parent.location.href = "../commonExam/sessionOut";
	}
	
    $("#clkHere").click(function(e) {
    	e.preventDefault();
		if (window.opener && !window.opener.closed) {
			window.opener.location.href = $(this).attr('href');
			window.close();
		} else {
			window.location.href = $(this).attr('href');
		}
	});
});
</script>
</head>
<body>
<spring:message code="Exam.SessionExpired" />
<br/>
<spring:message code="Exam.Usersessiontimedout" />
<a href="../login/eventSelection?changeLocale" id="clkHere"><spring:message code="Exam.LoginAgain" /></a>
<c:if test="${isSessionOut != null}">
<input type="hidden" id="isSessionOut" value="${isSessionOut}"/>
</c:if>
</body>
</html>