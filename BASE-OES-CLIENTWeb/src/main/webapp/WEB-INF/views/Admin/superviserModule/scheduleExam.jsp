<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page errorPage="../Common/jsperror.jsp"%>


<html>
<head>
<title><spring:message code="scheduleExam.Title"></spring:message></title>
<spring:message code="project.resources" var="resourcespath" />
<script type="text/javascript" src="<c:url value='/resources/js/jquery-ui.js'></c:url>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/utilities.js'></c:url>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/moment.min.js'></c:url>"></script>

</head>

<body>

	<fieldset class="well">
		<div>
			<legend>
				<span><spring:message code="scheduleExam.Title"></spring:message></span>
			</legend>
		</div>
		
		<div class="holder">
		<div id="tabbable">
		
			<div class="tab-content">
				<div id="tab2" class="tab-pane active">
				
				<ul class="nav nav-tabs" id="myTab">
					<li class="active"><a href="../superviserModule/scheduleExam" data-toggle="tab"><spring:message code="scheduleExam.solo"></spring:message></a></li>
					<c:if test="${sessionScope.eventgroupenable==true}">
						<li><a href="../groupSchedule/scheduleLabSession"><spring:message code="scheduleExam.group"></spring:message></a></li>
					</c:if>
				</ul>
			
			<form:form  class="form-horizontal"  action="scheduleExam" method="post" onsubmit="return validate(this);">
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.examEvent"></spring:message></label>
					<div class="controls">
						<select class="span4" id="examEventSelect" name="examEventSelect">
							<option value="-1" selected="selected"><spring:message code="scheduleExam.selectExamEvent"></spring:message></option>
							<c:forEach items="${activeEventListForScheduling }" var="eObj">
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
				
				<div class="control-group" id="scheduleDiv" style="display:none;">
					<label class="control-label" for="schduleType" id="schduleType"><spring:message code="scheduleExam.selectscheduleType"></spring:message></label>
					<div class="controls" id="radExamEvent">
						<c:forEach items="${activeEventListForScheduling }" var="eObj">
							<div id="event_${eObj.examEventID}" style="display:none;">
								<c:forEach items="${eObj.examEventScheduleTypeAssociationList}" var="eType">
									<input type="radio" id="rd_${eType.scheduleType}"  name="rad" class="rad" value="${eType.scheduleType}">
									<c:if test="${eType.scheduleType=='Day'}">
										<spring:message code="scheduleExam.day"></spring:message>
									</c:if>
									<c:if test="${eType.scheduleType=='Week'}">
										<spring:message code="scheduleExam.week"></spring:message>
									</c:if>
									<c:if test="${eType.scheduleType=='Custom'}">
										<spring:message code="scheduleExam.custom"></spring:message>
									</c:if>
								</c:forEach>
							</div>	
						</c:forEach>
						<input type="hidden" id="type" name="type" />
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="scheduleExam.week"></spring:message></label>
					<div class="controls" id="weekCombo">
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

			<c:if test="${fn:length(weekWiseSubjectPaperMap)>0}">
				<form:form id="frmSchedulePaper" modelAttribute="wpdAssociationViewModel" action="getSubjectWisePaper" method="POST">

					<input type="hidden"  id="hideDiv" name="hideDiv" value="${hideDiv}" />
					
					<div id="WeekWiseSubjectsGrid">
					<c:set var="counter" value="0"></c:set>
						<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
						<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
						<input type="hidden" id="weekID" name="weekID" value="${weekID}">
						<input type="hidden" id="scheduleType" name="scheduleType" value="${scheduleType}">
						
						<table class="table table-striped table-bordered" id="schedulingTable">
							<tbody>
							<c:forEach items="${weekWiseSubjectPaperMap }" var="entry1">
								<tr><b><spring:message code="scheduleExam.week"></spring:message>
										: <fmt:formatDate value="${entry1.key.scheduleStart}"  type="both" dateStyle="medium" timeStyle="short"  />
											<fmt:formatDate value="${entry1.key.scheduleStart}"
												var="startDateValue"   type="both" dateStyle="medium" timeStyle="short"  /> <fmt:formatDate
												value="${entry1.key.scheduleEnd}"  type="both" dateStyle="medium" timeStyle="short"  
												var="endDateValue" /> <c:if
												test="${startDateValue != endDateValue}">
										- <fmt:formatDate value="${entry1.key.scheduleEnd}"  type="both" dateStyle="medium" timeStyle="short"   />
											</c:if>
											</b>
											&nbsp;&nbsp;
											<br>
									
											<c:if test="${entry1.key.allowScheduleExtension && scheduleType!='Custom'}">
												<b><spring:message code="scheduleExam.extension"></spring:message></b> &nbsp;
												<input type="text" name="scheduleEx" id="scheduleEx" class="allnum input-mini" value="${fn:escapeXml('0')}" style="width: 30px;"/>
												&nbsp;<a href="#resetExtensionModal"  data-toggle="modal"><spring:message code="Exam.Reset"></spring:message></a>
												<br>
											</c:if>		
										
											<c:choose>
												<c:when test="${entry1.key.maxNumberOfPapers==0}">
													<b style="color: green;"><spring:message code="scheduleExam.scheduleUnlimited"></spring:message></b>	
												</c:when>
												<c:otherwise>
													<b style="color: green;"><spring:message code="scheduleExam.schedulemax"></spring:message>  ${entry1.key.maxNumberOfPapers} <spring:message code="scheduleExam.paper"></spring:message></b>
												</c:otherwise>
											</c:choose>
									</tr>
									
									<c:choose>
										<c:when test="${entry1.key.allowScheduleExtension && scheduleType!='Custom'}">
											<input type="hidden" id="showExtension" name="showExtension" value="true">
										</c:when>
										<c:otherwise>
											<input type="hidden" id="showExtension" name="showExtension" value="false">
										</c:otherwise>
									</c:choose>
									
									<input type="hidden" name="maxNoPaper" id="maxNoPaper" value="${entry1.key.maxNumberOfPapers}"/>
									<tr>
										<th><spring:message code="scheduleExam.subject"></spring:message></th>
										<th><spring:message code="scheduleExam.PaperExtension"></spring:message></b></th>
										<c:if test="${entry1.key.maxNumberOfPapers!=1}">
											<th><spring:message code="scheduleExam.addMore"></spring:message></th>
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
															<!-- Show Edit page -->
															<div class="${entry2.key.fkDisplayCategoryID}-subDiv">
																<c:forEach
																	items="${wpdAssociationViewModel.weekPaperDivisionAssoiciationList}"
																	var="wpdObj">
																	<c:if test="${wpdObj.fkDisplayCategoryID==entry2.key.fkDisplayCategoryID}">
																		<c:choose>
																			<c:when test="${wpdObj.fkPaperID!=0}">
																				<div>
																					${wpdObj.paper.name}&nbsp;&nbsp;&nbsp; <a
																						href="javascript:post_to_url('${wpdObj.fkPaperID}','${wpdObj.fkScheduleID}','${wpdObj.fkCollectionID}','${wpdObj.fkExamEventID}','${scheduleType}')"
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
																					<input type="text" class="sextension allnum" value="${fn:escapeXml('0') }" style="width: 30px;display: none;"/>
																				</div>
																			</c:otherwise>
																		</c:choose>
																	</c:if>
																</c:forEach>
															</div>
														</c:when>

														<c:otherwise>
															<!-- Show Create page -->
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
																		<input type="text" class="sextension allnum" value="${fn:escapeXml('0') }" style="width: 30px;display: none;"/>
																	</div>
															</div>

														</c:otherwise>
													</c:choose>
												</td>
												
												<c:if test="${entry1.key.maxNumberOfPapers!=1}">
													<td><a class="btn btn-blue btnAddMore"><spring:message code="scheduleLabSession.addMore"></spring:message></a></td>
												</c:if>
											</tr>
										</c:forEach>
										
									</tr>
								</c:forEach>
							</tbody>
						</table>
						
						<input type="hidden" id="scheduledP" name="scheduledP" value="${schPaper}">
						<input type="hidden" id="paperList" name="paperList"/>
						
						<div id="resetExtensionModal" class="modal hide fade in" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
							<div class="modal-header">
								<h3><spring:message code="scheduleExam.resetExtension"></spring:message></h3>
							</div>
							<div class="modal-body">
								<p><spring:message code="scheduleExam.message"></spring:message></p>
							</div>
							<div class="modal-footer">
								<a class="btn" id="resetYesbtn" onclick="resetExFun(1)"><spring:message code="scheduleExam.ok"></spring:message></a> 
								<a class="btn" id="resetNobtn" onclick="resetExFun(0)"><spring:message code="scheduleExam.cancel"></spring:message></a>
							</div>
						</div>
						
						
						<div class="control-group offset3">
							<div class="controls">
								<a class="btn btn-blue" id="btnSubmit" onclick="validateScheduling(this)"><spring:message code="scheduleLabSession.save"></spring:message></a>
								<!-- <button type="submit" class="btn btn-blue" >Save</button> -->
							</div>
						</div>
					</div>
				</form:form>
			</c:if>
			
			<!------------------------------- Already Defined Schedule--------------------------- -->
			
			<c:if test="${weekID==-1 && fn:length(definedSheduleMap)==0}">
				<div id="noScheduleAvailable">
					<legend>&nbsp;<spring:message code="scheduleExam.notAvailable"></spring:message></legend>
					<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
					<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
					<input type="hidden" id="scheduleType" name="scheduleType" value="${scheduleType}">
				</div>
			</c:if>
			
			<c:if test="${fn:length(definedSheduleMap)>0}">
			<div id="allWeekStatusGrid">
				<div>
					<h4>&nbsp;&nbsp;&nbsp;<spring:message code="scheduleExam.definedSchedule"></spring:message></h4>
				</div>
				
				<input type="hidden" id="examEventID" name="examEventID" value="${examEventID}">
				<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}">
				<input type="hidden" id="weekID" name="weekID" value="${weekID}">
				<input type="hidden" id="scheduleType" name="scheduleType" value="${scheduleType}">
				
				<table class="table table-striped table-bordered">
					<tbody>
							<tr>
								<th><spring:message code="scheduleExam.week"></spring:message></th>
								<th><spring:message code="scheduleExam.subject"></spring:message></th>
								<th><spring:message code="scheduleExam.subjectPaper"></spring:message></th>
							</tr>
						<jsp:useBean id="now" class="java.util.Date"></jsp:useBean>
						<c:forEach items="${definedSheduleMap}" var="weekObj">
								<c:choose>
								<c:when test="${fn:length(weekObj.value)>0}">
										<!-- To display current week in green color -->
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
										
												 <fmt:formatDate value="${weekObj.key.scheduleStart}"
												 type="both" dateStyle="medium" timeStyle="short"  /> <fmt:formatDate
												value="${weekObj.key.scheduleStart}"  type="both" dateStyle="medium" timeStyle="short"  
												var="startDateValue" /> <fmt:formatDate
												value="${weekObj.key.scheduleEnd}"  type="both" dateStyle="medium" timeStyle="short"  
												var="endDateValue" /> <c:if
												test="${startDateValue != endDateValue}">
												-<fmt:formatDate value="${weekObj.key.scheduleEnd}"  type="both" dateStyle="medium" timeStyle="short"   />
											</c:if> 
											
											<a  href="../superviserModule/getSubjectWisePaper?examEventID=${examEventID}&collectionID=${collectionID}&weekID=${weekObj.key.scheduleID}&scheduleType=${weekObj.key.scheduleType}&isForEdit=true">
												<br><b><spring:message code="scheduleExam.edit"></spring:message></b></a></td>
												
										<c:set var="subID" value="0"></c:set>											
										<c:forEach items="${weekObj.value}" var="subObj">
										<c:set var="wkID" value="${weekObj.key.scheduleID}||${subObj.fkDisplayCategoryID}"></c:set>
											<tr>
												<c:if test="${subID!=subObj.fkDisplayCategoryID}">
													<td rowspan="${weekWiseSubjectPaperListMap[wkID]}">${subjectIDLanguage[subObj.fkDisplayCategoryID].displayCategoryName}</td>
												</c:if>
												<td>${subObj.paper.name}</td>
											</tr>
											<c:set var="subID" value="${subObj.fkDisplayCategoryID}"></c:set>
										</c:forEach>
									</tr>
								</c:when>
								<c:otherwise>
										<tr>
										<td colspan="3">

											<fmt:formatDate value="${weekObj.key.scheduleStart}"  type="both" dateStyle="medium" timeStyle="short"   />

												<fmt:formatDate value="${weekObj.key.scheduleStart}"
													 var="startDateValue"  type="both" dateStyle="medium" timeStyle="short"  /> <fmt:formatDate
													value="${weekObj.key.scheduleEnd}"  type="both" dateStyle="medium" timeStyle="short"  
													var="endDateValue" /> <c:if
													test="${startDateValue != endDateValue}">
											-<fmt:formatDate value="${weekObj.key.scheduleEnd}"  type="both" dateStyle="medium" timeStyle="short"  />
												</c:if>

											</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</tbody>

				</table>
			</div><!--  End of All Week Status Grid -->
			</c:if>
			
			</div>
			</div>
		</div><!-- End of tabbable div -->
		</div>  <!-- End of holder -->
	</fieldset> <!-- End of fieldSet-->

	<script type="text/javascript">
	
	 $(document).ready(function(){
		 if($('#hideDiv').val()=='true')
			 {
			 $('#WeekWiseSubjectsGrid').hide();
			 }
		 
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
				 $(".sextension").val($('#scheduleEx').val());
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
					examEventID = $('#examEventSelect').val();
					// if scheduleType size is one then don't show scheduleType div.
					if($('#event_'+examEventID).find('input[type=radio]').size()=="1")
					{
						 $('#scheduleDiv').hide(); 
					}
					else
					{
						$('#scheduleDiv').show(); 
						$('#event_'+examEventID).show();
					} 
				 	var stype=$('#scheduleType').val();
				 	//set selected radiobutton checked.
					/* alert($('#event_'+examEventID).find("input[id=rd_" + stype + "]").prop("id")); */
				 	 $('#event_'+examEventID).find("input[id=rd_" + stype + "]").prop('checked', true); 
					
					
					var dat = JSON.stringify({ "examEventID" : examEventID }); 
					callExamEventAjax(dat,collectionID);		

					var dat1 = {"fkExamEventID" : examEventID , "fkCollectionID" : collectionID ,"scheduleType" : stype };
					callDivisionAjax(dat1,weekID);	
				}

			/* examEvent change event */
			$('#examEventSelect').change(function(event) {
				$('#WeekWiseSubjectsGrid').hide();
				$('#allWeekStatusGrid').hide();
				$('#noScheduleAvailable').hide();
				
				if($('#examEventSelect').val()==-1)
				{
					$('#scheduleDiv').hide();
					 $('#collection').hide(); 
				}
				else
				{
					$('#scheduleDiv').show();
				}
				
				// hide all div's of radioButton
				$('#radExamEvent').children('div').each(function () {
					/* alert($(this).prop("id")); */
					 $(this).hide(); 
				});
				
				examEventID = $('#examEventSelect').val();
				// if scheduleType size is one then don't show scheduleType div.
				/* alert($('#event_'+examEventID).find('input[type=radio]').size()); */
			 	if($('#event_'+examEventID).find('input[type=radio]').size()=="1" || $('#event_'+examEventID).find('input[type=radio]').size()=="0")
				{
					 $('#scheduleDiv').hide(); 
				}
				else
				{
					$('#scheduleDiv').show(); 
					$('#event_'+examEventID).show();
				} 
				//By default set first radiobutton selected.
			 	$('#event_'+examEventID).find('input[type=radio]:first').prop('checked',true); 
				
				/* after change of exam event set collectionSelect and weekSelect to select position */
				$('#collectionSelect').val(-1);	
				$("#collectionSelect").find("option").remove(); 
				$('#weekSelect').val(-1);
				$("#weekSelect").find("option").remove();
				
				var dat = JSON.stringify({"examEventID" : examEventID });
				if(examEventID!=-1)
				{
					callExamEventAjax(dat,undefined);
				}
			}); // end of examEventSelect change event
			
			$(".rad").click(function(event){
				examEventID = $('#examEventSelect').val();
				collectionID = $('#collectionSelect').val();
				scheduleType= $(".rad[type='radio']:checked").val();
				
				  var dat = { 
							"fkExamEventID" : examEventID, 
							"fkCollectionID" : collectionID,
							"scheduleType" : scheduleType
						};  
						callDivisionAjax(dat,undefined);
			}); // end of radio Clicked event
			
			
			$('#collectionSelect').change(function(event) {
				
				$('#WeekWiseSubjectsGrid').hide();
				$('#allWeekStatusGrid').hide();
				$('#noScheduleAvailable').hide();
				
				examEventID = $('#examEventSelect').val();
				collectionID = $('#collectionSelect').val();
				scheduleType= $(".rad[type='radio']:checked").val();
				
				 /* var dat="fkExamEventID="+examEventID + "&fkCollectionID=" + collectionID  ::also works */
				
				   var dat = { 
					"fkExamEventID" : examEventID, 
					"fkCollectionID" : collectionID,
					"scheduleType" : scheduleType
				};  
				callDivisionAjax(dat,undefined);
			}); // end of examEventSelect change event

			$('#weekSelect').change(function(event) {
				$('#WeekWiseSubjectsGrid').hide();
			});
			
			$('#scheduleEx').on('blur', function(){			
				/* alert($(this).val()); */
				$(".sextension").val($(this).val());
				$('#scheduleEx').prop('disabled', true);
			});
			
			if($('#showExtension').val()=='true')
			{
				$(".sextension").show();
			}
			
		}); /* End of document ready */
		
		 var collectionType="";
		
		function post_to_url(param1, param2, param3, param4, param5) {
			var params = {
				fkPaperID : param1,
				fkWeekID : param2,
				fkCollectionID : param3,
				fkExamEventID : param4,
				scheduleType : param5
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
				 scheduleType= $(".rad[type='radio']:checked").val();
				 var dat = {"fkExamEventID" : examEventID , "fkCollectionID" : collectionID ,"scheduleType" : scheduleType };
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

			  $("#weekSelect").append("<option value='-1'><spring:message code="scheduleExam.select"/></option>");  
					
			 /* var dt_to = $.datepicker.formatDate('dd-M-yy', new Date()); */
			 
			$.each(response, function(i, item) {
				console.log(moment(new Date(item.scheduleStart)).format('lll'));
				if (selectedId && selectedId == item.scheduleID) {
			
					$("#weekSelect").append(
							"<option value='" + item.scheduleID + "'selected='selected'>"
							+  moment(new Date(item.scheduleStart)).format('MMM DD YYYY, HH:mm:ss')  + ' - ' + moment(new Date(item.scheduleStart)).format('MMM DD YYYY, HH:mm:ss')
									+ "</option>");
					
				} else {
					
					$("#weekSelect").append(
							"<option value='" + item.scheduleID + "'>"
							+  moment(new Date(item.scheduleStart)).format('MMM DD YYYY, HH:mm:ss')  + ' - ' + moment(new Date(item.scheduleStart)).format('MMM DD YYYY, HH:mm:ss')
									+ "</option>");
				}
			});
		} /* end of displayDivision */
		
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
			 if( $('.rad[type=radio]:checked').size() <= 0)
			 {
			 	alert('<spring:message code="scheduleExam.scheduleType"/>');
			 	return false;
			 }
			 
			 $("#collectionId").val($("#collectionSelect").val());
			 $("#type").val($(".rad[type='radio']:checked").val());
			return true;
		}
		
		function validateScheduling(form){
			var optionList=new Array();
			
			$('#schedulingTable').find("select option:selected").each(function()
			{
				if($(this).prop("class")!="")
					{
						var extension=$(this).parent().parent().find('input[type="text"]').val();
						/* alert($(this).prop("class")+'||'+extension); */
						if(jQuery.trim(extension).length==0)
							{
								var extension="0";
							}
						optionList.push($(this).prop("class")+'||'+extension);	
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
			}
			else
			{
				alert('<spring:message code="scheduleExam.uniquePaper"/>');	
				return false;
			}
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
		 function resetExFun(i){
				if(i)
					{
						$('#scheduleEx').prop('disabled', false);
						$('#resetExtensionModal').modal('hide') ;
					}
				else
				{
					$('#resetExtensionModal').modal('hide') ;
				}
			}
		 
	</script>
</body>
</html>
