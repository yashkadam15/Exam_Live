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

<style type="text/css">
.highlightText {
	color: red;
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

.imgSize{
height: 70px;
width: 70px;
}
</style>
</head>

<body class="osp exam">
	
<input type="hidden" id="eventId" value="${examEvent.examEventID }"/>
		<!--Body  -->
		<div class="osp-content">

			<div class="container">
				<div class="row">
					<div class="span9 main-content">
						<%-- <div style="font-size: 1.286em;">
							<spring:message code="instruction.text" />
						</div> --%>
						<br>
						<!-- Content -->
						<!-- First Page -->
						<div style="padding-right: 20px">
							<div class="content-holder">
								<div class="holder">
									<div class="questions-area">
										<div class="question">
											<b><spring:message code="instruction.firstPageInstrution" /></b>
										</div>
										<br>
										<div class="qanswer" style="overflow: auto; height: 300px">
											<c:if test="${fn:length(instructions.intructionText) != 0}">
                                        ${instructions.intructionText}<br/><br/> <b><spring:message code="instruction.otherImp" /></b> <br/><br/>${instructions.importantInstructions }
                                        </c:if>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- First Page END-->
						<!-- Second Page START-->
						<%-- <div  style="padding-right: 20px">
							<c:if test="${fn:length(instructions.importantInstructions) != 0}">
								<div class="content-holder">
									<div class="holder">
										<div class="questions-area">
											<div class="question" class="instructionarea">
												<b> <spring:message code="instruction.otherImp"></spring:message>

												</b>
											</div>
											<div class="qanswer" style="height: 250px; overflow: auto">${instructions.importantInstructions }<br><br></div>
										</div>
									</div>
								</div>
							</c:if>
						</div> --%>
						<br>
						<!-- Second Page END-->
						<form:form modelAttribute="instructions" action="proceed" method="POST" class="form-horizontal" style="padding: 0;position:relative"   id="readyToBeginForm">
									<div>
										<spring:message code="instruction.language" />
										<select name="language" id="language" class="offset1" >
											<c:choose>
												<c:when test="${fn:length(mediumOfPapersList) == 1}">
													<c:forEach items="${mediumOfPapersList}" var="medium"  >
														<option selected="selected" value="${medium.language.id}" >${medium.language.languageName}</option>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<option value="0">
														<spring:message code="global.select" />
													</option>
													<c:forEach items="${mediumOfPapersList}" var="medium">
														<option value="${medium.language.id}">${medium.language.languageName}</option>
													</c:forEach>
												</c:otherwise>
											</c:choose>
										</select>
									</div>
									<br>
									<div class="redText">
										<spring:message code="instruction.info" />
									</div>

									<div class="redText declm">
										<input type="checkbox" id="disclaimer" /> ${instructions.disclaimerText}
									</div>

									<br>
									<form:button type="submit" class="btn btn-primary" id="proceed">
										&nbsp; <spring:message code="instruction.ready" /> &nbsp;
									</form:button>
									
									<a href="../groupExam/groupInfo?examEventID=${examEventID}&paperID=${paperID}&scheduleEnd=${scheduleEnd}" style="margin-left: 100px" class="btn btn btn-success">&nbsp; <spring:message code="Exam.Back" /> &nbsp;</a>
									
									<c:choose>
										<c:when test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true}">
											<c:choose>
												<c:when test="${sessionScope.user.object.rUrl !=null}">
													<a href="<c:url value="/gateway/backtopartner"></c:url>" id="cancelTest" class="btn btn btn-success"><spring:message code="global.cancel" /></a>
												</c:when>
												<c:otherwise>
													<a href="#" id="cancelTest" class="btn btn btn-success"><spring:message code="global.cancel" /></a>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<a href="../groupCandidatesModule/grouphomepage?changeLocale" id="cancelTest" class="btn btn btn-success"><spring:message code="global.cancel" /></a>
										</c:otherwise>
									</c:choose>

									<input type="hidden" value="${examEventID}" name="examEventID" />
									<input type="hidden" value="${paperID}" name="paperID" />
									<input type="hidden" value="${scheduleEnd}" name="scheduleEnd" />
								
								</form:form>

					</div>
					<br>
					<div class="span3">
						<div class="reported cols spaced"> 
							<c:forEach var="user" items="${usersList}" varStatus="i">
								<div class="osp-user-${userColors[i.index]}">
									<div class="col1-3 osp-question-for insts" style="padding: 2%;width: 34%;">
										<div class="osp-user">
											<c:choose>
												<c:when test="${not empty user.userPhoto and fn:length(user.userPhoto) > 0}">
														<img class="imgSize"  src="${imgPath}${user.userPhoto}" onerror="this.src='${imgPath}<spring:message code="instruction.defaultPhoto"/>';" >
												</c:when>
												<c:otherwise>
														<img class="imgSize" src="${imgPath}<spring:message code="instruction.defaultPhoto"/>" alt="default" >
												</c:otherwise>
											</c:choose>
										</div>
										${user.userName}
									</div>
								</div>
							</c:forEach>
						 </div>
					 </div>
				</div>
				<br>
			</div>
		</div>


    <div id="intrAlertModal" class="modal hide fade in" style="display: none;" >
			<div class="modal-body">
				<span id="alertSpan"></span>
			</div>
			<div class="modal-footer">		
				<button class="btn" data-dismiss="modal" aria-hidden="true"><spring:message code="Exam.modal.OK" /></button>		
			</div>	
	 </div>


