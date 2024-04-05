<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title><spring:message code="admindashboard.AdminDashboard" /></title>
<style type="text/css">
@keyframes blinkingText{0%{color:#ff0000}49%{color:#ff0000}60%{color:transparent}99%{color:transparent}100%{color:#ff0000}}
.blinking{animation:blinkingText 1.2s infinite;}

@keyframes blinkingTextsuccess{0%{color:#008000}49%{color:#008000}60%{color:transparent}99%{color:transparent}100%{color:#008000}}
.blinkingsuccess{animation:blinkingTextsuccess 1.2s infinite;}


.error-message{padding:5px 15px;background-color:#62c3b6;color:#fff;border-radius:5px;display:none;position:absolute;left:50%;transform:translateX(-50%)}
</style>
</head>
<body>
	<fieldset class="well">
		<legend>
			<span><img
				src="<c:url value="../resources/images/dashboard.png"></c:url>"
				alt=""> <spring:message code="admindashboard.AdminDashboard" /></span>
			<%-- 			<span><spring:message code="dashboard.name" /></span> --%>
		</legend>
		<div class="holder">
			<c:if test="${fn:length(candidateViewModelList) != 0}">
				<h3 style="line-height: 20px;">
					<spring:message code="admindashboard.ExamStatus" />
				</h3>
				<c:set var="examId" value="0" />
				<c:set var="noupload" value="0"/>
				<c:set var="totAllocated" value="0"/>
				<c:set var="totNotAppeared" value="0"/>
				<c:set var="totIncomplete" value="0"/>
				<c:set var="totNotUploaded" value="0"/>
				<c:set var="totUploaded" value="0"/>
				<c:forEach var="candExam" items="${candidateViewModelList}">
					<c:choose>
						<c:when test="${candExam.examEventID==examId }">
							<tr>
								<c:set var="totAllocated" value="${totAllocated + candExam.totalCandidates}"/>
								<c:set var="totNotAppeared" value="${totNotAppeared + candExam.notAppearedCandidates}"/>
								<c:set var="totIncomplete" value="${totIncomplete + candExam.incompleteExamCount}"/>
								
								<td>${candExam.paperName}</td>
								<td style="text-align: center;"><a
									href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=0" class="candCount"><h3
											class="dashboard-header">${candExam.totalCandidates}</h3></a>
	
								</td>
								<td style="text-align: center;"><a
									href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=1" class="candCount"><h3
											style="color: red; line-height: 10px;">${candExam.notAppearedCandidates}</h3></a></td>
								<td style="text-align: center;"><a
									href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=2" class="candCount"><h3
											style="color: red; line-height: 10px;">${candExam.incompleteExamCount}</h3></a>

								</td>

								<td style="text-align: center;">
								<c:if test="${candExam.uploadFlag!=2}">
									<c:set var="totNotUploaded" value="${totNotUploaded + candExam.notUploadedExamCount}"/>
									<c:set var="totUploaded" value="${totUploaded + candExam.uploadedExamCount}"/>
									<a href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=3" class="candCount">
									<h3 style="color: #297dbc; line-height: 10px;">${candExam.notUploadedExamCount}</h3></a>
								</c:if>
								<c:if test="${candExam.uploadFlag==2}">
									<c:set var="noupload" value="1"/>
									<h3 class="dashboard-header">*</h3>
								</c:if>
								</td>
								<td style="text-align: center;">
								<c:if test="${candExam.uploadFlag!=2}">
									<a href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=4" class="candCount">
									<h3 class="dashboard-header">${candExam.uploadedExamCount}</h3></a>
								</c:if>
								<c:if test="${candExam.uploadFlag==2}">
									<c:set var="noupload" value="1"/>
									<h3 class="dashboard-header">*</h3>
								</c:if>
								</td>
							</tr>

						</c:when>
						<c:otherwise>
							<c:if test="${examId!=0}">
								<tr>
									<td> Total</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totAllocated}</h3>
									</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totNotAppeared}</h3>
									</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totIncomplete}</h3>
									</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totNotUploaded}</h3>
									</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totUploaded}</h3>
									</td>
								</tr>
							
								</table>
								<c:set var="totAllocated" value="0"/>
								<c:set var="totNotAppeared" value="0"/>
								<c:set var="totIncomplete" value="0"/>
								<c:set var="totNotUploaded" value="0"/>
								<c:set var="totUploaded" value="0"/>
							</c:if>

							<table class="table table-striped table-bordered" id="demotable">
								<tr>
									<th colspan="6" class="dark-blue">
										${candExam.examEventName}</th>
								</tr>
								<tr>
									<th rowspan="2" style="text-align: center;" width="50%"><spring:message
											code="admindashboard.Paper" /></th>
									<th rowspan="2" style="text-align: center;"><spring:message
											code="admindashboard.AllocatedCandidates" /></th>
									<th rowspan="2" style="text-align: center;"><spring:message
											code="admindashboard.notAppeared" /></th>
									<th rowspan="2" style="text-align: center;"><spring:message
											code="admindashboard.IncompleteExams" /></th>
									<th colspan="2" style="text-align: center;" width="25%"><spring:message
											code="admindashboard.CompletedExams" /></th>

								</tr>
								<tr>


									<th style="text-align: center;"><spring:message
											code="admindashboard.NotUploaded" /></th>
									<th style="text-align: center;"><spring:message
											code="admindashboard.Uploaded" /></th>
								</tr>

								<tr>
									<c:set var="totAllocated" value="${totAllocated + candExam.totalCandidates}"/>
									<c:set var="totNotAppeared" value="${totNotAppeared + candExam.notAppearedCandidates}"/>
									<c:set var="totIncomplete" value="${totIncomplete + candExam.incompleteExamCount}"/>
									<td>${candExam.paperName}</td>
									<td style="text-align: center;"><a
										href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=0" class="candCount"><h3
												class="dashboard-header">${candExam.totalCandidates}</h3></a>

									</td>
									<td style="text-align: center;"><a
										href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=1" class="candCount"><h3
												style="color: red; line-height: 10px;">${candExam.notAppearedCandidates}</h3></a></td>
									<td style="text-align: center;"><a
										href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=2" class="candCount"><h3
												style="color: red; line-height: 10px;">${candExam.incompleteExamCount}</h3></a>

									</td>

									<td style="text-align: center;">
									<c:if test="${candExam.uploadFlag!=2}">
										<c:set var="totNotUploaded" value="${totNotUploaded + candExam.notUploadedExamCount}"/>
										<c:set var="totUploaded" value="${totUploaded + candExam.uploadedExamCount}"/>
										<a href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=3" class="candCount">
										<h3 style="color: #297dbc; line-height: 10px;">${candExam.notUploadedExamCount}</h3></a>
									</c:if>
									<c:if test="${candExam.uploadFlag==2}">
										<c:set var="noupload" value="1"/>
										<h3 class="dashboard-header">*</h3>
									</c:if>
									</td>
									<td style="text-align: center;">
									<c:if test="${candExam.uploadFlag!=2}">
										<a href="candidateDetails?paperID=${candExam.paperID}&examEventID=${candExam.examEventID}&flag=4" class="candCount">
										<h3 class="dashboard-header">${candExam.uploadedExamCount}</h3></a>
									</c:if>
									<c:if test="${candExam.uploadFlag==2}">
										<c:set var="noupload" value="1"/>
										<h3 class="dashboard-header">*</h3>
									</c:if>
									</td>
								</tr>
								</c:otherwise>
								</c:choose>



								<c:set var="examId" value="${candExam.examEventID}" />

								</c:forEach>


								<tr>
									<td> Total</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totAllocated}</h3>
									</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totNotAppeared}</h3>
									</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totIncomplete}</h3>
									</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totNotUploaded}</h3>
									</td>
									<td style="text-align: center;">
										<h3	class="dashboard-header">${totUploaded}</h3>
									</td>
								</tr>
							</table>
			<c:if test="${noupload==1}">
				 <div class="alert alert-info disableNotupload">
			     	<h3 class="dashboard-header">&nbsp;*&nbsp;</h3>-&nbsp; <spring:message code="admindashboard.StarIndicate" />
			    </div>
			</c:if>
			</c:if>
			<div id="APIURLInputModal" class="modal hide fade in" style="display: none;" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
				<div class="modal-header">
					<h3><spring:message code="admindashboard.ConfigureERAURL" /></h3>
				</div>
				<div class="modal-body form-horizontal">
					<div class="control-group">
	    				<label class="control-label" for="inputEmail"><spring:message code="admindashboard.ERAURL" />:</label>
		                <div class="controls">							
							<input type="text" id="eraURLtxt" name="eraURLtxt" style="width:70%;" placeholder="ERA Server IP Or ERA Server Name">
							<br/><span id="lblerror" class="blinking"></span><br>
							<span id="lblmsg" class="blinkingsuccess"></span><br>
						</div>
					</div>
				</div>
				
				<div class="modal-footer">
					<a class="btn" id="savebtn" onclick="validateURL()"><spring:message code="admindashboard.Save" /></a> 
				</div>
			</div>

		</div>
	

		<!-- upload Data -->
		<%-- <%@include file="dataUpload.jsp"%> --%>

		<script type="text/javascript">
			$(document).ready(function() {
				$("#lblerror").hide();
				$("#lblmsg").hide();
				var showAPIURLInputPopup=${showAPIURLInputPopup};
				if(showAPIURLInputPopup)
				{
					$('#APIURLInputModal').modal('show') ;
				}
			// disable link if candidate count is "0"
					 
						  $('.candCount').each(function(i, obj) {
							if($(this).text() == '0'){
								//$(this).prop("href","#");
								$(this).click(function(e) { e.preventDefault()}); 
							}
							
							});

	

			});
			function validateURL()
			{
				var url = $("#eraURLtxt").val();
				if(url.length===0)
				{
					$("#lblerror").show();
					$("#lblerror").text('<spring:message code="admindashboard.EnterValidERAURL" />');
					setTimeout(function () {
						$("#lblerror").hide();
				    }, 5000); 
					return false;
				}
				else
				{
					url='http://'+url+':4337/o/checkstatus'
					var dat = JSON.stringify({
						"name" : url
					});
					$.ajax({
					    type: 'POST',
					    url: "checkERAURL.ajax",
					    data: dat,
					    contentType : "application/json",
						dataType : "json",
					    success: function(response){
					        
					        console.log("validateURL success block: "+response);
							if(response)
							{
								saveURL();
								return true;
							}
							else
							{
								$("#lblerror").show();
								$("#lblerror").text('<spring:message code="admindashboard.EnterValidERAURL" />');
								setTimeout(function () {
									$("#lblerror").hide();
							    }, 5000); 
								return false;
							}
					    },
					    error: function(jqXHR, textStatus, errorThrown) {
					    	console.log('Status Code: '+jqXHR.status);
					    	console.log('Text Status: '+textStatus);
					    	console.log('Error: '+errorThrown);
					    	$("#lblerror").show();
					    	$("#lblerror").text('<spring:message code="admindashboard.EnterValidERAURL" />');
							setTimeout(function () {
								$("#lblerror").hide();
						    }, 5000); 
							return false;
					    }
					});
				}
			}
			function saveURL(){
				var dat = JSON.stringify({
					"name" : $("#eraURLtxt").val()
				});
				$.ajax({
					url : "saveERAURLforAuth.ajax",
					type : "POST",
					data : dat,
					contentType : "application/json",
					dataType : "json",
					success : function(response) {
						console.log("saveURL success block: "+response);
						if(response)
						{
							$("#lblmsg").show();
							$("#lblmsg").text('<spring:message code="admindashboard.URLsavedsuccessfully" />');
							setTimeout(function () {
								$("#lblmsg").hide();
						    },5000);
							setTimeout(function () {
								$('#APIURLInputModal').modal('hide') ;
								}, 2000);
						}
						else
						{
							$("#lblerror").show();
							$("#lblerror").text('<spring:message code="admindashboard.ErrorinsavingURLPleasere-try" />');
							setTimeout(function () {
								$("#lblerror").hide();
						    }, 5000);
						}
					},
					error : function() {
						console.log("error block: ");
						$("#lblerror").show();
						$("#lblerror").text('<spring:message code="admindashboard.ErrorinsavingURLPleasere-try" />');
						setTimeout(function () {
							$("#lblerror").hide();
					    }, 5000);
					}
				});
				
			}
			
			function isUrlValid(url) {
			    return /^(https?|s?ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(url);
			}
		</script>
	</fieldset>
</body>
</html>