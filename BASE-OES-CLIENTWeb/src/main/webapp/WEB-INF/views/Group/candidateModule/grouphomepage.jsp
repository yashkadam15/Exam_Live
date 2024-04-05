<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<html>
<head>
<title><spring:message code="grouphomepage.PageTitle" /></title>
<spring:message code="project.resources" var="resourcespath" />
<style type="text/css">
a {
	cursor: pointer;
}

.imageSize {
	height: 70px;
	width: 70px;
}

.imageSizeRes {
	height: 50px;
	width: 50px;
}
/*Reena :10/10/16 inline classes name changed from user-one to dashboard-user-one and so on till user-ten to avoid conflict with new added classes in template.css for chatwindow*/
.dashboard-user-one {
	background-color: #ee5e37;
	-webkit-box-shadow: inset 0 0 0 1px #c83811;
	-moz-box-shadow: inset 0 0 0 1px #c83811;
	box-shadow: inset 0 0 0 1px #c83811;
}

.dashboard-user-two {
	background-color: #9cd159;
	-webkit-box-shadow: inset 0 0 0 1px #76ad30;
	-moz-box-shadow: inset 0 0 0 1px #76ad30;
	box-shadow: inset 0 0 0 1px #76ad30;
}

.dashboard-user-three {
	background-color: #65a6ff;
	-webkit-box-shadow: inset 0 0 0 1px #187aff;
	-moz-box-shadow: inset 0 0 0 1px #187aff;
	box-shadow: inset 0 0 0 1px #187aff;
}

.dashboard-user-four {
	background-color: #ffcc00;
	-webkit-box-shadow: inset 0 0 0 1px #b38f00;
	-moz-box-shadow: inset 0 0 0 1px #b38f00;
	box-shadow: inset 0 0 0 1px #b38f00;
}

.dashboard-user-five {
	background-color: #aa73c2;
	-webkit-box-shadow: inset 0 0 0 1px #8647a2;
	-moz-box-shadow: inset 0 0 0 1px #8647a2;
	box-shadow: inset 0 0 0 1px #8647a2;
}

.dashboard-user-six {
	background-color: #f02424;
	-webkit-box-shadow: 0 0 1px #f02424;
	-moz-box-shadow: 0 0 1px #f02424;
	box-shadow: 0 0 1px #f02424;
}

.dashboard-user-seven {
	background-color: #24ccf0;
	-webkit-box-shadow: inset 0 0 0 1px #0d9cbb;
	-moz-box-shadow: inset 0 0 0 1px #0d9cbb;
	box-shadow: inset 0 0 0 1px #0d9cbb;
}

.dashboard-user-eight {
	background-color: #bababa;
	-webkit-box-shadow: inset 0 0 0 1px #949494;
	-moz-box-shadow: inset 0 0 0 1px #949494;
	box-shadow: inset 0 0 0 1px #949494;
}

.dashboard-user-nine {
	background-color: #dea700;
	-webkit-box-shadow: inset 0 0 0 1px #926d00;
	-moz-box-shadow: inset 0 0 0 1px #926d00;
	box-shadow: inset 0 0 0 1px #926d00;
}

.dashboard-user-ten {
	background-color: #e670dc;
	-webkit-box-shadow: inset 0 0 0 1px #db2fcc;
	-moz-box-shadow: inset 0 0 0 1px #db2fcc;
	box-shadow: inset 0 0 0 1px #db2fcc;
}

.alignThumbnailAtCenter {
	display: -webkit-box;
	display: -moz-box;
	display: -ms-flexbox;
	display: -webkit-flex;
	display: flex;
	-webkit-box-direction: normal;
	-moz-box-direction: normal;
	-webkit-box-orient: horizontal;
	-moz-box-orient: horizontal;
	-webkit-flex-direction: row;
	-ms-flex-direction: row;
	flex-direction: row;
	-webkit-flex-wrap: wrap;
	-ms-flex-wrap: wrap;
	flex-wrap: wrap;
	-webkit-box-pack: center;
	-moz-box-pack: center;
	-webkit-justify-content: center;
	-ms-flex-pack: center;
	justify-content: center;
	-webkit-box-align: center;
	-moz-box-align: center;
	-webkit-align-items: center;
	-ms-flex-align: center;
	align-items: center;
}

