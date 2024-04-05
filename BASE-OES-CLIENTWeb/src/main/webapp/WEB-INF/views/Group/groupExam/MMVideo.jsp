<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="Exam.Title" /></title>

<spring:theme code="curdetailtheme" var="curdetailtheme"/>
<spring:theme code="playertheme" var="playertheme"/>

<%-- <link href="<c:url value='/resources/style/template.css'></c:url>" rel="stylesheet"> --%>
<link rel="stylesheet" href="<c:url value='${curdetailtheme}'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='/resources/style/jquery.scrollbar.css'></c:url>" type="text/css"/>
<link rel="stylesheet" href="<c:url value='${playertheme}'></c:url>" type="text/css"/>
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
  -webkit-user-select: none;  /* Chrome all / Safari all */
  -moz-user-select: none;     /* Firefox all */
  -ms-user-select: none;      /* IE 10+ */
 
  /* No support for these yet, use at own risk */
  -o-user-select: none;
  user-select: none;
}
</style>
</head>
<body class="osp-user-one" style="background-color: transparent">
	<div id="askPwdsModal" class="modal hide fade in examModal" style="display: none;width: 57%;">
		<div class="modal-header">
			<h3><spring:message code="Exam.entersupervisorpassword" /></h3>
		</div>
		<div class="modal-body">
			<p id="askPwdsmodalMsg"><spring:message code="Exam.Media.PasswordLabel" /></p>
			<iframe src="" id="hidOperations" style="display: none;height: 0px;width: 0px"> </iframe>
			<label id="waitforprocess" style="display: none;font-weight: bold;"><spring:message code="Exam.Pleasewaitwhileprocessing" /></label>	
			<input type="password" id="takepwd">
			
			<p id="askPwdModalErrMsg" style="display: none; color: red;"><spring:message code="Exam.incorrectsuppsw" /></p>

		</div>
		<div class="modal-footer">
		   	  <a class="btn btn-success" id="chkpwd"><spring:message code="Exam.Yes" /></a> 	  		
			  <a class="btn askPwdsModalClose" id="cancelpwd"><spring:message code="Exam.No" /></a>
		</div>
	</div>
	<input type="hidden" id="dbanscnt" name="dbanscnt" value="${examViewModel.openObject}"/>
