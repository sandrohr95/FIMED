<%@ page contentType="text/html; charset=iso-8859-1" language="java"
	import="java.sql.*" errorPage="" session="true"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Logout</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
	<%
		HttpSession sesion = request.getSession();
		sesion.invalidate();
		response.sendRedirect("../login.jsp");
	%>
</body>
</html>