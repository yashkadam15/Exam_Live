<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>

<title><spring:message code="shortArtInclination.report"></spring:message></title>
<spring:message code="project.resources" var="resourcespath" />

<link rel="stylesheet" href="<c:url value='/resources/SVAIT/css/bootstrap.css'></c:url>">
<link rel="stylesheet" href="<c:url value='/resources/SVAIT/css/style.css'></c:url>">
<link rel="stylesheet" href="<c:url value='/resources/SVAIT/css/print.css'></c:url>">

<script src="<c:url value='../resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#printbtn').click(function(e){
		$(this).hide();
		window.print();
	});
});
</script>
<style type="text/css" media="print">
 @media print {

    html, body {
      height:100vh; 
      margin: 0 !important; 
      padding: 0 !important;
      overflow: hidden;
    }
@page {
    size: auto;   /* auto is the initial value */
    margin: 0;  /* this affects the margin in the printer settings */
}
} 

</style>

</head>
<body>
<c:choose>
<c:when test="${empty artInclinationDetails}">
	<div style="text-align: center;margin-top: 5%;">
		<spring:message code="shortArtInclination.noRecord" />
	</div>
</c:when>
<c:otherwise>
   <div id="certificate">
      <div class="page-wrapper">
        <div class="background-wrapper">
            <section id="top-area">
                <div class="container-fluid-a ">
                    <div class="row-a">
                        <div class="span-4 padding-0">
                            <table class="table table-bordered bg-white">
                                <tr>
                                    <td width="150" align="center"><p>${artInclinationDetails[0].candidateCode}</p></td>
                                    <td width="150" align="center"><p>${artInclinationDetails[0].examVenueCode}</p></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </section>
            <section id="tagline">
                <div class="container">
                    <div class="row-a">
                        <div class="span-12">
                            <div class="wrapper">
                                <!-- <img src="img/certificate-title.png" alt="" class="img-fluid"> -->
                                <!-- <img src="img/visual-arts.png" alt="" class="img-responsive">
                        <img src="img/inclination.png" alt="" class="img-responsive ml-3 inclination"> -->
                                <!-- <h1>Visual Arts</h1> -->
                                <!-- <h2>Inclination Report</h2> -->
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <section id="main-content">
                <div class="container">
                    <div class="row-a">
                        <div class="span-12">
                            <div class="card">
                                <div class="certificate-text-wrapper1">
                                    <div class="row-a">
                                        <div class="span-4">
                                            <h4 class="mb-2"><spring:message code="artInclinationTest.candidateName"/> </h4></div>
                                        <div class="span-8">
                                            <h4><span-> ${artInclinationDetails[0].candidateLastName} ${artInclinationDetails[0].candidateFirstName} ${artInclinationDetails[0].candidateMiddleName}</span-></h4></div>
                                    </div>
                                    <div class="row-a">
                                        <div class="span-4">
                                            <h4 class="mb-2"><spring:message code="artInclinationTest.candidateCode"/> </h4></div>
                                        <div class="span-8">
                                            <h4><span->${artInclinationDetails[0].candidateCode}</span-></h4></div>
                                    </div>
                                    <div class="row-a">
                                        <div class="span-4">
                                            <h4 class="mb-2"><spring:message code="artInclinationTest.attemptDate "/></h4></div>
                                        <div class="span-8">
                                            <h4> <fmt:formatDate value="${artInclinationDetails[0].attemptDate}" pattern="dd-MMM-yyyy"/></td></h4></div>
                                    </div>
                                    <hr class="style-hr">
                                </div>
                                <div class="certificate-text-wrapper2">
                                    
                                    <div class="row-a">
                                        <div class="span-12 text-center">
                                            <h4><strong><spring:message code="artInclinationTest.dear"/> ${artInclinationDetails[0].candidateFirstName}</strong></h4>
                                            <p><strong><spring:message code="artInclinationTest.attemptingVisualArtInclination"/></strong></p>
                                            <p><strong><spring:message code="artInclinationTest.reportGeneratedOnResponse"/></strong></p>
                                        </div>
                                    </div>
                                </div>
                                <div class="row-a">
                                    <div class="span-12">
                                        <div class="yellow-card">
                                            <div class="card-header">
                                                <h1><spring:message code="artInclinationTest.inclinationTowardsVisualArts"/> <fmt:formatNumber type = "number" maxFractionDigits = "2" value = "${artInclinationDetails[0].percentSum}" /> %</h1>
                                            </div>
                                            <div class="card-body">
                                                <p><spring:message code="artInclinationTest.responsesShow"/></p>
                                                <ol>
                                                     <c:forEach items="${artInclinationDetails}" var="obj" varStatus="loop">
												  		 <li>${obj.indicatorDescription}</li>
												  	</c:forEach>
                                                </ol>
                                                <br>
                                           
                                                

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row-a">
                                    <div class="span-9">
                                           <div class="text-wrapper">
                                                 <p><strong>
                                                 <c:if test="${artInclinationDetails!=null &&  fn:length(artInclinationDetails)>0 && artInclinationDetails[0].recMaster!=null}">
											  		${artInclinationDetails[0].recMaster.description}
											  	 </c:if>
											  	 </strong></p>
                                               
                                                <p><strong><spring:message code="artInclinationTest.joinMKCL'sKLiCCourses"/> </strong></p>
                                                <p class="mb-2"><strong><spring:message code="artInclinationTest.viewTheTrailers"/></strong> <br>
                                                 <a class="text-red" href="http://www.mkcl.org/klic"><spring:message code="artInclinationTest.wwwmkclorgklic"/></a> </p>
                                               
                                        <p class="text-small"><strong><em><spring:message code="artInclinationTest.administeredMKCL'sALC"/> ${artInclinationDetails[0].examVenueName}, <District><spring:message code="artInclinationTest.maharashtra"/></em></strong></p>
                                           </div>
                                    </div>
                                    <div class="span-3">
                                        <img src="../resources/SVAIT/img/klic-courses.png" alt="" class="img-responsive qr-code">
                                        <p class="text-small text-center"><strong><spring:message code="artInclinationTest.scanQRCode"/></strong></p>
                                    </div>
                                </div>
                                
                                <div class="strikethrough "></div>
                                <!-- <hr class="style1"> -->
                                <div class="row-a" id="logos">
                                    <div class="span-12">
                                        <div class="span-3 logo-info ">
                                            <div class="logo-info-text">
                                                <p><strong><spring:message code="artInclinationTest.learnComputerSmartWork"/></strong> </p>
                                            </div>
                                            <img src="../resources/SVAIT/img/mscit.png" alt="" class="img-responsive img-thumbnail course-img ">
                                            <p><a href="http://www.mkcl.org/mscit"  class="text-grey"><spring:message code="artInclinationTest.wwwmkclorgmscit"/></a></p>
                                        </div>
                                        <div class="span-3 logo-info">
                                            <div class="logo-info-text">
                                                <p><strong><spring:message code="artInclinationTest.learnSoftSkills"/></strong> </p>
                                            </div>
                                            <img src="../resources/SVAIT/img/klic-english.png" alt="" class="img-responsive img-thumbnail course-img ">
                                            <p><a href="http://www.mkcl.org/english" class="text-grey"><spring:message code="artInclinationTest.wwwmkcorgenglish"/></a></p>
                                        </div>
                                        <div class="span-3 logo-info">
                                            <div class="logo-info-text">
                                                <p><strong><spring:message code="artInclinationTest.klicDiploma"/></strong></p>
                                            </div>
                                            <img src="../resources/SVAIT/img/klic-diploma.png" alt="" class="img-responsive img-thumbnail course-img ">
                                            <p><a href="http://www.mkcl.org/klic" class="text-grey"><spring:message code="artInclinationTest.wwwmkclorgklic"/></a></p>
                                        </div>
                                      <!--   <div class="span-3 logo-info">
                                            <div class="logo-info-text">
                                                <p>दरमहा स्टायपेंडसह वर्क बेस्ड पदवी </p>
                                            </div>
                                            <img src="img/mfs.png" alt="" class="img-responsive img-thumbnail course-img ">
                                            <p><a href="http://www.mkcl.org/mastering" class="text-grey">www.mkcl.org/mastering</a></p>
                                        </div> -->
                                        <div class="span-3 logo-info">
                                            <div class="logo-info-text">
                                                <p><strong><spring:message code="artInclinationTest.compitativePreparation"/> </strong></p>
                                            </div>
                                            <img src="../resources/SVAIT/img/mastering.png" alt="" class="img-responsive img-thumbnail course-img ">
                                            <p><a href="http://www.mkcl.org/klic" class="text-grey"><spring:message code="artInclinationTest.wwwmkclorgklic"/></a></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
   </div>
   <div style="margin-right: 5%;margin-top: 1%;" align="center;">
				<center><button id="printbtn" class="btn btn-success">
				<spring:message code="shortArtInclination.print"></spring:message></button></center>
			</div>
			
	<br>
	</c:otherwise>
</c:choose>
</body>
</html>

