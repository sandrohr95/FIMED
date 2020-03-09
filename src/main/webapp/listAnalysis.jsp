<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="es.uma.khaos.mongo.api.beans.service.Database" %>


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
    Database database = new Database();

    String id = (String) sesion.getAttribute("userId");
    sesion.setAttribute("listAnalysis", database.get_listAnalysis(id));

    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");
%>

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="analysisPage.jsp">Gene expression level analysis</a></li>
            <li class="breadcrumb-item active" aria-current="page">Previous analysis</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header" style="margin-top: 0px">
                <h1><strong>Previous Analysis</strong></h1>
            </div>
            <table class="table table-striped table-condensed" align="center">
                <tbody>
                <c:forEach var="analysis" items="${sessionScope.listAnalysis}">
                    <tr>
                        <td class="col-md-6"><strong>Analysis name:  </strong>${analysis.analysis_name} </td>
                        <td class="col-md-6">
                            <div class="col-md-3">
                                <form id="previousAnalysis" action="previousAnalysis.jsp" method="get" enctype="multipart/form-data" accept-charset="UTF-8">
                                    <input type="hidden" class="form-control" name="id" id="id"
                                           value="${sessionScope.userId}">
                                    <input type="hidden" class="form-control" name="id_analysis" id="id_analysis"
                                           value="${analysis._id}">
                                    <button type="submit" class="btn btn-default btn-sm">
                                         <span class="glyphicon glyphicon-circle-arrow-up"
                                               aria-hidden="true"></span>
                                        View analysis
                                    </button>
                                </form>
                            </div>
                            <div class="col-md-3">
                                <form action="api/delete_analysis" method="get" enctype="multipart/form-data"
                                      name="${analysis._id}" id="${analysis._id}" accept-charset="UTF-8">

                                    <input type="hidden" class="form-control" name="id" value="${sessionScope.userId}">
                                    <input type="hidden" class="form-control" name="id_analysis" value="${analysis._id}">

                                    <button type="button" class="btn btn-default btn-sm"
                                            onclick="pregunta_delete_analysis('${analysis._id}')">
                                         <span class="glyphicon glyphicon-remove"
                                               aria-hidden="true"></span>
                                        Delete Analysis
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

        </div>
    </div>

</div>


</body>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
<script src="resources/js/otherFunctions.js"></script>


</html>











