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
<c:set var="user" value='${it}'/>
<body>
<%
    HttpSession sesion = request.getSession(true);
    PacienteDao pacienteDao = new PacienteDao();
    String id = (String) sesion.getAttribute("userId");
    sesion.setAttribute("Claves", pacienteDao.find_fields_keys(id));
    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");
    sesion.setAttribute("Usuario", pacienteDao.find_user_all_patients(id));
    sesion.setAttribute("KeysInCommon", pacienteDao.find_samples_metadata_common(id));

%>

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">FIMED</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">

            <div class="page-header" style="margin-top: 0px">
                <h1><strong>Gene Regulatory Network Analysis</strong>
                    <small>
                        <span class="glyphicon glyphicon-info-sign" data-toggle="modal" aria-hidden="true"
                              data-target="#keypinfo"></span>
                    </small>
                </h1>
                <h2><strong>List of Patients</strong></h2>
            </div>
            <div class="col-md-offset-1 col-md-8">
                <h3><span class="glyphicon glyphicon-alert"></span>
                    <small>
                        *This section currently accepts gene expression samples in Nanostring
                        format (RCC files)
                    </small>
                </h3>
            </div>

            <div>
                <table class="table table-striped table-condensed">
                    <c:forEach var="patientList" items="${sessionScope.Usuario.patientList}">
                        <table class="table table-condensed table-bordered" style="width: 70%" align="center">
                            <tbody>
                            <h3 align="center">Patient:${patientList.id}
                                <button type="button" class="btn btn-default btn-xs"
                                        data-toggle="modal" data-target="#muestrasModal${patientList.id}">
                                     <span class="glyphicon glyphicon-plus"
                                           aria-hidden="true"></span>
                                    Add Samples
                                </button>
                            </h3>
                            <c:forEach items="${patientList.parameters}" var="parameters">
                                <c:if test="${parameters.key == '_patientInformation'}">
                                    <c:forEach items="${parameters.value}" var="mapPatient" end="1">
                                        <tr>
                                            <td class="col-md-6">${mapPatient.key}</td>
                                            <td class="col-md-6">${mapPatient.value.Value}</td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
                            </tbody>
                        </table>

                        <!-- Modal -->
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
                                        <c:forEach items="${patientList.parameters._clinicalSamples}" var="muestras">

                                            <table class="table table-striped table-condensed ">
                                                <thead>
                                                <tr>
                                                    <!--  <th>ID de Muestra</th> -->
                                                    <th>Sample Name</th>
                                                    <th>Sample Date</th>
                                                    <th></th>
                                                    <th></th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <tr>
                                                    <!--  <td>${muestras.gridFS_Sample._id}</td> -->
                                                    <td>${muestras.sample_name}</td>
                                                    <td><fmt:formatDate value="${muestras.sample_date}"
                                                                        pattern="yyyy-MM-dd"/></td>
                                                    <td>
                                                        <button type="submit" class="btn btn-default btn-xs"
                                                                onclick="addsamplesGRN('${muestras.gridFS_Sample._id}','${patientList.id}')">
                                                                <span class="glyphicon glyphicon-plus"
                                                                      aria-hidden="true"></span>
                                                            &nbsp;Add
                                                        </button>
                                                    </td>
                                                    <td>
                                                        <button class="btnview${muestras.gridFS_Sample._id} btn-default btn-xs"
                                                                onclick="viewMoreSample('${muestras.gridFS_Sample._id}')"
                                                                data-toggle="collapse"
                                                                data-target="#${muestras.gridFS_Sample._id}">
                                                            <span class="glyphicon glyphicon-collapse-down"></span> View
                                                            more
                                                        </button>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                            <div id="${muestras.gridFS_Sample._id}" class="collapse">
                                                <table id="${muestras.gridFS_Sample._id}"
                                                       class="table table-condensed table-bordered ">
                                                    <thead>
                                                    <tr>
                                                        <th class="active" align="center" style="text-align: center"
                                                            colspan="2">
                                                            Sample Metadata
                                                        </th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <c:forEach items="${muestras.metadata}" var="metadatos">
                                                        <tr>
                                                            <td>
                                                                <input type="hidden"
                                                                       class="labelHeatMap${muestras.gridFS_Sample._id}"
                                                                       id="labelHeatMap${muestras.gridFS_Sample._id}"
                                                                       value="${metadatos.key}">
                                                                    ${metadatos.key}
                                                            </td>
                                                            <td>
                                                                <input type="hidden"
                                                                       class="labelHeatMapV${muestras.gridFS_Sample._id}"
                                                                       id="labelHeatMap${muestras.gridFS_Sample._id}"
                                                                       value="${metadatos.value}">
                                                                    ${metadatos.value}
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>

                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </table>

                <form id="cluster_heatmap" name="cluster_heatmap" method="get"> <!--action="./action/redirectResults.jsp"
                          enctype="multipart/form-data" acceptcharset="UTF-8"> -->
                    <div class="form-group">
                        <label class="col-sm-12 control-label">Analysis samples</label>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-offset-2 col-sm-2 control-label">Selected samples</label>
                        <div class="col-sm-8">
                            <div class="table-responsive">
                                <table class="table table-condensed">
                                    <thead>
                                    <tr>
                                        <th></th>
                                        <th>Sample ID</th>
                                        <th>Patient Code</th>
                                        <th>
                                            <button type="button" class="btn btn-default btn-xs"
                                                    onclick="deletesamplesGRN()">
                                                <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>&nbsp;delete
                                            </button>
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody id="SamplesGRN">

                                    </tbody>
                                </table>
                                <p class="help-block">
                                    Remove those you are not interested.
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-offset-2 col-sm-10 control-label">Services</label>
                        <div class="col-sm-offset-4 col-sm-4">
                            <label class="control-label">
                                <input type="checkbox" id="geneRegNetwork" onclick="activeMaxLinks()" disabled> Gene
                                regulatory network
                            </label>
                        </div>
                        <div class="col-sm-4">
                            <button type="button" class="btn" data-toggle="modal" data-target="#advanceConf">
                                Advanced Configuration
                            </button>
                        </div>
                        <div class="col-sm-offset-4 col-sm-8">
                            <p class="help-block">
                                Select at least one service to be executed.
                            </p>
                        </div>

                        <div class="slidecontainer col-sm-12">
                            <label class="col-sm-4 control-label">% of significantly altered gene expression
                                levels</label>
                            <div class="col-sm-6">
                                <input type="range" min="1" max="100" value="5" class="slider" id="percentage">
                            </div>
                            <div class="col-sm-2">
                                <span id="percentageOut"></span>
                            </div>
                        </div>

                        <div class="slidecontainer col-sm-12" id="slidelinks" style="display: none">
                            <label class="col-sm-4 control-label"># maximum of links of the Gene Regulatory
                                Network</label>
                            <div class="col-sm-6">
                                <input type="range" min="1" max="100" value="5" class="slider" id="maxlinks">
                            </div>
                            <div class="col-sm-2">
                                <span id="maxlinksOut"></span>
                            </div>
                        </div>
                        <div class="col-sm-12" align="center">
                            <!-- Small modal -->
                            <button type="button" class="btn btn-default" data-toggle="modal"
                                    data-target=".submit-modal">
                                <span class="glyphicon glyphicon-send" aria-hidden="true"></span>&nbsp;Submit
                            </button>

                        </div>

                        <div class="modal fade submit-modal" tabindex="-1" role="dialog"
                             aria-labelledby="mySmallModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-sm">
                                <div class="modal-content">
                                    <div class="modal-body">
                                        <p>
                                            Would you like to save this analysis?
                                        </p>
                                        <p class="help-block">
                                            In this case, name your analysis so that it will be saved in the Fimed
                                            database
                                        </p>
                                        <input type="text" class="form-control" id="name_analysis" name="name_analysis">
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close
                                            </button>
                                            <button type="button" class="btn btn-default" onclick="submitGRN()">
                                                <span class="glyphicon glyphicon-send" aria-hidden="true"></span>&nbsp;Submit
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>

                <!-- Advance Configuration Modal -->
                <div class="modal fade" id="advanceConf" tabindex="-1" role="dialog"
                     aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>Advanced Configuration</h3>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <label for="configuration">Select layout to represent GRN (By default:
                                        Force-directed layout)</label>
                                    <select multiple class="form-control" id="configuration">
                                        <option selected value="1">Force-directed layout</option>
                                        <option value="2">Circular layout</option>
                                    </select>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Save</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal info -->
<div class="modal fade" id="keypinfo" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle"
     aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 align="center">ATTENTION</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 align="center">How to perform a Gene Regulatory Network Analysis?</h4>
                    </div>
                    <div class="panel-body">
                        In this link users can find how to perform a Gene Regulatory Network (GRN) Analysis.
                        <a href="https://youtu.be/4bxuH9TVkc8?t=1002" target="_blank">FIMED tutorial (GRN Analysis)</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
</body>

<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
<script src="resources/js/viglaPage.js"></script>


</html>


