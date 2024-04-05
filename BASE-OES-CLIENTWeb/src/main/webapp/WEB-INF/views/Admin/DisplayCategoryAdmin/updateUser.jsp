<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<title></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
.error {
	color: red;
}
</style>
<script type="text/javascript" src="<c:url value='/resources/js/utilities.js'></c:url>"></script>
</head>
<body>

	<div class="well">
		<legend>
			<span><spring:message code="DisplayCategory.updateUser" /></span>
		</legend>
		<div class="holder">

			<form:form modelAttribute="user" action="update"
				method="POST" class="form-horizontal" enctype="multipart/form-data">

				<form:hidden path="userID" name="userID" id="userID" />

				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.firstName" /><span class="star">&#160;*</span></label>
					<div class="controls">
						<form:input path="firstName" name="fname" id="fname" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="firstName" cssClass="error"></form:errors>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.middleName" /></label>
					<div class="controls">
						<form:input path="middleName" name="mname" id="mname" value=""
							class="text" size="25" 
							placeholder="${typeSomething}" />
						<%-- <form:errors path="uname" cssClass="error"></form:errors> --%>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.lastName" /><span class="star">&#160;*</span></label>
					<div class="controls">
						<form:input path="lastName" name="lname" id="lname" value=""
							class="text" size="25" required="required"
							placeholder="${typeSomething}" />
						<form:errors path="lastName" cssClass="error"></form:errors>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userEmail" /></label>
					<div class="controls">
						<form:input path="email" name="email" id="email" value=""
							class="text" size="25"
							placeholder="${typeSomething}" />
						<%-- <form:errors path="email" cssClass="error"></form:errors> --%>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userMobileNumber" /></label>
					<div class="controls">
						<form:input path="mobileNumber" name="mobileNumber" id="mobileNumber" value=""
							class="allnum" size="25" maxlength="10"
							placeholder="${typeSomething}" />
						<%-- <form:errors path="mobileNumber" cssClass="error"></form:errors> --%>
					</div>
				</div>

				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userName" /><span class="star">&#160;*</span></label>
					<div class="controls">
						<form:input path="userName" name="userName" id="userName" value=""
							class="text" size="25"
							placeholder="${typeSomething}" />
						<form:errors path="userName" cssClass="error"></form:errors>
					</div>
				</div>
				
				<div class="control-group">
					<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.userPhoto" /></label>
					<div class="controls">
						<form:input type="file" name="file" id="file" path="" ></form:input>
					</div>
					<%-- ::::::${user.userPhoto } --%>
					<c:choose>
					<c:when test="${user.userPhoto != NULL && user.userPhoto !=''}">
					<div class="controls">
						<img alt='<spring:message code="Exam.NotAvailable" />' src="${relativeFolderPath}" style="width:80px;height:50px;"/>
					</div>
					</c:when>
					<c:otherwise>
						<div class="controls">
						<label id="division-lbl" class="control-label required"
						for="division"><spring:message code="DisplayCategory.imageNotAvailable" /></label>
						</div>
					</c:otherwise>
					</c:choose>
					<form:hidden path="userPhoto" name="userPhoto" id="userPhoto" value="${user.userPhoto}"/>
				</div>
				
				<!-- Button -->
				<div class="control-group">
					<div class="controls">
						<button type="submit" class="btn btn-blue" id="btnSuccess" name="btnSuccess">
							<spring:message code="global.save" />
						</button>
					</div>
				</div>
			</form:form>
		</div>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function(){			
		$("#btnSuccess").click(function(){	
			
			var semail = $('#email').val();
			
			if($('#mobileNumber').val().length >0 && $('#mobileNumber').val().length < 10)
			{
				alert('<spring:message code="DisplayCategory.invalidMobileNumberAlert" />');
				return false;
			} 
						
			var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			if(semail != ""){
			if (filter.test(semail)) {
				    }
			else {
				 alert('<spring:message code="DisplayCategory.invalidEmailAlert" />');
					 return false;
				  } 
	
			}});
			
		});
		
	</script>
</body>
</html>
