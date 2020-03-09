<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
    <c:if test="${sessionScope.conectado!='true'}">
        <c:redirect url="/login.jsp"/>
    </c:if>
</head>
<body>
<%
    HttpSession sesion = request.getSession(true);
    String id = (String) sesion.getAttribute("userId");
    String username = (String) sesion.getAttribute("usuario");
    String password = (String) sesion.getAttribute("password");

%>

<jsp:include page="/WEB-INF/jsp/header.jsp">
    <jsp:param name="page" value="none"/>
</jsp:include>

<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Documentation</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">

            <div class="page-header" style="margin-top: 0px">
                <h1><strong>Documentation</strong></h1>
            </div>
            <div>
                <h3><strong>What is FIMED?</strong></h3>
                <p>FIMED application for flexible integration of biomedical data is a new software solution that
                    facilitates the handling of large amounts of
                    heterogeneous data in clinical research processes, thus improving the efficiency and quality of the
                    data. It offers numerous benefits for
                    the user in each of the aspects of the phases of clinical trials, including the possibility of
                    inserting patient data dynamically and performing
                    different studies. This software application has been designed to guarantee scalability, versatility
                    and flexibility. In that way it can be adapted
                    to multiple clinical trials. This tool has been tested with a real case for a clinical assay in
                    Melanoma disease including two data analysis and
                    visualization components for gene expression data: heatmap visualization and gene regulatory network
                    inference.
                    From its initial use to the collection of data analysis results, this tool eliminates the obstacles
                    typical of clinical research by allowing the insertion
                    and manipulation of data at any time in a simple way for the user.
                </p>
                <h3><strong>FIMED Tutorial</strong></h3>
                <p>
                    In this video users will find a full tutorial of how to use FIMED.
                    This tutorial show the whole process of gene expression data analysis, since de easy collection of the patients
                    information in clinical assays to the exhaustive analysis of gene expression data and its visualization.
                    <a href="https://youtu.be/4bxuH9TVkc8" target="_blank">FIMED full tutorial</a>
                </p>
                <h3><strong>Supplementary material</strong></h3>
                <p>
                    Users can use the RCC files extracted from the Nanostring panel found in the following link.
                    <a href="http://khaos.uma.es/fimedRCC">sen-Nanostring-master.zip</a></p>
                <p>
                    These
                    RCC files are from a github project with MIT license. This way they can test the application and
                    make some examples
                </p>
            </div>
        </div>
    </div>
</div>

</body>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>


</html>