<form:form action="ProcessQuestion" method="POST" id="frmQues" modelAttribute="candidateItemAssociation">
<div class="osp-question" >
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
	<input type="hidden" id="examineeCandidateID" name="examineeCandidateID" value="${examineeCandidateID}"/>
	<input type="hidden" id="attempterCandidateID" name="attempterCandidateID" value="${attempterCandidateID}"/>
	<input type="hidden" id="examineeSelOpIDs" name="examineeSelOpIDs" value="${examineeSelOpIDs}"/>
	<input type="hidden" id="examineeSelConfLevel" name="examineeSelConfLevel" value="${examineeSelConfLevel}"/>
	<input type="hidden" id="candidateExamID" name="candidateExamID" value="${candidateExamID}"/>
	<input type="hidden" id="examEventID" name="examEventID" value="${examEventID }" />
	<input type="hidden" id="paperID" name="paperID" value="${paperID }" />
	
	<input type="hidden" id="itemStatus" name="itemStatus" value="${examViewModel.candidateItemAssociation.itemStatus}"/>
	<input type="hidden" id="curitemID" name="curitemID" value="${examViewModel.multimedias[0].itemLanguage.item.itemID }" />
	<input type="hidden" id="selectedLang" name="selectedLang" value="${selectedLang}" />
	<input type="hidden" id="itemBankGroupID" name="itemBankGroupID" value="${examViewModel.paperItemBankAssociation.itemBankGroupID}"/>
	<input type="hidden" id="difficultyLevel" name="difficultyLevel" value="${examViewModel.itemBankItemAssociation.difficultyLevel}"/>
	<form:hidden path="candidateExamItemID" id="ceiid"/>
    <form:hidden path="fkCandidateExamID" value="${candidateExamID}" /> 
    <form:hidden path="fkCandidateID" /> 
    <form:hidden path="fkItemID" /> 
    <form:hidden path="fkParentItemID" /> 
	<form:hidden path="item.Itemtype" value="MM" id="itype"/>
	<input type="hidden" value="${examViewModel.candidateItemAssociation.mediaPlayedCount}" id="mpc"/>
	<input type="hidden" id="sectionID" name="sectionID" value="${activeSec}" />
	
     
      <div class="question">
          <div class="pull-left">
              <%-- <strong id="quesnoText"><spring:message code="Exam.QuestionNo" /> </strong> --%>
          </div>
          <c:choose>
          	<c:when test="${examViewModel != null && examViewModel.multimedias != null && fn:length(examViewModel.multimedias) > 1}">
          		<div class="pull-right lang-div">
          	
          	</c:when>
          	<c:otherwise>
          		<div class="pull-right lang-div" style="display: none">
          	</c:otherwise>
          </c:choose>
              <spring:message code="Exam.ViewIn" />
               <select id="viewLang"> 
              <c:forEach items="${examViewModel.multimedias }" var="item" varStatus="i">
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
             <!--  <span class="fs"><a class="btn fs-minus" href="#">A<sup>-</sup></a><a class="btn fs-reset" href="#">A</a><a class="btn fs-plus" href="#">A<sup>+</sup></a></span>
              Time : <strong>0.5</strong> -->
          </div>
      </div>       		
       						 
      <div class="questiondiv scrollbar-outer">
       	<div class="palette1">                           	
            <div class="quick-ques1" style="padding: 4px">
	           	<c:forEach items="${examViewModel.candidateItemAssociation.candidateSubItemAssociations}" var="cia" varStatus="indx">
	           		<c:if test="${cia.itemStatus == 'NoStatus'}">
	           			<a title="<spring:message code="Exam.NotVisited" />" data-status="nostatus" class="btn btn-mini" id="silnk${cia.fkItemID}" data-item="${cia.fkItemID}">${indx.index+1}</a>
	           		</c:if>
	           		<c:if test="${cia.itemStatus == 'NotAnswered'}">
	           			<a title="<spring:message code="Exam.NotAnswered" />"  data-status="noans" class="btn btn-mini btn-red" id="silnk${cia.fkItemID}" data-item="${cia.fkItemID}">${indx.index+1}</a>
	           		</c:if>
	           		<c:if test="${cia.itemStatus == 'MarkedForReview'}">
	           			<a title="<spring:message code="Exam.Marked" />" data-status="marked" class="btn btn-mini btn-purple" id="silnk${cia.fkItemID}" data-item="${cia.fkItemID}">${indx.index+1}</a>
	           		</c:if>
	           		<c:if test="${cia.itemStatus == 'Answered'}">
	           			<a title="<spring:message code="Exam.Answered" />"  data-status="ans" class="btn btn-mini btn-greener" id="silnk${cia.fkItemID}" data-item="${cia.fkItemID}">${indx.index+1}</a>
	           		</c:if>
	           	</c:forEach>
           </div>
		</div>
         <c:forEach items="${examViewModel.multimedias }" var="item" varStatus="i">      
         	<c:choose>
         		<c:when test="${selectedLang == item.itemLanguage.fkLanguageID}">
         			<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
         			
         			    <div class="cq-holder clearfix">
         			        <div class="left-holder">
                          		<div class="comprehension scrollbar-outer min-h">
                          		<div class="qVideo-holder">
                          		<div class="wrap">
	                          		 <c:if test="${item.itemText != null && item.itemText != ''  && fn:length(item.itemText) > 0}">
		              	 				<p class="question-wrap">${item.itemText }</p>
		              	 			 </c:if>
                          		    <c:if test="${item.itemFilePath != null && item.itemFilePath != ''  && fn:length(item.itemFilePath) > 0}">
		              	 				<div id="MMplayer_${i.index+1}" data-mediamode="exam" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="false" data-mediatitle=""></div>
		              	 			 </c:if>
		              	 			 </div>
		              	 			 </div>
                          		</div>
                        	</div>
         			        <div class="right-holder">
         			           	<div class="cmpsqdiv comprehension-Questions scrollbar-outer min-h">
         			            <c:forEach items="${item.subItemList}" var="subItem" varStatus="j">  
         			                <form:hidden path="candidateSubItemAssociations[${j.index}].candidateExamItemID"/>
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateExamID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkItemID" /> 
								    <form:hidden path="candidateSubItemAssociations[${j.index}].fkParentItemID" /> 
									<form:hidden path="candidateSubItemAssociations[${j.index}].item.Itemtype" value="CMPS" class="itemtype"/>									
         			                <div class="control-holder" id="sidiv${item.itemLanguage.fkLanguageID}${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].fkItemID }">
         			                   <strong><spring:message code="Exam.Question" /> ${j.index+1} : </strong>
         			                    <p class="question-wrap">${subItem.subItemText}</p>
         			                    <c:if test="${subItem.subItemImage != null && subItem.subItemImage != ''  && fn:length(subItem.subItemImage) > 0}">
		              	 				  <img src="../exam/displayImage?disImg=${subItem.subItemImage}"/>
		              	 			    </c:if>
		              	 			    <br>
                                        <%-- <strong><spring:message code="Exam.Options" /> : </strong>
                                        <br> --%>
                                        <c:forEach  items="${subItem.optionList}" var="subItemOption" varStatus="k">
                                          <div class="controls">
                                             <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].candidateExamItemID"/>
		                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkcandidateID"/>
		                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkItemID"/>
		                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].candidateAnswerID"/>
		                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkParentItemID"/>
		                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkCandidateExamID"/>
		                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkExamEventID"/>
		                    				  
		                    				  <label class="checkbox radio">
		                    				  
		                    				          <c:choose>
				                    				       <c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].object > 1 }">
				                    				          <form:checkbox  path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].optionID" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo}${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }" />
				                    				       </c:when>
				                    				       <c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].object == 1 }">
				                    				           <c:choose>
				                    								<c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateAnswers[k.index] != null && examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateAnswers[k.index].optionID > 0 }">
			                    									    <form:radiobutton path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID"  checked="checked" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }"/>
										                    	    </c:when>
										                    	    <c:otherwise>
										                    		    <form:radiobutton path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }"/>
										                    	    </c:otherwise>
					                   						</c:choose>	
				                    				       </c:when>
		                    				         </c:choose> 
		                    				     
							                   		<c:if test="${subItemOption.subOptionText != null && subItemOption.subOptionText != ''  && fn:length(subItemOption.subOptionText) > 0}">
							                   		<div class="question-wrap">${subItemOption.subOptionText }</div>		                   		
							                   		</c:if>	
							                   		 <c:if test="${subItemOption.subOptionImage != null && subItemOption.subOptionImage != ''  && fn:length(subItemOption.subOptionImage) > 0}">
							                   		  	<c:if test="${subItemOption.subOptionText != null && subItemOption.subOptionText != ''  && fn:length(subItemOption.subOptionText) > 0}">
							                   		  	  <br>
							                   		  	</c:if>
							              	 			<img src="../exam/displayImage?disImg=${subItemOption.subOptionImage}"/>
							              	 		</c:if>	     
							              	 		              		
							                  </label>
                                          </div>
                                        </c:forEach>
         			                </div>
         			                <br>
         			            </c:forEach>
         			           </div>
         			        </div>
		              	  </div> 
              		</div> 
         		</c:when>
         		<c:otherwise>
         			<div id="${item.itemLanguage.fkLanguageID}" class="qdiv">
         			
	         			 <div class="cq-holder clearfix">
	         			        <div class="left-holder">
	                          		<div class="comprehension scrollbar-outer">
	                          		<div class="qVideo-holder">
	                          			 <c:if test="${item.itemText != null && item.itemText != ''  && fn:length(item.itemText) > 0}">
			              	 				<p class="question-wrap">${item.itemText }</p>
			              	 			 </c:if>
	                          		    <c:if test="${item.itemFilePath != null && item.itemFilePath != ''  && fn:length(item.itemFilePath) > 0}">
			              	 				<div id="MMplayer_${i.index+1}" data-mediamode="exam" data-mediatype="video" data-mediaurl="../exam/getmedia?f=${item.itemFilePath}&e=${item.fileTypeExtension}" data-mediaext="${item.fileTypeExtension}" data-medialoadonready="false" data-mediatitle=""></div>
			              	 			 </c:if></div>
	                          		</div>
	                        	</div>
	         			        <div class="right-holder"> 
	         			           	<div class="cmpsqdiv comprehension-Questions scrollbar-outer" >
	         			           	
		         			            <c:forEach items="${item.subItemList}" var="subItem" varStatus="j">  	
	         			                <form:hidden path="candidateSubItemAssociations[${j.index}].candidateExamItemID"/>
									    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateExamID" /> 
									    <form:hidden path="candidateSubItemAssociations[${j.index}].fkCandidateID" /> 
									    <form:hidden path="candidateSubItemAssociations[${j.index}].fkItemID" /> 
									    <form:hidden path="candidateSubItemAssociations[${j.index}].fkParentItemID" /> 
										<form:hidden path="candidateSubItemAssociations[${j.index}].item.Itemtype" value="CMPS" class="itemtype"/>	
	         			                
	         			                <div class="control-holder" id="sidiv${item.itemLanguage.fkLanguageID}${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].fkItemID }">
	         			                   <strong><spring:message code="Exam.Question" /> ${j.index+1} : </strong>
	         			                    <p class="question-wrap">${subItem.subItemText}</p>
	         			                    <c:if test="${subItem.subItemImage != null && subItem.subItemImage != ''  && fn:length(subItem.subItemImage) > 0}">
			              	 				  <img src="../exam/displayImage?disImg=${subItem.subItemImage}"/>
			              	 			    </c:if>
			              	 			    <br>
	                                      <%--   <strong><spring:message code="Exam.Options" /> : </strong>
	                                        <br> --%>
	                                        <c:forEach  items="${subItem.optionList}" var="subItemOption" varStatus="k">
	                                          <div class="controls">
	                                             <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].candidateExamItemID"/>
			                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkcandidateID"/>
			                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkItemID"/>
			                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].candidateAnswerID"/>
			                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkParentItemID"/>
			                    				 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkCandidateExamID"/>
			                   					 <form:hidden path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].fkExamEventID"/>
			                    				 
			                    				 
			                    				  <label  class="checkbox radio">
			                    				        
			                    				       <c:choose>
				                    				       <c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].object > 1 }">
				                    				          <form:checkbox  path="candidateSubItemAssociations[${j.index}].candidateAnswers[${k.index}].optionID" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo}${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }" />
				                    				       </c:when>
				                    				       <c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].object == 1 }">
				                    				           <c:choose>
				                    								<c:when test="${examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateAnswers[k.index] != null && examViewModel.candidateItemAssociation.candidateSubItemAssociations[j.index].candidateAnswers[k.index].optionID > 0 }">
			                    									    <form:radiobutton path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID"  checked="checked" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }"/>
										                    	    </c:when>
										                    	    <c:otherwise>
										                    		    <form:radiobutton path="candidateSubItemAssociations[${j.index}].candidateAnswers[0].optionID" id="optionsAns${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" class="${subItemOption.optionLanguage.option.optionSequenceNo }${subItemOption.optionLanguage.option.optionID }" value="${subItemOption.optionLanguage.option.optionID }"/>
										                    	    </c:otherwise>
					                   						</c:choose>	
				                    				       </c:when>
		                    				          </c:choose> 
			                    				      
			                    				     
								                   		<c:if test="${subItemOption.subOptionText != null && subItemOption.subOptionText != ''  && fn:length(subItemOption.subOptionText) > 0}">
								                   		<div class="question-wrap">${subItemOption.subOptionText }</div>		                   		
								                   		</c:if>	
								                   		 <c:if test="${subItemOption.subOptionImage != null && subItemOption.subOptionImage != ''  && fn:length(subItemOption.subOptionImage) > 0}">
								                   		  	<c:if test="${subItemOption.subOptionText != null && subItemOption.subOptionText != ''  && fn:length(subItemOption.subOptionText) > 0}">
								                   		  	  <br>
								                   		  	</c:if>
								              	 			<img src="../exam/displayImage?disImg=${subItemOption.subOptionImage}"/>
								              	 		</c:if>	     
								              	 		              		
								                  </label>
	                                          </div>
	                                        </c:forEach>
	         			                </div>
	         			                <br>
	         			            </c:forEach>
	         			            
	         			           </div>
	         			        </div>
			              	  </div> 
			              	  
              		</div>
         		</c:otherwise>         		
         	</c:choose>
         </c:forEach>
     </div>