.dashboardImageWrapper {
	text-align: left;
	display: inline-block;
}

.dashboardImageWrapperContainer {
	text-align: center;
	display: inline-block;
	width: 100%;
}
</style>
<!--[if IE 7]>
<style type="text/css">
.ql-box {width: 140px; padding: 20px 15px 10px; margin: 5px 10px;}
.liquid-responsive .liquid-slider .panel .panel-wrapper {padding: 0 130px}
.liquid-slider-wrapper .liquid-nav-left-arrow, .liquid-slider-wrapper .liquid-nav-right-arrow {height: 230px}
</style>
<![endif]-->
<script type="text/javascript">
	$(document).ready(function() {

		$('.lnkTakeTestbtn').click(function(e) {
			e.preventDefault();
			if ($(this).data('mode') === 'FullScreen') {
				window.open($(this).data('lnk'), "ExamPage", "fullscreen=yes,scrollbars=yes,location=no");
			} else if ($(this).data('mode') === 'NormalScreen') {
				window.location.href = $(this).data('lnk');
			}
		});

		$('#slider-id').liquidSlider({
			autoSlide : false,
			dynamicTabs : false,
			hoverArrows : false
		});
	});
</script>
<link href="<c:url value='/resources/style/style-slider.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/liquid-slider.css'></c:url>" rel="stylesheet">
<script type="text/javascript" src="<c:url value='/resources/js/jquery.easing.1.3.js'></c:url>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jquery.touchSwipe.min.js'></c:url>"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jquery.liquid-slider.min.js'></c:url>"></script>
</head>
<body>

	<c:set value="dd-MMM-yyyy" var="dateFormatForAllPapers" />
	<fieldset class="well">

		<legend>
			<span><img src="<c:url value="../resources/images/dashboard.png"></c:url>" alt=""> <spring:message code="grouphomepage.MyHome" /></span>
		</legend>

		<div class="holder">


			<div id="myCarousel" class="carousel slide" style="margin-bottom: 0px; margin-top: 3px">
				<!-- Carousel items -->
				<div class="carousel-inner">

					<c:forEach var="candidateInfo" items="${user.venueUser}" varStatus="j">

						<c:if test="${ (j.index+1) mod 4==1}">
							<c:choose>
								<c:when test="${j.index==0}">
									<div class="active item">
								</c:when>
								<c:otherwise>
									<div class="item">
								</c:otherwise>
							</c:choose>
							<div class="dashboardImageWrapperContainer">
								<c:set var="endDiv1" value="0" />
						</c:if>
						<c:set var="endDiv1" value="${endDiv1+1}" />
						<c:set var="endDiv2" value="0" />
						<div class="dashboardImageWrapper">
							<div class="thumbnail dashboard-user-${userColors[j.index]}" style="text-align: center; color: white; font-size: x-small;">
								<c:choose>
									<c:when test="${not empty candidateInfo.userPhoto and fn:length(candidateInfo.userPhoto) > 0}">
										<img class="imageSize" src="${imgPath}${candidateInfo.userPhoto}" onerror="this.src='${imgPath}<spring:message code="instruction.defaultPhoto"/>';">
									</c:when>
									<c:otherwise>
										<img class="imageSize" src="${imgPath}<spring:message code="instruction.defaultPhoto"/>" alt="default">
									</c:otherwise>
								</c:choose>
								<div style="padding-top: 3px;">${candidateInfo.userName}</div>
							</div>
						</div>


						<c:if test="${ endDiv1 == 4}">
				</div>
			</div>
			<c:set var="endDiv2" value="1" />
			</c:if>

			</c:forEach>
			<c:if test="${ endDiv2 == 0}">
		</div>
		</div>
		</c:if>

		</div>

		<!-- Carousel nav -->
		<a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a> <a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
		</div>





		<div id="showScheduledPapers">
			<c:choose>
				<c:when test="${fn:length(activePapers) != 0}">
					<br>
					<div class="box">
						<div class="box-header">
							<h4>
								<spring:message code="grouphomepage.activetests" />
							</h4>
							<br> <br>
						</div>
						<div class="box-body">
							<table class="table table-bordered table-complex">

								<!-- get exam event map -->
								<c:forEach var="examMap" items="${examEventMap}">
									<thead>
										<tr>
											<th colspan="4" class="text-left">${examMap.value}</th>
										</tr>
									</thead>
									<tbody>
										<!-- relate exam-display Category -->
										<c:forEach var="examDisplayCatgoryRel" items="${examDisplayCategoryRelationMap}">

											<c:if test="${examDisplayCatgoryRel.key==examMap.key}">

												<!-- get list of display Category from map  -->
												<c:forEach var="displayCategoryID" items="${examDisplayCatgoryRel.value}" varStatus="headerStatus">
													<c:forEach var="displayCategoryName" items="${displayCategoryMap}" varStatus="status">
														<c:if test="${displayCategoryID==displayCategoryName.key }">
															<tr>
																<td class="highlight span3">${displayCategoryName.value}</td>
																<c:choose>
																	<c:when test="${headerStatus.first}">
																		<td class="highlight text-center span1"><spring:message code="grouphomepage.exiresOn" /></td>
																		<td class="highlight text-center span1"><spring:message code="grouphomepage.attemptDate" /></td>
																		<td class="highlight text-center span2"></td>
																	</c:when>
																	<c:otherwise>
																		<td class="highlight text-center span1"></td>
																		<td class="highlight text-center span1"></td>
																		<td class="highlight text-center span2"></td>
																	</c:otherwise>
																</c:choose>

															</tr>

															<c:forEach var="paper" items="${activePapers}">
																<!-- get paper from corresponding exam And display Category -->
																<c:if test="${paper.examEvent.examEventID==examMap.key and paper.displayCategoryLanguage.fkDisplayCategoryID==displayCategoryID }">
																	<tr>

																		<td><c:choose>
																				<c:when test="${paper.assessmentType=='Solo' }">
																					<i class="icon-user "></i>
																				</c:when>
																				<c:when test="${paper.assessmentType=='Group' }">
																					<i class="icon-def-group"></i>
																				</c:when>
																			</c:choose> &nbsp;&nbsp;${paper.paper.name}&nbsp;&nbsp; <!-- show paper status : new,not complete or complete --> <c:choose>
																				<c:when test="${paper.paperStatus!=1}">
																					<span class="label label-success"><spring:message code="grouphomepage.new" /></span>
																				</c:when>
																			</c:choose></td>
																		<td class="text-center"><c:if test="${paper.expiryDate != null}">
																				<fmt:formatDate pattern="${dateFormatForAllPapers}" value="${paper.expiryDate}" />
																			</c:if></td>
																		<td class="text-center"><c:if test="${paper.attemptDate != null}">
																				<fmt:formatDate pattern="${dateFormatForAllPapers}" value="${paper.attemptDate}" />
																			</c:if></td>
																		<td class="text-center">
																		<a class="btn btn-red viewSyllabusBtn"  data-value="${paper.paper.paperID}" ><spring:message code="grouphomepage.activeViewsyllabus" /></a> <c:choose>
																				<c:when test="${paper.expiryDate == null && paper.paperStatus!=1}">
																					<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-purple lnkTakeTestbtn" data-lnk="../groupExam/groupInfo?examEventID=${paper.examEvent.examEventID}&paperID=${paper.paper.paperID}"><spring:message
																							code="grouphomepage.takeATest" /></a>
																				</c:when>
																				<c:when test="${paper.expiryDate != null && paper.paperStatus!=1}">
																					<a id="lnkTakeTest" data-mode="${paper.examEventPaperDetails.examWindowMode}" class="btn btn-purple lnkTakeTestbtn" data-lnk="../groupExam/groupInfo?examEventID=${paper.examEvent.examEventID}&paperID=${paper.paper.paperID}&scheduleEnd=${paper.scheduleMaster.scheduleEnd.time}"><spring:message
																							code="grouphomepage.takeATest" /></a>
																				</c:when>
																				<c:when test="${paper.expiryDate != null && paper.paperStatus==1 and paper.examEventPaperDetails.showAnalysis==true}">
																					<a class="btn btn-warning" href="../GroupResultAnalysis/groupAnalysisCandidateList?examEventId=${paper.examEvent.examEventID}&paperId=${paper.paper.paperID}">&nbsp;&nbsp;&nbsp;<spring:message code="grouphomepage.ViewAnalysis" />&nbsp;&nbsp;&nbsp;
																					</a>
																				</c:when>
																				<c:when test="${paper.expiryDate != null && paper.paperStatus==1 and paper.examEventPaperDetails.showAnalysis!=true}">
																					<a class="btn btn-disabled" href="javascript:void(0);">&nbsp;&nbsp;&nbsp;<spring:message code="grouphomepage.ViewAnalysis" />&nbsp;&nbsp;&nbsp;
																					</a>
																				</c:when>
																				<c:otherwise>
																					<a class="btn btn-disabled" href="javascript:void(0);"><spring:message code="grouphomepage.takeATest" /> </a>
																				</c:otherwise>
																			</c:choose></td>
																	</tr>
																</c:if>

															</c:forEach>

														</c:if>

													</c:forEach>
												</c:forEach>
											</c:if>

										</c:forEach>
								</c:forEach>
								</tbody>

							</table>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<br />
					<div class="alert alert-info">
						<a class="close" data-dismiss="alert" href="#">&times;</a> <span><spring:message code="grouphomepage.NoAvailabelTilte" /> : </span>
						<spring:message code="grouphomepage.NoAvailabelInfo" />
					</div>
				</c:otherwise>
			</c:choose>
		</div>
		</div>
	</fieldset>



	<!-- all papers syllabus Modal -->
	<input id="syllabusIframeURL" type="hidden" value="<c:url value="/groupCandidatesModule/viewPaperSyllabus"></c:url>" />
	<div id="modal-viewSyllabus" Class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false" data-keyboard="true" data-backdrop="static">
		<div class="modal-header">
			<h3 id="syllabusHeaderPart"></h3>
		</div>
		<div class="modal-body" style="padding: 10px;">
			<h4 style="text-decoration: underline;">
				<spring:message code="Candidate.syllabus" />
			</h4>
			<label id="loadingsyllabus"><spring:message code="homapage.loadingsyllabus" /> </label>
			<!-- iframe -->
			<iframe src="" style="display: none; margin: 2px 0 0 0; width: 100%; border: none; height: 350px;" id="hiddenIframe"></iframe>
		</div>
		<div class="modal-footer">
			<button class="btn" data-dismiss="modal" aria-hidden="true">
				<spring:message code="homepage.Exit" />
			</button>
		</div>
	</div>
	
	
	<script type="text/javascript">
		$(document).ready(function() {
			/* script added for exam client contact amoghs b4 modification */
			if(navigator.userAgent.search('MOSB') >= 0 && typeof js != "undefined"){
				js.getEventId($('#eventId').val());
			}
			//view syllabus
			$(".viewSyllabusBtn").click(function(e) {
				$("#hiddenIframe").hide();
				$("#loadingsyllabus").show();
				$('#modal-viewSyllabus').modal('show');
				var paperID = $(this).data("value");
				var url = $("#syllabusIframeURL").val();
				$("#hiddenIframe").prop("src", "").prop("src", url + "?paperID=" + paperID);
				$('#hiddenIframe').load(function() {
					$("#loadingsyllabus").hide();
					$("#hiddenIframe").show();
				});
			});
			
		});
	</script>
</body>
</html>
