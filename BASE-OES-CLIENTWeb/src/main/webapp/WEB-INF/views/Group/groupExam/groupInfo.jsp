<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<!--[if IEMobile 7]><html dir="ltr" lang="en"class="iem7"><![endif]-->
<!--[if IE 7]><html dir="ltr" lang="en" class="ie7"><![endif]-->
<!--[if IE 8]><html dir="ltr" lang="en" class="ie8"><![endif]-->
<!--[if IE 9]><html dir="ltr" lang="en" class="ie9"><![endif]-->
<!--[if (gte IE 9)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!-->
<html dir="ltr" lang="en">
<!--<![endif]-->
<head>
<title><spring:message code="Exam.Title" /></title>
<style type="text/css">
.widget-panel {
	border-radius: 18px;
	display: table;
	padding: 25px;
	height: 150px;
	margin: 15px 0; /* you can change/remove margin */
	width: 170px;
}

.widget {
	display: inline-block;
	width: 300px;
	height: 100px;
}

.widget p {
	
}

div.parent {
	border: solid black 1px;
	display: table;
	padding: 25px;
	width: 100%;
	margin: 15px 0; /* you can change/remove margin */
}

div.text {
	vertical-align: middle;
	display: table-cell;
	text-align: justify;
}

div.parent .img {
	vertical-align: middle;
	display: table-cell;
	padding-right: 5px;
	width: 50px; /* you can change width */
}

div.img img {
	width: 150px;
	height: 110px; /* you can change height */
	vertical-align: middle;
	margin-left: 5px;
	margin-right: 10px;
}

.links {
	width: 790px;
}

.languagearea {
	width: 200px;
}

.picsaction {
	width: 220px;
}

.picholder {
	margin-bottom: 10px;
	padding: 5px 5px;
	border: 1px solid #b5cee9;
	background-color: #e4edf7;
}

.instructionarea {
	height: 350px;
}

.span2 {
	width: 40px;
}

.redText {
	color: red;
}

.exampage .profile-timer .dp {
	width: 50px;
	height: 65px;
	overflow: hidden;
	border: 1px solid #000;
	float: left;
}

img.resize {
	height: auto;
	width: 60px;
}

img.resize {
	height: 95px;
	width: auto;
}

.sizetoImage {
	height: 100px;
	width: 110px;
}

.sizetoMultipleImage {
	height: 60px;
	width: 72px;
}

img.resizeGroup {
	height: 50px;
	width: 40px;
}

img.resizeGroup {
	height: 70px;
	width: 72px;
}
</style>
</head>

<body class="osp exam ">
	

		<!--Body  -->
		<div class="osp-content">
			<div class="container">
				<div class="row">
					<div class="span12 main-content">
						<div >
							<div class="reported cols spaced">


								<c:forEach var="user" items="${usersList}" varStatus="i">
									<div class="osp-user-${userColors[i.index]}" >
										<div class="col1-3 osp-question-for inst" >
											<h3><spring:message code="Exam.userinfo" /> ${i.index+1}</h3>
											<div class="osp-user" >
												<c:choose>
													<c:when test="${not empty user.userPhoto and fn:length(user.userPhoto) > 0}">
														<div class="img">
														<img  src="${imgPath}${user.userPhoto}" onerror="this.src='${imgPath}<spring:message code="instruction.defaultPhoto"/>';">
														</div>
														
													</c:when>
													<c:otherwise>
													<div class="img" >
														<img src="${imgPath}<spring:message code="instruction.defaultPhoto"/>" alt="default">
													</div>
													</c:otherwise>
												</c:choose>
												<p>${user.firstName} ${user.middleName} ${user.lastName}</p>
											    <span class="ex-info">${user.userName}<br><span>${sessionScope.user.groupMaster.groupName}</span></span>
											</div>
										</div>
									</div>
								</c:forEach>

							</div>
						</div>
					</div>
				</div>
			</div>
			<br>
			<div class="controls" align="center">
			<form:form action="instruction" method="post">
			<input type="hidden" value="${examEventID}" name="examEventID">
			<input type="hidden" value="${paperID}" name="paperID">
			<input type="hidden" value="${scheduleEnd}" name="scheduleEnd">
			<button class="btn btn-primary"><spring:message code="global.proceed" /></button>
			<a class="btn btn-primary"  href="../groupCandidatesModule/grouphomepage?changeLocale" id="dashLnk"> &nbsp; <spring:message code="Exam.Back" /> &nbsp;</a>
			</form:form>
			
			</div>

		</div>
	

<script type="text/javascript">
	 $("#dashLnk").click(function(e) {
		e.preventDefault();
		if (window.opener && !window.opener.closed) {
			window.opener.location.href = $(this).attr('href');
			window.close();
		} else {
			window.location.href = $(this).attr('href');
		}
	}); 
	</script>
	
</body>
</html>
