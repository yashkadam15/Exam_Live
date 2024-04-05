<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="Exam.Title" /></title>

<spring:theme code="curdetailtheme" var="curdetailtheme" />
<spring:theme code="playertheme" var="playertheme" />

<%-- <link href="<c:url value='/resources/style/template.css'></c:url>" rel="stylesheet"> --%>
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<!--[if IE 7]>
<style>
.exam-info .exam-ins .span5 {margin-left:0}
.exam-info .exam-ins .span7 .btn {margin-top: 4px; padding-top: 0; height:5px}
.quick-ques > .btn {border:1px solid #ccc}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.scrollbar.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/Legends.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/QuestionRender.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>

<style>
body {
	-webkit-user-select: none; /* Chrome all / Safari all */
	-moz-user-select: none; /* Firefox all */
	-ms-user-select: none; /* IE 10+ */
	/* No support for these yet, use at own risk */
	-o-user-select: none;
	user-select: none;
}
</style>
</head>
<body class="osp-user-one" style="background-color: transparent">
	<form:form action="ProcessQuestion" method="POST" id="frmQues" modelAttribute="examViewModel">
		<div class="osp-question" style="overflow-y: hidden;">
			<div class="inner-questions-area">
				<input type="hidden" id="hidExt" name="hidExt" value="-1" />
				<c:choose>
					<c:when test="${mode != null}">
						<input type="hidden" id="mode" name="mode" value="${mode }" />
					</c:when>
					<c:otherwise>
						<input type="hidden" id="mode" name="mode" value="off" />
					</c:otherwise>
				</c:choose>
				<input type="hidden" id="examineeCandidateID" name="examineeCandidateID" value="${examineeCandidateID}"/>
				<input type="hidden" id="attempterCandidateID" name="attempterCandidateID" value="${attempterCandidateID}"/>
				<input type="hidden" id="examineeSelOpIDs" name="examineeSelOpIDs" value="${examineeSelOpIDs}"/>
				<input type="hidden" id="examineeSelConfLevel" name="examineeSelConfLevel" value="${examineeSelConfLevel}"/>
				<input type="hidden" id="candidateExamID" name="candidateExamID" value="${candidateExamID}"/>
				<input type="hidden" id="examEventID" name="examEventID" value="${examEventID }" />
				<input type="hidden" id="paperID" name="paperID" value="${paperID }" />
				

				<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.multimedias[0].itemLanguage.item.itemID }" />
				<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
				<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
				<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
				
				<input type="hidden" value="0" id="mpc" /> 
				<input type="hidden" id="sectionID" name="sectionID" value="${activeSec}" />
				<input type="hidden" value="NOOPT" id="itype" name ="itype" />				

			<div class="question">
				<div class="pull-right" style="display: none">
					<select id="viewLang"> 
		              <c:forEach items="${examViewModel.multimedias }" var="item" varStatus="i">
		              		<c:if test="${selectedLang == item.itemLanguage.fkLanguageID}">
		              			<option selected="selected" value="${item.itemLanguage.fkLanguageID}">${item.itemLanguage.language.languageName }</option>
		              		</c:if>	              		          
		              </c:forEach>
	              	</select>
              	</div>
			</div>
			<div class="questiondiv scrollbar-outer">
				<c:forEach items="${examViewModel.multimedias }" var="item" varStatus="i">
						<c:if test="${selectedLang == item.itemLanguage.fkLanguageID}">
							<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
								<div class="cq-holder clearfix">
									<div class="left-holder">
										<div class="comprehension scrollbar-outer min-h-chat">
											<div class="qVideo-holder">	
												<div class="wrap">
													<p class="question-wrap">${item.itemText }</p>
													<c:if test="${item.itemFilePath != null && item.itemFilePath != ''  && fn:length(item.itemFilePath) > 0}">
													 <div id="MMplayer_${i.index+1}" data-mediamode="exam" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="false" data-mediatitle=""></div> 
												</c:if>
												</div>
												
											</div>
										</div>
									</div>
									<div class="right-holder">
										<div class="cmpsqdiv comprehension-Questions scrollbar-outer min-h-chat">
											<div class="chating-box">
												<c:forEach items="${item.subItemList}" var="subItem" varStatus="j">
													<div class="box" data-seq="${j.index}">
														<div class="que">
															<strong><spring:message code="Exam.Question" /> ${j.index+1} : </strong>${subItem.subItemText}
														</div>
														<div class="lastAdded" style="display: none;"></div>
														<c:forEach var="candidateItemAssociation" items="${examViewModel.candidateItemAssociationList}" varStatus="k">
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateExamItemID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].fkCandidateExamID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].fkCandidateID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].fkItemID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].fkParentItemID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].item.Itemtype" value="NOOPT"/>
															<form:hidden path="candidateItemAssociationList[${k.index}].confidenceLevel" id="conf${candidateItemAssociation.fkCandidateID}" value="Low"/>
															
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateExamItemID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].fkCandidateExamID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].fkCandidateID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].fkItemID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].fkParentItemID" />
															
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateAnswers[0].candidateExamItemID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkcandidateID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkItemID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateAnswers[0].candidateAnswerID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkParentItemID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkCandidateExamID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateAnswers[0].fkExamEventID" />
															<form:hidden path="candidateItemAssociationList[${k.index}].candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionFilePath" class="optionFilePath${candidateItemAssociation.fkCandidateID}"/>
															<div id="${candidateItemAssociation.fkCandidateID}" style="display: none;" data-seq="${k.index}">
																<div class="user-img">
																	<img src="" onerror="this.src='${imgPath}<spring:message code="instruction.defaultPhoto"/>';">
																	<span class="full-w" id="fullname">
																																		
																	</span>
																	<div class="btn-box">
																		<button class="btn  btn-mini btn-info recordbtn" data-ansduration="${subItem.answerDuration }" data-active="false" data-ansmode="${subItem.answeringMode }" data-itemid="${examViewModel.candidateItemAssociationList[k.index].candidateSubItemAssociations[j.index].candidateAnswers[0].fkItemID }" data-candid="${candidateItemAssociation.fkCandidateID}" title="Record Video">
																			<i class="record-vedeo"></i>
																		</button>
																		<!-- condition based,show after recording is palyable -->
																		<button class="btn btn-user btn-warning btn-mini playbtn" title="Play Video">
																			<i class="video-play"></i>
																		</button>
																	</div>
																</div>
																<span class="full-w notification"> <spring:message code="chatWindow.recordAns" /></span>
															</div>															
														</c:forEach>														
													</div>
													<div class="clearfix"></div>
												</c:forEach>												
											</div>
										</div>
									</div>
								</div>
							</div>
						</c:if>
				</c:forEach>
			</div>
		</div>
		</div>
		<!-- Confidence Level -->
		<div class="osp-confidence">

		</div>

		<!-- Submit -->
		<div class="pg-controls">
			<span class="align"></span>
			<button disabled="" id="ratepeer" class="btn btn-blue" href="#"><spring:message code="chatWindow.ratePeer" /></button>
			<input type="checkbox" id="ratingdone" name="confidenceLevel" value="" style="display: none;">
			<button class="btn btn-success" name="Save" id="Save" type="submit" style="display: none;">
				<spring:message code="Exam.submitAnswerbtn" />
			</button>
		</div>
	</form:form>
</body>
</html>
