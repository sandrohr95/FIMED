
function generateServices() {
    var parsedUrl = new URL(window.location);
    var percentage = parsedUrl.searchParams.get("percentage1");
    var id = parsedUrl.searchParams.getAll("id");
    var label = parsedUrl.searchParams.getAll("label");
    var max_links = parsedUrl.searchParams.get("max_links");
    var clusterHeatmap = parsedUrl.searchParams.get("clusterHeatmap");
    var dengrogramHeatmap = parsedUrl.searchParams.get("dengrogramHeatmap");
    var geneRegNetwork = parsedUrl.searchParams.get("geneRegNetwork");
    var configuration = parsedUrl.searchParams.get("configuration");
    var nameAnalysis = parsedUrl.searchParams.get("nameAnalysis");
    var algorithm = parsedUrl.searchParams.get("algorithm");


    if (clusterHeatmap === 'true') {
        $.get({
                method: 'GET',
                url: "api/service/cluster_heatmap"
            },
            {
                "id[]": id,
                "label[]": label,
                "percentage": percentage,
                "name_analysis": nameAnalysis
            },

            function (responsecluster) {
                if (responsecluster != null) {
                    document.getElementById("loading").style.display = "none";
                    if (responsecluster === "") {
                        document.getElementById('alertError').style.display = "inline";
                    } else {
                        $("#codigohtml2").html(responsecluster);
                    }

                }
            });
    }else if (dengrogramHeatmap === 'true') {
        $.get({
                method: 'GET',
                url: "api/service/dendrogramHeatmap"
            },
            {
                "id[]": id,
                "label[]": label,
                "percentage": percentage,
                "name_analysis": nameAnalysis
            },

            function (responsecluster) {
                document.getElementById("loading").style.display = "none";
                if (responsecluster != null) {
                    if (responsecluster === "") {

                        document.getElementById('alertError').style.display = "inline";
                    } else {
                        $("#dendrogramHtml").html(responsecluster);
                    }
                }
            });
    }else if (geneRegNetwork === 'true') {
        $.get({
                method: 'GET',
                url: "api/service/gene_regulatory_network"
            },
            {
                "id[]": id,
                "label[]": label,
                "percentage1": percentage,
                "max_links": max_links,
                "configuration": configuration,
                "algorithm": algorithm,
                "name_analysis": nameAnalysis
            },

            function (response) {
                if (response != null) {
                    document.getElementById("loading").style.display = "none";
                    if (response === "") {
                        document.getElementById('alertError').style.display = "inline";
                    } else {
                        $("#codigohtml").html(response);
                    }
                    document.getElementById("loading").style.display = "none";
                }

            });
    }else {
        alert("The algorithm can not be executed")
    }

}

generateServices();









