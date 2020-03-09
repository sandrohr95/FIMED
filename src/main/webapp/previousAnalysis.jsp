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
        <c:redirect url="login.jsp"/>
    </c:if>
    <script src="resources/js/response.js"></script>
    <script type="text/javascript" src="http://cdn.pydata.org/bokeh/release/bokeh-0.12.6.min.js"></script>
    <link rel="stylesheet" href="https://cdn.pydata.org/bokeh/release/bokeh-1.0.2.min.css" type="text/css"/>
    <link rel="stylesheet" href="https://cdn.pydata.org/bokeh/release/bokeh-widgets-1.0.2.min.css" type="text/css"/>
    <link rel="stylesheet" href="https://cdn.pydata.org/bokeh/release/bokeh-tables-1.0.2.min.css" type="text/css">
    <script type="text/javascript" src="https://cdn.pydata.org/bokeh/release/bokeh-1.0.2.min.js"></script>
    <script type="text/javascript" src="https://cdn.pydata.org/bokeh/release/bokeh-api-1.0.2.min.js"></script>
    <script type="text/javascript" src="https://cdn.pydata.org/bokeh/release/bokeh-widgets-1.0.2.min.js"></script>
    <script type="text/javascript" src="https://cdn.pydata.org/bokeh/release/bokeh-tables-1.0.2.min.js"></script>
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
</head>
<body>
<%
    HttpSession sesion = request.getSession(true);
    String id = (String) sesion.getAttribute("userId");
    String id_analysis = request.getParameter("id_analysis");
    Database database = new Database();

    sesion.setAttribute("analysis", database.getAnalysis(id, id_analysis));
    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");
%>

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<div class="container" data-ng-init="init()">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="analysisPage.jsp">Gene expression level analysis</a></li>
            <li class="breadcrumb-item"><a href="listAnalysis.jsp">Previous analysis</a></li>
            <li class="breadcrumb-item active" aria-current="page">Result analysis</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="panel-body">
                <h1>Gene expression analysis</h1>
                <div class="row-fluid">
                    <h3><strong>Analysis name:</strong> ${sessionScope.analysis.name_analysis}</h3>
                    ${sessionScope.analysis.result}
                </div>
            </div>
            <%@ include file="/WEB-INF/jsp/contactMsg.jsp" %>
        </div>
    </div>
</div><!-- /.container -->

<%@ include file="/WEB-INF/jsp/footer.jsp" %>

</body>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
</html>