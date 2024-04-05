<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:f="Functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:variable name="lang" select="groupReportPDFData/locale" />
	<xsl:variable name="properties" select="unparsed-text($lang)"
		as="xs:string" />



	<xsl:attribute-set name="myBorder">
		<xsl:attribute name="border">solid 0.3mm gray</xsl:attribute>		
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

	
	<xsl:template match="groupReportPDFData">
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
						<fo:table-column column-number="2" />
						<!-- <fo:table-column column-number="3" /> -->
						<fo:table-body>
							<fo:table-row keep-together.within-column="always">

								<fo:table-cell text-align="left">
									<fo:block xsl:use-attribute-sets="normaltext">
										<xsl:value-of select="examEventName" />
									</fo:block>
								</fo:table-cell>
								<!-- <fo:table-cell text-align="center"> <fo:block xsl:use-attribute-sets="normaltext"> 
									<fo:basic-link external-destination="http://www.mkcl.org" text-decoration="underline" 
									color="blue">www.mkcl.org </fo:basic-link> </fo:block> </fo:table-cell> -->
								<fo:table-cell text-align="right">
										<xsl:if test="locale = 'messages_ar.properties'">
	                         <xsl:attribute name="text-align">left</xsl:attribute>
                                     </xsl:if>
									<fo:block xsl:use-attribute-sets="normaltext" >

										<fo:block xsl:use-attribute-sets="normaltext" >
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
						<fo:table-column column-number="2" />
						<!-- <fo:table-column column-number="3" /> -->
						<fo:table-body>
							<fo:table-row keep-together.within-column="always">

								<fo:table-cell text-align="left">
									<fo:block xsl:use-attribute-sets="normaltext">										
										<xsl:value-of select="examEventName" /> 
									</fo:block>
								</fo:table-cell>
								<!-- <fo:table-cell text-align="center"> <fo:block xsl:use-attribute-sets="normaltext"> 
									<fo:basic-link external-destination="http://www.mkcl.org" text-decoration="underline" 
									color="blue">www.mkcl.org </fo:basic-link> </fo:block> </fo:table-cell> -->
								<fo:table-cell text-align="right">
									<fo:block xsl:use-attribute-sets="normaltext"
										text-align="right">
	<xsl:if test="locale = 'messages_ar.properties'">
	<xsl:attribute name="text-align">left</xsl:attribute>
