<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<html>
<head>
<title><spring:message code="groupviewActivityCalendar.PageTitle" /></title>
<spring:message code="project.resources" var="resourcespath" />

<style type="text/css">
.accordianColor_next { /*background-color: lavender;*/
	color: #fff;
	background-color: #61a1e3;
}

.accordianColor_Current { /*background-color: burlywood;*/
	background-color: #4da04e;
	color: #fff;
}

.accordianColor_prev { /*background-color: gainsboro;*/
	color: #e0e0e0;
	background-color: #a2a2a2;
}

.accordianColor_user { /*background-color: gainsboro;*/
	color: #338d93;
	background-color: #338d93;
}

.panelDeorator a {
	color: white;
	text-decoration: none !important;
}

.panelDeorator a:hover {
	color: black !important;
}

.error {
	color: red;
}

.answerbox {
	height: 150px; /*Specify Height*/
	width: 150px; /*Specify Width*/
	border: 1px solid black;
	/*Add 1px solid border, use any color you want*/
	background-color: green; /*Add a background color to the box*/
	text-align: center; /*Align the text to the center*/
}

.user-one {
	background-color: #ee5e37;
	-webkit-box-shadow: inset 0 0 0 1px #c83811;
	-moz-box-shadow: inset 0 0 0 1px #c83811;
	box-shadow: inset 0 0 0 1px #c83811;
}

.user-two {
	background-color: #9cd159;
	-webkit-box-shadow: inset 0 0 0 1px #76ad30;
	-moz-box-shadow: inset 0 0 0 1px #76ad30;
	box-shadow: inset 0 0 0 1px #76ad30;
}

.user-three {
	background-color: #65a6ff;
	-webkit-box-shadow: inset 0 0 0 1px #187aff;
	-moz-box-shadow: inset 0 0 0 1px #187aff;
	box-shadow: inset 0 0 0 1px #187aff;
}

.user-four {
	background-color: #ffcc00;
	-webkit-box-shadow: inset 0 0 0 1px #b38f00;
	-moz-box-shadow: inset 0 0 0 1px #b38f00;
	box-shadow: inset 0 0 0 1px #b38f00;
}

.user-five {
	background-color: #aa73c2;
	-webkit-box-shadow: inset 0 0 0 1px #8647a2;
	-moz-box-shadow: inset 0 0 0 1px #8647a2;
	box-shadow: inset 0 0 0 1px #8647a2;
}

.user-six {
	background-color: #f02424;
	-webkit-box-shadow: 0 0 1px #f02424;
	-moz-box-shadow: 0 0 1px #f02424;
	box-shadow: 0 0 1px #f02424;
}

.user-seven {
	background-color: #24ccf0;
	-webkit-box-shadow: inset 0 0 0 1px #0d9cbb;
	-moz-box-shadow: inset 0 0 0 1px #0d9cbb;
	box-shadow: inset 0 0 0 1px #0d9cbb;
}

.user-eight {
	background-color: #bababa;
	-webkit-box-shadow: inset 0 0 0 1px #949494;
	-moz-box-shadow: inset 0 0 0 1px #949494;
	box-shadow: inset 0 0 0 1px #949494;
}

.user-nine {
	background-color: #dea700;
	-webkit-box-shadow: inset 0 0 0 1px #926d00;
	-moz-box-shadow: inset 0 0 0 1px #926d00;
	box-shadow: inset 0 0 0 1px #926d00;
}

.user-ten {
	background-color: #e670dc;
	-webkit-box-shadow: inset 0 0 0 1px #db2fcc;
	-moz-box-shadow: inset 0 0 0 1px #db2fcc;
	box-shadow: inset 0 0 0 1px #db2fcc;
}

.label-attempt {
	background-color: #fff;
	padding: 1px 2px;
	color: #666;
	border: solid 1px;
	border-color: #666;
	text-shadow: 0 0px 0 rgba(0, 0, 0, 0);
	font-weight: normal;
}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		//schedule paper
		$('.lnkTakeTestbtn').click(function(e) {
			e.preventDefault();
			proceed(this);
		});
	});

	function proceed(object) {
		if ($(object).data('mode') === 'FullScreen') {
			window.open($(object).data('lnk'), "ExamPage", "fullscreen=yes,scrollbars=yes,location=no");
		} else if ($(object).data('mode') === 'NormalScreen') {
			window.location.href = $(object).data('lnk');
		}
	}
