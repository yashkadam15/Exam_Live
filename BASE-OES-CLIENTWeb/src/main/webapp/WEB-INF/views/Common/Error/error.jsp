<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isErrorPage="true" import="java.io.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>


<style type="text/css">
.accordion {
	overflow: hidden !important;
}
</style>

<script type="text/javascript">
	$(document).ready(function(){
/* code to collapse Basic details part on page load */
$("#expandall").click(function() {		
	
	$(".accordion-body.collapse.in").css('height','2px');
	
});

$("#collapseall").click(function() {	
	
	$(".accordion-body.collapse").css('height','0px');
	
});
	});
	</script>

</head>
<body>


	<div class="holder">

		<legend>
			<span><spring:message code="global.error.notavailable"/>
		</span></legend>
		
		<p style="font-size: 16px">
		<spring:message code="global.error.sorrymsg"/>
		</p>
		<div class="accordion" id="accordion2">
			<div class="accordion-group">
				<div class="accordion-heading" id="clickDiv">
					<a class="accordion-toggle" data-toggle="collapse"
						data-parent="#accordion2" href="#collapseOne"> <i
						class="icon-plus-sign" id="the-icon-element"></i> <spring:message code="global.error.moreinfo"/>
					</a>
				</div>
				
				<div id="collapseOne" class="accordion-body collapse">
					<div class="accordion-inner">
						<b><spring:message code="global.error.exceptions"/></b><br>
						<font color="red">${exception.message}</font><br />
						<br />
					</div>
				</div>
			</div>
		</div> 
		
		<script type="text/javascript">
			$("#clickDiv").click(
					function() {
						$('#the-icon-element').toggleClass('icon-plus-sign')
								.toggleClass('icon-minus-sign');
					});
		</script>

	<br><c:set var="IPvar" value="${fn:substringAfter(pageContext.request.localAddr,'.' )}" />

					<label style="font-size:12px; ">${fn:substringAfter(IPvar,'.')}</label>
	</div>
</body>
</html>