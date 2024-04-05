<%@page contentType="text/html;charset=UTF-8"%>
<!-- <style>
.modal-backdrop{
background:transparent;}
</style> -->
<div id="keyPad" class="ui-widget-content calc_container">
	<!-- new Help changes -->
	<div id="helptopDiv" class="dark-blue">
		<span><spring:message code="getCalculator.scientificCalculator"/></span>
		<!-- <div  id="keyPad_Help" class="help_back"></div>
		<div style="display: none;"  id="keyPad_Helpback"
			class="help_back"></div> -->
	</div>
	<!-- new Help changes -->
	<div class="calc_min" id="calc_min" data-dismiss="modal" aria-label="Close"></div>
     <!-- <div class="calc_max hide" id="calc_max"></div> -->
	 <div class="calc_close" id="closeButton" data-dismiss="modal" aria-label="Close"></div>
	<!-- <div class="calc_close" id="closeButton">
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div> -->
	<!-- main content start here-->
	<div id="mainContentArea">
		<input type="text" id="keyPad_UserInput1" class="keyPad_TextBox1"
			readonly="">
		<div class="text_container">
			<input type="text" id="keyPad_UserInput" class="keyPad_TextBox"
				maxlength="30" readonly=""> <span id="memory"
				class="memoryhide"><font size="2">M</font></span><font size="2">
			</font>
		</div>
		<font size="2">
			<div class="clear"></div>
			<div class="left_sec">
				<div class="calc_row clear">
					<a  id="keyPad_btnMod" class="keyPad_btnBinaryOp">mod</a>
					<div class="degree_radian">
						<input type="radio" name="degree_or_radian" value="deg"
							checked="checked">Deg <input type="radio"
							name="degree_or_radian" value="rad">Rad
					</div>
					<a  id="keyPad_btnPi" class="keyPad_btnConst"
						style="visibility: hidden;">π</a> <a  id="keyPad_btnE"
						class="keyPad_btnConst" style="visibility: hidden;">e</a> <a
						 id="keyPad_btnE" class="keyPad_btnConst"
						style="visibility: hidden;">e</a> <a  id="keyPad_MC"
						class="keyPad_btnMemoryOp">MC</a> <a  id="keyPad_MR"
						class="keyPad_btnMemoryOp">MR</a> <a  id="keyPad_MS"
						class="keyPad_btnMemoryOp">MS</a> <a  id="keyPad_M+"
						class="keyPad_btnMemoryOp">M+</a> <a  id="keyPad_M-"
						class="keyPad_btnMemoryOp">M-</a>

				</div>
				<div class="calc_row clear">
					<a  id="keyPad_btnSinH" class="keyPad_btnUnaryOp min">sinh</a>
					<a  id="keyPad_btnCosinH" class="keyPad_btnUnaryOp min">cosh</a>
					<a  id="keyPad_btnTgH" class="keyPad_btnUnaryOp min">tanh</a>
					<a  id="keyPad_EXP" class="keyPad_btnBinaryOp">Exp</a>
					<a  id="keyPad_btnOpen" class="keyPad_btnBinaryOp ">(</a>
					<a  id="keyPad_btnClose" class="keyPad_btnBinaryOp ">)</a>
					<a  id="keyPad_btnBack"
						class="keyPad_btnCommand calc_arrows">
						<div style="position: relative; top: -3px">←</div>
					</a> <a id="keyPad_btnAllClr" class="keyPad_btnCommand">C</a>
					<a  id="keyPad_btnInverseSign"
						class="keyPad_btnUnaryOp">+/-</a> <a 
						id="keyPad_btnSquareRoot" class="keyPad_btnUnaryOp">
						<div style="position: relative; top: 1px">√</div>
					</a>
				</div>
				<div class="calc_row clear" style="margin-top: 5px;">
					<a  id="keyPad_btnAsinH" class="keyPad_btnUnaryOp min "><span
						class="baseele">sinh</span><span class="superscript">-1</span></a> <a
						 id="keyPad_btnAcosH" class="keyPad_btnUnaryOp min "><span
						class="baseele">cosh</span><span class="superscript">-1</span></a> <a
						 id="keyPad_btnAtanH" class="keyPad_btnUnaryOp min "><span
						class="baseele">tanh</span><span class="superscript">-1</span></a> <a
						 id="keyPad_btnLogBase2" class="keyPad_btnUnaryOp"><span
						class="baseele">log</span><span class="subscript">2</span><span
						class="baseele">x</span></a> <a  id="keyPad_btnLn"
						class="keyPad_btnUnaryOp">ln</a> <a  id="keyPad_btnLg"
						class="keyPad_btnUnaryOp">log</a> <a  id="keyPad_btn7"
						class="keyPad_btnNumeric">7</a> <a  id="keyPad_btn8"
						class="keyPad_btnNumeric">8</a> <a  id="keyPad_btn9"
						class="keyPad_btnNumeric ">9</a> <a 
						id="keyPad_btnDiv" class="keyPad_btnBinaryOp">/</a> <a
						 id="keyPad_%" class="keyPad_btnBinaryOp">%</a>
				</div>
				<div class="calc_row clear">
					<a  id="keyPad_btnPi" class="keyPad_btnConst">π</a> <a
						 id="keyPad_btnE" class="keyPad_btnConst">e</a> <a
						 id="keyPad_btnFact" class="keyPad_btnUnaryOp">n!</a>
					<a  id="keyPad_btnYlogX" class="keyPad_btnBinaryOp "><span
						class="baseele">log</span><span class="subscript">y</span><span
						class="baseele">x</span></a> <a  id="keyPad_btnExp"
						class="keyPad_btnUnaryOp"><span class="baseele">e</span><span
						class="superscript">x</span></a> <a  id="keyPad_btn10X"
						class="keyPad_btnUnaryOp"><span class="baseele">10</span><span
						class="superscript">x</span></a> <a  id="keyPad_btn4"
						class="keyPad_btnNumeric">4</a> <a  id="keyPad_btn5"
						class="keyPad_btnNumeric">5</a> <a  id="keyPad_btn6"
						class="keyPad_btnNumeric ">6</a> <a 
						id="keyPad_btnMult" class="keyPad_btnBinaryOp"><div
							style="position: relative; top: 3px; font-size: 20px">*</div></a> <a
						 id="keyPad_btnInverse" class="keyPad_btnUnaryOp"><span
						class="baseele">1/x</span></a>
				</div>
				<div class="calc_row clear">
					<a  id="keyPad_btnSin" class="keyPad_btnUnaryOp min ">sin</a>
					<a  id="keyPad_btnCosin" class="keyPad_btnUnaryOp min">cos</a>
					<a  id="keyPad_btnTg" class="keyPad_btnUnaryOp min">tan</a>
					<a  id="keyPad_btnYpowX" class="keyPad_btnBinaryOp"><span
						class="baseele">x</span><span class="superscript">y</span></a> <a
						 id="keyPad_btnCube" class="keyPad_btnUnaryOp"><span
						class="baseele">x</span><span class="superscript">3</span></a> <a
						 id="keyPad_btnSquare" class="keyPad_btnUnaryOp"><span
						class="baseele">x</span><span class="superscript">2</span></a> <a
						 id="keyPad_btn1" class="keyPad_btnNumeric">1</a> <a
						 id="keyPad_btn2" class="keyPad_btnNumeric">2</a> <a
						 id="keyPad_btn3" class="keyPad_btnNumeric">3</a> <a
						 id="keyPad_btnMinus" class="keyPad_btnBinaryOp"><div
							style="position: relative; top: -1px; font-size: 20px">-</div></a>
				</div>
				<div class="calc_row clear">
					<a  id="keyPad_btnAsin" class="keyPad_btnUnaryOp min"><span
						class="baseele">sin</span><span class="superscript">-1</span></a> <a
						 id="keyPad_btnAcos" class="keyPad_btnUnaryOp min"><span
						class="baseele">cos</span><span class="superscript">-1</span></a> <a
						 id="keyPad_btnAtan" class="keyPad_btnUnaryOp min"><span
						class="baseele">tan</span><span class="superscript">-1</span></a> <a
						 id="keyPad_btnYrootX" class="keyPad_btnBinaryOp"><span
						class="superscript" style="top: -8px;">y</span><span
						class="baseele" style="font-size: 1.2em; margin: -6px 0 0 -9px;">√x</span></a>
					<a  id="keyPad_btnCubeRoot" class="keyPad_btnUnaryOp"><font
						size="3">∛ </font></a> <a  id="keyPad_btnAbs"
						class="keyPad_btnUnaryOp"><span class="baseele">|x|</span></a> <a
						 id="keyPad_btn0" class="keyPad_btnNumeric">0</a> <a
						 id="keyPad_btnDot" class="keyPad_btnNumeric ">.</a> <a
						 id="keyPad_btnPlus" class="keyPad_btnBinaryOp">+</a>
					<a  id="keyPad_btnEnter" class="keyPad_btnCommand "><div
							style="margin-bottom: 2px;">=</div></a>
				</div>
			</div>
			<div class="clear"></div> <!-- new Help changes -->
			<div id="helpContent" onmousedown="return false"
				style="display: none;">
				<h3 style="text-align: center;">
					<strong><spring:message code="calculator.instructions" /></strong>
				</h3>
				<spring:message code="calculator.getCalculatorInformation" /> <br> 
				<spring:message code="calculator.operateCalculator" />
				<br> <br>
				<h3 style="text-decoration: underline; color: green"><spring:message code="calculator.do's" /></h3>
				<ul>
					<li><spring:message code="calculator.pressCnewCalculation" /></li>
					<li><spring:message code="calculator.equationUsing" /></li>
					<li><spring:message code="calculator.usePredefinedOperations" /></li>
					<li><spring:message code="calculator.useMemoryFunction" /></li>
					<strong> <spring:message code="calculator.valueToMemory" /> <br>
						<spring:message code="calculator.storedInMemory" /> <br> <spring:message code="calculator.valueFromMemory" />
					</strong>
					<li><spring:message code="calculator.angleUnit" /></li>
					<strong><spring:message code="calculator.note" /></strong>
				</ul>
				<h3>
					<span style="text-decoration: underline; color: red"><spring:message code="calculator.dont's" /></span>
				</h3>
				<ul>
					<li><spring:message code="calculator.multiOperations" /></li>
					<li><spring:message code="calculator.leaveParenthesis" /></li>
					<li><spring:message code="calculator.changeAngleUnit" /></li>
				</ul>
				<h3>
					<span style="text-decoration: underline;"><spring:message code="calculator.limitations" /></span>
				</h3>
				<ul>
					<li><spring:message code="calculator.operationDisabled" /></li>
					<li><spring:message code="calculator.factCalculation14Digits" /></li>
					<li><spring:message code="calculator.logarithmicCalculation5Digits" /></li>
					<li><spring:message code="calculator.modulusWith15Digits" /></li>
					<br>
					<strong> <spring:message code="calculator.modOperation" /></strong>
					<br>
					<li><spring:message code="calculator.valueSupported" /></li>
				</ul>
				<br> <br>
			</div> <!-- new Help changes --> <!-- main content end here-->
		</font>
	</div>
	<font size="2"> </font>
</div>
<font size="2"> </font>