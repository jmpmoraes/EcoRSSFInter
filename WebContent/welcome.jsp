<html>
<head>

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
		<div ID="titulo">
		
			<p>Bem vindo ao Sistema EcoRSSF</p>
			</br>
			</br>
		
		</div>
		
		<div ID="mensagem">
		
			<p>Aqui voc� encontra informa��es sobre a coleta de diversos sensores espalhados pela regi�o.</p>
			</br>
			<p>Abaixo est�o listados os sensores registrados e seus respectivos status.</p>
		
		</div>
	
		
	</div>
	<!-- #main: end -->
	

	
</body>
</head>
</html>