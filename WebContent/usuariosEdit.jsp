<%@ page import="java.security.*"%>
<%@ page import="java.math.BigInteger"%>

<%@ page import="java.net.*"%>

<%@ page import="java.io.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>

<html>
<head>

<%
	Object obj = request.getSession().getAttribute("admin");
	if(obj != "true") 
		pageContext.forward("./permissaoFail.jsp");


	String formId = "";
	String formNome = "";
	String formSobreNome = "";
	String formEmail = "";
	String formLogin = "";
	boolean formAdmin = true;
	String formSenha = "";
	boolean formAtivo = true;

	String aux = request.getParameter("aux_user");
	String aux2 = request.getParameter("id");
	if (aux == null) {

		if (aux2 != null) {

			if (request.getParameter("id").toString().isEmpty() == false) {
				String urlstr = "http://localhost:8080/EcoRSSFWS/rest/usuario/get/"
						+ request.getParameter("id");
				String resposta = "0";

				try {
					URL url = new URL(urlstr);

					URLConnection fbconn = url.openConnection();
					InputStream io_stream_server = fbconn
							.getInputStream();
					BufferedReader responseWS = new BufferedReader(
							new InputStreamReader(io_stream_server,
									"UTF-8"));

					resposta = responseWS.readLine();

				}

				catch (Exception e) {
					throw new Exception();
				}

				Object listaParse = JSONValue.parse(resposta);
				JSONObject user = (JSONObject) listaParse;

				if (resposta.isEmpty() == false) {

					formNome = user.get("nome").toString();
					formSobreNome = user.get("sobrenome").toString();
					formSenha = user.get("senha").toString();
					formEmail = user.get("email").toString();
					formLogin = user.get("login").toString();
					formId = user.get("id").toString();

					if (user.get("ativo").equals(true))
						formAtivo = true;
					else
						formAtivo = false;
					
					if (user.get("admin").equals(true))
						formAdmin = true;
					else
						formAdmin = false;

				}
			}
		}
	} else {

		String senhaC;
		String auxSenha = request.getParameter("id");
		String ifSenha = request.getParameter("senhaSub");
		if (ifSenha.equals("{{}}{}") || ifSenha.equals("")) {

			String urlstr = "http://localhost:8080/EcoRSSFWS/rest/usuario/get/"
					+ auxSenha;
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

			Object listaParse = JSONValue.parse(resposta);
			JSONObject user = (JSONObject) listaParse;

			senhaC = user.get("senha").toString();
			
		} else {
			String senha = request.getParameter("senhaSub");
			MessageDigest m = MessageDigest.getInstance("MD5");
			m.reset();
			m.update(senha.getBytes());
			byte[] digest = m.digest();
			BigInteger bigInt = new BigInteger(1, digest);
			senhaC = bigInt.toString(16);
		}
		// Padding com 0 até ter 32 carateres
		while (senhaC.length() < 32) {
			senhaC = "0" + senhaC;
		}
		
		String idStr = null;
		
		if(request.getParameter("id") == null || request.getParameter("id") == ""){
			idStr = "null";
		}else{
			idStr = request.getParameter("id");
		}
		
		String urlstrSave = "http://localhost:8080/EcoRSSFWS/rest/usuario/save/"
				 			
				+ idStr + "&"
				

				+ request.getParameter("nomeSub") + "&"

				+ request.getParameter("sobreNomeSub") + "&"

				+ request.getParameter("loginSub") + "&"

				+ senhaC + "&"

				+ request.getParameter("emailSub") + "&"

				+ request.getParameter("ativoSub") + "&"
				
				+ request.getParameter("adminSub");

		String resposta = "0";

		try {
			urlstrSave = urlstrSave.replace(" ", "%20");
			URL url = new URL(urlstrSave);
			URLConnection fbconnSave = url.openConnection();
			InputStream io_stream_serverSave = fbconnSave
					.getInputStream();
			BufferedReader responseWS = new BufferedReader(
					new InputStreamReader(io_stream_serverSave, "UTF-8"));

			//resposta = responseWS.readLine();

		}

		catch (Exception e) {
			e.printStackTrace();
		}

		pageContext.forward("./redirectUser.jsp");

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

		<p style="color: black; font-size: 30px;">Edição de Usuários</p>
		<br>

		<form>

			<table class="editTable">
				<tr>
					<td>Nome:</td>
					<td><input type="text" name="nomeSub" value="<%=formNome%>" required="required"></td>

				</tr>
				<tr>
					<td>Sobrenome:</td>
					<td><input type="text" name="sobreNomeSub"
						value="<%=formSobreNome%>" required="required"></td>

				</tr>

				<tr>
					<td>E-mail:</td>
					<td><input type="text" name="emailSub" value="<%=formEmail%>" required="required"></td>
				</tr>



				<tr>
					<td>Login:</td>
					<td><input type="text" name="loginSub" value="<%=formLogin%>" required="required"></td>

				</tr>

				<tr>
					<td>Senha:</td>
					<td><input type="password" name="senhaSub" value="{{}}{}"
						onfocus="this.value=''"></td>
				</tr>

				<tr>
					<td>Admin:</td>
					<td><input type="checkbox" name="adminSub" <%if(formAdmin==true){ %> checked="checked" <%}	 %>></td>
				</tr>


				<tr>
					<td>Ativo:</td>
					<td><select name="ativoSub" >
							<option <%if(formAtivo==true){%>selected="selected"<%}%>>Ativo</option>
							<option <%if(formAtivo==false){%>selected="selected"<%}%>>Desativado</option>
							<
					</select>
				</tr>

			</table>
			<input type="hidden" value="<%=formId%>" id="id" name="id">
			<input type="hidden" value="1" id="aux_logout" name="aux_user">
			<br /> <a href="usuariosLista.jsp"><input type="button"
				value="Cancelar" style="margin-left: 15%; padding: 1px"></a> 
				<input type="submit" value="Enviar" style="padding: 1px; margin-left: 59%;"
				onclick="">
		</form>



		<br>



	</div>
	<!-- #main: end -->


</body>
</head>
</html>