</div>
</div>
     <!-- Confidence Level -->
<div class="osp-confidence">
<!-- check confidenece level required or not -->
<c:choose>
<c:when test="${sessionScope.exampapersetting.isConfidenceLevelCheck==true}">
	<input type="hidden" value="1" id="isConfidenceLevelsetting"/>
    <div class="levels cols">
    <c:forEach var="cflevel" items="${confidenceLevels}">
    <c:if test="${cflevel != 'None' && cflevel != 'FiveStars'}">
      <label class="conf ${cflevel} col1-3 radio">
           <form:radiobutton path="confidenceLevel"  value="${cflevel}"  />		                    
            <div class="conf-image"><img src="<c:url value="../resources/images/${cflevel}.png"></c:url>" alt="${cflevel} Confidence"></div>
            <p><c:choose>
            	<c:when test="${cflevel == 'Full' }">
                    <spring:message code="Exam.fullconf" />
           		 </c:when>
            	 <c:when test="${cflevel == 'Partial' }">
                    <spring:message code="Exam.partialconf" />
                 </c:when>
                 <c:when test="${cflevel == 'Low' }">
                    <spring:message code="Exam.lowconf" />
                 </c:when>
                 <c:otherwise>
            		${cflevel}
            	</c:otherwise>
            </c:choose></p>
        </label>
     </c:if>   
    </c:forEach>    
    </div>
</c:when> 
<c:otherwise>
	<input type="hidden" value="0" id="isConfidenceLevelsetting"/>
    <c:forEach var="cflevel" items="${confidenceLevels}">
     <c:if test="${cflevel == 'None' }">
     	   <label style="display: none"><form:radiobutton path="confidenceLevel" value="${cflevel}" checked="checked" /></label>
           <input type="hidden" value="${cflevel}" id="noneConfidenceLevel">
     </c:if>
    </c:forEach>
</c:otherwise>
</c:choose>
</div>

<!-- Submit -->
<div class="pg-controls" >
     <span class="align"></span> <button class="btn btn-success" name="Save" id="Save" type="submit"><spring:message code="Exam.submitAnswerbtn" /></button>
</div>
     </form:form>   
   </div>
</body>
</html>                       