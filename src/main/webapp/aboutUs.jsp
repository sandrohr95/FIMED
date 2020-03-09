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
            <li class="breadcrumb-item active" aria-current="page">About us</li>
        </ol>
    </nav>
    <div class="panel panel-default">
        <div class="panel-body">


            <div class="page-header" style="margin-top: 0px">
                <h1><strong>About us</strong></h1>
            </div>

            <div class="container">
                <div class="section-title underline" align="center">
                    <h2><strong>Authors of FIMED</strong>
                    </h2>
                    <h2>
                    <small>
                        FIMED has been developed by
                        <a href="https://khaos.uma.es/"> Khaos Research Group</a> of the University of Malaga
                    </small>
                    </h2>
                </div>
                <div class="MermersList col-md-12">
                    <div class="row ">
                        <div class="col-md-11">
                            <div class="panel panel-default">
                                <div class="panel-heading" style="padding: 1px 15px">
                                    <div class="MemberList">
                                        <h3>Sandro Hurtado Requena</h3>
                                    </div>
                                </div>
                                <div class="panel-body  ">
                                    <ul class="list-group ">
                                        <li class="list-group-item" style="border: 0px none;"><img
                                                style="margin-right: 10px; height: 120px;"
                                                src="resources/images/sandro-2.png"
                                                class="img-circle" align="left">
                                            <p>Sandro Hurtado holds a Bachelor's Degree in Health Engineering with a
                                                major in Biomedicine (2017) and is currently finishing his Master's
                                                Degree in Software Engineering and Artificial Intelligence, from the
                                                University of Málaga. His main lines of research are the development of
                                                ontologies in the domain of Gene Regulation Networks and Software
                                                applications for the collection, consolidation and analysis of clinical
                                                data, thus providing medical and biological information to researchers
                                                and doctors in this field.</p>

                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-11">
                            <div class="panel panel-default">
                                <div class="panel-heading" style="padding: 1px 15px">
                                    <div class="MemberList">
                                        <h3>Jose Manuel García Nieto</h3>
                                    </div>
                                </div>
                                <div class="panel-body  ">
                                    <ul class="list-group ">
                                        <li class="list-group-item" style="border: 0px none;"><img
                                                style="margin-right: 10px; height: 120px;"
                                                src="resources/images/JMGN.jpg"
                                                class="img-circle" align="left">
                                            <p>He received his M.S. and Ph.D. degrees in Computer Science in 2007 and
                                                2013, respectively, from the University of Malaga. He is involved in
                                                multiple research projects and technology transfer within the KHAOS
                                                Research group. His research topics are optimization algorithms, data
                                                analytics, Big Data, Web Semantics and Linked Data for knowledge
                                                acquisition, with special interest in the application to real-world in
                                                the domains of bioinformatics and precision agriculture.</p>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-11">
                            <div class="panel panel-default">
                                <div class="panel-heading" style="padding: 1px 15px">
                                    <div class="MemberList">
                                        <h3>Ismael Navas Delgado</h3>
                                    </div>
                                </div>
                                <div class="panel-body  ">
                                    <ul class="list-group ">
                                        <li class="list-group-item" style="border: 0px none;"><img
                                                style="margin-right: 10px; height: 120px;"
                                                src="resources/images/IND.jpg"
                                                class="img-circle" align="left">
                                            <p>Computer Engineer (2002), Doctor by the University of Málaga (2009) and
                                                Master in Cell Biology and Molecular Biology (2008). His research is
                                                developed within the KHAOS Research group participating in multiple
                                                research projects (15), being the second principal investigator of the
                                                projects TIN2014-58304-R and TIN2017-86049-R, and technology transfer
                                                (2). His research activity focuses on the integration of data through
                                                the use of semantic technologies and their application to Life
                                                Sciences.</p>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-11">
                            <div class="panel panel-default">
                                <div class="panel-heading" style="padding: 1px 15px">
                                    <div class="MemberList">
                                        <h3>José F. Aldana</h3>
                                    </div>
                                </div>
                                <div class="panel-body  ">
                                    <ul class="list-group ">
                                        <li class="list-group-item" style="border: 0px none;"><img
                                                style="margin-right: 10px; height: 120px;"
                                                src="resources/images/JFAM.png"
                                                class="img-circle" align="left">
                                            <p>Full Professor of the Computer Languages and Systems area in the
                                                Department of Languages and Computer Sciences of the University of
                                                Málaga. With more than 25 years of experience as a teacher in the area
                                                of databases and related areas. His areas of interest are Semantic
                                                Middleware; Semantic Web; Semantic Integration of Data and Applications
                                                and; Extensions of the Databases with Formal Semantics.</p>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br></div>
                <div class="section-title underline" align="center">
                    <h2><strong>Reference of this research activity </strong></h2>
                    <h3><a href="#"> Reference to this paper</a></h3>
                </div>
                <div class="section-title underline" align="center">
                    <h2><strong>Previous work </strong></h2>
                    <h3><a href="https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-019-2695-7"> VIGLA-M: visual gene expression data analytics</a></h3>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>


</html>











