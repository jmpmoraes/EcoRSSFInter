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

String urlstrSensor = "http://localhost:8080/EcoRSSFWS/rest/sensores/list";
String respostaSensor = "0";

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


%>

<script type="text/javascript" src="./js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="./js/highcharts.js"></script>



<script type="text/javascript">

var global;
var opt;

function reloadPage() {
	opt = $('select[name="optSensor"]').val();
	location.reload();
	document.getElementById("optSensor").value = opt;
}

function getLastSensorData(idSensor) {
	$.ajax({ 
		type: 'GET', 
		url: "http://localhost:8080/EcoRSSFWS/rest/dados/last/" + idSensor, 
		dataType: 'json',
		success: function (data) {
			global = data;
		}
		
	});
}

$(function loadChart() {
        Highcharts.setOptions({
            global: {
                useUTC: false
            }
        });
    
        var chart;
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'grafico',
                type: 'spline',
                marginRight: 10,
                events: {
                    load: function() {
    
                        // set up the updating of the chart each second
                        var series = this.series[0];
                        setInterval(function() {
                        	getLastSensorData($('select[name="optSensor"]').val());
                            var x = global.timeTicks; // current time
                                /* y = Math.random(); */
                                y = global.value;
                            series.addPoint([x, y], true, true);
                        }, 5000);
                    }
                }
            },
            title: {
                text: 'Grafico de Luminosidade'
            },
            xAxis: {
                type: 'datetime',
                tickPixelInterval: 150
            },
            yAxis: {
                title: {
                    text: 'Valor (lm)'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                formatter: function() {
                        return '<b>'+ this.series.name +'</b><br/>'+
                        Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) +'<br/>'+
                        Highcharts.numberFormat(this.y, 2);
                }
            },
            legend: {
                enabled: false
            },
            exporting: {
                enabled: false
            },
            series: [{
                name: 'Serie de Dados - Sensor ' + $('select[name="optSensor"]').val(),
                data: data = (function() {
                    // generate an array of random data
                    var data = [],
                        time = (new Date()).getTime(),
                        i;
    
                    for (i = -19; i <= 0; i++) {
                        data.push({
                            x: time + i * 1000,
                            y: 0
                        });
                    }
                    return data;
                })()
            }]
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
	
			<p style="color: black; font-size: 30px;">Monitora&ccedil;&atilde;o em Tempo Real</p>
		<br><br>
		<p>Este gr&aacute;fico apresenta a medi&ccedil;&atilde;o, em tempo real, do sensor selecionado abaixo.</p><br>
		<p>				Escolha o Sensor </p><select id="optSensor" name="optSensor" onchange="reloadPage();">
					<%for(int i = 0; i < sensorArray.size(); i++){ 
					JSONObject sensorLinha = (JSONObject) sensorArray.get(i);
					%>
					<option value="01"><%=sensorLinha.get("id")  %></option>
					<%} %>
				</select>
			<br><br>
	<div ID="grafico" style="max-width:80%; min-width: 400px; height: 400px; margin: 0 auto"></div>

	</div>
	<!-- #main: end -->
	

	
</body>
</head>
</html>