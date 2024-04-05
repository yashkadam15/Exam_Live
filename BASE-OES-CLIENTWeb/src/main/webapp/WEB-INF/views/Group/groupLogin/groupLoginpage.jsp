<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html dir="ltr" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="groupLoginPage.Title"/></title>
</head>

<body>


			<!-- Group Login Form -->
			
			<c:if test="${groupMasterList!=null || collectionId!=null || collectionMasterList!=null}">
				<form:form class="form-horizontal" action="../groupLogin/loginpage" method="POST" id="loginformget">
				<input type="hidden" id="examEventID" name="examEventID" value="${sessionObject.examEvent.examEventID}" /> 
				<input type="hidden" id="loginType" name="loginType" value="${sessionObject.loginType}" /> 
				
<%-- 				<div class="login-type">
				<spring:message code="groupLoginPage.ExamEvent"/> :
				${sessionObject.examEvent.name}
				</div> --%>
				<h3><spring:message code="groupLoginPage.PleaseSelectDevision"/>&nbsp;
				<c:if test="${collectionMasterList!=null}">
				 ${collectionMasterList[0].collectionType}&nbsp;and&nbsp;
				</c:if>
				<spring:message code="groupLoginPage.Group"/>
				</h3>
				<dl class="dl-horizontal">
					<dt>
					<spring:message code="groupLoginPage.ExamEvent"/> :
					</dt>
					<dd>
					${sessionObject.examEvent.name}
					</dd>
				</dl>
				
				<c:if test="${collectionMasterList!=null}">
					<div class="control-group">
								<c:if test="${collectionMasterList!=null && collectionMasterList[0].collectionType=='Batch'}">
								<label id='collectionName' class="control-label" for="inputEmail"><spring:message code="groupLoginPage.Batch" /></label>
								</c:if>
								<c:if test="${collectionMasterList!=null && collectionMasterList[0].collectionType=='Division'}">
								<label id='collectionName' class="control-label" for="inputEmail"><spring:message code="groupLoginPage.Division"/></label>
								</c:if>
								

								<div class="controls">
									<select id="collectionId" name="collectionId">
										<option value="-1">--<spring:message code="groupLoginPage.Select"/>--</option>
										<c:forEach var="collection" items="${collectionMasterList}">
											<option value="${collection.collectionID}">${collection.collectionName}</option>
										</c:forEach>
									</select>
								</div>
					</div>
					</c:if>
					<c:if test="${collectionMasterList==null}">
						<input type="hidden" name="collectionId" id="collectionId" value="${collectionId}"/>
					</c:if>
					<%-- <c:choose>
						<c:when test="${fn:length(groupMasterList)!=0 }"> --%>
							<div class="control-group">
								<label class="control-label" for="inputEmail"><spring:message code="groupLoginPage.PleaseSelectLabSessionGroup"/></label>	
								<div class="controls">
									<select id="groupId" name="groupId">
										<option value="-1">--<spring:message code="groupLoginPage.Select"/>--</option>
										<c:forEach var="group" items="${groupMasterList}">
											<option value="${group.groupID}">${group.groupName}</option>
										</c:forEach>
									</select>
								</div>
							</div>
							<div class="text-center">
								<button class="btn btn-primary" type="submit"><spring:message code="groupLoginPage.Proceed"/></button>
							</div>
							
						<%-- </c:when>
						<c:otherwise>
								<spring:message code="groupLoginPage.NoactiveLabSessionfoundfortoday"/><br><br>
							</c:otherwise>
					</c:choose> --%>

				</form:form>
			</c:if>



			<!-- Group Users Login Form -->
			<c:if test="${groupMasterList==null && collectionId==null && collectionMasterList==null}">

				<form:form modelAttribute="sessionObject" action="../groupLogin/postloginpage" method="POST" id="loginformpost">

					<form:hidden path="examEvent.examEventID" />
					<form:hidden path="examEvent.name" />
					<form:hidden path="loginType" />
					<form:hidden path="groupMaster.groupID" />
					<form:hidden path="groupMaster.groupName" />
					<%-- <form:hidden path="groupMaster.fkExamEventID" /> --%>
					<form:hidden path="collectionID"/>
					<div class="login-type clearfix">
						<span class="btn btn-login-type-med pull-left">
							<i class="icon-osp-large icon-usgroup"></i>
						</span>
						<div class="text">
							<spring:message code="groupLoginPage.GroupLogin"/>
							${sessionObject.groupMaster.groupName}
							<span>
								${sessionObject.examEvent.name}, 
								<c:if test="${collectionMaster.collectionType=='Division'}">
								<spring:message code="groupLoginPage.Division"/> : ${collectionMaster.collectionName}
								</c:if>
								<c:if test="${collectionMaster.collectionType=='Batch'}">
								<spring:message code="groupLoginPage.Batch"/> : ${collectionMaster.collectionName}
								</c:if>
							</span>
						</div>
					</div>

					<c:forEach var="user" items="${sessionObject.venueUser}" varStatus="i">
						<div class="control-group">
							<%-- <c:choose>
								<c:when test="${user != null && fn:length(user.userPhoto) > 0}">
									<span class="btn btn-user btn-${userColors[i.index]}"> <img src="${imgPath}${user.userPhoto}" style="width: 85px; height: 70px;"></span>
								</c:when>
								<c:otherwise>
									<span class="btn btn-user btn-${userColors[i.index]}"> <i class="icon-osp-large icon-us-w"></i>
									</span>
								</c:otherwise>
							</c:choose> --%>
								<span class="btn btn-user btn-${userColors[i.index]}"> <i class="icon-osp-large icon-us-w"></i>
									</span>

							<div class="controls">
								<i class="icon-user"></i> <input value="${user.userName}" readonly/>
							</div>
							<div class="controls">
								<i class="icon-greyer icon-lock"></i>
								<c:choose>
									<c:when test="${sessionObject.venueUser[i.index].object!=null}">
									             <spring:message code="groupLoginPage.LoggedinSuccessfully"/>
									             <form:hidden path="venueUser[${i.index}].object" />
									</c:when>
									<c:otherwise>
										<form:password path="venueUser[${i.index}].password" />
										<c:if test="${errorStatus=='1'}">
											<div style="color: red;"><spring:message code="groupLoginPage.Pleaseentercorrectpassword"/></div>
										</c:if>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<form:hidden path="venueUser[${i.index}].userID" />
						<form:hidden path="venueUser[${i.index}].userName" />
						<form:hidden path="venueUser[${i.index}].fkRoleID" />
						<form:hidden path="venueUser[${i.index}].firstName" />
						<form:hidden path="venueUser[${i.index}].middleName" />
						<form:hidden path="venueUser[${i.index}].lastName" />
						<form:hidden path="venueUser[${i.index}].mkclIdentificationNumber" />
						<form:hidden path="venueUser[${i.index}].userPhoto" />
						<form:hidden path="venueUser[${i.index}].fkExamVenueID" />
						<form:hidden path="venueUser[${i.index}].email" />
						<form:hidden path="venueUser[${i.index}].mobileNumber" />
						<form:hidden path="venueUser[${i.index}].systemFlag" />
						<form:hidden path="venueUser[${i.index}].lastSuccessfullLogin" />
					</c:forEach>


					<div class="controls text-center">
						<button class="btn btn-primary" type="submit"><spring:message code="groupLoginPage.Login"/></button>
					</div>
				</form:form>
			</c:if>

		

			<p class="version" style="text-align: center;">
			<b>
				<a class="pull-left" href="../login/eventSelection"><spring:message code="groupLoginPage.Back"/></a>
				<c:if test="${webVersion !=null}">
					<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
				</c:if>
				<a class="pull-right" href="../adminLogin/loginpage"><spring:message code="EventSelection.WebAdmin"/></a></b>
			</p>

		<script>
	$(document)
			.ready(
					function() {
						
						$('#loginformpost').submit(function(e) {
							var i = 0;
							$("input[type=password]").each(function() {

								if ($(this).val().length == 0) {
									i = 1;
								}
							});
							if (i == 1) {
								alert('<spring:message code="soloLoginPage.PleaseenterPassword"/>');
								return false;
							}
						});

						$('#loginformget').submit(function(e) {
							var errmsg='';
							var flagC=0;
							if ($('#collectionId').val() == '-1') {
								errmsg+='<spring:message code="groupLoginPage.pleaseselect"/>';
								errmsg+=" "+$('#collectionName').text();
								flagC=1;
							}
							if ($('#groupId').val() == -1) {
								errmsg+="\n";
								errmsg+='<spring:message code="groupLoginPage.pleaseselectGroup"/>';
								
								flagC=1;
							}
							
							if(flagC==1)
								{
								alert(errmsg);
								return false;
								}
						});
						//Ajax call for groups
						$('#collectionId').change(function(event) {
							var examEventID = $('#examEventID').val();
							var fkCollectionID = $('#collectionId').val();
							/* var dat = JSON.stringify({
								"fkExamEventID" : examEventID,
								"collectionID" : fkCollectionID
							}); */
							callGroupAjax(examEventID,fkCollectionID);
						}); 
						
						 /* end of displayDivision */
						
					});
	function callGroupAjax(examEventID,fkCollectionID) {
		$.ajax({
			url : "../groupLogin/loadGroups.ajax",
			type : "POST",
			//data : dat,
			data :"fkExamEventID="+examEventID+"&collectionID="+fkCollectionID,
			//contentType : "application/json",
			//dataType : "json",
			success : function(response) {
				if(response.length==0)
					{
					alert('<spring:message code="groupLoginPage.Groupsnotfoundforselected"/> '+$('#collectionName').text());
					}
				displayGroups(response);
			},
			error : function() {
				alert('<spring:message code="groupLoginPage.errorwhileloadingGroup"/>');
			}
		}); /* end of ajax */
	}
	
	function displayGroups(response) {
		$("#groupId").find("option").remove();

		 $("#groupId").append(
				'<option value="-1">--<spring:message code="groupLoginPage.Select"/>--</option>'); 
		 

		$.each(response, function(i, item) {
				$("#groupId").append(
						"<option value='" + item.groupID + "'>"
								+ item.groupName + "</option>");
		});
	}
</script>
    

</body>
</html>