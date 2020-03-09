<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.model.User"%>
<%@ page import="es.uma.khaos.mongo.api.beans.dao.PacienteDao" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Login</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<%
    String id = request.getParameter("id");
    System.out.println(id);

    String from = request.getParameter("from");
    HttpSession sesion = request.getSession();
    int redirect = 0;

    try {
        if (id == null)
        {
            response.sendRedirect("../errorResonse.jsp");
        }
        redirect = 1; // Common user


    } catch (Exception e) {

        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, "Please, contact with the administrator");
        redirect = -1; // Error
    }

    if (redirect == 1) {

        if (from != null) {
            response.sendRedirect("../" + from);

        } else {
            PacienteDao pacienteDao = new PacienteDao();
            User user = pacienteDao.find_user_all_patients(id);
            sesion.setAttribute("userId", id);
            sesion.setAttribute("userP", user);

            response.sendRedirect("../pacientes.jsp");
        }

    } else {
        response.sendRedirect("../error.jsp");
    }
%>
</body>
</html>