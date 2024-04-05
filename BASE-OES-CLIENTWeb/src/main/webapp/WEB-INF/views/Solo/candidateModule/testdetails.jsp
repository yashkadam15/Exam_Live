<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page errorPage="../common/jsperror.jsp"%>

<style type="text/css">

.panel-primary {
border-color: #428BCA;
}
.table {
margin-bottom: 12px;
}
.panel {
padding-bottom:0.6px;
padding-top:5px;
padding-left:10px;
padding-right:10px;
margin-bottom: 20px;
background-color: white;
border: 1px solid #DDD;
border-radius: 10px;
border-color: #428BCA;
-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
}
.panel-title {
margin-top: 0;
margin-bottom: 0;
font-size: 17.5px;
font-weight: 500;
}
.panel-primary .panel-heading {
color: white;
background-color: #428BCA;
border-color: #428BCA;
}
.panel-heading {
padding: 10px 15px;
margin: -15px -11px 15px;
background-color: whiteSmoke;
border-bottom: 1px solid #DDD;
border-top-right-radius: 12px;
border-top-left-radius: 12px;
}
</style>
<fieldset class="well">
	<div class="holder">

	<br/> 		
	<div class="panel panel-primary">
        <div class="panel-heading">
          <h4 class="panel-title" style="text-align: center">
					${examDisplayCategoryPaperViewModelObj.paper.name} 
					<c:if test="${examDisplayCategoryPaperViewModelObj.assessmentType!='Group'}">
						(Attempt #${examDisplayCategoryPaperViewModelObj.candidateExam.attemptNo})
					</c:if>
					</h4>
          </div>       		
		     <table class="table table-bordered table-complex ">
			<tr>
						<td class="highlight" width="10%" style="color: #297DBC"><b><font
								size="2"><spring:message code="testdetails.subject" /></font> </b></td>
						<td width="60%"><font size="2">
								${examDisplayCategoryPaperViewModelObj.displayCategoryLanguage.displayCategoryName}
								</font></td>
						<td class="highlight" width="15%" style="color: #297DBC"><b><font
								size="2"><spring:message code="testdetails.TestDate" /></font>
						</b></td>
						<td width="15%"><font size="2"><fmt:formatDate
									type="date" pattern="dd-MM-yyyy"
									value="${examDisplayCategoryPaperViewModelObj.candidateExam.attemptDate}" />
						</font></td>
						
					</tr>
					<tr>
						<td class="highlight" width="10%" style="color: #297DBC"><b><font size="2"><spring:message
										code="testdetails.Syllabus" /> </font> </b></td>
						<td width="60%"><font size="2">							
									<c:forEach var="ItemBanks"
										items="${examDisplayCategoryPaperViewModelObj.listItemBanks}"
										varStatus="status">
							${ItemBanks.name} 
							<c:if
											test="${(fn:length(examDisplayCategoryPaperViewModelObj.listItemBanks)) != status.count}">
        						,  <!-- Display , or not display decision -->
										</c:if>
									</c:forEach>
										<br/>
										
									
									 <%-- <a class="btn btn-success btn-sm" style="font-size: 10px;line-height: 1em;font-family: "Lucida Sans Unicode","Lucida Grande",sans-serif;" href="../exploriments/explorimentsTree"><spring:message code="testdetails.ViewExploriments" /></a> --%>
									 				
						</font></td>
						
						<td class="highlight" width="15%" style="color: #297DBC"><b><font
								size="2"><spring:message code="testdetails.TestDuration" /></font>
						</b></td>
						<td width="15%"><font size="2">${examDisplayCategoryPaperViewModelObj.paper.duration}
								<spring:message code="testdetails.mins" /></font></td>
					</tr>
				</table>	
			 </div>	
		</div>
		
</fieldset>