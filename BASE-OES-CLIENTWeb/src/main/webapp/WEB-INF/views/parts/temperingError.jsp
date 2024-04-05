<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%-- <%@ page errorPage="../common/jsperror.jsp"%> --%>
<html>
<head>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"> -->
<title>Error</title>
<link href="<c:url value='/resources/style/bootstrap.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/responsive.css'></c:url>" rel="stylesheet">
<link href="<c:url value='/resources/style/style.css'></c:url>" rel="stylesheet">
<!--[if IE 7]>
<style>
.loginpage form input {border:1px solid #ccc}
.loginpage .btn-blue {border:none}
</style>
<![endif]-->
<script src="<c:url value='/resources/js/jquery-1.12.0.min.js'></c:url>"></script>
<script src="<c:url value='/resources/js/bootstrap.min.js'></c:url>"></script>

<script>
$(window).load(function() {
  $('#loading').hide();
  
  });
</script>

</head>

<body class="loginpage">
<div class="main container">

    <fieldset class="well">
        <legend><img src="<c:url value="../resources/images/logo-grey.png"></c:url>" alt="OES"></legend>
          <div class="progress progress-striped active" id="loading">
    <div class="bar" style="width: 40%;"></div>
    </div>
    </div>
       
    </fieldset>
</div>

</body>
</html>