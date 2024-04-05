<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:f="Functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:variable name="lang" select="candLoginReportPDFData/locale" />
	<xsl:variable name="properties" select="unparsed-text($lang)"
		as="xs:string" />

	<xsl:attribute-set name="myBorder">
		<xsl:attribute name="border">solid 0.1mm gray</xsl:attribute>
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



	<xsl:template match="candLoginReportPDFData">
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






				<fo:flow flow-name="pg-body">

					<xsl:if test="locale = 'messages_ar.properties'">
						<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
					</xsl:if>
					<fo:block font-size="14pt" font-family="TIMESB" color="blue"
						text-align="center">
						<xsl:value-of select="eventName"></xsl:value-of>
					</fo:block>

					<fo:block xsl:use-attribute-sets="boldtext" text-align="left">
						<xsl:value-of select="f:getProperty('candidateLoginReport.title')" />
						<xsl:if test="eventCollectionType != 'None' ">
							<xsl:value-of select="eventCollectionType"></xsl:value-of>
							<xsl:value-of select="f:getProperty('colon.symbol')" />
							<xsl:value-of select="candidateCollectionType"></xsl:value-of>
						</xsl:if>
					</fo:block>


					<fo:block>
						<!-- Candidate details table -->
						<fo:table>


							<fo:table-column column-number="1" column-width="10%" />
							<fo:table-column column-number="2" column-width="30%" />
							<fo:table-column column-number="3" />
							<fo:table-column column-number="4" />
							<fo:table-column column-number="5" />
							<fo:table-column column-number="6" />

							<fo:table-body>

								<!-- 1st Row -->
								<fo:table-row keep-together.within-column="always">

									<!-- serial number cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of select="f:getProperty('serialnumber.label')" />
										</fo:block>
									</fo:table-cell>

									<!-- 2nd cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of select="f:getProperty('canidateName.label')" />
										</fo:block>
									</fo:table-cell>
									<!-- 3rd cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of
												select="f:getProperty('incompleteexams.CandidateCode')" />
										</fo:block>
									</fo:table-cell>
									<!-- 4th cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of select="f:getProperty('GroupReport.loginId')" />
										</fo:block>
									</fo:table-cell>
									<!-- 5th cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of select="f:getProperty('incompleteexams.Password')" />
										</fo:block>
									</fo:table-cell>
									<!-- 6th cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of select="f:getProperty('GroupReport.candidatephoto')" />
										</fo:block>
									</fo:table-cell>


								</fo:table-row>
								<xsl:for-each select="./listofCandidatePDFData/candidateViewModelData">
									<!-- IN loop -->
									<fo:table-row keep-together.within-column="always">

										<!-- serial number cell -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="serialNumber"></xsl:value-of>
											</fo:block>
										</fo:table-cell>

										<!-- 2nd cell -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
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
										<!-- 3rd cell -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="candidateCode"></xsl:value-of>
											</fo:block>
										</fo:table-cell>

										<!-- 4th cell -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="candidateLoginID"></xsl:value-of>
											</fo:block>
										</fo:table-cell>
										<!-- 5th cell -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="candidatePassword"></xsl:value-of>
											</fo:block>
										</fo:table-cell>
										<!-- 6th cell -->
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:variable name="photo" select="candidatePhoto"></xsl:variable>
												<xsl:choose>
													<xsl:when test="string(normalize-space($photo))">
														<fo:external-graphic src="url('{candidatePhoto}')"
															content-height="scale-to-fit" content-width="1.0583333cm"
															height="1.0583333cm" scaling="non-uniform">
														</fo:external-graphic>

													</xsl:when>
													<xsl:otherwise>
														<fo:block xsl:use-attribute-sets="normaltext">
															<xsl:value-of select="f:getProperty('noImageFound.msgOnPDF')" />
														</fo:block>
													</xsl:otherwise>
												</xsl:choose>
											</fo:block>
										</fo:table-cell>

									</fo:table-row>
								</xsl:for-each>

								<!-- end of loop -->

							</fo:table-body>
						</fo:table>
						<!-- End of Candidate details table -->
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