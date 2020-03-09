<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp"%>
</head>
<c:set var="response" value='${it}' />
<body>

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none" />
</jsp:include>

<div class="container">

    <div class="panel panel-default">
        <div class="panel-body" align="center">
            <h2>Error</h2>
            <p>Something unexpected happened. This is embarrassing...</p>
            <p>
                <a href="login.jsp">Back to home</a>
            </p>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
</body>
</html>