<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="presentreport.label" /></title>
<spring:message code="project.resources" var="resourcespath" />


<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
<style>
.top-buffer {
	margin-top: 0px;
}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		examEventID = $('#examEventSelect').val();
		paperId = $('#paperId').val();
		/* examEvent change event */
		$('#examEventSelect').change(function(event) {
			examEventID = $('#examEventSelect').val();
			console.log("exam eventID ::" + examEventID);
			var dat = JSON.stringify({
				"examEventID" : examEventID
			});
			if (examEventID != -1) {
				callExamEventAjax(dat, undefined);
			}

		});
	});
</script>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="presentreport.examWiseLabel" /></span>
			</legend>
		</div>

		<div class="holder">
			<div>
				<form:form class="form-horizontal" action="prAbsReport" method="post"
					onsubmit="return validate();">

					<div class="control-group">
						<label class="control-label"><spring:message
								code="candidateTestReport.examEvent"></spring:message></label>
						<div class="controls">
							<select class="span4" id="examEventSelect" name="examEventSelect">
								<%-- <c:if test="${activeExamEventList !=null && fn:length(activeExamEventList)>1}">
								<option value="-1" selected="selected"><spring:message code="candidateTestReport.selectExamEvent"></spring:message></option>	
							</c:if> --%>
								<option value="-1" selected="selected">
									<spring:message code="candidateTestReport.selectExamEvent"></spring:message>
								</option>
								<c:forEach items="${activeExamEventList }" var="eObj">
									<c:choose>
										<c:when test="${eObj.examEventID==examEventId}">
											<option value="${eObj.examEventID}" selected="selected">${eObj.name}</option>
										</c:when>
										<c:otherwise>
											<option value="${eObj.examEventID}">${eObj.name}</option>
										</c:otherwise>

									</c:choose>
								</c:forEach>
							</select>
						</div>
					</div>

					<div id="paper">
						<label class="control-label" for="paperName" id="paper-lbl"><spring:message code="scoreCard.Paper" /></label>
						<div class="controls">
							<input type="hidden" id="paperId" name="paperId"
								value="${paperId}"> <select class="span4"
								id="paperSelect" name="paperSelect">
							</select>
						</div>
						<br>

					</div>
					<div>
						<div align="center">
							<button type="submit" class="btn btn-blue"
								style="text-align: center;">
								<spring:message code="presentreport.viewreport" />
							</button>

							<!-- back button form -->
							<c:if
								test="${presentAbsentVMList !=null && fn:length(presentAbsentVMList)!=0}">
								<form:form action="prAbsReport" method="post">

									<input type="hidden" id="paperSelect" name="paperSelect"
										value="${paperId}" />
									<input type="hidden" id="examEventSelect"
										name="examEventSelect" value="${examEventId}" />
									<button type="submit" class="btn btn-blue pull-right">
										<spring:message code="presentreport.back" />
									</button>

								</form:form>
							</c:if>
						</div>
					</div>



				</form:form>




			</div>
		</div>
	</fieldset>

	<fieldset class="well">
		<div class="holder">

			<c:if test="${prAbsReportVM !=null and presentAbsentVMList== null}">
				<!--Integrated data table  -->
				<c:set var="srNo" value="1" scope="page" />
				<table class="table table-striped table-bordered">
					<thead>

						<tr>
							<th><spring:message code="peerAssessment.paperName" /></th>
							<th><spring:message
									code="admindashboard.AllocatedCandidates" /></th>
							<th><spring:message code="presentreport.presentCandidates" /></th>
							<th><spring:message code="presentreport.absentCandidates" /></th>

						</tr>
					</thead>


					<tbody>
						<tr>
							<td>${prAbsReportVM.paperName}</td>
							<td><a
								href="candidateWiseprAbsReport?paperID=${paperId}&eventID=${examEventId}&flag=2" class="candCount">${prAbsReportVM.allocatedCandidates}</a></td>
							<td><a
								href="candidateWiseprAbsReport?paperID=${paperId}&eventID=${examEventId}&flag=0" class="candCount">${prAbsReportVM.presentCandidates}</a></td>
							<td><a
								href="candidateWiseprAbsReport?paperID=${paperId}&eventID=${examEventId}&flag=1" class="candCount">${prAbsReportVM.absentCandidates}</a></td>
						</tr>


					</tbody>


				</table>



			</c:if>


			<c:if
				test="${presentAbsentVMList !=null && fn:length(presentAbsentVMList)!=0}">



				<%-- 
