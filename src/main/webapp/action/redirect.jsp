<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.model.User"%>
<%@ page import="es.uma.khaos.mongo.api.beans.dao.PacienteDao" %>
<%@ page import="org.apache.hadoop.yarn.webapp.hamlet.Hamlet" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Login</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<%
    String id_pac = request.getParameter("idP");
    String id = request.getParameter("id");
    PacienteDao pacienteDao = new PacienteDao();
    User user = pacienteDao.find_patient_by_id(id,id_pac);


    String from = request.getParameter("from");
    HttpSession sesion = request.getSession();
    int redirect = 0;

    try {

        sesion.setAttribute("userId", id);
        sesion.setAttribute("pacienteId", id_pac);
        sesion.setAttribute("usuariopaciente", user);

        sesion.setAttribute("conectado", "true");
        sesion.setAttribute("successMsg", "Login successful!");
        redirect = 1; // Common user


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

            response.sendRedirect("../updatePatient.jsp");
        }

    } else {
        response.sendRedirect("../error.jsp");
    }
%>
</body>
</html>