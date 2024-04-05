
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<html>
<head>
<title>Insert title here</title>
<spring:message code="project.resources" var="resourcespath" />

<link href="<c:url value='/resources/style/admin/base-admin.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/admin/dashboard.css'></c:url>" rel="stylesheet">

<style type="text/css">
.widget-content-highlight {
	background: #a3d48e;
}

.activemonth {
	background: #a3d48e;
}

.activemonth h4 {
	color: #345b23;
}

.widget-content {
	height: 85px;
}

a {
	cursor: pointer;
}
</style>
</head>
<body>
	<fieldset class="well">

		<div id="tabbable" class="holder">
			<ul class="nav nav-tabs" id="myTab">
				<li><a href="../candidateModule/viewtestscore"> <spring:message code="allTestAnalysis.briefAnalysis"/></a></li>
				<li><a href="../candidateModule/viewoverall" data-toggle="tab"><spring:message code="allTestAnalysis.overallAnalysis"/> </a></li>
				<li><a href="../candidateModule/questionByquestion"><spring:message code="allTestAnalysis.queWiseAnalysis"/> </a></li>
				<li><a href="../candidateModule/topicwise"><spring:message code="allTestAnalysis.topicWiseAnalysis"/></a></li>
				<li><a href="../candidateModule/difficultylevelwise"><spring:message code="allTestAnalysis.diffLevelWiseAnalysis"/> </a></li>
				<li class="active"><a
					href="../candidateModule/allTestsAnalysis"><spring:message code="allTestAnalysis.testHistory"/></a></li>
			</ul>


			<div class="tab-content holder">
				<div id="tab1" class="tab-pane active">


					<legend>
						<span><spring:message code="allTestAnalysis.testHistory"/></span>
					</legend>
					<div class="alert alert-info">
						<img src="../resources/images/green.png">&nbsp; <spring:message code="allTestAnalysis.activeWeekofCurrentMonth"/>
					</div>
					<div id="myCarousel" class="carousel slide">

						<!-- Carousel items -->

						<div class="carousel-inner">

							<div class="item">
								<div class="row-fluid">


									<div class="alert alert-Warning thumbnail">
										<div class="alert alert-info thumbnail">
											<h4><spring:message code="allTestAnalysis.april13"/></h4>
										</div>

										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week1"/></b>
													</h3>


												</div>
												<div class="widget-content ">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.sets"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.measurementsAndDimensions"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.physicalChemistry"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">


												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week2"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.organicChemistry"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.thermodynamics"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.fusionReactions"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week3"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.functions"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.waves"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.setsAndQuadraticEquation"/></a></li>
														<li><a href="../candidateModule/viewtestscore">...</a></li>
													</ul>
												</div>


											</div>
										</div>
										<br>
										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week4"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.surds"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.functions"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.sequenceAndSeries"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week5"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.heat"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.sound"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.mechanics"/></a></li>

													</ul>
												</div>


											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="item">
								<div class="row-fluid">


									<div class="alert alert-Warning thumbnail">
										<div class="alert alert-info thumbnail">
											<h4><spring:message code="allTestAnalysis.may13"/></h4>
										</div>

										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week1"/></b>
													</h3>

												</div>
												<div class="widget-content ">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.sets"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.measurementsAndDimensions"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.physicalChemistry"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">


												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week2"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.organicChemistry"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.thermodynamics"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.fusionReactions"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week3"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.functions"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.waves"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.setsAndQuadraticEquation"/></a></li>
														<li><a href="../candidateModule/viewtestscore">...</a></li>
													</ul>
												</div>


											</div>
										</div>
										<br>
										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week4"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.surds"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.functions"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.sequenceAndSeries"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week5"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.heat"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.sound"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.mechanics"/></a></li>

													</ul>
												</div>


											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="active item highlightTheBox">

								<div class="row-fluid">


									<div class="alert alert-Warning thumbnail">
										<div class="activemonth thumbnail">
											<h4><spring:message code="allTestAnalysis.jun13"/></h4>
										</div>


										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week1"/></b>
													</h3>
												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.sets"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.measurementsAndDimensions"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.physicalChemistry"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">


												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week2"/></b>
													</h3>

												</div>
												<div class="widget-content ">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.organicChemistry"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.thermodynamics"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.fusionReactions"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week3"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.functions"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.waves"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.setsAndQuadraticEquation"/></a></li>
														<li><a href="../candidateModule/viewtestscore">...</a></li>
													</ul>
												</div>


											</div>
										</div>
										<br>
										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header ">
													<h3>
														<b><spring:message code="allTestAnalysis.week4"/></b>
													</h3>

												</div>
												<div class="widget-content ">
													<ul>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.lawOfMotion"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.thermodynamics"/></a></li>
														<li><a href="../candidateModule/viewtestscore"><spring:message code="allTestAnalysis.sets"/></a></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<img src="../resources/images/green.png">&nbsp;<b><spring:message code="allTestAnalysis.week5"/></b>
													</h3>


												</div>
												<div class="widget-content widget-content-highlight">
													<ul>
														<li><a href="../candidateModule/homepage"><spring:message code="allTestAnalysis.measurementsAndDimensions"/></a></li>
														<li><a href="../candidateModule/homepage"><spring:message code="allTestAnalysis.chemicalBonding"/></a></li>
														<li><a href="../candidateModule/homepage"><spring:message code="allTestAnalysis.algebra"/></a></li>
														<li><a href="../candidateModule/homepage"><spring:message code="allTestAnalysis.mechanics"/></a></li>
														<li><a href="../candidateModule/homepage"><spring:message code="allTestAnalysis.physicalChemistry"/> </a></li>
														<li><a href="../candidateModule/homepage"><spring:message code="allTestAnalysis.algebra"/></a></li>

													</ul>
												</div>


											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="item">
								<div class="row-fluid">


									<div class="alert alert-Warning thumbnail">
										<div class="alert alert-info thumbnail">
											<h4><spring:message code="allTestAnalysis.july13"/></h4>
										</div>

										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week1"/></b>
													</h3>


												</div>
												<div class="widget-content ">
													<ul>
														<li><spring:message code="allTestAnalysis.sets"/></li>
														<li><spring:message code="allTestAnalysis.measurementsAndDimensions"/></li>
														<li><spring:message code="allTestAnalysis.physicalChemistry"/></li>

													</ul>
												</div>


											</div>
											<div class="span4">


												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week2"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><spring:message code="allTestAnalysis.organicChemistry"/></li>
														<li><spring:message code="allTestAnalysis.thermodynamics"/></li>
														<li><spring:message code="allTestAnalysis.fusionReactions"/></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week3"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><spring:message code="allTestAnalysis.functions"/></li>
														<li><spring:message code="allTestAnalysis.waves"/></li>
														<li><spring:message code="allTestAnalysis.setsAndQuadraticEquation"/></li>
														<li>...</li>
													</ul>
												</div>


											</div>
										</div>
										<br>
										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week4"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><spring:message code="allTestAnalysis.surds"/></li>
														<li><spring:message code="allTestAnalysis.functions"/></li>
														<li><spring:message code="allTestAnalysis.sequenceAndSeries"/></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week5"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><spring:message code="allTestAnalysis.heat"/></li>
														<li><spring:message code="allTestAnalysis.sound"/></li>
														<li><spring:message code="allTestAnalysis.mechanics"/></li>

													</ul>
												</div>


											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="item">
								<div class="row-fluid">


									<div class="alert alert-Warning thumbnail">
										<div class="alert alert-info thumbnail">
											<h4><spring:message code="allTestAnalysis.aug13"/></h4>
										</div>

										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week1"/></b>
													</h3>


												</div>
												<div class="widget-content ">
													<ul>
														<li><spring:message code="allTestAnalysis.sets"/></li>
														<li><spring:message code="allTestAnalysis.measurementsAndDimensions"/></li>
														<li><spring:message code="allTestAnalysis.physicalChemistry"/></li>

													</ul>
												</div>


											</div>
											<div class="span4">


												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week2"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><spring:message code="allTestAnalysis.organicChemistry"/></li>
														<li><spring:message code="allTestAnalysis.thermodynamics"/></li>
														<li><spring:message code="allTestAnalysis.fusionReactions"/></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week3"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><spring:message code="allTestAnalysis.functions"/></li>
														<li><spring:message code="allTestAnalysis.waves"/></li>
														<li><spring:message code="allTestAnalysis.setsAndQuadraticEquation"/></li>
														<li>...</li>
													</ul>
												</div>


											</div>
										</div>
										<br>
										<div class="row-fluid">
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week4"/></b>
													</h3>


												</div>
												<div class="widget-content">
													<ul>
														<li><spring:message code="allTestAnalysis.surds"/></li>
														<li><spring:message code="allTestAnalysis.functions"/></li>
														<li><spring:message code="allTestAnalysis.sequenceAndSeries"/></li>

													</ul>
												</div>


											</div>
											<div class="span4">
												<div class="widget-header">
													<h3>
														<b><spring:message code="allTestAnalysis.week5"/></b>
													</h3>

												</div>
												<div class="widget-content">
													<ul>
														<li><spring:message code="allTestAnalysis.heat"/></li>
														<li><spring:message code="allTestAnalysis.sound"/></li>
														<li><spring:message code="allTestAnalysis.mechanics"/></li>

													</ul>
												</div>


											</div>
										</div>
									</div>
								</div>
							</div>

						</div>


						<!-- Carousel nav -->
						<a class="carousel-control left" id="previousbtn"
							href="#myCarousel" data-slide="prev">&lsaquo;</a> <a
							class="carousel-control right" href="#myCarousel"
							data-slide="next" id="nextbtn">&rsaquo;</a>
					</div>



				</div>
			</div>
		</div>
		
	

	</fieldset>

	<script type="text/javascript">
		$(function() {

			$('.carousel').carousel('pause');

			/* $("#nextbtn").hide();
			$("#previousbtn").on(
					"click",
					function() {
						//for previous
						//As after 3rd child first become active
						//coution : we have taken three div
						$("#nextbtn").show();
						var status = $(".carousel-inner > div:nth-child(2)")
								.hasClass('active');

						if (status == true) {
							$("#nextbtn").hide();
						} else {
							$("#nextbtn").show();
						}
					});
			$("#nextbtn").on(
					"click",
					function() {
						//for next
						//As after 3rd child first become active
						//coution : we have taken three div
						var status = $(".carousel-inner > div:nth-child(3)")
								.hasClass('active');

						if (status == true) {
							$("#nextbtn").hide();
						} else {
							$("#nextbtn").show();
						}

					});
			 */
		});
	</script>

</body>
</html>