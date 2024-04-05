<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%-- <%@ page errorPage="../common/jsperror.jsp"%> --%>

<html>
<head>
<title></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
.error {
	color: red;
}
</style>
</head>
<body>


	<fieldset class="well">
		<legend>
			<span><spring:message code="candidateDivAss.title"/></span>
		</legend>
		<div class="holder">

			<spring:message code="global.typeSomething" var="typeSomething"></spring:message>
			<spring:message code="global.selectDate" var="selectDateMessage"></spring:message>
			<spring:message code="global.dateFormatClientSide" var="dateFormat"></spring:message>

			<form:form modelAttribute="candidateCollectionAssociation"
				action="showCandidate" method="POST" onsubmit="return validate(this);" id="addform"
			class="form-horizontal" >

				<form:hidden path="fkCandidateID" />


				<form:hidden path="candidateCollectionAssociationID" />
				<div class="control-group">
					<label class="control-label" for="inputEmail"><spring:message code="candidateTestReport.examEvent"></spring:message></label>
					<div class="controls">
						<form:select path="fkExamEventID" id="fkExamEventID"
								class="span4">
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
						</form:select>
					</div>
				</div>
				
				<input type="hidden" id="examEventId" name="examEventId" value="${examEventId}"/>
				
				<div class="control-group" id="collectiondiv">
					<label class="control-label" for="collectionName" id="collection-lbl"><spring:message code="candidateTestReport.collection" /></label>
					<div class="controls">
					<input type="hidden" id="collectionId" name="collectionId" >
					
							<form:select path="fkCollectionID" id="collectionTypeSelect" class="span4">
							</form:select>
						
					
					</div>
				</div>
				<input type="hidden" id="collectionID" name="collectionID" value="${collectionID}"/>
				
		


				<div class="control-group offset1">
					<div class="controls">
						<button type="submit" class="btn btn-blue" id="show">
							<spring:message code="global.showcandidate">
							</spring:message>
						</button>
					</div>
				</div>

			</form:form>
			
			

			<c:choose>

				<c:when test="${fn:length(mapCandidateList) != 0}">
					<form:form modelAttribute="viewDivisonExamEvenAssociation"
						action="addCandidate" method="POST" onsubmit="return validate(this);" id="showCandidate"
						class="form-horizontal" >




						<c:set var="cnt1" value="0" scope="page" />
						<c:set var="cnt2" value="0" scope="page" />
						<c:set var="flag" value="0" scope="page" />
						

								<form:hidden path="collectionMaster.collectionID" />

								<form:hidden path="examEvent.examEventID" />
								<table
									class="table table-bordered table-condensed table-complex">
									<tr>
										<c:forEach items="${mapCandidateList}" var="candidateExam"
											varStatus="cnt">
											<c:set var="flag" value="0" />
											<c:forEach var="candidateDivList"
												items="${viewDivisonExamEvenAssociation.candidateCollectionAssociationList}"
												varStatus="cnt1">
												<c:if
													test="${candidateDivList.fkCandidateID==candidateExam.key   }">
													<c:set var="flag" value="1" />
												</c:if>
											</c:forEach>




											<td><c:choose>

													<c:when test="${flag==1}">

														<form:checkbox checked="checked"
															path="candidateCollectionAssociationList[${cnt.index}].fkCandidateID"
															value="${candidateExam.key}" />&nbsp; ${candidateExam.value}										
								
								</c:when>
													<c:otherwise>

														<form:checkbox
															path="candidateCollectionAssociationList[${cnt.index}].fkCandidateID"
															value="${candidateExam.key}" />&nbsp; ${candidateExam.value}			
								
								</c:otherwise>
												</c:choose></td>
												
						<c:if test="${(cnt.index+1)%2==0}">
						
								</tr>
									<tr>
									
								</c:if>	
										</c:forEach>
										
										
<c:if test="${fn:length(mapCandidateList)%2 !=0 && fn:length(mapCandidateList) != 1}">
<td>
</td> 
</c:if>
										<!-- <td></td> -->
									</tr>
