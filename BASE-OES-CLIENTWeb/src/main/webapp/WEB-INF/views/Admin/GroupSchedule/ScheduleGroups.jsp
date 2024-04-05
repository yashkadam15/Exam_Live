<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page errorPage="../../Common/jsperror.jsp"%> 


<html>
<head>
<title><spring:message code="scheduleLabSession.Title"></spring:message></title>
<spring:message code="project.resources" var="resourcespath" />
<script type="text/javascript" src="<c:url value='/resources/js/jquery-ui.js'></c:url>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>

</head>
<body>
	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="scheduleLabSession.Title"></spring:message></span>
			</legend>
		</div>
		
		<div class="holder">
		
			<div id="tabbable">
		
			<div class="tab-content">
				<div id="tab2" class="tab-pane active">
				
				<ul class="nav nav-tabs" id="myTab">
					<li><a href="../superviserModule/scheduleExam"><spring:message code="scheduleExam.solo"></spring:message></a></li>
					<li  class="active"><a href="../groupSchedule/scheduleLabSession"><spring:message code="scheduleExam.group"></spring:message></a></li>
				</ul>
				
			<form:form  class="form-horizontal"  action="scheduleLabSession" method="post" onsubmit="return validate(this);">
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

				<div class="control-group"  id="collection" style="display: none;">
					<label class="control-label" for="collectionName" id="collection-lbl"></label>
					<div class="controls">
						<input type="hidden" id="collectionId" name="collectionId" />
						<select class="span4" id="collectionSelect" name="collectionSelect">
						</select>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.day"></spring:message></label>
					<div class="controls">
						<select class="span4" id="weekSelect" name="weekSelect">
						</select>
					</div>
				</div>

				<div class="control-group">
					<div class="controls offset1">
						<button type="submit" class="btn btn-blue offset1"><spring:message code="scheduleExam.schedule"></spring:message></button>
					</div>
				</div>
			</form:form>

