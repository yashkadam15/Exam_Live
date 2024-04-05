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
<spring:theme code="curdetailtheme" var="curdetailtheme"/>

<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/selectFix.css'></c:url>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/style/jplayer.blue.monday.css'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/SCSPlayerSkin.css'></c:url>">

<!--[if IE 7]>
<style>
.exam-info .exam-ins .span5 {margin-left:0}
.exam-info .exam-ins .span7 .btn {margin-top: 4px; padding-top: 0; height:5px}
.quick-ques > .btn {border:1px solid #ccc}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.scrollbar.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/RestrictActions.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/Legends.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/QuestionRender.js?${jsTime }'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/jquery.jplayer.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/oesplayer.js?${jsTime }'></c:url>"></script>
<script	src="<c:url value='/resources/js/darkModeTheme.js'></c:url>"></script>
<script>
darkModeCheck();
</script>
<style>
body {
  -webkit-user-select: none;  /* Chrome all / Safari all */
  -moz-user-select: none;     /* Firefox all */
  -ms-user-select: none;      /* IE 10+ */
 
  /* No support for these yet, use at own risk */
  -o-user-select: none;
  user-select: none;
}
</style>

</head>
<body class="exampage exampage-hgt">
	<div class="main container-fluid bg1" style=" background-image: none;">
<input type="hidden" id="dbanscnt" name="dbanscnt" value="${examViewModel.openObject}"/>
		<form:form action="ProcessQuestion" method="POST" id="frmQues" modelAttribute="candidateItemAssociation">
		<div class="inner-questions-area">	
			<input type="hidden" id="hidExt" name="hidExt" value="-1"/>
			<c:choose>
				<c:when test="${mode != null}">
					<input type="hidden" id="mode" name="mode" value="${mode }"/>
				</c:when>
				<c:otherwise>
					<input type="hidden" id="mode" name="mode" value="off"/>
				</c:otherwise>
			</c:choose>
			<c:set var="isQusAvailable" value="false"></c:set>
			<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}" />
			<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.successList[0].itemLanguage.item.itemID }" />
			<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
			<input type="hidden" id="itemBankID" name="itemBankID" value="${examViewModel.itemBankItemAssociation.fkItemBankID}" />
			<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}" />
			<form:hidden path="candidateExamItemID" />
			<form:hidden path="item.Itemtype" value="SCS" id="itype" />
			<form:hidden path="fkItemID" />
			<input type="hidden" id="sectionID" name="sectionID" value="0" />
			<input type="hidden" id="isLastItem" value="${candidateItemAssociation.isLastItem}">
			<div class="question">
	          <div class="pull-left">
	              <strong id="quesnoText"><spring:message code="Exam.QuestionNo" /> </strong>
	          </div>
	          <div class="pull-right">
	          	<a id="btn-decrease" class="btn btn-mini btn-info btn-default2" href="#">A<sup>-</sup></a>
			    <a id="btn-orig" class="btn btn-mini btn-info btn-default2" href="#">A</a>
			    <a id="btn-increase" class="btn btn-mini btn-info btn-default2" href="#">A<sup>+</sup></a>
	          </div>
	          <c:choose>
	          	<c:when test="${examViewModel != null && examViewModel.successList != null && fn:length(examViewModel.successList) > 1}">
	          		<div class="pull-right">	          	
	          	</c:when>
	          	<c:otherwise>
	          		<div class="pull-right" style="display: none">
	          	</c:otherwise>
	          </c:choose>
	              <spring:message code="Exam.ViewIn" />
	               <select id="viewLang"> 
	              <c:forEach items="${examViewModel.successList }" var="item" varStatus="i">
	              	<c:choose>
	              		<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">
	              			<option selected="selected" value="${item.itemLanguage.fkLanguageID}">${item.itemLanguage.language.languageName }</option>
	              		</c:when>
	              		<c:otherwise>
	              			<option value="${item.itemLanguage.fkLanguageID}">${item.itemLanguage.language.languageName }</option>
	              		</c:otherwise>
	              	</c:choose>                 
	              </c:forEach>
	              </select>
	          </div>
		</div>
			<div class="questiondiv scrollbar-outer scs">
				<c:forEach items="${examViewModel.successList }" var="item" varStatus="i">
				<c:choose>
	         		<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">
	         			<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
	         				<c:if test="${item.answeringMode == 'IMAGE'}">
								<input type="hidden" id="ansmode" value="${item.answeringMode }"/>
								<input type="hidden" id="mulmode" value="${item.multimediaType }"/>
									<div class="text-center">				
										<c:if test="${item.itemFilePath != null && item.itemFilePath != ''}">
											<c:if test="${item.multimediaType == 'IMAGE'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionImg" /></p>
													</c:otherwise>
												</c:choose>									
												<img class="que-img" src="../exam/displayImage?disImg=${item.itemFilePath}" alt="">
											</c:if>
											<c:if test="${item.multimediaType == 'AUDIO'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionAudio" /></p>
													</c:otherwise>
												</c:choose>																		
												<div id="MMplayer_1" class="mediaplayer" data-mediamode="success" data-mediatype="audio" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>							
											</c:if>
											<c:if test="${item.multimediaType=='VIDEO'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionVideo" /></p>
													</c:otherwise>
												</c:choose>												
												<div class="videoQue">
								                    <div id="MMplayer_1" data-mediamode="success" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>
								                </div>
											</c:if>																												
										</c:if>	
										<c:if test="${item.multimediaType=='NONE'}">
												<p class="question-wrap">${item.itemText }</p>
										</c:if>	
									</div>			
									<strong><spring:message code="Exam.Options" /> :</strong>
									<br/>
									<br/>			
									<c:forEach items="${item.optionList}" var="option" varStatus="j">
										<div class="controls scsOptDiv">
										<form:hidden path="candidateAnswers[${j.index }].candidateExamItemID" />
										<form:hidden path="candidateAnswers[${j.index }].fkcandidateID" />
										<form:hidden path="candidateAnswers[${j.index }].fkItemID" />
										<form:hidden path="candidateAnswers[${j.index }].candidateAnswerID" />
										<form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID" />
										<form:hidden path="candidateAnswers[${j.index }].fkExamEventID" />
										<div><div class="question-wrap">${option.optionText }</div></div>
										<label class="radio">
										<c:choose>
					                    	<c:when test="${candidateItemAssociation.candidateAnswers[j.index] != null && candidateItemAssociation.candidateAnswers[j.index].optionID >0 }">
					                    		<form:radiobutton path="candidateAnswers[0].optionID" checked="checked" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
					                    	</c:when>
					                    	<c:otherwise>
					                    		<form:radiobutton path="candidateAnswers[0].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
					                    	</c:otherwise>
				                    	</c:choose>
										<img src="../exam/displayImage?disImg=${option.optionFilePath}"/>								
										</label>
										</div>
									</c:forEach>								
							</c:if>
							
							<c:if test="${item.answeringMode == 'AUDIO'}">
								<input type="hidden" id="ansmode" value="${item.answeringMode }"/>
								<input type="hidden" id="mulmode" value="${item.multimediaType }"/>
								<div class="${ item.multimediaType != 'IMAGE' ? 'que-box' : '' }">
									<div class="text-center">										
										<c:if test="${item.itemFilePath != null && item.itemFilePath != ''}">
											<c:if test="${item.multimediaType == 'IMAGE'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionImg" /></p>
													</c:otherwise>
												</c:choose>												
												<img class="que-img" src="../exam/displayImage?disImg=${item.itemFilePath}" alt="">
											</c:if>
											<c:if test="${item.multimediaType == 'AUDIO'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionAudio" /></p>
													</c:otherwise>
												</c:choose>
												<div id="MMplayer_1" class="mediaplayer" data-mediamode="success" data-mediatype="audio" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>
											</c:if>
											<c:if test="${item.multimediaType=='VIDEO'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionVideo" /></p>
													</c:otherwise>
												</c:choose>												
												<div class="videoQue">
								                    <div id="MMplayer_1" data-mediamode="success" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>
								                </div>
											</c:if>										
										</c:if>
										<c:if test="${item.multimediaType=='NONE'}">
												<p class="question-wrap">${item.itemText }</p>
										</c:if>									
									</div>
									<strong><spring:message code="Exam.Options" /> :</strong>
									<br/>
									<br/>
								<c:forEach items="${item.optionList}" var="option" varStatus="j">
									<div class="controls scsOptDiv">
										<form:hidden path="candidateAnswers[${j.index }].candidateExamItemID" />
										<form:hidden path="candidateAnswers[${j.index }].fkcandidateID" />
										<form:hidden path="candidateAnswers[${j.index }].fkItemID" />
										<form:hidden path="candidateAnswers[${j.index }].candidateAnswerID" />
										<form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID" />
										<form:hidden path="candidateAnswers[${j.index }].fkExamEventID" />
										<label class="radio">
										<c:choose>
											<c:when test="${candidateItemAssociation.candidateAnswers[j.index] != null && candidateItemAssociation.candidateAnswers[j.index].optionID >0 }">
					                    		<form:radiobutton path="candidateAnswers[0].optionID" checked="checked" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
					                    	</c:when>
					                    	<c:otherwise>
					                    		<form:radiobutton path="candidateAnswers[0].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
					                    	</c:otherwise>
										</c:choose>
										<div id="MMplayer_${j.index + 2}" class="mediaplayer" data-mediamode="success" data-mediatype="audio" data-mediaurl="../exam/getmedia?f=${option.optionFilePath}&e=${option.fileTypeExtension}" data-mediaext="${option.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>	 																				
										</label>
									</div>
								</c:forEach>								
							</c:if>
						
							<c:if test="${item.answeringMode == 'NONE'}">
								<input type="hidden" id="ansmode" value="${item.answeringMode }"/>
								<input type="hidden" id="mulmode" value="${item.multimediaType }"/>								
									<div class="text-center">										
										<c:if test="${item.itemFilePath != null && item.itemFilePath != ''}">
											<c:if test="${item.multimediaType == 'IMAGE'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionImg" /></p>
													</c:otherwise>
												</c:choose>												
												<img class="que-img" src="../exam/displayImage?disImg=${item.itemFilePath}" alt="">
											</c:if>
											<c:if test="${item.multimediaType == 'AUDIO'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionAudio" /></p>
													</c:otherwise>
												</c:choose>												
												<div id="MMplayer_1" class="mediaplayer" data-mediamode="success" data-mediatype="audio" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>
											</c:if>
											<c:if test="${item.multimediaType=='VIDEO'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionVideo" /></p>
													</c:otherwise>
												</c:choose>												
												<div class="videoQue">
								                    <div id="MMplayer_1" data-mediamode="success" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>
								                </div>
											</c:if>										
										</c:if>
										<c:if test="${item.multimediaType=='NONE'}">
												<p class="question-wrap">${item.itemText }</p>
										</c:if>
									</div>
									<strong><spring:message code="Exam.Options" /> :</strong>
									<br/>
									<br/>
								<c:forEach items="${item.optionList}" var="option" varStatus="j">
								<div class="controls">
									<form:hidden path="candidateAnswers[${j.index }].candidateExamItemID" />
									<form:hidden path="candidateAnswers[${j.index }].fkcandidateID" />
									<form:hidden path="candidateAnswers[${j.index }].fkItemID" />
									<form:hidden path="candidateAnswers[${j.index }].candidateAnswerID" />
									<form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID" />
									<form:hidden path="candidateAnswers[${j.index }].fkExamEventID" />
									<label class="radio">
										<c:choose>
											<c:when test="${candidateItemAssociation.candidateAnswers[j.index] != null && candidateItemAssociation.candidateAnswers[j.index].optionID >0 }">
					                    		<form:radiobutton path="candidateAnswers[0].optionID" checked="checked" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
					                    	</c:when>
					                    	<c:otherwise>
					                    		<form:radiobutton path="candidateAnswers[0].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
					                    	</c:otherwise>
										</c:choose>
										<div class="question-wrap">${option.optionText }</div>
									</label>									
									</div>
								</c:forEach>
							</c:if>
							
							<c:if test="${item.answeringMode == 'SPEAK'}">
								<input type="hidden" id="ansmode" name="ansmode" value="${item.answeringMode }"/>								
								<input type="hidden" id="mulmode" value="${item.multimediaType }"/>								
							</c:if>
						
							<c:if test="${item.answeringMode == 'VIDEO'}">
								<input type="hidden" id="ansmode" value="${item.answeringMode }"/>
								<input type="hidden" id="mulmode" value="${item.multimediaType }"/>
									<div class="text-center">														
										<c:if test="${item.itemFilePath != null && item.itemFilePath != ''}">
											<c:if test="${item.multimediaType == 'IMAGE'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionImg" /></p>
													</c:otherwise>
												</c:choose>												
												<img class="que-img" src="../exam/displayImage?disImg=${item.itemFilePath}" alt="">
											</c:if>
											<c:if test="${item.multimediaType == 'AUDIO'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionAudio" /></p>
													</c:otherwise>
												</c:choose>																			
												<div id="MMplayer_1" class="mediaplayer" data-mediamode="success" data-mediatype="audio" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>									
											</c:if>
											<c:if test="${item.multimediaType=='VIDEO'}">
												<c:choose>
													<c:when test="${item.itemText != null && item.itemText != ''}">
														<p class="question-wrap caption">${item.itemText }</p>
													</c:when>
													<c:otherwise>
														<p class="question-wrap caption"><spring:message code="Exam.SCS.CaptionVideo" /></p>
													</c:otherwise>
												</c:choose>												
												<div class="videoQue">
								            		<div id="MMplayer_1" data-mediamode="success" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>
								                </div>
											</c:if>																												
										</c:if>	
										</div>
										<c:if test="${item.multimediaType=='NONE'}">
												<p class="question-wrap">${item.itemText }</p>
										</c:if>	
											
									<strong><spring:message code="Exam.Options" /> :</strong>
									<br/>
									<br/>			
								
									<c:forEach items="${item.optionList}" var="option" varStatus="j">
										<div class="controls scsOptDiv">
										<form:hidden path="candidateAnswers[${j.index }].candidateExamItemID" />
										<form:hidden path="candidateAnswers[${j.index }].fkcandidateID" />
										<form:hidden path="candidateAnswers[${j.index }].fkItemID" />
										<form:hidden path="candidateAnswers[${j.index }].candidateAnswerID" />
										<form:hidden path="candidateAnswers[${j.index }].fkCandidateExamID" />
										<form:hidden path="candidateAnswers[${j.index }].fkExamEventID" />
										<label class="radio">
											<c:choose>
												<c:when test="${candidateItemAssociation.candidateAnswers[j.index] != null && candidateItemAssociation.candidateAnswers[j.index].optionID >0 }">
						                    		<form:radiobutton path="candidateAnswers[0].optionID" checked="checked" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
						                    	</c:when>
						                    	<c:otherwise>
						                    		<form:radiobutton path="candidateAnswers[0].optionID" id="optionsAns${option.optionLanguage.option.optionSequenceNo }" class="${option.optionLanguage.option.optionSequenceNo }" value="${option.optionLanguage.option.optionID }"/>
						                    	</c:otherwise>
											</c:choose>
											<div class="videoQue">
							                   <div id="MMplayer_${j.index + 2}" data-mediamode="success" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${option.optionFilePath}&e=${option.fileTypeExtension}" data-mediaext="${option.fileTypeExtension}" data-medialoadonready="true" data-mediatitle=""></div>
							                </div>
										</label>										
										</div>
									</c:forEach>
								
							</c:if>
	         			</div>
	         		</c:when>
	         		<c:otherwise>
	         			<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
	         			</div>
	         		</c:otherwise>
         		</c:choose>
				</c:forEach>
			</div>
			<div class="action" style="position:fixed; width: 90%">  
		     	<c:if test="${sessionScope.exampapersetting.showReset}">
		     		<button class="btn btn-lblue pull-right" name="Reset" id="Reset" type="submit"><spring:message code="Exam.Reset" /></button>
		     	</c:if>
		     	<c:if test="${sessionScope.exampapersetting.showSkip}">
		     		<button class="btn btn-lblue pull-right" name="Skip" id="Skip" type="button" onclick="window.parent.skipThis()"><spring:message code="Exam.Skip" /></button>
		     	</c:if>
		     	<button class="btn btn-lblue pull-left" name="Save" id="Save" type="submit" ><spring:message code="Exam.SaveNext" /></button>
		     	<c:if test="${sessionScope.exampapersetting.showMarkForReview}">
		     		<div id="markr">
		     			<span class="btn markreview-btn ">
			          		<form:checkbox path="isMarkedForReview" id="cbReview"/>
			          		
			          		<label for="cbReview"><spring:message code="Exam.MarkforReview" /></label>
		       			</span>
		       		</div>
		     	</c:if>
		     </div>
		    
		</form:form>
	</div>
	</div>
</body>
</html>
