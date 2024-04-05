<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:attribute-set name="myBorder">
		<xsl:attribute name="border">solid 0.1mm gray</xsl:attribute>
	</xsl:attribute-set>



	<xsl:attribute-set name="normaltext">
		<xsl:attribute name="font-family">CALIBRI</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-left">.2cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
	</xsl:attribute-set>




	<xsl:template match="certificateViewModelRoot">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

			<fo:layout-master-set>

				<fo:simple-page-master master-name="first"
					page-height="29.7cm" page-width="20cm" margin-left="2.0cm"
					margin-right="2.0cm" margin-top="1mm" margin-bottom="0.1cm">
					<fo:region-body region-name="pg-body" margin-top="12mm"
						margin-bottom="2cm" />
					<fo:region-before region-name="header-first"
						extent="1cm" margin-top="0.7mm" />
					<fo:region-after region-name="footer-first" extent=".5cm" />
				</fo:simple-page-master>

				<fo:simple-page-master master-name="rest"
					page-height="29.7cm" page-width="20cm" margin-left="2.0cm"
					margin-right="2.0cm" margin-top="1mm" margin-bottom="0.1cm">
					<fo:region-body region-name="pg-body" margin-top="12mm"
						margin-bottom="2cm" />
					<fo:region-before region-name="header-rest"
						extent=".5cm" margin-top="0.7mm" />
					<fo:region-after region-name="footer-first" extent=".5cm" />
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

				<!-- First Page Footer -->
				<fo:static-content flow-name="footer-first">

					<fo:block xsl:use-attribute-sets="normaltext" color="blue"
						font-size="9pt" text-align="center">
						<!-- <fo:page-number /> -->
						&#x00A0;
						<xsl:value-of select="requestURL" />
						&#x00A0;
						<fo:page-number-citation ref-id="end" />
					</fo:block>


				</fo:static-content>



				<fo:flow flow-name="pg-body">
					<!-- get logo name based on client -->
					<xsl:variable name="logo" select="logoName">
					</xsl:variable>

					<xsl:for-each select="./listofCertificateViewModel/certificateViewModel">
						<fo:block space-after=".5cm" break-after="page">
							<fo:block space-before=".2mm">
								<!-- Candidate details table -->
								<fo:table>
									<fo:table-column column-number="1" />


									<fo:table-body>

										<!-- 1st Row -->
										<fo:table-row keep-together.within-column="always">

											<!-- serial number cell -->
											<fo:table-cell font-weight="bold" font-family='Times New Roman'>

												<fo:block text-align="center">
													<fo:external-graphic  src="{$logo}"
														inline-progression-dimension.maximum="100%"
														content-height="100%" content-width="100%">
													</fo:external-graphic>
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>

												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center"
													keep-together.within-column="always" font-size="16pt">
													<fo:inline text-decoration="underline"> Computer Typing Speed
														Test
													</fo:inline>
												</fo:block>
											</fo:table-cell>

										</fo:table-row>

										<fo:table-row keep-together.within-column="always">

											<!-- serial number cell -->
											<fo:table-cell font-size="14pt" font-weight="bold"
												font-family='Times New Roman'>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center" font-size="12pt">
													<xsl:value-of select="speed" />
													&#x00A0;Words Per Minute
												</fo:block>

												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center">
													<fo:inline text-decoration="underline"> Attempt Certificate
													</fo:inline>
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
											</fo:table-cell>

										</fo:table-row>



										<fo:table-row keep-together.within-column="always">
											<!-- serial number cell -->
											<fo:table-cell xsl:use-attribute-sets="normaltext"
												font-family='Times New Roman'>
												<fo:block text-align="center">
													This is to certify that
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center">

													<!-- candidate name -->
													<fo:inline padding-right="1mm" font-weight="bold"
														font-family="ARIAL">
														<xsl:value-of select="candidateFirstName" />
													</fo:inline>

													<!-- <xsl:if test="candidateMiddleName"> &#x00A0; </xsl:if> -->
													<fo:inline padding-right="1mm" font-weight="bold"
														font-family="ARIAL">
														<xsl:value-of select="candidateMiddleName" />
													</fo:inline>
													<!-- <xsl:if test="candidateLastName"> &#x00A0; </xsl:if> -->
													<fo:inline padding-right="1mm" font-weight="bold"
														font-family="ARIAL">
														<xsl:value-of select="candidateLastName" />
													</fo:inline>

												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center">
													having Registration Number
													<fo:inline font-weight="bold" font-family="ARIAL">
														<xsl:value-of select="candidateCode" />
													</fo:inline>
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center">
													has appeared for
													<fo:inline font-weight="bold" font-family="ARIAL">
														"
														<xsl:value-of select="candidatePaperName" />
														"
													</fo:inline>
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center">
													on
													<fo:inline font-weight="bold" font-family="ARIAL">
														<xsl:value-of select="attemptedDate" />
													</fo:inline>
													at
													<fo:inline font-weight="bold" font-family="ARIAL">
														<xsl:value-of select="nameOfExamCenter" />
													</fo:inline>
													,
													District :
													<fo:inline font-weight="bold" font-family="ARIAL">
														<xsl:value-of select="district" />
													</fo:inline>
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center">
													and he/she has Computer Typing Speed of

													<fo:inline font-weight="bold" font-family="ARIAL">
														"
														<xsl:value-of select="score" />
														"
													</fo:inline>
													Net Words Per Minute (WPM).


												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<!-- table to display seal and signature -->
												<fo:table>
													<fo:table-column column-number="1" />
													<fo:table-column column-number="2" />

													<fo:table-body>

														<!-- 1st Row -->
														<fo:table-row keep-together.within-column="always">

															<!-- serial number cell -->
															<fo:table-cell text-align="center">
																<fo:block>
																	<fo:leader leader-length="80%"
																		leader-pattern="rule" color="black" />
																</fo:block>
																<fo:block>

																	<fo:inline font-weight="bold" font-size="10pt">
																		Signature of Exam Center Coordinator
																	</fo:inline>
																</fo:block>
															</fo:table-cell>
															<fo:table-cell text-align="center">
																<fo:block>
																	<fo:leader leader-length="50%"
																		leader-pattern="rule" color="black" />
																</fo:block>
																<fo:block>

																	<fo:inline font-weight="bold" font-size="10pt"> Seal
																		of Exam Center
																	</fo:inline>
																</fo:block>
															</fo:table-cell>

														</fo:table-row>
													</fo:table-body>
												</fo:table>






												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="left" font-weight="bold">
													Important
													Note:
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													1. This certificate is only valid for the purpose
													of
													acknowledgement.
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													2. This certificate is not valid unless signed by
													the Exam Center Coordinator with seal of the Center.
												</fo:block>




											</fo:table-cell>

										</fo:table-row>








									</fo:table-body>
								</fo:table>
								<!-- End of Candidate details table -->
							</fo:block>
						</fo:block>
					</xsl:for-each>

				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
</xsl:stylesheet>