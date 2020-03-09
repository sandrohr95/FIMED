<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Fimed</title>
	<%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
</head>
<c:set var="response" value='${it}' />
<body>

	<jsp:include page="/WEB-INF/jsp/header.jsp">
		<jsp:param name="page" value="none" />
	</jsp:include>

	<div class="container">

	<div class="alert alert-info" role="alert" style="margin-top: 20px;">
			<p>Please fill the patient's fields.</p>
		</div>
	</div>

</body>
</html>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