<%-- ${flagCreateMode} --%>
<!--  Save SubjectWise paper Create Mode -->
			<c:if test="${fn:length(weekWiseSubjectPaperMap)>0}">
				<form:form id="frmSchedulePaper" action="getSubjectWisePaper" method="POST">

					<div id="WeekWiseSubjectsGrid">
					
						<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
						<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
						<input type="hidden" id="weekID" name="weekID" value="${weekID}">
						
						<table class="table table-striped table-bordered"  id="schedulingTable">
							<tbody>
							<c:forEach items="${weekWiseSubjectPaperMap }" var="entry1">
									<tr><b><spring:message code="scheduleExam.day"></spring:message>
										<fmt:formatDate value="${entry1.key.scheduleStart}" type="date" />
											<fmt:formatDate value="${entry1.key.scheduleStart}"
												pattern="dd/MM/yyyy" var="startDateValue" /> <fmt:formatDate
												value="${entry1.key.scheduleEnd}" pattern="dd/MM/yyyy"
												var="endDateValue" /> <c:if
												test="${startDateValue != endDateValue}">
										- <fmt:formatDate value="${entry1.key.scheduleEnd}" type="date" />
											</c:if>
											</b>
											&nbsp;&nbsp;
											<br>
				
											<c:choose>
												<c:when test="${entry1.key.maxNumberOfPapers==0}">
													<b style="color: green;"><spring:message code="scheduleExam.scheduleUnlimited"></spring:message></b>	
												</c:when>
												<c:otherwise>
													<b style="color: green;"><spring:message code="scheduleExam.schedulemax"></spring:message> ${entry1.key.maxNumberOfPapers} <spring:message code="scheduleExam.paper"></spring:message></b>
												</c:otherwise>
											</c:choose>
											
									</tr>
									<input type="hidden" id="maxNoPaper" name="maxNoPaper" value="${entry1.key.maxNumberOfPapers}" />
									<tr>
										<th><spring:message code="scheduleExam.subject"></spring:message></th>
										<th><spring:message code="scheduleExam.subjectPaper"></spring:message></th>
										<c:if test="${entry1.key.maxNumberOfPapers!=1}">
											<th><spring:message code="scheduleLabSession.addMore"></spring:message></th>
										</c:if>
									</tr>

									<tr>
									<c:set var="schPaper" value="0"></c:set>
										<c:forEach items="${entry1.value}" var="entry2">
											<tr>
												<td>${entry2.key.displayCategoryName} <input
													type="hidden" id="${entry2.key.fkDisplayCategoryID}"
													name="${entry2.key.fkDisplayCategoryID}"
													value="${entry2.key.fkDisplayCategoryID}" />
												</td>
	
												<td>
													<c:choose>
														<c:when test="${isForEdit==true}">
															<!-- Show Edit Page -->
															<div class="${entry2.key.fkDisplayCategoryID}-subDiv">
																<c:forEach
																	items="${wpdAssociationViewModel.weekPaperDivisionAssoiciationList}"
																	var="wpdObj">
																	<c:if test="${wpdObj.fkDisplayCategoryID==entry2.key.fkDisplayCategoryID}">
																			<c:choose>
																			<c:when test="${wpdObj.fkPaperID!=0}">
																				<div>
																					${wpdObj.paper.name}&nbsp;&nbsp;&nbsp; <a
																						href="javascript:post_to_url('${wpdObj.fkPaperID}','${wpdObj.fkScheduleID}','${wpdObj.fkCollectionID}','${wpdObj.fkExamEventID}')"
																						class="btn btn-orange pull-right btn-mini  removelink"><spring:message
																							code="scheduleExam.remove"></spring:message></a>
																				</div>
																				<c:set var="schPaper" value="${schPaper+1}"></c:set>
																				<br>
																			</c:when>
																			<c:otherwise>
																				<div
																					class="${entry2.key.fkDisplayCategoryID}-innerDiv">
																					<select
																						class="cmb ${entry2.key.fkDisplayCategoryID}" style="width: 300px;">
																						<option value="-1">None</option>
																						<c:forEach items="${entry2.value}" var="paperObj">
																							<option
																								class="${entry2.key.fkDisplayCategoryID}||${paperObj.paperID}"
																								value="${paperObj.paperID}">[${paperObj.code}]-${paperObj.name}</option>
																						</c:forEach>
																					</select>
																				</div>
																			</c:otherwise>
																		</c:choose>
																	</c:if>
																</c:forEach>
															</div>
														</c:when>

														<c:otherwise>
															<!-- Show Create Page -->
															<div class="${entry2.key.fkDisplayCategoryID}-subDiv">
																<div class="${entry2.key.fkDisplayCategoryID}-innerDiv">
																	<select class="cmb ${entry2.key.fkDisplayCategoryID}" style="width: 300px;">
																		<option value="-1">None</option>
																		<c:forEach items="${entry2.value}" var="paperObj">
																			<option
																				class="${entry2.key.fkDisplayCategoryID}||${paperObj.paperID}"
																				value="${paperObj.paperID}">[${paperObj.code}]-${paperObj.name}</option>
																		</c:forEach>
																	</select>
																</div>
															</div>
														</c:otherwise>
													</c:choose>
												</td>
	
												<c:if test="${entry1.key.maxNumberOfPapers!=1}">
													<td><a class="btn btn-blue btnAddMore">
														<spring:message code="scheduleLabSession.addMore"></spring:message></a>
													</td>
												</c:if>
												
											</tr>
										</c:forEach>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						
						<div id="popUpRetainGroupModal" class="modal hide fade in" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
							<div class="modal-header">
								<h3><spring:message code="scheduleExam.retainGroup"></spring:message></h3>
							</div>
							<div class="modal-body">
								<p><spring:message code="scheduleExam.retaingMsg"></spring:message></p>
							</div>
							<div class="modal-footer">
								<a class="btn" id="retainYesbtn" onclick="ratainGroupFun(1)"><spring:message code="scheduleExam.yes"></spring:message></a> 
								<a class="btn" id="retainNobtn" data-dismiss="modal" onclick="ratainGroupFun(0)"><spring:message code="scheduleExam.no"></spring:message></a>
							</div>
						</div>
						
						<div id="popUpAbsentModal" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
							<div class="modal-header">
								<h3><spring:message code="scheduleExam.markAbsent"></spring:message></h3>
							</div>
							<div class="modal-body">
								<p><spring:message code="scheduleExam.markAbsentMsg"></spring:message></p>
							</div>
							<div class="modal-footer">
								<a class="btn" id="absentYesbtn" onclick="absentFun(1)"><spring:message code="scheduleExam.yes"></spring:message></a> 
								<a class="btn" id="absentNobtn" data-dismiss="modal" onclick="absentFun(0)"><spring:message code="scheduleExam.no"></spring:message></a>
							</div>
						</div>
						
						
						<input type="hidden" id="scheduledP" name="scheduledP" value="${schPaper}">
						<input type="hidden" id="isForEdit" name="isForEdit" value="${isForEdit}" />
						<input type="hidden" id="groupExist" name="groupExist" value="${groupExist}" />
						<input type="hidden"  id="labGroup" name="labGroup" value="${labSessionGroup}"/>
						
						<input type="hidden" id="retainGroup" name="retainGroup"/>
						<input type="hidden" id="markAbsentCandidate" name="markAbsentCandidate"/>
						<input type="hidden" id="groupCreateMode" name="groupCreateMode" value="${groupCreateMode}"/>
						
						<input type="hidden" id="paperList" name="paperList"/>

						<div class="control-group offset3">
							<div class="controls">
								<a class="btn btn-blue" id="btnSubmit" onclick="validateScheduling(this)"><spring:message code="scheduleLabSession.save"></spring:message></a>
							</div>
						</div>
							
					</div>
				</form:form>
			</c:if>
			</div>
			</div>
			</div>
		</div>  <!-- End of holder -->
	</fieldset> <!-- End of fieldSet-->

	<script type="text/javascript">
	
	 $(document).ready(function(){
		 
	 $('.btnAddMore').click(function(event){

			$(this).closest('td').prev().find("div[class$='-subDiv']").each(function()
			 {
				 var selectBoxLength=0;
				 $(this).find('select').each(function()
				 {
					 selectBoxLength=selectBoxLength+1;
				 });
				 var innerhtml='<div>'+$(this).find("div[class$='-innerDiv']:first").html()+'</div>';
				 var optionlength=$(this).find("div[class$='-innerDiv']:first").find('select').children('option').length-1;
					 if(optionlength>selectBoxLength)
					{
						 $(this).append(innerhtml);	 
					}
			 });
		 });// End of btnAddMore click event
		
		$('#deletePaper').click(function(event){
			$('#deleteSchedule').submit();
		});
		$('.removelink').click(function(event){
			
		var r = confirm('<spring:message code="scheduleExam.removePaper"/>');
				if (r == true) {
					return true;
				} else {
					return false;
				}
			});

			/* populate division and weeks on load  */
		 	examEventID = $('#examEventSelect').val();
			collectionID = $('#collectionID').val();
			weekID=$('#weekID').val(); 
			
			if($('#examEventSelect').val()!=-1)
				{
					var dat = JSON.stringify({ "examEventID" : examEventID }); 
					callExamEventAjax(dat,collectionID);		

					var dat1 = JSON.stringify({"fkExamEventID" : examEventID , "fkCollectionID" : collectionID }); 
					callDivisionAjax(dat1,weekID);	
				}

			/* examEvent change event */
			$('#examEventSelect').change(function(event) {
				
				$('#WeekWiseSubjectsGrid').hide();
				$('#noScheduleAvailable').hide();
				
				examEventID = $('#examEventSelect').val();
				/* after change of exam event set collectionSelect and weekSelect to select position */
				
				if($('#examEventSelect').val()==-1)
				{
					$('#collection').hide();
				}
			
				$('#collectionSelect').val(-1);	
				$('#weekSelect').val(-1);
				$("#weekSelect").find("option").remove();
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				if(examEventID!=-1)
				{
					callExamEventAjax(dat,undefined);
				}
			}); // end of examEventSelect change event

			$('#collectionSelect').change(function(event) {
				
				$('#WeekWiseSubjectsGrid').hide();
				$('#noScheduleAvailable').hide();
				
				$('#weekSelect').val(-1);
				
				examEventID = $('#examEventSelect').val();
				collectionID = $('#collectionSelect').val();
				var dat = JSON.stringify({
					"fkExamEventID" : examEventID,
					"fkCollectionID" : collectionID
				});
				callDivisionAjax(dat,undefined);
			}); // end of examEventSelect change event

			$('#weekSelect').change(function(event) {
				$('#WeekWiseSubjectsGrid').hide();
			});
		}); /* End of document ready */
		
		 var collectionType="";
		function post_to_url(param1, param2, param3, param4) {
			var params = {
				fkPaperID : param1,
				fkWeekID : param2,
				fkDivisionID : param3,
				fkExamEventID : param4,
			};
			var method = "post"; // Set method to post by default, if not specified.
			var path = "deleteSchedule";
			var form = $(document.createElement("form")).attr({
				"method" : method,
				"action" : path
			});
			$.each(params, function(key, value) {
				$.each(value instanceof Array ? value : [ value ], function(i,
						val) {
					$(document.createElement("input")).attr({
						"type" : "hidden",
						"name" : key,
						"value" : val
					}).appendTo(form);
				});
			});
			form.appendTo(document.body).submit();
		}
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
		function callDivisionAjax(dat,selectedId) {
			$.ajax({
				url : "WeekAccEventDivision.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayWeek(response, selectedId);
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
				// $("#collectionSelect").prop("disabled",true);
				 $("#collection").hide();
				 
				 // call for collection ajax
				 examEventID = $('#examEventSelect').val();
				 collectionID = $('#collectionSelect').val();
				 
				 var dat = JSON.stringify({"fkExamEventID" : examEventID,"fkCollectionID" : collectionID});
				 callDivisionAjax(dat,undefined);
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

		function displayWeek(response, selectedId) {
			$("#weekSelect").find("option").remove();

			  $("#weekSelect").append("<option value='-1'></option>");   
					
			 /* var dt_to = $.datepicker.formatDate('dd-M-yy', new Date()); */
			 
			$.each(response, function(i, item) {
				if (selectedId && selectedId == item.scheduleID) {
			
					if(compareDate(item.scheduleStart,item.scheduleEnd))
					{
					$("#weekSelect").append(
							"<option value='" + item.scheduleID + "'selected='selected'>"
							+ $.datepicker.formatDate('M dd, yy',new Date(item.scheduleStart)) + "</option>");
					}
				else
					{
						$("#weekSelect").append(
							"<option value='" + item.scheduleID + "'selected='selected'>"
							+ $.datepicker.formatDate('M dd, yy',new Date(item.scheduleStart)) + ' - ' + $.datepicker.formatDate('M dd, yy',new Date(item.scheduleEnd))
									+ "</option>");
					}
					
				} else {
					
					if(compareDate(item.scheduleStart,item.scheduleEnd))
						{
						$("#weekSelect").append(
								"<option value='" + item.scheduleID + "'selected='selected'>"
								+ $.datepicker.formatDate('M dd, yy',new Date(item.scheduleStart)) + "</option>");
						}
					else
						{
							$("#weekSelect").append(
								"<option value='" + item.scheduleID + "'selected='selected'>"
								+ $.datepicker.formatDate('M dd, yy',new Date(item.scheduleStart)) + ' - ' + $.datepicker.formatDate('M dd, yy',new Date(item.scheduleEnd))
										+ "</option>");
						}
				}
			});
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
			 if(e['weekSelect'].value==-1)
				{
					alert('<spring:message code="GroupReport.selectSchedule"/>');
					$("#weekSelect").focus();
					return false;
				} 
			$("#collectionId").val($("#collectionSelect").val());
			return true;
		}
		function validateScheduling(form){
			var optionList=new Array();
			
			$('#schedulingTable').find("select option:selected").each(function()
			{
				if($(this).prop("class")!="")
					{
						optionList.push($(this).prop("class"));	
					}
				
			});
		
			if(optionList.length==0)
			{
				alert('<spring:message code="scheduleExam.selectPaper"/>');
				return false;
			}
			
			if(!arrHasDupes(optionList))
			{
				var scheduledPaper=$('#scheduledP').val();
				var paperNo=$('#maxNoPaper').val();
				
				// if paperNo is 0 unlimited paper('s') can be scheduled.
				
				if(paperNo!='0')
				{
					if((optionList.length+parseInt(scheduledPaper))>paperNo)
					{
						alert('<spring:message code="scheduleExam.schedulemax"/> '+$('#maxNoPaper').val()+' <spring:message code="scheduleExam.paper"/>');
						return false;
					}
				}
				
				$('#paperList').val(optionList);	
					
					//when group create mode is system generated then only show popup model for retain group and absentmodel
					if($('#groupCreateMode').val()=='1')
					{
						if($('#isForEdit').val()!='true' && $('#groupExist').val()!='true')
						{
							if($('#labGroup').val()=='true')
							{
								$('#popUpRetainGroupModal').modal('show') ;
								
							} // End of labGroup if
							else
							{
								$('#popUpAbsentModal').modal('show') ;
							} 
						} //End of groupExist if
						
						//it will execute for edit mode
						else
						{
							$('#frmSchedulePaper').submit();
						}
					}
					else
					{
						$('#frmSchedulePaper').submit();
					}
					
			} //End of arrHasDupes function
			else
			{
				alert('<spring:message code="scheduleExam.uniquePaper"/>');
				return false;
			}
			
		}
		function ratainGroupFun(i){
			if(i)
				{
					$('#retainGroup').val('true');
					$('#popUpRetainGroupModal').modal('hide') ;
					$('#frmSchedulePaper').submit(); 
				}
			else
			{
				$('#retainGroup').val('false');
				$('#popUpRetainGroupModal').modal('hide') ;
				$('#popUpAbsentModal').modal('show') ;
			}
		}
		
		function absentFun(i){
			if(i)
				{
					$('#markAbsentCandidate').val('true');
				}
			else
				{
					$('#markAbsentCandidate').val('false');
				}
			$('#popUpAbsentModal').modal('hide') ;
			$('#frmSchedulePaper').submit(); 
			
		}
		
		 function arrHasDupes( A ) { // finds any duplicate array elements using the fewest possible comparison
				var i, j, n;
				n=A.length;
			                                                     // to ensure the fewest possible comparisons
				for (i=0; i<n; i++) {                        // outer loop uses each item i at 0 through n
					for (j=i+1; j<n; j++) {              // inner loop only compares items j at i+1 to n
						if (A[i]==A[j]) return true;
				}	}
				return false;
			} 

			 function compareDate(startDate, endDate)
				{
					var start=new Date(startDate);
					var end=new Date(endDate);
					if(start.getDate()==end.getDate())
						{
						if(start.getMonth()==end.getMonth())
							{
							if(start.getFullYear()==end.getFullYear())
								{
									return true;
								}
							}
						}
					return false;
				}
			 
	</script>
</body>
</html>