</xsl:if>
										<fo:block xsl:use-attribute-sets="normaltext">
											<fo:page-number />
											<xsl:value-of select="f:getProperty('global.pagination.of')" />
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
			
				<xsl:for-each select="./listofgroupPDFData/groupReportViewModelData">	 
				
				<fo:block break-before="page">			
				
				
					<xsl:if test="position() = 1">
					<fo:block 
						text-align="center" xsl:use-attribute-sets="boldtext" font-size="14pt">
			 	<xsl:value-of select="f:getProperty('GroupReport.header')"></xsl:value-of>	 	
					  </fo:block>
					</xsl:if>	
				
				  <xsl:variable name="scheduleStartDatevar" select="scheduleStartDate"/> 
				  <xsl:variable name="collectionTypevar" select="collectionType"/>    
				
			  
						<!-- Candidate details table -->
						<fo:table space-before="0.5cm">

							<fo:table-column column-number="1" column-width="10%" />
							<fo:table-column column-number="2" column-width="20%" />
							<fo:table-column column-number="3" />
							<fo:table-column column-number="4" />
							<fo:table-column column-number="5" />						
							

							<fo:table-body>
							
							   <fo:table-row keep-together.within-column="always">
							   <fo:table-cell xsl:use-attribute-sets="myBorder"  text-align="center">							 
							    <xsl:attribute name="number-columns-spanned"><xsl:value-of select="'5'"/></xsl:attribute> 								    									  
										<fo:block xsl:use-attribute-sets="boldtext">
										<xsl:attribute name="font-size">14pt</xsl:attribute>
								<xsl:value-of select="f:getProperty('GroupReport.grouploginfor')"/>		
								&#160; <xsl:value-of select="$scheduleStartDatevar"></xsl:value-of>
										</fo:block>
								</fo:table-cell>
							   
							   </fo:table-row>									
				
							
				       <xsl:for-each select="./listofcollectionPDFData/collectionPDFData">
				       
				                                  
                           <xsl:variable name="collectionNamevar" select="collectionName"/>                           
                    	   <xsl:variable name="noOfCollectionCandidatevar" select="noOfCollectionCandidate"/>     
                    	   
				               <xsl:choose>
                                 <xsl:when test="$collectionTypevar!='None'">
                                  <fo:table-row keep-together.within-column="always">
                                 <fo:table-cell xsl:use-attribute-sets="myBorder" >
                            	 <xsl:attribute name="number-columns-spanned"><xsl:value-of select="'5'"/></xsl:attribute> 				  
												<fo:block xsl:use-attribute-sets="normaltext" display-align="center">
										<xsl:if test="$collectionTypevar = 'Division'">		
										 <xsl:value-of select="f:getProperty('groupLoginPage.Division')"/>  :	<xsl:value-of select="$collectionNamevar"></xsl:value-of>								
										</xsl:if>
										<xsl:if test="$collectionTypevar = 'Batch'">		
										 <xsl:value-of select="f:getProperty('groupLoginPage.Batch')"/>  :	 <xsl:value-of select="$collectionNamevar"></xsl:value-of>								
										</xsl:if>												
																			
												</fo:block>
								</fo:table-cell>    
								</fo:table-row>                         
                                 </xsl:when>
                                 </xsl:choose>    			       
				       
                                 
                              <xsl:if test="position() = 1">   
                                  <!-- 1st Row -->
								<fo:table-row keep-together.within-column="always">

									<!-- serial number cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext" >
										<xsl:value-of select="f:getProperty('GroupReport.srno')"/>
										</fo:block>
									</fo:table-cell>                                   
									
									<!-- 2rd cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
										<xsl:value-of select="f:getProperty('GroupReport.groupName')"/>
										</fo:block>
									</fo:table-cell>
									
									<!-- 3th cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
										<xsl:value-of select="f:getProperty('GroupReport.candidateName')"/>
										</fo:block>
									</fo:table-cell>
									
									<!-- 4th cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
										<xsl:value-of select="f:getProperty('GroupReport.loginId')"/>
										</fo:block>
									</fo:table-cell>
									
									<!-- 5th cell -->
									<fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="boldtext">
										<xsl:value-of select="f:getProperty('GroupReport.candidatephoto')"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row> 
                           </xsl:if>                   
                       
                         
                       
                          
                       <xsl:for-each select="./listofgroupMasterPDFData/groupMasterPDFData">     
                                
                         
                    	   <xsl:variable name="groupNamevar" select="groupName"/>
                    	   <xsl:variable name="noOfCandiatevar" select="noOFCandidate"/>
                    	    <xsl:variable name="firstGroupvar" select="firstGroup"/>                           
                           
                                                                           	 
                            <xsl:for-each select="./listcandidatePDFData/candiatePDFData" >                        
                       
                               
                               <xsl:variable name="grouplevel1Count" select="position()"/>      
                              	
                              
                               	<fo:table-row keep-together.within-column="always">        	
                               	
                               	      
                                <fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="candidateID"></xsl:value-of>
											</fo:block>
								</fo:table-cell>    
                       		       <xsl:choose>
                                   <xsl:when test=" $grouplevel1Count= 1">
									 <fo:table-cell xsl:use-attribute-sets="myBorder" >
									  <xsl:attribute name="number-rows-spanned"><xsl:value-of select="$noOfCandiatevar"/></xsl:attribute>									 
											<fo:block xsl:use-attribute-sets="normaltext">											
												<xsl:value-of select="$groupNamevar"></xsl:value-of>
											</fo:block>
								    </fo:table-cell>
								    </xsl:when>
								    </xsl:choose>
								
                               
                                 
								       <fo:table-cell xsl:use-attribute-sets="myBorder">
										<fo:block xsl:use-attribute-sets="normaltext">
										
										<fo:inline padding-right="1mm">
										<xsl:value-of select="candidateFirstName"></xsl:value-of>
										</fo:inline>						

										<fo:inline padding-right="1mm">
											<xsl:value-of select="candidateLastName"></xsl:value-of>
										</fo:inline>
											</fo:block>
										</fo:table-cell>											

										
										<fo:table-cell xsl:use-attribute-sets="myBorder">
											<fo:block xsl:use-attribute-sets="normaltext">
												<xsl:value-of select="candidateUserName"></xsl:value-of>
											</fo:block>
										</fo:table-cell>	
										<fo:table-cell xsl:use-attribute-sets="myBorder">									
									    <fo:block xsl:use-attribute-sets="normaltext">										
											<xsl:variable name="photo" select="candidatePhoto"></xsl:variable>										
											<xsl:choose>
											<xsl:when test="string(normalize-space($photo))">																			
											<fo:external-graphic src="url('{candidatePhoto}')" content-height="scale-to-fit"
												content-width="1.0583333cm" height="1.0583333cm" scaling="non-uniform" >
											</fo:external-graphic>
										
											</xsl:when>
											<xsl:otherwise>
											<fo:block xsl:use-attribute-sets="normaltext">											
											<xsl:value-of select="f:getProperty('noImageFound.msgOnPDF')"/>
											</fo:block>
											</xsl:otherwise>
											</xsl:choose>											
										</fo:block>	
										</fo:table-cell>												 
								 
								 
								  </fo:table-row>
								  </xsl:for-each><!-- Candidate loop -->							  
								  </xsl:for-each><!-- Group loop -->	  
								  
								                              
                                  </xsl:for-each><!-- Collection loop -->						

								<!-- end of loop -->

							</fo:table-body>
						</fo:table>
					</fo:block>
					</xsl:for-each> <!-- Schedule loop -->
						<!-- End of Candidate details table -->
					
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