<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.model.User" %>
<%@ page import="es.uma.khaos.mongo.api.beans.dao.PacienteDao" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
    <c:if test="${sessionScope.conectado!='true'}">
        <c:redirect url="/login.jsp"/>
    </c:if>
</head>
<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<body>
<%

    HttpSession sesion = request.getSession(true);
    String id = (String) sesion.getAttribute("userId");
    String id_pac = (String) sesion.getAttribute("pacienteId");
    sesion.setAttribute("pacienteId", id_pac);

    System.out.println("id: " + id);
    System.out.println("patientId: " + id_pac);


    PacienteDao pacienteDao = new PacienteDao();
    User user = pacienteDao.find_patient_by_id(id, id_pac);
    sesion.setAttribute("usuariopaciente", user);
    sesion.setAttribute("ClavesFichero", pacienteDao.find_fields_keys_files(id));
    sesion.setAttribute("ClavesMuestra", pacienteDao.find_fields_keys_samples(id));
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
            <div class="container">
                <h3>Insert, update or delete patient fields
                    <small>
                        The selected fields will be deleted when the patient is updated
                    </small>
                </h3>
                <c:set var="count" value="0" scope="page"/>
                <c:forEach var="patientList" items="${sessionScope.usuariopaciente.patientList}">

                    <form id="crearPaciente" name="FormPaciente" action="api/crearPaciente" method="post"
                          enctype="multipart/form-data" acceptcharset="UTF-8">

                        <input type="hidden" class="form-control" name="id_pac" id="id_pac" value=${patientList.id}>
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="id" id="id_user"
                                   value="${sessionScope.userId}">
                        </div>
                        <!-- One "tab" for each step in the form: -->
                        <div class="tab">
                            <c:forEach items="${patientList.parameters}" var="parameters">
                                <c:if test="${parameters.key == '_patientInformation'}">
                                    <c:forEach items="${parameters.value}" var="mapPatient">
                                        <c:set var="value" scope="session"
                                               value="${mapPatient.value.Value.getClass().simpleName}"/>
                                        <c:choose>
                                            <c:when test="${value == 'String'}">
                                                <c:set var="type" scope="session"
                                                       value="${mapPatient.value.Type}"/>
                                                <c:choose>
                                                    <c:when test="${type == 'String'}">
                                                        <div class="row">
                                                            <div class="col-md-offset-1 col-md-4 col">
                                                                <label class="control-label">
                                                                    <input onclick="hideFields('${mapPatient.key}')"
                                                                           type="checkbox" id="${mapPatient.key}"
                                                                           name="deletefields"
                                                                           value="${mapPatient.key}">
                                                                        ${mapPatient.key}
                                                                </label>
                                                            </div>
                                                            <div class="col-md-6 ">
                                                                <input type="text" style="display: none"
                                                                       class="form-control"
                                                                       name="keys"
                                                                       value="${mapPatient.key}">
                                                                <input type="text" style="display: none"
                                                                       class="form-control"
                                                                       name="keystype"
                                                                       id="keystype"
                                                                       value="${type}">
                                                                <input type="text" class="form-control"
                                                                       id="values${mapPatient.key}"
                                                                       name="values"
                                                                       value="${mapPatient.value.Value}"
                                                                       placeholder="Enter Value">
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${type == 'Textarea'}">
                                                        <div class="row">
                                                            <div class="col-md-offset-1 col-md-4 col">
                                                                <label class="control-label">
                                                                    <input onclick="hideFields('${mapPatient.key}')"
                                                                           type="checkbox" id="${mapPatient.key}"
                                                                           name="deletefields"
                                                                           value="${mapPatient.key}">
                                                                        ${mapPatient.key}
                                                                </label>
                                                            </div>
                                                            <div class="col-md-6 ">
                                                                <label>
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="keys"
                                                                           value="${mapPatient.key}">
                                                                </label>
                                                                <label for="keystype"></label>
                                                                <input type="text"
                                                                       style="display: none"
                                                                       class="form-control"
                                                                       name="keystype"
                                                                       id="keystype"
                                                                       value="${type}">
                                                                <label for="values${mapPatient.key}"></label>
                                                                <textarea
                                                                        class="form-control"
                                                                        id="values${mapPatient.key}"
                                                                        name="values"
                                                                        placeholder="Enter Value">${mapPatient.value.Value}
                                                                </textarea>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${type == 'Long' || type == 'Integer' || type == 'Double'}">
                                                        <div class="row">
                                                            <div class="col-md-offset-1 col-md-4">
                                                                <label class="control-label">
                                                                    <input onclick="hideFields('${mapPatient.key}')"
                                                                           type="checkbox" id="${mapPatient.key}"
                                                                           name="deletefields"
                                                                           value="${mapPatient.key}">
                                                                        ${mapPatient.key}
                                                                </label>
                                                            </div>
                                                            <div class="col-md-6 ">
                                                                <input type="text" style="display: none"
                                                                       class="form-control"
                                                                       name="keys"
                                                                       value="${mapPatient.key}">
                                                                <input type="text" style="display: none"
                                                                       class="form-control"
                                                                       name="keystype"
                                                                       id="keystype"
                                                                       value="${type}">
                                                                <input type="number" class="form-control"
                                                                       id="values${mapPatient.key}"
                                                                       name="values"
                                                                       value="${mapPatient.value.Value}"
                                                                       placeholder="Enter Value">
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${type == 'Date'}">
                                                        <div class="row">
                                                            <div class="col-md-offset-1 col-md-4">
                                                                <label class="control-label">
                                                                    <input onclick="hideFields('${mapPatient.key}')"
                                                                           type="checkbox" id="${mapPatient.key}"
                                                                           name="deletefields"
                                                                           value="${mapPatient.key}">
                                                                        ${mapPatient.key}
                                                                </label>
                                                            </div>
                                                            <div class="col-md-6 ">
                                                                <input type="text" style="display: none"
                                                                       class="form-control"
                                                                       name="keys"
                                                                       value="${mapPatient.key}">
                                                                <input type="text" style="display: none"
                                                                       class="form-control"
                                                                       name="keystype"
                                                                       id="keystype"
                                                                       value="${type}">
                                                                <input type="date" class="form-control"
                                                                       id="values${mapPatient.key}"
                                                                       name="values"
                                                                       value="${mapPatient.value.Value}"/>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${type == 'Boolean'}">
                                                        <div class="row">
                                                            <div class="col-md-offset-1 col-md-4">
                                                                <label class="control-label">
                                                                    <input onclick="hideFields('${mapPatient.key}')"
                                                                           type="checkbox" id="${mapPatient.key}"
                                                                           name="deletefields"
                                                                           value="${mapPatient.key}">
                                                                        ${mapPatient.key}
                                                                </label>
                                                            </div>
                                                            <div class="col-md-6 ">
                                                                <input type="text" style="display: none"
                                                                       class="form-control"
                                                                       name="keys"
                                                                       value="${mapPatient.key}">
                                                                <input type="text" style="display: none"
                                                                       class="form-control"
                                                                       name="keystype"
                                                                       id="keystype"
                                                                       value="${type}">
                                                                <div class="form-group">
                                                                    <select class="form-control"
                                                                            id="values${mapPatient.key}"
                                                                            name="values">
                                                                    <c:if test="${mapPatient.value.Value == 'Yes'}">
                                                                        <option selected value="Yes">Yes
                                                                        </option>
                                                                        <option value="No">No</option>
                                                                    </c:if>
                                                                    <!-- En el caso que este seleccionado el valor 'NO'-->
                                                                    <c:if test="${mapPatient.value.Value == 'No'}">
                                                                        <option value="Yes">Yes</option>
                                                                        <option selected value="No">No</option>
                                                                    </c:if>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise> <!-- DBOBject-->
                                                <c:set var="count" value="${count+1}"/>
                                                <div class="row">
                                                    <div class="col-md-offset-1 col-md-11">
                                                        <label class="control-label">
                                                            <input type="checkbox" id="${mapPatient.key}"
                                                                   name="deletefields"
                                                                   value="${mapPatient.key}"> ${mapPatient.key}
                                                        </label>
                                                        <span class="glyphicon glyphicon-info-sign" data-toggle="modal"
                                                              aria-hidden="true" data-target="#keypinfo"></span>
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subkeys${count}"
                                                               id="subkeys" value="${mapPatient.key}">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subkeystype"
                                                               id="subkeystype"
                                                               value="BasicDBObject">
                                                    </div>
                                                </div>
                                                <c:forEach items="${mapPatient.value}" var="mapPatientParameters">
                                                    <c:set var="subtype" scope="session"
                                                           value="${mapPatientParameters.value.Type}"/>
                                                    <c:choose>
                                                        <c:when test="${subtype == 'Long' || subtype == 'Integer' || subtype == 'Double'}">
                                                            <div class="row">
                                                                <div class="col-md-offset-2 col-md-3">
                                                                    <label class="control-label">
                                                                        <input onclick="hidesubFields('${mapPatientParameters.key}')"
                                                                               type="checkbox"
                                                                               id="${mapPatientParameters.key}"
                                                                               name="deletefields"
                                                                               value="${mapPatient.key}.${mapPatientParameters.key}"> ${mapPatientParameters.key}
                                                                    </label>
                                                                </div>
                                                                <div class="col-md-6 ">
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}"
                                                                           value="${mapPatientParameters.key}">
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}type" id="subsubkeys"
                                                                           value="${subtype}">
                                                                    <input type="number" class="form-control"
                                                                           id="subsubvalues${mapPatientParameters.key}"
                                                                           name="subsubvalues${count}"
                                                                           value="${mapPatientParameters.value.Value}"
                                                                           placeholder="Enter Value">
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${subtype == 'String'}">
                                                            <div class="row">

                                                                <div class="col-md-offset-2 col-md-3">

                                                                    <label class="control-label">
                                                                        <input onclick="hidesubFields('${mapPatientParameters.key}')"
                                                                               type="checkbox"
                                                                               id="${mapPatientParameters.key}"
                                                                               name="deletefields"
                                                                               value="${mapPatient.key}.${mapPatientParameters.key}"> ${mapPatientParameters.key}
                                                                    </label>
                                                                </div>
                                                                <div class="col-md-6 ">
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}"
                                                                           value="${mapPatientParameters.key}">
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}type" id="subsubkeys"
                                                                           value="${subtype}">
                                                                    <input type="text" class="form-control"
                                                                           id="subsubvalues${mapPatientParameters.key}"
                                                                           name="subsubvalues${count}"
                                                                           value="${mapPatientParameters.value.Value}"
                                                                           placeholder="Enter Value">
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${subtype == 'Textarea'}">
                                                            <div class="row">
                                                                <div class="col-md-offset-2 col-md-3">
                                                                    <label class="control-label">
                                                                        <input onclick="hidesubFields('${mapPatientParameters.key}')"
                                                                               type="checkbox"
                                                                               id="${mapPatientParameters.key}"
                                                                               name="deletefields"
                                                                               value="${mapPatient.key}.${mapPatientParameters.key}"> ${mapPatientParameters.key}
                                                                    </label>
                                                                </div>
                                                                <div class="col-md-6 ">
                                                                    <label>
                                                                        <input type="text" style="display: none"
                                                                               class="form-control"
                                                                               name="subsubkeys${count}"
                                                                               value="${mapPatientParameters.key}">
                                                                    </label>
                                                                    <label for="subsubkeys"></label>
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}type" id="subsubkeys"
                                                                           value="${subtype}">
                                                                    <label for="subsubvalues${mapPatientParameters.key}"></label>
                                                                    <textarea class="form-control"
                                                                              id="subsubvalues${mapPatientParameters.key}"
                                                                              name="subsubvalues${count}"

                                                                              placeholder="Enter Value">${mapPatientParameters.value.Value}</textarea>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${subtype == 'Date'}">
                                                            <div class="row">
                                                                <div class="col-md-offset-2 col-md-3">
                                                                    <label class="control-label">
                                                                        <input onclick="hidesubFields('${mapPatientParameters.key}')"
                                                                               type="checkbox"
                                                                               id="${mapPatientParameters.key}"
                                                                               name="deletefields"
                                                                               value="${mapPatient.key}.${mapPatientParameters.key}"> ${mapPatientParameters.key}
                                                                    </label>
                                                                </div>
                                                                <div class="col-md-6 ">
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}"
                                                                           value="${mapPatientParameters.key}">
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}type" id="subsubkeys"
                                                                           value="${subtype}">
                                                                    <input type="date" class="form-control"
                                                                           id="subsubvalues${mapPatientParameters.key}"
                                                                           name="subsubvalues${count}"
                                                                           value="${mapPatientParameters.value.Value}"/>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${subtype == 'Boolean'}">
                                                            <div class="row">
                                                                <div class="col-md-offset-2 col-md-3">
                                                                    <label class="control-label">
                                                                        <input onclick="hidesubFields('${mapPatientParameters.key}')"
                                                                               type="checkbox"
                                                                               id="${mapPatientParameters.key}"
                                                                               name="deletefields"
                                                                               value="${mapPatient.key}.${mapPatientParameters.key}"> ${mapPatientParameters.key}
                                                                    </label>
                                                                </div>
                                                                <div class="col-md-6 ">
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}"
                                                                           value="${mapPatientParameters.key}">
                                                                    <input type="text" style="display: none"
                                                                           class="form-control"
                                                                           name="subsubkeys${count}type" id="subsubkeys"
                                                                           value="${subtype}">
                                                                    <select class="form-control"
                                                                            id="subsubvalues${mapPatientParameters.key}"
                                                                            name="subsubvalues${count}">
                                                                        <c:if test="${mapPatientParameters.value.Value == 'Yes'}">
                                                                            <option selected value="Yes">Yes
                                                                            </option>
                                                                            <option value="No">No</option>
                                                                        </c:if>
                                                                        <!-- En el caso que este seleccionado el valor 'NO'-->
                                                                        <c:if test="${mapPatientParameters.value.Value == 'No'}">
                                                                            <option value="Yes">Yes</option>
                                                                            <option selected value="No">No</option>
                                                                        </c:if>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                                <div class="col-md-offset-1 col-md-11">
                                                    <button type="button" class="btn-sm btn-primary"
                                                            id="addSubfields()"
                                                            onClick="addStaticSubfields(${count})"
                                                            style="margin-bottom: 15px;">
                                                        Add new Fields to ${mapPatient.key}</button>
                                                    <button type="button" class="btn-sm btn-primary"
                                                            id="deleteSubfields"
                                                            onclick="delete_subfields('StaticSubFields${count}')">-
                                                    </button>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="row" id="StaticSubFields${count}"></div>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
                            <div class="col-md-offset-1 col-md-9">
                                <h3>Add new Patient Fields
                                    <small>
                                        The patient will be update with the new parameters.
                                    </small>
                                </h3>
                            </div>
                            <div class="row" id="Fields"></div>
                            <div class="row" id="SubKeyp1"></div>
                            <div class="row" id="SubFields1"></div>
                            <div class="row" id="SubKeyp2"></div>
                            <div class="row" id="SubFields2"></div>

                            <div class="col-md-offset-2 btn-group btn-group-justified" style="text-align:center;">
                                <div class="col-md-2">
                                    <button type="button"
                                            class="btn-sm btn-primary button-field" id="addPaciente()"
                                            onClick="add_field()">Add new Field
                                    </button>
                                </div>
                                <div class="col-md-2">
                                    <button type="button"
                                            class="btn-sm btn-primary button-field" id="myDeleteFunction()"
                                            onclick="deleteFields('Fields')">Delete Field
                                    </button>
                                </div>
                                <div class="col-md-2">
                                    <button type="button"
                                            class="btn-sm btn-primary button-field" id="addSubKeyP()"
                                            onClick="add_compound_field()">Add new Subfield
                                    </button>
                                </div>
                                <div class="col-md-2">
                                    <button type="button"
                                            class="btn-sm btn-primary button-field" id="myDeleteFunctionKeyP()"
                                            onClick="deleteCompoundFields()">Delete Subfield
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="tab">
                            <div class="col-md-offset-1 col-md-8">
                                <h3>Add samples associated with your patient
                                </h3>

                            </div>
                            <div class="col-md-offset-1 col-md-8">
                                <h4><span class="glyphicon glyphicon-alert"></span>
                                    <small>
                                        *This section currently accepts gene expression samples in Nanostring
                                        format (RCC files)
                                    </small>
                                </h4>
                            </div>
                            <c:forEach items="${patientList.parameters._clinicalSamples}" var="muestras">
                                <div class="col-md-offset-2 col-md-6">
                                    <label class="control-label">
                                        <input type="checkbox" name="deletemuestras"
                                               value="${muestras.sample_name}">
                                        Sample:
                                    </label>
                                </div>
                                <div>
                                    <label class="col-md-2 col-md-offset-3 control-label">${"Nombre Muestra"}</label>
                                    <div class="col-md-5">
                                        <label class="form-control">${muestras.sample_name}</label>
                                    </div>
                                    <c:forEach items="${muestras.metadata}" var="metadato" end="1">
                                        <label class="col-md-2 col-md-offset-3 control-label">${metadato.key}</label>
                                        <div class="col-md-5">
                                            <label class="form-control">${metadato.value}</label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                            <div>
                                <div class="col-md-offset-2 col-md-3 ">
                                    <h3>Attach sample
                                    </h3>
                                </div>
                                <div class="col-md-3 col-md" style="font-size: 12px; margin: 15px">
                                    <input type="file" name="muestra" id="muestra" multiple/>
                                </div>
                                <div class="col-md-offset-2 col-md-8">
                                    <h3 style="margin-bottom: 20px;"> Insert Metadata
                                        <small>
                                            Insert information associated with the attached Sample
                                        </small>
                                    </h3>
                                </div>
                                <c:forEach items="${sessionScope.ClavesMuestra}" var="mapMuestra">
                                    <tr>
                                        <label class="col-md-3 col-md-offset-3 control-label">${mapMuestra.key}</label>
                                        <div class="col-md-3 ">
                                            <input type="text" style="display: none" class="form-control"
                                                   name="MetaSampleKey" id="MetaSampleKey"
                                                   value="${mapMuestra.key}">
                                            <input type="text" class="form-control" id="MetaSamplevalue"
                                                   name="MetaSamplevalue"
                                                   placeholder="Enter Value">
                                        </div>
                                    </tr>
                                </c:forEach>
                                <div class="table-row-cell">
                                    <div class="row" id="MetaSampleFields"></div>
                                    <div class="btn-group btn-group-justified" style="text-align:center;">
                                        <button style="margin: 5px" type="button"
                                                class=" btn-sm btn-primary" id="addmetasamples"
                                                onClick="checkIfEmptySample()">New Metadata
                                        </button>

                                        <button style="margin-top: 20px; margin-bottom: 20px" type="button"
                                                class=" btn-sm btn-primary" id="myDeleteFunction3()"
                                                onclick="deleteFields('MetaSampleFields')">Delete Metadata
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <br><br>
                        </div>
                        <div class="tab" style="margin-right: 60px;">
                            <div class="col-md-offset-1 col-md-8">
                                <h3>Insert Files
                                    <small>
                                        Attach files associated with your patient
                                    </small>
                                </h3>
                            </div>
                            <c:forEach items="${patientList.parameters._files}" var="ficheros">
                                <label class="col-md-offset-2 col-md-6 control-label">${"File: "}</label>
                                <div>
                                    <label class="col-md-2 col-md-offset-3 control-label">${"Filename"}</label>
                                    <div class="col-md-5">
                                        <label class="form-control">${ficheros.filename}</label>
                                    </div>
                                </div>
                                <c:forEach items="${ficheros.metadata}" var="metadatos">
                                    <div>
                                        <label class="col-md-2 col-md-offset-3 control-label">${metadatos.key}</label>
                                        <div class="col-md-5 ">
                                            <label class="form-control">${metadatos.value}</label>
                                        </div>
                                    </div>
                                </c:forEach>

                                <label class="col-md-offset-3 col-md checkbox-inline"
                                       style="margin-top: 10px;margin-bottom: 10px; ">
                                    <input type="checkbox" name="deleteficheros" value="${ficheros.filename}">
                                    Delete
                                    file: ${ficheros.filename}
                                </label>
                            </c:forEach>

                            <div>
                                <div class="col-md-offset-2 col-md-3">
                                    <h3>Attach new file
                                    </h3>
                                </div>
                                <div class="col-md-3" style="font-size: 12px; margin: 15px">
                                    <input type="file" id="fichero" name="fichero"
                                           placeholder="Inserta fichero" multiple/>
                                </div>
                            </div>
                            <c:forEach items="${sessionScope.ClavesFichero}" var="mapfichero">
                                <tr>
                                    <label class="col-md-2 col-md-offset-2 control-label">${mapfichero.key}</label>
                                    <div class="col-md-5 ">
                                        <input type="text" style="display: none" class="form-control"
                                               name="MetadataKey"
                                               id="MetadataKey"
                                               value="${mapfichero.key}">
                                        <input type="text" class="form-control" id="Metadatavalue"
                                               name="Metadatavalue"
                                               placeholder="Enter Value">
                                    </div>
                                </tr>
                            </c:forEach>
                            <div class="col-md-offset-2 col-md-8">
                                <h3>Insert Metadata
                                    <small>
                                        Insert information associated with the attached file
                                    </small>
                                </h3>
                            </div>

                            <div class="table-row-cell">
                                <div class="row" id="MetaFields"></div>
                                <div class="btn-group btn-group-justified" style="text-align:center;">
                                    <button style="margin: 5px" type="button"
                                            class=" btn-sm btn-primary" id="addMetadatos()"
                                            onClick="checkIfEmpty()">New Metadata
                                    </button>

                                    <button style="margin-top: 20px; margin-bottom: 20px" type="button"
                                            class=" btn-sm btn-primary" id="myDeleteFunction2()"
                                            onclick="deleteFields('MetaFields')">Delete Metadata
                                    </button>
                                </div>
                                <input type="button" onclick="pregunta()" class="btn-block btn-primary"
                                       value="Update Patient" style="margin-right: -30px">
                            </div>
                        </div>

                        <div class="col-md-12">
                            <div style="text-align:center;margin-top:40px; ">
                                <button type="button" class=" btn-sm btn-primary" style="margin-right: 50px;"
                                        id="prevBtn" onclick="nextPrev(-1)">
                                    Prev
                                </button>
                                <button type="button" class=" btn-sm btn-primary" id="nextBtn"
                                        onclick="nextPrev(1)">
                                    Next
                                </button>
                            </div>
                            <!-- Circles which indicates the steps of the form: -->
                            <div style="text-align:center;margin-top:40px;">
                                <span class="step"></span>
                                <span class="step"></span>
                                <span class="step"></span>
                            </div>
                        </div>
                        <div>
                            <form id="contador">
                                <input type="hidden" id="cont" value="${count}">
                            </form>
                        </div>
                    </form>
                </c:forEach>
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
                If you select a compound field, its associated simple fields will be deleted.
            </div>

        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/footer.jsp" %>
</body>

<link href='<c:url value="/resources/css/styleform.css" />' rel="stylesheet">

<script src="resources/js/otherFunctions.js"></script>
<script src="resources/js/paciente.js"></script>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
<script src="resources/js/stepsForm.js"></script>
</html>

