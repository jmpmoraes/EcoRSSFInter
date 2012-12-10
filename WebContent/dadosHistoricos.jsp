<html>
<head>

<%@ page import="java.security.*"%>
<%@ page import="java.math.BigInteger"%>

<%@ page import="java.net.*"%>

<%@ page import="java.util.*"%>

<%@ page import="java.text.*"%>

<%@ page import="java.io.*"%>
<%@ page import="org.json.simple.*"%>

<%@ page import="org.json.simple.parser.*"%>

<%



boolean erroDifDatas = false;
boolean erroDatas = false;

int interator = 0;
JSONArray listaArray = null;
String auxHist = request.getParameter("aux_hist");
String auxDI = request.getParameter("dt_inicio");
String auxDF = request.getParameter("dt_fim");

String urlstrSensor = "http://localhost:8080/EcoRSSFWS/rest/sensores/list";
String respostaSensor = "0";

String idSensor = "01";

try {
	URL url = new URL(urlstrSensor);

	URLConnection fbconn = url.openConnection();
	InputStream io_stream_server = fbconn.getInputStream();
	BufferedReader responseWS = new BufferedReader(
			new InputStreamReader(io_stream_server, "UTF-8"));

	respostaSensor = responseWS.readLine();



}

catch (Exception e) {
	throw new Exception();
}

//Parse da resposta
Object listaParse = JSONValue.parse(respostaSensor);

JSONArray sensorArray = (JSONArray) listaParse;




if(auxHist != null){
	
	if( auxDI.equals("") || auxDF.equals("")){
		erroDatas = true;
	}
	
	if(!erroDatas){
	String aux = request.getParameter("dt_inicio");
	String aux0 = aux.substring(2,3);
	
	if(!aux0.equals("/")){
		aux = "0" + aux;
	}
	
	String aux1 = aux.substring(0, 5);
	String aux2 = aux.substring(6, aux.length()) ;
	String aux3 = aux1.substring(0,2);
	String aux4 = aux1.substring(3, 5);
	
	String date = aux4+"/"+aux3+"/"+aux2;
		Date startDate = (new Date(date));
		
	aux = request.getParameter("dt_fim");
	
	aux0 = aux.substring(2,3);
	
	if(!aux0.equals("/")){
		aux = "0" + aux;
	}
	
	aux1 = aux.substring(0, 5);
	aux2 = aux.substring(6, aux.length()) ;
	aux3 = aux1.substring(0,2);
	aux4 = aux1.substring(3, 5);
	
	date = aux4+"/"+aux3+"/"+aux2;
	
	idSensor = request.getParameter("optSensor");
	
	Date endDate = (new Date(date));
	if(endDate.getTime() > startDate.getTime()){
		
	String urlstr = "http://localhost:8080/EcoRSSFWS/rest/dados/range/" + idSensor + "&" + startDate.getTime() + "&" + endDate.getTime();
	String resposta = "0";
	try {
		URL url = new URL(urlstr);

		URLConnection fbconn = url.openConnection();
		InputStream io_stream_server = fbconn.getInputStream();
		BufferedReader responseWS = new BufferedReader(
				new InputStreamReader(io_stream_server, "UTF-8"));

		resposta = responseWS.readLine();


	}

	catch (Exception e) {
		throw new Exception();
	}

	//Parse da resposta
	Object listaParseRes = JSONValue.parse(resposta);
	
	listaArray = (JSONArray) listaParseRes;
	}else
		erroDifDatas = true;
	
	
	
	
	
	}
	
}
%>


<script type="text/javascript" src="./js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="./js/highcharts.js"></script>
<script type="text/javascript" src="./js/datetimepicker.js"></script>
<script type="text/javascript" src="./js/exporting.js"></script>

