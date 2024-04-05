<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">


<title></title>

<script type="text/javascript">
$(document).ready(function(){
    $("#frmSubmit").submit();
});
</script> 

</head>
<body class="exampage">
	
		<form:form id="frmSubmit" action="${redirectUrl}" method="POST">	
		
			<c:if test="${ceid != null}">
				<input type="hidden" name="ceid" value="${ceid}" />
			</c:if>
			<c:if test="${dcid != null}">
				<input type="hidden" name="dcid" value="${dcid}" />
			</c:if>
			<c:if test="${se != null}">
				<input type="hidden" name="se" value="${se}" />
			</c:if>
			<c:if test="${b != null}">
				<input type="hidden" name="b" value="${b}" />
			</c:if>
		
		</form:form>
</body>
</html>
