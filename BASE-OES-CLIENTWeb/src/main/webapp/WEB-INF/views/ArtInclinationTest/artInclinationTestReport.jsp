<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>

<title><spring:message code="artInclination.report"></spring:message></title>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/template.css?v=04042023A'></c:url>" />

<style type="text/css">

.info {
  padding: 8px 35px 8px 14px;
  margin-bottom: 20px;
/*text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5);*/
  background-color: #ffffff ;
  border: 2px solid #0174DF ;
  -webkit-border-radius: 2px;
  -moz-border-radius: 2px;
  border-radius: 2px;
}
.imageSize{
height: 60px;
width: 70px;
}

img.resize {
	height: auto;
	width: 60px;
}

img.resize {
	height: 105px;
	width: auto;
}

.panel {
	padding-bottom: 5px;
	padding-top: 5px;
	padding-left: 10px;
	padding-right: 10px;
	margin-bottom: 10px;
	background-color: white;
	border: 1px solid #DDD;
	border-radius: 13px;
	border-color: #428BCA;
	-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
	box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
}
.panel-primary{
	border-color: #428BCA;
	border: 2px solid #0174DF;
}
.outerPanel{
	margin-left: 5%;
	margin-right: 5%;
	margin-top: 3%; 
	margin-bottom: 10px;
	border: 4px solid #FFB226;
	padding-bottom: 5px;
	padding-top: 5px;
	padding-left: 10px;
	padding-right: 10px;
	background-color: white;
}
@media print {
    html, body {
        height: auto;    
    }
}
</style>

</head>
<body style="background-color: white;font-family:Arial;">
	
