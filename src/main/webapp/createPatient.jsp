<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.dao.PacienteDao" %>
<script type='text/javascript' src='http://code.jquery.com/jquery.min.js'></script>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
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
    sesion.setAttribute("attributes", pacienteDao.find_form_attributes(id));
    sesion.setAttribute("ClavesFichero", pacienteDao.find_fields_keys_files(id));
    sesion.setAttribute("ClavesMuestra", pacienteDao.find_fields_keys_samples(id));

%>
<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Create Patient</li>
        </ol>
    </nav>

    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header" style="margin-top: 0px">
                <h1>Add Patient</h1>
            </div>
            <h3>
                Add Patients Dynamically
                <small>
                    ADDITIONAL INFORMATION
                    <span class="glyphicon glyphicon-info-sign" data-toggle="modal" aria-hidden="true"
                          data-target="#keypinfo"></span>
                </small>
            </h3>

            <c:choose>
                <c:when test="${not empty sessionScope.attributes}">
                    <form id="crearPaciente" name="FormPaciente" action="api/crearPaciente" method="post"
                          enctype="multipart/form-data" accept-charset="UTF-8">
                        <input type="hidden" class="form-control" name="id" id="id"
                               value="${sessionScope.userId}">
                        <!-- One "tab" for each step in the form: -->
                        <div class="tab">
                            <!--CAMPOS PREDETERMINADOS -->
                            <c:set var="count" value="0" scope="page"/>
                            <!-- El contador se esta incrementando en todas las varibles sencillas -->
                            <c:forEach items="${sessionScope.attributes}" var="attributes" varStatus="contador">
                                <c:set var="type" scope="session" value="${attributes.value}"/>
                                <c:choose>
                                    <c:when test="${type == 'String'}">
                                        <label class="col-md-offset-1 col-md-4 control-label">${attributes.key}</label>
                                        <div class="col-md-6 col-md ">
                                            <input type="text" style="display: none" class="form-control" name="keys"
                                                   id="keysString"
                                                   value="${attributes.key}">
                                            <input type="text" style="display: none" class="form-control"
                                                   name="keystype"
                                                   id="keystypeString"
                                                   value="${type}">
                                            <input type="text" class="form-control" id="valuesString" name="values"
                                                   placeholder="Enter Value">
                                        </div>
                                    </c:when>
                                    <c:when test="${type == 'Textarea'}">
                                        <label class="col-md-offset-1 col-md-4 control-label">${attributes.key}</label>
                                        <div class="col-md-6 col-md ">
                                            <input type="text" style="display: none" class="form-control" name="keys"
                                                   id="keysTextArea"
                                                   value="${attributes.key}">
                                            <input type="text" style="display: none" class="form-control"
                                                   name="keystype"
                                                   id="keysTypeTextArea"
                                                   value="${type}">
                                            <textarea class="form-control" id="valuesTextArea" name="values"
                                                      placeholder="Enter Value"></textarea>
                                        </div>
                                    </c:when>
                                    <c:when test="${type == 'Long' || type == 'Integer' || type == 'Double'}">
                                        <label class="col-md-offset-1 col-md-4 control-label">${attributes.key}</label>
                                        <div class="col-md-6 col-md ">
                                            <input type="text" style="display: none" class="form-control" name="keys"
                                                   id="keysLong"
                                                   value="${attributes.key}">
                                            <input type="text" style="display: none" class="form-control"
                                                   name="keystype"
                                                   id="keystypeLong"
                                                   value="${type}">
                                            <input type="number" class="form-control" id="valuesLong" name="values"
                                                   placeholder="Enter Value">
                                        </div>
                                    </c:when>
                                    <c:when test="${type == 'Date'}">
                                        <label class="col-md-offset-1 col-md-4 control-label">${attributes.key}</label>
                                        <div class="col-md-6 col-md ">
                                            <input type="text" style="display: none" class="form-control" name="keys"
                                                   id="keysDate"
                                                   value="${attributes.key}"/>
                                            <input type="text" style="display: none" class="form-control"
                                                   name="keystype"
                                                   id="keystypeDate"
                                                   value="${type}"/>
                                            <input type="date" class="form-control" id="valuesDate" name="values"
                                                   placeholder="Enter Value"/>
                                        </div>
                                    </c:when>
                                    <c:when test="${type == 'Boolean'}">
                                        <label class="col-md-offset-1 col-md-4 control-label">${attributes.key}</label>
                                        <div class="col-md-6 col-md ">
                                            <input type="text" style="display: none" class="form-control"
                                                   name="keystype"
                                                   id="keystypeBoolean"
                                                   value="${type}">
                                            <input type="text" style="display: none" class="form-control" name="keys"
                                                   id="keysBoolean"
                                                   value="${attributes.key}">
                                            <div class="form-group">
                                                <select class="form-control" id="values" name="values">
                                                    <option value="Yes">Yes</option>
                                                    <option selected value="No">No</option>
                                                </select>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise> <!--BasicDBObject-->
                                        <c:set var="count" value="${count+1}"/>
                                        <div class="col-md-offset-1 col-md-10">
                                            <label class="control-label">${attributes.key}</label>
                                            <input type="text" style="display: none" class="form-control"
                                                   name="subkeys${count}"
                                                   id="subkeys"
                                                   value="${attributes.key}">
                                            <input type="text" style="display: none" class="form-control"
                                                   name="subkeystype"
                                                   id="subkeystype"
                                                   value="BasicDBObject">
                                        </div>
                                        <c:forEach items="${attributes.value}" var="mapAttributes">
                                            <c:set var="subtype" scope="session"
                                                   value="${mapAttributes.value}"/>
                                            <c:choose>
                                                <c:when test="${subtype == 'Long' || subtype == 'Integer' || subtype == 'Double'}">
                                                    <label class="col-md-offset-2 col-md-3 control-label">${mapAttributes.key}</label>
                                                    <div class="let col-md-6 col-md">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}"
                                                               id="subsubkeys${subtype}" value="${mapAttributes.key}">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}type" id="subsubkeys${subtype}"
                                                               value="${subtype}">
                                                        <input type="number" class="form-control"
                                                               id="subsubvalues${subtype}"
                                                               name="subsubvalues${count}" placeholder="Enter Value">

                                                    </div>
                                                </c:when>
                                                <c:when test="${subtype == 'String'}">
                                                    <label class="col-md-offset-2 col-md-3 control-label">${mapAttributes.key}</label>
                                                    <div class="let col-md-6 col-md">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}"
                                                               id="subsubkeys${subtype}" value="${mapAttributes.key}">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}type" id="subsubkeys${subtype}"
                                                               value="${subtype}">
                                                        <input type="text" class="form-control"
                                                               id="subsubvalues${subtype}"
                                                               name="subsubvalues${count}" placeholder="Enter Value">
                                                    </div>
                                                </c:when>
                                                <c:when test="${subtype == 'Textarea'}">
                                                    <label class="col-md-offset-2 col-md-3 control-label">${mapAttributes.key}</label>
                                                    <div class="let col-md-6 col-md">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}"
                                                               id="subsubkeys${subtype}" value="${mapAttributes.key}">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}type" id="subsubkeys${subtype}"
                                                               value="${subtype}">
                                                        <textarea type="text" class="form-control"
                                                                  id="subsubvalues${subtype}"
                                                                  name="subsubvalues${count}"
                                                                  placeholder="Enter Value"></textarea>
                                                    </div>
                                                </c:when>
                                                <c:when test="${subtype == 'Date'}">
                                                    <label class="col-md-offset-2 col-md-3 control-label">${mapAttributes.key}</label>
                                                    <div class="let col-md-6 col-md">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}"
                                                               id="subsubkeys${subtype}" value="${mapAttributes.key}">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}type" id="subsubkeys${subtype}"
                                                               value="${subtype}">
                                                        <input type="date" class="form-control" id="subsubvalues"
                                                               name="subsubvalues${count}" placeholder="Enter Value">
                                                    </div>
                                                </c:when>
                                                <c:when test="${subtype == 'Boolean'}">
                                                    <label class="col-md-offset-2 col-md-3 control-label">${mapAttributes.key}</label>
                                                    <div class="col-md-6 col-md ">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}"
                                                               id="subsubkeys${subtype}" value="${mapAttributes.key}">
                                                        <input type="text" style="display: none" class="form-control"
                                                               name="subsubkeys${count}type" id="subsubkeys${subtype}"
                                                               value="${subtype}">
                                                        <select class="form-control" id="subsubvalues${subtype}"
                                                                name="subsubvalues${count}">
                                                            <option value="Yes">Yes</option>
                                                            <option selected value="No">No</option>
                                                        </select>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    "${subtype}"
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <div class="row" id="StaticSubFields${count}"></div>
                            <!-- CONTADOR -->
                            <input type="hidden" id="cont" value="${count}">
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

                            <div>
                                <div class="col-md-offset-2 col-md-3 ">
                                    <h3>Attach sample
                                    </h3>
                                </div>
                                <div class="col-md-3 col-md" style="font-size: 12px; margin: 15px">
                                    <input type="file" name="muestra" id="muestra" placeholder="Choose Sample File"
                                           multiple/>
                                </div>
                            </div>
                            <div class="col-md-offset-2 col-md-8">
                                <h3 style="margin-bottom: 20px;"> Add Metadata
                                    <small>
                                        Add information associated with the attached Sample
                                    </small>
                                </h3>
                            </div>
                            <c:forEach items="${sessionScope.ClavesMuestra}" var="mapMuestra">
                                <tr>
                                    <label class="col-md-3 col-md-offset-3 control-label">${mapMuestra.key}</label>
                                    <div class="col-md-3 ">
                                        <input type="text" style="display: none" class="form-control"
                                               name="MetaSampleKey"
                                               id="MetaSampleKey"
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
                            <br><br>
                        </div>

                        <div class="tab">
                            <!-- CAMPOS PREDETERMINADOS PARA FICHEROS -->
                            <div class="col-md-offset-1 col-md-8">
                                <h3>Add Files
                                    <small>
                                        Attach files associated with your patient
                                    </small>
                                </h3>
                            </div>

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
                                    <label class="col-md-3 col-md-offset-3 control-label">${mapfichero.key}</label>
                                    <div class="col-md-3 ">
                                        <input type="text" style="display: none" class="form-control" name="MetadataKey"
                                               id="MetadataKey"
                                               value=""${mapfichero.key}">
                                        <input type="text" class="form-control" id="Metadatavalue" name="Metadatavalue"
                                               placeholder="Enter Value">
                                    </div>
                                </tr>
                            </c:forEach>
                            <div class="col-md-offset-2 col-md-8">
                                <h3 style="margin-bottom: 20px;"> Add Metadata
                                    <small>
                                        Add information associated with the attached file
                                    </small>
                                </h3>
                            </div>
                            <div class="table-row-cell">
                                <div class="row" id="MetaFields"></div>
                                <div class="btn-group btn-group-justified" style="text-align:center;">
                                    <button style="margin: 5px" type="button"
                                            class=" btn-sm btn-primary" id="addmetadatos"
                                            onClick="checkIfEmpty()">New Metadata
                                    </button>

                                    <button style="margin-top: 20px; margin-bottom: 20px" type="button"
                                            class=" btn-sm btn-primary" id="myDeleteFunction2()"
                                            onclick="deleteFields('MetaFields')">Delete Metadata
                                    </button>
                                </div>
                            </div>
                            <input type="button" onclick="pregunta()" class="btn-block btn-primary"
                                   value="Insert Patient">
                        </div>
                        <div class="col-md-12">
                            <div style="text-align:center;margin-top:40px;">
                                <button type="button" class=" btn-sm btn-primary" id="prevBtn" onclick="nextPrev(-1)">
                                    Prev
                                </button>
                                <button type="button" class=" btn-sm btn-primary" id="nextBtn" onclick="nextPrev(1)">
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
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="id" id="id_user"
                                   value="${sessionScope.userId}">
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning">
                        <strong>Patient insertion information</strong> Before inserting your patients into FIMED you
                        must
                        <a href="formDesign.jsp" class="alert-link">go to design the form</a> for the insertion of the
                        clinical variables
                    </div>
                </c:otherwise>
            </c:choose>
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
                        <h4 align="center">How to add a new Patient?</h4>
                    </div>
                    <div class="panel-body">
                        In this link users can find how to add clinical patients information in FIMED
                        <p>
                            <a href="https://youtu.be/4bxuH9TVkc8?t=191" target="_blank">FIMED tutorial (Add
                                Patient(s))</a>
                        </p>
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

<script src="resources/js/paciente.js"></script>
<script src="resources/js/stepsForm.js"></script>
<script src="resources/js/otherFunctions.js"></script>

</html>

