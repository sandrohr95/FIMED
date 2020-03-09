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

		<div class="alert alert-info" role="alert" style="margin-top: 20px;">
			<p>The username and/or the password are not correct or you're not registered in the system yet.</p>
			<p>If you are not registered, go to the: <a href="registerUser.jsp">Registration form</a></p>	
		</div>

	</div>
	<%@ include file="/WEB-INF/jsp/footer.jsp"%>
</body>
</html>