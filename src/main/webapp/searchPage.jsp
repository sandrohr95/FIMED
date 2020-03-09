<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp"%>
</head>


<c:set var="user" value='${it}' />
<body>

<%
    HttpSession sesion = request.getSession(true);
    String id = (String)sesion.getAttribute("userId");
    String username = (String)sesion.getAttribute("usuario");
    String password = (String)sesion.getAttribute("password");
    System.out.println("id: " + id);
    System.out.println("usuario: " + username);

%>
<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Patient search</li>
        </ol>
    </nav>

    <div class="panel panel-default">
        <div class="panel-body">

            <div class="page-header" style="margin-top: 0px">
                <h1>Patient search</h1>
            </div>

            <form  id="AllPacientes" action="action/findAllPatients.jsp" method="post">

                <div class="col-md-4">
                    <input type="hidden" class="form-control" name="id" id="id"  value="${sessionScope.userId}">
                    <h3>Search patient by ID</h3>
                    <button type="submit" class="btn btn-primary btn-lg btn-block"
                            formaction=<c:url value="/searchByID.jsp" />>
                        <span class="glyphicon glyphicon-search"></span>
                        Search Patient </button>

                    <h3>Search Patient by Parameter</h3>
                    <button type="submit" class="btn btn-primary btn-lg btn-block"
                            formaction=<c:url value="/searchByParameter.jsp" />>
                        <span class="glyphicon glyphicon-search"></span>
                        Search Patient</button>

                    <h3>List all your patients</h3>
                    <button type="submit" class="btn btn-primary btn-lg btn-block">
                        <span class="glyphicon glyphicon-search"></span>
                        Search Patient</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp"%>
