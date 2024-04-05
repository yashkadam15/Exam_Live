<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html dir="ltr" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="groupLoginPage.Title"/></title>
</head>

<body>

	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="peerAssessment.confidenceLevelRpt"></spring:message></span>
			</legend>
		</div>

<div class="holder">
			<form:form  class="form-horizontal"  action="confidenceRpt" method="post" >
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected"><spring:message code="scheduleExam.selectExamEvent"></spring:message></option>
							<c:forEach items="${examEventList }" var="eObj">
							
										<option value="${eObj.examEventID}">${eObj.name}</option>
									
							</c:forEach>
						</select>
					</div>
				</div>

			<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.selectPaper"/></label>
					<div class="controls">
						<select class="span4  " id="selectPaper" name="selectPaper" data-live-search="true" style="width: 56%;">
						</select>
					</div>
				</div>
				
				
				<div class="controls">
					<%--  <button type="submit" id="btnSubmit" name="btnSubmit" class="btn btn-blue" ><spring:message code="candidateTestReport.getReport" /></button> --%> 
					
					
				 <input type="submit" id="btnSubmit" name="action" class="btn btn-blue" 
				value= '<spring:message code="candidateTestReport.getReport" />' />
					
					<input class="btn btn-blue"  type="submit" name="action" id="exportToExcel"  value= '<spring:message code="global.exportToExcel" />' />	
					</div>
					
			
					
		<input type="hidden" id="hid_ExamEventID" name="hid_ExamEventID"/>
					<input type="hidden" id="hid_PaperID" name="hid_PaperID"/>			
</form:form>







<fieldset class="well">
			<div class="holder">
			
			
			<c:if test="${fn:length(assessmentRptViewModelList) != 0}">
			<b><spring:message code="EventSelection.ExamEventName"/>: </b> ${assessmentRptViewModelList[0].examEventName}
		<br>	<b><spring:message code="peerAssessment.paperName"/>: </b> ${assessmentRptViewModelList[0].paperName}	<br>	
	<!--Integrated data table  -->
			<c:set var="srNo" value="${pagination.start+1}" scope="page" />
			
			<table class="table table-striped table-bordered" id="demotable">
           <thead>
					<tr>
              <th rowspan="2" width="10%"><spring:message code="serialnumber.label"/></th>
                <th rowspan="2" width="15%"><spring:message code="canidateName.label"/></th>
                 <th rowspan="2" width="10%"><spring:message code="Exam.Username"/></th>
                <th colspan="2" width="20%"><spring:message code="Exam.fullconf"/>
                  </th>
                <th colspan="2" width="20%"><spring:message code="Exam.partialconf"/></th>
                <th colspan="2" width="20%"><spring:message code="Exam.lowconf"/></th>
                      <th rowspan="2" width="5%"><spring:message code="viewtestscore.TotalQuestions"/></th>
            </tr>
            <tr>
               
                <th > <spring:message code="global.right"/></th>
                <th ><spring:message code="global.wrong"/></th>
                <th ><spring:message code="global.right"/></th>
                <th ><spring:message code="global.wrong"/></th>
                <th ><spring:message code="global.right"/></th>
                <th ><spring:message code="global.wrong"/></th> 
                 
            </tr>
            </thead>
            
            
            <c:forEach var="assessmentRptViewModel" items="${assessmentRptViewModelList}">
            
            	<tbody>
							<tr>
							<td>${srNo}	<c:set var="srNo" value="${srNo+1}" scope="page" /></td>
