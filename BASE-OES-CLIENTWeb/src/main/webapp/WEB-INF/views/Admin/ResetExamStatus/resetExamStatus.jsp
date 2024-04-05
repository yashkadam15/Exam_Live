<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title><spring:message code="resetExamStatus.header"/></title>
<style type="text/css">
.input-mini {
  width: 50px;  
}

</style>
<script type="text/javascript" src="<c:url value='/resources/js/utilities.js'></c:url>"></script>
</head>
<body>
<fieldset class="well">
		<legend>
			<span><spring:message code="resetExamStatus.header"/></span>
			
		</legend>
		<div class="holder">
		<form:form  action="resetStatus" method="POST" class="form-horizontal">
				<div class="control-group " style="background:none;">
				<div class="control-label" style="width:250px;">
					<label  id="lbl"><spring:message code="resetExamStatus.CandidateUsername/LoginId"/>&nbsp;:&nbsp;</label></div>
				<div class="controls">
						<input type="text" id="username" value="${fn:escapeXml(username)}" name="username"/>
						
				</div>
				</div>
				<div class="control-group " style="background:none;">
					<div class="control-label" style="width:250px;"></div>
				<div class="controls" >
				<button type="submit" class="btn btn-blue" id="result">
							<spring:message code="global.proceed"/>
						</button>		
				</div>
				</div>				
		</form:form>
		<c:if test="${fn:length(viewModelList) != 0}">		
		
		<c:forEach var="viewModel" items="${viewModelList}" varStatus="i">	
	
		</c:forEach>	
		<table class="table table-striped table-bordered table-condensed" id="demotable" style="font-size:10pt;">
		<c:forEach var="viewModel" items="${viewModelList}" varStatus="i">	
		
		    <input type="hidden" name="paperDuration-${viewModel.candidateExam.candidateExamID}" id="paperDuration-${viewModel.candidateExam.candidateExamID}" value="${viewModel.paper.duration}">
		        <c:if test="${i.index==0}">			       
				<thead>					 
					<tr><td colspan="3"><b><spring:message code="DisplayCategory.uName"/> </b>: ${viewModel.candidate.candidateFirstName }</td>
					    <td colspan="4"><b ><spring:message code="candidateTestReport.candidatecode"/></b> : ${viewModel.candidate.candidateCode }</td>
					</tr>						
					<tr>
						<th><spring:message code="resetExamStatus.ExamEventName"/></th>
						<th><spring:message code="examlog.paper"/></th>						
						<th style="width:16%;"><spring:message code="scoreCard.AttemptDate"/></th>
						<th style="width:14%;"><spring:message code="resetExamStatus.SpentTime"/> </th>
						<th style="width:11%;"><spring:message code="resetExamStatus.status"/></th>
						<th style="width:13%;"><spring:message code="resetExamStatus.MarkInComplete"/></th>
						<th style="width:11%;"><spring:message code="resetExamStatus.ResetAttempt"/></th>
					</tr>
				</thead>	
					</c:if>	
				<tbody>
			
					<tr>
					<td>${viewModel.examEvent.name}</td>
					<td>${viewModel.paper.name}</td>
					<td>				
                      <fmt:formatDate value="${viewModel.candidateExam.attemptDate}" pattern="dd-MM-yyyy HH:mm:ss" />
                     </td>
					<td style="text-align:center;" >
					<input type="text" value="${fn:escapeXml(viewModel.candidateExam.elapsedTime)}" class="input-mini allnum" disabled="disabled" id="tx${viewModel.candidateExam.candidateExamID}" style="margin-bottom:0px;">
					<input type="checkbox" value="1"  id="chk${viewModel.candidateExam.candidateExamID}" onclick="enableTextBox(${viewModel.candidateExam.candidateExamID});">
					</td>					
					<td  ><c:choose>
					<c:when test="${viewModel.candidateExam.uploadFlag==1}">
					<spring:message code="resetExamStatus.uploaded"/>
					</c:when>
					<c:otherwise>
					<spring:message code="resetExamStatus.notuploaded"/>
					</c:otherwise>
					</c:choose></td>
					<td>
				<%-- 	<c:if test="${viewModel.candidateExam.uploadFlag==0 || viewModel.candidateExam.uploadFlag==2}"> --%>
				 <%-- 	<a href="../resetExamStatus/markIncomplete?ceid=${viewModel.candidateExam.candidateExamID}&username=${username}" class="btn btn-warning btn-xs" onclick="return confirmcomplete();"><spring:message code="resetExamStatus.Incomplete"/></a>  --%>
				   <form:form action="markIncomplete" method="POST">
				   <input type="hidden" name="ceid" id="ceid" value="${viewModel.candidateExam.candidateExamID}" >
				   <input type="hidden" name="${viewModel.candidateExam.candidateExamID}uploadFlag" id="${viewModel.candidateExam.candidateExamID}uploadFlag" value="${viewModel.candidateExam.uploadFlag}">
				   <input type="hidden" name="${viewModel.candidateExam.candidateExamID}elapsedTime" id="${viewModel.candidateExam.candidateExamID}elapsedTime" value="" >				   
				   <button type="submit" onclick="return confirmcomplete(${viewModel.candidateExam.candidateExamID});" class="btn btn-warning btn-xs" ><spring:message code="resetExamStatus.Incomplete"/></button>
				   </form:form>
				   
				<%-- 	</c:if>		 --%>			
					</td>
					<td>
				<%-- 	<c:if test="${viewModel.candidateExam.uploadFlag==0 || viewModel.candidateExam.uploadFlag==2}"> --%>
					<%-- <a href="../resetExamStatus/resetAttempt?ceid=${viewModel.candidateExam.candidateExamID}&username=${username}" class="btn btn-red btn-xs" onclick="return confirmResetAttempt();"><spring:message code="resetExamStatus.Reset"/></a> --%>
					 <form:form action="resetAttempt" method="POST">
				   <input type="hidden" name="ceid" id="ceid" value="${viewModel.candidateExam.candidateExamID}">
				   <button type="submit" onclick="return confirmResetAttempt(${viewModel.candidateExam.candidateExamID});" class="btn btn-red btn-xs" ><spring:message code="resetExamStatus.Reset"/></button>
				   </form:form>
					
					
					<%-- </c:if> --%>
				
					</td>					
					</tr>				
					</tbody>
				</c:forEach>	
			</table>			
		
		</c:if>
		<c:if test="${fn:length(viewModelList) == 0 && username!=null && username!=''}">	
		<div class="alert alert-info" style="height: 40%;"><b><spring:message code="global.42.warning"/></b></div>
		</c:if>	
		</div>

	</fieldset>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#result').click(function() {
			if($.trim($('#username').val())=='')
				{
					alert('<spring:message code="scoreCard.PleaseenterthecandidateLoginID"/>');
					return false;
				}
			return true;
			});
			
			
		});
		
		function confirmcomplete(Ceid)
		{	
			
			var elapsedTime=$("#tx"+Ceid).val();			
			
			
			if(elapsedTime.indexOf(".") > -1)
			{
			var arr=elapsedTime.split(".");	
			    if(parseInt(arr[0])!=0)
					{
				   elapsedTime=(parseInt(arr[0])*60)+ parseInt(arr[1]);
					}
			     else
				   {
			    	 elapsedTime= parseInt(arr[1]);
				   }
			}
			else
				{
				elapsedTime=elapsedTime*60;
				}
			
			
			$("#"+Ceid+'elapsedTime').val(elapsedTime);			
			
			var paperduration=$('#paperDuration-'+Ceid).val();				
			
			
		/* 	alert("paper duration--"+paperduration+"elapsedTime---"+elapsedTime);  */
			
			if(elapsedTime <= paperduration)
			{
			
			if($("#chk"+Ceid).prop('checked') == true){
				return confirm('<spring:message code="resetExamStatus.confirmIncpmletemsg2"/>');
			}
			else
			{
				return confirm('<spring:message code="resetExamStatus.confirmIncpmletemsg"/>');
			}		
			} 
			else
			{
				alert('<spring:message code="resetExamStatus.timeSpentValidaionMsg"/>');
				return false;
			}
			
		}
		
		function confirmResetAttempt()
		{		
					
			return confirm('<spring:message code="resetExamStatus.confirmResetAttempt"/>');
					
		}
		
		function enableTextBox(Obj)
		{
			
			 if ($("#chk"+Obj).is(':checked')) {
				 $("#tx"+Obj).prop('disabled',false);		           
		        }
			 else
				 {
				 $("#tx"+Obj).prop('disabled',true);	
				 }
		}
		
	</script>
</body>
</html>