<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="certificate.eligibilitycertslabel"/></title>
<style>
u, ins {
  text-decoration: underline;
  padding-bottom: 2px;
}
.page {
	width: 20cm;
	min-height: 29.7cm;
	padding: 2cm;
	/* margin: 2cm ;  */
	margin-right: 2cm;
	margin-left: 2cm;
	/* border: 1px #D3D3D3 solid; */
	/* border-radius: 5px; */
	background: white;
	/* box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); */
}

@page {
	size: A4;
	margin-top: 14px;
}

@media print {
	.page {
		margin: 0;
		/* border: initial;
		border-radius: initial; 
		width: initial;
		min-height: initial;
		box-shadow: initial;
		background: initial;*/
		page-break-after: always;
	}
}
</style>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script type="text/javascript">

				   window.print();   
		
</script>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
</head>
<body>
	<div class="book">
		<fieldset class="well" style="border: 0px">


			<c:forEach items="${batchCerts}" var="batchCerts">
				<div class="page">
					<div style="border-style: solid; padding: 10px" align="center">
						<table style="text-align: center">
							<tr>
								<td>
										<img src="../resources/images/${logo}" align="center"> <br> 
									

									<P align="center" style="font-size: 16px; padding-top: 20px;" >
										<b><u> <spring:message code="certificates.typingTest" /></u> </b>

									</P>
									
								</td>
							</tr>
							<tr>
								<td style="padding-top: 14px;">
									<P align="center" style="font-size: 14px">
										<b> ${batchCerts.speed}&nbsp; <spring:message code="certificates.wordsperMin" /> </b>
									</P>
									
								</td>
							</tr>

							<tr>
								<td style="padding-top: 14px;">
									<P align="center" style="font-size: 14px">
										<b><u><spring:message code="certificates.attemptCertificate" /> </u></b> 
									</P>
									
								</td>
							</tr>

							<tr>
								<td style="padding-top: 14px;">
									<P align="center" style="font-size: 14px">
										<spring:message code="certificates.certify" /> 
									</P>
									
								</td>
							</tr>

							<tr>
								<td style="padding-top: 14px;">
									<P align="center" style="font-size: 14px">
										<b>${batchCerts.candidateFirstName}&nbsp;${batchCerts.candidateMiddleName}&nbsp;${batchCerts.candidateLastName}</b>
									
									</P>
										
								</td>
							</tr>

							<tr>
								<td style="padding-top: 14px;">
									<P align="center" style="font-size: 14px">
										<spring:message code="certificates.regNumber" /> ${batchCerts.candidateCode} <br />
									</P>
									
								</td>
							</tr>

							<tr>
								<td style="padding-top: 14px;">
									<P align="center" style="font-size: 14px">
										<spring:message code="certificates.hasappearedFor" /> "<b>${batchCerts.candidatePaperName}</b>" <br />
									</P>
									
								</td>
							</tr>

							<tr>
								<td style="padding-top: 14px;">
									<P align="center" style="font-size: 14px">
										on <b>${batchCerts.attemptedDate}</b> at <b>${batchCerts.nameOfExamCenter}</b>
										<spring:message code="certificates.district" /> <b>${batchCerts.district}</b> 
									</P>
									
								</td>
							</tr>

							<tr>
								<td style="padding-top: 14px;">
									<P align="center" style="font-size: 14px">
										<spring:message code="certificates.typingSpeed" /> "<b>${batchCerts.score}</b>"
										<spring:message code="certificates.netWordsPerMin" /> <br />
										
									</P>
									<br />
										<br />
								</td>
							</tr>

							<tr>
							
											<td style="padding-top: 35px;"><p style="float: left;border-top:1px black solid; padding-top: 4px;"><spring:message code="certificates.signofCenterCoordinator" /></p> <p style="float: right;border-top:1px black solid; padding-top: 4px;"> <spring:message code="certificates.sealExamCenter" /></p></td>
										
							</tr>


							<tr>
								<td align="left"><b><spring:message code="certificates.impNote" /></b><br> 
								<p>
								 <spring:message code="certificates.acknowledgement" /><br> 
									 <spring:message code="certificates.certificateNotValid" /> <br></p></td>
							</tr>


						</table>
					</div>
				</div>
			</c:forEach>


		</fieldset>
	</div>
</body>
</html>