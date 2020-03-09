<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.model.User"%>
<%@ page import="es.uma.khaos.mongo.api.beans.service.Database" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Login</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
	<%
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String from = request.getParameter("from");
		HttpSession sesion = request.getSession();
		int redirect = 0;

		try {

			Database db = new Database();
			User user = db.searchUserDb(username, password);
			System.out.println(user);

			if (user.getId() != null && !user.getId().isEmpty()) {

				sesion.setAttribute("usuario", username);
				sesion.setAttribute("userId", user.getId());
				sesion.setAttribute("conectado", "true");
				sesion.setAttribute("successMsg", "Login successful!");
				redirect = 1; // Common user
			}
		} catch (Exception e) {
		    sesion.setAttribute("errorMsg",
					"Error: Impossible to connect to the database. Contact with an administrator.");
			redirect = -1; // Error
			e.printStackTrace();
		}

		if (redirect == 0) {
			sesion.setAttribute("errorMsg", "Incorrect username and password!");
			if (from != null) {
				response.sendRedirect("../login.jsp?from=" + from);
			} else {

				response.sendRedirect("../loggingError.jsp");
			}

		} else if (redirect == 1) {

			if (from != null) {
				response.sendRedirect("../" + from);

			} else {
				request.getSession().setAttribute("nombre_param", "valor_param");

				response.sendRedirect("../home.jsp");
			}

		} else {
            response.sendRedirect("../connectionError.jsp");
		}
	%>
</body>
</html>