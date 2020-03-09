<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.dao.PacienteDao" %>
<%@ page import="es.uma.khaos.mongo.api.beans.model.User" %>


<!DOCTYPE html>
<html>
<head>
    <title>Melanoma WEB</title>
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
    User user = new User();
    user = (User) sesion.getAttribute("user");
%>

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="../../home.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="../../searchPage.jsp">Search patients</a></li>
            <li class="breadcrumb-item active" aria-current="page">Search patient by parameters</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header">
                <h2><strong>Lista de Pacientes</strong></h2>
            </div>

            <div>

                <form id="pacientByParameter" action="pacientByParameter" method="get" acceptcharset="UTF-8">

                    <div class="form-group">
                        <input type="hidden" class="form-control" name="id" id="id" value="${sessionScope.userId}">
                    </div>

                    <div class="form-group">
                        <label for="selectParameter" class="col-sm-2 control-label">Search: </label>
                        <div class="form-group">
                            <label for="selectParameter">Select the patients' parameters: </label>
                            <select multiple class="form-control" id="selectParameter" onchange="selectOpciones()">
                                <c:forEach items="${sessionScope.Claves}" var="mapPatient">
                                    <c:if test="${mapPatient.value.getClass().simpleName == 'String'}">
                                        <option value="${mapPatient.key}">${mapPatient.key}</option>
                                    </c:if>
                                    <c:if test="${mapPatient.value.getClass().simpleName != 'String'}">
                                        <c:forEach items="${mapPatient.value}" var="mapPatientParameters">
                                            <tr>
                                                <option value="${mapPatientParameters.key}">${mapPatientParameters.key}</option>
                                            </tr>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-10 col-sm-offset-1">
                        <label for="vparameter" class="col-sm-2 control-label">Searh parameter:</label>
                        <input type="text" class="form-control" id="kparameter" name="kparameter"
                               placeholder="Ej: Enfermedad">
                        <label for="vparameter" class="col-sm-2 control-label">Value:</label>
                        <input type="text" class="form-control" id="vparameter" name="vparameter"
                               placeholder="Ej: Psoriasis">
                        <input type="submit" class="btn btn-primary" value="FindPatient"/>
                    </div>
                </form>

                <table class="table table-striped table-condensed">
                    <c:forEach var="patientList" items="${user.patientList}">
                        <table class="table table-condensed table-bordered" style="width: 90%; margin-top: 50px;margin-bottom: 10px;" align="center">
                            <thead>
                            <tr>
                                <th class="active" align="center" style="text-align: center" colspan="2">
                                    Paciente: ${patientList.id} </th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${patientList.parameters}" var="parameters">
                                <tr>
                                <c:if test="${parameters.key == '_pacienteInformacion'}">
                                    <c:forEach items="${parameters.value}" var="mapPatient">
                                        <c:if test="${mapPatient.value.getClass().simpleName == 'String'}">
                                            <tr>
                                                <td class="col-md-6">${mapPatient.key}</td>
                                                <td class="col-md-6">${mapPatient.value}</td>
                                            </tr>
                                        </c:if>
                                        <c:if test="${mapPatient.value.getClass().simpleName != 'String'}">
                                            <th class="active" colspan="2">${mapPatient.key}</th>
                                            <c:forEach items="${mapPatient.value}" var="mapPatientParameters">
                                                <tr>
                                                    <td align="center" class="col-md-3">${mapPatientParameters.key}</td>
                                                    <td class="col-md-4">${mapPatientParameters.value}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:if>
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
                                    Visualizar Muestras
                                </button>
                            </div>
                            <div class="col-sm-2">
                                <button type="button" class="btn btn-default btn-sm"
                                        data-toggle="modal" data-target="#ficherosModal${patientList.id}">
                                         <span class="glyphicon glyphicon-eye-open"
                                               aria-hidden="true"></span>
                                    Visualizar Ficheros
                                </button>
                            </div>
                            <div class="col-sm-2">
                                <form id="UpdatePatient" action="/action/redirect.jsp" method="get"
                                      enctype="multipart/form-data" acceptcharset="UTF-8">

                                    <input type="hidden" class="form-control" name="id" id="id"
                                           value="${sessionScope.userId}">
                                    <input type="hidden" class="form-control" id="idP" name="idP"
                                           value="${patientList.id}">
                                    <button type="submit" class="btn btn-default btn-sm">
                                         <span class="glyphicon glyphicon-circle-arrow-up"
                                               aria-hidden="true"></span>
                                        Actualizar Paciente
                                    </button>
                                </form>
                            </div>
                            <div class="col-sm-2">
                                <form action="deletePatient" id="deletePatient${patientList.id}"
                                      name="deletePatient${patientList.id}" method="get" enctype="multipart/form-data"
                                      acceptcharset="UTF-8">

                                    <input type="hidden" class="form-control" name="id" value="${sessionScope.userId}">
                                    <input type="hidden" class="form-control" name="id_pac" value="${patientList.id}">
                                    <button type="button" class="btn btn-default btn-sm"
                                            onclick="pregunta_delete_patient('${patientList.id}')">
                                         <span class="glyphicon glyphicon-remove"
                                               aria-hidden="true"></span>
                                        Eliminar Paciente
                                    </button>
                                </form>
                            </div>
                        </div>

                        <div class="modal fade" id="ficherosModal${patientList.id}" tabindex="-1" role="dialog"
                             aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h3>Ficheros Adjuntos</h3>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <p><strong>Patient code:</strong> ${patientList.id}</p>
                                        <table class="table">
                                            <thead>
                                            <c:forEach items="${patientList.parameters.ficheros}" var="ficheros">
                                                <tr>
                                                    <th class="active" colspan="2">${"Fichero adjunto: "}</th>
                                                </tr>
                                                <tr>
                                                    <td class="col-md-6">${"Filename"}</td>
                                                    <td class="col-md-6">${ficheros.filename}</td>
                                                </tr>
                                                <c:forEach items="${ficheros.metadatos}" var="metadatos">
                                                    <tr>
                                                        <td class="col-md-6">${metadatos.key}</td>
                                                        <td class="col-md-6">${metadatos.value}</td>
                                                    </tr>
                                                </c:forEach>
                                                <div>
                                                    <form action="download" id="download" method="get"
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
                                                        <td class="col-md-6">${"Descargar fichero:"}</td>
                                                        <td>

                                                            <button type="submit" class="btn btn-default btn-xs">
                                                                         <span class="glyphicon glyphicon-download"
                                                                               aria-hidden="true"></span>
                                                                Descargar ${ficheros.filename}
                                                            </button>
                                                        </td>
                                                    </form>
                                                </div>
                                            </c:forEach>
                                            </thead>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal fade" id="muestrasModal${patientList.id}" tabindex="-1" role="dialog"
                             aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h3>Samples</h3>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <p><strong>Patient code:</strong> ${patientList.id}</p>
                                        <table class="table">
                                            <thead>
                                            <tr>
                                                <th>ID de Muestra</th>
                                                <th>Nombre de Muestra</th>
                                                <th>Fecha de Muestra</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${patientList.parameters.muestras}" var="muestras">
                                                <tr>
                                                    <td>${muestras.contenido._id}</td>
                                                    <td>${muestras.nombre_Muestra}</td>
                                                    <td>${muestras.fecha_Muestra}</td>

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
<script src="/resources/js/patientList.js"></script>


</html>






