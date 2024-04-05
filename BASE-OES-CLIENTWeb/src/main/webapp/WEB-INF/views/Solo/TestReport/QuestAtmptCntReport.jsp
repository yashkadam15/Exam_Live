<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="questAtmptCntReport.atmptRpt"></spring:message></title>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />
	<style type="text/css">
 #search {  
 position: relative;
margin-top: 0px;
padding-left: 12px;
float: none;
margin-bottom: 0px;
margin-right: 5px;
} 

	</style>
</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="questAtmptCntReport.atmptRpt"></spring:message></span>
			</legend>
		</div>
		
		<div class="holder">
			<form:form  class="form-horizontal"  action="questAtmptCntRpt" method="POST" onsubmit="return validate();">
						
				<div class="control-group">
					<label class="control-label"><spring:message code="candidateTestReport.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected"><spring:message code="candidateTestReport.selectExamEvent"></spring:message></option>							
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

				<div  id="paper">
					<label class="control-label" for="paperName" id="paper-lbl"><spring:message code="scoreCard.Paper"/></label>
					<div class="controls">
						<input type="hidden" id="paperId" name="paperId" value="${paperId}" >
						<select class="span4" id="paperSelect" name="paperSelect">
						</select>
					</div>
				</div>
				<br/>
				<div>
					<div class="controls">
						<button type="submit" class="btn btn-blue" ><spring:message code="EventSelection.Proceed"/></button>
					</div>
				</div>
				
			</form:form>
			</div>
	</fieldset>
	
	<fieldset class="well">
			<div class="holder">			
			
			<c:set var="srNo" value="1" scope="page" />
			<c:if test="${fn:length(viewModelList) != 0}">
			
			<%-- <div style="float: left;border: solid 1px gray;width: 100%;padding: 5px;"><b><spring:message code="MarkDistributionReport.ExamCenter"/>:</b>&nbsp;[${venue.examVenueCode}]&nbsp;${venue.examVenueName}</div> --%>
			<table class="table table-striped table-bordered" id="tblCandidateList" >
				<thead>
					<tr>
					<c:choose>
						<c:when test="${ fn:length(viewModelList[0].sectionNameList)>1}">
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="candidateTestReport.srNo" /></th>
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="MarkDistributionReport.CandidateCode"/></th>
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="candidateTestReport.candidatename"></spring:message></th>
							<th colspan="${ fn:length(viewModelList[0].sectionNameList)}" style="vertical-align: middle;text-align: center;"><spring:message code="MarkDistributionReport.Sections"/></th>
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="viewtestscore.TotalQuestions"/></th>
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="CandidateInfoReport.TotalAttempted"></spring:message></th>
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="questAtmptCntReport.timeTaken"></spring:message></th>
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="attemptReport.atmptNo"></spring:message></th>
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="queAttemptCntReport.mediaPlayed"/></th>
							<th rowspan="2" style="vertical-align: middle;text-align: center;"><spring:message code="queAttemptCntReport.count"/></th>
							<tr>
							<c:forEach var="sectionName" items="${viewModelList[0].sectionNameList}" >
								<th style="vertical-align: middle;text-align: center;">${sectionName}</th>
							</c:forEach>
							</tr>
						</c:when>
						<c:otherwise>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="candidateTestReport.srNo" /></th>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="MarkDistributionReport.CandidateCode"/></th>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="candidateTestReport.candidatename"></spring:message></th>
							<c:forEach var="sectionName" items="${viewModelList[0].sectionNameList}" >
								<th style="vertical-align: middle;text-align: center;">${sectionName}&nbsp;<spring:message code="MarkDistributionReport.Section"/></th>
							</c:forEach>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="viewtestscore.TotalQuestions"/> <spring:message code="questionUsageReport.questions"/></th>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="CandidateInfoReport.TotalAttempted"></spring:message></th>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="questAtmptCntReport.timeTaken"></spring:message></th>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="attemptReport.atmptNo"></spring:message></th>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="queAttemptCntReport.mediaPlayed"/></th>
							<th style="vertical-align: middle;text-align: center;"><spring:message code="queAttemptCntReport.count"/></th>
						</c:otherwise>
					</c:choose>
						
						
					</tr>
				</thead>
			
					<tbody>
						<c:forEach var="viewModel" items="${viewModelList}">
							<tr>
								<td>${pagination.start+srNo}<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
								<td>${viewModel.candidateCode}</td>
								<td>${viewModel.candidateFullName}</td>
								<c:set var="totMarks" value="0" scope="page" />
								<c:forEach var="questCnt" items="${viewModel.attemptedQuestCntList}">
									<td> ${questCnt}
									<c:set var="totMarks" value="${questCnt+totMarks}" scope="page" />
									</td>
								</c:forEach>
								<td>${viewModel.totalQuestion}</td>
								<td>${totMarks}</td>
								<td><fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="2" value="${viewModel.timeTaken/60}" /> mins</td>
								<td>${viewModel.attemptNo}</td>
								<td>
									<%-- <c:if test="${ viewModel.listSectionWiseMediaPlayCount !=null && fn:length(viewModel.listSectionWiseMediaPlayCount) != 0}">
										<c:forEach var="SectionMediaPlay" items="${viewModel.listSectionWiseMediaPlayCount}">
											<spring:message code="CandidateInfoReport.ListeningSet" /> ${SectionMediaPlay.sectionNumber}.${SectionMediaPlay.itemSequenceNumber} : ${SectionMediaPlay.mediaPlayCount}<br>
										</c:forEach>
									</c:if> --%>
									<c:if test="${ viewModel.sectionWiseMediaPlayCountViewModel !=null && viewModel.sectionWiseMediaPlayCountViewModel.itemText !=null}">
										<%-- <spring:message code="CandidateInfoReport.ListeningSet" /> ${viewModel.sectionWiseMediaPlayCountViewModel.sectionNumber}. ${viewModel.sectionWiseMediaPlayCountViewModel.itemSequenceNumber} --%>
										${viewModel.sectionWiseMediaPlayCountViewModel.itemText}
									</c:if>
								</td>
								<td>
									<c:if test="${ viewModel.sectionWiseMediaPlayCountViewModel !=null}">
										${viewModel.sectionWiseMediaPlayCountViewModel.mediaPlayCount}
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</tbody>
			</table>
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
			<div class="dataTables_paginate paging_bootstrap pagination" align="right">
					<ul>
						<c:choose>
							<c:when
								test="${disablePrev==true || (fn:length(viewModelList)<=pagination.recordsPerPage && pagination.start==0)}">
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
					<form:form action="showQuestAtmptCntRptPrev" method="POST" modelAttribute="pagination"
						id="prev_selector_for_the_form" name="prev_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						<input type="hidden" id="searchText" name="searchText" value="${searchText}" />
						<input type="hidden" id="paperSelect" name="paperSelect" value="${paperId}" >
						<input type="hidden" id="examEventSelect" name="examEventSelect" value="${examEventId}" >						
					</form:form>
					<form:form action="showQuestAtmptCntRptNext" method="POST" modelAttribute="pagination"
						id="next_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						<input type="hidden" id="searchText" name="searchText" value="${searchText}" />
						<input type="hidden" id="paperSelect" name="paperSelect" value="${paperId}" >
						<input type="hidden" id="examEventSelect" name="examEventSelect" value="${examEventId}" >
					</form:form>
				</div>
			</c:if>
			<c:if test="${(viewModelList==null || fn:length(viewModelList) == 0) && paperId>0}">
				<spring:message code="MarkDistributionReport.Recordsnotfound"/>
			</c:if>
			</div>
		</fieldset>
	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
	 $(document).ready(function(){
		 
		
		 
		 examEventID = $('#examEventSelect').val();
		 paperId = $('#paperId').val();
		
		 
		 if($('#examEventSelect').val()!=-1)
		{
			var dat = JSON.stringify({ "examEventID" : examEventID }); 
			if (examEventID!=-1) {
				callExamEventAjax(dat,paperId);	
			}
		}
		 /* examEvent change event */
			$('#examEventSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				if (examEventID !=-1) {
					callExamEventAjax(dat,undefined);
				}
				
			}); // end of examEventSelect change event

	 }); /* End of document ready */
	 
	 
	// Used to get paper list
		function callExamEventAjax(dat,selectedId) {
			$.ajax({
				url : "listEventPapers.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayPapers(response, selectedId);
				},
				error : function() {
					alert("opps.....");
				}
			}); /* end of ajax */
		}
	 
		function displayPapers(response, selectedId) {			
			$("#paperSelect").find("option").remove();
			$("#paperSelect").append("<option value='-1'>--<spring:message code="select.selectPaper"/>--</option>");		
			$.each(response, function(i, paper) {
				if (selectedId && selectedId == paper.paperID) {
					$("#paperSelect").append("<option value='" + paper.paperID + "' selected='selected'>"
									+ paper.name + "</option>");
				} else {
					$("#paperSelect").append("<option value='" + paper.paperID + "'>"
									+ paper.name + "</option>");
				}
			});

		} /* end of displayCollection */
		

		function validate() {
			
			if($('#examEventSelect').val()==-1 || $('#examEventSelect').val()=='')
			{
				alert('<spring:message code="DisplayCategory.selectExamEvent"/>');
				$("#examEventSelect").focus();
				return false;
			} 
			 if($('#paperSelect').val()==-1 || $('#paperSelect').val()=='')
			{
				 alert('<spring:message code="scheduleExam.selectPaper"/>');
				$("#paperSelect").focus();
				return false;
			}
			return true;
		}
		

		 $('#tblCandidateList')
			.dataTable({	
				"sDom" : "<'row-fluid'<'span4'><'span12'f>r>t<'row-fluid'<'span4'><'span8'>>",
						"iDisplayLength" : -1,
						"oTableTools" : {
							"sSwfPath" : "../resources/media/csv_xls_pdf.swf"
						}
					});

	$("#prev_anchor_tag").click(function() {
		$("#prev_selector_for_the_form").submit();
		return false;
	});

	$("#next_anchor_tag").click(function() {
		$("#next_selector_for_the_form").submit();
		return false;
	});

	$('#go').click(
			function() {
				var searchText = $('#search').val();
				var examEventId1= $('#examEventSelect').val();
				var paperId1=$('#paperSelect').val();
			
				window.location.href = 'questAtmptCntRpt?searchText='
						+ searchText+'&examEventSelect='+examEventId1+'&paperSelect='+paperId1;
			});
	
	</script>
	
	
</body>
</html>