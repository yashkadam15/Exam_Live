<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:f="Functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:variable name="lang" select="CandidateAttemptPDFModel/locale" />
	<xsl:variable name="properties" select="unparsed-text($lang)" as="xs:string" />

	<xsl:attribute-set name="myBorder">
		<xsl:attribute name="border">solid 0.1mm gray</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="blockBorder">
		<xsl:attribute name="border">solid 0.1mm gray</xsl:attribute>
		<xsl:attribute name="background-color">gray</xsl:attribute>
		<xsl:attribute name="padding">0.5mm</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="subTitleBorder">
		<xsl:attribute name="border-bottom-width">solid 0.1mm gray</xsl:attribute>
		<xsl:attribute name="border-left-width">solid 0.1mm gray</xsl:attribute>
		<xsl:attribute name="border-right-width">solid 0.1mm gray</xsl:attribute>
		<xsl:attribute name="background-color">gray</xsl:attribute>
		<xsl:attribute name="padding">0.5mm</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="tableBorder">
		<xsl:attribute name="border">solid 0.5mm gray</xsl:attribute>
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="titles">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">18pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="background-color">#428BCA</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="boldtext">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-left">.2cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="blueBoldtext">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="margin-left">.2cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="redBoldtext">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">red</xsl:attribute>
		<xsl:attribute name="margin-left">.2cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="normaltext">
		<xsl:attribute name="font-family">APARAJ,ARAB</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="margin-left">.2cm</xsl:attribute>
		<xsl:attribute name="margin-right">.2cm</xsl:attribute>
	</xsl:attribute-set>



	<xsl:template match="CandidateAttemptPDFModel">
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


	<!-- First Page Footer -->
	<fo:static-content flow-name="footer-first">
		<xsl:if test="locale = 'messages_ar.properties'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
		<!-- table for footer -->
		<fo:table>
			<fo:table-column column-number="1" />
			<!-- <fo:table-column column-number="3" /> -->
			<fo:table-body>
				<fo:table-row keep-together.within-column="always">

					<fo:table-cell text-align="center">
						<xsl:if test="locale = 'messages_ar.properties'">
							<xsl:attribute name="text-align">center</xsl:attribute>
						</xsl:if>
						<fo:block xsl:use-attribute-sets="normaltext">

							<fo:block xsl:use-attribute-sets="normaltext">
								<fo:page-number />
								<xsl:text>&#160;&#160;</xsl:text>
								<xsl:value-of select="f:getProperty('global.pagination.of')" />
								<xsl:text>&#160;&#160;</xsl:text>
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
			<!-- <fo:table-column column-number="3" /> -->
			<fo:table-body>
				<fo:table-row keep-together.within-column="always">
					<fo:table-cell text-align="center">
						<fo:block xsl:use-attribute-sets="normaltext" text-align="center">
							<xsl:if test="locale = 'messages_ar.properties'">
								<xsl:attribute name="text-align">center</xsl:attribute>
							</xsl:if>
							<fo:block xsl:use-attribute-sets="normaltext">
								<fo:page-number />
								<xsl:text>&#160;&#160;</xsl:text>
								<xsl:value-of select="f:getProperty('global.pagination.of')" />
								<xsl:text>&#160;&#160;</xsl:text>
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
				
					<fo:block text-align="center" xsl:use-attribute-sets="titles blockBorder">
						<xsl:value-of select="f:getProperty('attemptReport.pdftitle')" />
						&#160;<xsl:value-of select="lastName" />
						&#160;<xsl:value-of select="middleName" />
						&#160;<xsl:value-of select="firstName" />
					</fo:block>
			
					<fo:block text-align="center" xsl:use-attribute-sets="titles blockBorder">
							<xsl:value-of select="f:getProperty('attemptReport.pdfSubtitle')" /> 		
					</fo:block>
					
					
					<!-- <fo:block white-space-collapse="false" white-space-treatment="preserve" 
    				font-size="0pt" line-height="10px">.</fo:block> -->
					
					<fo:table xsl:use-attribute-sets="tableBorder">
						<fo:table-column column-number="1" column-width="35%" />
						<fo:table-column column-number="2" column-width="65%" />

						<fo:table-body>
							
							<fo:table-row keep-together.within-column="always">

								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.examEvent')" /> 
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="eventName" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
								
								<fo:table-row>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.pName')" /> 
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="paperName" />
									</fo:block>
								</fo:table-cell>
								</fo:table-row>
								
								<fo:table-row>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.attemptNo')" /> 
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="attemptNo" />
									</fo:block>
								</fo:table-cell>
								</fo:table-row>
								
								<fo:table-row>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.candidateCode')" />  
									</fo:block>
								</fo:table-cell>
									<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="candidateCode" />
									</fo:block>
								</fo:table-cell>
								</fo:table-row>
								
								<fo:table-row>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.examStatus')" />  
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:choose>
											<xsl:when test="examStatus='true' ">
												<xsl:value-of select="f:getProperty('attemptReport.complete')" /> 
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="f:getProperty('attemptReport.incomplete')" />
											</xsl:otherwise>
										</xsl:choose>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							
							<fo:table-row>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.totQues')" />  
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="totQuestions" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							
							<fo:table-row>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.atmptQues')" />  
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="attemptedQuestions" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							
							<fo:table-row>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.remainQues')" />
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="remainingQuestios" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							
							<fo:table-row>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="f:getProperty('attemptReport.markObt')" />
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="marksObtained" />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
					
					
						</fo:table-body>
					</fo:table>
					
					<fo:block white-space-collapse="false" white-space-treatment="preserve" 
    				font-size="0pt" line-height="10px">.</fo:block>
    				
					<fo:block text-align="left" xsl:use-attribute-sets="boldtext" font-size="12pt" font-weight="bold">
								#Note:
								&#160;<fo:inline color="blue">Blue</fo:inline>&#160;Color indicates ‘Correct Answer‘
								 &#160;<fo:inline color="red">Red</fo:inline>&#160;Color indicates ‘Incorrect Answer’
								 &#160;<fo:inline color="black">Black</fo:inline>&#160;Color indicates ‘Not Attempted’
					</fo:block>
		
					<fo:block>
						<fo:table border-right-width="0.5mm" xsl:use-attribute-sets="tableBorder">
							<fo:table-column column-number="1" column-width="15%"/>
							<fo:table-column column-number="2" column-width="10%"/>
							<fo:table-column column-number="3" column-width="75%"/>
							<fo:table-body>
							
						<xsl:for-each select="./CandidateAttemptReportList/CandidateAttemptReport">
							<xsl:variable name="itemCount" select="itemSequenceNumber"/> 
							
								<xsl:if test="not(sectionName='Default') and itemSequenceNumber=1">
									<fo:table-row keep-together.within-column="always">
										<fo:table-cell text-align="center" number-columns-spanned="3">
											<fo:block text-align="center" xsl:use-attribute-sets="titles blockBorder" font-size="14pt" font-weight="bold">
												<xsl:value-of select="sectionName" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</xsl:if>
								
								
								<fo:table-row keep-together.within-column="always" xsl:use-attribute-sets="myBorder" border-top-width="0.5mm">
								
									<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
										 	 <xsl:value-of select="f:getProperty('attemptReport.questionID')" />
										 	 &#160;
										 	 <xsl:value-of select="itemID"></xsl:value-of>
										</fo:block>
									</fo:table-cell>
								
								
									<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
											<xsl:value-of select="f:getProperty('attemptReport.question')" />
											<!-- <xsl:value-of select="$itemCount"></xsl:value-of>. -->
											<xsl:value-of select="itemSequenceNumber"></xsl:value-of>.
										</fo:block>
									</fo:table-cell>
									
									<fo:table-cell xsl:use-attribute-sets="myBorder"> 	
										<fo:block  xsl:use-attribute-sets="boldtext" linefeed-treatment="preserve" white-space-treatment="preserve" white-space-collapse="false">
											<!-- check for Question Text -->
											<xsl:if test="not(itemText = 'null')">
												<xsl:choose>
												    
												    <xsl:when  test="not(multimediaType = 'null') and ( multimediaType = 'AUDIO' or multimediaType = 'VIDEO')">
                                                          
                                                          
                                                          <fo:inline>
																	<xsl:choose>
                                                          				<xsl:when test="not(multimediaType = 'null') and multimediaType = 'AUDIO'">
                                                                			<xsl:value-of select="f:getProperty('attemptReport.Audio')" /> (<xsl:value-of select="itemText" />)
 													      				</xsl:when>
 													      				<xsl:when test="not(multimediaType = 'null') and multimediaType = 'VIDEO'">
                                                                			<xsl:value-of select="f:getProperty('attemptReport.Video')" /> (<xsl:value-of select="itemText" />)
 													      				</xsl:when>
 													      			</xsl:choose>
														  </fo:inline>
                                                         
														
 												   </xsl:when>
												   <xsl:otherwise>
												         <xsl:value-of select="itemText" />
												   </xsl:otherwise>
  												</xsl:choose>
											</xsl:if>
											
																
											<!-- check for Question Image -->
											<xsl:if test="not(itemImageList = 'null') and count(ItemImageList/ItemImage) > 0">
												<xsl:for-each select="./ItemImageList/ItemImage">
													<fo:block>
														<xsl:variable name="questionImageSrc" select="." />
														<fo:external-graphic src="decImg:{$questionImageSrc}"
															inline-progression-dimension.maximum="100%"
															content-height="scale-down-to-fit" content-width="scale-down-to-fit">
														</fo:external-graphic>
													</fo:block>
												</xsl:for-each>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								
								<!-- Option ID, Option Sequence and Option text -->
								<xsl:if test="not(CandidateAttemptOptionList='null') and count(CandidateAttemptOptionList/CandidateAttemptOption) > 0">
								<xsl:for-each select="./CandidateAttemptOptionList/CandidateAttemptOption">
									<fo:table-row keep-together.within-column="always" xsl:use-attribute-sets="myBorder">
										<fo:table-cell text-align="left"  xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="f:getProperty('attemptReport.optID')" /> 
												&#160;
												<xsl:value-of select="optionID"></xsl:value-of>
											</fo:block>
										</fo:table-cell>
										
										<fo:table-cell text-align="left"  xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="f:getProperty('attemptReport.option')" />
												&#160;
												<!-- <xsl:value-of select="optionSequence"></xsl:value-of>. -->
												<xsl:value-of select="position()"/>.
											</fo:block>
										</fo:table-cell>	
												
										<fo:table-cell text-align="left"  xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext" linefeed-treatment="preserve" white-space-treatment="preserve" white-space-collapse="false">
											 	<!-- check for Option Text -->
															<xsl:if test="not(optionText = 'null')">
																	<xsl:value-of select="optionText" />
															</xsl:if>
    
															<xsl:if test="not(optionImage = 'null')">
																<fo:block>	
																<xsl:variable name="optionImageSrc" select="optionImage" />
																	<fo:external-graphic src="decImg:{$optionImageSrc}"
																		inline-progression-dimension.maximum="100%"
																		content-height="scale-down-to-fit" content-width="scale-down-to-fit">
																	</fo:external-graphic>
																</fo:block>
															</xsl:if>
											 </fo:block>
										</fo:table-cell>
									</fo:table-row>
								</xsl:for-each>
								</xsl:if>
							
								<!-- Correct option, Attempted OptionSequence, Attempted OptionID -->
										<xsl:choose>
											<xsl:when test="not(itemType='null') and (itemType='PRT')">
												<fo:table-row keep-together.within-column="always" xsl:use-attribute-sets="myBorder">
												<fo:table-cell text-align="left" number-columns-spanned="2"  xsl:use-attribute-sets="myBorder"></fo:table-cell>
												
													<fo:table-cell text-align="left"  xsl:use-attribute-sets="myBorder">
														<xsl:choose>
													 	 	<xsl:when test="correctIncorrectFlag='true'">
													 	 			<fo:block xsl:use-attribute-sets="blueBoldtext">
													 	 				<xsl:value-of select="f:getProperty('attemptReport.Correct')" />
													 	 			</fo:block>
													 	 		</xsl:when>
													 	 		<xsl:otherwise>
													 	 			<xsl:choose>
													 	 				<xsl:when test="correctIncorrectFlag='false'">
													 	 					<fo:block xsl:use-attribute-sets="redBoldtext">
													 	 						<xsl:value-of select="f:getProperty('attemptReport.InCorrect')" />
													 	 					</fo:block>
													 	 				</xsl:when>
													 	 				<xsl:otherwise>
													 	 					<fo:block xsl:use-attribute-sets="boldtext">
													 	 					<xsl:value-of select="f:getProperty('attemptReport.notAttempted')" />
															 	 		</fo:block>		
													 	 				</xsl:otherwise>
													 	 			</xsl:choose>
												 		 		</xsl:otherwise>
													 	 </xsl:choose>
													</fo:table-cell>
													 </fo:table-row>	 
											</xsl:when>
											
									<xsl:otherwise>
									
									<xsl:if test="not(CorrectOptionSeqList='null') and count(CorrectOptionSeqList/CorrectOptionSeq) > 0">
									<fo:table-row keep-together.within-column="always" xsl:use-attribute-sets="myBorder">
									<fo:table-cell text-align="left" number-columns-spanned="2"  xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
										 	 <xsl:value-of select="f:getProperty('attemptReport.correctOption')" />
										 	 &#160;
										 	 <xsl:if test="not(CorrectOptionSeqList='null') and count(CorrectOptionSeqList/CorrectOptionSeq) > 0">
										 	 	<xsl:for-each select="./CorrectOptionSeqList/CorrectOptionSeq">
										 	 		<xsl:value-of select="."></xsl:value-of>
										 	 	 		<xsl:if test="position() != last()">,</xsl:if>
										 	 	</xsl:for-each>
										 	 </xsl:if>
										</fo:block>
									</fo:table-cell>
									
									
										<fo:table-cell text-align="left"  xsl:use-attribute-sets="myBorder">
											<xsl:choose>
												
												<xsl:when test="not(correctIncorrectFlag='null') and (correctIncorrectFlag='true') ">
													<fo:block xsl:use-attribute-sets="blueBoldtext">
														<xsl:value-of select="f:getProperty('attemptReport.attemptedOption')" />
														&#160;
														<xsl:if test="not(AttemptedOptionSeqList='null') and count(AttemptedOptionSeqList/AttemptedOptionSeq) > 0">
															 <xsl:for-each select="./AttemptedOptionSeqList/AttemptedOptionSeq">
										 	 					<xsl:value-of select="."></xsl:value-of>
										 	 					 <xsl:if test="position() != last()">,</xsl:if>
										 	 				</xsl:for-each>
										 	 			</xsl:if>
										 	 			&#160; &#160;
										 	 			<xsl:value-of select="f:getProperty('attemptReport.attemptedOptionID')"/>
														&#160;
														
														<xsl:if test="not(AttemptedOptionIDList='null') and count(AttemptedOptionIDList/AttemptedOptionID) > 0">
										 	 			<xsl:for-each select="./AttemptedOptionIDList/AttemptedOptionID">
									 	 					<xsl:value-of select="."></xsl:value-of>
									 	 					 <xsl:if test="position() != last()">,</xsl:if>
										 	 			</xsl:for-each>
										 	 			</xsl:if>
										 	 			
													</fo:block>
												</xsl:when>
												
												<xsl:otherwise>
													<xsl:choose>
													<xsl:when test="not(attemptedOptionSeqList='null') and AttemptedOptionSeqList/AttemptedOptionSeq">
													<fo:block xsl:use-attribute-sets="redBoldtext">
														<xsl:value-of select="f:getProperty('attemptReport.attemptedOption')" />
														&#160;
														<xsl:for-each select="./AttemptedOptionSeqList/AttemptedOptionSeq">
									 	 					<xsl:value-of select="."></xsl:value-of>
									 	 					 <xsl:if test="position() != last()">,</xsl:if>
										 	 			</xsl:for-each>
										 	 			
										 	 			
										 	 			&#160; &#160;
										 	 			<xsl:value-of select="f:getProperty('attemptReport.attemptedOptionID')"/>
														&#160;
												
														<xsl:if test="not(AttemptedOptionIDList='null') and count(AttemptedOptionIDList/AttemptedOptionID) > 0">
										 	 			<xsl:for-each select="./AttemptedOptionIDList/AttemptedOptionID">
									 	 					<xsl:value-of select="."></xsl:value-of>
									 	 					 <xsl:if test="position() != last()">,</xsl:if>
										 	 			</xsl:for-each>
										 	 			</xsl:if>
										 	 			
										 	 		</fo:block>
													</xsl:when>
														
													<xsl:otherwise>
														<fo:block xsl:use-attribute-sets="boldtext">
															<xsl:value-of select="f:getProperty('attemptReport.notAttempted')" />
														 </fo:block>
													</xsl:otherwise>
													
													</xsl:choose>
												</xsl:otherwise>
												
											</xsl:choose>
											
									</fo:table-cell>
									</fo:table-row>
										</xsl:if>	 
									</xsl:otherwise>
							</xsl:choose>
										
								
									
									
								<!-- For Comprehension Subitems -->
								
								<xsl:if test="not(SubItemList='null') and count(SubItemList/SubItem) > 0">
									<xsl:for-each select="./SubItemList/SubItem">
										<xsl:variable name="subitemCount" select="position()"/>
										<fo:table-row keep-together.within-column="always">
											<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder" border-top-width="0.4mm">
												<fo:block xsl:use-attribute-sets="boldtext">
												 	<xsl:value-of select="f:getProperty('attemptReport.subQuestionID')" />
										 	 			&#160;
												 	 <xsl:value-of select="subItemItemID"></xsl:value-of>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder" border-top-width="0.4mm">
												<fo:block xsl:use-attribute-sets="boldtext">
													<xsl:value-of select="f:getProperty('attemptReport.subQuestion')" />
													<xsl:value-of select="$itemCount"></xsl:value-of>.
													<xsl:value-of select="$subitemCount"></xsl:value-of>
													</fo:block>
											</fo:table-cell>
											<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder" border-top-width="0.4mm">
											<fo:block xsl:use-attribute-sets="boldtext" linefeed-treatment="preserve" white-space-treatment="preserve" white-space-collapse="false">
													<xsl:if test="not(subItemText = 'null')">
															<xsl:value-of select="subItemText" />
													</xsl:if>
													
													<xsl:if test="not(subItemImage = 'null') and not(normalize-space(subItemImage)='')">
														<!-- check for Question Image -->
														<xsl:variable name="questionImageSrc" select="subItemImage" />
														<fo:block>
															<fo:external-graphic src="decImg:{$questionImageSrc}"
																inline-progression-dimension.maximum="100%"
																content-height="scale-down-to-fit" content-width="scale-down-to-fit">
															</fo:external-graphic>
														</fo:block>
													</xsl:if>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										
										
										
										<xsl:if test="not(SubItemOptionList='null') and count(SubItemOptionList/SubItemOption) > 0">
											<xsl:for-each select="./SubItemOptionList/SubItemOption">
												<fo:table-row keep-together.within-column="always">
													<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
														<fo:block xsl:use-attribute-sets="normaltext">
															<xsl:value-of select="f:getProperty('attemptReport.optID')" /> 
															&#160;
															<xsl:value-of select="subOptionID"></xsl:value-of>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
														<fo:block xsl:use-attribute-sets="normaltext">
														 	<xsl:value-of select="f:getProperty('attemptReport.option')" />
														 	&#160;
														 	<!-- <xsl:value-of select="subOptionSeqNo"></xsl:value-of>. -->
														 	<xsl:value-of select="position()"/>.
														</fo:block>
													</fo:table-cell>
													<fo:table-cell text-align="left" xsl:use-attribute-sets="myBorder">
														<fo:block xsl:use-attribute-sets="normaltext" linefeed-treatment="preserve" white-space-treatment="preserve" white-space-collapse="false">
														 	<!-- check for Option Text -->
															<xsl:if test="not(subOptionText = 'null')">
																	<xsl:value-of select="subOptionText" />
															</xsl:if>
			
															<xsl:if test="not(subOptionImage = 'null') and not(normalize-space(subOptionImage)='')">
																<fo:block>
																	<xsl:variable name="optionImageSrc"
																		select="subOptionImage" />
																	<fo:external-graphic src="decImg:{$optionImageSrc}"
																		inline-progression-dimension.maximum="100%"
																		content-height="scale-down-to-fit" content-width="scale-down-to-fit">
																	</fo:external-graphic>
																</fo:block>
															</xsl:if>
														 </fo:block>
													</fo:table-cell>
												</fo:table-row>
											</xsl:for-each>
											
									<fo:table-row keep-together.within-column="always" xsl:use-attribute-sets="myBorder">
									<fo:table-cell text-align="left" number-columns-spanned="2"  xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
										 	 <xsl:value-of select="f:getProperty('attemptReport.correctOption')" />
										 	 &#160;
										 	 <xsl:for-each select="./CorrectSubOptionSeqList/CorrectSubOptionSeq">
										 	 	<xsl:value-of select="."></xsl:value-of>
										 	 	 <xsl:if test="position() != last()">,</xsl:if>
										 	 </xsl:for-each>
										</fo:block>
									</fo:table-cell>
									
									
									<fo:table-cell text-align="left"  xsl:use-attribute-sets="myBorder">
										
											<xsl:choose>
												
												<xsl:when test="subItemCorrectInCorrect='true' ">
													<fo:block xsl:use-attribute-sets="blueBoldtext">
														<xsl:value-of select="f:getProperty('attemptReport.attemptedOption')" />
														&#160;
														 <xsl:for-each select="./AttemptedSubOptionSeqList/AttemptedSubOptionSeq">
										 	 				<xsl:value-of select="."></xsl:value-of>
										 	 				 <xsl:if test="position() != last()">,</xsl:if>
										 	 			</xsl:for-each>
										 	 			
										 	 			&#160; &#160;
										 	 			<xsl:value-of select="f:getProperty('attemptReport.attemptedOptionID')"/>
														&#160;
										 	 			<xsl:for-each select="./AttemptedSubOptionIDList/AttemptedSubOptionID">
									 	 					<xsl:value-of select="."></xsl:value-of>
									 	 					 <xsl:if test="position() != last()">,</xsl:if>
										 	 			</xsl:for-each>
										 	 			
													</fo:block>
												</xsl:when>
												
												<xsl:otherwise>
													
													
													<xsl:choose>
													<xsl:when test="not(attemptedOptSeq='null') and AttemptedSubOptionSeqList/AttemptedSubOptionSeq">
													<fo:block xsl:use-attribute-sets="redBoldtext">
														<xsl:value-of select="f:getProperty('attemptReport.attemptedOption')" />
														&#160;
														<xsl:for-each select="./AttemptedSubOptionSeqList/AttemptedSubOptionSeq">
									 	 					<xsl:value-of select="."></xsl:value-of>
									 	 					 <xsl:if test="position() != last()">,</xsl:if>
										 	 			</xsl:for-each>
										 	 		
										 	 			&#160; &#160;
										 	 			<xsl:value-of select="f:getProperty('attemptReport.attemptedOptionID')"/>
														&#160;
										 	 			<xsl:for-each select="./AttemptedSubOptionIDList/AttemptedSubOptionID">
									 	 					<xsl:value-of select="."></xsl:value-of>
									 	 					 <xsl:if test="position() != last()">,</xsl:if>
										 	 			</xsl:for-each>
										 	 			
										 	 			
										 	 		</fo:block>
													</xsl:when>
														
													<xsl:otherwise>
														<fo:block xsl:use-attribute-sets="boldtext">
															<xsl:value-of select="f:getProperty('attemptReport.notAttempted')" />
														 </fo:block>
													</xsl:otherwise>
													
													</xsl:choose>
													
													
												</xsl:otherwise>
												
											</xsl:choose>
											
									</fo:table-cell>
								</fo:table-row>
											
										</xsl:if>
										
									</xsl:for-each>
								</xsl:if>
							
						</xsl:for-each>
							
							</fo:table-body>
						</fo:table>
						
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