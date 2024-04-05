<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title> <spring:message code="attemptedPaperTestReport.title" /> </title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
</style>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="attemptedPaperTestReport.heading" /> - ${candidateName} <%-- <spring:message code="scheduleExam.Title"> </spring:message> --%></span>
			</legend>
		</div>
		
		<div class="holder">
			<c:if test="${mapDisplayCategory !=null && fn:length(mapDisplayCategory)>0 }">
						
				<table class="table table-bordered table-complex" id="tblResultAnalysis">
						<thead>
							<tr class="info">
								<th colspan="2" class="text-left">${examEvent.name }</th>
								
							</tr>
						</thead>
						<tbody>
							
							<c:forEach var="mapdisplaycategory" items="${mapDisplayCategory}" varStatus="status">
							<tr >
								<td class="highlight" colspan="2">${mapdisplaycategory.value}</td>
								
							</tr>
							
								<c:if test="${mapDisplayCategoryExamDisplayCategoryPaper !=null && fn:length(mapDisplayCategoryExamDisplayCategoryPaper)>0 }">
									<c:forEach var="mapdisplaycategorypaper" items="${mapDisplayCategoryExamDisplayCategoryPaper}">
										<c:if test="${mapdisplaycategory.key==mapdisplaycategorypaper.key}">
											<c:forEach var="list" items="${mapdisplaycategorypaper.value}">
												<%-- <c:forEach var="ExamDisplayCategoryPaper" items="${list}"> --%>
												<tr>
												<td class="span3 ">${list.examEventPaperDetails.paper.name}
												<!-- Display attempt details for solo papers not to group papers -->
												<c:if test="${list.assessmentType!='Group'}">
													 (Attempt #${list.candidateExam.attemptNo})
												</c:if>
												
												</td>
												<td class="span1">										
													<c:choose>
														<c:when test="${list.examEventPaperDetails.showAnalysis==true}">
															<a class="btn btn-warning pull-right" href="../ResultAnalysis/viewtestscore?examEventId=${examEvent.examEventID}&paperId=${list.examEventPaperDetails.paper.paperID}&candidateId=${candidateId}&collectionId=${collectionId}&displayCategoryId=${displayCategoryId}&attemptNo=${list.candidateExam.attemptNo}"><spring:message code="attemptedPaperTestReport.Analysis" /></a>
														</c:when>
														<%-- <c:otherwise>
															<a class="btn btn-warning pull-right" disabled="disabled"><spring:message code="attemptedPaperTestReport.Analysis"/></a>
														</c:otherwise> --%>
													</c:choose>
												</td>
												</tr>
												<%-- </c:forEach> --%>
											</c:forEach>
										</c:if>
									</c:forEach>
								</c:if>
							
							</c:forEach>
							<tr >
								<td class="highlight" colspan="2"><a class="btn btn-blue pull-right" href="../TestReport/CandidateTestReportlist?examEventSelect=${examEvent.examEventID}&collectionId=${collectionId}&displayCategorySelect=${displayCategoryId}"><spring:message code="global.back" /></a></td>
								
							</tr>
						</tbody>
					</table>
			</c:if>
		</div>
		</fieldset>
	
</body>
</html>