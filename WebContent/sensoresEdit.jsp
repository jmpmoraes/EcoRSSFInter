<html>
<head>

<%@ page import="java.security.*"%>
<%@ page import="java.math.BigInteger"%>

<%@ page import="java.net.*"%>


<%@ page import="java.io.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>

<%
	Object obj = request.getSession().getAttribute("admin");
	if(obj != "true") 
		pageContext.forward("./permissaoFail.jsp");

	String formId = "";
	String formMinValue = "";
	String formMaxValue = "";
	String formInfo = "";
	boolean formStatus = true;
	
	String aux = request.getParameter("aux_sensor");
	String aux2 = request.getParameter("id");
	
	String resposta = "0";
	
	if (aux == null) {
		
		if(aux2 == null){
			aux2 ="";
		}
		else{
		String urlstr = "http://localhost:8080/EcoRSSFWS/rest/sensores/get/"
				+ aux2;
	
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
		
		Object listaParse = JSONValue.parse(resposta);
		JSONObject sensor = (JSONObject) listaParse;
		
		formId = sensor.get("id").toString();
		formMaxValue = sensor.get("maxValue").toString();
		formMinValue = sensor.get("minValue").toString();
		formInfo = sensor.get("info").toString();
		
		
		if (sensor.get("status").equals(true))
			formStatus = true;
		else
			formStatus = false;

		}
	}
	else{

		String infoText = request.getParameter("infoSub");
		infoText = infoText.replace(" ", "%20");
		
		String urlstrSave = "http://localhost:8080/EcoRSSFWS/rest/sensores/save/"
				+ request.getParameter("idSub") + "&"
				+ request.getParameter("maxValueSub") + "&"
				+ request.getParameter("minValueSub") + "&"
				+ infoText + "&"
				+ request.getParameter("statusSub");
		
		try {
			URL url = new URL(urlstrSave);
			URLConnection fbconn = url.openConnection();
			InputStream io_stream_server = fbconn.getInputStream();
			BufferedReader responseWS = new BufferedReader(
					new InputStreamReader(io_stream_server, "UTF-8"));

			resposta = responseWS.readLine();
		}

		catch (Exception e) {
			throw new Exception();
		}
		pageContext.forward("./redirectSensor.jsp");
	}	
%>


<script type="text/javascript" src="./js/jquery-1.8.3.min.js"></script>

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
	<div ID="mainSite" style="padding-left: 20%; padding-top: 7%">


		<p style="color: black; font-size: 30px;">Edi&ccedil;&atilde;o de
			Sensores</p>
		<br>

		<form>
			<table class="editTable">
				<tr>
					<td style="">N&uacute;mero do Sensor:</td>
					<td><input type="text" name="idSub" value="<%=formId%>" required="required"></td>
				</tr>



				<tr>
					<td>Limite Monitorado - Inferior:</td>
					<td><input type="text" name="minValueSub"
						value="<%=formMinValue%>"></td>

				</tr>

				<tr>
					<td>Limite Monitorado - Superior:</td>
					<td><input type="text" name="maxValueSub"
						value="<%=formMaxValue%>"></td>

				</tr>

				<!-- 				<tr> -->
				<!-- 				<td>Monitora&ccedil;&atilde;o Habilitada:</td> <td><input type="checkbox" -->
				<!-- 						name="b_limite"></td> -->

				<!-- 				</tr> -->




				<tr>
					<td>Status:</td>
					<td><select name="statusSub">
							<option <%if(formStatus==true){%>selected="selected"<%}%>>Ativo</option>
							<option <%if(formStatus==false){%>selected="selected"<%}%>>Desativado</option>
					</select></td>
				</tr>

				<tr>
					<td>Informa&ccedil;&otilde;es:</td>
					<td><textarea name="infoSub" 
							style="width: 300px; height: 80px"><%=formInfo%></textarea></td>

				</tr>

			</table>
			<input type="hidden" value="<%=formId%>" id="id" name="id">
			<input type="hidden" value="1" id="aux_sensor" name="aux_sensor">
			<br /> <a href="sensoresLista.jsp"><input type="button"
				value="Cancelar" style="margin-left: 15%; padding: 1px"></a> <input
				type="submit" value="Enviar" style="margin-left: 59%; padding: 1px">
		</form>


	</div>
	<!-- #main: end -->



</body>
</head>
</html>