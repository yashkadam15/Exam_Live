<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<html>
<head>
<title><spring:message code="viewExamSchedule.Title"></spring:message></title>
<spring:message code="project.resources" var="resourcespath" />

</head>
<body>

	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="viewExamSchedule.Title"></spring:message></span>
			</legend>
		</div>
		
		<div class="holder">
			<form:form  class="form-horizontal"  action="viewExamSchedule" method="post" onsubmit="return validate(this);">
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected"><spring:message code="scheduleExam.selectExamEvent"></spring:message></option>
							<c:forEach items="${activeExamEventList }" var="eObj">
								<c:choose>
									<c:when test="${eObj.examEventID==examEventID}">
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

				<div class="control-group" id="collection" style="display: none;">
					<label class="control-label" for="collectionName" id="collection-lbl"></label>
					<div class="controls">
						<input type="hidden" id="collectionId" name="collectionId" >
						<select class="span4" id="collectionSelect" name="collectionSelect">
						</select>
					</div>
				</div>

				<div class="control-group">
					<div class="controls offset1">
						<button type="submit" class="btn btn-blue" ><spring:message code="viewExamSchedule.Title"></spring:message></button>
					</div>
				</div>
			</form:form>

<%-- ${flagCreateMode} --%>

		<!------------------------------- Already Defined Schedule--------------------------- -->
		<c:if test="${!flagCreateMode==true && fn:length(definedSheduleMap)==0}">
				<div id="noScheduleAvailable">
					<legend>&nbsp;<spring:message code="scheduleExam.notAvailable"/></legend>
					<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
					<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
				</div>
		</c:if>		
		
			<c:if test="${fn:length(definedSheduleMap)>0}">
			<div id="allWeekStatusGrid">
				<div>
					<h4>&nbsp;&nbsp;&nbsp;<spring:message code="scheduleExam.definedSchedule"></spring:message></h4>
				</div>
				
				<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
				<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
				
						
				<table class="table table-striped table-bordered">
					<tbody>
							<tr>
								<th><spring:message code="scheduleExam.week"></spring:message></th>
								<th><spring:message code="scheduleExam.subject"></spring:message></th>
								<th><spring:message code="scheduleExam.subjectPaper"></spring:message></th>
								<th><spring:message code="scheduleExam.scheduleLocation"></spring:message></th>
							</tr>
						<jsp:useBean id="now" class="java.util.Date"></jsp:useBean>
						<c:forEach items="${definedSheduleMap}" var="weekObj">
								<c:choose>
								<c:when test="${fn:length(weekObj.value)>0}">
									<c:choose>
											<c:when
												test="${(weekObj.key.scheduleStart==now || weekObj.key.scheduleEnd==now) || (weekObj.key.scheduleStart lt now && weekObj.key.scheduleEnd gt now)}">
												<tr style="color: green;">
											</c:when>
											<c:otherwise>
												<tr>
											</c:otherwise>
										</c:choose>
										<!-- <tr> -->
										<td rowspan="${fn:length(weekObj.value)+1}">
					
											<fmt:formatDate value="${weekObj.key.scheduleStart}"  pattern="MMM dd yyyy, HH:mm:ss" type="both" dateStyle="medium" timeStyle="medium"/> 
											-<fmt:formatDate value="${weekObj.key.scheduleEnd}"  pattern="MMM dd yyyy, HH:mm:ss" type="both" dateStyle="medium" timeStyle="medium"/>
											
										</td>
										
										<c:set var="subID" value="0"></c:set>															
										<c:forEach items="${weekObj.value}" var="subObj">
										<c:set var="wkID" value="${weekObj.key.scheduleID}||${subObj.fkDisplayCategoryID}"></c:set>
											<tr>
												<%-- <td>${subjectIDLanguage[subObj.fkDisplayCategoryID].displayCategoryName}</td> --%>
												<c:if test="${subID!=subObj.fkDisplayCategoryID}">
													<td rowspan="${weekWiseSubjectPaperListMap[wkID]}">${subjectIDLanguage[subObj.fkDisplayCategoryID].displayCategoryName}</td>
												</c:if>
												<td>${subObj.paper.name}</td>
												<td>${paperSchedule[subObj.paper.paperID]}</td>
											</tr>
											<c:set var="subID" value="${subObj.fkDisplayCategoryID}"></c:set>
										</c:forEach>
										
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="3">
											<fmt:formatDate value="${weekObj.key.scheduleStart}" pattern="MMM dd yyyy, HH:mm:ss" type="both" dateStyle="medium" timeStyle="medium"/>
											-<fmt:formatDate value="${weekObj.key.scheduleEnd}" pattern="MMM dd yyyy, HH:mm:ss" type="both" dateStyle="medium" timeStyle="medium" />
											
										</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</tbody>

				</table>
			</div><!--  End of All Week Status Grid -->
			</c:if>
			
		</div>  <!-- End of holder -->
	</fieldset> <!-- End of fieldSet-->

	<script type="text/javascript">
	
	 $(document).ready(function(){

		 /* populate division and weeks on load  */
		 	examEventID = $('#examEventSelect').val();
		 	collectionID = $('#collectionID').val();
			weekID=$('#weekID').val();
			
			if($('#examEventSelect').val()!=-1)
				{
					var dat = JSON.stringify({ "examEventID" : examEventID }); 
					callExamEventAjax(dat,collectionID);		
				}

			/* examEvent change event */
			$('#examEventSelect').change(function(event) {
				$('#allWeekStatusGrid').hide();
				$('#noScheduleAvailable').hide();
				
				examEventID = $('#examEventSelect').val();
				
				if($('#examEventSelect').val()==-1)
				{
					$('#collection').hide();
				}

				/* after change of exam event set collectionSelect select position */
				$('#collectionSelect').val(-1);	
				$("#collectionSelect").find("option").remove(); 
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				if(examEventID!=-1)
				{
					callExamEventAjax(dat,undefined);	
				}
			}); // end of examEventSelect change event

			$('#collectionSelect').change(function(event) {
				$('#allWeekStatusGrid').hide();
				$('#noScheduleAvailable').hide();
			}); // end of examEventSelect change event

		}); /* End of document ready */
		
		 var collectionType="";
		
		function callExamEventAjax(dat,selectedId) {
			$.ajax({
				url : "divisionAccEventRole.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayDivision(response, selectedId);
				},
				error : function() {
				}
			}); /* end of ajax */
		}
		function displayDivision(response, selectedId) {
			$("#collectionSelect").find("option").remove();

			collectionType=response[0].collectionType;
			
			 $("#collectionSelect").append(
					"<option value='-1'><spring:message code="scheduleExam.select"/></option>"); 

			 // If Collection type is None, disable collection ddl and call collection ajax
			 if(response !='NULL' && response[0].collectionType=='None'){
				 $("#collectionSelect").append("<option value='" + response[0].collectionID + "' selected='selected'>"
									+ response[0].collectionName + "</option>");
				 $("#collection").hide();
			 }else{
				 if(response !='NULL'){
					 if(response[0].collectionType=='Division')
						{
							 $("#collection-lbl").html('<spring:message code="groupLoginPage.Division" />');
						}
						else if(response[0].collectionType=='Batch')
						{
							$("#collection-lbl").html('<spring:message code="groupLoginPage.Batch" />');
						}
					 //$("#collection-lbl").html(response[0].collectionType);
				 }
				 // If collection type is division or batch
				  $("#collection").show();
			 
			$.each(response, function(i, item) {
				if (selectedId && selectedId == item.collectionID) {
					$("#collectionSelect").append(
							"<option value='" + item.collectionID + "' selected='selected'>"
									+ item.collectionName + "</option>");
				} else {
					$("#collectionSelect").append(
							"<option value='" + item.collectionID + "'>"
									+ item.collectionName + "</option>");
				}
			});
			}
		} /* end of displayDivision */
		
		function validate(form) {
			var e = form.elements;
			if(e['examEventSelect'].value==-1)
			{
				alert('<spring:message code="DisplayCategory.selectExamEvent"/>');
				$("#examEventSelect").focus();
				return false;
			} 
			 if(e['collectionSelect'].value==-1)
			{
				 if(collectionType=='Division')
				 {
				 alert('<spring:message code="scheduleExam.cselect"/> '+'<spring:message code="groupLoginPage.Division" />');	 	
				 }
			 else if(collectionType=='Batch')
				 {
				 	alert('<spring:message code="scheduleExam.cselect"/> '+'<spring:message code="groupLoginPage.Batch" />');
				 }
				$("#collectionSelect").focus();
				return false;
			} 
			 $("#collectionId").val($("#collectionSelect").val());
			return true;
		}
		
	</script>
</body>
</html>
