<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Sign up</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp"%>
</head>

<body>
<div class="container">

    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header" style="margin-top: 0px">
                <img align="middle" src="resources/images/Fimed_logo.png">
                <h2>Registration Page</h2>
            </div>

            <form id="login" action="api/register" method="post" enctype="multipart/form-data" acceptcharset="UTF-8" onsubmit="return validar()">
                <div class="form-group">
                    <label for="name" class="col-sm-2 control-label">Name</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="name" name="name">
                    </div>
                </div>
                <br>
                <div class="form-group">
                    <label for="apellidos" class="col-sm-2 control-label">Surname</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="apellidos" name="apellidos">
                    </div>
                </div>
                <div class="form-group">
                    <label for="email" class="col-sm-2 control-label">Email</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="email" name="email">
                    </div>
                </div>
                <br>
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
                    <div class="col-sm-offset-2 col-sm-10">
                        <button id="execBtn" type="submit" class="btn btn-primary" style="margin-top: 7px;"
                        >Sign up</button>
                    </div>
                </div>
            </form>
            <br><br><br>
            <form >
                <h5>Come back to Login page:</h5>
                <button type="submit" class="btn btn-primary" formaction="login.jsp" style="margin-top: 7px;">Go to login</button>
            </form>

        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/footer.jsp" %>
<script src="resources/js/otherFunctions.js"></script>
</body>
</html>
