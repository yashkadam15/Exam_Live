<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<spring:theme code="curdetailtheme" var="curdetailtheme" />
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css" />
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
</head>
<body style="background-color: white;">
<span style="padding-left: 6px;font-weight: bold;"><spring:message code="Exam.AttemptedQuestions" /> <span></span> <spring:message code="questionByquestion.outof" /> <span></span></span>
<br>
<br>
	<form:form class="form-horizontal" id="pswform" method="post" autocomplete="off" action="../endexam/verify" style="margin: 0px">

  <c:choose>
        <c:when test="${verifyStatus == 1}">
              <div class="alert alert-success">
						<div>
							<p>	Authentication completed successfully  </p>
						</div>
			  </div>
			  <br> <br> <br>
        </c:when>
        <c:otherwise> 
	         <c:if test="${sessionScope.exampapersetting.candidatePwdtoEnd==true}">
	            <input id="height1" value="1" type="hidden" />
	            <input id="soloRnum" name="soloRnum" value="${soloRnum }" type="hidden" />
				<ul class="inline">
					<li><spring:message code="Exam.entercandidatepassword" /></li>
					<li>&nbsp;<input type="password" id="cpsw" name="cpsw" value="${cpsw}" autocomplete="off"></li>
				</ul>
				&nbsp;&nbsp;&nbsp;&nbsp;<span id="cerrormsg" style="display: none; color: red;" class="offset2"><spring:message code="Exam.incorrectcandpsw" /></span>
			</c:if>
			<c:if test="${sessionScope.exampapersetting.supervisorPwdEndExam==true }">
			   <input id="height2" value="1" type="hidden" />
				<ul class="inline">
					<li><spring:message code="Exam.entersupervisorpassword" /></li>
					<li><input type="password" id="spsw" name="spsw" value="${spsw}" autocomplete="off"></li>
				</ul>
				&nbsp;&nbsp;&nbsp;&nbsp;<span id="serrormsg" style="display: none; color: red;" class="offset2"><spring:message code="Exam.incorrectsuppsw" /></span>
			</c:if>
        </c:otherwise>
   </c:choose>

		
	</form:form>
	
	<input id="verifyStatus" value="${verifyStatus}" type="hidden" />
	<input id="cpswerror" value="${cpswerror}" type="hidden" />
	<input id="spswerror" value="${spswerror}" type="hidden" />
	

	<script type="text/javascript">
		$(document).ready(function() {
			if ($("#verifyStatus").val() == "1") {
				//trigger click event of parent
				window.parent.$('#submitTestBeforetimesUp').click();
			}

			//error msg
			if ($("#cpswerror").val() == "1") {
				$("#cerrormsg").show();
			}

			//error msg
			if ($("#spswerror").val() == "1") {
				$("#serrormsg").show();
			}
			
			//set Iframe height
			if ($("#height1").val() == "1" && $("#height2").val() == "1") {
				$("#verifypswIframe",window.parent.document).height("120");
			}else if ($("#height1").val() == "1" || $("#height2").val() == "1"){
				$("#verifypswIframe",window.parent.document).height("60");
			}
			
			
		});
	</script>
</body>
</html>