<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
</head>

<script>alert("Your form has been successfully filled.");
window.close();
</script>


<body>

<%--<jsp:include page="/WEB-INF/jsp/header.jsp">--%>
<%--    <jsp:param name="page" value="none"/>--%>
<%--</jsp:include>--%>

<div class="container">

    <div class="alert alert-info" role="alert" style="margin-top:20px;">
        <p>
            Your form has been successfully filled.
        </p>
    </div>

    <div class="panel panel-default">
        <div class="panel-body">
            <form>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary btn-lg btn-block"
                            formaction=<c:url value="/home.jsp"/>>
                        Go to Home
                        <span class="glyphicon glyphicon-home"></span>
                    </button>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary btn-lg btn-block"
                            formaction=<c:url value="/searchPage.jsp"/>>
                        Search the patient
                        <span class="glyphicon glyphicon-search"></span>
                    </button>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary btn-lg btn-block"
                            formaction=<c:url value="/createPatient.jsp"/>>
                        Add new Patient <span class="glyphicon glyphicon-arrow-right"></span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
<%@ include file="/WEB-INF/jsp/Navigationbar.jsp" %>