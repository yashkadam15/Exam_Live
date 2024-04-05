$(function() {

						//for filling answer matrics if it is in edit level
						//var answerdata="viraj dhamal Indian Now";
						var answerdata = $("#answerdata").val();

						//var answerdata="";
						var answeArr = [];
						var removedCellColumn = [];
						//allow for edit of not
						var editrestrict = $("#editrestrict").val();
						if (answerdata.length > 0) {
							if (editrestrict) {
								$("#btnReset").prop("disabled", true);
							} else {
								$("#btnReset").prop("disabled", false);
							}
							answeArr = answerdata.split(" ");
							if (answeArr.length > 0) {
								for (var col = 0; col < answeArr.length; col++) {
									var parentDiv;
									if (editrestrict) {
										parentDiv = $(
												document.createElement('div'))
												.attr("class", "noborder")
												.attr("column", col).attr(
														"onclick",
														"return false").css(
														"background-color",
														"#00bcd4");
									} else {
										parentDiv = $(
												document.createElement('div'))
												.attr("class", "noborder")
												.attr("column", col).attr(
														"onclick",
														"transfer(this)").css(
														"background-color",
														"#00bcd4");
									}

									var childDiv = $(document
											.createElement('div'));
									childDiv
											.append(answeArr[col]
													+ '<i class="fa fa-hand-pointer-o" aria-hidden="true"></i>');
									parentDiv.append(childDiv);
									$("#div" + col).append(parentDiv);
								}
							}
						}

						//for filling full table matrics
						var celldata = $("#celldata").val();
						//celldata='[{"rno":0,"column":[{"cno":0,"cvalue":"viraj","checked":true},{"cno":1,"cvalue":"dhamal","checked":true},{"cno":2,"cvalue":"acting","checked":false},{"cno":3,"cvalue":"at","checked":false}]},{"rno":1,"column":[{"cno":0,"cvalue":"viraj","checked":false},{"cno":1,"cvalue":"kumar","checked":false},{"cno":2,"cvalue":"Indian","checked":true},{"cno":3,"cvalue":"all","checked":false}]},{"rno":2,"column":[{"cno":0,"cvalue":"to","checked":false},{"cno":1,"cvalue":"in","checked":false},{"cno":2,"cvalue":"then","checked":false},{"cno":3,"cvalue":"Now","checked":true}]},{"rno":3,"column":[{"cno":0,"cvalue":"We","checked":false},{"cno":1,"cvalue":"are","checked":false},{"cno":2,"cvalue":"Ok","checked":false},{"cno":3,"cvalue":"Not","checked":false}]}]';
						if (celldata != '') { // if celldata not empty or null

							var qtype = $('#qtype').val();
							var jsonCellData = jQuery.parseJSON(celldata);

							$("#tblMatrix").remove();
							var table = $(document.createElement('table'))
									.attr("id", 'matrixTable');
							$
									.each(
											jsonCellData,
											function(key, value) {
												var newTr = $(document
														.createElement('tr'));
												var rowno = value.rno;
												$
														.each(
																value.column,
																function(key,
																		value) {
																	var colmnno = value.cno;
																	var newTd = $(document
																			.createElement('td'));
																	var mainDiv = $(
																			document
																					.createElement('div'))
																			.attr(
																					"id",
																					'div'
																							+ rowno
																							+ ''
																							+ colmnno
																							+ '')
																			.attr(
																					"class",
																					"border")
																			.attr(
																					"pcolumn",
																					colmnno);
																	//keep the cell empty if the value is in respective answer column
																	if (answeArr[colmnno] != value.cvalue
																			|| $
																					.inArray(
																							colmnno,
																							removedCellColumn) > -1) {
																		var parentDiv;
																		if (answeArr[colmnno]) {
																			parentDiv = $(
																					document
																							.createElement('div'))
																					.attr(
																							"id",
																							'opt'
																									+ rowno
																									+ ''
																									+ colmnno
																									+ '')
																					.attr(
																							"class",
																							"noborder")
																					.attr(
																							"column",
																							colmnno)
																					.attr(
																							"onclick",
																							"return false");
																		} else {
																			parentDiv = $(
																					document
																							.createElement('div'))
																					.attr(
																							"id",
																							'opt'
																									+ rowno
																									+ ''
																									+ colmnno
																									+ '')
																					.attr(
																							"class",
																							"noborder")
																					.attr(
																							"column",
																							colmnno)
																					.attr(
																							"onclick",
																							"transfer(this)");
																		}
																		var childDiv = $(document
																				.createElement('div'))
																		childDiv
																				.append(value.cvalue
																						+ '<i class="fa fa-hand-pointer-o" aria-hidden="true"></i>');
																		parentDiv
																				.append(childDiv);
																		mainDiv
																				.append(parentDiv);
																	} else {
																		removedCellColumn
																				.push(colmnno);
																		mainDiv
																				.css(
																						"background-color",
																						"#D3D3D3");
																	}

																	newTd
																			.append(mainDiv);
																	newTr
																			.append(newTd);
																});
												table.append(newTr);
											});

							$("#matrixDiv").append(table);
						}

						$('#btnReset')
								.click(
										function() {
											$('#ans')
													.find('div[pcolumn]')
													.each(
															function() {
																if ($(this)
																		.find(
																				'div').length > 0) {
																	var elementCopy = $(
																			this)
																			.children()
																			.clone();
																	var pclmnId = $(
																			this)
																			.attr(
																					"pcolumn");
																	var targetDivId = pclmnId
																			.substring(
																					1,
																					pclmnId.length);
																	$(
																			elementCopy)
																			.css(
																					"background-color",
																					"");

																	$(
																			"#matrixDiv")
																			.find(
																					"div[pcolumn='"
																							+ targetDivId
																							+ "']")
																			.each(
																					function() {
																						if ($(
																								this)
																								.find(
																										'div').length == 0) {
																							$(
																									this)
																									.append(
																											elementCopy);
																							$(
																									this)
																									.css(
																											"background-color",
																											"");
																						}
																						$(
																								this)
																								.find(
																										'div[column]')
																								.attr(
																										"onclick",
																										"transfer(this)");
																					});
																	$(this)
																			.children()
																			.remove();
																}
															});
										});

						$("#layout-condensed-toggle").click();
					});
	/////// matrix srcipt ////

	function transfer(ele) {
		if($('#AllowAnswerUpdate',window.parent.document).val()=='false' && $('#mode').val()!='off') {
			return false;
		}
			var pclmnId = $(ele).parent().attr("pcolumn");
			var elementCopy = $(ele).clone();
			if (pclmnId.substring(0, 1) == 'p') { //transfer back 
				var targetDivId = pclmnId.substring(1, pclmnId.length);
				$(elementCopy).css("background-color", "");
	
				$("#matrixDiv").find("div[pcolumn='" + targetDivId + "']").each(
						function() {
							if ($(this).find('div').length == 0) {
								$(this).append(elementCopy);
								$(this).css("background-color", "");
							}
							$(this).find('div[column]').attr("onclick",
									"transfer(this)");
						});
			} else { // transfer to ans matrix
				var targetDivId = 'p' + pclmnId.substring(0, pclmnId.length);
				$(elementCopy).css("background-color", "#00bcd4");
				$("#ans").find("div[pcolumn='" + targetDivId + "']").html(
						elementCopy);
				$("#matrixDiv").find(
						"div[pcolumn='" + pclmnId.substring(0, pclmnId.length)
								+ "']").each(function() {
					$(this).find('div').attr("onclick", "return false");
				});
				$(ele).parent().css("background-color", "#D3D3D3");
			}
	
			$(ele).remove();
		

	} 
  