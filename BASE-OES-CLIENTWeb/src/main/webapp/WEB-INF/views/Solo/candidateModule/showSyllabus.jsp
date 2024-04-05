<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<%-- <link href="<c:url value='/resources/style/template.css'></c:url>" rel="stylesheet"> --%>
<spring:theme code="curdetailtheme" var="curdetailtheme"/>
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<style type="text/css">
body {
	margin: 0;
	font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
	font-size: 14px;
	line-height: 20px;
	color: #333333;
	background-color: #ffffff;
}
</style>
</head>
<body>
	<c:choose>
		<c:when test="${not empty paperWiseSyllabus.paper.name}">
			<input type="hidden" value="${paperWiseSyllabus.paper.name}" id="syllabusHeaderPart"/>
			
				<table class="table table-bordered">


					<c:choose>
						<c:when test="${paperWiseSyllabus.paper.isSectionRequired==true}">
							<c:forEach var="section" varStatus="sectionCnt" items="${paperWiseSyllabus.sections}">
								<tr style="background-color: #f9f9f9;">
									<td colspan="2"><b>${section.sequenceNo }.&nbsp;&nbsp;${section.sectionName }</b></td>
								</tr>
								<tr>
									<td style="border-right-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<td style="border-left-color: white;" class="sectionItemBanks"><c:forEach var="itemBankAssoc" varStatus="iBankCnt" items="${paperWiseSyllabus.sectionItemBanks}">
											<c:if test="${itemBankAssoc.fkSectionID==section.sectionID}">
							   				${itemBankAssoc.itemBank.name}&nbsp;&nbsp;<span style="padding: 0 5px; color: #ccc" class="seperatorBar">|</span>&nbsp;&nbsp;
							   				</c:if>
										</c:forEach></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td><c:forEach var="itemBankAssoc" varStatus="iBankCnt" items="${paperWiseSyllabus.sectionItemBanks}">
							   				${itemBankAssoc.itemBank.name}&nbsp;&nbsp;
							   				<c:if test="${iBankCnt.index < fn:length(paperWiseSyllabus.sectionItemBanks)-1}">
							   					<span style="padding: 0 5px; color: #ccc">|</span>&nbsp;&nbsp;
							   				</c:if>
							   				
										</c:forEach></td>
							</tr>
						</c:otherwise>
					</c:choose>


				</table>
		
		</c:when>
		<c:otherwise>
		 <spring:message code="homepage.nosyllabusavailable" />
        </c:otherwise>
	</c:choose>

<script type="text/javascript">
$(document).ready(function() {
	//modal header
	$("#syllabusHeaderPart",window.parent.document).text("").text($("#syllabusHeaderPart").val());
	
	//remove last seperator bar
	$(".table td.sectionItemBanks span.seperatorBar:last-child").remove();
	
});

</script>	

</body>
</html>