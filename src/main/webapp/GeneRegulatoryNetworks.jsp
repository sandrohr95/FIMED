<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
</head>


<c:set var="user" value='${it}'/>
<body>

<%
    HttpSession sesion = request.getSession(true);
    String id = (String) sesion.getAttribute("userId");
    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");
    System.out.println("id: " + id);
%>
<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Gene expression level analysis</li>
        </ol>
    </nav>

    <div class="panel panel-default">
        <div class="panel-body">
            <div class="page-header" style="margin-top: 0px">
                <h1>Gene Regulatory Networks</h1>
                <p>Inference of GRN in the study of the connectivity of highly expressed genes.</p>
            </div>
            <div class="row">
                <div class="col-sm-6 col-md-3">
                    <div class="thumbnail">
                        <img src="resources/images/grn.png" style="height: 120px" alt="...">
                        <div class="caption">
                            <h3>GRNBOOST2</h3>
                            <p>Inference of GRN in the study of the connectivity of highly expressed genes.</p>
                            <p>
                                <a href="grnPage.jsp" class="btn btn-primary btn-block" role="button">GRNBOOST2
                                    Analysis</a>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3">
                    <div class="thumbnail">
                        <img src="resources/images/grn.png" style="height: 120px" alt="...">
                        <div class="caption">
                            <h3>GENIE3</h3>
                            <p>Inference of GRN in the study of the connectivity of highly expressed genes.</p>
                            <p>
                            <p>
                                <a href="genie3.jsp" class="btn btn-primary btn-block" role="button">GENIE3
                                    Analysis</a>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3">
                    <div class="thumbnail">
                        <img src="resources/images/grn.png" style="height: 120px" alt="...">
                        <div class="caption">
                            <h3>SINCERITIES</h3>
                            <p>Inference of GRN in the study of the connectivity of highly expressed genes.</p>
                            <p>
                                <a href="" class="btn btn-primary btn-block" role="button">SINCERITIES Analysis</a>
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-md-3">
                    <div class="thumbnail">
                        <img src="resources/images/Fimed_logo.png" style="height: 120px" alt="...">
                        <div class="caption">
                            <h3>OTHER GRN ANALYSIS</h3>
                            <p>Here you can find all the previously performed analyzes stored Fimed Clinical Tool.</p>
                            <p>
                                <a href="" class="btn btn-primary btn-block" role="button">GRN
                                    Analysis</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
<%@ include file="/WEB-INF/jsp/footer.jsp" %>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
