<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
</head>

<body>

<%--<jsp:include page="/WEB-INF/jsp/header.jsp">--%>
<%--    <jsp:param name="page" value="none"/>--%>
<%--</jsp:include>--%>

<div class="container">

    <div class="alert alert-info" role="alert" style="margin-top:20px;">
        <p>
            The analysis has been delete successfully
        </p>
    </div>

    <form>
        <div>
            <button type="submit" class="btn btn-link"
                    formaction=<c:url value="/home.jsp"/>>Go to Home
            </button>
        </div>
    </form>
</div>

</body>
</html>
<%@ include file="/WEB-INF/jsp/Navigationbar.jsp" %>