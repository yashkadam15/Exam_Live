<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<head>

<title>Login App Manager</title>
</head>
<body>
<div>
	
	<div class="container">
		<div class="row">
			<!-- <a class="btn btn-primary" data-toggle="modal" href="#myModal" >Login</a> -->
	
	        <div class="modal hide in" id="myModal" aria-hidden="false" style="display: block;top: 15%;border: none;background-color: #e6e3e1;">
	          <div class="modal-header">
	            <!-- <button type="button" class="close" data-dismiss="modal">x</button> -->	         
	            <h3><spring:message code="appManagerLogin.logintoAppManager"></spring:message></h3>
	          </div>
	          <div class="modal-body">
	          
	           <form:form class="form-horizontal" modelAttribute="user" action="../appmanager/login" method="POST" id="loginform">
	               <div class="control-group">
	    				<label class="control-label" for="inputEmail"><i class="icon-greyer icon-user"></i></label>
		                <div class="controls">							
							<spring:message code="incompleteexams.Username" var="usernameMsg"/>
							<input type="text" name="userName" id="userid" placeholder="${fn:escapeXml(usernameMsg)}">
						</div>
					</div>
					
					<div class="control-group">
	    				<label class="control-label" for="inputEmail"><i class="icon-greyer icon-lock"></i></label>
						<div class="controls">							
							<spring:message code="incompleteexams.Password" var="passwordMsg"/>
							<input type="password" name="password" id="pass" placeholder='${fn:escapeXml(passwordMsg)}'>
						</div>
					</div>
					
		              <div class="controls text-center">
		             	 <button class="btn btn-primary" type="submit" id="btnSave"><spring:message code="adminLogin.login"></spring:message></button></p>
		           	  </div>
	            </form:form>
	            
	          </div>	         
	        </div>
		</div>
	</div>

</div>

 <script>
	$(document)
			.ready(
					function() {
						$('#btnSave').click(function() {
							var userid = $("#userid").val().trim();
							var pass = $("#pass").val().trim();
							var msg = "";
							var i = 0;
							if (userid == '') {
								//var m=
								msg += '<spring:message code="appManagerLogin.enterUsername"/>';
								msg +='\n\n';
								i = 1;
							}
							if (pass == '') {
								msg += '<spring:message code="appManagerLogin.enterPassword"/>';
								msg +='\n';
								i = 1;
							}
							if (i == 1) {
								alert(msg);
								return false;
							}
							return true;
						});
					});
</script>
</body>
</html>