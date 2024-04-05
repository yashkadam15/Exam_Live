<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<a class="btn btn-navbar" data-toggle="collapse"
	data-target=".nav-collapse"> <span class="icon-bar"></span> <span
	class="icon-bar"></span> <span class="icon-bar"></span>
</a>
<a class="brand" href="#">Main Menu</a>
<div class="nav-collapse collapse">
	<ul class="nav side-menu">
		<c:choose>
			<c:when test="${sessionScope.user.object != null and sessionScope.user.isThirdPartySession == true}">
			<!-- Manu not availalble to display -->
			</c:when>
			<c:otherwise>
				<!-- Menus for Admin Login Section -->
		<c:if test="${loginType=='Admin'}">
			<!-- Menus for Administrator -->
			<c:if test="${roleID == 1}">
				<li><a href="../dashboard/adminDashBoard"><i
						class="icon-th-large"></i> <spring:message code="menu.dashBoard" /></a></li>
						<c:if test="${clientid==4}">
							<li><a href="../EligibilityCertificate/eligibilityCertificateNoTyping"><i
							class="icon-list-alt"></i><spring:message code="certificate.eligibilityCertificate"/></a></li>
						</c:if>

				<li><a href="../EnableDisableExamEvent/manageExamEvent"><i
						class="icon-star-empty"></i> <spring:message
							code="leftmenu.ManageExamEvent" /></a></li>
			<li><a href="../syncData/selectSyncEvent"><i
						class="icon-download-alt"></i><spring:message code="leftmenu.SynchroniseExamData" /></a></li>
			<li><a href="../examEventClosure/examActivityLogSearch"><i
						class="icon-download-alt"></i><spring:message code="leftmenu.examActivityLog"/></a></li>
				<c:if test="${iear}">
					<li><a href="../dashboard/editERAURL"><i class="icon-th-large"></i><spring:message code="leftmenu.editERAURL"/></a></li>
				</c:if>	
			</c:if>

			<!-- Menus for Subject Admin Login -->
			<c:if test="${roleID == 2}">
				<li><a href="../dashboard/subjectAdminDashBoard"><i
						class="icon-th-large"></i> <spring:message code="menu.dashBoard" /></a></li>
			</c:if>			
		</c:if> 

		<!-- Menus for Solo Login -->
		<c:if test="${loginType=='Solo'}">
			<li><a href="../candidateModule/homepage"><i
					class="icon-th-large"></i> <spring:message
						code="menu.CandidateDashBoard" /></a></li>

		</c:if>
		<!-- Menus for Group Login -->
		<c:if test="${loginType=='Group'}">
			<li><a href="../groupCandidatesModule/grouphomepage"><i
					class="icon-th-large"></i> <spring:message
						code="menu.CandidateDashBoard" /></a></li>
			<li><a href="../groupCandidatesModule/viewActiveExamEvent"><i
					class="icon-th-large"></i> <spring:message
						code="menu.activitycalender" /></a></li>

		</c:if>
	
		<!-- Menu for change and reset supervisor password -->
	
		<c:if test="${roleID == 1}">
			<li><a href="../login/SupervisorchangePwd"><i
						class="icon-th-large"></i> <spring:message
							code="menu.supervisorPwdChange" /></a></li>
			<li><a href="../login/resetSupervisorPwd"><i
						class="icon-th-large"></i> <spring:message
							code="menu.supervisorPwdReset" /></a></li>
						<!-- 	Upload status -->
									<li><a href="../dashboard/uploadStatus"><i
						class="icon-th-large"></i> <spring:message
							code="menu.uploadStatus" /></a></li>
				<li><a href="../resetExamStatus/resetStatus"><i class="icon-th-large">
				</i> <spring:message code="resetExamStatus.header"/></a></li>
				<li><a href="../examEventClosure/bulkEndExamGet"><i class="icon-th-large"></i> <spring:message code="bulkEndExam.menu"/></a></li>
				<li><a href="../suspendCandidate/eventList"><i class="icon-th-large"></i> <spring:message code="suspendExam.SuspendExam"/></a></li>
			    <li><a href="../releaseCandidate/eventList"><i class="icon-th-large"></i>Suspension Report/Release</a></li>
		</c:if>
		<!-- Added one more role i.e. Call Center(4) for that added condition Yograj 24-Jun-2016 -->
		<c:if test="${roleID == 4}">
			<li><a href="../dashboard/adminDashBoard">
				<i class="icon-th-large"></i>
				<spring:message code="menu.dashBoard" /></a>
			</li>
			<li><a href="../resetExamStatus/resetStatus">
				<i class="icon-th-large"></i> 
				<spring:message code="resetExamStatus.header"/></a>
			</li>
			<li><a href="../login/SupervisorchangePwd"><i
						class="icon-th-large"></i> <spring:message
							code="menu.supervisorPwdChange" /></a>
							</li>
		</c:if>
		
		
		<!-- notification icon -->
		<c:if test="${notificationUrl != null && clientid==1}">
			<li><a href="${notificationUrl}" target="_blank"><img
					src="<c:url value="../resources/images/live-notification-icon.jpg"></c:url>"
					alt=""></a></li>
		</c:if>
			</c:otherwise>
		</c:choose>
		

	</ul>

</div>


