<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:f="Functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:variable name="lang" select="PDFViewModelData/locale" />
	<xsl:variable name="properties" select="unparsed-text($lang)"
		as="xs:string" />



	<xsl:attribute-set name="myBorder">
		<xsl:attribute name="border">solid 0.1mm gray</xsl:attribute>
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="titles">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">16pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">white</xsl:attribute>
		<xsl:attribute name="background-color">#428BCA</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="boldtext">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="margin-left">.2cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
		<!-- <xsl:attribute name="background-color">#C0C0C0</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:attribute-set name="normaltext">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-left">.2cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
		<!-- <xsl:attribute name="background-color">#C0C0C0</xsl:attribute> -->
	</xsl:attribute-set>



	<xsl:template match="PDFViewModelData">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>

				<fo:simple-page-master master-name="first"
					page-height="29.7cm" page-width="21cm" margin-left="0.5cm"
					margin-right="0.5cm" margin-top="1mm" margin-bottom="0.1cm">
					<fo:region-body region-name="pg-body" margin-top="12mm"
						margin-bottom="2cm" />
					<fo:region-before region-name="header-first"
						extent="20mm" margin-top="0.7mm" />
					<fo:region-after region-name="footer-first" extent="20mm" />
				</fo:simple-page-master>

				<fo:simple-page-master master-name="rest"
					page-height="29.7cm" page-width="21cm" margin-left="0.5cm"
					margin-right="0.5cm" margin-top="1mm" margin-bottom="0.1cm">
					<fo:region-body region-name="pg-body" margin-top="12mm"
						margin-bottom="2cm" />
					<fo:region-before region-name="header-rest"
						extent="1cm" margin-top="0.7mm" />
					<fo:region-after region-name="footer-rest" extent="1.5cm" />
				</fo:simple-page-master>

				<fo:page-sequence-master master-name="simple">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference
							page-position="first" master-reference="first" />
						<fo:conditional-page-master-reference
							page-position="rest" master-reference="rest" />
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>


			</fo:layout-master-set>
			<fo:page-sequence master-reference="simple">


				<!-- First Page header(not required) -->
				<!-- <fo:static-content flow-name="header-first"> <fo:block font-family="APARAJ" 
					font-size="15pt" text-align="center"> <xsl:value-of select="questionPaperTitle" 
					/> First Page Header </fo:block> </fo:static-content> -->

				<!-- rest Page header -->
				<fo:static-content flow-name="header-rest">
					<xsl:if test="locale = 'messages_ar.properties'">
						<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
					</xsl:if>
					<!-- table for header -->
					<fo:table>
						<fo:table-column column-number="1" />
						<fo:table-column column-number="2" />
						<fo:table-body>
							<fo:table-row keep-together.within-column="always">

								<fo:table-cell text-align="left">
									<xsl:if test="locale = 'messages_ar.properties'">
										<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
									</xsl:if>
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="examDispalyCategoryPaperViewModelObj/paperName" />
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right">
									<xsl:if test="locale = 'messages_ar.properties'">
										<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
										<xsl:attribute name="text-align">left</xsl:attribute>
									</xsl:if>
									<fo:block xsl:use-attribute-sets="normaltext">
										<fo:inline padding-right="1mm">
											<xsl:value-of select="candidateFirstName"></xsl:value-of>

										</fo:inline>
										<fo:inline padding-right="1mm">
											<xsl:value-of select="candidateMiddleName"></xsl:value-of>
										</fo:inline>

										<fo:inline padding-right="1mm">
											<xsl:value-of select="candidateLastName"></xsl:value-of>
										</fo:inline>


									</fo:block>
								</fo:table-cell>

							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:static-content>



				<!-- First Page Footer -->
				<fo:static-content flow-name="footer-first">
					<xsl:if test="locale = 'messages_ar.properties'">
						<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
					</xsl:if>

					<!-- table for footer -->
					<fo:table>
						<fo:table-column column-number="1" />
						<fo:table-column column-number="2" />
						<!-- <fo:table-column column-number="3" /> -->
						<fo:table-body>
							<fo:table-row keep-together.within-column="always">

								<fo:table-cell>
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="eventName" />
									</fo:block>
								</fo:table-cell>
								<!-- <fo:table-cell text-align="center"> <fo:block xsl:use-attribute-sets="normaltext"> 
									<fo:basic-link external-destination="http://www.mkcl.org" text-decoration="underline" 
									color="blue">www.mkcl.org </fo:basic-link> </fo:block> </fo:table-cell> -->
								<fo:table-cell>
									<fo:block xsl:use-attribute-sets="normaltext">

										<fo:block xsl:use-attribute-sets="normaltext">
											<fo:page-number />
											&#x00A0;
											<xsl:value-of select="f:getProperty('global.pagination.of')" />
											&#x00A0;
											<fo:page-number-citation ref-id="end" />
										</fo:block>


									</fo:block>
								</fo:table-cell>

							</fo:table-row>
						</fo:table-body>
					</fo:table>

				</fo:static-content>

				<!-- rest Page Footer -->
				<fo:static-content flow-name="footer-rest">
					<xsl:if test="locale = 'messages_ar.properties'">
						<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
					</xsl:if>
					<!-- table for footer -->
					<fo:table>
						<fo:table-column column-number="1" />
						<fo:table-column column-number="2" />
						<!-- <fo:table-column column-number="3" /> -->
						<fo:table-body>
							<fo:table-row keep-together.within-column="always">

								<fo:table-cell>
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="eventName" />
									</fo:block>
								</fo:table-cell>
								<!-- <fo:table-cell text-align="center"> <fo:block xsl:use-attribute-sets="normaltext"> 
									<fo:basic-link external-destination="http://www.mkcl.org" text-decoration="underline" 
									color="blue">www.mkcl.org </fo:basic-link> </fo:block> </fo:table-cell> -->
								<fo:table-cell>
									<fo:block xsl:use-attribute-sets="normaltext">

										<fo:block xsl:use-attribute-sets="normaltext">
											<fo:page-number />
											&#x00A0;
											<xsl:value-of select="f:getProperty('global.pagination.of')" />
											&#x00A0;
											<fo:page-number-citation ref-id="end" />
										</fo:block>


									</fo:block>
								</fo:table-cell>

							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:static-content>

				<fo:flow flow-name="pg-body">

					<xsl:if test="locale = 'messages_ar.properties'">
						<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
					</xsl:if>
					<fo:block font-family="APARAJ" font-size="12pt"
						font-weight="normal">




						<fo:block font-size="14pt" font-family="APARAJ" color="blue"
							text-align="center">
							<xsl:value-of select="eventName"></xsl:value-of>
						</fo:block>

						<!-- code to set value of paper attribute is section required -->

						<xsl:variable name="isSectionreqd"
							select="examDispalyCategoryPaperViewModelObj/isSectionRequired"></xsl:variable>

						<fo:block xsl:use-attribute-sets="boldtext" text-align="center">
							<fo:block xsl:use-attribute-sets="normaltext">
								<xsl:value-of select="f:getProperty('analysisbooklet.title')" />
								<xsl:value-of select="examDispalyCategoryPaperViewModelObj/paperName" />
								<xsl:if
									test="examDispalyCategoryPaperViewModelObj/assessmentType!='Group'">
									<xsl:value-of select="f:getProperty('attemptnumber.label')" />
									<xsl:value-of select="attemptNumber" />
									<xsl:value-of select="f:getProperty('closingbracket.symbol')" />
								</xsl:if>

							</fo:block>

						</fo:block>



						<!-- Candidate details table -->
						<fo:table>


							<fo:table-column column-number="1" column-width="40%" />
							<fo:table-column column-number="2" column-width="35%" />
							<fo:table-column column-number="3" column-width="10%" />
							<fo:table-column column-number="4" />

							<fo:table-body>

								<fo:table-row>
									<!-- Heading row -->
									<fo:table-cell xsl:use-attribute-sets="myBorder"
										number-columns-spanned="4" text-align="center">
										<fo:block xsl:use-attribute-sets="titles">
											<xsl:value-of select="f:getProperty('canidatedetails.label')" />
										</fo:block>
									</fo:table-cell>

								</fo:table-row>
								<!-- 1st Row -->
								<fo:table-row keep-together.within-column="always"
									background-color="#F9F8F6">
									<!-- 1st cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of
												select="f:getProperty('incompleteexams.CandidateName')" />
										</fo:block>
									</fo:table-cell>
									<!-- 2nd cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of select="f:getProperty('GroupReport.loginId')" />
										</fo:block>
									</fo:table-cell>
									<!-- 3rd cell -->
									<xsl:if test="collectionType != 'None'">
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext">


												<xsl:if test="collectionType = 'Division'">
													<xsl:value-of select="f:getProperty('groupLoginPage.Division')" />
												</xsl:if>
												<xsl:if test="collectionType = 'Batch'">
													<xsl:value-of select="f:getProperty('groupLoginPage.Batch')" />
												</xsl:if>

											</fo:block>
										</fo:table-cell>
									</xsl:if>
									<!-- 4th cell -->

									<xsl:if test="collectionType != 'None'">
										<fo:table-cell xsl:use-attribute-sets="myBorder"
											number-rows-spanned="2">
											<fo:block xsl:use-attribute-sets="normaltext"
												text-align="center">
												<xsl:variable name="candidateImagesrc" select="candidateImagePath" />
												<fo:external-graphic src="url('{candidateImagePath}')"
													content-width="3cm" content-height="2cm">
												</fo:external-graphic>
											</fo:block>
										</fo:table-cell>
									</xsl:if>

									<xsl:if test="collectionType = 'None'">
										<fo:table-cell xsl:use-attribute-sets="myBorder"
											number-rows-spanned="2" number-columns-spanned="2">
											<fo:block xsl:use-attribute-sets="normaltext"
												text-align="center">
												<xsl:variable name="candidateImagesrc" select="candidateImagePath" />
												<fo:external-graphic src="url('{candidateImagePath}')"
													content-width="3cm" content-height="2cm">
												</fo:external-graphic>
											</fo:block>
										</fo:table-cell>
									</xsl:if>


								</fo:table-row>
								<fo:table-row keep-together.within-column="always">

									<fo:table-cell xsl:use-attribute-sets="myBorder"
										display-align="center">
										<fo:block xsl:use-attribute-sets="normaltext">
											<fo:inline padding-right="1mm">
												<xsl:value-of select="candidateFirstName"></xsl:value-of>

											</fo:inline>
											<fo:inline padding-right="1mm">
												<xsl:value-of select="candidateMiddleName"></xsl:value-of>
											</fo:inline>

											<fo:inline padding-right="1mm">
												<xsl:value-of select="candidateLastName"></xsl:value-of>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell xsl:use-attribute-sets="myBorder"
										display-align="center">
										<fo:block xsl:use-attribute-sets="normaltext">
											<xsl:value-of select="candidateUserName"></xsl:value-of>
										</fo:block>
									</fo:table-cell>
									<xsl:if test="collectionType != 'None'">
										<fo:table-cell xsl:use-attribute-sets="myBorder"
											display-align="center">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="candidateCollection"></xsl:value-of>
											</fo:block>
										</fo:table-cell>
									</xsl:if>
									<!-- <fo:table-cell xsl:use-attribute-sets="myBorder" number-columns-spanned=""> 
										<fo:block xsl:use-attribute-sets="normaltext"> <fo:external-graphic src="url('resources/WebFiles/UserImages/defaultCandidate.jpg')" 
										content-width="3cm" content-height="3cm"> </fo:external-graphic> </fo:block> 
										</fo:table-cell> -->
								</fo:table-row>
							</fo:table-body>
						</fo:table>
						<!-- End of Candidate details table -->

						<!--(Brief Analysis) Parent table start -->
						<fo:table xsl:use-attribute-sets="myBorder" space-before="1cm">


							<fo:table-column column-number="1" />
							<fo:table-body>

								<!-- 1st Row -->
								<fo:table-row keep-together.within-column="always">

									<fo:table-cell text-align="center">
										<fo:block xsl:use-attribute-sets="titles">
											<xsl:value-of select="examSubjectPaperViewModelObj/paperName" />
										</fo:block>
									</fo:table-cell>

								</fo:table-row>

								<!-- 2nd row -->
								<fo:table-row keep-together.within-column="always">

									<fo:table-cell>
										<fo:block>

											<!-- Inner table -->
											<fo:table>

												<fo:table-column column-number="1" />
												<fo:table-column column-number="2" />
												<fo:table-column column-number="3" />
												<fo:table-column column-number="4" />
												<fo:table-body>
													<!-- inner 1st row -->
													<fo:table-row keep-together.within-column="always"
														background-color="#F9F8F6">

														<!-- 1st cell of inner table -->
														<fo:table-cell xsl:use-attribute-sets="myBorder">
															<fo:block xsl:use-attribute-sets="boldtext">
																<xsl:value-of
																	select="f:getProperty('candidateTestReport.selectDisplayCategory')" />
															</fo:block>
														</fo:table-cell>
														<!-- 2st cell of inner table -->
														<fo:table-cell xsl:use-attribute-sets="myBorder">
															<fo:block xsl:use-attribute-sets="boldtext">
																<xsl:value-of select="f:getProperty('Candidate.syllabus')" />
															</fo:block>
														</fo:table-cell>
														<!-- 3rd cell of inner table -->
														<fo:table-cell xsl:use-attribute-sets="myBorder">
															<fo:block xsl:use-attribute-sets="boldtext">
																<xsl:value-of select="f:getProperty('testdetails.TestDate')" />
															</fo:block>
														</fo:table-cell>
														<!-- 4th cell of inner table -->
														<fo:table-cell xsl:use-attribute-sets="myBorder">
															<fo:block xsl:use-attribute-sets="boldtext">
																<xsl:value-of
																	select="f:getProperty('testdetails.TestDuration')" />
															</fo:block>
														</fo:table-cell>
													</fo:table-row>

													<!-- inner 2nd row -->
													<fo:table-row keep-together.within-column="always">

														<!-- 1st cell of inner table -->
														<fo:table-cell xsl:use-attribute-sets="myBorder">
															<fo:block margin-left=".2cm"
																xsl:use-attribute-sets="normaltext">
																<xsl:value-of
																	select="examDispalyCategoryPaperViewModelObj/displayCategoryName" />

															</fo:block>
														</fo:table-cell>
														<!-- 2st cell of inner table -->
														<fo:table-cell xsl:use-attribute-sets="myBorder">
															<fo:block xsl:use-attribute-sets="normaltext">
																<xsl:for-each
																	select="./examDispalyCategoryPaperViewModelObj/listofSectionviewModelOfExamDisplayCategory/sectionviewModelOfExamDisplayCategory">
																	<xsl:if test="$isSectionreqd =  'Y'">
																		<fo:block font-size="10" color="blue"
																			text-decoration="underline">
																			<xsl:value-of select="f:getProperty('section.label')" />
																			<xsl:value-of select="sectionName"></xsl:value-of>
																		</fo:block>
																	</xsl:if>
																	<xsl:for-each select="./listItemBanks/itemBank">
																		<xsl:value-of
																			select="concat(substring(', ',1,position()-1),name)" />
																	</xsl:for-each>
																</xsl:for-each>
															</fo:block>
														</fo:table-cell>
														<!-- 3rd cell of inner table -->
														<fo:table-cell xsl:use-attribute-sets="myBorder">
															<fo:block xsl:use-attribute-sets="normaltext">
																<xsl:value-of
																	select="examDispalyCategoryPaperViewModelObj/attemptDate" />
															</fo:block>
														</fo:table-cell>
														<!-- 4th cell of inner table -->
														<fo:table-cell xsl:use-attribute-sets="myBorder">
															<fo:block xsl:use-attribute-sets="normaltext">
																<xsl:value-of
																	select="examDispalyCategoryPaperViewModelObj/duration" />
																&#160;
																<xsl:value-of select="f:getProperty('minute.label')" />
															</fo:block>
														</fo:table-cell>
													</fo:table-row>


												</fo:table-body>
											</fo:table>


										</fo:block>
									</fo:table-cell>
								</fo:table-row>


							</fo:table-body>


						</fo:table>


						<!-- Second Parent table start -->
						<fo:table space-before="1cm">



							<fo:table-column column-number="1" />
							<fo:table-column column-number="2" />
							<fo:table-column column-number="3" />
							<fo:table-column column-number="4" />
							<fo:table-column column-number="5" />
							<xsl:if
								test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">
								<fo:table-column column-number="6" />
							</xsl:if>
							<fo:table-body>

								<!-- Heading of brief analysis -->
								<fo:table-row keep-together.within-column="always"
									background-color="#F9B749">

									<!-- 1st cell of inner table -->
									<xsl:choose>
										<xsl:when
											test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">
											<fo:table-cell number-columns-spanned="6">
												<fo:block xsl:use-attribute-sets="boldtext" color="black"
													keep-with-next="always" font-size="16pt" text-align="center">
													<xsl:value-of
														select="f:getProperty('viewtestscore.BriefAnalysis')" />
												</fo:block>
											</fo:table-cell>
										</xsl:when>
										<xsl:otherwise>
											<fo:table-cell number-columns-spanned="5">
												<fo:block xsl:use-attribute-sets="boldtext" color="black"
													keep-with-next="always" font-size="16pt" text-align="center">
													<xsl:value-of
														select="f:getProperty('viewtestscore.BriefAnalysis')" />
												</fo:block>
											</fo:table-cell>
										</xsl:otherwise>
									</xsl:choose>





								</fo:table-row>

								<!-- First row -->

								<xsl:choose>
									<xsl:when
										test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">
										<fo:table-row keep-together.within-column="always"
											background-color="#D8D8D8">

											<!-- 1st cell of inner table -->
											<fo:table-cell number-columns-spanned="6">
												<fo:block xsl:use-attribute-sets="boldtext" color="black"
													text-align="center">
													<xsl:value-of select="f:getProperty('viewtestscore.Questions')" />
												</fo:block>
											</fo:table-cell>


										</fo:table-row>
									</xsl:when>
									<xsl:otherwise>
										<fo:table-row keep-together.within-column="always"
											background-color="#D8D8D8">

											<!-- 1st cell of inner table -->
											<fo:table-cell number-columns-spanned="5">
												<fo:block xsl:use-attribute-sets="boldtext" color="black"
													text-align="center">
													<xsl:value-of select="f:getProperty('viewtestscore.Questions')" />
												</fo:block>
											</fo:table-cell>


										</fo:table-row>
									</xsl:otherwise>
								</xsl:choose>

								<!-- second row -->



								<xsl:choose>

									<xsl:when test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">
										<fo:table-row keep-together.within-column="always" background-color="#F9F8F6">

											<!-- 1st cell of inner table -->
											<fo:table-cell text-align="center" number-columns-spanned="2" xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('viewtestscore.Question')" />
												</fo:block>
											</fo:table-cell>
											<!-- 2st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('viewtestscore.Attempted')" />
												</fo:block>
											</fo:table-cell>
											<!-- 3rd cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('questionByquestion.correct')" />
												</fo:block>
											</fo:table-cell>

											<!-- 4th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of
														select="f:getProperty('questionByquestion.incorrect')" />
												</fo:block>
											</fo:table-cell>
											<!-- 5th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
												<xsl:value-of select="f:getProperty('viewtestscore.evaluationPending')" />
												</fo:block>
											</fo:table-cell>

										</fo:table-row>


										<!-- For main Items -->
										<!-- Third row -->
										<fo:table-row keep-together.within-column="always">

											<!-- 1st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('viewtestscore.MainQues')" />
												</fo:block>
											</fo:table-cell>


											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="resultAnalysisViewModelObj/totalMainItem" />
												</fo:block>
											</fo:table-cell>
											<!-- 2st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of
														select="resultAnalysisViewModelObj/totalAttemptedMainItem" />
												</fo:block>
											</fo:table-cell>
											<!-- 3rd cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="resultAnalysisViewModelObj/totalMainItemCorrectAnswer" />
												</fo:block>
											</fo:table-cell>

											<!-- 4th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:variable name="totalAttemptedMainItems" select="resultAnalysisViewModelObj/totalAttemptedMainItem"></xsl:variable>
													<xsl:variable name="totalCorrectMainItems" select="resultAnalysisViewModelObj/totalMainItemCorrectAnswer"></xsl:variable>
													<xsl:variable name="evPendingMainItem" select="resultAnalysisViewModelObj/totalEvaluationPendingMainItem"></xsl:variable>
													
													<xsl:value-of select="$totalAttemptedMainItems - $totalCorrectMainItems - $evPendingMainItem" />
												</fo:block>
											</fo:table-cell>
											
											<!-- 5th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
												<xsl:value-of select="resultAnalysisViewModelObj/totalEvaluationPendingMainItem" />
												</fo:block>
											</fo:table-cell>
											

										</fo:table-row>



										<!-- For Sub item -->

										<fo:table-row keep-together.within-column="always">

											<!-- 1st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('viewtestscore.SubQues')" />
												</fo:block>
											</fo:table-cell>


											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="resultAnalysisViewModelObj/totalSubItem" />
												</fo:block>
											</fo:table-cell>
											<!-- 2st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of
														select="resultAnalysisViewModelObj/totalAttemptedSubItem" />
												</fo:block>
											</fo:table-cell>
											<!-- 3rd cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of
														select="resultAnalysisViewModelObj/totalSubItemCorrectAnswer" />
												</fo:block>
											</fo:table-cell>

											<!-- 4th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:variable name="totalAttemptedSubItems" select="resultAnalysisViewModelObj/totalAttemptedSubItem"></xsl:variable>
													<xsl:variable name="totalCorrectSubItems" select="resultAnalysisViewModelObj/totalSubItemCorrectAnswer"></xsl:variable>
													<xsl:variable name="evPendingSubItems" select="resultAnalysisViewModelObj/totalEvaluationPendingSubItem"></xsl:variable>
													
													
													<xsl:value-of select="$totalAttemptedSubItems - $totalCorrectSubItems - $evPendingSubItems" />
												</fo:block>
											</fo:table-cell>
											
											<!-- 5th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
												<xsl:value-of select="resultAnalysisViewModelObj/totalEvaluationPendingSubItem" />
												</fo:block>
											</fo:table-cell>
											

										</fo:table-row>


										<!-- Total of All -->


										<fo:table-row keep-together.within-column="always">

											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('viewtestscore.Total')" />
												</fo:block>
											</fo:table-cell>

											<!-- 1st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">

													<xsl:variable name="totalMainItems"
														select="resultAnalysisViewModelObj/totalMainItem"></xsl:variable>

													<xsl:variable name="totalSubItems"
														select="resultAnalysisViewModelObj/totalSubItem"></xsl:variable>

													<xsl:value-of select="$totalMainItems + $totalSubItems" />
												</fo:block>
											</fo:table-cell>
											<!-- 2st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:variable name="totalAttemptedSubItems" select="resultAnalysisViewModelObj/totalAttemptedSubItem"></xsl:variable>
													<xsl:variable name="totalAttemptedMainItems" select="resultAnalysisViewModelObj/totalAttemptedMainItem"></xsl:variable>
													<xsl:value-of select="$totalAttemptedSubItems + $totalAttemptedMainItems" />
												</fo:block>
											</fo:table-cell>
											<!-- 3rd cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:variable name="totalCorrectedSubItems" select="resultAnalysisViewModelObj/totalSubItemCorrectAnswer"></xsl:variable>
													<xsl:variable name="totalCorrectedMainItems" select="resultAnalysisViewModelObj/totalMainItemCorrectAnswer"></xsl:variable>
													<xsl:value-of select="$totalCorrectedSubItems + $totalCorrectedMainItems" />
												</fo:block>
											</fo:table-cell>

											<!-- 4th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:variable name="totalAttemptedSubItems" select="resultAnalysisViewModelObj/totalAttemptedSubItem"></xsl:variable>
													<xsl:variable name="totalCorrectSubItems" select="resultAnalysisViewModelObj/totalSubItemCorrectAnswer"></xsl:variable>
													<xsl:variable name="totalIncorrectSubItems" select="$totalAttemptedSubItems - $totalCorrectSubItems"></xsl:variable>
													<xsl:variable name="totalAttemptedMainItems" select="resultAnalysisViewModelObj/totalAttemptedMainItem"></xsl:variable>
													<xsl:variable name="totalCorrectMainItems" select="resultAnalysisViewModelObj/totalMainItemCorrectAnswer"></xsl:variable>
													<xsl:variable name="totalIncorrectMainItems" select="$totalAttemptedMainItems - $totalCorrectMainItems"></xsl:variable>

													<xsl:variable name="pendingMainItems" select="resultAnalysisViewModelObj/totalEvaluationPendingMainItem"></xsl:variable>
													<xsl:variable name="pendingSubItems" select="resultAnalysisViewModelObj/totalEvaluationPendingSubItem"></xsl:variable>
											
													<xsl:value-of select="$totalIncorrectMainItems + $totalIncorrectSubItems -($pendingMainItems + $pendingSubItems)" />
												</fo:block>
											</fo:table-cell>

												<!-- 5th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:variable name="pendingMainItems" select="resultAnalysisViewModelObj/totalEvaluationPendingMainItem"></xsl:variable>
													<xsl:variable name="pendingSubItems" select="resultAnalysisViewModelObj/totalEvaluationPendingSubItem"></xsl:variable>
													<xsl:value-of select="$pendingMainItems + $pendingSubItems" />
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:when>
	
										<xsl:otherwise>
										<fo:table-row keep-together.within-column="always"
											background-color="#F9F8F6">

											<!-- 1st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('viewtestscore.TotalQuestions')" />
												</fo:block>
											</fo:table-cell>
											<!-- 2st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('viewtestscore.Attempted')" />
												</fo:block>
											</fo:table-cell>
											<!-- 3rd cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('questionByquestion.correct')" />
												</fo:block>
											</fo:table-cell>

											<!-- 4th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('questionByquestion.incorrect')" />
												</fo:block>
											</fo:table-cell>
											
											<!-- 5th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="f:getProperty('viewtestscore.evaluationPending')" />
												</fo:block>
											</fo:table-cell>

										</fo:table-row>

										<!-- Third row -->
										<fo:table-row keep-together.within-column="always">

											<!-- 1st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="resultAnalysisViewModelObj/totalItem" />
												</fo:block>
											</fo:table-cell>
											<!-- 2st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="resultAnalysisViewModelObj/totalAttemptedItem" />
												</fo:block>
											</fo:table-cell>
											<!-- 3rd cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="resultAnalysisViewModelObj/totalCorrectAnswer" />
												</fo:block>
											</fo:table-cell>

											<!-- 4th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:variable name="totalAttempted" select="resultAnalysisViewModelObj/totalAttemptedItem"></xsl:variable>
													<xsl:variable name="totalCorrect" select="resultAnalysisViewModelObj/totalCorrectAnswer"></xsl:variable>
														<xsl:variable name="evpending" select="resultAnalysisViewModelObj/totalEvaluationPendingItem"></xsl:variable>
														<xsl:variable name="incorrect" select="$totalAttempted - $totalCorrect - $evpending"></xsl:variable>
													
													
													<xsl:value-of select="$incorrect" />
												</fo:block>
											</fo:table-cell>
											
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of select="resultAnalysisViewModelObj/totalEvaluationPendingItem"></xsl:value-of>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:otherwise>


								</xsl:choose>


								<!-- Fourth row -->
								<xsl:choose>

									<xsl:when
										test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">

										<fo:table-row keep-together.within-column="always"
											background-color="#D8D8D8">

											<!-- 1st cell of inner table -->
											<fo:table-cell number-columns-spanned="6">
												<fo:block xsl:use-attribute-sets="boldtext" color="black"
													text-align="center">
													<xsl:value-of select="f:getProperty('viewtestscore.Marks')" />
												</fo:block>
											</fo:table-cell>


										</fo:table-row>

									</xsl:when>

									<xsl:otherwise>
										<fo:table-row keep-together.within-column="always"
											background-color="#D8D8D8">

											<!-- 1st cell of inner table -->
											<fo:table-cell number-columns-spanned="5">
												<fo:block xsl:use-attribute-sets="boldtext" color="black"
													text-align="center">
													<xsl:value-of select="f:getProperty('viewtestscore.Marks')" />
												</fo:block>
											</fo:table-cell>


										</fo:table-row>
									</xsl:otherwise>
								</xsl:choose>

								<!-- Fifth row -->
								<fo:table-row keep-together.within-column="always"
									background-color="#F9F8F6">

									<!-- 1st cell of inner table -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext" color="black">
											<xsl:value-of select="f:getProperty('scoreCard.TotalMarks')" />
										</fo:block>
									</fo:table-cell>
									<!-- 2st cell of inner table -->
									<fo:table-cell 
										xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext" color="black">
											<xsl:value-of
												select="f:getProperty('correctquestionmarks.lable')" />
										</fo:block>
									</fo:table-cell>
									
									<fo:table-cell 
										xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext" color="black">
											<xsl:value-of
												select="f:getProperty('incorrectquestionmarks.lable')" />
										</fo:block>
									</fo:table-cell>
									
									<fo:table-cell 
										xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext" color="black">
											<xsl:value-of
												select="f:getProperty('questionByquestion.marksObtainedForItem')" />
											*
										</fo:block>
									</fo:table-cell>
									<!-- 3rd cell of inner table -->

									<xsl:choose>

										<xsl:when
											test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">


											<fo:table-cell number-columns-spanned="2"
												xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of
														select="f:getProperty('viewtestscore.MinimumPassing')" />
												</fo:block>
											</fo:table-cell>

										</xsl:when>
										<xsl:otherwise>
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="boldtext" color="black">
													<xsl:value-of
														select="f:getProperty('viewtestscore.MinimumPassing')" />
												</fo:block>
											</fo:table-cell>
										</xsl:otherwise>
									</xsl:choose>

								</fo:table-row>

								<!-- Sixth row -->
								<fo:table-row keep-together.within-column="always">

									<!-- 1st cell of inner table -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="normaltext">
											<xsl:value-of select="resultAnalysisViewModelObj/totalMarks" />
										</fo:block>
									</fo:table-cell>
									<!-- 2st cell of inner table -->




									<fo:table-cell 
										xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="normaltext">
											<xsl:value-of
												select="resultAnalysisViewModelObj/totalMarksObtainedForCorrect" />
										</fo:block>
									</fo:table-cell>
									
									<fo:table-cell 
										xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="normaltext">
											
											<xsl:if
												test="resultAnalysisViewModelObj/totalMarksObtainedForInCorrect = 0.0">
												<xsl:value-of select="f:getProperty('zero.marks')" />
											</xsl:if>
											<xsl:if
												test="resultAnalysisViewModelObj/totalMarksObtainedForInCorrect != 0.0">
												<xsl:value-of
													select="resultAnalysisViewModelObj/totalMarksObtainedForInCorrect" />
											</xsl:if>
											
										</fo:block>
									</fo:table-cell>
									
									<fo:table-cell 
										xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="normaltext">
											<xsl:value-of select="resultAnalysisViewModelObj/totalObtainedMarks" />
										</fo:block>
									</fo:table-cell>






									<!-- 3rd cell of inner table -->
									<xsl:choose>

										<xsl:when
											test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">

											<fo:table-cell number-columns-spanned="2"
												xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">

													<xsl:choose>
														<xsl:when
															test="(resultAnalysisViewModelObj/minimumPassingMarks != 'null')">
															<xsl:value-of
																select="resultAnalysisViewModelObj/minimumPassingMarks" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="f:getProperty('viewtestscore.NA')" />
														</xsl:otherwise>
													</xsl:choose>


												</fo:block>
											</fo:table-cell>
										</xsl:when>
										<xsl:otherwise>
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">

													<xsl:choose>
														<xsl:when
															test="(resultAnalysisViewModelObj/minimumPassingMarks != 'null')">
															<xsl:value-of
																select="resultAnalysisViewModelObj/minimumPassingMarks" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="f:getProperty('viewtestscore.NA')" />
														</xsl:otherwise>
													</xsl:choose>


												</fo:block>
											</fo:table-cell>
										</xsl:otherwise>
									</xsl:choose>

								</fo:table-row>


								<!-- <xsl:choose> <xsl:when test="resultAnalysisViewModelObj/paperContainCMPSItem 
									= 'true'"> <xsl:variable name="colspanBriefAnalysis" select="4" /> </xsl:when> 
									<xsl:otherwise> <xsl:variable name="colspanBriefAnalysis" select="3" /> </xsl:otherwise> 
									</xsl:choose> -->


								<!-- Seventh row (percentage) -->
								<fo:table-row keep-together.within-column="always"
									xsl:use-attribute-sets="myBorder">

									<!-- 1st cell of inner table -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext" color="black">
											<xsl:value-of select="f:getProperty('viewtestscore.Percentage')" />
										</fo:block>
									</fo:table-cell>
									<!-- 2st cell of inner table -->
									<fo:table-cell margin-left=".2cm">
										<xsl:attribute name="number-columns-spanned"><xsl:value-of
											select="'4'" /></xsl:attribute>

										<xsl:choose>
											<xsl:when
												test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">
												<xsl:attribute name="number-columns-spanned"><xsl:value-of
													select="'4'" /></xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="number-columns-spanned"><xsl:value-of
													select="'3'" /></xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>

										<fo:block>

											<xsl:choose>
												<xsl:when test="resultAnalysisViewModelObj/percentage != 0">
													<xsl:value-of
														select='format-number(resultAnalysisViewModelObj/percentage, "#.00")'></xsl:value-of>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select='resultAnalysisViewModelObj/percentage'></xsl:value-of>
												</xsl:otherwise>
											</xsl:choose>

											%

										</fo:block>
									</fo:table-cell>


								</fo:table-row>


								<!-- 8th row ( Result Status) -->
								<fo:table-row keep-together.within-column="always"
									xsl:use-attribute-sets="myBorder">

									<!-- 1st cell of inner table -->
									<fo:table-cell xsl:use-attribute-sets="myBorder"
										margin-left=".2cm">
										<fo:block>
											<xsl:value-of select="f:getProperty('viewtestscore.ResultStatus')" />
										</fo:block>
									</fo:table-cell>
									<!-- 2st cell of inner table -->
									<fo:table-cell margin-left=".2cm">
										<xsl:choose>
											<xsl:when
												test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">
												<xsl:attribute name="number-columns-spanned"><xsl:value-of
													select="'4'" /></xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="number-columns-spanned"><xsl:value-of
													select="'3'" /></xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										<fo:block>

											<xsl:choose>


												<xsl:when
													test="(number(resultAnalysisViewModelObj/totalObtainedMarks) >=  number(resultAnalysisViewModelObj/minimumPassingMarks))">
													<fo:inline color="green">PASS</fo:inline>
												</xsl:when>

												<xsl:when
													test="(number(resultAnalysisViewModelObj/totalObtainedMarks) &lt;   number(resultAnalysisViewModelObj/minimumPassingMarks))">
													<fo:inline color="red">FAIL</fo:inline>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="f:getProperty('viewtestscore.NA')" />
												</xsl:otherwise>


											</xsl:choose>

										</fo:block>
									</fo:table-cell>


								</fo:table-row>

								<!-- 9th row ( Result Status) -->
								<!-- Commented by Sonam 30 Jan 2015 as per suggested by ma'am -->
								<!-- <fo:table-row keep-together.within-column="always" xsl:use-attribute-sets="myBorder"> 
									1st cell of inner table <fo:table-cell> <fo:block xsl:use-attribute-sets="boldtext" 
									color="black"> <xsl:value-of select="f:getProperty('viewtestscore.Rank')" 
									/> </fo:block> </fo:table-cell> 2st cell of inner table <fo:table-cell> <fo:block 
									xsl:use-attribute-sets="boldtext" color="black"> <xsl:choose> <xsl:when test="resultAnalysisViewModelObj/totalObtainedMarks 
									> 0"> <xsl:value-of select="resultAnalysisViewModelObj/rank" /> out of <xsl:value-of 
									select="resultAnalysisViewModelObj/rankOutOf" /> </xsl:when> <xsl:otherwise> 
									<fo:block color="red">Candidate not eligible for rank. </fo:block> </xsl:otherwise> 
									</xsl:choose> </fo:block> </fo:table-cell> 3rd cell of inner table <fo:table-cell> 
									<fo:block> </fo:block> </fo:table-cell> </fo:table-row> -->


								<xsl:choose>

									<xsl:when
										test="resultAnalysisViewModelObj/paperContainCMPSItem = 'true'">

										<fo:table-row keep-together.within-column="always">

											<!-- 1st cell of inner table -->
											<fo:table-cell number-columns-spanned="5">
												<fo:block>
													<xsl:value-of select="f:getProperty('scoreCard.MarksObtained')" />
													=
													<xsl:value-of select="f:getProperty('marksobtained.equation')" />
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:when>

									<xsl:otherwise>
										<fo:table-row keep-together.within-column="always">

											<!-- 1st cell of inner table -->
											<fo:table-cell number-columns-spanned="4">
												<fo:block>
													<xsl:value-of select="f:getProperty('scoreCard.MarksObtained')" />
													=
													<xsl:value-of select="f:getProperty('marksobtained.equation')" />
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:otherwise>

								</xsl:choose>

							</fo:table-body>


						</fo:table>
						<!-- <fo:block> * Marks Obtained = Correct Question Marks - Incorrect 
							Question Marks </fo:block> -->

						<!-- End of brief analysis -->

						<!-- difficultylevelwise Analysis -->
						<fo:block space-before="1cm">


							<fo:table xsl:use-attribute-sets="myBorder">

								<fo:table-column column-number="1" />
								<fo:table-column column-number="2" />
								<fo:table-column column-number="3" />
								<fo:table-column column-number="4" />
								<fo:table-column column-number="5" />


								<fo:table-body>

									<!-- Heading of difficulty level analysis -->
									<fo:table-row keep-together.within-column="always"
										background-color="#F9B749">

										<!-- 1st cell of inner table -->
										<fo:table-cell number-columns-spanned="5">
											<fo:block xsl:use-attribute-sets="boldtext" color="black"
												keep-with-next="always" font-size="16pt" text-align="center">
												<xsl:value-of select="f:getProperty('difficultylevelwise.heading')" />
											</fo:block>
										</fo:table-cell>


									</fo:table-row>
									<!-- inner 1st row -->
									<fo:table-row keep-together.within-column="always"
										background-color="#F9F8F6">

										<!-- 1st cell of inner table -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext">
												<xsl:value-of
													select="f:getProperty('difficultylevelwise.DifficultyLevel')" />
											</fo:block>
										</fo:table-cell>

										<!-- 2nd cell of first row -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext">
												<xsl:value-of select="f:getProperty('difficultylevelwise.Total')" />
											</fo:block>
										</fo:table-cell>

										<!-- 3rd cell of first row -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext">
												<xsl:value-of select="f:getProperty('topicwise.Correct_Attempt')" />
											</fo:block>
										</fo:table-cell>
										
										<!-- 4th cell of inner table -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of select="f:getProperty('viewtestscore.evaluationPending')" />
											</fo:block>
										</fo:table-cell>

										<!-- 5th cell of inner table -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext">
												<xsl:value-of select="f:getProperty('difficultylevelwise.Accuracy')" />
											</fo:block>
										</fo:table-cell>

									</fo:table-row>

									<xsl:for-each
										select="./difficultyLevelViewModelPDF/listResultAnalysisViewModelPDF/resultAnalysisViewModelPDF">

										<!-- 2nd row -->
										<fo:table-row keep-together.within-column="always">

											<!-- 1st cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="difficultyLevel"></xsl:value-of>
												</fo:block>
											</fo:table-cell>

											<!-- 2nd cell of first row -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">

													<xsl:value-of select="totalItem"></xsl:value-of>

												</fo:block>
											</fo:table-cell>

											<!-- 3rd cell of first row -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="totalCorrectAnswer"></xsl:value-of>
													/
													<xsl:value-of select="totalAttemptedItem"></xsl:value-of>
												</fo:block>
											</fo:table-cell>

											<!-- 4th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block>
													<xsl:value-of select="totalEvaluationPendingItem"></xsl:value-of>
												</fo:block>
											</fo:table-cell>

											<!-- 5th cell of inner table -->
											<fo:table-cell xsl:use-attribute-sets="myBorder">
												<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:choose>
														<xsl:when test="percentage != 0">
															<xsl:value-of select='format-number(percentage, "#.00")'></xsl:value-of>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select='percentage'></xsl:value-of>
														</xsl:otherwise>
													</xsl:choose>
													%

												</fo:block>
											</fo:table-cell>



										</fo:table-row>
									</xsl:for-each>

								</fo:table-body>

							</fo:table>
						</fo:block>

						<!-- End of topic wise analysis -->

						<!-- Topic Wise Analysis -->
						<fo:block break-before="page">

							<!-- Topic Wise Analysis -->
							<fo:table space-before="0.5cm" xsl:use-attribute-sets="myBorder">

								<fo:table-column column-number="1" />
								<fo:table-column column-number="2" />
								<fo:table-column column-number="3" />
								<fo:table-column column-number="4" />
								<fo:table-column column-number="5" />


								<fo:table-body>

									<!-- Heading of Topic Wise analysis -->
									<fo:table-row keep-together.within-column="always"
										background-color="#F9B749">

										<!-- 1st cell of inner table -->
										<fo:table-cell number-columns-spanned="5">
											<fo:block xsl:use-attribute-sets="boldtext" color="black"
												font-size="16pt" text-align="center">
												<xsl:value-of select="f:getProperty('topicwise.heading')" />
											</fo:block>
										</fo:table-cell>


									</fo:table-row>

									<!-- heading row -->
									<fo:table-row keep-together.within-column="always">

										<!-- 1st cell of inner table -->
										<fo:table-cell number-columns-spanned="4">

											<fo:block xsl:use-attribute-sets="boldtext"
												text-align="center" color="black" font-size="14pt">
												<xsl:value-of select="f:getProperty('topicWiseSummary.label')" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>

									<!-- inner 1st row -->
									<fo:table-row keep-together.within-column="always"
										background-color="#F9F8F6">

										<!-- 1st cell of inner table -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext" color="black">
												<xsl:value-of select="f:getProperty('topicwise.Topics')" />
											</fo:block>
										</fo:table-cell>

										<!-- 2nd cell of first row -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext" color="black">
												<xsl:value-of select="f:getProperty('difficultylevelwise.Total')" />
											</fo:block>
										</fo:table-cell>

										<!-- 3rd cell of first row -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext" color="black">
												<xsl:value-of
													select="f:getProperty('difficultylevelwise.Correct_Attempt')" />
											</fo:block>
										</fo:table-cell>

										<!-- 4th cell of inner table -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext" color="black">
										<xsl:value-of select="f:getProperty('viewtestscore.evaluationPending')" />
											</fo:block>
										</fo:table-cell>


										<!-- 5th cell of inner table -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="boldtext" color="black">
												<xsl:value-of
													select="f:getProperty('difficultylevelwise.Accuracy')" />
											</fo:block>
										</fo:table-cell>

									</fo:table-row>


									<xsl:for-each select="./listofSectionviewModel/sectionviewModel">

										<fo:table-row background-color="#F9F8F6">
											<fo:table-cell number-columns-spanned="5">
												<xsl:if test="$isSectionreqd =  'Y'">
													<fo:block xsl:use-attribute-sets="normaltext"
														color="blue">
														<xsl:value-of select="f:getProperty('section.label')" />
														<xsl:value-of select="sectionName"></xsl:value-of>
													</fo:block>
												</xsl:if>
											</fo:table-cell>
										</fo:table-row>

										<xsl:for-each select="./listtopicwiseAnalysis/topicWiseAnalysis">
											<!-- remainig row -->
											<fo:table-row keep-together.within-column="always"
												space-before="0.5cm">

												<!-- 1st cell of inner table -->
												<fo:table-cell xsl:use-attribute-sets="myBorder">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:value-of select="itemBankName"></xsl:value-of>
													</fo:block>
												</fo:table-cell>

												<!-- 2nd cell of row -->
												<fo:table-cell xsl:use-attribute-sets="myBorder">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:value-of select="totalItem"></xsl:value-of>
													</fo:block>
												</fo:table-cell>

												<!-- 3rd cell of row -->
												<fo:table-cell xsl:use-attribute-sets="myBorder">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:value-of select="totalCorrectAnswer"></xsl:value-of>
														/
														<xsl:value-of select="totalAttemptedItem"></xsl:value-of>
													</fo:block>
												</fo:table-cell>

												<!-- 4th cell of row -->
												<fo:table-cell xsl:use-attribute-sets="myBorder">
													<fo:block xsl:use-attribute-sets="normaltext">
													<xsl:value-of select="totalEvaluationPendingItem"></xsl:value-of>
													</fo:block>
												</fo:table-cell>
												
												<!-- 5th cell of row -->
												<fo:table-cell xsl:use-attribute-sets="myBorder">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:choose>
															<xsl:when test="percentage != 0">
																<xsl:value-of select='format-number(percentage, "#.00")'></xsl:value-of>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select='percentage'></xsl:value-of>
															</xsl:otherwise>
														</xsl:choose>

														%
													</fo:block>
												</fo:table-cell>

											</fo:table-row>

										</xsl:for-each>
									</xsl:for-each>

								</fo:table-body>

							</fo:table>
							<fo:block xsl:use-attribute-sets="boldtext" color="black"
								space-before=".3cm">
								<xsl:value-of select="f:getProperty('analyticsobservation.label')" />
							</fo:block>

							<!-- table for Best Area and weak area -->
							<fo:table background-color="#F9F8F6"
								xsl:use-attribute-sets="myBorder">
								<fo:table-column column-number="1" column-width="20%" />
								<fo:table-column column-number="2" />

								<fo:table-body>
									<!-- 1st row -->
									<fo:table-row space-before="0.5cm"
										keep-together.within-column="always">

										<fo:table-cell>
											<fo:block xsl:use-attribute-sets="boldtext"
												font-size="16pt" color="green">
												<xsl:value-of select="f:getProperty('topicwise.BestArea')" />
											</fo:block>
										</fo:table-cell>

										<fo:table-cell>
											<fo:block xsl:use-attribute-sets="boldtext"
												font-size="16pt" color="green">
												<xsl:if test="normalize-space(bestArea)=''">
													--
												</xsl:if>
												<xsl:value-of select="bestArea"></xsl:value-of>

											</fo:block>
										</fo:table-cell>

									</fo:table-row>
									<!-- 2nd row -->
									<fo:table-row space-before="1cm"
										keep-together.within-column="always">

										<fo:table-cell>
											<fo:block xsl:use-attribute-sets="boldtext"
												font-size="16pt" color="red">
												<xsl:value-of select="f:getProperty('topicwise.WeakArea')" />
											</fo:block>
										</fo:table-cell>

										<fo:table-cell>
											<fo:block xsl:use-attribute-sets="boldtext"
												font-size="16pt" color="red">
												<xsl:if test="normalize-space(weakArea)=''">
													--
												</xsl:if>
												<xsl:value-of select="weakArea"></xsl:value-of>
											</fo:block>
										</fo:table-cell>

									</fo:table-row>

								</fo:table-body>
							</fo:table>

						</fo:block>

						<!-- End of topic wise analysis -->

						<!-- (Attempted Question Details )Topic Wise Analysis -->
						<fo:block xsl:use-attribute-sets="boldtext" text-align="center"
							keep-with-next="always" color="black" space-before="0.5cm"
							font-weight="bold" font-size="14">
							<xsl:value-of select="f:getProperty('topicWiseDetailedAnalysis.label')" />
						</fo:block>



						<fo:table space-before="0.5cm">

							<fo:table-column column-number="1" />
							<fo:table-body>


								<xsl:for-each select="./listofSectionviewModel/sectionviewModel">
									<!-- code to display section name -->
									<!-- code to display section name -->
									<fo:table-row space-before="0.5cm">

										<fo:table-cell>

											<fo:block text-align="center"
												xsl:use-attribute-sets="boldtext" keep-with-next="always"
												font-size="14pt" text-decoration="underline">

												<xsl:if test="$isSectionreqd =  'Y'">
													<xsl:value-of select="f:getProperty('section.label')" />
													<xsl:value-of select="sectionName"></xsl:value-of>
												</xsl:if>
											</fo:block>


										</fo:table-cell>
									</fo:table-row>


									<!-- end of code to display section name -->

									<xsl:for-each select="./listtopicwiseAnalysis/topicWiseAnalysis">
										<!-- inner 1st row -->
										<fo:table-row space-before="0.5cm">

											<fo:table-cell padding-top=".5cm">
												<fo:block color="#F9B749" keep-with-next="always"
													font-size="14pt" xsl:use-attribute-sets="boldtext">
													<xsl:value-of select="f:getProperty('topic.label')" />
													<xsl:value-of select="itemBankName"></xsl:value-of>
												</fo:block>
												<!-- Table of questions details alng with justification -->

												<xsl:for-each
													select="./listMultipleChoiceSingleCorrectViewModelPDF/multipleChoiceSingleCorrectVMPDF">

													<!-- if question type if of practical type -->
													<xsl:if test="itemType = 9">

														<fo:block>
															<fo:table space-before=".4cm" keep-with-next="always">

																<fo:table-column column-number="1"
																	column-width="80%" />
																<fo:table-column column-number="2" />


																<fo:table-body>
																	<fo:table-row keep-together.within-column="always"
																		background-color="#F9F8F6" xsl:use-attribute-sets="myBorder">

																		<fo:table-cell text-align="left">

																			<fo:block xsl:use-attribute-sets="boldtext">
																				<!-- Question -->

																				<xsl:value-of
																					select="f:getProperty('questionByquestion.question')" />
																				:
																				<xsl:value-of select="itemIndex"></xsl:value-of>
																				[
																				<xsl:value-of select="practicalSubjectName" />
																				-
																				<xsl:value-of select="practicalCategory" />
																				]

																				<!-- marks obtained -->
																				<xsl:choose>
																					<xsl:when test="isAttempted = 1">
																						<xsl:choose>
																							<xsl:when test="isCorrectAnswer = 1">
																								<fo:inline color="green">
																									<xsl:value-of
																										select="f:getProperty('viewtestscore.Correct')" />
																									[
																									<xsl:value-of select="marksObtained"></xsl:value-of>
																									&#160;
																									<xsl:value-of
																										select="f:getProperty('marksObtained.label')" />
																									]
																								</fo:inline>
																							</xsl:when>
																							<xsl:otherwise>
																								<fo:inline color="red">
																									<xsl:value-of
																										select="f:getProperty('questionByquestion.incorrect')" />
																									[
																									<xsl:value-of select="marksObtained"></xsl:value-of>
																									&#160;
																									<xsl:value-of
																										select="f:getProperty('questionByquestion.marksObtainedForItem')" />
																									]
																								</fo:inline>
																							</xsl:otherwise>
																						</xsl:choose>
																					</xsl:when>
																					<xsl:otherwise>
																						(
																						<xsl:value-of
																							select="f:getProperty('questionByquestion.notattempted')" />
																						)
																					</xsl:otherwise>
																				</xsl:choose>

																			</fo:block>
																		</fo:table-cell>
																		<fo:table-cell text-align="right">
																			<fo:block xsl:use-attribute-sets="boldtext"
																				font-size="12pt">
																				<!-- Question -->
																				<fo:block margin-right="2px">
																					<xsl:if test="locale = 'messages_ar.properties'">
																						<xsl:attribute name="text-align">left</xsl:attribute>
																					</xsl:if>
																					<xsl:value-of
																						select="f:getProperty('difficultyLevel.label')" />
																					<xsl:value-of select="difficultyLevel"></xsl:value-of>
																				</fo:block>
																			</fo:block>
																		</fo:table-cell>
																	</fo:table-row>

																	<!-- inner 1st row -->
																	<fo:table-row keep-with-next="always">
																		<!-- 1st cell of inner table -->
																		<fo:table-cell number-columns-spanned="2"
																			xsl:use-attribute-sets="myBorder">
																			<fo:block margin-left=".2cm">
																				<!-- itemImage/Item Text -->
																				<fo:block linefeed-treatment="preserve"
																					white-space-treatment="preserve"
																					white-space-collapse="false"
																					xsl:use-attribute-sets="normaltext">
																					<xsl:value-of select="itemText"></xsl:value-of>
																				</fo:block>
																			</fo:block>
																		</fo:table-cell>
																	</fo:table-row>
																</fo:table-body>
															</fo:table>
														</fo:block>
													</xsl:if>
													<!-- End of Question Type Practical -->


													<!-- if Question Type is of Matching pair -->
													<xsl:if test="itemType = 4">
														<fo:block space-before=".4cm" keep-with-next="always">
															<fo:table>
																<fo:table-column column-number="1"
																	column-width="4%" />
																<fo:table-column column-number="2" />
																<fo:table-column column-number="3" />
																<fo:table-column column-number="4" />
																<fo:table-column column-number="5"
																	column-width="8%" />
																<fo:table-column column-number="6"
																	column-width="13%" />

																<fo:table-body>
																	<fo:table-row keep-with-next="always">
																		<fo:table-cell number-columns-spanned="6">
																			<fo:block>
																				<fo:table>

																					<fo:table-column column-number="1" />
																					<fo:table-column column-number="2" />


																					<fo:table-body>
																						<fo:table-row
																							keep-together.within-column="always"
																							background-color="#F9F8F6"
																							xsl:use-attribute-sets="myBorder">

																							<fo:table-cell text-align="left">

																								<fo:block xsl:use-attribute-sets="boldtext">
																									<!-- Question -->

																									<xsl:value-of
																										select="f:getProperty('questionByquestion.question')" />
																									:
																									<xsl:value-of select="itemIndex"></xsl:value-of>

																								</fo:block>

																							</fo:table-cell>


																							<fo:table-cell text-align="right">



																								<fo:block xsl:use-attribute-sets="boldtext"
																									font-size="12pt">

																									<!-- Question -->
																									<fo:block margin-right="2px">
																										<xsl:if test="locale = 'messages_ar.properties'">
																											<xsl:attribute name="text-align">left</xsl:attribute>
																										</xsl:if>
																										<xsl:value-of
																											select="f:getProperty('difficultyLevel.label')" />
																										<xsl:value-of select="difficultyLevel"></xsl:value-of>
																									</fo:block>

																								</fo:block>
																							</fo:table-cell>



																						</fo:table-row>
																					</fo:table-body>
																				</fo:table>

																			</fo:block>
																		</fo:table-cell>
																	</fo:table-row>



																	<!-- inner 1st row -->

																	<fo:table-row keep-with-next="always">

																		<!-- 1st cell of inner table -->
																		<fo:table-cell number-columns-spanned="6"
																			xsl:use-attribute-sets="myBorder">
																			<fo:block margin-left=".2cm">


																				<!-- itemImage/Item Text -->

																				<fo:block linefeed-treatment="preserve"
																					white-space-treatment="preserve"
																					white-space-collapse="false"
																					xsl:use-attribute-sets="normaltext">
																					<xsl:value-of select="itemText"></xsl:value-of>

																				</fo:block>

																				<xsl:if
																					test="not(itemImageDifficultyLevel = 'null' or  normalize-space(itemImageDifficultyLevel)='')">
																					<fo:block margin-left="2px" margin-right="2px">
																						<xsl:variable name="optionImageSrc"
																							select="itemImageDifficultyLevel" />
																						<fo:external-graphic src="url({$optionImageSrc})"
																							inline-progression-dimension.maximum="100%"
																							content-height="scale-down-to-fit" content-width="scale-down-to-fit">
																						</fo:external-graphic>
																					</fo:block>
																				</xsl:if>


																			</fo:block>
																		</fo:table-cell>
																	</fo:table-row>
																	<!-- Matching pair subitem details -->
																	<fo:table-row keep-with-next="always">
																		<!-- sR NO. -->
																		<fo:table-cell margin-left=".2cm"
																			xsl:use-attribute-sets="myBorder">
																			<fo:block>
																				<xsl:value-of select="f:getProperty('number.label')" />
																			</fo:block>
																		</fo:table-cell>

																		<!-- sub uestion -->
																		<fo:table-cell margin-left=".2cm"
																			xsl:use-attribute-sets="boldtext">
																			<fo:block>
																				<xsl:value-of
																					select="f:getProperty('questionByquestion.subItemText')" />
																			</fo:block>
																		</fo:table-cell>
																		<!-- Options -->
																		<fo:table-cell margin-left=".2cm"
																			xsl:use-attribute-sets="boldtext">
																			<fo:block>
																				<xsl:value-of select="f:getProperty('optionText.label')" />
																			</fo:block>
																		</fo:table-cell>
																		<!-- Candidate Answer -->
																		<fo:table-cell margin-left=".2cm"
																			xsl:use-attribute-sets="boldtext">
																			<fo:block>
																				<xsl:value-of
																					select="f:getProperty('questionByquestion.candidateanswer')" />
																			</fo:block>
																		</fo:table-cell>
																		<!-- Selected -->
																		<fo:table-cell margin-left=".2cm"
																			xsl:use-attribute-sets="boldtext">
																			<fo:block>
																				<xsl:value-of select="f:getProperty('selected.label')" />
																			</fo:block>
																		</fo:table-cell>
																		<!-- Marks Obtained -->
																		<fo:table-cell margin-left=".2cm"
																			xsl:use-attribute-sets="boldtext" font-size="10pt">
																			<fo:block>
																				<xsl:value-of
																					select="f:getProperty('scoreCard.MarksObtained')" />
																			</fo:block>
																		</fo:table-cell>
																	</fo:table-row>
																	<xsl:for-each select="./subItemList/subitem">
																		<fo:table-row
																			keep-together.within-column="always">
																			<!-- sR NO. -->
																			<fo:table-cell margin-left=".2cm"
																				xsl:use-attribute-sets="myBorder">
																				<fo:block>
																					<xsl:value-of select="position()" />
																				</fo:block>
																			</fo:table-cell>
																			<!-- sub uestion -->
																			<fo:table-cell xsl:use-attribute-sets="myBorder">
																				<fo:block linefeed-treatment="preserve"
																					white-space-treatment="preserve"
																					white-space-collapse="false" margin-left=".2cm"
																					xsl:use-attribute-sets="normaltext">
																					<!-- itemImage/Item Text -->
																					<xsl:value-of select="itemText"></xsl:value-of>
																					<xsl:if
																						test="not(itemImageDifficultyLevel = 'null' or  normalize-space(itemImageDifficultyLevel)='')">
																						<fo:block margin-left="2px" margin-right="2px">
																							<xsl:variable name="optionImageSrc"
																								select="itemImageDifficultyLevel" />
																							<fo:external-graphic src="url({$optionImageSrc})"
																								inline-progression-dimension.maximum="100%"
																								content-height="scale-down-to-fit"
																								content-width="scale-down-to-fit">
																							</fo:external-graphic>
																						</fo:block>
																					</xsl:if>


																				</fo:block>
																			</fo:table-cell>
																			<!-- Options -->
																			<fo:table-cell xsl:use-attribute-sets="myBorder"
																				margin-left=".2cm">
																				<xsl:for-each select="./optionListMCSC/optionList">
																					<fo:block margin-left="2px" margin-right="2px"
																						linefeed-treatment="preserve"
																						white-space-treatment="preserve"
																						white-space-collapse="false"
																						xsl:use-attribute-sets="normaltext">
																						<xsl:value-of select="optionText"></xsl:value-of>
																						<xsl:if
																							test="optionImage != 'null' and  normalize-space(optionImage)!=''">
																							<fo:block>

																								<xsl:variable name="optionImageSrc"
																									select="optionImage" />
																								<fo:external-graphic src="url({$optionImageSrc})"
																									inline-progression-dimension.maximum="100%"
																									content-height="scale-down-to-fit"
																									content-width="scale-down-to-fit">
																								</fo:external-graphic>
																							</fo:block>
																						</xsl:if>



																					</fo:block>
																				</xsl:for-each>
																			</fo:table-cell>
																			<!-- Candidate Answer -->
																			<fo:table-cell xsl:use-attribute-sets="myBorder">
																				<fo:block margin-left=".2cm">

																					<xsl:value-of select="candidateAnswer" />

																				</fo:block>
																			</fo:table-cell>
																			<!-- Selected -->
																			<fo:table-cell xsl:use-attribute-sets="myBorder">
																				<fo:block>
																					<xsl:choose>
																						<xsl:when test="isAttempted = '1'">
																							<xsl:choose>
																								<xsl:when test="isCorrectAnswer = 1">
																									<fo:block text-align="center">

																										<fo:external-graphic
																											src="url('{/PDFViewModelData/righIconpath}')"
																											content-width=".4cm">
																										</fo:external-graphic>
																									</fo:block>
																								</xsl:when>
																								<xsl:otherwise>
																									<fo:block text-align="center">

																										<fo:external-graphic
																											src="url('{/PDFViewModelData/wrongIconpath}')"
																											content-width=".4cm">
																										</fo:external-graphic>
																									</fo:block>
																								</xsl:otherwise>
																							</xsl:choose>

																						</xsl:when>


																						<xsl:otherwise>
																							<fo:block text-align="center"></fo:block>
																						</xsl:otherwise>
																					</xsl:choose>

																				</fo:block>
																			</fo:table-cell>

																			<!-- Marks Obtained -->
																			<fo:table-cell xsl:use-attribute-sets="myBorder">
																				<fo:block margin-left=".2cm">

																					<xsl:value-of select="marksObtained" />

																				</fo:block>
																			</fo:table-cell>
																		</fo:table-row>
																	</xsl:for-each>

																	<!-- ends Matching Pair subitems -->


																</fo:table-body>
															</fo:table>





														</fo:block>
													</xsl:if>

													<!-- End of Question Type is of Matching pair -->

													<!-- for item type single correct,multiple correcct,picture 
														identification and comprehension -->
													<xsl:if
														test="itemType = 0 or itemType = 1 or itemType = 2 or itemType = 3 or itemType = 6  or itemType = 8 or itemType = 10">
														<fo:block space-before=".4cm">
															<fo:table>

																<fo:table-column column-number="1" />


																<fo:table-body>


																	<fo:table-row keep-together.within-column="1">

																		<fo:table-cell>
																			<fo:table>

																				<fo:table-column column-number="1"
																					column-width="4%" />
																				<fo:table-column column-number="2"
																					column-width="80%" />
																				<fo:table-column column-number="3"
																					column-width="8%" />
																				<fo:table-column column-number="4" />

																				<fo:table-body>

																					<fo:table-row>
																						<fo:table-cell
																							number-columns-spanned="4">
																							<fo:block>
																								<fo:table xsl:use-attribute-sets="myBorder">

																									<fo:table-column column-number="1" />
																									<fo:table-column column-number="2" />


																									<fo:table-body>
																										<fo:table-row
																											keep-together.within-column="always"
																											background-color="#F9F8F6">

																											<fo:table-cell text-align="left">

																												<fo:block xsl:use-attribute-sets="boldtext">
																													<!-- Question -->
																													<xsl:value-of
																														select="f:getProperty('questionByquestion.question')" />
																													:
																													<xsl:value-of select="itemIndex"></xsl:value-of>

																													<!-- condition to display whether question is 
																														attempted or not and whther it si correct or InCorrect -->

																													<xsl:choose>
																														<xsl:when test="isAttempted = '1'">
																															(
																															<xsl:value-of
																																select="f:getProperty('viewtestscore.Attempted')" />
																															)

																															<xsl:choose>
																																<xsl:when test="isCorrectAnswer = 1">
																																	<fo:inline color="green">
																																		<xsl:value-of
																																			select="f:getProperty('viewtestscore.Correct')" />
																																		[
																																		<xsl:value-of select="marksObtained"></xsl:value-of>
																																		&#160;
																																		<xsl:value-of
																																			select="f:getProperty('marksObtained.label')" />
																																		]
																																	</fo:inline>
																																</xsl:when>
																																<xsl:otherwise>
																																	<xsl:choose>
																																		<xsl:when test="itemType = 10">
																																			<xsl:value-of select="f:getProperty('viewtestscore.evaluationPending')" />
																																		</xsl:when>
																																		<xsl:otherwise>
																																			<fo:inline color="red">
																																				<xsl:value-of
																																					select="f:getProperty('questionByquestion.incorrect')" />
																																				[
																																				<xsl:value-of select="marksObtained"></xsl:value-of>
																																				&#160;
																																				<xsl:value-of select="f:getProperty('questionByquestion.marksObtainedForItem')" />
																																				]
																																			</fo:inline>
																																		</xsl:otherwise>
																																	</xsl:choose>
																																</xsl:otherwise>
																															</xsl:choose>
																														</xsl:when>
																														<xsl:otherwise>

																															<xsl:if
																																test="count(./subItemList/subitem) = 0">
																																(
																																<xsl:value-of
																																	select="f:getProperty('questionByquestion.notattempted')" />
																																)
																															</xsl:if>
																														</xsl:otherwise>

																													</xsl:choose>

																												</fo:block>





																											</fo:table-cell>

																											<fo:table-cell text-align="right">



																												<fo:block xsl:use-attribute-sets="boldtext"
																													font-size="12pt">

																													<!-- Question -->
																													<fo:block margin-right="2px">
																														<xsl:if
																															test="locale = 'messages_ar.properties'">
																															<xsl:attribute name="text-align">left</xsl:attribute>
																														</xsl:if>
																														<xsl:value-of
																															select="f:getProperty('difficultyLevel.label')" />
																														<xsl:value-of select="difficultyLevel"></xsl:value-of>
																													</fo:block>

																												</fo:block>
																											</fo:table-cell>



																										</fo:table-row>
																									</fo:table-body>
																								</fo:table>

																							</fo:block>
																						</fo:table-cell>
																					</fo:table-row>



																					<!-- inner 1st row -->


																					<!-- inner 2nd row -->
																					<fo:table-row>

																						<!-- 1st cell of inner table -->
																						<fo:table-cell
																							number-columns-spanned="4"
																							xsl:use-attribute-sets="myBorder">
																							<fo:block margin-left=".2cm"
																								xsl:use-attribute-sets="normaltext">

																								<xsl:if test="multiMediatype != 11">

																									<xsl:if test="itemType = 6">
																										<fo:block>
																											<xsl:value-of
																												select="f:getProperty('analysisbooklet.simulationQuestionLabel')" />

																										</fo:block>
																										<fo:block>
																											<xsl:value-of select="itemText"></xsl:value-of>
																										</fo:block>
																									</xsl:if>


																									<xsl:choose>
																										<xsl:when test="multiMediatype = 0">

																											<fo:inline>
																												<xsl:value-of
																													select="f:getProperty('analysisbooklet.multimediatypeAudio')" />
																												(
																												<xsl:value-of select="itemText"></xsl:value-of>
																												)
																											</fo:inline>


																										</xsl:when>
																										<xsl:when test="multiMediatype = 1">
																											<fo:block>
																												<xsl:value-of
																													select="f:getProperty('analysisbooklet.multimediatypeVideo')" />
																												(
																												<xsl:value-of select="itemText"></xsl:value-of>
																												)
																											</fo:block>
																										</xsl:when>

																									</xsl:choose>

																								</xsl:if>

																								<!-- itemImage/Item Text -->
																								<xsl:if test="multiMediatype = 11">
																									<fo:block linefeed-treatment="preserve"
																										white-space-treatment="preserve"
																										white-space-collapse="false"
																										xsl:use-attribute-sets="normaltext">

																										<xsl:value-of select="itemText"></xsl:value-of>
																									</fo:block>
																								</xsl:if>

																								<!-- code to display itemimage list in case of picture 
																									identification -->
																								<xsl:if test="itemType = 2">
																									<xsl:for-each select="./itemImageListPI/itemImagePI">
																										<fo:block margin-left="2px"
																											margin-right="2px">
																											<xsl:variable name="itemImagePISrc"
																												select="itemImage" />
																											<fo:external-graphic src="url({$itemImagePISrc})"
																												inline-progression-dimension.maximum="100%"
																												content-height="scale-down-to-fit"
																												content-width="scale-down-to-fit">
																											</fo:external-graphic>
																										</fo:block>

																									</xsl:for-each>

																								</xsl:if>
																								<xsl:if
																									test="not(itemImageDifficultyLevel = 'null' or  normalize-space(itemImageDifficultyLevel)='')">
																									<fo:block margin-left="2px"
																										margin-right="2px">
																										<xsl:variable name="optionImageSrc"
																											select="itemImageDifficultyLevel" />
																										<fo:external-graphic src="url({$optionImageSrc})"
																											inline-progression-dimension.maximum="100%"
																											content-height="scale-down-to-fit"
																											content-width="scale-down-to-fit">
																										</fo:external-graphic>
																									</fo:block>
																								</xsl:if>


																							</fo:block>
																							<!-- If Comprehension than subitem details -->

																							<xsl:for-each select="./subItemList/subitem">

																								<fo:block space-before=".4cm">
																									<fo:table>

																										<fo:table-column
																											column-number="1" />


																										<fo:table-body>


																											<fo:table-row
																												keep-together.within-column="1">

																												<fo:table-cell>
																													<fo:table xsl:use-attribute-sets="myBorder">

																														<fo:table-column
																															column-number="1" column-width="4%" />
																														<fo:table-column
																															column-number="2" column-width="80%" />
																														<fo:table-column
																															column-number="3" column-width="8%" />
																														<fo:table-column
																															column-number="4" />

																														<fo:table-body>

																															<fo:table-row>
																																<fo:table-cell
																																	number-columns-spanned="4">
																																	<fo:block>
																																		<fo:table
																																			xsl:use-attribute-sets="myBorder">

																																			<fo:table-column
																																				column-number="1" />
																																			<fo:table-column
																																				column-number="2" />


																																			<fo:table-body>
																																				<fo:table-row
																																					keep-together.within-column="always"
																																					background-color="#F9F8F6">

																																					<fo:table-cell>

																																						<fo:block
																																							xsl:use-attribute-sets="boldtext">
																																							<!-- Question -->
																																							<xsl:value-of
																																								select="f:getProperty('viewtestscore.SubQues')" />
																																							:
																																							<xsl:value-of
																																								select="itemIndex"></xsl:value-of>

																																							<!-- condition to display whether 
																																								question is attempted or not and whther it si correct or InCorrect -->

																																							<xsl:choose>
																																								<xsl:when test="isAttempted = '1'">
																																									(
																																									<xsl:value-of
																																										select="f:getProperty('viewtestscore.Attempted')" />
																																									)

																																									<xsl:choose>
																																										<xsl:when
																																											test="isCorrectAnswer = 1">
																																											<fo:inline color="green">
																																												<xsl:value-of
																																													select="f:getProperty('viewtestscore.Correct')" />
																																												[
																																												<xsl:value-of
																																													select="marksObtained"></xsl:value-of>
																																												&#160;
																																												<xsl:value-of
																																													select="f:getProperty('marksObtained.label')" />
																																												]
																																											</fo:inline>
																																										</xsl:when>
																																										<xsl:otherwise>
																																											<fo:inline color="red">
																																												<xsl:value-of
																																													select="f:getProperty('questionByquestion.incorrect')" />
																																												[
																																												<xsl:value-of
																																													select="marksObtained"></xsl:value-of>
																																												&#160;
																																												<xsl:value-of
																																													select="f:getProperty('questionByquestion.marksObtainedForItem')" />
																																												]
																																											</fo:inline>
																																										</xsl:otherwise>
																																									</xsl:choose>
																																								</xsl:when>
																																								<xsl:otherwise>
																																									(
																																									<xsl:value-of
																																										select="f:getProperty('questionByquestion.notattempted')" />
																																									)
																																								</xsl:otherwise>
																																							</xsl:choose>
																																						</fo:block>

																																					</fo:table-cell>

																																					<fo:table-cell
																																						text-align="right">




																																					</fo:table-cell>



																																				</fo:table-row>
																																			</fo:table-body>
																																		</fo:table>

																																	</fo:block>
																																</fo:table-cell>
																															</fo:table-row>



																															<!-- inner 1st row -->


																															<!-- inner 2nd row -->
																															<fo:table-row>

																																<!-- 1st cell of inner table -->
																																<fo:table-cell
																																	number-columns-spanned="4"
																																	xsl:use-attribute-sets="myBorder">
																																	<fo:block linefeed-treatment="preserve"
																																		white-space-treatment="preserve"
																																		white-space-collapse="false"
																																		margin-left=".2cm"
																																		xsl:use-attribute-sets="normaltext">
																																		<!-- itemImage/Item Text -->
																																		<xsl:value-of select="itemText"></xsl:value-of>
																																		<xsl:if
																																			test="not(itemImageDifficultyLevel = 'null' or  normalize-space(itemImageDifficultyLevel)='')">
																																			<fo:block margin-left="2px"
																																				margin-right="2px">
																																				<xsl:variable name="optionImageSrc"
																																					select="itemImageDifficultyLevel" />
																																				<fo:external-graphic
																																					src="url({$optionImageSrc})"
																																					inline-progression-dimension.maximum="100%"
																																					content-height="scale-down-to-fit"
																																					content-width="scale-down-to-fit">
																																				</fo:external-graphic>
																																			</fo:block>
																																		</xsl:if>


																																	</fo:block>
																																</fo:table-cell>

																															</fo:table-row>

																															<fo:table-row
																																keep-with-next="always">

																																<!-- 1st cell of inner table -->
																																<fo:table-cell
																																	number-columns-spanned="4">
																																	<fo:block
																																		xsl:use-attribute-sets="boldtext">
																																		<xsl:value-of
																																			select="f:getProperty('option.label')" />
																																	</fo:block>
																																</fo:table-cell>


																															</fo:table-row>



																															<!-- inner 3rd row -->
																															<fo:table-row
																																keep-with-next="always">
																																<fo:table-cell
																																	xsl:use-attribute-sets="myBorder">
																																	<fo:block
																																		xsl:use-attribute-sets="boldtext">
																																		<xsl:value-of
																																			select="f:getProperty('number.label')" />

																																	</fo:block>
																																</fo:table-cell>


																																<!-- 2nd cell of inner table -->
																																<fo:table-cell
																																	xsl:use-attribute-sets="myBorder">
																																	<fo:block
																																		xsl:use-attribute-sets="boldtext">
																																		<xsl:value-of
																																			select="f:getProperty('optionText.label')" />
																																	</fo:block>
																																</fo:table-cell>

																																<!-- 3rd cell of inner table -->
																																<fo:table-cell
																																	xsl:use-attribute-sets="myBorder">
																																	<fo:block
																																		xsl:use-attribute-sets="boldtext">
																																		<xsl:value-of
																																			select="f:getProperty('correct.label')" />
																																	</fo:block>
																																</fo:table-cell>

																																<!-- 4th cell of inner table -->
																																<fo:table-cell
																																	xsl:use-attribute-sets="myBorder">
																																	<fo:block
																																		xsl:use-attribute-sets="boldtext">
																																		<xsl:value-of
																																			select="f:getProperty('selected.label')" />
																																	</fo:block>
																																</fo:table-cell>
																															</fo:table-row>

																															<!-- variable to keep track of where option 
																																justifiaction is to displayed -->
																															<xsl:variable name="flagforselectedOption"
																																select="'false'" />
																															<!-- loop of option list -->
																															<xsl:for-each
																																select="./optionListMCSC/optionList">
																																<xsl:variable name="flagforselectedOption"
																																	select="'false'" />

																																<fo:table-row>
																																	<fo:table-cell
																																		xsl:use-attribute-sets="myBorder">
																																		<fo:block font-weight="bold"
																																			margin-left="2px">

																																			<xsl:value-of select="optionIndex"></xsl:value-of>
																																		</fo:block>
																																	</fo:table-cell>


																																	<!-- option text/image cell -->
																																	<fo:table-cell
																																		xsl:use-attribute-sets="myBorder">

																																		<!-- Options -->
																																		<fo:block margin-left="2px"
																																			margin-right="2px"
																																			linefeed-treatment="preserve"
																																			white-space-treatment="preserve"
																																			white-space-collapse="false"
																																			xsl:use-attribute-sets="normaltext">
																																			<xsl:value-of select="optionText"></xsl:value-of>
																																			<xsl:if
																																				test="optionImage != 'null' and  normalize-space(optionImage)!=''">
																																				<fo:block>

																																					<xsl:variable name="optionImageSrc"
																																						select="optionImage" />
																																					<fo:external-graphic
																																						src="url({$optionImageSrc})"
																																						inline-progression-dimension.maximum="100%"
																																						content-height="scale-down-to-fit"
																																						content-width="scale-down-to-fit">
																																					</fo:external-graphic>
																																				</fo:block>
																																			</xsl:if>



																																		</fo:block>
																																	</fo:table-cell>

																																	<!-- 3rd cell of inner table -->
																																	<fo:table-cell
																																		xsl:use-attribute-sets="myBorder"
																																		display-align="center">
																																		<fo:block
																																			xsl:use-attribute-sets="boldtext">
																																			<xsl:if test="correct = 1">
																																				<fo:block text-align="center">
																																					<fo:external-graphic
																																						src="url('{/PDFViewModelData/righIconpath}')"
																																						content-width=".4cm">
																																					</fo:external-graphic>
																																				</fo:block>
																																			</xsl:if>
																																		</fo:block>
																																	</fo:table-cell>

																																	<!-- 3rd cell of inner table -->
																																	<fo:table-cell
																																		xsl:use-attribute-sets="myBorder"
																																		display-align="center">
																																		<fo:block font-weight="bold">
																																			<xsl:if test="userselectedTrue = 1">

																																				<xsl:choose>
																																					<xsl:when test="correct = 1">
																																						<fo:block text-align="center">

																																							<fo:external-graphic
																																								src="url('{/PDFViewModelData/righIconpath}')"
																																								content-width=".4cm">
																																							</fo:external-graphic>
																																						</fo:block>
																																					</xsl:when>
																																					<xsl:otherwise>
																																						<fo:block text-align="center">

																																							<fo:external-graphic
																																								src="url('{/PDFViewModelData/wrongIconpath}')"
																																								content-width=".4cm">
																																							</fo:external-graphic>
																																						</fo:block>
																																					</xsl:otherwise>
																																				</xsl:choose>

																																			</xsl:if>
																																		</fo:block>
																																	</fo:table-cell>
																																</fo:table-row>

																															</xsl:for-each>




																														</fo:table-body>
																													</fo:table>
																													<!-- condition to check whther selected user 
																														option is correct or not -->
																													<xsl:for-each select="./optionListMCSC/optionList">
																														<!-- if condition to display table of answer 
																															explanation only if there is justification image or text -->

																														<xsl:if
																															test="not((normalize-space(justification)='' or justification ='null') and (normalize-space(justificationImage) = '' or justificationImage = 'null'))">



																															<xsl:if
																																test="correct=1 or userselectedTrue = 1">

																																<fo:table space-before="0.5cm"
																																	keep-together.within-column="always">
																																	<fo:table-column
																																		column-number="1" />

																																	<fo:table-body>

																																		<!-- inner 1st row -->
																																		<fo:table-row
																																			keep-together.within-column="always">

																																			<!-- 1st cell of inner table -->
																																			<fo:table-cell
																																				xsl:use-attribute-sets="myBorder">
																																				<fo:block
																																					xsl:use-attribute-sets="boldtext"
																																					color="black">
																																					<xsl:value-of
																																						select="f:getProperty('answerExplanation.label')" />
																																				</fo:block>
																																			</fo:table-cell>


																																		</fo:table-row>

																																		<fo:table-row>

																																			<!-- 1st cell of inner table -->
																																			<fo:table-cell
																																				xsl:use-attribute-sets="myBorder">
																																				<fo:block
																																					xsl:use-attribute-sets="boldtext"
																																					color="black">
																																					<xsl:value-of
																																						select="f:getProperty('optionLbl.Justification')" />
																																					&#160;
																																					<xsl:value-of select="optionIndex"></xsl:value-of>

																																				</fo:block>
																																			</fo:table-cell>


																																		</fo:table-row>

																																		<!-- inner 2nd row -->
																																		<fo:table-row>

																																			<!-- 1st cell of inner table -->
																																			<fo:table-cell
																																				xsl:use-attribute-sets="myBorder">
																																				<fo:block
																																					xsl:use-attribute-sets="normaltext"
																																					linefeed-treatment="preserve"
																																					white-space-treatment="preserve"
																																					white-space-collapse="false">

																																					<xsl:if
																																						test="not(justification = 'null')">
																																						<xsl:value-of select="justification"></xsl:value-of>
																																					</xsl:if>
																																					<xsl:if
																																						test="not(justificationImage = 'null')">
																																						<fo:block margin-left=".02cm"
																																							margin-right=".02cm">
																																							<xsl:variable name="optionImageSrc"
																																								select="justificationImage" />
																																							<fo:external-graphic
																																								src="url({$optionImageSrc})"
																																								inline-progression-dimension.maximum="100%"
																																								content-height="scale-down-to-fit"
																																								content-width="scale-down-to-fit">
																																							</fo:external-graphic>
																																						</fo:block>
																																					</xsl:if>

																																				</fo:block>
																																			</fo:table-cell>


																																		</fo:table-row>


																																	</fo:table-body>
																																</fo:table>

																															</xsl:if>


																														</xsl:if>

																													</xsl:for-each>


																												</fo:table-cell>
																											</fo:table-row>

																										</fo:table-body>
																									</fo:table>

																								</fo:block>


																							</xsl:for-each>
																							<!-- ends subitems -->
																						</fo:table-cell>

																					</fo:table-row>

																					<xsl:if test="count(./subItemList/subitem) = 0">
																						<!-- condition not to display option text in case of 
																							simulation based question where there is no options -->
																						<xsl:if test="count(./optionListMCSC/optionList) != 0">
																							<fo:table-row keep-with-next="always">

																								<!-- 1st cell of inner table -->
																								<fo:table-cell
																									number-columns-spanned="4">
																									<fo:block xsl:use-attribute-sets="boldtext">
																										<xsl:value-of select="f:getProperty('option.label')" />
																									</fo:block>
																								</fo:table-cell>


																							</fo:table-row>




																							<!-- inner 3rd row -->
																							<fo:table-row keep-with-next="always">
																								<fo:table-cell
																									xsl:use-attribute-sets="myBorder">
																									<fo:block xsl:use-attribute-sets="boldtext">
																										<xsl:value-of select="f:getProperty('number.label')" />

																									</fo:block>
																								</fo:table-cell>


																								<!-- 2nd cell of inner table -->
																								<fo:table-cell
																									xsl:use-attribute-sets="myBorder">
																									<fo:block xsl:use-attribute-sets="boldtext">
																										<xsl:value-of
																											select="f:getProperty('optionText.label')" />
																									</fo:block>
																								</fo:table-cell>

																								<!-- 3rd cell of inner table -->
																								<fo:table-cell
																									xsl:use-attribute-sets="myBorder">
																									<fo:block xsl:use-attribute-sets="boldtext">
																										<xsl:value-of select="f:getProperty('correct.label')" />
																									</fo:block>
																								</fo:table-cell>

																								<!-- 4th cell of inner table -->
																								<fo:table-cell
																									xsl:use-attribute-sets="myBorder">
																									<fo:block xsl:use-attribute-sets="boldtext">
																										<xsl:value-of
																											select="f:getProperty('selected.label')" />
																									</fo:block>
																								</fo:table-cell>
																							</fo:table-row>

																							<!-- variable to keep track of where option justifiaction 
																								is to displayed -->
																							<xsl:variable name="flagforselectedOption"
																								select="'false'" />
																							<!-- loop of option list -->
																							<xsl:for-each select="./optionListMCSC/optionList">
																								<xsl:variable name="flagforselectedOption"
																									select="'false'" />

																								<fo:table-row>
																									<fo:table-cell
																										xsl:use-attribute-sets="myBorder">
																										<fo:block font-weight="bold"
																											margin-left="2px">

																											<xsl:value-of select="optionIndex"></xsl:value-of>
																										</fo:block>
																									</fo:table-cell>


																									<!-- option text/image cell -->
																									<fo:table-cell
																										xsl:use-attribute-sets="myBorder">

																										<!-- Options -->
																										<fo:block margin-left="2px"
																											margin-right="2px" linefeed-treatment="preserve"
																											white-space-treatment="preserve"
																											white-space-collapse="false"
																											xsl:use-attribute-sets="normaltext">
																											<xsl:value-of select="optionText"></xsl:value-of>
																											<xsl:if
																												test="optionImage != 'null' and  normalize-space(optionImage)!=''">
																												<fo:block>

																													<xsl:variable name="optionImageSrc"
																														select="optionImage" />
																													<fo:external-graphic
																														src="url({$optionImageSrc})"
																														inline-progression-dimension.maximum="100%"
																														content-height="scale-down-to-fit"
																														content-width="scale-down-to-fit">
																													</fo:external-graphic>
																												</fo:block>
																											</xsl:if>



																										</fo:block>
																									</fo:table-cell>

																									<!-- 3rd cell of inner table -->
																									<fo:table-cell
																										xsl:use-attribute-sets="myBorder"
																										display-align="center">
																										<fo:block xsl:use-attribute-sets="boldtext">
																											<xsl:if test="correct = 1">
																												<fo:block text-align="center">
																													<fo:external-graphic
																														src="url('{/PDFViewModelData/righIconpath}')"
																														content-width=".4cm">
																													</fo:external-graphic>
																												</fo:block>
																											</xsl:if>
																										</fo:block>
																									</fo:table-cell>

																									<!-- 3rd cell of inner table -->
																									<fo:table-cell
																										xsl:use-attribute-sets="myBorder"
																										display-align="center">
																										<fo:block font-weight="bold">
																											<xsl:if test="userselectedTrue = 1">

																												<xsl:choose>
																													<xsl:when test="correct = 1">
																														<fo:block text-align="center">

																															<fo:external-graphic src="url('{/PDFViewModelData/righIconpath}')" content-width=".4cm">
																															</fo:external-graphic>
																														</fo:block>
																													</xsl:when>
																													<xsl:otherwise>
																														<fo:block text-align="center">

																															<fo:external-graphic
																																src="url('{/PDFViewModelData/wrongIconpath}')"
																																content-width=".4cm">
																															</fo:external-graphic>
																														</fo:block>
																													</xsl:otherwise>
																												</xsl:choose>

																											</xsl:if>
																										</fo:block>
																									</fo:table-cell>
																								</fo:table-row>

																							</xsl:for-each>
																						</xsl:if><!-- end of condition not to display option 
																							text in case of simulation based question where there is no options -->

																						<!-- for RIFORM item type -->
																						<xsl:if test="count(./optionListMCSC/optionList) =  0">
																							<fo:table-row keep-with-next="always">
																								<fo:table-cell
																									number-columns-spanned="4"
																									xsl:use-attribute-sets="myBorder">
																									<!-- inner table to display details of item type 
																										RIFORM -->
																									<fo:table>
																										<fo:table-column column-number="1" column-width="15%"/>
																										<fo:table-column column-number="2" column-width="20%"/>
																										<fo:table-column column-number="3" column-width="15%"/>
																										<fo:table-column column-number="4" column-width="50%"/>
																										<fo:table-body>
																											<fo:table-row keep-with-next="always">
																												<fo:table-cell xsl:use-attribute-sets="myBorder">
																													<fo:block xsl:use-attribute-sets="boldtext" text-align="left">
																														<xsl:value-of select="f:getProperty('RIFORM_QuestionAnalysis.AnswerDuration')" />
																													</fo:block>
																												</fo:table-cell>
																												<fo:table-cell xsl:use-attribute-sets="myBorder">
																													<fo:block xsl:use-attribute-sets="boldtext" text-align="left">
																														<xsl:value-of select="f:getProperty('RIFORM_QuestionAnalysis.RecordedAnswerDuration')" />
																													</fo:block>
																												</fo:table-cell>
																												<fo:table-cell xsl:use-attribute-sets="myBorder">
																													<fo:block xsl:use-attribute-sets="boldtext" text-align="left">
																														<xsl:value-of select="f:getProperty('RIFORM_QuestionAnalysis.Answeringmode')" />
																													</fo:block>
																												</fo:table-cell>
																												<fo:table-cell xsl:use-attribute-sets="myBorder">
																													<fo:block xsl:use-attribute-sets="boldtext" text-align="left">
																														<xsl:value-of select="f:getProperty('RIFORM_QuestionAnalysis.RecordedAnswerFilename')" />
																													</fo:block>
																												</fo:table-cell>
																											</fo:table-row>

																											<fo:table-row keep-with-next="always">
																												<fo:table-cell xsl:use-attribute-sets="myBorder">
																													<fo:block text-align="left" xsl:use-attribute-sets="normaltext">
																														<xsl:value-of select="answerDuration"></xsl:value-of>
																													</fo:block>
																												</fo:table-cell>
																												<fo:table-cell xsl:use-attribute-sets="myBorder">
																													<fo:block text-align="left" xsl:use-attribute-sets="normaltext">
																														<xsl:value-of select="timeTakenInSec"></xsl:value-of>
																													</fo:block>
																												</fo:table-cell>
																												<fo:table-cell xsl:use-attribute-sets="myBorder">
																													<fo:block text-align="left" xsl:use-attribute-sets="normaltext">
																														<xsl:if test="multiMediatype = 0">
																																<xsl:value-of select="f:getProperty('RIFORM_QuestionAnalysis.audio')" />
																														</xsl:if>

																													<xsl:if test="multiMediatype = 1">
																														<xsl:value-of select="f:getProperty('RIFORM_QuestionAnalysis.video')" />
																													</xsl:if>
																																																									</fo:block>
																												</fo:table-cell>
																												<fo:table-cell xsl:use-attribute-sets="myBorder">
																													<fo:block text-align="left" xsl:use-attribute-sets="normaltext">
																														<xsl:value-of select="optionFIlepath"></xsl:value-of>
																													</fo:block>
																												</fo:table-cell>
																											</fo:table-row>
																										</fo:table-body>
																									</fo:table>
																								</fo:table-cell>
																							</fo:table-row>

																						</xsl:if>
																					</xsl:if>


																				</fo:table-body>
																			</fo:table>
																			<!-- condition to check whther selected user option is 
																				correct or not -->
																			<xsl:for-each select="./optionListMCSC/optionList">
																				<!-- if condition to display table of answer explanation 
																					only if there is justification image or text -->

																				<xsl:if
																					test="not((normalize-space(justification)='' or justification ='null') and (normalize-space(justificationImage) = '' or justificationImage = 'null'))">



																					<xsl:if test="correct=1 or userselectedTrue = 1">

																						<fo:table space-before="0.5cm"
																							keep-together.within-column="always">
																							<fo:table-column column-number="1" />

																							<fo:table-body>

																								<!-- inner 1st row -->
																								<fo:table-row
																									keep-together.within-column="always">

																									<!-- 1st cell of inner table -->
																									<fo:table-cell
																										xsl:use-attribute-sets="myBorder">
																										<fo:block xsl:use-attribute-sets="boldtext"
																											color="black">
																											<xsl:value-of
																												select="f:getProperty('answerExplanation.label')" />
																										</fo:block>
																									</fo:table-cell>


																								</fo:table-row>

																								<fo:table-row>

																									<!-- 1st cell of inner table -->
																									<fo:table-cell
																										xsl:use-attribute-sets="myBorder">
																										<fo:block xsl:use-attribute-sets="boldtext"
																											color="black">
																											<xsl:value-of
																												select="f:getProperty('optionLbl.Justification')" />
																											&#160;
																											<xsl:value-of select="optionIndex"></xsl:value-of>

																										</fo:block>
																									</fo:table-cell>


																								</fo:table-row>

																								<!-- inner 2nd row -->
																								<fo:table-row>

																									<!-- 1st cell of inner table -->
																									<fo:table-cell
																										xsl:use-attribute-sets="myBorder">
																										<fo:block xsl:use-attribute-sets="normaltext"
																											linefeed-treatment="preserve"
																											white-space-treatment="preserve"
																											white-space-collapse="false">

																											<xsl:if test="not(justification = 'null')">
																												<xsl:value-of select="justification"></xsl:value-of>
																											</xsl:if>
																											<xsl:if test="not(justificationImage = 'null')">
																												<fo:block margin-left=".02cm"
																													margin-right=".02cm">

																													<xsl:variable name="optionImageSrc"
																														select="justificationImage" />
																													<fo:external-graphic
																														src="url({$optionImageSrc})"
																														inline-progression-dimension.maximum="100%"
																														content-height="scale-down-to-fit"
																														content-width="scale-down-to-fit">
																													</fo:external-graphic>
																												</fo:block>
																											</xsl:if>

																										</fo:block>
																									</fo:table-cell>


																								</fo:table-row>


																							</fo:table-body>
																						</fo:table>

																					</xsl:if>


																				</xsl:if>

																			</xsl:for-each>


																		</fo:table-cell>
																	</fo:table-row>

																</fo:table-body>
															</fo:table>

														</fo:block>
													</xsl:if>
													<!-- End of item type single correct,multiple correcct,picture 
														identification and comprehension -->

												</xsl:for-each>
												<!--End of Table of questions details alng with justification -->

											</fo:table-cell>
										</fo:table-row>
									</xsl:for-each>
								</xsl:for-each>
							</fo:table-body>

						</fo:table>


						<!-- End of topic wise analysis -->



					</fo:block>
					<fo:block id="end" text-align="center" space-before="45pt">

					</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	<!-- Code for reading proprty file -->
	<xsl:function name="f:getProperty" as="xs:string?">
		<xsl:param name="key" as="xs:string" />
		<xsl:variable name="lines" as="xs:string*"
			select="
						  for $x in 
							for $i in tokenize($properties, '\n')[matches(., '^[^!#]')] return
							  tokenize($i, '=')
							return translate(normalize-space($x), '\', '')" />
		<xsl:sequence select="$lines[index-of($lines, $key)+1]" />
	</xsl:function>

</xsl:stylesheet>