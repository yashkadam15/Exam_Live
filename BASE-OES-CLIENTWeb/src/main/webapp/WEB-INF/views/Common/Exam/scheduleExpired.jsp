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
	
  /*   $("#dashLnk").click(function(e) {
    	e.preventDefault();
		if (window.opener && !window.opener.closed) {
			window.opener.location.href = $(this).attr('href');
			window.close();
		} else {
			window.location.href = $(this).attr('href');
		}
	}); */
	
	//e.preventDefault();
	if (window.opener && !window.opener.closed) {
		window.opener.location.href = $("#dashLnk").attr('href');
		window.close();
	} else {
		window.location.href = $("#dashLnk").attr('href');
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
			<br/>
			<c:choose>
				<c:when test="${loginType == 'Group'}">
					<a href="../groupCandidatesModule/grouphomepage?messageId=92" id="dashLnk"><spring:message code="Exam.GoToDashboard" /></a>
				</c:when>
				<c:otherwise>
					<c:if test="${loginType == 'Solo'}">
					<a href="../candidateModule/homepage?messageId=92" id="dashLnk"><spring:message code="Exam.GoToDashboard" /></a>					
					</c:if>
				</c:otherwise>
			</c:choose>			
		</div>
	</fieldset>

</body>
</html>