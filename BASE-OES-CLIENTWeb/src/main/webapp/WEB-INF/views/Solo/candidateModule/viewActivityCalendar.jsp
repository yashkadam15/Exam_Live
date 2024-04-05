<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<html>
<head>
<title><spring:message code="viewActivityCalendar.PageTitle" /></title>
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

.accordianColor_next_Title {
	color: red;
}

.accordianColor_Current_Title {
	color: #468847;
}

.accordianColor_prev_Title {
	color: red;
}

.error {
	color: red;
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

.dashboardform{
	display: inline-block;
	margin:0px;
}

</style>
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
			<span> <img src="<c:url value="../resources/images/tests.png"></c:url>" alt="Add New"> <spring:message code="viewActivityCalendar.PageHeading" />&nbsp; <c:if test="${currentExamEvent!=null}">
					${currentExamEvent.name}
			</c:if>
			</span>
		</legend>
		<div class="holder">

			<br>
			<div class="accordion allWeekPanel" id="accordion2">

				<!-- get previous shedule master map -->
				<c:forEach var="scheduleMap" items="${previousScheduleMasterMap}" varStatus="i">
					<div class="accordion-group">
						<div class="accordion-heading accordianColor_prev">
							<a class="accordion-toggle  accordianColor_prev" data-toggle="collapse" data-parent="#accordion2" href="#collapse-${scheduleMap.value.scheduleID}"> ${scheduleMap.value.scheduleName} : <fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMap.value.scheduleStart}" />&nbsp;
								<!-- Compare Dates --> <fmt:formatDate value="${scheduleMap.value.scheduleStart}" pattern="dd/MM/yyyy" var="startDateValue" /> <fmt:formatDate value="${scheduleMap.value.scheduleEnd}" pattern="dd/MM/yyyy" var="endDateValue" /> <c:if test="${startDateValue != endDateValue}">
									<spring:message code="viewActivityCalendar.to" />
									<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMap.value.scheduleEnd}" />
								</c:if> <img class="pull-right panel-Exp-Col-Icon" alt="" src="${collapseIconSrc}">
							</a>
						</div>

						<!-- Make previous collapse open -->
						<c:choose>
							<c:when test="${i.index==fn:length(previousScheduleMasterMap)-1}">
								<div id="collapse-${scheduleMap.value.scheduleID}" class="accordion-body collapse ${previousCollapse}">
							</c:when>
							<c:otherwise>
								<div id="collapse-${scheduleMap.value.scheduleID}" class="accordion-body collapse">
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
											<c:forEach var="scheduleDisplayCategoryRelMap" items="${previousScheduleDisplayCategoryRelMap}">

												<!-- relate schedule and displayCategory -->
												<c:if test="${scheduleMap.key==scheduleDisplayCategoryRelMap.key}">
													<!-- get displayCategorys list of schedule -->
													<c:forEach var="displayCategory" items="${scheduleDisplayCategoryRelMap.value}" varStatus="status">
														<c:set var="NoPrevPaperFound" value="1" />
														<tr>
															<td class="highlight span3">${displayCategory.displayCategoryName}</td>
															<c:choose>
																<c:when test="${status.first}">
																	<td class="highlight text-center span1"><spring:message code="viewActivityCalendar.ExpiresOn" /></td>
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
														<c:forEach var="paper" items="${previousSchedulePapers}">
															
															<c:choose>
														 		<c:when test="${paper.supervisorPwdStartExam == true}"> <c:set var="formActionPrevPp" value="../exam/AuthenticationGet" /></c:when>
														 		<c:otherwise><c:set var="formActionPrevPp" value="../exam/instruction" /></c:otherwise>
														 	</c:choose>
															
															<c:if test="${paper.displayCategoryLanguage.fkDisplayCategoryID==displayCategory.fkDisplayCategoryID and paper.scheduleMaster.scheduleID==scheduleMap.key}">
																<tr>
																	<td><c:choose>
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
																				<span class="label label-attempt"><spring:message code="homepage.Attempt" />#${paper.candidateExam.attemptNo}</span>
																			</c:when>
																		</c:choose> <c:choose>
																			<c:when test="${paper.paperStatus==0 and paper.expiryDate != null and paper.testPermission==true }">
																				<span class="label label-success"><spring:message code="viewActivityCalendar.new" /></span>
																			</c:when>
																			<c:when test="${paper.paperStatus==0 and paper.expiryDate == null and paper.testPermission!=true }">
																				<span class="label label-warning"> <spring:message code="viewActivityCalendar.notAttempted" />
																				</span>
																			</c:when>
																			<c:when test="${paper.paperStatus==0 and paper.expiryDate != null and paper.testPermission!=true}">
																				<!-- if schedule extension is greater than Event expiry -->
																				<span class="label label-warning"> <spring:message code="viewActivityCalendar.notAttempted" />
																				</span>
																			</c:when>
																			<c:when test="${paper.paperStatus == 2 && paper.assessmentType !='Group'}">
																				<span class="label label-important"><spring:message code="viewActivityCalendar.Incomplete" /></span>
																			</c:when>
																			<c:when test="${paper.paperStatus == 0 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																				<span class="label label-success"><spring:message code="viewActivityCalendar.new" /></span>
																			</c:when>
																			<c:when test="${paper.paperStatus == 2 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																				<span class="label label-important"><spring:message code="homepage.incomplete" /></span>
																			</c:when>
																		</c:choose></td>
																	<td class="text-center"><c:choose>
																			<c:when test="${paper.expiryDate != null && paper.testPermission==true}">
																				<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.expiryDate}" />&nbsp;
																	         </c:when>
																			<c:otherwise>
																				<spring:message code="viewActivityCalendar.Closed" />
																			</c:otherwise>
																		</c:choose></td>
																	<td class="text-center"><c:if test="${paper.candidateExam != null and paper.candidateExam.attemptDate != null }">
																			<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.candidateExam.attemptDate}" />&nbsp;
																	</c:if></td>
																	<td class="text-center"><a class="btn btn-red viewSyllabusBtn" data-value="${paper.paper.paperID}"><spring:message code="homepage.activeViewsyllabus" /></a> <c:choose>

																			<c:when test="${paper.testPermission==true and paper.paperStatus!=1 and  (paper.examEventPaperDetails.assessmentType=='Group' or paper.examEventPaperDetails.assessmentType=='Both') and paper.assessmentType=='Group' }">
																				<!--candidate which are not in Group but have group Paper  : disable it -->
																				<a class="btn btn-btn-disabled" href="#modalGroup-group" data-toggle="modal" data-backdrop="static"><spring:message code="homepage.GroupTest" /></a>
																			</c:when>
																			<c:when test="${paper.testPermission==true and paper.paperStatus!=1 and paper.expiryDate != null and paper.freePaperStatus==0}">
																				<c:choose>
																					<c:when test="${paper.paper.paperType == 'Typing'}">
																						<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																					</c:when>
																					<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																						
																						<form:form class="dashboardform examform" action="${formActionPrevPp}" method="POST">	
																							<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																						   	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																							<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																						</form:form>
																					</c:when>
																					<c:otherwise>
																						
																						<form:form class="dashboardform examform" action="${formActionPrevPp}" method="POST">	
																							<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																						   	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																							<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																						</form:form>
																					</c:otherwise>
																				</c:choose>
																			</c:when>
																			<c:when test="${paper.testPermission==true and paper.paperStatus!=1  and paper.expiryDate != null and paper.freePaperStatus==1 and paper.assessmentType=='Solo'}">
																				<!--PaperType=3 is Typing Test Paper  -->
																				<c:choose>
																					<c:when test="${paper.paper.paperType == 'Typing'}">
																						<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																					</c:when>
																					<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																						<form:form class="dashboardform examform" action="${formActionPrevPp}" method="POST">	
																							<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																						   	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																							<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																						</form:form>
																					</c:when>
																					<c:otherwise>																						
																						<form:form class="dashboardform examform" action="${formActionPrevPp}" method="POST">	
																							<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																						   	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																							<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																						</form:form>
																					</c:otherwise>
																				</c:choose>
																			</c:when>
																			<c:when test="${paper.testPermission==true  and paper.paperStatus!=1 and paper.expiryDate != null and paper.candidateExam != null && paper.freePaperStatus==1 and paper.candidateExam.attemptNo > 1}">
																				<!--PaperType=3 is Typing Test Paper  -->
																				<c:choose>
																					<c:when test="${paper.paper.paperType == 'Typing'}">
																						<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&clientid=${clientId}"><spring:message
																								code="homepage.takeATest" /></a>
																					</c:when>
																					<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																						<form:form class="dashboardform examform" action="${formActionPrevPp}" method="POST">	
																							<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																						   	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																							<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}"><spring:message
																							code="homepage.takeATest" /></a>
																						</form:form>
																					</c:when>
																					<c:otherwise>
																						
																						<form:form class="dashboardform examform" action="${formActionPrevPp}" method="POST">	
																							<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																						   	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																							<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}"><spring:message
																								code="homepage.takeATest" /></a>
																						</form:form>
																					</c:otherwise>
																				</c:choose>

																			</c:when>
																			<c:when test="${paper.testPermission!=true and paper.paperStatus!=1 and  paper.assessmentType=='Group'}">
																				<a class="btn btn-disabled" data-mode="#" href="javascript:void(0);"><spring:message code="viewActivityCalendar.grouptest" /></a>
																			</c:when>
																			<c:when test="${paper.testPermission!=true and paper.paperStatus!=1 and  paper.assessmentType=='Solo'}">
																				<a class="btn btn-disabled" data-mode="#" href="javascript:void(0);"><spring:message code="viewActivityCalendar.TakeATest" /></a>
																			</c:when>
																			<c:when test="${paper.paperStatus == 1 and  paper.examEventPaperDetails.showAnalysis==true}">
																				<a class="btn btn-warning " href="../ResultAnalysis/viewtestscore?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}&attemptNo=${paper.candidateExam.attemptNo}">&nbsp;&nbsp;&nbsp;<spring:message code="viewActivityCalendar.Analysis" />&nbsp;&nbsp;&nbsp;
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
									<spring:message code="viewActivityCalendar.ScheduleInfo" />
								</div>
								<c:set var="NoPrevPaperFound" value="1" />
							</c:if>
						</div>

					</div>
			</div>
			</c:forEach>


			<!-- current Schedule Panel -->
			<c:forEach items="${currentScheduleMasters}" var="scheduleMaster">
				<c:forEach items="${currentScheduleDisplayCategoryRelMap}" var="displayCategoryMap">
					<c:if test="${displayCategoryMap.key==scheduleMaster.scheduleType}">
						<div class="accordion-group">
							<div class="accordion-heading accordianColor_Current">
								<a class="accordion-toggle  accordianColor_Current" data-toggle="collapse" data-parent="#accordion2" href="#collapse-${scheduleMaster.scheduleID}"> ${scheduleMaster.scheduleName} <fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMaster.scheduleStart}" />&nbsp; <!-- Compare Dates -->
									<fmt:formatDate value="${scheduleMaster.scheduleStart}" pattern="dd/MM/yyyy" var="startDateValue" /> <fmt:formatDate value="${scheduleMaster.scheduleEnd}" pattern="dd/MM/yyyy" var="endDateValue" /> <c:if test="${startDateValue != endDateValue}">
										<spring:message code="viewActivityCalendar.to" />
										<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMaster.scheduleEnd}" />
									</c:if> <img class="pull-right panel-Exp-Col-Icon" alt="" src="${collapseIconSrc}">
								</a>
							</div>
							<div id="collapse-${scheduleMaster.scheduleID}" class="accordion-body collapse ${currentCollapse}">
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
																			<td class="highlight text-center span1"><spring:message code="viewActivityCalendar.ExpiresOn" /></td>
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
																<!-- get papers of current schedule -->
																<c:forEach var="paper" items="${currentSchedulePapers}">
																
																<c:choose>
															 		<c:when test="${paper.supervisorPwdStartExam == true}"> <c:set var="formActionCurrPp" value="../exam/AuthenticationGet" /></c:when>
															 		<c:otherwise><c:set var="formActionCurrPp" value="../exam/instruction" /></c:otherwise>
															 	</c:choose>

																	<!-- if it is FREE paper then put into WEEK -->
																	<c:set value="0" var="freePaperPanelSet" />
																	<c:choose>
																		<c:when test="${paper.freePaperStatus == 1 and scheduleMaster.scheduleType.ordinal() == 1}">
																			<c:set value="1" var="freePaperPanelSet" />
																		</c:when>
																	</c:choose>
																	<!-- check paper belong to  ScheduleType -->
																	<c:if test="${paper.displayCategoryLanguage.fkDisplayCategoryID==displayCategory.fkDisplayCategoryID and (paper.scheduleMaster.scheduleType==scheduleMaster.scheduleType or freePaperPanelSet==1) }">
																		<tr>
																			<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.scheduleMaster.scheduleStart}" var="datePointerStart" />
																			<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${paper.scheduleMaster.scheduleEnd}" var="datePointerEnd" />

																			<td><c:choose>
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
																					<c:when test="${paper.paperStatus==0 and paper.assessmentType!='Group' and paper.expiryDate != null}">
																						<span class="label label-success"><spring:message code="homepage.new" /></span>
																					</c:when>
																					<c:when test="${paper.paperStatus!=1 and paper.assessmentType!='Group' and paper.expiryDate != null}">
																						<span class="label label-important"><spring:message code="homepage.incomplete" /></span>
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
																			<td class="text-center"><a class="btn btn-red viewSyllabusBtn pull-left" data-value="${paper.paper.paperID}"><spring:message code="homepage.activeViewsyllabus" /></a> <!-- check if paper is combo test and it is in current schedule--> <c:choose>


																					<c:when test="${paper.paperStatus!=1 && paper.expiryDate != null && (paper.examEventPaperDetails.assessmentType=='Group' or paper.examEventPaperDetails.assessmentType=='Both') && paper.assessmentType=='Group' }">
																						<!--candidate which are not in Group but have group Paper  : disable it -->
																						<a class="btn btn-purple" href="#modalGroup-group" data-toggle="modal" data-backdrop="static"><spring:message code="homepage.GroupTest" /></a>
																					</c:when>
																					<c:when test="${paper.paperStatus!=1 and paper.expiryDate != null and paper.freePaperStatus==0}">
																						<c:choose>
																							<c:when test="${paper.paper.paperType == 'Typing'}">
																								<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																							</c:when>
																							<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																							
																								<form:form class="dashboardform examform" action="${formActionCurrPp}" method="POST">	
																									<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																							    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																									<%-- <button class="btn btn-blue practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																									<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a> 
																								</form:form>
																							</c:when>
																							<c:otherwise>
																								
																								<form:form class="dashboardform examform" action="${formActionCurrPp}" method="POST">	
																									<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																							    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																							    	<%-- <button class="btn btn-blue" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																							    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																								</form:form>
																							</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:when test="${paper.paperStatus!=1  and paper.expiryDate != null and paper.freePaperStatus==1 and paper.assessmentType=='Solo'}">
																						<c:choose>
																							<c:when test="${paper.paper.paperType == 'Typing'}">
																								<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																							</c:when>
																							<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																								
																									<form:form class="dashboardform examform"  action="${formActionCurrPp}" method="POST">	
																										<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																								    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																								    	<%-- <button class="btn btn-blue practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																								    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																									</form:form>	
																							</c:when>
																							<c:otherwise>
																							
																									<form:form class="dashboardform examform" action="${formActionCurrPp}" method="POST">		
																										<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																								    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																								    	<%-- <button class="btn btn-blue" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																								    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																									</form:form>
																							</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:when test="${paper.paperStatus!=1 and paper.candidateExam != null && paper.freePaperStatus==1 and paper.candidateExam.attemptNo > 1}">
																						<c:choose>
																							<c:when test="${paper.paper.paperType == 'Typing'}">
																								<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&clientid=${clientId}"><spring:message
																										code="homepage.takeATest" /></a>
																							</c:when>
																							<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																							
																								<form:form class="dashboardform examform" action="${formActionCurrPp}" method="POST">	
																									<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																							    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																							    	<%-- <button class="btn btn-blue practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																							    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}"><spring:message
																										code="homepage.takeATest" /></a>
																								</form:form>
																							</c:when>
																							<c:otherwise>
																							
																								<form:form class="dashboardform examform" action="${formActionCurrPp}" method="POST">	
																									<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																							    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																							    	<%-- <button class="btn btn-blue" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																							    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-blue lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}"><spring:message
																										code="homepage.takeATest" /></a>
																								</form:form>	
																							</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:when test="${paper.paperStatus!=1  and paper.candidateExam != null && paper.freePaperStatus==1}">
																						<!-- b=0 :dcid is present hence update  
																							 b=1 :dcid is not present hence insert -->
																						<c:choose>
																							<c:when test="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID] > 0}">
																								<c:choose>
																									<c:when test="${paper.paper.paperType == 'Typing'}">
																										<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-blue lnkFreeTakeTest typingTest"
																											data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=false&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																									</c:when>
																									<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																								
																											
																											<form:form class="dashboardform examform" action="${formActionCurrPp}" method="POST">	
																												<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																										    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																										    	<input type="hidden" name="b" value="false" />
																										    	<%-- <button class="btn btn-blue lnkFreeTakeTest practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																										    	<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-blue lnkFreeTakeTest practicalTest"
																												data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=false"><spring:message code="homepage.takeATest" /></a> 
																											</form:form>	
																									</c:when>
																									<c:otherwise>
																									
																											
																												<form:form  class="dashboardform examform" action="${formActionCurrPp}" method="POST">	
																													<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																											    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																											    	<input type="hidden" name="b" value="false" />
																											    	<%-- <button class="btn btn-blue lnkFreeTakeTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																											    	<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-blue lnkFreeTakeTest"
																											data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=false"><spring:message code="homepage.takeATest" /></a>
																												</form:form>	
																									</c:otherwise>
																								</c:choose>
																							</c:when>
																							<c:otherwise>
																								<c:choose>
																									<c:when test="${paper.paper.paperType == 'Typing'}">
																										<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-blue lnkFreeTakeTest typingTest"
																											data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=true&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																									</c:when>
																									<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																								
																										
																											<form:form class="dashboardform examform" action="${formActionCurrPp}" method="POST">	
																												<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																										    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																										    	<input type="hidden" name="b" value="true" />
																										    	<%-- <button class="btn btn-blue lnkFreeTakeTest practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																										    	<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-blue lnkFreeTakeTest practicalTest"
																												data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=true"><spring:message code="homepage.takeATest" /></a>
																											</form:form>	
																										
																									</c:when>
																									<c:otherwise>
																									
																											<form:form class="dashboardform examform"  action="${formActionCurrPp}" method="POST">	
																												<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																										    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																										    	<input type="hidden" name="b" value="true" />
																										    	<%-- <button class="btn btn-blue lnkFreeTakeTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																										    	<a id="lnkFreeTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" data-dcidcnt="${displayCategoryWiseAttemptsMap[paper.displayCategoryLanguage.fkDisplayCategoryID]}" class="btn btn-blue lnkFreeTakeTest"
																												data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&b=true"><spring:message code="homepage.takeATest" /></a> 
																											</form:form>	
																									</c:otherwise>
																								</c:choose>
																							</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:when test="${paper.paperStatus==1 and paper.examEventPaperDetails.showAnalysis==true}">
																						<a class="btn btn-warning" href="../ResultAnalysis/viewtestscore?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}&attemptNo=${paper.candidateExam.attemptNo}">&nbsp;&nbsp;&nbsp;<spring:message code="viewActivityCalendar.Analysis" />&nbsp;&nbsp;&nbsp;
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
												<spring:message code="viewActivityCalendar.NoCurrentWeekInfo" />
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
			<c:forEach var="scheduleMap" items="${nextScheduleMasterMap}">
				<div class="accordion-group">
					<div class="accordion-heading accordianColor_next">
						<a class="accordion-toggle  accordianColor_next" data-toggle="collapse" data-parent="#accordion2" href="#collapse-${scheduleMap.value.scheduleID}"> ${scheduleMap.value.scheduleName} : <fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMap.value.scheduleStart}" />&nbsp; <!-- Compare Dates -->
							<fmt:formatDate value="${scheduleMap.value.scheduleStart}" pattern="dd/MM/yyyy" var="startDateValue" /> <fmt:formatDate value="${scheduleMap.value.scheduleEnd}" pattern="dd/MM/yyyy" var="endDateValue" /> <c:if test="${startDateValue != endDateValue}">
								<spring:message code="viewActivityCalendar.to" />
								<fmt:formatDate pattern="${dateFormatForWeekPanel}" value="${scheduleMap.value.scheduleEnd}" />
							</c:if> <img class="pull-right panel-Exp-Col-Icon" alt="" src="${collapseIconSrc}"></a>

					</div>
					<div id="collapse-${scheduleMap.value.scheduleID}" class="accordion-body collapse">
						<div class="accordion-inner">

							<div class="box">
								<!-- <div class="box-header">Header</div> -->
								<c:set var="NoNextPaperFound" value="0" />
								<div class="box-body">
									<table class="table table-bordered table-complex">
										<tbody>
											<!-- get previous schedule displayCategory relation map -->
											<c:forEach var="scheduleDisplayCategoryRelMap" items="${nextScheduleDisplayCategoryRelMap}">

												<!-- relate schedule and displayCategory -->
												<c:if test="${scheduleMap.key==scheduleDisplayCategoryRelMap.key}">

													<!-- get displayCategorys list of schedule -->
													<c:forEach var="displayCategory" items="${scheduleDisplayCategoryRelMap.value}" varStatus="status">

														<c:set var="NoNextPaperFound" value="1" />
														<tr>
															<td class="highlight">${displayCategory.displayCategoryName}</td>
															<c:choose>
																<c:when test="${status.first}">
																	<td class="highlight text-center"><spring:message code="viewActivityCalendar.OpensOn" /></td>
																	<td class="highlight"></td>
																</c:when>
																<c:otherwise>
																	<td class="highlight"></td>
																	<td class="highlight"></td>
																</c:otherwise>
															</c:choose>
														</tr>

														<!-- get all papers of related displayCategorys And schedule -->
														<c:forEach var="paper" items="${nextSchedulePapers}">
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
																	<td class="text-center span1"><a class="btn btn-red viewSyllabusBtn" data-value="${paper.paper.paperID}"><spring:message code="homepage.activeViewsyllabus" /></a></td>
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
									<spring:message code="viewActivityCalendar.ScheduleInfo" />
								</div>
								<c:set var="NoNextPaperFound" value="1" />
							</c:if>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
		<br />

		<c:if test="${currentExamEvent.isGroupEnabled != null and currentExamEvent.isGroupEnabled==true}">
			<div style="text-align: center; position: relative; padding-bottom: 0px">
				<p>
					<i class="icon-user "></i>
					<spring:message code="homapage.solopaper" />
					&nbsp;&nbsp;<i class="icon-def-group"></i>
					<spring:message code="homapage.grouppaper" />
					<br /> &nbsp;&nbsp;
				</p>
			</div>
		</c:if>
		<br />
		<c:if test="${noDataToDisplay!=1 and hideCalender!=true}">
			<table align="center">
				<tr>
					<td><span style="background-color: #a2a2a2; width: 18px; height: 18px; border: 1px solid;">&nbsp;&nbsp;&nbsp; &nbsp;</span></td>
					<td>&nbsp;<spring:message code="viewActivityCalendar.previousweekindicator"></spring:message>&nbsp;&nbsp;
					</td>
					<td><span style="background-color: #4da04e; width: 18px; height: 18px; border: 1px solid">&nbsp;&nbsp;&nbsp; &nbsp;</span></td>
					<td>&nbsp;<spring:message code="viewActivityCalendar.activeweekindicator"></spring:message>&nbsp;&nbsp;
					</td>
					<td><span style="background-color: #61a1e3; width: 18px; height: 18px; border: 1px solid">&nbsp;&nbsp;&nbsp; &nbsp;</span></td>
					<td>&nbsp;<spring:message code="viewActivityCalendar.nextweekindicator"></spring:message>&nbsp;&nbsp;
					</td>
				</tr>
			</table>
		</c:if>

	</fieldset>

	<!-- common home  page -->
	<%@include file="commonhomepage.jsp"%>

	<script type="text/javascript">
		$(function() {

			//remove box table if empty
			$(".allWeekPanel").find(".NoPaperFoundDiv").each(function() {
				$(this).parent().find(".box").remove();
			});

			var collapseIconSrc = "${collapseIconSrc}";
			var expandIconSrc = "${expandIconSrc}";
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

			//modal setting
			//	$("#endTestConfirmModal").modal({ backdrop: 'static', keyboard: true });

		});
	</script>
</body>
</html>
