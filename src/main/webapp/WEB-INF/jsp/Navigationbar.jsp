<%--
  Created by IntelliJ IDEA.
  User: khaosdev
  Date: 13/06/18
  Time: 14:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <style>
        .active {
            background-color: #f5f5f5;
        }

        .dropbtn {
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            font-size: 16px;
            border: none;
            cursor: pointer;
        }

        /* The container <div> - needed to position the dropdown content */
        .dropdown {
            position: relative;
            display: inline-block;
        }

        /* Dropdown Content (Hidden by Default) */
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
        }

        /* Links inside the dropdown */
        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        /* Change color of dropdown links on hover */
        .dropdown-content a:hover {
            background-color: #f1f1f1
        }

        /* Show the dropdown menu on hover */
        .dropdown:hover .dropdown-content {
            display: block;
        }

        /* Change the background color of the dropdown button when the dropdown content is shown */
        .dropdown:hover .dropbtn {
            background-color: #3e8e41;
        }

    </style>
</head>
<body>

<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="../home.jsp" style="padding-top: 0;padding-left: 15px"><img
                    src="../resources/images/Fimed_logo.png" style="height: 40px"></a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav">
                <li class="nav-link"><a href="../home.jsp"> Home </a></li>
                <li><a href="../createPatient.jsp"> Add </a></li>
                <li><a href="../searchPage.jsp"> Search </a></li>
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">Analysis <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="../heatmapPage.jsp">HeatMap</a></li>
                        <li><a href="../clusterheatmapPage.jsp">Dendrogram + Heatmap</a></li>
                        <li><a href="../grnPage.jsp">Gene Regulatory Network</a></li>
                    </ul>
                </li>
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">About us <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="../aboutUs.jsp">About us</a></li>
                        <li><a href="http://khaos.uma.es/"> Khaos Research </a></li>
                    </ul>
                </li>
                <li><a href="../Manual.jsp">Help  <span class=" glyphicon glyphicon-info-sign"></span></a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="../action/logoutAction.jsp"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

</body>
</html>
