<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:attribute-set name="myBorder">
		<xsl:attribute name="border">solid 0.5mm black</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="normaltext">
		<xsl:attribute name="font-family">Calibri</xsl:attribute>
		<xsl:attribute name="font-size">11.5pt</xsl:attribute>
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
						extent="20mm" margin-top="0.7mm" />
					<fo:region-after region-name="footer-first" extent="20mm" />
				</fo:simple-page-master>

				<fo:simple-page-master master-name="rest"
					page-height="29.7cm" page-width="20cm" margin-left="2.0cm"
					margin-right="2.0cm" margin-top="1mm" margin-bottom="0.1cm">
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




				<fo:flow flow-name="pg-body">


					<xsl:for-each select="./listofCertificateViewModel/certificateViewModel">
						<fo:block space-after=".5cm" break-after="page">
							<fo:block space-before=".2mm">
								<!-- Candidate details table -->
								<fo:table>
									<fo:table-column column-number="1" />


									<fo:table-body>

										<!-- inner table -->
										<fo:table-row>
											<fo:table-cell>
												<fo:table>
													<fo:table-column column-number="1" />
													<fo:table-column column-number="2" />

													<fo:table-body>

														<fo:table-row>
															<fo:table-cell>
																<fo:block text-align="left">
																	<fo:external-graphic
																		src="url('resources/images/hkclLogo.jpg')"
																		inline-progression-dimension.maximum="100%"
																		content-height="110%" content-width="110%">>
																	</fo:external-graphic>
																</fo:block>
															</fo:table-cell>
															<fo:table-cell>
																<fo:block>
																	<fo:leader leader-pattern="rule" color="white" />
																</fo:block>
																<fo:block>
																	<fo:leader leader-pattern="rule" color="white" />
																</fo:block>
																<fo:block text-align="right">
																	<fo:external-graphic
																		src="url('resources/images/HSCITLogo.jpg')"
																		inline-progression-dimension.maximum="100%"
																		content-height="110%" content-width="110%">>
																	</fo:external-graphic>
																</fo:block>

															</fo:table-cell>
														</fo:table-row>
													</fo:table-body>
												</fo:table> <!-- end of first inner table -->
											</fo:table-cell>


										</fo:table-row>





										<fo:table-row>
											<!-- serial number cell -->
											<fo:table-cell>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center" font-size="17pt"
													font-weight="bold" font-family="calibriB">
													Haryana State -
													Certificate
													in
													Information Technology

												</fo:block>
											</fo:table-cell>

										</fo:table-row>


										<fo:table-row>

											<!-- serial number cell -->
											<fo:table-cell>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block text-align="center" font-size="15pt"
													font-weight="bold" font-family="calibriB" color="blue">
													Appearing
													Certificate
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>


											</fo:table-cell>

										</fo:table-row>

										<fo:table-row>
											<!-- serial number cell -->
											<fo:table-cell>
												<fo:block text-align="center"
													xsl:use-attribute-sets="normaltext">
													This is to certify that
												</fo:block>
												<!-- <fo:block> <fo:leader leader-pattern="rule" color="white" 
													/> </fo:block> -->
												<fo:block space-before="0.2cm" text-align="center"
													xsl:use-attribute-sets="normaltext" font-family="calibriB">

													<!-- candidate name -->
													<fo:inline padding-right="1mm">
														<xsl:value-of select="candidateFirstName" />
													</fo:inline>

													<!-- <xsl:if test="candidateMiddleName"> &#x00A0; </xsl:if> -->
													<fo:inline padding-right="1mm">
														<xsl:value-of select="candidateMiddleName" />
													</fo:inline>
													<!-- <xsl:if test="candidateLastName"> &#x00A0; </xsl:if> -->
													<fo:inline padding-right="1mm">
														<xsl:value-of select="candidateLastName" />
													</fo:inline>

												</fo:block>
												<!-- <fo:block> <fo:leader leader-pattern="rule" color="white" 
													/> </fo:block> -->
												<fo:block space-before="0.2cm" text-align="center"
													xsl:use-attribute-sets="normaltext">
													having Learner Code
													<fo:inline font-weight="bold" font-family="Calibri">
														<xsl:value-of select="candidateCode" />
													</fo:inline>
												</fo:block>
												<!-- <fo:block> <fo:leader leader-pattern="rule" color="white" 
													/> </fo:block> -->
												<fo:block space-before="0.2cm" text-align="center"
													xsl:use-attribute-sets="normaltext">
													has appeared for
													<fo:inline font-weight="bold" font-family="calibriB">
														“Final
														Exam HS-CIT"
													</fo:inline>
												</fo:block>
												<!-- <fo:block> <fo:leader leader-pattern="rule" color="white" 
													/> </fo:block> -->
												<fo:block space-before="0.2cm" text-align="center"
													xsl:use-attribute-sets="normaltext">
													on
													<fo:inline font-family="calibriB" font-size="11.5pt">
														<xsl:value-of select="attemptedDate" />
													</fo:inline>

												</fo:block>
												<!-- <fo:block> <fo:leader leader-pattern="rule" color="white" 
													/> </fo:block> -->
												<fo:block space-before="0.2cm" text-align="left"
													font-family="calibriI" font-style="italic">
													Details of Marks obtained
													are
													as follows:

												</fo:block>
											</fo:table-cell>
										</fo:table-row>




										<fo:table-row>
											<fo:table-cell>

												<!-- inner table -->
												<fo:table border="solid 0.5mm black">
													<fo:table-column column-number="1" />
													<fo:table-column column-number="2" />
													<fo:table-column column-number="3" />
													<fo:table-column column-number="4" />

													<fo:table-body border="solid 0.1mm black">

														<!-- 1st Row -->
														<fo:table-row background-color="#808080"
															text-align="center" font-family="calibriB" font-size="12pt">
															<fo:table-cell xsl:use-attribute-sets="myBorder">
																<fo:block>
																	Section

																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder">
																<fo:block>
																	Marks
																	obtained

																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder">
																<fo:block>
																	Maximum
																	marks

																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder">
																<fo:block>
																	Result

																</fo:block>
															</fo:table-cell>

														</fo:table-row>

														<!-- 2nd row -->
														<fo:table-row text-align="center">
															<fo:table-cell xsl:use-attribute-sets="myBorder">
																<fo:block font-family="Calibri" font-size="12pt">Internal
																	Evaluation
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder">
																<fo:block font-family="Calibri" font-size="11pt">Shall
																	be provided in the Final Certificate
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder">
																<fo:block font-family="Calibri" font-size="11pt">50
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder">
																<fo:block font-family="Calibri" font-size="11pt">Not
																	yet available*
																</fo:block>
															</fo:table-cell>

														</fo:table-row>

														<!-- 3rd row -->
														<fo:table-row text-align="center">
															<fo:table-cell xsl:use-attribute-sets="myBorder"
																font-family="Calibri" font-size="12pt">
																<fo:block font-family="Calibri" font-size="11pt">
																	Final Exam
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder"
																font-family="Calibri" font-size="11pt">
																<fo:block font-family="Calibri" font-size="11pt">
																	<xsl:value-of select="score" />
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder"
																font-family="Calibri" font-size="11pt">
																<fo:block font-family="Calibri" font-size="11pt"> 50
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder"
																font-family="Calibri" font-size="11pt">
																<fo:block font-family="Calibri" font-size="11pt">
																	<xsl:value-of select="resultStatus" />
																</fo:block>
															</fo:table-cell>

														</fo:table-row>

														<!-- 4th row -->
														<fo:table-row background-color="#808080"
															text-align="center">
															<fo:table-cell xsl:use-attribute-sets="myBorder"
																font-family="Calibri" font-size="12pt">
																<fo:block font-family="Calibri" font-size="11pt">
																	Total Marks
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder"
																font-family="Calibri" font-size="11pt">
																<fo:block font-family="Calibri" font-size="11pt">Not
																	yet available*
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder"
																font-family="Calibri" font-size="11pt">
																<fo:block font-family="Calibri" font-size="11pt">100
																</fo:block>
															</fo:table-cell>
															<fo:table-cell xsl:use-attribute-sets="myBorder"
																font-family="Calibri" font-size="11pt">
																<fo:block font-family="Calibri" font-size="11pt">Not
																	yet available*
																</fo:block>
															</fo:table-cell>

														</fo:table-row>

													</fo:table-body>
												</fo:table>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>


											</fo:table-cell>
										</fo:table-row>

										<fo:table-row>
											<fo:table-cell>
												<fo:block font-size="10pt" font-family="Calibri">
													*
													Following
													is the criteria for
													passing HS-CIT
													Examination
													successfully:
												</fo:block>
												<fo:block space-before=".2cm" font-size="10pt"
													font-family="Calibri">
													&#160;&#160;&#160;&#160;•&#160;&#160;&#160;Individual
													passing in
													Internal and
													Final Exam <fo:inline font-size="10pt" font-weight="bold"
															font-family="calibriB">each</fo:inline> with 40% Marks(20
													out
													of 50)
												</fo:block>
												<fo:block space-before=".2cm" font-size="10pt"
													font-family="Calibri">
													&#160;&#160;&#160;&#160;•&#160;&#160; Passing
													criteria
													is
													same for
													fresh
													as well as re-exam learners.
												</fo:block>
												<fo:block space-before=".2cm" font-size="10pt"
													font-family="Calibri">
													&#160;&#160;&#160;&#160;•&#160;&#160; Only
													passed
													Candidates in
													internal
													evaluation as well as final
													examination will
													receive Final
													Certificate
												</fo:block>

												<!-- code for signature and seal -->
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>

											</fo:table-cell>

										</fo:table-row>



										<!-- inner table -->
										<fo:table-row>
											<fo:table-cell>
												<fo:table>
													<fo:table-column column-number="1" />
													<fo:table-column column-number="2" />

													<fo:table-body>

														<fo:table-row>
															<fo:table-cell>

																<fo:block text-align-last='left'>
																	<fo:leader leader-pattern="rule"
																		leader-length="65%" />
																</fo:block>
																<fo:block text-align="left">
																	<fo:inline font-family="Calibri" font-size="11.5pt">
																		Signature of Exam Coordinator
																	</fo:inline>
																</fo:block>
															</fo:table-cell>
															<fo:table-cell>

																<fo:block text-align-last='right'>
																	<fo:leader leader-pattern="rule"
																		leader-length="10%" />
																</fo:block>
																<fo:block text-align="right">
																	<fo:inline font-family="Calibri" font-size="11.5pt">
																		Seal
																	</fo:inline>
																</fo:block>
															</fo:table-cell>
														</fo:table-row>
													</fo:table-body>
												</fo:table><!-- end of second inner table -->
											</fo:table-cell>
										</fo:table-row>





										<fo:table-row>
											<fo:table-cell>


												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>
												<fo:block>
													<fo:leader leader-pattern="rule" color="white" />
												</fo:block>

												<fo:block>
													<fo:block>
														<fo:inline font-size="9pt" font-weight="bold"
															font-family="calibriB">
															Important Note:
														</fo:inline>
													</fo:block>
													<fo:block font-size="9pt" font-family="Calibri">
														&#160;&#160;&#160;&#160;1)&#160;&#160; The certificate is
														only valid
														for the purpose
														of
														acknowledgement and the final
														certificate
														will be issued
														afterwards.
													</fo:block>
													<fo:block>
														<fo:leader leader-pattern="rule" color="white" />
													</fo:block>

													<fo:block font-size="9pt" font-family="Calibri">
														&#160;&#160;&#160;&#160;2)&#160;&#160; This certificate is
														not valid
														unless signed by
														the Exam
														Coordinator and with
														seal
														of the
														Center.
													</fo:block>
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