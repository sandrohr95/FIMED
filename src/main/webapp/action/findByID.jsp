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
    String idP = request.getParameter("idP");
    System.out.println(idP);
    System.out.println(id);
    String from = request.getParameter("from");
    HttpSession sesion = request.getSession();

    try {
        if (idP == null || "".equals(idP))
        {
            response.sendRedirect("../errorNotFilledInserted.jsp");

        } else if (id == null) {
            response.sendRedirect("../errorResponseId.jsp");

        }else {
            PacienteDao pacienteDao = new PacienteDao();
            User user = pacienteDao.find_patient_by_id(id,idP);
            sesion.setAttribute("userId", id);
            sesion.setAttribute("userP", user);
            response.sendRedirect("../pacientes.jsp");
        }

    } catch (Exception e) {

        e.printStackTrace();
        response.sendRedirect("../errorBuilderPacient.jsp");

    }

%>
</body>
</html>