<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.dao.PacienteDao" %>
<script type='text/javascript' src='http://code.jquery.com/jquery.min.js'></script>

<!DOCTYPE html>
<html>
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
    <c:if test="${sessionScope.conectado!='true'}">
        <c:redirect url="login.jsp"/>
    </c:if>
</head>
<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<body>
<%
    HttpSession sesion = request.getSession(true);
    String id = (String) sesion.getAttribute("userId");
    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");
    System.out.println("userId: " + id);

    PacienteDao pacienteDao = new PacienteDao();
    sesion.setAttribute("Attributes", pacienteDao.find_form_attributes(id));
    sesion.setAttribute("ClavesFichero", pacienteDao.find_fields_keys_files(id));
    sesion.setAttribute("ClavesMuestra", pacienteDao.find_fields_keys_samples(id));
%>
<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Form Design</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header" style="margin-top: 0px">
                <h1>Form Design</h1>
            </div>
            <h3>
                Add attributes dynamically
                <small>
                    ADDITIONAL INFORMATION
                    <span class="glyphicon glyphicon-info-sign" data-toggle="modal" aria-hidden="true"
                          data-target="#keypinfo"></span>
                </small>
            </h3>

            <form id="crearPaciente" name="FormDesign" action="api/formDesign" method="post"
                  enctype="multipart/form-data" accept-charset="UTF-8">

                <!--CAMPOS PREDETERMINADOS -->
                <c:set var="count" value="0" scope="page"/>
                <!-- El contador se esta incrementando en todas las varibles sencillas -->
                <c:forEach items="${sessionScope.Attributes}" var="attributes" varStatus="contador">
                    <c:set var="type" scope="session" value="${attributes.value}"/>
                    <c:choose>
                        <c:when test="${type == 'String'}">
                            <div class="row">
                                <label class="col-md-offset-1 col-md-4 control-label">
                                    <input onclick="hideFields('${attributes.key}')"
                                           type="checkbox" id="${attributes.key}"
                                           name="deletefields"
                                           value="${attributes.key}">
                                        ${attributes.key}</label>
                                <div class="col-md-5 col-md ">
                                    <input type="text" style="display: none" class="form-control" name="keys" id="keys"
                                           value="${attributes.key}">
                                    <div class="form-group">
                                        <select class="form-control" id="values${attributes.key}" name="values">
                                            <option selected value="String">String</option>
                                            <option value="Integer">Number</option>
                                            <option value="Date">Date</option>
                                            <option value="Boolean">Checkbox</option>
                                            <option value="Textarea">textarea</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${type == 'Long' || type == 'Integer' || type == 'Double'}">
                            <div class="row">
                                <label class="col-md-offset-1 col-md-4 control-label">
                                    <input onclick="hideFields('${attributes.key}')"
                                           type="checkbox" id="${attributes.key}"
                                           name="deletefields"
                                           value="${attributes.key}">
                                        ${attributes.key}
                                </label>
                                <div class="col-md-5 col-md ">
                                    <input type="text" style="display: none" class="form-control" name="keys" id="keys"
                                           value="${attributes.key}">
                                    <div class="form-group">
                                        <select class="form-control" id="values${attributes.key}" name="values">
                                            <option value="String">String</option>
                                            <option selected value="Integer">Number</option>
                                            <option value="Date">Date</option>
                                            <option value="Boolean">Checkbox</option>
                                            <option value="Textarea">textarea</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${type == 'Date'}">
                            <div class="row">
                                <label class="col-md-offset-1 col-md-4 control-label">
                                    <input onclick="hideFields('${attributes.key}')"
                                           type="checkbox" id="${attributes.key}"
                                           name="deletefields"
                                           value="${attributes.key}">
                                        ${attributes.key}
                                </label>
                                <div class="col-md-5 col-md ">
                                    <input type="text" style="display: none" class="form-control" name="keys" id="keys"
                                           value="${attributes.key}">
                                    <div class="form-group">
                                        <select class="form-control" id="values${attributes.key}" name="values">
                                            <option value="String">String</option>
                                            <option value="Integer">Number</option>
                                            <option selected value="Date">Date</option>
                                            <option value="Boolean">Checkbox</option>
                                            <option value="Textarea">textarea</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${type == 'Boolean'}">
                            <div class="row">
                                <label class="col-md-offset-1 col-md-4 control-label"> <input
                                        onclick="hideFields('${attributes.key}')"
                                        type="checkbox" id="${attributes.key}"
                                        name="deletefields"
                                        value="${attributes.key}">
                                        ${attributes.key}</label>
                                <div class="col-md-5 col-md ">
                                    <input type="text" style="display: none" class="form-control" name="keys" id="keys"
                                           value="${attributes.key}">
                                    <div class="form-group">
                                        <select class="form-control" id="values${attributes.key}" name="values">
                                            <option value="String">String</option>
                                            <option value="Integer">Number</option>
                                            <option value="Date">Date</option>
                                            <option selected value="Boolean">Checkbox</option>
                                            <option value="Textarea">textarea</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${type == 'Textarea'}">
                            <div class="row">
                                <label class="col-md-offset-1 col-md-4 control-label">
                                    <input onclick="hideFields('${attributes.key}')"
                                           type="checkbox" id="${attributes.key}"
                                           name="deletefields"
                                           value="${attributes.key}">
                                        ${attributes.key}
                                </label>
                                <div class="col-md-5 col-md ">
                                    <input type="text" style="display: none" class="form-control" name="keys" id="keys"
                                           value="${attributes.key}">
                                    <div class="form-group">
                                        <select class="form-control" id="values${attributes.key}" name="values">
                                            <option value="String">String</option>
                                            <option value="Integer">Number</option>
                                            <option value="Date">Date</option>
                                            <option value="Boolean">Checkbox</option>
                                            <option selected value="Textarea">textarea</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:set var="count" value="${count+1}"/>
                            <div class="row">
                                <label class="col-md-offset-1 col-md-10 control-label">
                                    <input type="checkbox" id="${attributes.key}"
                                           name="deletefields"
                                           value="${attributes.key}">${attributes.key}</label>
                                <input type="text" style="display: none" class="form-control" name="subkeys${count}"
                                       id="subkeys"
                                       value="${attributes.key}">
                            </div>
                            <c:forEach items="${attributes.value}" var="mapPatientParameters">
                                <c:set var="subtype" scope="session"
                                       value="${mapPatientParameters.value}"/>
                                <div>
                                    <div class="row">
                                        <label class="col-md-offset-2 col-md-3 control-label">
                                            <input onclick="hidesubFields('${mapPatientParameters.key}')"
                                                   type="checkbox"
                                                   id="${mapPatientParameters.key}"
                                                   name="deletefields"
                                                   value="${attributes.key}.${mapPatientParameters.key}"> ${mapPatientParameters.key}
                                        </label>
                                        <div class="let col-md-5 col-md">
                                            <c:choose>
                                                <c:when test="${subtype == 'String'}">
                                                    <input type="text" style="display: none" class="form-control"
                                                           name="subsubkeys${count}"
                                                           id="subsubkeys" value="${mapPatientParameters.key}">
                                                    <div class="form-group">
                                                        <select class="form-control"
                                                                id="subsubvalues${mapPatientParameters.key}"
                                                                name="subsubvalues${count}">
                                                            <option selected value="String">String</option>
                                                            <option value="Integer">Number</option>
                                                            <option value="Date">Date</option>
                                                            <option value="Boolean">Checkbox</option>
                                                            <option value="Textarea">textarea</option>
                                                        </select>
                                                    </div
                                                </c:when>

                                                <c:when test="${subtype == 'Long' || subtype == 'Integer' || subtype =='Double'}">
                                                    <input type="text" style="display: none" class="form-control"
                                                           name="subsubkeys${count}"
                                                           id="subsubkeys" value="${mapPatientParameters.key}">
                                                    <div class="form-group">
                                                        <select class="form-control"
                                                                id="subsubvalues${mapPatientParameters.key}"
                                                                name="subsubvalues${count}">
                                                            <option value="String">String</option>
                                                            <option selected value="Integer">Number</option>
                                                            <option value="Date">Date</option>
                                                            <option value="Boolean">Checkbox</option>
                                                            <option value="Textarea">textarea</option>
                                                        </select>
                                                    </div>
                                                </c:when>

                                                <c:when test="${subtype == 'Date'}">
                                                    <input type="text" style="display: none" class="form-control"
                                                           name="subsubkeys${count}"
                                                           id="subsubkeys" value="${mapPatientParameters.key}">
                                                    <div class="form-group">
                                                        <select class="form-control"
                                                                id="subsubvalues${mapPatientParameters.key}"
                                                                name="subsubvalues${count}">
                                                            <option value="String">String</option>
                                                            <option value="Integer">Number</option>
                                                            <option selected value="Date">Date</option>
                                                            <option value="Boolean">Checkbox</option>
                                                            <option value="Textarea">textarea</option>
                                                        </select>
                                                    </div>
                                                </c:when>
                                                <c:when test="${subtype == 'Boolean'}">
                                                    <input type="text" style="display: none" class="form-control"
                                                           name="subsubkeys${count}"
                                                           id="subsubkeys" value="${mapPatientParameters.key}">
                                                    <div class="form-group">
                                                        <select class="form-control"
                                                                id="subsubvalues${mapPatientParameters.key}"
                                                                name="subsubvalues${count}">
                                                            <option value="String">String</option>
                                                            <option value="Integer">Number</option>
                                                            <option value="Date">Date</option>
                                                            <option selected value="Boolean">Checkbox</option>
                                                            <option value="Textarea">textarea</option>
                                                        </select>
                                                    </div>
                                                </c:when>
                                                <c:when test="${subtype == 'Textarea'}">
                                                    <input type="text" style="display: none" class="form-control"
                                                           name="subsubkeys${count}"
                                                           id="subsubkeys" value="${mapPatientParameters.key}">
                                                    <div class="form-group">
                                                        <select class="form-control"
                                                                id="subsubvalues${mapPatientParameters.key}"
                                                                name="subsubvalues${count}">
                                                            <option value="String">String</option>
                                                            <option value="Integer">Number</option>
                                                            <option value="Date">Date</option>
                                                            <option value="Boolean">Checkbox</option>
                                                            <option selected value="Textarea">textarea</option>
                                                        </select>
                                                    </div>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <div class="let col-md-offset-1 col-md-11">
                                <button type="button" class="btn-sm btn-primary" id="addSubfields()"
                                        onClick="add_static_subfields(${count})" style="margin-bottom: 15px;">
                                    Add subfields to ${attributes.key}</button>
                                <button type="button" class="btn-sm btn-primary" id="deleteSubfields"
                                        onclick="delete_fields('StaticSubFields${count}')">-
                                </button>
                            </div>
                            <div class="row" id="StaticSubFields${count}"></div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <!-- CONTADOR -->
                <input type="hidden" id="cont" value="${count}">

                <div class="col-md-offset-3 col-md-9">
                    <h3>Add new fields to the form
                        <small>
                            The form will be updated with the new parameters
                        </small>
                    </h3>
                </div>
                <div class="table-row-cell">
                    <div class="row" id="Fields"></div>
                    <div class="row" id="SubKeyp1"></div>
                    <div class="row" id="SubFields1"></div>
                    <div class="row" id="SubKeyp2"></div>
                    <div class="row" id="SubFields2"></div>

                    <div class="col-md-offset-2 btn-group btn-group-justified" style="text-align:center;">
                        <div class="col-md-2">
                            <button type="button"
                                    class="btn-sm btn-primary button-field" id="addField()"
                                    onClick="add_fields()">Add new Field
                            </button>
                        </div>
                        <div class="col-md-2">
                            <button type="button"
                                    class="btn-sm btn-primary button-field" id="myDeleteFunction()"
                                    onclick="delete_fields('Fields')">Delete Field
                            </button>
                        </div>
                        <div class="col-md-2">
                            <button type="button"
                                    class="btn-sm btn-primary button-field" id="addSubKeyP()"
                                    onClick="add_compound_key()">Add new Subfield
                            </button>
                        </div>
                        <div class="col-md-2">
                            <button type="button"
                                    class="btn-sm btn-primary button-field" id="myDeleteFunctionKeyP()"
                                    onClick="delete_subfields()">Delete Subfield
                            </button>
                        </div>
                    </div>
                </div>

                <input type="button" onclick="form_ask()" class="btn-block btn-primary" value="Create Form"/>

                <div class="form-group">
                    <input type="hidden" class="form-control" name="id" id="id_user"
                           value="${sessionScope.userId}">
                </div>
                <div class="form-group">
                    <input type="hidden" class="form-control" name="typeForm" id="typeForm"
                           value="design">
                </div>
            </form>
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
                        <h4 align="center">How to design a clinical form?</h4>
                    </div>
                    <div class="panel-body">
                        In this link users can find how to design an electronic Case Report Form (eCRF)
                        in order to capture clinical trial information data.
                        <a href="https://youtu.be/4bxuH9TVkc8?t=90" target="_blank">FIMED tutorial (Design Form)</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/footer.jsp" %>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
</body>

<link href='<c:url value="/resources/css/styleform.css" />' rel="stylesheet">

<script src="resources/js/formdesign.js"></script>
<script src="resources/js/otherFunctions.js"></script>
</html>

