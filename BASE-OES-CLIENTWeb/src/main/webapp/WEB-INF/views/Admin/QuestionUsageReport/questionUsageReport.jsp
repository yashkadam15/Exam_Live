<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/error/error.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><spring:message code="QuestionUsageReport.header"/></title>
<spring:message code="project.resources" var="resourcespath" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/style/dataTable.css'></c:url>" />	
<style type="text/css">
.fontColor {
color:red;
}
</style>		
</head>
<body>

		<div>
			<legend>
				<span><spring:message code="QuestionUsageReport.header"/></span>
			</legend>
		</div>


<div class="holder" >

<form:form action="questionUsageReportExcel" method="POST"  class="form-horizontal" id="getform" onsubmit="return validate(this);" > 
<input type="hidden" id="paperId" name="paperId" value="${paperID}">
			 <input type="hidden" id="districtName" name="districtName" value="${districtName}">
			<input type="hidden" id="examvenueID" name="examvenueID" value="${examvenueID}">	
        <div class="control-group" style="background:none ;">
					<label class="control-label " for="inputEmail"><spring:message code="incompleteexams.ExamEvent"/></label>
					<div class="controls">
						<select class="span4 required " id="examEventSelect" name="examEventSelect" style="width: 56%;">
							<option value="-1" selected="selected"><spring:message code="candidateTestReport.selectExamEvent"/></option>
							<c:forEach items="${examEventList}" var="eObj">
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
				
				
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.subjectPaper"/></label>
					<div class="controls">
						<select class="span4  " id="selectPaper" name="selectPaper"  style="width: 56%;">
						</select>
					</div>
				</div>
				<%-- <div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="venueActivityReport.selectDistrictHeader"/></label>
					<div class="controls">
						<select class="span4" id="districtSelect" name="districtSelect" data-live-search="true" style="width: 56%;">
						</select>
					</div>
				</div> --%>
				<div class="control-group" style="background:none ;">
					<label class="control-label" for="inputEmail"><spring:message code="QuestionUsageReport.selectVenueHeader"/></label>
					<div class="controls">
						<select class="span4" id="selectVenue" name="selectVenue"  style="width: 56%;">
						</select>
					</div>
				</div>
				    <center>
						<button type="submit" class="btn btn-success" id="submitbutton">
						<spring:message code="QuestionUsageReport.exporttoexcel"/>
						</button >
					</center>
					
					<br/>
				   <c:choose>
				    <c:when test="${questionUsageReportViewModelList!= null && fn:length(questionUsageReportViewModelList)!=0}">
					<table class="table table-striped table-bordered" id="demotable">
					<thead>
					<tr>
					<th width="6%" rowspan="2"><spring:message code="uploadExpectancy.Srno"/></th>
					<th rowspan="2"><spring:message code="questionUsageReport.queID"/></th>
					<th rowspan="2"><spring:message code="questionUsageReport.queText"/></th>
					<th rowspan="2"><spring:message code="questionUsageReport.subQueId"/></th>
					<th rowspan="2"><spring:message code="questionUsageReport.subQueText"/></th>					
					<th rowspan="2"><spring:message code="questionUsageReport.diffLevel"/></th>
					<th colspan="4" style="text-align: center;"><spring:message code="questionUsageReport.questions"/></th>
					<!-- <th width="12%">Answered Correct</th>
					<th width="10%">Answered InCorrect</th> 
					<th width="10%" rowspan="2">Not Attempted</th>		-->			
					<th width="10%"><spring:message code="questionUsageReport.correctResponse"/></th>
					<th width="10%"><spring:message code="questionUsageReport.incorrectResponse"/></th> 
					</tr>
					<tr>					
					<th><spring:message code="questionUsageReport.received"/></th>
					<th><spring:message code="questionUsageReport.correct"/></th>
					<th><spring:message code="questionUsageReport.incorrect"/></th>
					<th><spring:message code="questionUsageReport.notAttempted"/></th>
					</tr>
					</thead>
					<tbody>
					<c:forEach items="${questionUsageReportViewModelList}" var="questionUsageReportViewModel" varStatus="i">
					<tr>					
					<td>${i.index+1}
					<c:if test="${i.index==0}">
					<c:set var="prevQuestionID" value="0"/>
					</c:if>
					</td>					
					<td> 
					<c:if test="${prevQuestionID !=questionUsageReportViewModel.questionID || prevQuestionID==0}">					
					${questionUsageReportViewModel.questionID }
					</c:if>
					</td>
					<td>
					
					
								
					
					<c:if test="${prevQuestionID !=questionUsageReportViewModel.questionID || prevQuestionID==0}">
					${questionUsageReportViewModel.mainQuestionText}					
					</c:if>
					<c:set var="prevQuestionID" value="${questionUsageReportViewModel.questionID }"/>
					</td>					
					<td>${questionUsageReportViewModel.subItemId}</td>
					<td>${questionUsageReportViewModel.subtemText}</td>
					<td>${questionUsageReportViewModel.difficultyLevel}</td>
					<td>${questionUsageReportViewModel.countOfStudentsReceived}</td>
					<td>${questionUsageReportViewModel.countOfStudentsAnsCorrect}</td>
					<td>${questionUsageReportViewModel.countOfStudentsAnsInCorrect}</td>
					<td>${questionUsageReportViewModel.countOfNotattempted}</td>
					 <td>${questionUsageReportViewModel.perCorrectResponse}</td>
					<td>${questionUsageReportViewModel.perWrongNotattemptedResponse}</td>		 	
					
					</tr>
					</c:forEach>
					</tbody>
					</table> 				
					</c:when>
					<c:otherwise>
					<c:if test="${examEventId!=null}">
					<legend><spring:message code="incompleteexams.Recordsnotfound"/></legend>
					</c:if>
					</c:otherwise>
					</c:choose>  
					
					
					
					
	</form:form>