</script>
</head>
<body>

	<fieldset class="well">

		<!-- date format -->
		<c:set value="dd MMM, yyyy" var="dateFormatForWeekPanel" />
		<!-- collapse & expand panel image path -->
		<c:set value="../resources/images/sort_desc.png" var="collapseIconSrc" />
		<c:set value="../resources/images/sort_asc.png" var="expandIconSrc" />

		<!-- get current exam event -->
		<legend>
			<span> <img src="<c:url value="../resources/images/tests.png"></c:url>" alt="Add New"> <spring:message code="groupviewActivityCalendar.PageHeading" />&nbsp; <c:if test="${currentActiveExamEvent!=null}">
					${currentActiveExamEvent.name}
			</c:if>
			</span>
		</legend>
		<div class="holder">

			<br>
			<div class="accordion allUserPanel" id="accordion1">
				<c:forEach var="candidateCalender" items="${candidateCalenders}" varStatus="k">

					<div class="accordion-group">
						<div class="accordion-heading user-${userColors[k.index]} panelDeorator">
							<a class="accordion-toggle user-${userColors[k.index]}" data-toggle="collapse" data-parent="#accordion1" href="#collapse-candidate${candidateCalender.venueUser.object}"><i class="icon-user"></i> &nbsp;&nbsp; ${candidateCalender.venueUser.firstName}
								${candidateCalender.venueUser.middleName} ${candidateCalender.venueUser.lastName} <img class="pull-right panel-Exp-Col-Icon" alt="" src="${collapseIconSrc}"></a>
						</div>
						<div id="collapse-candidate${candidateCalender.venueUser.object}" class="accordion-body collapse">
							<div class="accordion-inner">

								<!-- User wise Calender Start -->
								<!-- INNER ACCIORDIAN START -->
								<div class="accordion allWeekPanel" id="accordion${k.index+3}">
									<!-- get previous shedule master map -->
									<c:forEach var="scheduleMap" items="${candidateCalender.previousScheduleMasterMap}" varStatus="i">
										<div class="accordion-group">
											<div class="accordion-heading accordianColor_prev">
												<a class="accordion-toggle  accordianColor_prev" data-toggle="collapse" data-parent="#accordion${k.index+3}" href="#collapse-${scheduleMap.value.scheduleID}-candidate${candidateCalender.venueUser.object}"> ${scheduleMap.value.scheduleName} : <fmt:formatDate
														pattern="${dateFormatForWeekPanel}" value="${scheduleMap.value.scheduleStart}" />&nbsp; <!-- Compare Dates --> <fmt:formatDate value="${scheduleMap.value.scheduleStart}" pattern="dd/MM/yyyy" var="startDateValue" /> <fmt:formatDate value="${scheduleMap.value.scheduleEnd}"
														pattern="dd/MM/yyyy" var="endDateValue" /> <c:if test="${startDateValue != endDateValue}">
														<spring:message code="groupviewActivityCalendar.to" />
														<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMap.value.scheduleEnd}" />
													</c:if> <img class="pull-right panel-Exp-Col-Icon" alt="" src="${collapseIconSrc}">
												</a>
											</div>

											<!-- Make previous collapse open -->
											<c:choose>
												<c:when test="${i.index==fn:length(candidateCalender.previousScheduleMasterMap)-1}">
													<div id="collapse-${scheduleMap.value.scheduleID}-candidate${candidateCalender.venueUser.object}" class="accordion-body collapse ${previousCollapse}">
												</c:when>
												<c:otherwise>
													<div id="collapse-${scheduleMap.value.scheduleID}-candidate${candidateCalender.venueUser.object}" class="accordion-body collapse">
												</c:otherwise>
											</c:choose>


											<div class="accordion-inner">

												<div class="box">
													<!-- <div class="box-header">Header</div> -->
													<!-- variable to check empty schedule -->
													<c:set var="NoPrevPaperFound" value="0" />
													<div class="box-body">
														<table class="table table-bordered table-complex">
															<tbody>

																<!-- get previous schedule displayCategory relation map -->
																<c:forEach var="scheduleDisplayCategoryRelMap" items="${candidateCalender.previousScheduleDisplayCategoryRelMap}">

																	<!-- relate schedule and displayCategory -->
																	<c:if test="${scheduleMap.key==scheduleDisplayCategoryRelMap.key}">
																		<!-- get displayCategorys list of schedule -->
																		<c:forEach var="displayCategory" items="${scheduleDisplayCategoryRelMap.value}" varStatus="status">
																			<c:set var="NoPrevPaperFound" value="1" />
																			<tr>
																				<td class="highlight span3">${displayCategory.displayCategoryName}</td>
																				<c:choose>
																					<c:when test="${status.first}">
																						<td class="highlight text-center span1"><spring:message code="groupviewActivityCalendar.ExpiresOn" /></td>
																						<td class="highlight text-center span1"><spring:message code="viewActivityCalendar.attemptDate" /></td>
																						<td class="highlight span2"></td>
																					</c:when>
																					<c:otherwise>
																						<td class="highlight span1"></td>
																						<td class="highlight span1"></td>
																						<td class="highlight span2"></td>
																					</c:otherwise>
																				</c:choose>
																			</tr>

																			<!-- get all papers of related displayCategorys and schedule-->
																			<c:forEach var="paper" items="${candidateCalender.previousSchedulePapers}">
																				<c:if test="${paper.displayCategoryLanguage.fkDisplayCategoryID==displayCategory.fkDisplayCategoryID and paper.scheduleMaster.scheduleID==scheduleMap.key}">
																					<tr>
																						<td><c:choose>
																								<c:when test="${paper.assessmentType==null and paper.freePaperStatus == 1 }">
																									<i class="icon-def-group"></i>
																								</c:when>
																								<c:when test="${paper.assessmentType=='Group' and paper.freePaperStatus == 1 }">
																									<i class="icon-def-group"></i>
																								</c:when>
																								<c:when test="${paper.assessmentType=='Solo' and paper.freePaperStatus == 0}">
																									<i class="icon-user "></i>
																								</c:when>
																								<c:when test="${paper.assessmentType=='Group' and paper.freePaperStatus == 0 }">
																									<i class="icon-def-group"></i>
																								</c:when>
																								<c:when test="${paper.assessmentType=='Solo' and paper.freePaperStatus == 1}">
																									<i class="icon-user "></i>
																								</c:when>
																								<c:when test="${paper.freePaperStatus==1}">
																									<i class="icon-user "></i>
																								</c:when>
																							</c:choose> &nbsp;&nbsp;${paper.paper.name}&nbsp;&nbsp; <c:choose>
																								<c:when test="${paper.examEventPaperDetails != null and paper.examEventPaperDetails.noOfAttempts == 2}">
																									<span class="label label-attempt"><spring:message code="homepage.Attempt" /> #${paper.candidateExam.attemptNo}</span>
																								</c:when>
																							</c:choose> <c:choose>
																								<c:when test="${paper.paperStatus==0 and paper.expiryDate != null and paper.testPermission==true }">
																									<span class="label label-success"><spring:message code="viewActivityCalendar.new" /></span>
																								</c:when>
																								<c:when test="${paper.paperStatus==0 and paper.expiryDate == null and paper.testPermission!=true }">
																									<span class="label label-warning"> <spring:message code="groupviewActivityCalendar.notAttempted" />
																									</span>
																								</c:when>
																								<c:when test="${paper.paperStatus==0 and paper.expiryDate != null and paper.testPermission!=true }">
																									<span class="label label-warning"> <spring:message code="groupviewActivityCalendar.notAttempted" />
																									</span>
																								</c:when>
																								<c:when test="${paper.paperStatus == 2 && paper.assessmentType !='Group'}">
																									<span class="label label-important"><spring:message code="groupviewActivityCalendar.Incomplete" /></span>
																								</c:when>
																								<c:when test="${paper.paperStatus == 0 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																									<span class="label label-success"><spring:message code="viewActivityCalendar.new" /></span>
																								</c:when>
																								<c:when test="${paper.paperStatus == 2 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																									<span class="label label-important"><spring:message code="homepage.incomplete" /></span>
																								</c:when>
																							</c:choose></td>
																						<td class="text-center"><c:choose>
																								<c:when test="${paper.expiryDate != null and paper.testPermission==true}">
																									<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.expiryDate}" />&nbsp;
																									         </c:when>
																								<c:otherwise>
																									<spring:message code="groupviewActivityCalendar.Closed" />
																								</c:otherwise>
																							</c:choose></td>
																						<td class="text-center"><c:if test="${paper.candidateExam != null and paper.candidateExam.attemptDate != null }">
																								<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.candidateExam.attemptDate}" />&nbsp;
																									</c:if></td>
																						<td class="text-center"><a class="btn btn-red viewSyllabusBtn"  data-value="${paper.paper.paperID}"><spring:message code="groupviewActivityCalendar.Syllabus" /></a> <c:choose>
																								<c:when test="${paper.testPermission==true and paper.paperStatus!=1 and  (paper.examEventPaperDetails.assessmentType=='Group' or paper.examEventPaperDetails.assessmentType=='Both') and paper.assessmentType=='Group' }">
																									<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-purple lnkTakeTestbtn"
																										data-lnk="../groupExam/groupInfo?examEventID=${paper.examEvent.examEventID}&paperID=${paper.paper.paperID}&scheduleEnd=${paper.scheduleMaster.scheduleEnd.time}"><spring:message code="groupviewActivityCalendar.grouptest" /></a>
																								</c:when>
																								<c:when test="${paper.testPermission==true and paper.paperStatus!=1 and paper.expiryDate != null and paper.freePaperStatus==0}">
																									<a class="btn btn-greener" href="#modalCandidateInfo-${candidateCalender.venueUser.object}" data-toggle="modal" data-backdrop="static"><spring:message code="groupviewActivityCalendar.TakeATest" /></a>
																								</c:when>
																								<c:when test="${paper.testPermission==true and paper.paperStatus!=1  and paper.expiryDate != null and paper.freePaperStatus==1 and paper.assessmentType=='Solo'}">
																									<a class="btn btn-greener" href="#modalCandidateInfo-${candidateCalender.venueUser.object}" data-toggle="modal" data-backdrop="static"><spring:message code="groupviewActivityCalendar.TakeATest" /></a>
																								</c:when>
																								<c:when test="${paper.testPermission==true  and paper.paperStatus!=1 and paper.expiryDate != null and paper.candidateExam != null && paper.freePaperStatus==1 and paper.candidateExam.attemptNo > 1}">
																									<a class="btn btn-greener" href="#modalCandidateInfo-${candidateCalender.venueUser.object}" data-toggle="modal" data-backdrop="static"><spring:message code="groupviewActivityCalendar.TakeATest" /></a>
																								</c:when>
																								<c:when test="${paper.testPermission!=true and paper.paperStatus!=1 and  paper.assessmentType=='Group'}">
																									<a class="btn btn-disabled" data-mode="#" href="javascript:void(0);"><spring:message code="viewActivityCalendar.grouptest" /></a>
																								</c:when>
																								<c:when test="${paper.testPermission!=true and paper.paperStatus!=1 and  paper.assessmentType=='Solo'}">
																									<a class="btn btn-disabled" data-mode="#" href="javascript:void(0);"><spring:message code="viewActivityCalendar.TakeATest" /></a>
																								</c:when>
																								<c:when test="${paper.paperStatus == 1 and  paper.examEventPaperDetails.showAnalysis==true}">
																									<%-- <a class="btn btn-warning " href="../ResultAnalysis/viewtestscore?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}&attemptNo=${paper.candidateExam.attemptNo}">&nbsp;&nbsp;&nbsp;<spring:message code="viewActivityCalendar.Analysis" />&nbsp;&nbsp;&nbsp;
																									</a> --%>
																									<a class="btn btn-warning " href="../ResultAnalysis/viewtestscore?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}&candidateId=${candidateCalender.venueUser.object}&attemptNo=${paper.candidateExam.attemptNo}">&nbsp;&nbsp;&nbsp;<spring:message
																											code="groupviewActivityCalendar.Analysis" />&nbsp;&nbsp;&nbsp;
																									</a>
																								</c:when>
																								<c:when test="${paper.paperStatus == 1 and  paper.examEventPaperDetails.showAnalysis!=true}">
																									<a class="btn btn-disabled" href="javascript:void(0);">&nbsp;&nbsp;&nbsp;<spring:message code="viewActivityCalendar.Analysis" />&nbsp;&nbsp;&nbsp;
																									</a>
																								</c:when>
																							</c:choose></td>
																					</tr>
																				</c:if>

																			</c:forEach>

																		</c:forEach>

																	</c:if>

																</c:forEach>

															</tbody>
														</table>
													</div>
												</div>

												<c:if test="${NoPrevPaperFound != '1'}">
													<div class="alert alert-warning NoPaperFoundDiv" style="height: 20%">
														<spring:message code="groupviewActivityCalendar.ScheduleInfo" />
													</div>
													<c:set var="NoPrevPaperFound" value="1" />
												</c:if>
											</div>

										</div>
								</div>
				</c:forEach>


				<!-- current Schedule Panel -->

				<c:forEach items="${candidateCalender.currentScheduleMasters}" var="scheduleMaster">
					<c:forEach items="${candidateCalender.currentScheduleDisplayCategoryRelMap}" var="displayCategoryMap">
						<c:if test="${displayCategoryMap.key==scheduleMaster.scheduleType }">
							<div class="accordion-group">
								<div class="accordion-heading accordianColor_Current">
									<a class="accordion-toggle  accordianColor_Current" data-toggle="collapse" data-parent="#accordion${k.index+3}" href="#collapse-${scheduleMaster.scheduleID}-candidate${candidateCalender.venueUser.object}"> ${scheduleMaster.scheduleName} <fmt:formatDate
											pattern="${dateFormatForWeekPanel}" value="${scheduleMaster.scheduleStart}" />&nbsp; <!-- Compare Dates --> <fmt:formatDate value="${scheduleMaster.scheduleStart}" pattern="dd/MM/yyyy" var="startDateValue" /> <fmt:formatDate value="${scheduleMaster.scheduleEnd}" pattern="dd/MM/yyyy"
											var="endDateValue" /> <c:if test="${startDateValue != endDateValue}">
											<spring:message code="groupviewActivityCalendar.to" />
											<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMaster.scheduleEnd}" />
										</c:if> <img class="pull-right panel-Exp-Col-Icon" alt="" src="${collapseIconSrc}">
									</a>
								</div>
								<div id="collapse-${scheduleMaster.scheduleID}-candidate${candidateCalender.venueUser.object}" class="accordion-body collapse ${currentCollapse}">
									<div class="accordion-inner">
										<c:choose>
											<c:when test="${not empty displayCategoryMap.value}">
												<div class="box">
													<!-- 	<div class="box-header"></div> -->
													<div class="box-body">
														<table class="table table-bordered table-complex">
															<tbody>
																<!-- get displayCategorys of current schedule -->
																<c:forEach var="displayCategory" items="${displayCategoryMap.value}" varStatus="status">
																	<tr>
																		<td class="highlight span3">${displayCategory.displayCategoryName}</td>
																		<c:choose>
																			<c:when test="${status.first}">
																				<td class="highlight text-center span1"><spring:message code="groupviewActivityCalendar.ExpiresOn" /></td>
																				<td class="highlight text-center span1"><spring:message code="groupviewActivityCalendar.attemptDate" /></td>
																				<td class="highlight span2"></td>
																			</c:when>
																			<c:otherwise>
																				<td class="highlight span1"></td>
																				<td class="highlight span1"></td>
																				<td class="highlight span2"></td>
																			</c:otherwise>
																		</c:choose>
																	</tr>

																	<!-- get papers of current schedule -->
																	<c:forEach var="paper" items="${candidateCalender.currentSchedulePapers}">
																		<!-- if it is FREE paper then put into WEEK -->
																		<c:set value="0" var="freePaperPanelSet" />
																		<c:choose>
																			<c:when test="${paper.freePaperStatus == 1 and scheduleMaster.scheduleType.ordinal() == 1}">
																				<c:set value="1" var="freePaperPanelSet" />
																			</c:when>
																		</c:choose>
																		<!-- check paper belong to  ScheduleType -->
																		<c:if test="${paper.displayCategoryLanguage.fkDisplayCategoryID==displayCategory.fkDisplayCategoryID and (paper.scheduleMaster.scheduleType==scheduleMaster.scheduleType or freePaperPanelSet==1)}">
																			<tr>
																				<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.scheduleMaster.scheduleStart}" var="datePointerStart" />
																				<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.scheduleMaster.scheduleEnd}" var="datePointerEnd" />

																				<td><c:choose>
																						<c:when test="${paper.assessmentType==null and paper.freePaperStatus == 1 }">
																							<i class="icon-def-group"></i>
																						</c:when>
																						<c:when test="${paper.assessmentType=='Group' and paper.freePaperStatus == 1 }">
																							<i class="icon-def-group"></i>
																						</c:when>
																						<c:when test="${paper.assessmentType=='Solo' and paper.freePaperStatus == 0}">
																							<i class="icon-user "></i>
																						</c:when>
																						<c:when test="${paper.assessmentType=='Group' and paper.freePaperStatus == 0 }">
																							<i class="icon-def-group"></i>
																						</c:when>																						
																						<c:when test="${paper.assessmentType=='Solo' and paper.freePaperStatus == 1}">
																							<i class="icon-user "></i>
																						</c:when>
																						<c:when test="${paper.freePaperStatus==1}">
																							<i class="icon-user "></i>
																						</c:when>
																					</c:choose> &nbsp;&nbsp;${paper.paper.name}&nbsp;&nbsp; <c:choose>
																						<c:when test="${paper.examEventPaperDetails != null and paper.examEventPaperDetails.noOfAttempts == 2}">
																							<span class="label label-attempt"><spring:message code="homepage.Attempt" /> #${paper.candidateExam.attemptNo}</span>
																						</c:when>
																					</c:choose> <c:choose>

																						<c:when test="${paper.paperStatus==0 and paper.expiryDate != null}">
																							<span class="label label-success"><spring:message code="groupviewActivityCalendar.new" /></span>
																						</c:when>
																						<c:when test="${paper.paperStatus != 1 and paper.expiryDate != null && paper.assessmentType !='Group'}">
																							<span class="label label-important"><spring:message code="groupviewActivityCalendar.Incomplete" /></span>
																						</c:when>
																						<c:when test="${paper.paperStatus == 0 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																							<span class="label label-success"><spring:message code="viewActivityCalendar.new" /></span>
																						</c:when>
																						<c:when test="${paper.paperStatus == 2 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																							<span class="label label-important"><spring:message code="homepage.incomplete" /></span>
																						</c:when>
																						<c:when test="${paper.paperStatus==1 and paper.freePaperStatus==1}">
																							<%-- BLANK --%>
																						</c:when>
																						<c:when test="${paper.freePaperStatus==1}">
																							<span class="label label-success"><spring:message code="homepage.new" /></span>
																						</c:when>
																					</c:choose></td>
																				<td class="text-center"><c:if test="${paper.expiryDate != null}">
																						<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.expiryDate}" />
																					</c:if></td>
																				<td class="text-center"><c:if test="${paper.candidateExam != null and paper.candidateExam.attemptDate != null }">
																						<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.candidateExam.attemptDate}" />&nbsp;
																									</c:if>
																				<td class="text-center"><a class="btn btn-red viewSyllabusBtn"  data-value="${paper.paper.paperID}" ><spring:message code="groupviewActivityCalendar.Syllabus" /></a> <!-- check if paper is combo test and it is in current schedule--> <c:choose>


																						<c:when test="${paper.paperStatus!=1 && paper.expiryDate == null && (paper.examEventPaperDetails.assessmentType=='Group') && paper.assessmentType==null }">
																							<c:choose>
																							   <c:when test="${paper.groupPaperStatus==true}">
																							     	<a class="btn btn-warning" href="../GroupResultAnalysis/groupAnalysisCandidateList?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}">&nbsp;&nbsp;&nbsp;<spring:message code="grouphomepage.ViewAnalysis" />&nbsp;&nbsp;&nbsp;
																									</a>
																							   </c:when>
																							   <c:otherwise>
																							   		<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-purple lnkTakeTestbtn" data-lnk="../groupExam/groupInfo?examEventID=${paper.examEvent.examEventID}&paperID=${paper.paper.paperID}&scheduleEnd=${paper.scheduleMaster.scheduleEnd.time}"><spring:message
																									code="groupviewActivityCalendar.grouptest" /></a>
																							   </c:otherwise>
																							</c:choose>
																						</c:when>
																						<c:when test="${paper.paperStatus!=1 && paper.expiryDate != null && (paper.examEventPaperDetails.assessmentType=='Group' or paper.examEventPaperDetails.assessmentType=='Both') && paper.assessmentType=='Group' }">
																							<c:choose>
																							   <c:when test="${paper.groupPaperStatus==true}">
																							     	<a class="btn btn-warning" href="../GroupResultAnalysis/groupAnalysisCandidateList?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}">&nbsp;&nbsp;&nbsp;<spring:message code="grouphomepage.ViewAnalysis" />&nbsp;&nbsp;&nbsp;
																									</a>
																							   </c:when>
																							   <c:otherwise>
																							   		<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-purple lnkTakeTestbtn" data-lnk="../groupExam/groupInfo?examEventID=${paper.examEvent.examEventID}&paperID=${paper.paper.paperID}&scheduleEnd=${paper.scheduleMaster.scheduleEnd.time}"><spring:message
																									code="groupviewActivityCalendar.grouptest" /></a>
																							   </c:otherwise>
																							</c:choose>
																						</c:when>
																						<c:when test="${paper.paperStatus!=1 and paper.expiryDate != null and paper.freePaperStatus==0}">
																							<a class="btn btn-greener" href="#modalCandidateInfo-${candidateCalender.venueUser.object}" data-toggle="modal" data-backdrop="static"><spring:message code="groupviewActivityCalendar.TakeATest" /></a>
																						</c:when>
																						<c:when test="${paper.paperStatus!=1  and paper.expiryDate != null and paper.freePaperStatus==1 and paper.assessmentType=='Solo'}">
																							<a class="btn btn-greener" href="#modalCandidateInfo-${candidateCalender.venueUser.object}" data-toggle="modal" data-backdrop="static"><spring:message code="groupviewActivityCalendar.TakeATest" /></a>
																						</c:when>
																						<c:when test="${paper.paperStatus!=1 and paper.candidateExam != null && paper.freePaperStatus==1 and paper.candidateExam.attemptNo > 1}">
																							<a class="btn btn-greener" href="#modalCandidateInfo-${candidateCalender.venueUser.object}" data-toggle="modal" data-backdrop="static"><spring:message code="groupviewActivityCalendar.TakeATest" /></a>
																						</c:when>
																						<c:when test="${paper.paperStatus!=1  and paper.candidateExam != null && paper.freePaperStatus==1}">
																							<!-- b=0 :dcid is present hence update  
																							 b=1 :dcid is not present hence insert -->
																							<c:choose>
																								<c:when test="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID] > 0}">
																									<a class="btn btn-greener" href="#modalCandidateInfo-${candidateCalender.venueUser.object}" data-toggle="modal" data-backdrop="static"><spring:message code="groupviewActivityCalendar.TakeATest" /></a>
																								</c:when>
																								<c:otherwise>
																									<a class="btn btn-greener" href="#modalCandidateInfo-${candidateCalender.venueUser.object}" data-toggle="modal" data-backdrop="static"><spring:message code="groupviewActivityCalendar.TakeATest" /></a>
																								</c:otherwise>
																							</c:choose>
																						</c:when>
																						<c:when test="${paper.paperStatus==1 and paper.examEventPaperDetails.showAnalysis==true}">
																							<%-- <a class="btn btn-warning" href="../ResultAnalysis/viewtestscore?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}&attemptNo=${paper.candidateExam.attemptNo}">&nbsp;&nbsp;&nbsp;<spring:message code="viewActivityCalendar.Analysis" />&nbsp;&nbsp;&nbsp;
																							</a> --%>
																							<a class="btn btn-warning" href="../ResultAnalysis/viewtestscore?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}&candidateId=${candidateCalender.venueUser.object}&attemptNo=${paper.candidateExam.attemptNo}">&nbsp;&nbsp;&nbsp;<spring:message
																									code="groupviewActivityCalendar.Analysis" />&nbsp;&nbsp;&nbsp;
																							</a>
																						</c:when>
																						<c:when test="${paper.paperStatus == 1 and paper.examEventPaperDetails.showAnalysis!=true}">
																							<a class="btn btn-disabled" href="javascript:void(0);">&nbsp;&nbsp;&nbsp;<spring:message code="viewActivityCalendar.Analysis" />&nbsp;&nbsp;&nbsp;
																							</a>
																						</c:when>
																					</c:choose></td>
																			</tr>
																		</c:if>
																	</c:forEach>

																</c:forEach>
															</tbody>
														</table>
													</div>
												</div>

											</c:when>
											<c:otherwise>
												<div class="alert alert-warning">
													<spring:message code="groupviewActivityCalendar.NoCurrentWeekInfo" />
												</div>
											</c:otherwise>
										</c:choose>
									</div>

								</div>
							</div>
						</c:if>
					</c:forEach>
				</c:forEach>


				<!-- get next schedule master map -->
				<c:forEach var="scheduleMap" items="${candidateCalender.nextScheduleMasterMap}">
					<div class="accordion-group">
						<div class="accordion-heading accordianColor_next">
							<a class="accordion-toggle  accordianColor_next" data-toggle="collapse" data-parent="#accordion${k.index+3}" href="#collapse-${scheduleMap.value.scheduleID}-candidate${candidateCalender.venueUser.object}"> ${scheduleMap.value.scheduleName} : <fmt:formatDate
									pattern="${dateFormatForWeekPanel}" value="${scheduleMap.value.scheduleStart}" />&nbsp; <!-- Compare Dates --> <fmt:formatDate value="${scheduleMap.value.scheduleStart}" pattern="dd/MM/yyyy" var="startDateValue" /> <fmt:formatDate value="${scheduleMap.value.scheduleEnd}"
									pattern="dd/MM/yyyy" var="endDateValue" /> <c:if test="${startDateValue != endDateValue}">
									<spring:message code="groupviewActivityCalendar.to" />
									<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMap.value.scheduleEnd}" />
								</c:if> <img class="pull-right panel-Exp-Col-Icon" alt="" src="${collapseIconSrc}"></a>

						</div>
						<div id="collapse-${scheduleMap.value.scheduleID}-candidate${candidateCalender.venueUser.object}" class="accordion-body collapse">
							<div class="accordion-inner">

								<div class="box">
									<!-- <div class="box-header">Header</div> -->
									<c:set var="NoNextPaperFound" value="0" />
									<div class="box-body">
										<table class="table table-bordered table-complex">
											<tbody>
												<!-- get previous schedule displayCategory relation map -->
												<c:forEach var="scheduleDisplayCategoryRelMap" items="${candidateCalender.nextScheduleDisplayCategoryRelMap}">

													<!-- relate schedule and displayCategory -->
													<c:if test="${scheduleMap.key==scheduleDisplayCategoryRelMap.key}">

														<!-- get displayCategorys list of schedule -->
														<c:forEach var="displayCategory" items="${scheduleDisplayCategoryRelMap.value}" varStatus="status">

															<c:set var="NoNextPaperFound" value="1" />
															<tr>
																<td class="highlight">${displayCategory.displayCategoryName}</td>
																<c:choose>
																	<c:when test="${status.first}">
																		<td class="highlight text-center"><spring:message code="groupviewActivityCalendar.OpensOn" /></td>
																		<td class="highlight"></td>
																	</c:when>
																	<c:otherwise>
																		<td class="highlight"></td>
																		<td class="highlight"></td>
																	</c:otherwise>
																</c:choose>
															</tr>

															<!-- get all papers of related displayCategorys And schedule -->
															<c:forEach var="paper" items="${candidateCalender.nextSchedulePapers}">
																<c:if test="${paper.displayCategoryLanguage.fkDisplayCategoryID==displayCategory.fkDisplayCategoryID and paper.scheduleMaster.scheduleID==scheduleMap.key}">
																	<tr>
																		<td><c:choose>
																				<c:when test="${paper.assessmentType=='Solo' }">
																					<i class="icon-user "></i>
																				</c:when>
																				<c:when test="${paper.assessmentType=='Group' }">
																					<i class="icon-def-group"></i>
																				</c:when>

																			</c:choose>&nbsp;&nbsp;${paper.paper.name}</td>
																		<td class="text-center span2"><c:if test="${paper.scheduleMaster.scheduleStart!=null}">
																				<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.scheduleMaster.scheduleStart}" />
																			</c:if></td>
																		<td class="text-center span1"><a class="btn btn-red viewSyllabusBtn"  data-value="${paper.paper.paperID}"><spring:message code="groupviewActivityCalendar.Syllabus" /></a></td>
																	</tr>
																</c:if>

															</c:forEach>
														</c:forEach>
													</c:if>
												</c:forEach>
											</tbody>
										</table>
									</div>
								</div>

								<c:if test="${NoNextPaperFound != '1'}">
									<div class="alert alert-warning NoPaperFoundDiv">
										<spring:message code="groupviewActivityCalendar.ScheduleInfo" />
									</div>
									<c:set var="NoNextPaperFound" value="1" />
								</c:if>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
			<!-- INNER ACCIORDIAN END -->
			<!-- User wise Calender End -->

		</div>
		</div>
		</div>
		</c:forEach>
		</div>




		<br />
		<div style="text-align: center; position: relative; padding-bottom: 0px">
			<p>
				<i class="icon-user "></i> <spring:message code="homapage.solopaper" /> &nbsp;&nbsp;<i class="icon-def-group"></i> <spring:message code="homapage.grouppaper" /><br /> &nbsp;&nbsp;
			</p>
		</div>
		<br />
		<c:if test="${noDataToDisplay!=1 and hideCalender!=true}">			
			<table align="center">
			<tr><td><span style="background-color: #a2a2a2; width: 18px; height: 18px; border: 1px solid;">&nbsp;&nbsp;&nbsp; &nbsp;</span></td>
			<td>&nbsp;<spring:message code="viewActivityCalendar.previousweekindicator"></spring:message>&nbsp;&nbsp;</td>
			<td><span style="background-color: #4da04e; width: 18px; height: 18px; border: 1px solid">&nbsp;&nbsp;&nbsp; &nbsp;</span></td>
			<td>&nbsp;<spring:message code="viewActivityCalendar.activeweekindicator"></spring:message>&nbsp;&nbsp;</td>
			<td><span style="background-color: #61a1e3; width: 18px; height: 18px; border: 1px solid">&nbsp;&nbsp;&nbsp; &nbsp;</span></td>
			<td>&nbsp;<spring:message code="viewActivityCalendar.nextweekindicator"></spring:message>&nbsp;&nbsp;</td></tr>
			</table> 
		</c:if>
	</fieldset>

		<!-- all papers syllabus Modal -->
	<input id="syllabusIframeURL" type="hidden" value="<c:url value="/groupCandidatesModule/viewPaperSyllabus"></c:url>" />
	<div id="modal-viewSyllabus" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
		<div class="modal-header">
			<h3 id="syllabusHeaderPart"></h3>
		</div>
		<div class="modal-body" style="padding: 10px;">
			<h4 style="text-decoration: underline;">
				<spring:message code="Candidate.syllabus" />
			</h4>
			<label id="loadingsyllabus"><spring:message code="homapage.loadingsyllabus" /> </label>
			<!-- iframe -->
			<iframe src="" style="display: none; margin: 2px 0 0 0; width: 100%; border: none; height: 350px;" id="hiddenIframe"></iframe>
		</div>
		<div class="modal-footer">
			<button class="btn" data-dismiss="modal" aria-hidden="true">
				<spring:message code="homepage.Exit" />
			</button>
		</div>
	</div>


	<!-- Modal for group Login Message -->
	<c:if test="${fn:length(candidates) != 0}">
		<c:forEach var="candidate" items="${candidates}" varStatus="i">
			<div id="modalCandidateInfo-${candidate.object}" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">

				<div class="modal-header alert-error text-center">
					<h5>
						<spring:message code="groupviewActivityCalendar.grouploginrequired" />
					</h5>
				</div>
				<div class="modal-body">
					<spring:message code="groupviewActivityCalendar.pleaseproceedsolologin" />
					.
				</div>
				<div class="modal-footer">
					<button class="btn" data-dismiss="modal" aria-hidden="true">
						<spring:message code="homepage.Exit" />
					</button>
				</div>
			</div>
		</c:forEach>
	</c:if>

	<script type="text/javascript">
		$(function() {

			//remove box table if empty
			$(".allWeekPanel").find(".NoPaperFoundDiv").each(function() {
				$(this).parent().find(".box").remove();
			});

			var collapseIconSrc = "${collapseIconSrc}";
			var expandIconSrc = "${expandIconSrc}";
			//INNER ACCORDIAN
			//set icon on page loading event
			$(".allWeekPanel").find(".in").parent().find(".panel-Exp-Col-Icon").attr("src", expandIconSrc);
			//set icon on panel collapse and expand event
			$(".allWeekPanel .accordion-group .accordion-heading a").click(function() {
				var srcVal = $(this).parent().find(".panel-Exp-Col-Icon").attr("src");
				if (collapseIconSrc === srcVal) {
					//expand panel
					$(this).parent().find(".panel-Exp-Col-Icon").attr("src", expandIconSrc);
				} else {
					//collapse the panel
					$(this).parent().find(".panel-Exp-Col-Icon").attr("src", collapseIconSrc);
				}
				//make all other collapse
				$(".allWeekPanel").find(".panel-Exp-Col-Icon").not($(this).parent().find(".panel-Exp-Col-Icon")).each(function() {
					if (!$(this).parent().parent().parent().find(".in").hasClass("in")) {
						$(this).attr("src", collapseIconSrc);
					}
				});
			});

			//OUTER ACCORDIAN
			//set icon on panel collapse and expand event
			$(".allUserPanel > .accordion-group > .accordion-heading a").click(function() {
				var srcVal = $(this).parent().find(".panel-Exp-Col-Icon").attr("src");
				if (collapseIconSrc === srcVal) {
					//expand panel
					$(this).parent().find(".panel-Exp-Col-Icon").attr("src", expandIconSrc);
				} else {
					//collapse the panel
					$(this).parent().find(".panel-Exp-Col-Icon").attr("src", collapseIconSrc);
				}
				//make all other collapse
				$(".allUserPanel").find(".panel-Exp-Col-Icon").not($(this).parent().find(".panel-Exp-Col-Icon")).each(function() {
					if (!$(this).parent().parent().parent().find(".in").hasClass("in")) {
						$(this).attr("src", collapseIconSrc);
					}
				});
			});

			//modal setting
			//	$("#endTestConfirmModal").modal({ backdrop: 'static', keyboard: true });

		});
	</script>
	<script type="text/javascript">
		$(document).ready(function() {
			//view syllabus
			$(".viewSyllabusBtn").click(function(e) {
				$("#hiddenIframe").hide();
				$("#loadingsyllabus").show();
				$('#modal-viewSyllabus').modal('show');
				var paperID = $(this).data("value");
				var url = $("#syllabusIframeURL").val();
				$("#hiddenIframe").prop("src", "").prop("src", url + "?paperID=" + paperID);
				$('#hiddenIframe').load(function() {
					$("#loadingsyllabus").hide();
					$("#hiddenIframe").show();
				});
			});
			
		});
	</script>
</body>
</html>
