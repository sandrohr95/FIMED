<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.dao.PacienteDao" %>
<%@ page import="es.uma.khaos.mongo.api.beans.model.User" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html>
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
    <c:if test="${sessionScope.conectado!='true'}">
        <c:redirect url="/login.jsp"/>
    </c:if>
</head>
<body>
<%
    HttpSession sesion = request.getSession(true);
    PacienteDao pacienteDao = new PacienteDao();
    String id = (String) sesion.getAttribute("userId");
    sesion.setAttribute("Claves", pacienteDao.find_fields_keys(id));
    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");
    User user = (User) sesion.getAttribute("userP");
%>

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="searchPage.jsp">Search patients</a></li>
            <li class="breadcrumb-item active" aria-current="page">Search of all patients</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header" style="margin-top: 0px">
                <h1><strong>List of Patients</strong></h1>
            </div>
            <div>
                <form id="pacientByParameter" action="action/redirectPatientByParameter.jsp" method="post"
                      accept-charset="UTF-8">
                    <div class="form-group">
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
                    <div class="col-sm-10 col-sm-offset-1">
                        <label for="vparameter" class="col-sm-2 control-label">Searh parameter:</label>
                        <input type="text" class="form-control" id="kparameter" name="kparameter"
                               placeholder="e.g: Disease">
                        <label for="vparameter" class="col-sm-2 control-label">Value:</label>
                        <input type="text" class="form-control" id="vparameter" name="vparameter"
                               placeholder="e.g: Psoriasis">
                        <div id="typeparam"></div>
                        <input type="submit" class="btn btn-primary" value="Filter Patients"/>
                    </div>
                </form>

                <table class="table table-striped table-condensed">
                    <c:forEach var="patientList" items="${userP.patientList}">
                        <table class="table table-condensed table-bordered"
                               style="width: 90%; margin-top: 50px;margin-bottom: 10px;" align="center">
                            <thead>
                            <tr>
                                <th align="center" style="text-align: center; font-size: 14px" colspan="2">
                                    Patient: ${patientList.id} </th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${patientList.parameters}" var="parameters">
                                <tr>
                                <c:if test="${parameters.key == '_patientInformation'}">
                                    <c:forEach items="${parameters.value}" var="mapPatient">
                                        <c:choose>
                                            <%--                                            This is a Simple or compund parameter--%>
                                            <c:when test="${mapPatient.value.getClass().simpleName == 'BasicDBObject'}">
                                                <c:set var="value" scope="session"
                                                       value="${mapPatient.value.Value.getClass().simpleName}"/>
                                                <c:choose>
                                                    <c:when test="${value == 'String'}">
                                                        <tr>
                                                            <td class="col-md-6">${mapPatient.key}</td>
                                                            <td class="col-md-6">${mapPatient.value.Value}</td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <th class="active" colspan="2">${mapPatient.key}</th>
                                                        <c:forEach items="${mapPatient.value}"
                                                                   var="mapPatientParameters">
                                                            <tr>
                                                                <td align="center"
                                                                    class="col-md-6">${mapPatientParameters.key}</td>
                                                                <td class="col-md-6">${mapPatientParameters.value.Value}</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <%--                                            List parameter in MongoDB (Like another table in SQL)--%>
                                            <c:when test="${mapPatient.value.getClass().simpleName == 'BasicDBList'}">
                                                <tr>
                                                    <th class="active" colspan="2" align="center">
                                                        <button type="button" class="btn-link"
                                                                data-toggle="modal"
                                                                data-target="#ListParametersModal${patientList.id}${mapPatient.key}"> <%-- poner el nombre tb de la lista como identificador --%>
                                                            <span class="glyphicon glyphicon-eye-open"
                                                                  aria-hidden="true"></span>
                                                                ${mapPatient.key}
                                                        </button>
                                                    </th>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                ${mapPatient.value.getClass().simpleName}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </c:if>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <div class="row" align="center">
                            <div class="col-sm-2 col-sm-offset-2">
                                <button type="button" class="btn btn-default btn-sm"
                                        data-toggle="modal" data-target="#muestrasModal${patientList.id}">
                                         <span class="glyphicon glyphicon-eye-open"
                                               aria-hidden="true"></span>
                                    Display Samples
                                </button>
                            </div>
                            <div class="col-sm-2">
                                <button type="button" class="btn btn-default btn-sm"
                                        data-toggle="modal" data-target="#ficherosModal${patientList.id}">
                                         <span class="glyphicon glyphicon-eye-open"
                                               aria-hidden="true"></span>
                                    Display Files
                                </button>
                            </div>
                            <div class="col-sm-2">
                                <form id="UpdatePatient" action="updatePage.jsp" method="get"
                                      enctype="multipart/form-data" acceptcharset="UTF-8">

                                    <input type="hidden" class="form-control" name="id" id="id"
                                           value="${sessionScope.userId}">
                                    <input type="hidden" class="form-control" id="idP" name="idP"
                                           value="${patientList.id}">
                                    <button type="submit" class="btn btn-default btn-sm">
                                         <span class="glyphicon glyphicon-circle-arrow-up"
                                               aria-hidden="true"></span>
                                        Update Patient
                                    </button>
                                </form>
                            </div>
                            <div class="col-sm-2">
                                <form action="api/deletePatient" id="deletePatient${patientList.id}"
                                      name="deletePatient${patientList.id}" method="get" enctype="multipart/form-data"
                                      accept-charset="UTF-8">

                                    <input type="hidden" class="form-control" name="id" value="${sessionScope.userId}">
                                    <input type="hidden" class="form-control" name="id_pac" value="${patientList.id}">

                                    <button type="button" class="btn btn-default btn-sm"
                                            onclick="pregunta_delete_patient('${patientList.id}')">
                                         <span class="glyphicon glyphicon-remove"
                                               aria-hidden="true"></span>
                                        Delete Patient
                                    </button>
                                </form>
                            </div>
                        </div>

                        <c:forEach items="${patientList.parameters}" var="parameters">
                            <c:if test="${parameters.key == '_patientInformation'}">
                                <c:forEach items="${parameters.value}" var="mapPatient">
                                    <c:if test="${mapPatient.value.getClass().simpleName == 'BasicDBList'}">

                                        <div class="modal fade"
                                             id="ListParametersModal${patientList.id}${mapPatient.key}" tabindex="-1"
                                             role="dialog"
                                             aria-labelledby="exampleModalLabel" aria-hidden="true" align="left">
                                            <div class="modal-dialog modal-dialog-scrollable" role="document">
                                                <div class="modal-content align-left" style="overflow:auto">
                                                    <div class="modal-header">
                                                        <h3>${mapPatient.key} List</h3>
                                                        <button type="button" class="close" data-dismiss="modal"
                                                                aria-label="Close">
                                                            <span aria-hidden="true">&times;</span>
                                                        </button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <table class="table">
                                                            <thead>
                                                                <th align="center"
                                                                    style="text-align: center; font-size: 14px"
                                                                    colspan="1000">
                                                                        ${mapPatient.key} </th>
                                                            </thead>
                                                            <tbody>
                                                            <c:forEach items="${mapPatient.value}"
                                                                       var="List_parameter">
                                                                <tr>
                                                                    <c:forEach items="${List_parameter}"
                                                                               var="map_parameter">
                                                                        <th>${map_parameter.key}:</th>
                                                                        <td>${map_parameter.value.Value}</td>
                                                                    </c:forEach>
                                                                </tr>
                                                            </c:forEach>
                                                            </tbody>

                                                                <%-- SI CONSIDERAMOS QUE EN EL ARRAY TODOS LOS CAMPOS SON LOS MISMOS LIKE IN SQL --%>
                                                                <%--                                                            <c:forEach items="${mapPatient.value}" var="List_parameter"--%>
                                                                <%--                                                                       end="0">--%>
                                                                <%--                                                                <thead>--%>
                                                                <%--                                                                <tr>--%>
                                                                <%--                                                                    <c:forEach items="${List_parameter}"--%>
                                                                <%--                                                                               var="map_parameter">--%>
                                                                <%--                                                                        <th>${map_parameter.key}</th>--%>
                                                                <%--                                                                    </c:forEach>--%>
                                                                <%--                                                                </tr>--%>
                                                                <%--                                                                </thead>--%>
                                                                <%--                                                                <c:forEach items="${mapPatient.value}"--%>
                                                                <%--                                                                           var="List_parameter">--%>
                                                                <%--                                                                    <tbody>--%>
                                                                <%--                                                                    <tr>--%>
                                                                <%--                                                                    <c:forEach items="${List_parameter}"--%>
                                                                <%--                                                                               var="map_parameter">--%>
                                                                <%--                                                                            <td>${map_parameter.value.Value}</td>--%>
                                                                <%--                                                                    </c:forEach>--%>
                                                                <%--                                                                    </tr>--%>
                                                                <%--                                                                    </tbody>--%>
                                                                <%--                                                                </c:forEach>--%>
                                                                <%--                                                            </c:forEach>--%>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                        <div class="modal fade" id="ficherosModal${patientList.id}" tabindex="-1" role="dialog"
                             aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content" style="overflow: scroll">
                                    <div class="modal-header">
                                        <h3>Attached Files</h3>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <p><strong>Patient code:</strong> ${patientList.id}</p>
                                        <table class="table">
                                            <tbody>
                                            <c:forEach items="${patientList.parameters._files}" var="ficheros">
                                                <tr>
                                                    <th class="active" colspan="2">${"Attached File: "}</th>
                                                </tr>
                                                <tr>
                                                    <td class="col-md-6">${"Filename"}</td>
                                                    <td class="col-md-6">${ficheros.filename}</td>
                                                </tr>
                                                <c:forEach items="${ficheros.metadata}" var="metadatos">
                                                    <tr>
                                                        <td class="col-md-6">${metadatos.key}</td>
                                                        <td class="col-md-6">${metadatos.value}</td>
                                                    </tr>
                                                </c:forEach>
                                                <div>
                                                    <form action="api/download" id="download" method="get"
                                                          enctype="multipart/form-data" acceptcharset="UTF-8">

                                                        <div class="form-group">
                                                            <input type="hidden" class="form-control" name="id"
                                                                   id="id_user" value="${sessionScope.userId}">
                                                        </div>
                                                        <div class="form-group">
                                                            <input type="hidden" class="form-control" name="id_pac"
                                                                   id="id_pac" value="${patientList.id}">
                                                        </div>
                                                        <div class="form-group">
                                                            <input type="hidden" class="form-control" name="filename"
                                                                   id="filename" value="${ficheros.filename}">
                                                        </div>
                                                        <td class="col-md-6">${"Download File:"}</td>
                                                        <td>

                                                            <button type="submit" class="btn btn-default btn-xs">
                                                                         <span class="glyphicon glyphicon-download"
                                                                               aria-hidden="true"></span>
                                                                    ${ficheros.filename}
                                                            </button>
                                                        </td>
                                                    </form>
                                                </div>
                                            </c:forEach>

                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal fade" id="muestrasModal${patientList.id}" tabindex="-1" role="dialog"
                             aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content" style="width: 750px">
                                    <div class="modal-header">
                                        <h3>Samples</h3>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body" style="max-width: 730px">
                                        <p><strong>Patient code:</strong> ${patientList.id}</p>
                                        <table class="table">
                                            <thead>
                                            <tr>
                                                <th>Sample ID</th>
                                                <th>Sample Name</th>
                                                <th>Sample Date</th>
                                                <th>Download</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${patientList.parameters._clinicalSamples}"
                                                       var="muestras">
                                                <tr>
                                                    <td>${muestras.gridFS_Sample._id}</td>
                                                    <td>${muestras.sample_name}</td>
                                                    <td><fmt:formatDate value="${muestras.sample_date}"
                                                                        pattern="yyyy-MM-dd"/></td>
                                                    <div>
                                                        <form action="api/downloadSample" id="downloadSample"
                                                              method="get"
                                                              enctype="multipart/form-data" acceptcharset="UTF-8">

                                                            <div class="form-group">
                                                                <input type="hidden" class="form-control" name="idUser"
                                                                       id="idUser" value="${sessionScope.userId}">
                                                            </div>
                                                            <div class="form-group">
                                                                <input type="hidden" class="form-control"
                                                                       name="idPaciente"
                                                                       id="idPaciente" value="${patientList.id}">
                                                            </div>
                                                            <div class="form-group">
                                                                <input type="hidden" class="form-control" name="Sample"
                                                                       id="Sample" value="${muestras.sample_name}">
                                                            </div>
                                                            <td>

                                                                <button type="submit" class="btn btn-default btn-xs">
                                                                         <span class="glyphicon glyphicon-download"
                                                                               aria-hidden="true"></span>
                                                                        ${muestras.sample_name}
                                                                </button>
                                                            </td>
                                                        </form>
                                                    </div>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
<script src="resources/js/otherFunctions.js"></script>


</html>











