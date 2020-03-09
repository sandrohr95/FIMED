<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
    <c:if test="${sessionScope.conectado!='true'}">
        <c:redirect url="login.jsp"/>
    </c:if>
</head>
<body>

<%--<jsp:include page="/WEB-INF/jsp/header.jsp">--%>
<%--    <jsp:param name="page" value="none"/>--%>
<%--</jsp:include>--%>

<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item active" aria-current="page">Home</li>
        </ol>
    </nav>

    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header" style="margin-top: 0px">
                <!--	<img src="resources/images/Fimed_logo.png">-->
                <h1>Add or search a patient (s):</h1>
            </div>

            <form>
                <div class="row">
                    <div class="col-md-6">
                        <h3>Add patient's data columns </h3>
                        <button type="submit" class="btn btn-primary btn-lg btn-block"
                                formaction=<c:url value="/formDesign.jsp"/>>Form design
                        </button>
                    </div>
                    <div class="col-md-6">
                        <h3>Search patients</h3>
                        <button type="submit" class="btn btn-primary btn-lg btn-block"
                                formaction=<c:url value="/searchPage.jsp"/>>Search patient (s)
                        </button>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <h3>Add new patient</h3>
                        <button type="submit" class="btn btn-primary btn-lg btn-block"
                                formaction=<c:url value="/createPatient.jsp"/>>Add patient (s)
                        </button>
                    </div>
                    <div class="col-md-6">
                        <h3>Analyze your patients' genetic expression data</h3>
                        <button type="submit" class="btn btn-primary btn-lg btn-block"
                                formaction=<c:url value="/analysisPage.jsp"/>>Gene level expression analysis
                        </button>
                    </div>
                </div>
            </form>

        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/footer.jsp" %>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
</body>
</html>
