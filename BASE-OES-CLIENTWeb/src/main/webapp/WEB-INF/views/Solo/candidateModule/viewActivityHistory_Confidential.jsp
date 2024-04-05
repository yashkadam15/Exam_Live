<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:choose>
	<c:when test="${fn:length(nonActivePapers) != 0}">
		<div class="box">
			<div class="box-header">
				<h4>
					<spring:message code="homepage.historyTitle" />
				</h4>
				</br> </br>
			</div>
			<div class="box-body">
				<table class="table table-bordered table-complex">
					<c:set var="attemptStatusHeader" value="0" />
					<!-- get exam event map -->
					<%-- <c:forEach var="examMap" items="${nonActiveExamEventMap}"> --%>
					<thead>
						<tr>
							<th colspan="3" class="text-left">${currentExamEvent.name}</th>
						</tr>
					</thead>
					<tbody>
						<!-- relate exam-display Category -->
						<%-- 	<c:forEach var="examDisplayCatgoryRel" items="${nonActiveExamDisplayCategoryRelationMap}"> --%>

						<%-- <c:if test="${examDisplayCatgoryRel.key==examMap.key}"> --%>

						<!-- get list of display Category from map  -->
						<%-- <c:forEach var="displayCategoryID" items="${examDisplayCatgoryRel.value}"> --%>
						<c:forEach var="displayCategoryName" items="${nonActiveDisplayCategoryMap}">

							<%-- <c:if test="${displayCategoryID==displayCategoryName.key }"> --%>
							<tr>
								<td class="highlight span3">${displayCategoryName.value}</td>
								<c:choose>
									<c:when test="${attemptStatusHeader!=1}">
										<c:set var="attemptStatusHeader" value="1" />
										<td class="highlight text-center span1"><spring:message code="viewActivityCalendar.attemptDate" /></td>
										<td class="highlight span2 text-center">
										<!--Display button for Personality profiling test(event id=54 and total papers=7 and single display category) -->
											<c:if test="${currentExamEvent.examEventID==54}">
												<c:choose>
													<c:when test="${countOfCompletedPapers==7}">
														<a class="btn btn-blue pull-center" href="../profilingTestReport/candidateProfilingTestReport?candidateUserName=${candidate.candidateCode}" target="_blank"><spring:message code="viewtestscoreForKlick.PrintCertificate" /></a>
													</c:when>
													<c:otherwise>
														<a class="btn btn-disabled pull-center" href="javascript:void(0);"><spring:message code="viewtestscoreForKlick.PrintCertificate" /></a>
													</c:otherwise>
												</c:choose>
												
											</c:if>
										</td>
									</c:when>
									<c:otherwise>
										<td class="highlight span1"></td>
										<td class="highlight span2"></td>
									</c:otherwise>
								</c:choose>
							</tr>

							<c:forEach var="paper" items="${nonActivePapers}">
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
												<c:when test="${paper.paperStatus == 3 and paper.assessmentType!='Group'}">
													<span class="label label-important">Exam Withheld</span>
												</c:when>

											</c:choose> &nbsp;&nbsp;${paper.paper.name} <c:choose>
												<c:when test="${paper.examEventPaperDetails != null and paper.examEventPaperDetails.noOfAttempts == 2}">
													<span class="label label-attempt"><spring:message code="homepage.Attempt" /> #${paper.candidateExam.attemptNo}</span>
												</c:when>
											</c:choose></td>
										<td class="text-center"><c:if test="${paper.candidateExam != null and paper.candidateExam.attemptDate != null }">
												<fmt:formatDate pattern="${dateFormatForAllPapers}" value="${paper.candidateExam.attemptDate}" />&nbsp;
																			</c:if></td>
										<td class="text-center"><%-- <a class="btn btn-red viewSyllabusBtn"  data-value="${paper.paper.paperID}" ><spring:message code="homepage.activeViewsyllabus" /></a> --%>  
											<c:choose>
												<c:when test="${paper.paper.paperType=='Typing'}">
													<a class="btn btn-warning" href="../ResultAnalysis/viewtestscore?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}&attemptNo=${paper.candidateExam.attemptNo}&ceid=${paper.candidateExam.candidateExamID}&showtypsc=1">&nbsp;&nbsp;&nbsp;<spring:message code="homepage.details" />&nbsp;&nbsp;&nbsp;
													</a>
												</c:when>
												<c:otherwise>
													<a class="btn btn-warning" href="../endexam/showTestResult?examEventID=${paper.examEvent.examEventID}&paperID=${paper.paper.paperID}&attemptNo=${paper.candidateExam.attemptNo}&ceid=${paper.candidateExam.candidateExamID}">&nbsp;&nbsp;&nbsp;<spring:message code="homepage.details" />&nbsp;&nbsp;&nbsp;
													</a>
												</c:otherwise>
											</c:choose>
											
											</td>
									</tr>
								</c:if>
							</c:forEach>
							<%-- </c:if> --%>
						</c:forEach>

						<%-- 	</c:forEach>
												</c:if>

											</c:forEach> --%>
						<%-- <tr>
							<td colspan="3"><a class="btn btn-blue pull-left btn-mini" href="javascript:post_to_url('${currentExamEvent.examEventID}','0')"><spring:message code="homepage.More" /></a></td>
						</tr> --%>
						<%-- </c:forEach> --%>
					</tbody>
				</table>
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<div class="alert alert-info">
			<a class="close" data-dismiss="alert" href="#">&times;</a> <span><spring:message code="homepage.NoHistoryTitle" /> : </span>
			<spring:message code="homepage.NoHistoryInfo" />
		</div>
	</c:otherwise>
</c:choose>

<c:if test="${currentExamEvent.isGroupEnabled != null and currentExamEvent.isGroupEnabled==true}">
	<div style="text-align: center; position: relative; padding-bottom: 0px">
		<p>
			<i class="icon-user "></i> <spring:message code="homapage.solopaper" />&nbsp;&nbsp;<i class="icon-def-group"></i>  <spring:message code="homapage.grouppaper" /><br /> &nbsp;&nbsp;
		</p>
	</div>
</c:if>

<script type="text/javascript">
		$(document).ready(function() {
			$('#btn-wkremaining').popover({
				html : true,
				placement : 'bottom',
				trigger : 'hover',
				//  title : 'Week Remaining',
				content : function() {
					return $('#data-content-wkremaining').html();
				}
			});
			$('#btn-spclwkused').popover({
				html : true,
				placement : 'bottom',
				trigger : 'hover',
				// title : 'Special Week Used',
				content : function() {
					return $('#data-content-spclwkused').html();
				}
			});
			$('#btn-testattempted').popover({
				html : true,
				placement : 'bottom',
				trigger : 'hover',
				// title : 'Tests Attempted',
				content : function() {
					return $('#data-content-testattempted').html();
				}
			});
		});
	</script>