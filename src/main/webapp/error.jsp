<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>

<%@ include file="/WEB-INF/jsp/headerHtml.jsp"%>

<c:if test="${sessionScope.conectado!='true'}">
	<c:redirect url="login.jsp" />
</c:if>

</head>

<body>

	<div class="container">

		<div class="panel panel-default">
			<div class="panel-body">
				<h3>Error</h3>
				<p>Something unexpected happened. This is embarrassing...</p>
				<p>
					<a href="login.jsp">Back to home</a>
				</p>
			</div>
		</div>

	</div>
	<!-- /.container -->

	<%@ include file="/WEB-INF/jsp/footer.jsp"%>
	<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>

</body>
</html>