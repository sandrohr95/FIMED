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

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<div class="container" data-ng-init="init()">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Analysis</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">
            <h1>Gene expression analysis</h1>
            <div class="row-fluid">
                <h3>Gene regulatory network</h3>
                <div id="loading">
                    <div class="col-md-12" id="loader"></div>
                    <div class="card col-md-12" style="margin-top: 50px" align="center">
                        <div class="card-body">
                            This process could take some minutes, please wait.
                        </div>
                    </div>
                </div>
                <div id="alertError" align="center" class="alert alert-danger col-md-12" style="display: none">
                    <strong>There has been an error executing the service.</strong>
                    <br>
                    Check that the format of the samples selected for the analysis is appropriate.
                </div>
                <br>
                <div id="codigohtml"></div>
            </div>
            <%@ include file="/WEB-INF/jsp/contactMsg.jsp" %>
        </div>
    </div>
</div><!-- /.container -->

<%@ include file="/WEB-INF/jsp/footer.jsp" %>

</body>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
</html>