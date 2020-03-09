<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>
	<%@ include file="/WEB-INF/jsp/headerHtml.jsp"%>
</head>
<c:set var="response" value='${it}' />
<body>

<%--<jsp:include page="/WEB-INF/jsp/header.jsp">--%>
<%--	<jsp:param name="page" value="none" />--%>
<%--</jsp:include>--%>

<div class="container">

	<div class="alert alert-info" role="alert" style="margin-top:20px;">
		<p>
			Something is wrong. Please, contact with the administrators.			
		</p>
	</div>

</div>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>
</body>
</html>
<%@ include file="/WEB-INF/jsp/Navigationbar.jsp" %>