<%-- ${mapCandidateList.size()}
<c:if test="${mapCandidateList.size()%2 !=0}">
<td>
</td> 
</c:if>--%>
								</table>
						

						<br />
						<!-- For Save button -->
			<c:if test="${fn:length(viewDivisonExamEvenAssociation.candidateCollectionAssociationList)!=0 }">
						${message}
						</c:if>
						<div class="control-group">
							<div class="controls">
								<button type="submit" class="btn btn-blue" id="btnSave">
									<spring:message code="global.save" />
								</button>
							</div>
						</div>
					</form:form>


				</c:when>
				<c:otherwise>
					<c:if test="${showCandidate == true }">
					<div cssClass="error">
					<spring:message code="candidateDivAss.nocandidate" />
					</div>
			
			</c:if>
				</c:otherwise>
			</c:choose>
		</div>
	</fieldset>
	<script type="text/javascript">
	 $(document).ready(function(){
			
			/* populate division and weeks on load  */
		 	examEventID = $('#fkExamEventID').val();
			collectionID = $('#collectionID').val();
		
			
			if($('#fkExamEventID').val()!=-1)
				{
			
					var dat = JSON.stringify({ "examEventID" : examEventID }); 
					callExamEventAjax(dat,collectionID);		
				
				}
			else{
				$('#collectiondiv').hide();
			}
			

			/* examEvent change event */
			$('#fkExamEventID').change(function(event) {
				if($('#fkExamEventID').val()!=-1)
				{
				$('#collectiondiv').show();
				}
				else{
					$('#collectiondiv').hide();
				}
				examEventID = $('#fkExamEventID').val();
				var dat = JSON.stringify({
					"examEventID" : examEventID
				});
				callExamEventAjax(dat,undefined);
			}); // end of examEventSelect change event


		}); /* End of document ready */
		
		function callExamEventAjax(dat,selectedId) {
			$.ajax({
				url : "collectionAccEventRole.ajax",
				type : "POST",
				data : dat,
				contentType : "application/json",
				dataType : "json",
				success : function(response) {
					displayCollection(response, selectedId);
				},
				error : function() {
					/* alert("opps....."); */
				}
			}); /* end of ajax */
		}
		
		function displayCollection(response, selectedId) {
			$("#collectionTypeSelect").find("option").remove();
		
			 // If Collection type is None, disable collection ddl and call collection ajax
			 if(response !='NULL' && response[0].collectionType=='None'){
				 $("#collectionTypeSelect").append("<option value='" + response[0].collectionID + "' selected='selected'>"
									+ response[0].collectionName + "</option>");
				// $("#collectionSelect").prop("disabled",true);
				 $("#collection").hide();

			 }else{
				 if(response !='NULL'){
					 $("#collection-lbl").html(response[0].collectionType);
				 }
				 // If collection type is division or batch
				  $("#collection").show();
			 
			$.each(response, function(i, item) {
				if (selectedId && selectedId == item.collectionID) {
					$("#collectionTypeSelect").append(
							"<option value='" + item.collectionID + "' selected='selected' readonly='readonly'>"
									+ item.collectionName + "</option>");
					
				} else {
					$("#collectionTypeSelect").append(
							"<option value='" + item.collectionID + "'>"
									+ item.collectionName + "</option>");
				}
			});
			 }
		} /* end of displayCollection */
		
		$('#fkExamEventID').change(function() {
			$("#showCandidate").hide();

		});
		$('#collectionTypeSelect').change(function() {
			$("#showCandidate").hide();

		});

		function validate(form) {
			var e = form.elements;
			if(e['fkExamEventID'].value==-1)
			{
				alert('Select Exam Event');
				$("#examEventSelect").focus();
				return false;
			} 
			 if($('#collectionTypeSelect').val()==-1||$('#collectionTypeSelect').val()==null)
			{
				alert('Select Collection');
				$("#collectionTypeSelect").focus();
				return false;
			} 
			
			 
			return true;
		}



	</script>
</body>
</html>
