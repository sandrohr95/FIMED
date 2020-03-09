<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<html>
<head>
<title>LOGIN</title>
<%@ include file="/WEB-INF/jsp/headerHtml.jsp"%>
</head>
<body>
	<div class="container">
		<div class="panel panel-default">
			<div class="panel-body">
				<div class="page-header" style="margin-top: 0px">
					<img src="resources/images/Fimed_logo.png">
					<h2>Login Page:</h2>
				</div>

				<form id="login" action="./action/loginAction.jsp" method="post">
					<div class="form-group">
						<label for="username" class="col-sm-2 control-label">Username</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="username" name="username">
						</div>
					</div>
					<div class="form-group">
						<label for="password" class="col-sm-2 control-label">Password</label>
						<div class="col-sm-10">
							<input type="password" class="form-control" id="password" name="password">
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10" style="margin-top: 7px;">
							<button id="execBtn" type="submit" class="btn btn-primary">Login</button>
						</div>
					</div>
				</form>
							
			<form>
			<div class="form-group">
				<label for="register" class="col-sm-2 control-label" >Sign up:</label>
				<a href="registerUser.jsp" class="btn btn-primary" style="margin-top: 10px;">Sign up</a>
		
			</div>
			</form>
				<%@ include file="/WEB-INF/jsp/contactMsg.jsp" %>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/jsp/footer.jsp"%>



</body>
</html>