</div>

<script type="text/javascript">
	 $(document).ready(function(){
		 
			/* populate division and weeks on load  */
		 	examEventID = $('#examEventSelect').val();		
			paperID=$('#paperId').val();		
			examVenuePinCode=$('#districtName').val();		 	
			examVenueID=$('#examvenueID').val();
		
			 if($('#examEventSelect').val()!=-1)
				{
					var dat = JSON.stringify({ "examEventID" : examEventID }); 
					callPaperAjax(dat,paperID);				
					callVenueAjax(examEventID,examVenuePinCode,examVenueID);	
				}		
				
			
		  /* examEvent change event */
			$('#examEventSelect').change(function(event) {
				examEventID = $('#examEventSelect').val();
				/* display paper list*/
				var dat = JSON.stringify({	"examEventID" : examEventID	});
				callPaperAjax(dat,undefined);				
				callVenueAjax(examEventID,examVenuePinCode,undefined);	
				
			}); // end of examEventSelect change event
			
		  
			
			$('#demotable')
			.dataTable(
					{
						"sDom" : "<'row-fluid'<'span4'><'span8'f>r>t<'row-fluid'<'span4'><'span8'>>",
						"iDisplayLength" : -1,								
						"aoColumns" : [ null,null,null,null,null,null,null,null, null,null ],
						"oTableTools" : {
							"sSwfPath" : "../resources/media/csv_xls_pdf.swf",
							"aButtons" : [
									"copy",
									"print",
									{
										"sExtends" : "collection",
										"sButtonText" : 'Save <span class="caret" />',
										"aButtons" : [
												{
													'sExtends' : 'csv',
													'mColumns' : [
															0,
															1,
															2,
															3,
															4,5,6 ,7,8,9]
												},
												{
													'sExtends' : 'xls',
													'mColumns' : [
															0,
															1,
															2,
															3,
															4,5,6,7,8,9 ]
												},
												{
													'sExtends' : 'pdf',
													'mColumns' : [
															0,
															1,
															2,
															3,
															4,5,6,7,8 ,9]
												} ]
									} ]
						}
					});

			/* $("#prev_anchor_tag").click(function() {
				$("#prev_selector_for_the_form").submit();
				return false;
			});
			
			$("#next_anchor_tag").click(function() {
				$("#next_selector_for_the_form").submit();
				return false;
			});
			
			$('#go').click(
					function() {
						var searchText = $('#search')
								.val();
						window.location.href = 'searchPaper?searchText='
								+ searchText+'&linkLocation=2';
					}); */							
			
			
		
	 });	 
	
	 
	 function callPaperAjax(dat,selectedId) {
			$.ajax({
				url : "paperList.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayPaper(response, selectedId);					
				},
				error : function() {
					alert('<spring:message code="questionUsageReport.opps"/>');
				}
			}); /* end of ajax */
		}
	 
	 function displayPaper(response, selectedId) {
		 
			$("#selectPaper").find("option").remove();			
			
			if (selectedId==0) {
				 $("#selectPaper").append("<option value='-1' selected='selected'>--- Select Paper ---</option>");
			}else{
				$("#selectPaper").append("<option value='-1'>--- Select Paper ---</option>");
			}
			
			$.each(response, function(i, item) {
				if (selectedId && selectedId == item.paperID) {
					$("#selectPaper").append("<option value='" + item.paperID + "' selected='selected'>"+ item.name + "</option>");			
					
					
				} else {
					$("#selectPaper").append("<option value='" + item.paperID + "'>"+ item.name + "</option>");					
				}
			});				
			  
			  
		} /* end of display Paper */	
		
		
	// Call Enue Ajax tio get Event and District Wise.
	 function callVenueAjax(examEventID,examVenuePinCode,selectedId) {
		 //alert("callVenueAjax");
			$.ajax({
				url : "examVenueList.ajax",
				type : "POST",
				data:"examEventID="+examEventID+"&examVenuePinCode="+examVenuePinCode,				
				success : function(response) {
					displayVenueList(response, selectedId);	
					
				},
				error : function() {
					alert('<spring:message code="questionUsageReport.wrongWhileGettingVenue"/>');
				}
			}); /* end of ajax */
		}


		
	// display Exam Venue List in selectbox
	 function displayVenueList(response, selectedId) {
			
			$("#selectVenue").find("option").remove();	
			
			
			if (selectedId==0) {
				 $("#selectVenue").append("<option value='0' selected='selected'>"+'<spring:message code="candidateAcademicSummaryReport.allOption"/>'+"</option>");
			}else{
				$("#selectVenue").append("<option value='0'>"+'<spring:message code="candidateAcademicSummaryReport.allOption"/>'+"</option>");
			}
			
			$.each(response, function(i, item) {
				if (selectedId && selectedId == item.examVenueID) {
					$("#selectVenue").append(
							"<option value='" + item.examVenueID + "' selected='selected'>"
									+ item.examVenueName + "</option>");
				} else {
					$("#selectVenue").append(
							"<option value='" + item.examVenueID + "'>"
									+ item.examVenueName + "</option>");
				}
			});
			
		} /* end of display Exam Venue */ 
		
		
		function validate(form) {
			var e = form.elements;
			if(e['examEventSelect'].value==-1)
			{
				alert('<spring:message code="examevent.selectalertMessage"/>');
				$("#examEventSelect").focus();
				return false;
			} 
			 if(e['selectPaper'].value==-1)
			{
				alert('<spring:message code="scheduleExam.selectPaper"/>');
				$("#selectPaper").focus();
				return false;
			} 
			
			return true;
		}
		
		
	
		
	</script>
	<script type="text/javascript" src="<c:url value='/resources/js/gridDataTable.js'></c:url>"></script>
</body>
</html>