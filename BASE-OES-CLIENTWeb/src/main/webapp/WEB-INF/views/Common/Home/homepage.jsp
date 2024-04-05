<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page errorPage="../Common/jsperror.jsp"%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="Common.Home.Title"></spring:message></title>
<%--
<link rel="stylesheet" href="<c:url value='/resources/style/template_home.css?v=04042023A'></c:url>" type="text/css" />
	
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/equalize.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/selectFix.js'></c:url>"></script>
<script>
	$(document).ready(function() {	
		if(navigator.userAgent.search('MOSB') >= 0){
	    	$('select').each(function(){
	    		$(this).fixCEFSelect();
	    	});
		}
	});
</script>
--%>
</head>
<body>


<!-- <div class="main">
    <div id="home"> -->
        <!-- <h1>OES Exam Center</h1> -->
        <div class="logo-holder" id="logoDiv">
        <span>
        <c:choose>
			<c:when test="${clientid==0}">
										
			</c:when>
			<c:otherwise>
				<img id="logo" src="<c:url value="/resources/images/${clientid}_mkcloeslogo.png"></c:url>" alt="OES School Project">
			</c:otherwise>
		</c:choose>
		</span>
		</div>
        <!-- <a class="btn-huge" href="#">Start OES</a> -->
        <form:form method="post">			
			<button type="button" class="btn-huge" id="openOES"><spring:message code="homepage.clickHereToStart"></spring:message> </button>
		</form:form>
        <div class="footer">
            <c:if test="${webVersion !=null}">
				<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
			</c:if><br>
            
            <c:if test="${isCopyRightEnabled}">
            	 <spring:message code="homepage.2015OES"></spring:message> &nbsp;&nbsp;
            	<spring:message code="homepage.Poweredby"> </spring:message> <%-- <c:choose>
							<c:when test="${clientid==0}">
									
							</c:when>
							<c:otherwise>
									<img style="width: 24px;height: 25px;" src="<c:url value="/resources/images/${clientid}_companylogo.png"></c:url>" alt="MKCL">
							</c:otherwise>
						</c:choose>  --%><spring:message code="global.companyName"></spring:message>.
			</c:if>
						<br><c:set var="IPvar" value="${fn:substringAfter(pageContext.request.localAddr,'.' )}" />

					<label style="font-size:12px; ">${fn:substringAfter(IPvar,'.')}</label> 
        </div>
   <!--  </div>
</div> -->
		
<script type="text/javascript">
var oesWin;
$('#openOES').click(function() 
{	
	if(!oesWin || oesWin.closed)
	{	
		oesWin=null;
		if(navigator.userAgent.toLowerCase().indexOf('chrome') > -1){
			oesWin = window.open("login/eventSelection", "ExamPage", "fullscreen=yes,scrollbars=yes,location=no,height="+screen.height+", width="+screen.width);
			oesWin.moveTo(0,0);
			// oesWin.resizeTo(screen.availWidth, screen.availHeight);
		}
		else
		{
			oesWin = window.open("login/eventSelection", "ExamPage", "fullscreen=yes,scrollbars=yes,location=no");
		}
		oesWin.focus();
		oesWin.opener=null;
	}
	else if(!oesWin.closed)
	{		
		oesWin.focus();
		oesWin.opener=null;
		alert('<spring:message code="Common.Home.AlreadyOpen"/>');
	}
});

</script>
  </body>
</html>