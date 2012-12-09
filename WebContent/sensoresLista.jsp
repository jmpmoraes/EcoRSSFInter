<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ page import="java.security.*"%>
<%@ page import="java.math.BigInteger"%>

<%@ page import="java.net.*"%>

<%@ page import="java.io.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>


<%
		Object obj = request.getSession().getAttribute("admin");
		String urlstr = "http://localhost:8080/EcoRSSFWS/rest/sensores/list";
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
		Object listaParse = JSONValue.parse(resposta);
			
		JSONArray listaArray = (JSONArray) listaParse;


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
	
	<p style="color: black; font-size: 30px;">Edi&ccedil;&atilde;o de Sensores</p>
	<br />
	<br />
	
	
	<table border="0" cellpadding="0" cellspacing="0">
			
			<thead>
				<tr>
					<th>N&uacute;mero do Sensor</th>
					<th>Status</th>
					<th>Limite Monitorado - Inferior</th>
					<th>Limite Monitorado - Superior</th>
					<th>Info</th> 
					<%if( obj == "true" ){ %><th></th><% }%>
				</tr>
			</thead>



			<tbody>
			<% for (int i = 0; i < listaArray.size() ; i++){
					 JSONObject linha = (JSONObject) listaArray.get(i); 
					 String imageUrl;
					 String userUrl = "id=" + linha.get("id");
					 String nextPageURL = "sensoresEdit.jsp?";
					 nextPageURL = nextPageURL + userUrl;
					 
					 if(linha.get("status").equals(true))
						 imageUrl = "./images/status_ok.png";
					 else
						 imageUrl = "./images/status_error.png";
					 
					 %>
 
				<tr>

					<td><%= linha.get("id") %></td>
					<td><img src="<%= imageUrl %>" height="20" width="20"></td>
					
					<%	if(linha.get("minValue") == null){ %>
					<td> - </td>
					<%}else{ %>
					<td><%= linha.get("minValue") %></td>
					<%} %>
					<%	if(linha.get("maxValue") == null){ %>
					<td> - </td>
					<%}else{ %>
					<td><%= linha.get("maxValue") %></td>
					<%} %>
					<%	if(linha.get("info") == null){ %>
					<td> N&atilde;o h&aacute; descri&ccedil;&atilde;o.</td>
					<%}else{ %>
					<td><%= linha.get("info") %></td>
					<%} %>
						<%if( obj == "true" ){%> 	<td><input type="button"
						onclick="javascript: location.href='<%= nextPageURL %>';"
						value="Editar Sensor" /></td><% }%>


				</tr>
				<%} %>
				
				
			</tbody>
		</table>
		<br /> 
	<%-- <%if( obj == "true" ){ %><input type="button"
			onclick="javascript: location.href='sensoresEdit.jsp';"
			value="Novo Sensor" style="float: right; margin-right: 15%;"><%} %>
	 --%>
		
	</div>
	<!-- #main: end -->
	

	
</body>
</head>
</html>