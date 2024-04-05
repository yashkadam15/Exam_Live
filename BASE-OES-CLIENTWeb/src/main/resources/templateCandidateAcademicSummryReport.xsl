<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:f="Functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:variable name="lang"
		select="candAcademicSummaryReportPDFData/locale" />
	<xsl:variable name="properties" select="unparsed-text($lang)"
		as="xs:string" />

	<xsl:attribute-set name="myBorder">
		<xsl:attribute name="border">solid 0.1mm #707070</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="headerBorder">
		<xsl:attribute name="border">solid 0.1mm #707070</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="titles">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">16pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="background-color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="border">solid 0.1mm #707070</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="boldtext">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">14pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-left">.2cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
		<xsl:attribute name="margin-top">.1cm</xsl:attribute>
		<xsl:attribute name="margin-bottom">.1cm</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="normaltext">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-left">.1cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
		<xsl:attribute name="margin-top">.2cm</xsl:attribute>
		<xsl:attribute name="margin-bottom">.2cm</xsl:attribute>

		<!-- <xsl:attribute name="background-color">#C0C0C0</xsl:attribute> -->
	</xsl:attribute-set>



	<xsl:template match="candAcademicSummaryReportPDFData">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>

				<fo:simple-page-master master-name="first"
					page-height="29.7cm" page-width="21cm" margin-left="0.5cm"
					margin-right="0.5cm" margin-top="1mm" margin-bottom="0.1cm">
					<fo:region-body region-name="pg-body" margin-top="12mm"
						margin-bottom="2cm" />
					<fo:region-before region-name="header-first"
						extent="1cm" margin-top="0.7mm" />
					<fo:region-after region-name="footer-first" extent="1.5cm" />
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="rest"
					page-height="29.7cm" page-width="21cm" margin-left="0.5cm"
					margin-right="0.5cm" margin-top="1mm" margin-bottom="0.1cm">
					<fo:region-body region-name="pg-body" margin-top="12mm"
						margin-bottom="2cm" />
					<fo:region-before region-name="header-rest"
						extent="1cm" margin-top="0.7mm" />
					<fo:region-after region-name="footer-first" extent="1.5cm" />
				</fo:simple-page-master>

			<!-- 	<fo:simple-page-master master-name="rest"
					page-height="29.7cm" page-width="21cm" margin-left="0.5cm"
					margin-right="0.5cm" margin-top="1mm" margin-bottom="0.1cm">
					<fo:region-body region-name="pg-body" margin-top="12mm"
						margin-bottom="2cm" />
					<fo:region-before region-name="header-rest"
						extent="1cm" margin-top="0.7mm" />
					<fo:region-after region-name="footer-rest" extent="1.5cm" />
				</fo:simple-page-master> -->

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

										<xsl:if test="locale = 'messages_ar.properties'">
											<xsl:attribute name="text-align">right</xsl:attribute>
										</xsl:if>
										<xsl:value-of
											select="f:getProperty('academicreportpdf.reportleftTitle')" />


									</fo:block>
								</fo:table-cell>
								<fo:table-cell>

									<fo:block xsl:use-attribute-sets="normaltext"
										text-align="right">
										<xsl:if test="locale = 'messages_ar.properties'">
											<xsl:attribute name="text-align">left</xsl:attribute>
										</xsl:if>
										<fo:block xsl:use-attribute-sets="normaltext">
											<fo:page-number />
											<!-- <xsl:value-of select="f:getProperty('academicreportpdf.pageof')" 
												/> -->
											&#x00A0;<xsl:value-of select="f:getProperty('global.pagination.of')" />&#x00A0;
											<!-- <xsl:value-of select="f:getProperty('global.pagination.of')" /> -->
											<fo:page-number-citation ref-id="end" />
										</fo:block>

									</fo:block>
								</fo:table-cell>

							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:static-content>

				

				<!-- rest Page header -->
				<fo:flow flow-name="pg-body">

					<xsl:if test="locale = 'messages_ar.properties'">
						<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
					</xsl:if>
					<fo:block>

						<!-- header -->
						<xsl:for-each
							select="./listofCandidateSummaryReportPDFData/candidateSummaryReportPDFData">

							<fo:block break-before="page">

								<fo:block xsl:use-attribute-sets="titles" text-align="center"
									keep-together="always">
									<fo:block xsl:use-attribute-sets="boldtext"
										text-align="center" keep-together="always">
										<xsl:value-of select="eventName"></xsl:value-of>
										<fo:block>
											<fo:inline padding-right="1mm">
												<xsl:value-of select="candidate/candidateFirstName"></xsl:value-of>

											</fo:inline>
											<fo:inline padding-right="1mm">
												<xsl:value-of select="candidate/candidateMiddleName"></xsl:value-of>
											</fo:inline>

											<fo:inline padding-right="1mm">
												<xsl:value-of select="candidate/candidateLastName"></xsl:value-of>
											</fo:inline>

											<fo:inline padding-right="2mm">
												(
												<xsl:value-of select="candidate/candidateUserName"></xsl:value-of>
												)
											</fo:inline>

										</fo:block>


									</fo:block>
								</fo:block>
								<fo:table>

									<fo:table-column column-number="1"
										column-width="5%" />
									<fo:table-column column-number="2"
										column-width="15%" />
									<fo:table-column column-number="3"
										column-width="27%" />
									<fo:table-column column-number="4"
										column-width="8%" />
									<fo:table-column column-number="5"
										column-width="8%" />
									<fo:table-column column-number="6"
										column-width="10%" />
									<fo:table-column column-number="7"
										column-width="7%" />
									<fo:table-column column-number="8"
										column-width="10%" />
									<fo:table-column column-number="9"
										column-width="10%" />

									<fo:table-header>
										<!-- Candidate Header -->
										<fo:table-row background-color="#EEEEEE">

											<!-- serial number cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of
														select="f:getProperty('candidateAcademicSummaryReport.srNo')" />

												</fo:block>
											</fo:table-cell>

											<!-- 2nd cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of
														select="f:getProperty('candidateAcademicSummaryReport.dispCategory')" />

												</fo:block>
											</fo:table-cell>
											<!-- 3rd cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of
														select="f:getProperty('candidateAcademicSummaryReport.paper')" />

												</fo:block>
											</fo:table-cell>
											
											<!-- 4rd cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
												<xsl:value-of
														select="f:getProperty('bulkEndExam.attemptno')" />
												
													
												</fo:block>
											</fo:table-cell>
											
											<!-- 5th cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of
														select="f:getProperty('candidateAcademicSummaryReport.totalMarks')" />

												</fo:block>
											</fo:table-cell>
											<!-- 6th cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of
														select="f:getProperty('candidateAcademicSummaryReport.markObtain')" />

												</fo:block>
											</fo:table-cell>
											<!-- 7th cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of
														select="f:getProperty('candidateAcademicSummaryReport.TotalTime')" />

												</fo:block>
											</fo:table-cell>
											<!-- 8th cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of
														select="f:getProperty('candidateAcademicSummaryReport.timeTaken')" />

												</fo:block>
											</fo:table-cell>
											<!-- 9th cell -->
											<fo:table-cell xsl:use-attribute-sets="headerBorder"
												wrap-option="wrap">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of
														select="f:getProperty('candidateAcademicSummaryReport.dateAppeared')" />

												</fo:block>
											</fo:table-cell>

										</fo:table-row>
									</fo:table-header>
									<!-- end of header -->


									<!-- Candidate Exam details table -->

									<fo:table-body>
										<xsl:for-each
											select="./listofCandidateWiseExamPDFData/candidateWiseExamPDFData">
											<!-- 1st Row -->
											<fo:table-row keep-together.within-column="always">

												<!-- serial number cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:number value="position()" format="1" />
													</fo:block>
												</fo:table-cell>

												<!-- 2nd cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:value-of
															select="displayCategoryLanguage/displayCategoryName" />
													</fo:block>
												</fo:table-cell>
												<!-- 3rd cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:value-of select="paper/name" /> <!-- [Attempt # <xsl:value-of select="candidateExam/attemptNo" />] -->
													</fo:block>
												</fo:table-cell>
												
												<!-- 4th cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:value-of select="attemptNo" />
													</fo:block>
												</fo:table-cell>
												
												<!-- 5th cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:value-of select="paperMarks/totalMarks" />
													</fo:block>
												</fo:table-cell>
												
												<!-- 6th cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<!-- <xsl:choose>
															<xsl:when test="candidateExam/marksObtained >= 0">
																<xsl:value-of select="candidateExam/marksObtained" />
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="f:getProperty('academicreportpdf.NA')" />
															</xsl:otherwise>
														</xsl:choose> -->
														<xsl:value-of select="candidateExam/marksObtained" />
													</fo:block>
												</fo:table-cell>
												
												<!-- 7th cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:value-of select="paper/duration" />
													</fo:block>
												</fo:table-cell>
												
												<!-- 8th cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<!-- <xsl:choose>
															<xsl:when test="candidateExam/elapsedTime>0">
																<xsl:value-of select="candidateExam/elapsedTime" />
															</xsl:when>
															<xsl:otherwise>

																<xsl:value-of select="f:getProperty('academicreportpdf.NA')" />
															</xsl:otherwise>
														</xsl:choose> -->
														<xsl:value-of select="candidateExam/elapsedTime" />
													</fo:block>
												</fo:table-cell>
												<!-- 9th cell -->
												<fo:table-cell xsl:use-attribute-sets="myBorder"
													wrap-option="wrap">
													<fo:block xsl:use-attribute-sets="normaltext">
														<xsl:choose>
															<xsl:when test="string-length(candidateExam/attemptDate)>0">
																<xsl:variable name="dte"
																	select="candidateExam/attemptDate" />
																<!-- xmlns:ms="urn:schemas-microsoft-com:xslt" <xsl:value-of 
																	select="ms:format-date($dte, 'MMM dd, yyyy')"/> -->

																<xsl:value-of
																	select="concat(
								                      substring($dte, 9, 2),
								                      '/',
								                      substring($dte, 6, 2),
								                      '/',
								                      substring($dte, 1, 4)
								                      )" />
															</xsl:when>
															<xsl:otherwise>

																<xsl:value-of select="f:getProperty('academicreportpdf.NA')" />
															</xsl:otherwise>
														</xsl:choose>

													</fo:block>
												</fo:table-cell>

											</fo:table-row>
										</xsl:for-each>

										<!-- <fo:table-row> <fo:table-cell number-columns-spanned="7"> 
											<fo:block xsl:use-attribute-sets="boldtext" > * N/A -Not Attempted by Candidate 
											</fo:block> </fo:table-cell> </fo:table-row> -->



									</fo:table-body>
								</fo:table>



							</fo:block>
						</xsl:for-each><!-- cand main loop end -->
						<fo:block xsl:use-attribute-sets="boldtext">

							<xsl:value-of select="f:getProperty('academicreportpdf.NAmsg')" />


						</fo:block>
						<!-- End of Candidate details table -->
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