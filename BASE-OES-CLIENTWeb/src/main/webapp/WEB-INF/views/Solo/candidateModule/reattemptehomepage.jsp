<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="homepage.PageTitle" /></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
a {
	cursor: pointer;
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

	<c:set value="dd-MMM-yyyy" var="dateFormatForAllPapers" />
	<fieldset class="well">

		<legend>
			<span><img src="<c:url value="../resources/images/dashboard.png"></c:url>" alt=""> <spring:message code="homepage.MyHome" /> <c:if test="${currentExamEvent.eventCategory == 'TestSeries' }">
					<span class="pull-right"><spring:message code="reattemptHomePage.testSeries" /> <fmt:formatDate pattern="${dateFormatForAllPapers}" value="${currentExamEvent.endDate}" /></span>
				</c:if>
		</legend>

		<div class="holder">

			<c:if test="${currentExamEvent.localSchedular == 'Candidate' }">

				<c:if test="${currentExamEvent.noofBonusWeek > 0}">

					<div class="alert alert-info">
						<a class="close" data-dismiss="alert" href="#">&times;</a>
						<spring:message code="homepage.bonuswkinfo.1" />
						<b>${currentExamEvent.maxPapersScheduleByCandidate} <spring:message code="homepage.bonuswkinfo.2" /></b>
						<spring:message code="homepage.bonuswkinfo.3" />
						<b>${currentExamEvent.maxPapersScheduleByCandidate} <spring:message code="homepage.bonuswkinfo.4" /></b>
						<spring:message code="homepage.bonuswkinfo.5" />
						<b>${currentExamEvent.maxPapersforBonusWeek} <spring:message code="homepage.bonuswkinfo.6" /></b>
						<spring:message code="homepage.bonuswkinfo.7" />
						<b>${currentExamEvent.noofBonusWeek} <spring:message code="homepage.bonuswkinfo.8" />
						</b>
						<spring:message code="homepage.bonuswkinfo.9" />
					</div>

					<!-- get remaining special weeks -->
					<c:set var="spwrcnt" value="${currentExamEvent.noofBonusWeek-availableNumberOfBonusWeek}" />

					<!-- if weeks remaining less than special weeks then both will be weeks remaining -->
					<c:if test="${remainingWeekCount < spwrcnt }">
						<c:set var="spwrcnt" value="${remainingWeekCount}" />
					</c:if>


					<div class="quick-nav">
						<div class="btn btn-grey" id="btn-wkremaining">
							<h1 style="color: #007251">${remainingWeekCount}</h1>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<spring:message code="homepage.WeeksRemaining" />
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</div>
						&nbsp;&nbsp;&nbsp;
						<div class="btn btn-grey" id="btn-spclwkused">
							<h1 style="color: #ec3a0f">${spwrcnt}</h1>
							<spring:message code="homepage.SpecialWeeksUsed" />
						</div>
						&nbsp;&nbsp;&nbsp;
						<div class="btn btn-grey" id="btn-testattempted">
							<h1 style="color: #297dbc">${totalPaperCnt-attemptedPaperCnt}</h1>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<spring:message code="homepage.TestsAttempted" />
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</div>
					</div>


					<div id="data-content-wkremaining" style="display: none">
						<div style="font-size: 12px;">
							<spring:message code="homepage.bonuswkinfo.weekremain.info" />
						</div>
					</div>
					<div id="data-content-spclwkused" style="display: none;">
						<div style="font-size: 12px;">
							<%--  <spring:message code="homepage.bonuswkinfo.weekused.info.1" /> <b>/</b> <spring:message code="homepage.bonuswkinfo.weekused.info.2" /> </br> --%>
							<spring:message code="homepage.bonuswkinfo.weekused.info.3" />
							<b>${currentExamEvent.maxPapersScheduleByCandidate} <spring:message code="homepage.bonuswkinfo.weekused.info.4" />
							</b>
							<spring:message code="homepage.bonuswkinfo.weekused.info.5" />
							<b> ${currentExamEvent.maxPapersforBonusWeek} <spring:message code="homepage.bonuswkinfo.weekused.info.6" />
							</b>
							<spring:message code="homepage.bonuswkinfo.weekused.info.7" />
							</br>
							<spring:message code="homepage.bonuswkinfo.weekused.info.8" />
						</div>
					</div>
					<div id="data-content-testattempted" style="display: none">
						<div style="font-size: 12px;">
							<spring:message code="homepage.bonuswkinfo.paperattempted.info.1" />
						</div>
					</div>
				</c:if>
			</c:if>

			<div id="tabbable">
				<ul class="nav nav-tabs " id="myTab">
					<li><a href="../candidateModule/homepage" class="tab_text" style="text-transform: uppercase; font-weight: normal; text-shadow: 1px 1px 0 #ffffff;"><spring:message code="homepage.activetests" /></a></li>
					<li class="active"><a href="#" class="tab_text" style="text-transform: uppercase; font-weight: normal; text-shadow: 1px 1px 0 #ffffff;"><spring:message code="homepage.reattemTab" /></a></li>
				</ul>
			</div>


			<div id="showScheduledPapers">
				<c:choose>
					<c:when test="${fn:length(activeReattemptPapers) != 0}">
						<div class="box">
							<!-- <div class="box-header">
								<h4>Active Re-Attempt Papers</h4>
								<br> <br>
							</div> -->
							<div class="box-body">
								<table class="table table-bordered table-complex" style="border-top: 0;">

									<!-- get exam event map -->
									<%-- 	<c:forEach var="examMap" items="${examEventMap}"> --%>
									<thead>
										<tr>
											<th colspan="3" class="text-left">${currentExamEvent.name}<a class="btn btn-blue pull-right" href="javascript:post_to_url('${currentExamEvent.examEventID}','1')"><spring:message code="homepage.viewActivitycalender" /></a></th>
										</tr>
									</thead>
									<tbody>
										<!-- relate exam-display Category -->
										<%-- 	<c:forEach var="examDisplayCatgoryRel" items="${examDisplayCategoryRelationMap}">

												<c:if test="${examDisplayCatgoryRel.key==examMap.key}">

													<!-- get list of display Category from map  -->
													<c:forEach var="displayCategoryID" items="${examDisplayCatgoryRel.value}" varStatus="headerStatus"> --%>
										<c:forEach var="displayCategoryName" items="${displayCategoryMap}" varStatus="status">
											<%-- <c:if test="${displayCategoryID==displayCategoryName.key }"> --%>
											<tr>
												<td class="highlight span3">${displayCategoryName.value}</td>
												<c:choose>
													<c:when test="${status.first}">
														<td class="highlight text-center span1">&nbsp;&nbsp;&nbsp;<spring:message code="homepage.exiresOn" />&nbsp;&nbsp;&nbsp;
														</td>
														<td class="highlight span2"></td>
													</c:when>
													<c:otherwise>
														<td class="highlight span1"></td>
														<td class="highlight span2"></td>
													</c:otherwise>
												</c:choose>

											</tr>

											<c:forEach var="paper" items="${activeReattemptPapers}">
											
												<c:choose>
											 		<c:when test="${paper.supervisorPwdStartExam == true}"> <c:set var="formAction" value="../exam/AuthenticationGet" /></c:when>
											 		<c:otherwise><c:set var="formAction" value="../exam/instruction" /></c:otherwise>
											 	</c:choose>
												
												<!-- get paper from corresponding exam And display Category -->
												<c:if test="${paper.examEvent.examEventID==currentExamEvent.examEventID and paper.displayCategoryLanguage.fkDisplayCategoryID==displayCategoryName.key }">
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
																	<span class="label label-attempt"><spring:message code="homepage.Attempt" /> #${paper.candidateExam.attemptNo}</span>
																</c:when>
															</c:choose> <!-- show paper status : new,not complete or complete --> <c:choose>

																<c:when test="${paper.paperStatus==0 and paper.assessmentType!='Group'}">
																	<span class="label label-success"><spring:message code="homepage.new" /></span>
																</c:when>
																<c:when test="${paper.paperStatus!=0 and paper.assessmentType!='Group'}">
																	<span class="label label-important"><spring:message code="homepage.incomplete" /></span>
																</c:when>
																<c:when test="${paper.paperStatus == 0 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																	<span class="label label-success"><spring:message code="viewActivityCalendar.new" /></span>
																</c:when>
																<c:when test="${paper.paperStatus == 2 and paper.assessmentType =='Group' && paper.expiryDate != null}">
																	<span class="label label-important"><spring:message code="homepage.incomplete" /></span>
																</c:when>
																<c:when test="${paper.freePaperStatus==1}">
																	<span class="label label-success"><spring:message code="homepage.new" /></span>
																</c:when>
															</c:choose></td>
														<td class="text-center"><c:if test="${paper.expiryDate != null}">
																<fmt:formatDate pattern="${dateFormatForAllPapers}" value="${paper.expiryDate}" />
															</c:if></td>
														<td class="text-center"> <a class="btn btn-red viewSyllabusBtn"  data-value="${paper.paper.paperID}" ><spring:message code="homepage.activeViewsyllabus" /></a> <c:choose>


																<c:when test="${paper.paper.name!=null && (paper.examEventPaperDetails.assessmentType=='Group' or paper.examEventPaperDetails.assessmentType=='Both') && paper.labSessionGroupID == 0 && paper.assessmentType=='Group' }">
																	<!--candidate which are not in Group but have group Paper  : disable it -->
																	<a class="btn btn-disabled" href="#modalGroup-${paper.labSessionGroupID}" data-toggle="modal" data-backdrop="static"><spring:message code="homepage.GroupTest" /></a>
																</c:when>
																<c:when test="${paper.expiryDate != null && paper.examEventPaperDetails.assessmentType=='Group' && paper.labSessionGroupID > 0 }">
																	<a class="btn btn-purple" href="#modalGroup-${paper.labSessionGroupID}" data-toggle="modal" data-backdrop="static"> <spring:message code="homepage.GroupTest" /></a>
																</c:when>
																<c:when test="${paper.expiryDate != null && paper.examEventPaperDetails.assessmentType=='Both' && paper.labSessionGroupID > 0 && paper.assessmentType=='Group'}">
																	<a class="btn btn-purple" href="#modalGroup-${paper.labSessionGroupID}" data-toggle="modal" data-backdrop="static"><spring:message code="homepage.GroupTest" /></a>
																</c:when>
																<c:when test="${paper.expiryDate != null and paper.freePaperStatus==0}">
																	<c:choose>
																		<c:when test="${paper.paper.paperType == 'Typing'}">
																			<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																		</c:when>
																		<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																			
																			 <form:form class="dashboardform examform" action="${formAction}" method="POST">	
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																				<%-- <button class="btn btn-greener practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																				<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																			</form:form>
																		</c:when>
																		<c:otherwise>
																		
																			 <form:form class="dashboardform examform" action="${formAction}" method="POST" >	
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																				<%-- <button class="btn btn-greener" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																				<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a>
																			</form:form>
																		</c:otherwise>
																	</c:choose>
																</c:when>
																<c:when test="${paper.expiryDate != null and paper.freePaperStatus==1 and paper.assessmentType=='Solo'}">
																	<c:choose>
																		<c:when test="${paper.paper.paperType == 'Typing'}">
																			<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}&clientid=${clientId}"><spring:message code="homepage.takeATest" /></a>
																		</c:when>
																		<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																			
																			 <form:form class="dashboardform examform" action="${formAction}" method="POST">	
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																				<%-- <button class="btn btn-greener practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																				<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a> 
																			</form:form>
																		</c:when>
																		<c:otherwise>
																			
																			<form:form class="dashboardform examform" action="${formAction}" method="POST">	
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="se" value="${paper.expiryDate.time}" />
																		    	<%-- <button class="btn btn-greener" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																		    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&se=${paper.expiryDate.time}"><spring:message code="homepage.takeATest" /></a> 
																			</form:form>
																		</c:otherwise>
																	</c:choose>
																</c:when>
																<c:when test="${paper.candidateExam != null && paper.freePaperStatus==1}">

																	<c:choose>
																		<c:when test="${paper.paper.paperType == 'Typing'}">
																			<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn typingTest" data-lnk="typ:url?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}&clientid=${clientId}"><spring:message
																					code="homepage.takeATest" /></a>
																		</c:when>
																		<c:when test="${paper.paper.paperType == 'DifficultyLevelWiseExam'}">
																			
																	 		<form:form class="dashboardform examform" action="${formAction}" method="POST">	
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																		    	<%-- <button class="btn btn-greener practicalTest" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																		    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn practicalTest" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}"><spring:message code="homepage.takeATest" /></a>
																			</form:form>	
																			
																		</c:when>
																		<c:otherwise>
																			
																			<form:form  class="dashboardform examform" action="${formAction}" method="POST">		
																				<input type="hidden" name="ceid" value="${paper.candidateExam.candidateExamID}" />
																		    	<input type="hidden" name="dcid" value="${paper.displayCategoryLanguage.fkDisplayCategoryID}" />
																		    	<%-- <button class="btn btn-greener" type="submit" id="btnTakeATest"><spring:message code="homepage.takeATest" /></button> --%>
																		    	<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-greener lnkTakeTestbtn" data-lnk="../exam/Authentication?ceid=${paper.candidateExam.candidateExamID}&dcid=${paper.displayCategoryLanguage.fkDisplayCategoryID}"><spring:message code="homepage.takeATest" /></a>
																			</form:form>
																			
																		</c:otherwise>
																	</c:choose>
																</c:when>
															</c:choose></td>
													</tr>
												</c:if>

											</c:forEach>

											<%-- </c:if> --%>

										</c:forEach>
										<%-- 	</c:forEach>
												</c:if>

											</c:forEach>
									</c:forEach> --%>
									</tbody>

								</table>
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<br />
						<div class="alert alert-info">
							<a class="close" data-dismiss="alert" href="#">&times;</a>
							<spring:message code="homepage.noreattemptpaperavailable" />
						</div>
					</c:otherwise>
				</c:choose>


				<!-- common history page -->
				<%@include file="viewActivityHistory.jsp"%>

			</div>

		</div>


	</fieldset>

	<!-- common home  page -->
	<%@include file="commonhomepage.jsp"%>

</body>
</html>