<c:choose>
	<c:when test="${empty artInclinationDetails}">
		<div style="text-align: center;margin-top: 5%;">
			<spring:message code="artInclination.noRecord" />
		</div>
	</c:when>
	
	<c:otherwise>
	
			<div style="margin-left: 5%; margin-right: 5%; margin-top: 2%" align="center">
				<a target="_blank" href="http://www.mkcl.org/klic/" class="btn btn-success" style="margin-left: 5%;"  id="crsDetails"><spring:message code="artInclination.courseTrailors"></spring:message></a>
				<a target="_blank"  href="../ArtInclinationTestReport/artInclinationTestPrint?candidateUserName=${candidateUserName}&examEventId=${examEventId}&paperId=${paperId}&attemptNo=${attemptNo}" class="btn btn-success" id="printbtn"><spring:message code="artInclination.print"></spring:message></a>
			</div>
	
			<div class="outerPanel">

				<div
					style="margin-left: 5%; margin-right: 5%;margin-bottom: 15%;">
					<img style="float: left;"
						src="<c:url value="${resourcespath}images/${clientid}_1_MKCL logo English.jpg"></c:url>" />
					<img style="float: right;"
						src="<c:url value="${resourcespath}images/${clientid}_2_Klic courses logo.jpg"></c:url>" />
				</div>

			<br>
		<div style="margin-left: 5%; margin-right: 5%;">
			
				<div>
						<label style="font-size: 12pt;text-align:center;text-decoration: underline;"><b>"<spring:message code="artInclination.title" />"</b></label>
				</div>

				<br />

				<div class="panel panel-primary">
					<%-- <label style="font-size: 12pt;text-align:center;"><b><spring:message code="artInclination.test"></spring:message></b></label> --%>
				
					<table style="width: 100%; text-align: center;font-size: 11pt;">

						<tr>
						
						<c:forEach items="${artInclinationDetails}" var="artObj" varStatus="st">
							<c:if test="${st.index==1}">
									
								<td style="vertical-align: top;">
							
							 <jsp:useBean id="now" class="java.util.Date"></jsp:useBean>
								<fmt:formatDate value="${now}" pattern="dd/MM/yyyy" var="currentDateValue" /> 
									<table>
									<tr>
										<td style="text-align: left;"><spring:message code="artInclination.studentName"></spring:message></td>
										<td>:&nbsp;</td>
										<td style="text-align: left;">${artObj.candidateFirstName}&nbsp;${artObj.candidateLastName}</td>
									</tr>
									
									<tr>
										<td style="text-align: left;"><spring:message code="artInclination.candidateCode"></spring:message></td>
										<td>:&nbsp;</td>
										<td style="text-align: left;">${artObj.candidateCode}</td>
									</tr>
									
									<tr>
										<td style="text-align: left;"><spring:message code="artInclination.attemptDate"></spring:message></td>
										<td>:&nbsp;</td>
										<td style="text-align: left;"><fmt:formatDate value="${artObj.attemptDate}" pattern="dd/MM/yyyy"/></td>
									</tr>
									<tr>
										<td style="text-align: left;"><spring:message code="artInclination.centerCode"></spring:message></td>
										<td>:&nbsp;</td>
										<td style="text-align: left;">${artObj.examVenueCode}</td>
									</tr>
									<tr>
										<td style="text-align: left;"><spring:message code="artInclination.centerName"></spring:message></td>
										<td>:&nbsp;</td>
										<td style="text-align: left;">${artObj.examVenueName}</td>
									</tr>
								</table>
									
							</td>
						
							<td><c:choose>
									<c:when
										test="${not empty artObj.candidatePhoto and fn:length(artObj.candidatePhoto) > 0}">
											
											<c:choose>
												<c:when test="${fn:startsWith(artObj.candidatePhoto, 'http://')}">
													<img class="resize" style="float: right;" src="<c:url value="${artObj.candidatePhoto}"></c:url>" />
												</c:when>
												<c:otherwise>
													<img class="resize" style="float: right;" src="<c:url value="${imgPath}${artObj.candidatePhoto}"></c:url>" />	
												</c:otherwise>
											</c:choose>
											
									</c:when>
									<c:otherwise>
											<img class="resize" style="float: right;"
												src="${imgPath}defaultCandidate.jpg" alt="no Image" />
										
									</c:otherwise>
								</c:choose>
							</td>		
							</c:if>
						</c:forEach>
						</tr>
					</table>

				</div>
			
			<br/>
			<label style="font-size: 11pt;text-align:center;">
				<b><spring:message code="artInclination.searchReport"></spring:message></b>
			</label>
			
			<spring:message code="artInclination.howYouAre"></spring:message>

				<br /> 
				  <label style="font-size:13pt;font-style:italic;color:#40B240;">
				  	<c:forEach items="${artInclinationDetails}" var="obj" varStatus="loop">
				  		 ${obj.indicatorDescription}
				  		<br />
				  		<br />
				  	</c:forEach>
				  </label>
				<br/>
				
				<label style="font-size:11pt;">
					 <spring:message code="artInclination.pursueCourses"></spring:message>
				 </label>
				<div class="panel panel-primary" style="font-size:13pt;">
					<c:forEach items="${artInclinationDetails}" var="obj" varStatus="loop">
				  		${loop.index+1}. ${obj.courseName}
				  		<br />
				  	</c:forEach>
				</div>

			<br>
			<p style="font-size: 9.5px; line-height: 1;"><b><spring:message code="artInclination.disclaimer"></spring:message></b><spring:message code="artInclination.disclaimerText"></spring:message></p>
			
			</div>
			
			</div> <!-- Outer div with orange color -->
			
			<div style="margin-right: 5%;" align="center">
				<a target="_blank"  href="http://www.mkcl.org/klic/" class="btn btn-success" style="margin-left: 5%;" id="crsDetails"><spring:message code="artInclination.courseTrailors"></spring:message></a>
				<a target="_blank"  href="../ArtInclinationTestReport/artInclinationTestPrint?candidateUserName=${candidateUserName}&examEventId=${examEventId}&paperId=${paperId}&attemptNo=${attemptNo}" class="btn btn-success" id="printbtn"><spring:message code="artInclination.print"></spring:message></a>
			</div>
			
	<br>
	</c:otherwise>
</c:choose>
	
	</body>
</html>