<%-- 	<input type="hidden" id="disclaimer" value="${instructions.disclaimerText}" />  --%>
	<script type="text/javascript">
		$(document).ready(function() {
			// script added for exam client; contact amoghs b4 modification
			if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined"){
				js.getEventId($('#eventId').val());
			}
			//amoghs end
			$("#instForm").hide();
			$("#instPrev").hide();

			/* $("#language").val(0); */
			$('input:checkbox').removeAttr('checked');

			$("#firstPage").show();
			$("#secondPage").hide();

			$('.declm p').contents().unwrap();
			$('.prev').click(function(e) {
				e.preventDefault();
				$("#firstPage").show();
				$("#secondPage").hide();
				$("#instForm").hide();
				$("#instPrev").hide();
			});

			$('#cancelTest').click(function(e) {
				e.preventDefault();
				if (window.opener && !window.opener.closed) {
					window.opener.location.href = $(this).attr('href');
					window.close();
				} else {
					window.location.href = $(this).attr('href');
				}
			});
			$('.next').click(function(e) {

				e.preventDefault();
				$("#firstPage").hide();
				$("#secondPage").show();
				$("#instForm").show();
				$("#instPrev").show();
				// For removing next line from disclaimer text
				/* var disclaimerTxt = $('${instructions.disclaimerText }');
				$("#distext").replaceWith(disclaimerTxt.text()); */

			});

			$("#proceed").click(function() {
				if (!$("#disclaimer").is(':checked')) {
					//alert("<spring:message code="instruction.confirmlan" />");
					$("#intrAlertModal").modal({ backdrop: 'static', keyboard: true });
					$("#alertSpan").text("").text("<spring:message code="instruction.confirmlan" />");
					return false;
				}
				if ($("#disclaimer").is(':checked')) {
					if ($("#language").val() == 0) {
						//alert("<spring:message code="instruction.chooselang" />");
						$("#intrAlertModal").modal({ backdrop: 'static', keyboard: true });
						$("#alertSpan").text("").text("<spring:message code="instruction.chooselang" />");
						return false;
					}

				}

			});
			
			//disable button second click
			$("#readyToBeginForm").on('submit', function() {
				$("#proceed").prop('disabled', true);
			});
		});
	</script>
</body>
</html>
