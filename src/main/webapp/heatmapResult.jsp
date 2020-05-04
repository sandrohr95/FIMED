<!DOCTYPE html>
<html>
<head>
    <title>Fimed</title>
    <%@ include file="/WEB-INF/jsp/headerHtml.jsp" %>
    <c:if test="${sessionScope.conectado!='true'}">
        <c:redirect url="login.jsp"/>
    </c:if>
    <script src="resources/js/response.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-tables.css" integrity="sha256-g24dX7HcOoj1KI2TYtOYKvU1N8grqnVlMy1lyh9xh1k=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-tables.min.css" integrity="sha256-iBWv5+ZmZ8SY8hMJtnEnUJYInLHV5obfVmlgSKOhzxA=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-widgets.css" integrity="sha256-294hQIn0XhFkDXAXbQjGblyIr7VEgkw8U0I1wHy3+HI=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-widgets.min.css" integrity="sha256-U/R5A6NKSaMvxW0FaCRdwImzht8RW6tFYyNdqgQhNsc=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh.css" integrity="sha256-ki++R2T9pNBdHdfPxj5Ck010Gt9vOjdO3Z1Mz5b09IA=" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh.min.css" integrity="sha256-c0kT5aMIjtsU00xTb2BRHw8tBQffDOE2EAUaHSYFbu0=" crossorigin="anonymous" />

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-api.js" integrity="sha256-nrX1dtc/rzSQha9UX8g8mX5SsKEr0hLIIivl8tHvZfM=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-api.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-api.min.js" integrity="sha256-koKIWC9lHWgvAnNGfKu/ENo3u9tJ8bJs+ygUKPztPp4=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-api.min.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-gl.js" integrity="sha256-PIo63glSQDC61IGWt1oKIIFaICEomsAwmEtcZ7MJ+wg=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-gl.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-gl.min.js" integrity="sha256-Pch1dcFB/a8q34uXYigbNHPU+m/u7tZnEonQFTKEdI8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-gl.min.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-tables.js" integrity="sha256-rcB6N0mOitXxsMRlh2fveYxGaMgxIfQhOgbd8e1+xlY=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-tables.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-tables.min.js" integrity="sha256-Y3uT2ZjOEvJ2JpQMCgEi/EcNAauCs/530r5oZ704L/g=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-tables.min.js.map" integrity="undefined" crossorigin="anonymous"></script><script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-tables.min.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-widgets.js" integrity="sha256-7FPwQ82fy1FuS77wc1iygAdUQkjTfzYfg63U45X1+8g=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-widgets.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-widgets.min.js" integrity="sha256-xiIPCg2LB2RcK1IMQuAvcLQRdzEq0VEA06UhOr58IqA=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh-widgets.min.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh.js" integrity="sha256-syNdF8jEC9LqIXcocvB/jTQsKyuunvIqk03ppKIeItQ=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh.js.map" integrity="undefined" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh.min.js" integrity="sha256-JOsToc27fokNFt3bd4aCO4GfcTmU9IYmQ0YoBsQiK4s=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bokeh/1.0.2/bokeh.min.js.map" integrity="undefined" crossorigin="anonymous"></script>

</head>
<body>
    <jsp:include page="/WEB-INF/jsp/header.jsp">
        <jsp:param name="page" value="none"/>
    </jsp:include>

    <div class="container" data-ng-init="init()">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page">Analysis</li>
            </ol>
        </nav>
        <div class="panel panel-default">
            <div class="panel-body">
                <h1>Gene expression analysis</h1>

                <div class="row-fluid">
                    <h3>Heatmap</h3>
                    <div  id="loading">
                        <div class="col-md-12" id="loader"></div>
                        <div class="card col-md-12" style="margin-top: 50px" align="center">
                            <div class="card-body">
                                This process could take some minutes, please wait.
                            </div>
                        </div>
                    </div>
                    <div id="alertError" align="center" class="alert alert-danger col-md-12" style="display: none">
                        <strong>There has been an error executing the service.</strong>
                        <br>
                        Check that the format of the samples selected for the analysis is appropriate.
                    </div>
                    <br>

                    <div align="center" id="codigohtml2" >
                    </div>
                </div>
                <%@ include file="/WEB-INF/jsp/contactMsg.jsp" %>
            </div>
        </div>
    </div><!-- /.container -->

    <%@ include file="/WEB-INF/jsp/footer.jsp" %>

</body>
<%@ include file="/WEB-INF/jsp/BarraNavegacion.jsp" %>
</html>