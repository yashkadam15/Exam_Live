<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html dir="ltr" lang="en">
<!--<![endif]-->
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="soloLoginPage.Title" /></title>


<!--[if lt IE 10]>
<script src="<c:url value='/resources/js/jquery.placeholder.min.js'></c:url>"></script>
<script>
$(document).ready(function(){
    $('input, textarea').placeholder();
});
</script>
<![endif]-->
</head>
<body>
							
								<div id="progressbar" align="center">
									<legend>
										<spring:message code="soloLoginPage.PleasewaitSystemScanisinprogress" />
									</legend>
									<legend>
										<img src="<c:url value="/resources/images/progressbar.gif"></c:url>" alt="OES">
									</legend>
								</div>

	<script type="text/javascript">
		$(document).ready(function() 
		{
			$.ajax({
				type : "GET",
				url : '../audit/verification',					
				global: false,
				success : function(verificationStatus) 
				{
					if (verificationStatus == "verified") 
					{
						$('#progressbar > legend').hide();
						$('#progressbar').html('<h3><spring:message code="pleaseWait.everythingFine"/></h3>');
					}
					else 
					{
						window.location.href = '../audit/deny/' + verificationStatus;
					}					
				},
				error : function(data)
				{
					console.log("error");
					console.log(data);
					$('#progressbar > legend').hide();
					$('#progressbar').html('<h3><spring:message code="pleaseWait.auditFailed"/></h3>');
				}
			});
		});
	</script>
</body>
</html>