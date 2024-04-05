<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page errorPage="../common/jsperror.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Unit 1 Assessment</title>
<link rel="stylesheet" href="<c:url value='/resources/style/template_darkmode.css'></c:url>" type="text/css" />
</head>
<body>
	<spring:message code="project.resources" var="resourcespath" />

	<script type="text/javascript" src="<c:url value='/resources/js/jquery.timer.js'></c:url>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/demo.js'></c:url>"></script>

	<div>
		<div style="float: left;">
			<table cellpadding="9" cellspacing="3"
				style="background-color: #CCFFFF;">
				<tr>
					<td>
						<%-- <img src="<c:url value="${resourcespath}images/student.jpg"></c:url>" alt="Student"  
		style="border: medium; color: black;" >--%>
					</td>
					<td>
						<table cellpadding="1" cellspacing="3">
							<tr>
								<td><b><spring:message code="takeTest.name"/></b></td>
								<td>&nbsp; <spring:message code="takeTest.reenaKumari"/></td>
							<tr>
								<td><b><spring:message code="takeTest.loginId"/></b></td>
								<td>&nbsp; <spring:message code="takeTest.OS2013A123"/></td>
						</table>
					</td>

				</tr>
			</table>

		</div>

		<div style="float: right;">
			<table>
				<tr>
					<td rowspan="3" style="background-color: #D8D8D8;">&nbsp;
						&nbsp; <img
						src="<c:url value="${resourcespath}images/timer3.gif"></c:url>"
						alt="timer">
					</td>
					<td rowspan="3"
						style="background-color: #D8D8D8; font-weight: 900;">
						<!-- <label style="font-weight: 900;">TIMER - 10:</label> -->
						&nbsp; &nbsp; <span id="countdown"></span>&nbsp; &nbsp;
					</td>
					<!-- <td rowspan="3" style="background-color:  #D8D8D8; font-weight: 900;">
		<label id="timer" style="font-weight: 900;">00</label>
		</td> -->

					<td rowspan="3" style="background-color: white;">&nbsp; &nbsp;
						&nbsp; &nbsp; &nbsp;</td>

					<td><b><spring:message code="takeTest.queRemaining"/></b></td>
					<td><b>4</b></td>
				</tr>
				<tr>
					<td><b><spring:message code="takeTest.queAttempted"/></b></td>
					<td><b>2</b></td>

				</tr>
				<tr>
					<td><b><spring:message code="takeTest.currentQuestion"/></b></td>
					<td><label style="font-weight: bold;" id="remQues"><spring:message code="takeTest.1outof5"/></label></td>
				</tr>
			</table>
		</div>


	</div>
	<br>
	<br>
	<br>
	<br>
	<table style="background-color: #CCFFFF;" width="100%">
		<tr>
			<td width="51%"><b><spring:message code="takeTest.clickQuestiontoSolve"/></b>
			<td width="2%"><img
				src="<c:url value="${resourcespath}images/red.png"></c:url>"
				alt="timer">
			<td width="15%"><spring:message code="takeTest.attemptedQuestion"/>
			<td width="2%"><img
				src="<c:url value="${resourcespath}images/green.png"></c:url>"
				alt="timer">
			<td width="13%"><spring:message code="takeTest.currentQuestion"/>
			<td width="2%"><img
				src="<c:url value="${resourcespath}images/gray.png"></c:url>"
				alt="timer">
			<td width="15%"><spring:message code="takeTest.unAttemptedQuestion"/>
		</tr>
	</table>
	<br>
	<table>
		<tr>
			<td style="background-color: #FFCCCC;" align="center" width="50px">
				<b><spring:message code="takeTest.unit1"/></b>
			</td>
			<td style="background-color: #FFFFFF;">&nbsp;</td>
			<td style="background-color: #FFFFFF;">&nbsp;</td>
			<td style="background-color: #FFFFFF;">&nbsp;</td>
			<td>
				<table border="2" cellpadding="3">
					<tr>

						<td style="background-color: #C0C0C0;" align="center" id="q1"><spring:message code="takeTest.q1"/></td>

						<td style="background-color: #C0C0C0;" align="center" id="q2"><spring:message code="takeTest.q2"/></td>

						<td style="background-color: #C0C0C0;" align="center" id="q3"><spring:message code="takeTest.q3"/></td>
						<td style="background-color: #C0C0C0;" align="center" id="q4"><spring:message code="takeTest.q4"/></td>
						<!-- <td style="background-color: #FFFFFF;">&nbsp;</td> -->
						<td style="background-color: #C0C0C0;" align="center" id="q5"><spring:message code="takeTest.q5"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br>

	<table style="background-color: #CCFFFF;" width="100%" id="qa">
		<tr>
			<td><b><spring:message code="takeTest.instruction"/></b> <spring:message code="takeTest.selectCorrectAnswer"/></td>
		</tr>
	</table>
	<br>

	<c:forEach var="i" begin="1" end="5">
		<div class="alert alert-success" id="message${i}"
			style="font-weight: bolder; size: 20px;"></div>
		<table border="2" width="100%" cellpadding="4" id="ans${i}">
			<tr style="border: none;">
			<tr>
				<td colspan="2" style="border: none;" align="center">&nbsp;<input
					type="text" value="${i}" id="${i}" style="display: none;" /></td>
			</tr>
			<tr>


				<td id="num${i}" style="border: none; font-weight: bold;"
					align="right"><spring:message code="takeTest.question"/> &nbsp;</td>
				<td id="ques${i}" style="border: none; font-weight: bold;"
					align="left"></td>
			</tr>

			<tr>
				<td id="num1${i}" style="border: none;" align="right"><input
					type="radio" name="ans1" value="c"></td>
				<td style="border: none;"><label id="op1${i}"></label></td>
			</tr>
			<tr>
				<td id="num2${i}" style="border: none;" align="right"><input
					type="radio" name="ans1" value="w1"></td>
				<td style="border: none;"><label id="op2${i}"></label></td>
			</tr>
			<tr>
				<td id="num3${i}" style="border: none;" align="right"><input
					type="radio" name="ans1" value="w2"></td>
				<td style="border: none;"><label id="op3${i}"></label></td>
			</tr>
			<tr>
				<td id="num4${i}" style="border: none;" align="right"><input
					type="radio" name="ans1" value="w3"></td>
				<td style="border: none;"><label id="op4${i}"></label></td>
			</tr>
			<tr>
				<td colspan="2" style="border: none;" align="center">&nbsp;</td>
			</tr>
		</table>

		<table width="100%" id="button">
			<tr>
				<td style="text-align: left; border: none;" colspan="2">

					<button type="submit" class="btn btn-success" name="submit"
						value="" id="ansSubmit${i}"><spring:message code="takeTest.submitAnswer"/></button>

				</td>

				<td style="text-align: right; border: none;" colspan="2">
					<%-- <button type="submit" class="btn btn-danger" name="submit"
								value="" id="ansCancel${i}"  onclick="window.close();">End Test</button> --%>
					<a href="../candidateModule/homepage" class="btn btn-danger"
					id="ansCancel${i}"><spring:message code="takeTest.endTest"/></a>

				</td>

			</tr>


		</table>
	</c:forEach>

	<script>
	<!--
		
	//-->
	</script>


	<script>
		$(document)
				.ready(
						function() {

							$("#q1").css("background-color", "#00FF00");
							$("#num1").append("1");
							$("#ques1")
									.text(
											"Which of the following shares characteristics with both hardware and software?");
							$("#op11").text("Operating System");
							$("#op21").text("Software");
							$("#op31").text("Data");
							$("#op41").text("none");
							$("#ans2").hide();
							$("#ans3").hide();
							$("#ans4").hide();
							$("#ans5").hide();
							$("#message1").hide();
							$("#message2").hide();
							$("#message3").hide();
							$("#message4").hide();
							$("#message5").hide();
							$("#message").hide();
							$("#ansSubmit2").hide();
							$("#ansSubmit3").hide();
							$("#ansSubmit4").hide();
							$("#ansSubmit5").hide();
							$("#ansCancel2").hide();
							$("#ansCancel3").hide();
							$("#ansCancel4").hide();
							$("#ansCancel5").hide();

							/* timer();
							function timer()  
							{  
								 $("#clock").val(timeout);
							/* 	 alert(timeout); */
							/* if(timeout > 0)
								{
							timeout=timeout - 1;
							setTimeout(timer(), 1000); 
								}
							}   */

						});

		$("#ansSubmit1")
				.click(
						function() {

							$("#message1").hide();
							$("#message2").hide();
							$("#message3").hide();
							$("#message4").hide();
							$("#message5").hide();
							$("#ans1").hide();
							$("#ansSubmit1").hide();
							$("#ansCancel1").hide();
							$("#ans2").show();
							$("#ansSubmit2").show();
							$("#ansCancel2").show();
							$("#q2").css("background-color", "#00FF00");
							$("#q1").css("background-color", "#FF0000");
							$("#num2").append("2");
							$("#ques2")
									.text(
											"Text editor that Is the part of Windows operating system");
							$("#op12").text("Wordpad");
							$("#op22").text("Notepad");
							$("#op32").text("Adobe Photoshop");
							$("#op42").text("Jasc Paint Shop");
							$("#remQues").text("2 out of 5");

						});

		$("#ansSubmit2")
				.click(
						function() {

							$("#message1").hide();
							$("#message2").hide();
							$("#message3").hide();
							$("#message4").hide();
							$("#message5").hide();
							$("#ans2").hide();
							$("#ansSubmit2").hide();
							$("#ansCancel2").hide();
							$("#ans3").show();
							$("#ansSubmit3").show();
							$("#ansCancel3").show();
							$("#q3").css("background-color", "#00FF00");
							$("#q2").css("background-color", "#FF0000");
							$("#num3").append("3");
							$("#ques3")
									.text(
											"Microsoft Windows provides a graphics application named");
							$("#op13").text("Paint");
							$("#op23").text("Adobe Photoshop");
							$("#op33").text("Jasc Paint Shop");
							$("#op43").text("None of these");
							$("#remQues").text("3 out of 5");
						});

		$("#ansSubmit3")
				.click(
						function() {

							$("#message1").hide();
							$("#message2").hide();
							$("#message3").hide();
							$("#message4").hide();
							$("#message5").hide();
							$("#ans3").hide();
							$("#ansSubmit3").hide();
							$("#ansCancel3").hide();
							$("#ans4").show();
							$("#ansSubmit4").show();
							$("#ansCancel4").show();
							$("#q4").css("background-color", "#00FF00");
							$("#q3").css("background-color", "#FF0000");
							$("#num4").append("4");
							$("#ques4")
									.text(
											"Which of the following file format is supported in Windows 7");
							$("#op14").text("NTFS");
							$("#op24").text("BDS");
							$("#op34").text("EXT");
							$("#op44").text("All of the above");
							$("#remQues").text("4 out of 5");

						});

		$("#ansSubmit4")
				.click(
						function() {

							$("#message1").hide();
							$("#message2").hide();
							$("#message3").hide();
							$("#message4").hide();
							$("#message5").hide();
							$("#ans4").hide();
							$("#ansSubmit4").hide();
							$("#ansCancel4").hide();
							$("#ans5").show();
							$("#ansSubmit5").show();
							$("#ansCancel5").show();
							$("#q5").css("background-color", "#00FF00");
							$("#q4").css("background-color", "#FF0000");
							$("#num5").append("5");
							$("#ques5")
									.text(
											"What is the meaning of Hibernate in Windows XP/Windows 7 ?");
							$("#op15")
									.text("Restart the computer in safe mode");
							$("#op25").text(
									"Restart the computer in hibernate mode");
							$("#op35")
									.text(
											"Shut down the computer terminating all the running applications");
							$("#op45")
									.text(
											"Shut down the computer without closing the running applications");
							$("#remQues").text("5 out of 5");

						});

		$("#ansSubmit5").click(function() {

			$("#message1").show();
			$("#message2").hide();
			$("#message3").hide();
			$("#message4").hide();
			$("#message5").hide();
			$("#message1").html("Assessment for Unit 1 completed");
			$("#ans1").hide();
			$("#ans2").hide();
			$("#ans3").hide();
			$("#ans4").hide();
			$("#ans5").hide();
			$("#ansSubmit4").hide();
			$("#ansSubmit5").hide();
			$("#qa").hide();
			$("#button").hide();
			$("#ansCancel4").hide();
			/*    $("#ans5").show(); */
			/*  $("#ansSubmit5").show(); */
			$("#ansCancel5").show();
			$("#q5").css("background-color", "#FF0000");
			/*  $("#ques5").text("What is the meaning of Hibernate in Windows XP/Windows 7 ?");
			  $("#op15").text("Restart the computer in safe mode");
			  $("#op25").text("Restart the computer in hibernate mode");
			  $("#op35").text("Shut down the computer terminating all the running applications");
			  $("#op45").text("Shut down the computer without closing the running applications"); */

		});
	</script>
</body>
</html>