

<html>
<head>
<%@ page import="java.security.*"%>
<%@ page import="java.math.BigInteger"%>

<%@ page import="java.net.*"%>

<%@ page import="java.io.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>







<script type="text/javascript" src="./js/jquery-1.8.3.min.js"></script>

<!-- Header -->
<jsp:include page="header.jsp" />
<body>

	<%
	
		Object obj = request.getSession().getAttribute("admin");
		String urlstr = "http://localhost:8080/EcoRSSFWS/rest/usuario/getUsuarios";
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

	<!-- Topo do Body -->
	<jsp:include page="bodyHeader.jsp" />




	<!-- side-navigation: lista de botoes que compoem o menu lateral -->
	<div ID="side-navigation">
		<jsp:include page="menuLateral.jsp" />
	</div>





	<!-- main: tela principal -->
	<div ID="mainSite" style="padding-left: 20%; padding-top: 7%">

		<p style="color: black; font-size: 30px;">Edi&ccedil;&atilde;o de
			Usu&aacute;rios</p>
		<br /> <br /> 
		<table border="0" cellpadding="0" cellspacing="0">

			<thead>
				<tr>
					<th>ID</th>
					<th>Nome</th>
					<th>Sobrenome</th>
					<th>E-mail</th>
					<th>Login</th>
					<th>Status</th>
					<th>Admin</th>
				<%if( obj == "true" ){ %>	<th></th><%} %>
				</tr>
			</thead>



			<tbody>
				<% for (int i = 0; i < listaArray.size() ; i++){
					 JSONObject linha = (JSONObject) listaArray.get(i); 
					 String imageUrl;
					 String imageUrlAdmin;
					 String userUrl = "id=" + linha.get("id");
					 String nextPageURL = "usuariosEdit.jsp?";
					 nextPageURL = nextPageURL + userUrl;
					 
					 if(linha.get("ativo").equals(true))
						 imageUrl = "./images/status_ok.png";
					 else
						 imageUrl = "./images/status_error.png";
					 
					 if(linha.get("admin").equals(true))
						 imageUrlAdmin = "./images/status_ok.png";
					 else
						 imageUrlAdmin = "./images/status_error.png";
					 
					 %>
				<tr>




					<td><%= linha.get("id") %></td>
					<td><%= linha.get("nome") %></td>
					<td><%= linha.get("sobrenome") %></td>
					<td><%= linha.get("email") %></td>
					<td><%= linha.get("login") %></td>
					<td><img src="<%= imageUrl %>" height="20" width="20"></td>
					<td><img src="<%= imageUrlAdmin %>" height="20" width="20"></td>

				<%if( obj == "true" ){ %>	<td><input type="button"
						onclick="javascript: location.href='<%= nextPageURL %>';"
						value="Editar Usuário" /></td><%} %>
				</tr>
				<%} %>



			</tbody>
		</table>
		<br />
<%if( obj == "true" ){ %><input type="button"
			onclick="javascript: location.href='usuariosEdit.jsp';"
			value="Novo Usuário"  style="float: right; margin-right: 15%;"/><%} %>
		<br /> <br>



	</div>
	<!-- #main: end -->



</body>
</head>
</html>