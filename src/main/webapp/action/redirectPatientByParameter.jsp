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
    String kparameter = request.getParameter("kparameter");
    String vparameter = request.getParameter("vparameter");
    String from = request.getParameter("from");
    HttpSession sesion = request.getSession();
    System.out.println(kparameter);
    System.out.println(vparameter);


    try {

        if ((kparameter == null || "".equals(kparameter)) || (vparameter == null || "".equals(vparameter))) {

            response.sendRedirect("../errorNotFilledInserted.jsp");

        }else {
            if (id == null) {

                response.sendRedirect("../error.jsp");

            } else {
                PacienteDao pacienteDao = new PacienteDao();
                User user = pacienteDao.find_user_patient_by_parameter(id,kparameter,vparameter);
                sesion.setAttribute("userId", id);
                sesion.setAttribute("userP", user);

                if (user.getPatientList().isEmpty()) {
                    response.sendRedirect("../errorBuilderPacient.jsp");
                } else {
                    response.sendRedirect("../pacientes.jsp");
                }

            }

        }

    } catch (Exception e) {

        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, "Please, contact with the administrator");

    }
%>
</body>
</html>