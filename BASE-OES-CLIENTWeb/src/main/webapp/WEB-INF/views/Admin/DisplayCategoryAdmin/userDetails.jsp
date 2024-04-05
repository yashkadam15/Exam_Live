<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page errorPage="../common/jsperror.jsp"%>
	<!-- <div class="holder"> -->
	<!-- <fieldset class="well">
		 -->
			<div class="alert alert-info">


				<div class="row-fluid">
					<div class="span3">
						<label id="papertime-lbl" for="" class=" required"><b><spring:message code = "DisplayCategory.uName"/>
						</b> </label>
					</div>
					<p><font size="2">${user.firstName}   ${user.lastName}</font> </p>
				</div>

				
				<%-- <div class="row-fluid">
					<div class="span3">
						<label id="papertime-lbl" for="" class=" required"><b><spring:message code = "DisplayCategory.lastName"/>
						</b> </label>
					</div>
					<p><font size="2">${user.lastName}</font> </p>
				</div>
				 --%>

				<div class="row-fluid">
					<div class="span3">
						<label id="papertime-lbl" for="" class=" required"><b><spring:message code = "DisplayCategory.userName"/>
						 </b> </label>
					</div>
					<p><font size="2">${user.userName}</font></p>
				</div>
				
			</div>
		
	<!-- </fieldset> -->
	<!-- </div> -->

