
<%
	String aux = request.getParameter("aux_logout");
	if (aux != null) {
		session.setAttribute("logado", "false");
		pageContext.forward("./index.jsp");
	} else {

		Object obj = request.getSession().getAttribute("logado");

		Object userLogado = request.getSession().getAttribute("name");
		pageContext.setAttribute("u", userLogado);
		if (obj == "false" || obj == null)
			pageContext.forward("./loginNeed.jsp");

	}
%>

<!-- header: logo e titulo -->
<div id="header">
	<div id="shining">


		<div id="mainMenuWrapper">
			<br /> <a style="margin-left: 15px" href="index.jsp"><img
				src="./images/logo_site.png" height="65px"></a>

			<div id="login" style=" margin-right: 30px;">
			<form method="post">
				<p style="color: #44cb0c; float: right;">${u}</p>
				<p style="float: right; margin-top: 1px; color: white;">Olá,&nbsp;</p>
				<br />
				<input type="hidden" value="1" id="aux_logout" name="aux_logout"> 
				<button type="submit" style="padding: 3px; float: right;">Logout</button>
				</form>
			</div>
		</div>



		<!-- #mainMenuWrapper -->
	</div>
</div>
