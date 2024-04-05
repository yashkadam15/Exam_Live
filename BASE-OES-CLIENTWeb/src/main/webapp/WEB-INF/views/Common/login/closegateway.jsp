<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script type="text/javascript">
	$(document).ready(function() {
		//e.preventDefault();

		// 19 Dec 2016 : guided access to open mode,while redirecting back to partner.
		if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined"){				
			js.loadDefaultConfig();			
		}
		
		//submit form on onload
		$("form").submit();
		/* if (window.opener && !window.opener.closed) {
			window.opener.location.href = $("#returnUrl").val();
			window.close();
		} else {
			window.location.href = $("#returnUrl").val();
		} */
		
		
	});
</script>
</head>
<body>
	<form:form action="${returnUrl}" method="POST">
		<c:forEach items="${sesObject}" var="obj">
			<input type="hidden" id="${obj.key}" name="${obj.key}" value="${obj.value}" />
		</c:forEach>
	</form:form>
</body>
</html>