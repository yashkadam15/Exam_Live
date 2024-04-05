<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>OES | Forms</title>
</head>
<body>
  <fieldset class="well">
                    <legend><span><spring:message code="instruction.testInstruction"/></span></legend>
                    <div class="holder">
                        <form:form action="exam.html">
                            <ol>
                                <li><spring:message code="instruction.selectCorrectOption"/></li>
                                <li><spring:message code="instruction.selectCorrectOption"/></li>
                                <li><spring:message code="instruction.selectCorrectOption"/></li>
                                <li><spring:message code="instruction.selectCorrectOption"/></li>
                                <li><spring:message code="instruction.selectCorrectOption"/></li>
                                <li><spring:message code="instruction.selectCorrectOption"/></li>
                                <li><spring:message code="instruction.selectCorrectOption"/></li>
                                <li><spring:message code="instruction.selectCorrectOption"/></li>
                            </ol>
                            <div class="controls">
                                <label class="checkbox">
                                    <input type="checkbox" id="checkbox"> <spring:message code="instruction.readAllInstructions"/>
                                </label>
                            </div><br>
                            <div class="controls">
                                <button type="submit" class="btn btn-blue"><spring:message code="instruction.startPaper"/></button>
                                <button type="submit" class="btn btn-red"><spring:message code="takeTest.cancel"/></button>
                            </div>
                        </form:form>
                    </div>
                </fieldset>
</body>
</html>