<script type="text/javascript">
	var global;
	var opt;

	function reloadPage() {
		opt = $('select[name="optSensor"]').val();
		location.reload();
		document.getElementById("optSensor").value = opt;
	}



	

	$(function loadChart() {
		Highcharts.setOptions({
			global : {
				useUTC : false
			}
		});

		var chart;
		chart = new Highcharts.Chart({
			chart : {
				renderTo : 'grafico',
				type : 'spline',
				marginRight : 10,
				events : {
					load : function() {


					}
				}
			},
			title : {
				text : 'Grafico de Luminosidade - Sensor  '  + <%= idSensor %> 
			},
			xAxis : {
				type : 'datetime',
				tickPixelInterval : 150
			},
			yAxis : {
				title : {
					text : 'Valor (lm)'
				},
				plotLines : [ {
					value : 0,
					width : 1,
					color : '#808080'
				} ]
			},
			tooltip : {
				formatter : function() {
					return '<b>'
							+ this.series.name
							+ '</b><br/>'
							+ Highcharts
									.dateFormat('%Y-%m-%d %H:%M:%S', this.x)
							+ '<br/>' + Highcharts.numberFormat(this.y, 2);
				}
			},
			legend : {
				enabled : false
			},
			exporting : {
				enabled : true
			},
			series : [ {
				name : 'Serie de Dados - Sensor '
						+ $('select[name="optSensor"]').val(),
				data : data = (function() {
					// generate an array of random data
					var data = [], time = (new Date()).getTime(), i;
					
				
					
					<% if(auxHist != null && erroDatas == false && erroDifDatas == false){ 
							try{
								if(listaArray.size() > 999){
									for(int i = - 999 ; i < 0; i++) { 
										
										
										JSONObject linha = (JSONObject) listaArray.get(interator);
										interator++;
										%>
										
										data.push({
										x : <%= linha.get("timeTicks") %>,
										y : <%= linha.get("value")%>
										});
										
							<%			
			
										}
									%>
									alert("A busca retornou mais de 1000 linhas. Foram utilizados os 1000 primeiros retornos para montar o grafico.");
									<%
									
								}
								else{
									for(int i = - listaArray.size() ; i < 0; i++) { 
								
								
									JSONObject linha = (JSONObject) listaArray.get(interator);
									interator++;
									%>
									
									data.push({
									x : <%= linha.get("timeTicks") %>,
									y : <%= linha.get("value")%>
									});
									
						<%			
		
									}
								}
							} catch(Exception e){	
								e.printStackTrace();
							
							}
					}else{
						
					if(erroDatas == true){
						%>
						alert("Preencha ambos os campos de data.");
						<%
					}
					
					if(erroDifDatas == true){
						%>
						alert("A data inicial e posterior que a data final.");
						<%}	%>
						
					for (j = -19; j <= 0; j++) {
						data.push({
							x : time + j * 1000,
							y : 0
						});
					}
					
					
				<%} %>
				return data;				
				})()
			} ]
		});
	});

	$(document).ready(loadChart());
</script>


<!-- Header -->
<jsp:include page="header.jsp" />
<body>
	<!-- Topo do Body -->
	<jsp:include page="bodyHeader.jsp" />



	<!-- side-navigation: lista de botoes que compoem o menu lateral -->
	<div ID="side-navigation">
		<jsp:include page="menuLateral.jsp" />
	</div>





	<!-- main: tela principal -->
	<div ID="mainSite" style="padding-left: 22%; padding-top: 7%">

		<p style="color: black; font-size: 30px;">Dados Hist&oacute;ricos</p>
		<br> <br>
		<form>
			<p>Este gr&aacute;fico apresenta a medi&ccedil;&atilde;o de um
				dado sensor, dentro de um per&iacute;odo de tempo.</p>
			<br>
			<p>
				Escolha o Sensor <select id="optSensor" name="optSensor">
					<%for(int i = 0; i < sensorArray.size(); i++){ 
					JSONObject sensorLinha = (JSONObject) sensorArray.get(i);
					%>
					<option><%=sensorLinha.get("id")  %></option>
					<%} %>
				</select>


			</p>
			<br>
			<table class="editTable">
				<tr>
					<td>In&iacute;cio:</td>
					<td><input type="Text" id="dt_inicio" name="dt_inicio"
						maxlength="25" size="25" onclick="javascript:alert('Utilize o Calendario ao lado.')"><a
						href="javascript:NewCal('dt_inicio','ddmmyyyy',true,24)"><img
							src="./images/cal.gif" width="16" height="16" border="0"
							alt="Pick a date" style="margin-left: 5px;"></a></td>
				</tr>
				<tr>
					<td>Fim:</td>
					<td><input type="Text" id="dt_fim" name="dt_fim"
						maxlength="25" size="25" onclick="javascript:alert('Utilize o Calendario ao lado.')"><a
						href="javascript:NewCal('dt_fim','ddmmyyyy',true,24)"><img
							src="./images/cal.gif" width="16" height="16" border="0"
							alt="Pick a date" style="margin-left: 5px;"></a></td>
				</tr>


			</table>
			<br> <input type="hidden" value="1" id="aux_hist" name="aux_hist"> 
				<input type="submit" value="Gerar Relat&oacute;rio" id="dt_range" style="padding: 1px" maxlength="25" size="25">
		</form>


		<br> <br>
		<div ID="grafico"
			style="max-width: 80%; min-width: 400px; height: 400px; margin: 0 auto"></div>

	</div>
	<!-- #main: end -->



</body>
</head>
</html>
