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
    String id = (String) sesion.getAttribute("userId");
    String username = (String)sesion.getAttribute("usuario");
    String password = (String)sesion.getAttribute("password");
%>
<div class="container">

    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="searchPage.jsp">Search patients</a></li>
            <li class="breadcrumb-item active" aria-current="page">Search patient by ID</li>
        </ol>
    </nav>

    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header" style="margin-top: 0px">
                <h1>Patient search</h1>
            </div>
            <h3>Patient</h3>
            <form id="patientById" action="action/findByID.jsp" method="post">

                <div class="form-group">
                    <input type="hidden" class="form-control" name="id" id="id" value= "${sessionScope.userId}">
                </div>

                <div class="form-group">
                    <label for="idP" class="col-sm-2 control-label">Find by ID</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="idP" name="idP">
                    </div>
                </div>

                <input type="submit" class="btn btn-primary"  value="FindPatient" />

            </form>

        </div>
    </div>
</div>

</body>
</html>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp"%>