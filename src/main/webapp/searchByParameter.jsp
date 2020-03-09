<%@ page import="es.uma.khaos.mongo.api.beans.dao.PacienteDao" %>
<%@ page import="es.uma.khaos.mongo.api.beans.model.User" %>
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
    PacienteDao pacienteDao = new PacienteDao();
    String id = (String) sesion.getAttribute("userId");
    sesion.setAttribute("Claves", pacienteDao.find_fields_keys(id));
    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");
    User user = new User();
    user = (User) sesion.getAttribute("user");
%>
<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="searchPage.jsp">Search patients</a></li>
            <li class="breadcrumb-item active" aria-current="page">Search patient by parameters</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">
            <c:out value="${sessionScope.user}"/>

            <div class="page-header" style="margin-top: 0px">
                <h1>Patient search</h1>
            </div>

            <h3>Patient</h3>

            <form id="pacientByParameter" action="action/redirectPatientByParameter.jsp" method="post">

                <div class="form-group">
                    <input type="hidden" class="form-control" name="t" id="t" value="${sessionScope.userId}">
                    <input type="hidden" class="form-control" name="id" id="id" value="${sessionScope.userId}">
                </div>

                <div class="form-group">
                    <label for="selectParameter" class="col-sm-2 control-label">Search: </label>
                    <div class="form-group">
                        <label for="selectParameter">Select the patients' parameters: </label>
                        <select multiple class="form-control" id="selectParameter" name="selectOptions"
                                onchange="selectOpciones()">
                            <c:forEach items="${sessionScope.Claves}" var="mapPatient">
                                <c:set var="type" scope="session" value="${mapPatient.value.Type}"/>
                                <c:choose>
                                    <c:when test="${type == 'String'}">
                                        <option value="${mapPatient.key}#${type}">${mapPatient.key}</option>
                                    </c:when>
                                    <c:when test="${type == 'Date'}">
                                        <option value="${mapPatient.key}#${type}">${mapPatient.key}</option>
                                    </c:when>
                                    <c:when test="${type == 'Long' || type == 'Integer' || type == 'Double'}">
                                        <option value="${mapPatient.key}#${type}"
                                                name="Integer">${mapPatient.key}</option>
                                    </c:when>
                                    <c:when test="${type == 'Boolean'}">
                                        <option value="${mapPatient.key}#${type}"
                                                name="Boolean">${mapPatient.key}</option>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-sm-10">
                    <label for="vparameter" class="col-sm-2 control-label">Searh parameter:</label>
                    <input type="text" class="form-control" id="kparameter" name="kparameter"
                           placeholder="Ej: Enfermedad">
                    <label for="vparameter" class="col-sm-2 control-label">Value:</label>
                    <input type="text" class="form-control" id="vparameter" name="vparameter"
                           placeholder="Ej: Psoriasis">
                    <div id="typeparam"></div>
                    <input type="submit" class="btn btn-primary" value="Filter Patients"/>
                </div>
            </form>
        </div>
    </div>
</div>


</body>
<script src="resources/js/otherFunctions.js"></script>

</html>
<%@ include file="/WEB-INF/jsp/footer.jsp" %>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
