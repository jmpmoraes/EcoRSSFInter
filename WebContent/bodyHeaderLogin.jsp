<script type="text/javascript" src="./js/jquery-1.8.3.min.js"></script>

<%@ page import="java.security.*"%>
<%@ page import="java.math.BigInteger"%>

<%@ page import="java.net.*"%>

<%@ page import="java.io.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>






<%
	String login = request.getParameter("xx_login");
	String senha = request.getParameter("xx_senha");

	String aux = request.getParameter("aux_login");
	
	Object obj = request.getSession().getAttribute("logado");

	if (obj == "true") {
		pageContext.forward("./welcome.jsp");
	} else {
		if (((login != null && senha != null) && (!login.equals("") && !senha.equals(""))) && aux.equals("1")) {
			
			if (obj != "fail") {
				// MD5 para Encriptar senha
				MessageDigest m = MessageDigest.getInstance("MD5");
				m.reset();
				m.update(senha.getBytes());
				byte[] digest = m.digest();
				BigInteger bigInt = new BigInteger(1, digest);
				String senhaC = bigInt.toString(16);

				// Padding com 0 até ter 32 carateres
				while (senhaC.length() < 32) {
					senhaC = "0" + senhaC;
				}

				// 		Aqui por a logica do Login, com o redirect pra pagina de erro
				String urlstr = "http://localhost:8080/EcoRSSFWS/rest/usuario/getLogin/"
						+ login + "&" + senhaC;
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
					

				} catch (Exception e) {
					throw new Exception();
				}

				if (resposta.equals("1")) {
					
					String urlLogin = "http://localhost:8080/EcoRSSFWS/rest/usuario/get/byLogin/"
							+ login;
					String respostaLogin = "0";
					
					try {
						URL url = new URL(urlLogin);

						URLConnection fbconn = url.openConnection();
						InputStream io_stream_server = fbconn
								.getInputStream();
						BufferedReader responseWS = new BufferedReader(
								new InputStreamReader(io_stream_server,
										"UTF-8"));

						respostaLogin = responseWS.readLine();
						
						
						

					} catch (Exception e) {
						throw new Exception();
					}
					Object listaParse = JSONValue.parse(respostaLogin);
					JSONObject user = (JSONObject) listaParse;
					
					session.setAttribute("logado", "true");
					session.setAttribute("name", user.get("nome").toString());
					session.setAttribute("admin", user.get("admin").toString());
					pageContext.forward("./welcome.jsp");
					return;

				} else {
					
					session.setAttribute("logado", "fail");


 					pageContext.forward("./loginFail.jsp");
					
				}

			}
			session.setAttribute("logado", null);
		}
	}
%>

<!-- header: logo e titulo -->
<div id="header">
	<div id="shining">


		<div id="mainMenuWrapper">
			<br /> <a style="margin-left: 15px" href="index.jsp"><img
				src="./images/logo_site.png" height="65px"></a>

			<div id="login">
				<form method="post">
					<input style="float: right; margin-right: 10px; width: 100px;"
						type="text" name="xx_login" id="xx_login">
					<p style="float: right; margin-right: 5px; margin-top: 1px;">Login:</p>
					<br /> <input
						style="float: right; margin-right: 10px; margin-top: 2px; width: 100px;"
						type="password" name="xx_senha" id="xx_senha">
					<p style="float: right; margin-right: 5px; margin-top: 3px;">Senha:</p>
					<input type="hidden" value="1" id="aux_login" name="aux_login">
					<input type="hidden" value="1" id="aux_login" name="aux_login"> 
					<br />

					<button type="submit"
						style="padding: 3px; float: right; margin-right: 10px; margin-top: 3px;">Login</button>
				</form>
			</div>
		</div>



		<!-- #mainMenuWrapper -->
	</div>
</div>









