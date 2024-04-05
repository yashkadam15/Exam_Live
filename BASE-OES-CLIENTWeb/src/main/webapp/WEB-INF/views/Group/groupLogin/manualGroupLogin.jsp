<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>

<html dir="ltr" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><spring:message code="groupLoginPage.Title" /></title>


</head>

<body>


								<!--Login Form -->
								

									<form:form modelAttribute="sessionObject" action="../groupLogin/manualgrouplogin" method="POST"
										id="loginformpost">

										<form:hidden path="examEvent.examEventID" />
										<form:hidden path="examEvent.name" />
										<form:hidden path="loginType" />
										<div class="login-type clearfix">
											<span class="btn btn-login-type-med pull-left"> <i
												class="icon-osp-large icon-usgroup"></i>
											</span>
											<div class="text">
												<spring:message code="groupLoginPage.GroupLoginLbl" />
												<span> ${sessionObject.examEvent.name}
												</span>
											</div>
										</div>
										<c:if test="${collectionMasterList!=null}">
										<div class="row-fluid">
														<div class="span3"><b>
															<c:if test="${collectionMasterList!=null && collectionMasterList[0].collectionType=='Batch'}">
																<label id='collectionName' class="control-label"
																	for="inputEmail"><spring:message
																		code="manualGroupLogin.Batch" /></label>
															</c:if>
															<c:if test="${collectionMasterList!=null && collectionMasterList[0].collectionType=='Division'}">
																<label id='collectionName' class="control-label"
																	for="inputEmail"><spring:message
																		code="manualGroupLogin.Division" /></label>
															</c:if></b>
															</div>
															<!-- <div class="controls"> -->
															<c:choose>
															<c:when test="${collectionMasterList!=null && (collectionMasterList[0].collectionType=='Batch' || collectionMasterList[0].collectionType=='Division')}">
															<div class="span2">
																<select id="collectionID" name="collectionID">
																	<option value="-1">--<spring:message code="groupLoginPage.Select"/>--</option>
																	<c:forEach var="collection" items="${collectionMasterList}">
																	<c:choose>
																	<c:when test="${collection.collectionID==sessionObject.collectionID}">
																		<option value="${collection.collectionID}" selected>${collection.collectionName}</option>
																	</c:when>
																	<c:otherwise>
																		<option value="${collection.collectionID}">${collection.collectionName}</option>
																	</c:otherwise>
																	</c:choose>
																		
																	</c:forEach>
																</select>
																</div>
																</c:when>
																<c:otherwise>
																	<input type="hidden" id="collectionID" name="collectionID" value="${collectionMasterList[0].collectionID}">
																</c:otherwise>
																</c:choose>
														</div>
													</c:if> 
									<c:if test="${collectionMasterList==null}">
										<input type="hidden" name="collectionID" id="collectionID" value="${collectionId}" />
															
									</c:if>
									<c:forEach begin="0" end="${sessionObject.examEvent.groupMaxSize-1}" step="1" varStatus="i">
											<div class="control-group">
												<span class="btn btn-user btn-two">
													<i class="icon-osp-large icon-us-w"></i>
												</span>
												<div class="controls">
													<i class="icon-user"></i> 
													<form:input path="venueUser[${i.index}].userName" id="user${i.index}"/>
												</div>
												<div class="controls">
													<i class="icon-greyer icon-lock"></i>
													<form:password path="venueUser[${i.index}].password" id="pass${i.index}"/>
												</div>
											</div>
										</c:forEach>
										<div class="controls text-center">
											<button class="btn btn-primary" type="submit">
												<spring:message code="groupLoginPage.Login" />
											</button>
										</div>
									</form:form>
								

								<p class="version" style="text-align: center;">
								<b>
									<a class="pull-left" href="../login/eventSelection"><spring:message
											code="groupLoginPage.Back" /></a>
									<c:if test="${webVersion !=null}">
										<spring:message code="adminLogin.version"></spring:message> <fmt:formatNumber type="number" maxFractionDigits="2" minFractionDigits="1" value="${webVersion}" />
									</c:if>
									<a class="pull-right" href="../adminLogin/loginpage"><spring:message
											code="EventSelection.WebAdmin" /></a></b>
								</p>
	
	<script>
	$(document)
			.ready(
					function() {
						
					
						$('#loginformpost').submit(function(e) {
							
							var flag = 0;
							var innerflag=0;
							var innermsg="";
							var usercnt=0;
							var errmsg='<spring:message code="manualGroupLogin.Pleasecorrectfollowingerrors"/>';
							var maxgroupsize= parseInt('${sessionObject.examEvent.groupMaxSize}',10);
							var insamecnt=0;
							
							if ($('#collectionID').val() == -1) {
								errmsg += "\n-"+ $('#collectionName').text()+".";
								flag = 1;
							}
							for(var i=0;i<maxgroupsize;i++)
							{
								for(var j=0;j<maxgroupsize;j++)
								{
									if(i!=j)
									{
										if($('#user'+i).val().trim().length!=0 && $('#user'+j).val().trim().length!=0)
										{
											if($('#user'+i).val()==$('#user'+j).val()) 
											{
												insamecnt=1;
											}
										}
									}
								}
							}
							if(insamecnt==1)
							{
								errmsg += "\n-";
								errmsg += '<spring:message code="manualGroupLogin.Duplicateusersnotallowed"/>.';
								flag = 1;
							}
							
							
							
							for(var i=0;i<maxgroupsize;i++)
								{
								if($('#user'+i).val().trim().length!=0)
									{
									usercnt=usercnt+1;
										if ($('#pass'+i).val().length == 0) 
										{
											
											innermsg += (i+1).toString()+"," ;
											innerflag = 1;
										}
									}
								}
							if(innerflag==1)
							{
								flag=1;
								var lastInd=innermsg.lastIndexOf(",");
								errmsg+="\n-";
								errmsg+='<spring:message code="manualGroupLogin.Enterpasswords"/>.';
							}
							if(usercnt==0)
							{
								errmsg += "\n-";
								errmsg += '<spring:message code="manualGroupLogin.Pleaseenterusernameandpassword"/>.';
								flag = 1;
							}
							
							
							if (flag == 1) {
								alert(errmsg);
								return false;
							}
							
						});

				});
	


</script>
</body>
</html>