<td>${assessmentRptViewModel.candidateFirstName}&nbsp;${assessmentRptViewModel.candidateLastName}</td>	
<td>${assessmentRptViewModel.candidateUserName}</td>						
<td>${assessmentRptViewModel.fullConf_RightAttps}</td>
<td>${assessmentRptViewModel.fullConf_WrongAttps}</td>
<td>${assessmentRptViewModel.partialConf_RightAttps}</td>
<td>${assessmentRptViewModel.partialConf_WrongAttps}</td>
<td>${assessmentRptViewModel.lowConf_RightAttps}</td>
<td>${assessmentRptViewModel.lowConf_WrongAttps}</td>
<td>${assessmentRptViewModel.totleItems}</td>
            </tr>
            </tbody>
            </c:forEach>
            
            
        </table>
			
			
			<c:if test="${fn:length(assessmentRptViewModelList) != 0}">
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
				<div class="dataTables_paginate paging_bootstrap pagination" align="right">
					<ul>
						<c:choose>
							<c:when
								test="${disablePrev==true || (fn:length(assessmentRptViewModelList)<=pagination.recordsPerPage && pagination.start==0)}">
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
						
						<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
						<input type="hidden" id="paperID" name="paperID" value="${paperID}">
						
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
					<form:form action="next" method="POST" modelAttribute="pagination"
						id="next_selector_for_the_form">
						<form:hidden path="end" />
						<form:hidden path="start" />
						<form:hidden path="recordsPerPage" />
						
						<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
						<input type="hidden" id="paperID" name="paperID" value="${paperID}">

						
						<input type="hidden" id="searchText" name="searchText"
							value="${searchText}" />
					</form:form>
				</div>
			</c:if>
		</c:if>
			</div>
		</fieldset>
</div></fieldset>
	<script type="text/javascript">
	
	
	$("#exportToExcel").click(function()
			{
		var paperID=$("#selectPaper").val();
			$("#hid_PaperID").val(paperID);
			
			
			if($('#examEventSelect').val() == '-1')
			{
				alert('<spring:message code="DisplayCategory.selectExamEvent"/>');
			return false;
			}
		
			if(paperID == null || paperID == '0')
		{
		alert('<spring:message code="scheduleExam.selectPaper"/>');
		return false;
		}
		
		
			});
	
	$("#btnSubmit").click(function()
			{

		var paperID=$("#selectPaper").val();
		$("#hid_PaperID").val(paperID);
		var examEventID=$('#examEventSelect').val();
		
	
		if(examEventID == '-1')
			{
			alert('<spring:message code="DisplayCategory.selectExamEvent"/>');
			return false;
			}
		
		if(paperID == null || paperID == '0')
		{
		alert('<spring:message code="scheduleExam.selectPaper"/>');
		return false;
		}
		
	});
	
		  /* examEvent change event */
			$('#examEventSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				$("#hid_ExamEventID").val(examEventID);
				/* display paper list*/
			 	var dat = JSON.stringify({	"examEventID" : examEventID	}); 
			 	/*var dat = {"examEventID" : examEventID};*/
				callPaperAjax(dat);	
			
				
			}); 
		
		  
		  
			 
			 function callPaperAjax(dat) {
				
					$.ajax({
						url : "paperList.ajax",
						type : "POST",
						data : dat,
						contentType : "application/json",
						dataType : "json",
						success : function(response) {
							
							displayPaper(response);					
						},
						error : function() {
							
						}
					}); /* end of ajax */
				}
			 
			 
			 
			 function displayPaper(response, selectedId) {
				
					$("#selectPaper").find("option").remove();			
					
					if (selectedId==0) {
						 $("#selectPaper").append("<option value='0' selected='selected'>--- Select ---</option>");
					}else{
						$("#selectPaper").append("<option value='0'>--- Select ---</option>");
					}
					
					$.each(response, function(i, item) {
						if (selectedId && selectedId == item.paperID) {
							$("#selectPaper").append("<option value='" + item.paperID + "' selected='selected'>"+ item.name + "</option>");			
							
							
						} else {
							$("#selectPaper").append("<option value='" + item.paperID + "'>"+ item.name + "</option>");					
						}
					});				
					  
					  $("#selectPaper").select2();
				} /* end of display Paper */
			 
	</script>
	
	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			
			$("#prev_anchor_tag").click(function() {
				$("#prev_selector_for_the_form").submit();
				return false;
			});

			$("#next_anchor_tag").click(function() {
				$("#next_selector_for_the_form").submit();
				return false;
			});
			
							
		});					
					
	</script>
</body>
</html>