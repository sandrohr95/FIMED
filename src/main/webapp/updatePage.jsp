<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
</head>


<c:set var="user" value='${it}'/>
<body>

<%
    HttpSession sesion = request.getSession(true);
    String id = (String) sesion.getAttribute("userId");
    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");
    System.out.println("id: " + id);
    System.out.println("usuario: " + username);

    String id_pac = request.getParameter("idP");
    sesion.setAttribute("pacienteId", id_pac);
    System.out.println("pacienteId: " + id_pac);
%>
<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="searchPage.jsp">Search patients</a></li>
            <li class="breadcrumb-item active" aria-current="page">List of Patients</li>
            <li class="breadcrumb-item active" aria-current="page">Update patient</li>
        </ol>
    </nav>

    <div class="panel panel-default">
        <div class="panel-body">

            <div class="page-header" style="margin-top: 0px">
                <h1>Update Patient</h1>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <form id="UpdatePatient" action="updatePatient.jsp" method="get"
                          enctype="multipart/form-data" acceptcharset="UTF-8">

                        <input type="hidden" class="form-control" name="id" id="userId"
                               value="${sessionScope.userId}">
                        <input type="hidden" class="form-control" id="pacienteId" name="idP"
                               value="${sessionScope.pacienteId}">
                        <h3>Update patient fields</h3>
                        <button type="submit" class="btn btn-primary btn-lg btn-block">
                                         <span class="glyphicon glyphicon-circle-arrow-up"
                                               aria-hidden="true"></span>
                            Update Patient
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
<%@ include file="/WEB-INF/jsp/footer.jsp" %>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
