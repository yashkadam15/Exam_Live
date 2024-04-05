<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>

<title><spring:message code="viewtestscore.title" /></title>

<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">
		<div id="tabbable" class="holder">
				 <c:if test="${showResultType=='No'}">
					<br><br><br>
					<div class="alert alert-success">${resultText}</div>
				</</c:if>
		</div>

	</fieldset>

</body>
</html>