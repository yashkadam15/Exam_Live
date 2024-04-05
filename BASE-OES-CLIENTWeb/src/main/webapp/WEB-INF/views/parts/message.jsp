<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page errorPage="../Common/jsperror.jsp" %>

<c:if test="${message=='failure'}">
	<div id="system-message">
		<div class="alert alert-error">
			<a class="close" data-dismiss="alert">×</a>
			<h4 class="alert-heading">
				<%-- <spring:message code="global.error"></spring:message> --%>
			</h4>
			<div>
				<p>	${ messageText}	</p>
			</div>
		</div>
	</div>
</c:if>
<c:if test="${message=='success'}">
	<div id="system-message">
		<div class="alert alert-success">
			<a class="close" data-dismiss="alert">×</a>
			<h4 class="alert-heading">
				<%-- <spring:message code="global.success"></spring:message> --%>
			</h4>
			<div>
				<p>	${ messageText}	</p>
			</div>
		</div>
	</div>
</c:if>
<c:if test="${message=='info'}">
	<div id="system-message">
		<div class="alert alert-info">
			<a class="close" data-dismiss="alert">×</a>
			<h4 class="alert-heading">
			<%-- <c:if test="${errorclass!='notDisplayInfo'}">
				<spring:message code="global.info"></spring:message>
				</c:if> --%>
			</h4>
			<div>
				<p>	${ messageText}	</p>
			</div>
		</div>
	</div>
</c:if>
<c:if test="${message=='warning'}">
	<div id="system-message">
		<div class="alert alert-warning">
			<a class="close" data-dismiss="alert">×</a>
			<h4 class="alert-heading">
				<%-- <spring:message code="global.warning"></spring:message> --%>
			</h4>
			<div>
				<p>	${ messageText}	</p>
			</div>
		</div>
	</div>
</c:if>
<!-- <script type="text/javascript">
	$(document).ready(function(){
 		$('.close').click(function(){
			$('#system-message').css('display','none');
		});
	});
</script>	 -->	
