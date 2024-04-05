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
.noborder {
	border: 0px;
}

.page {
	width: 20cm;
	min-height: 29.7cm;
	padding: 2cm;
	margin: 2cm;
	margin-right: 2cm;
	margin-left: 2cm;
	/* border: 1px #D3D3D3 solid; */
	/* border-radius: 5px; */
	background: white;
	/* box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); */
}

@page {
	size: A4;
	margin-top: 10px;
}

@media print {
	.page {
		margin: 0;
		border: initial;
		border-radius: initial;
		width: initial;
		min-height: initial;
		box-shadow: initial;
		background: initial;
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
						<table>
							<tr>
								<td>
									<p style="float: left;">
										<img src="../resources/images/hkclLogo.jpg">
									</p>
									<p style="float: right; padding-top: 25px;">
										<img src="../resources/images/HSCITLogo.jpg">
									</p>
								</td>
							</tr>

							<tr>
								<td>
									<P align="center" style="font-size: 20px; padding-bottom: 4px;">
										<b><spring:message code="certificates.haryanaState" />
										</b>

									</P>
								</td>
							</tr>
							<tr>
								<td style="padding-top: 20px;">
									<P align="center" style="font-size: 17px; color: blue;">
										<b><spring:message code="certificates.appearingCertificate" /></b>
									</P>
								</td>
							</tr>


							<tr>
								<td style="padding-top: 15px;">
									<P align="center" style="font-size: 13px"><spring:message code="certificates.certify" /></P>
								</td>
							</tr>

							<tr>
								<td style="padding-top: 10px;">
									<P align="center" style="font-size: 13px">
										<b>${batchCerts.candidateFirstName}&nbsp;${batchCerts.candidateMiddleName}&nbsp;${batchCerts.candidateLastName}</b>

									</P>
								</td>
							</tr>


							<tr>
								<td style="padding-top: 10px;">
									<P align="center" style="font-size: 13px">
										<spring:message code="certificates.learnerCode" /> <b>${batchCerts.candidateCode}</b>
									</P>
								</td>
							</tr>

							<tr>
								<td style="padding-top: 10px;">
									<P align="center" style="font-size: 13px">
										<spring:message code="certificates.hasappearedFor" /> <b><spring:message code="certificates.appearedFor" /> </b>
									</P>
								</td>
							</tr>

							<tr>
								<td style="padding-top: 10px;">
									<P align="center" style="font-size: 13px">on
										${batchCerts.attemptedDate}</P>
								</td>
							</tr>
							<tr>
								<td style="padding-left: 10px; padding-top: 10px;">
									<p style="font-style: italic; text-align: left; font-size: 13px;"><spring:message code="certificates.marksObtainedFollow" /> </p>
								</td>
							</tr>
							<tr>
								<td>


									<table border="1px solid black;" align="center">

										<tr style="background-color: grey;">
											<td><spring:message code="certificates.section" /> </td>
											<td><spring:message code="certificates.marksObtained" /> </td>
											<td><spring:message code="certificates.maxMarks" /> </td>
											<td><spring:message code="certificates.result" /> </td>
										</tr>

										<tr>
											<td><spring:message code="certificates.internalEvaluation" /></td>
											<td><spring:message code="certificates.finalCertificate" /></td>
											<td>50</td>
											<td><spring:message code="certificates.notYetAvailable" /></td>
										</tr>

										<tr>
											<td><spring:message code="certificates.finalExam" /></td>
											<td>${batchCerts.score }</td>
											<td>50</td>
											<td>
												<%-- ${batchCerts.resultStatus} --%>
											</td>
										</tr>

										<tr style="background-color: grey;">
											<td><spring:message code="certificates.totalMarks" /></td>
											<td><spring:message code="certificates.notYetAvailable" /></td>
											<td>100</td>
											<td><spring:message code="certificates.notYetAvailable" /></td>
										</tr>
									</table>

								</td>
							</tr>

							<tr>
								<td style="padding-top: 10px; font-size: 12px;">
									<ul style="padding-left: 0px;">
										<spring:message code="certificates.criteriaForPassingHS-CIT" />
										<div style="padding-left: 25px;">
										<li><spring:message code="certificates.individualPassing" /></li>
										<li><spring:message code="certificates.passingCriteria" /></li>
										<li><spring:message code="certificates.onlyPassCandidates" /></li>
									</div>
									</ul>
								</td>
							</tr>




							<tr>

								<td style="padding-top: 25px;"><p
										style="float: left; border-top: 2px black solid; padding-top: 4px;"><spring:message code="certificates.signatureExamCoordinator" /></p>
									<p
										style="float: right; border-top: 2px black solid; padding-top: 4px;">
										<spring:message code="certificates.seal" /></p></td>

							</tr>


							<tr>
								<td align="left" style="font-size: 9px;"><b><spring:message code="certificates.impNote" /></b>
									<p >
										<spring:message code="certificates.acknowledgementCertificate" />
										</p>
										<p style="font-size: 10px;"> <spring:message code="certificates.certificateNotValid" />
									</p></td>
							</tr>


						</table>
					</div>
				</div>
			</c:forEach>


		</fieldset>
	</div>
</body>
</html>