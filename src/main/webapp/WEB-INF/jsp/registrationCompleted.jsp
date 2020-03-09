<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
</head>
<c:set var="response" value='${it}'/>

<script>alert("Your form has been successfully filled.");
window.close();
</script>


<body>

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<div class="container">

    <div class="alert alert-info" role="alert" style="margin-top:20px;">
        <p>
            Your User has been successfully registered
        </p>
    </div>
    <div class="panel panel-default">
        <div class="panel-body">
            <form>
                <div>
                    <button type="submit" class="btn-lg btn-link"
                            formaction=<c:url value="/login.jsp"/>>Go to Login Page
                    </button>
                </div>

            </form>
        </div>
    </div>

</div>

</body>
</html>