<div class="controls pull-right">

						<a href="prAbsReport?paperSelect=${paperid}&examEventSelect=${examEventId}"  class="btn btn-blue">Back</a>
					</div> --%>

				<!--Integrated data table  -->
				<%-- <c:set var="srNo" value="1" scope="page" /> --%>
				<c:set var="srNo" value="${pagination.start+1}" scope="page" />
				<table class="table table-striped table-bordered">
					<thead>
						<tr>
							<th colspan="5" style="background-color: #338D93; color: #fff">
								<c:choose>
									<c:when test="${flag=='0'}">
										<spring:message code="presentreport.forpaperInfo" />
									</c:when>
									<c:when test="${flag=='1'}">
										<spring:message code="absentreport.forpaperInfo" />
									</c:when>
									<c:when test="${flag=='2'}">
										<spring:message code="presentabsentreport.forpaperInfo" />
									</c:when>


								</c:choose> <b>${prAbsViewModel.paperName}</b>

							</th>

						</tr>
						<tr>
							<th colspan="5"><spring:message
									code="presentreport.examCenterName" /> : <b>${centerName}</b></th>
						</tr>
						<tr>
							<th><spring:message code="candidateTestReport.srNo" /></th>
							<th><spring:message code="incompleteexams.CandidateCode" /></th>
							<th><spring:message code="canidateName.label" /></th>
							<th><spring:message code="Exam.Username" /></th>
							<th><spring:message code="presentreport.status" /></th>

						</tr>
					</thead>
					<tfoot>

						<tr>
							<th><spring:message code="candidateTestReport.srNo" /></th>
							<th><spring:message code="incompleteexams.CandidateCode" /></th>
							<th><spring:message code="canidateName.label" /></th>
							<th><spring:message code="Exam.Username" /></th>
							<th><spring:message code="presentreport.status" /></th>
						</tr>
						<tr>
							<td colspan="5" style="background-color: #338D93; color: #fff"><p
									align="center"><spring:message code="presentAbsentReport.totalPresent" />
									-&nbsp;${prAbsViewModel.presentCandidates}
									&nbsp;&nbsp;|&nbsp;&nbsp;<spring:message code="presentAbsentReport.totalAbsent" />
									-&nbsp;${prAbsViewModel.absentCandidates}</p></td>
						</tr>
					</tfoot>

					<tbody>
						<c:forEach items="${presentAbsentVMList}" var="candDetails"
							varStatus="status">
							<tr>
								<td>${srNo}<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${candDetails.candidateCode}</td>
								<td>${candDetails.candidateName}</td>
								<td>${candDetails.userName}</td>
								<td><c:choose>
										<c:when test="${candDetails.presentStatus}">
											<spring:message code="presentreport.present" />
										</c:when>
										<c:otherwise>
											<p style="color: red;">
												<spring:message code="presentreport.absent" />
											</p>
										</c:otherwise>
									</c:choose></td>
							</tr>
						</c:forEach>

					</tbody>


				</table>


				<!-- pagination  -->
				<c:if test="${fn:length(presentAbsentVMList) != 0}">
					<!--Display count of records  -->
					<div class="span5">
						<spring:message code="global.pagination.showing"></spring:message>
						${pagination.start+1} - ${pagination.end}
						<spring:message code="global.pagination.of"></spring:message>
						<c:choose>
							<c:when test="${disableNext==true}">
							${pagination.end}
						</c:when>
							<c:otherwise>
								<spring:message code="list.Many" />
							</c:otherwise>
						</c:choose>
					</div>

					<!--Display pagination buttons  -->
					<div class="dataTables_paginate paging_bootstrap pagination"
						align="right">
						<ul>
							<c:choose>
								<c:when
									test="${disablePrev==true || (fn:length(presentAbsentVMList)<=pagination.recordsPerPage && pagination.start==0)}">
									<li class="prev"><a href="#" id="prev_anchor_tag"
										style="display: none;">← <spring:message
												code="global.previous"></spring:message>
									</a></li>
								</c:when>
								<c:otherwise>
									<li class="prev"><a href="#" id="prev_anchor_tag">← <spring:message
												code="global.previous"></spring:message>
									</a></li>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${disableNext==true}">
									<li class="next"><a href="#" id="next_anchor_tag"
										style="display: none;"><spring:message code="global.next"></spring:message>
											→ </a></li>
								</c:when>
								<c:otherwise>
									<li class="next"><a href="#" id="next_anchor_tag"><spring:message
												code="global.next"></spring:message> → </a></li>
								</c:otherwise>
							</c:choose>
						</ul>
						<!--Form For previous,next buttons  -->
						<form:form action="prev" method="POST" modelAttribute="pagination"
							id="prev_selector_for_the_form" name="prev_selector_for_the_form">
							<form:hidden path="end" />
							<form:hidden path="start" />
							<form:hidden path="recordsPerPage" />

							<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}">
							<input type="hidden" id="paperId" name="paperId" value="${paperId}">
							<input type="hidden" id="flag" name="flag" value="${flag}">
							<input type="hidden" id="searchText" name="searchText"
								value="${searchText}" />

						</form:form>
						<form:form action="next" method="POST" modelAttribute="pagination"
							id="next_selector_for_the_form">
							<form:hidden path="end" />
							<form:hidden path="start" />
							<form:hidden path="recordsPerPage" />

							<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}">
							<input type="hidden" id="paperId" name="paperId" value="${paperId}">
							<input type="hidden" id="flag" name="flag" value="${flag}">
							<input type="hidden" id="searchText" name="searchText"
								value="${searchText}" />
						</form:form>
					</div>
				</c:if>


			</c:if>



		</div>
	</fieldset>

	<script type="text/javascript">
		$(document).ready(function() {

			examEventID = $('#examEventSelect').val();
			paperId = $('#paperId').val();

			if ($('#examEventSelect').val() != -1) {
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				if (examEventID != -1) {
					callExamEventAjax(dat, paperId);
				}

				var dat1 = JSON.stringify({
					"examEventID" : examEventID,
					"fkPaperID" : paperId
				});
				/* 	if (examEventID != -1 && paperId != -1) {
						callPaperAjax(dat1, attemptDate);
					} */
			}

			/* examEvent change event */
			$('#examEventSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				console.log("exam eventID ::" + examEventID);
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				if (examEventID != -1) {
					callExamEventAjax(dat, undefined);
				}

			}); // end of examEventSelect change event

			/* paper change event */
			$('#paperSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				paperId = $('#paperSelect').val();
				var dat = JSON.stringify({
					"examEventID" : examEventID,
					"fkPaperID" : paperId
				});
				/* 	if (examEventID != -1 && paperId != -1) {
						callPaperAjax(dat, undefined);
					} */

			}); // end of paper change event

		}); /* End of document ready */

		// Used to get paper list
		function callExamEventAjax(dat, selectedId) {
			$.ajax({
				url : "listPaperAssociatedToEvent.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayPapers(response, selectedId);
				},

			}); /* end of ajax */
		}

		function displayPapers(response, selectedId) {
			$("#paperSelect").find("option").remove();

			/* if(response.length>1){
				$("#paperSelect").append("<option value='-1'>--<spring:message code="select.selectPaper"/> --</option>");
			} */
			$("#paperSelect")
					.append(
							"<option value='-1'>--"
									+ "<spring:message code="select.selectPaper"/>"
									+ " --</option>");
			$.each(response, function(i, paper) {
				if (selectedId && selectedId == paper.paperID) {
					$("#paperSelect").append(
							"<option value='" + paper.paperID + "' selected='selected'>"
									+ paper.name + "</option>");
				} else {
					$("#paperSelect").append(
							"<option value='" + paper.paperID + "'>"
									+ paper.name + "</option>");
				}
			});

		} /* end of displayCollection */

		function validate() {

			if ($('#examEventSelect').val() == -1
					|| $('#examEventSelect').val() == '') {
				alert('<spring:message code="candidateTestReport.selectEvent" />');
				$("#examEventSelect").focus();
				return false;
			}
			if ($('#paperSelect').val() == -1 || $('#paperSelect').val() == '') {
				alert('<spring:message code="scheduleExam.selectPaper"/>');
				$("#paperSelect").focus();
				return false;
			}

			return true;
		}
	</script>

	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
		$(document).ready(function() {

			$("#prev_anchor_tag").click(function() {
				$("#prev_selector_for_the_form").submit();
				return false;
			});

			$("#next_anchor_tag").click(function() {
				$("#next_selector_for_the_form").submit();
				return false;
			});
			
// disable link if there is count of 0
			$('.candCount').each(function(i, obj) {
					if($(this).text() == '0'){
						//$(this).prop("href","#");
						$(this).click(function(e) { e.preventDefault()}); 
					}
					
					});

		});
	</script>

</body>
</html>