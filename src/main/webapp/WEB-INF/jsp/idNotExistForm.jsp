<!DOCTYPE html>
<html>

<head>
	<%@ include file="/WEB-INF/jsp/headerHtml.jsp"%>
</head>
<body>

<jsp:include page="/WEB-INF/jsp/header.jsp">
	<jsp:param name="page" value="none" />
</jsp:include>

<div class="container">

	<div class="alert alert-info" role="alert" style="margin-top:20px;">
		<p>
			User's Id does not exist. Are you a user?
		</p>
	</div>

</div>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>
</body>
</html>