var services = {
    clusterHeatmap: false,
    geneRegNetwork: false,
    dendrogramHeatmap: false
};

var samelabelHeatMap = [];
var samevalueHeatMap = [];
var samples = [];
var result = [];

////// Services ////
var checkBoxHeatMap = document.getElementById("heatMap");
var checkBoxGRN = document.getElementById("geneRegNetwork");
var checkBoxDendrogram = document.getElementById("dendrogram");
var a = 0;

//// Percentage slide /////////
var percentageSlide = document.getElementById("percentage");
var percentageOutput = document.getElementById("percentageOut");
var configurationGRN = document.getElementById("configuration");


// Display the default slider value
percentageOutput.innerHTML = percentageSlide.value + "%";

// Update the current slider value (each time you drag the slider handle)
percentageSlide.oninput = function () {
    percentageOutput.innerHTML = this.value + "%";
};

//// MaxLinks slide /////////
var maxlinksSlide = document.getElementById("maxlinks");
var maxlinksoutput = document.getElementById("maxlinksOut");

// Display the default slider value
maxlinksoutput.innerHTML = maxlinksSlide.value;

// Update the current slider value (each time you drag the slider handle)
maxlinksSlide.oninput = function () {
    maxlinksoutput.innerHTML = this.value;
};

// Funcion para ver si la muestra de analisis ha sido seleccionada
function contain(samples, idMuestra) {
    for (i in samples) {
        if (samples[i].idS == idMuestra) {
            return true;
        }
    }
    return false;
}


function addsamples(idMuestra, idPac) {

    if (contain(samples, idMuestra)) {
        alert('you can only add the sample once');
    } else {
        a++;
        var labelHeatMap = [];
        var valueHeatMap = [];
        var inputElements = document.getElementsByClassName("labelHeatMap" + idMuestra);
        var valueElements = document.getElementsByClassName("labelHeatMapV" + idMuestra);
        for (var i = 0; inputElements[i]; ++i) {

            labelHeatMap.push(inputElements[i].value);
            valueHeatMap.push(valueElements[i].value);

        }

        console.log(idMuestra);
        console.log(idPac);
        samples.push({
            idS: idMuestra,
            idP: idPac,
            label: labelHeatMap,
            value: valueHeatMap
        });

        for (var i = 0; i < samples.length; i++) {
            for (var e = 0; e < samples[i].label.length; e++) {

                if (samples[0].label.includes(samples[i].label[e])) //Comparo el primer array con todos, si el label existe en todos lo inserto
                {
                    samelabelHeatMap.push(samples[i].label[e]);
                    samevalueHeatMap.push(samples[i].label[e]);
                }
            }
        }

        //Delete repeated keys
        // Show all the possible labels to be selected in HeatMap
        samevalueHeatMap.forEach(function (item) {
            if (result.indexOf(item) < 0) {
                var option = document.createElement('option');
                option.innerHTML = '<option value="' + item + '">' + item + '</option>';
                document.getElementById('optionlabel').appendChild(option);
                result.push(item);
            }
        });

        for (i in samples) {
            console.log("i.samples");
            console.log(i);

            var tr = document.createElement('tr');
            tr.innerHTML = '<tr>'
                + '<td>' + a + '</td>'
                + '<td> ' + samples[i].idS + '</td>'
                + '<td> ' + samples[i].idP + '</td>' + '</tr>';
        }

        document.getElementById('SamplesHeatMap').appendChild(tr);
    }

    console.log(samples);

    //Enable Services
    console.log(samples.length);
    if (samples.length > 1) {
        checkBoxHeatMap.disabled = false;
    }

}

function addsamplesGRN(idMuestra, idPac) {

    if (contain(samples, idMuestra)) {
        alert('you can only add the sample once');
    } else {
        a++;
        console.log(idMuestra);
        console.log(idPac);
        samples.push({
            idS: idMuestra,
            idP: idPac
        });

        for (i in samples) {
            console.log("i.samples");
            console.log(i);

            var tr = document.createElement('tr');
            tr.innerHTML = '<tr>'
                + '<td>' + a + '</td>'
                + '<td> ' + samples[i].idS + '</td>'
                + '<td> ' + samples[i].idP + '</td>' + '</tr>';
        }

        document.getElementById('SamplesGRN').appendChild(tr);
    }

    console.log(samples);

    if (samples.length > 2) {
        checkBoxGRN.disabled = false;
    }

}

function addsamplesDendroGram(idMuestra, idPac) {

    if (contain(samples, idMuestra)) {
        alert('you can only add the sample once');
    } else {
        a++;
        console.log(idMuestra);
        console.log(idPac);
        samples.push({
            idS: idMuestra,
            idP: idPac
        });

        for (i in samples) {
            console.log("i.samples");
            console.log(i);

            var tr = document.createElement('tr');
            tr.innerHTML = '<tr>'
                + '<td>' + a + '</td>'
                + '<td> ' + samples[i].idS + '</td>'
                + '<td> ' + samples[i].idP + '</td>' + '</tr>';
        }

        document.getElementById('SamplesDendrogram').appendChild(tr);
    }

    console.log(samples);

    if (samples.length > 1) {
        checkBoxDendrogram.disabled = false;
    }

}

//Elimino las muestra seleccionadas tanto en el array que las contiene como en HTML
function deletesamples() {
    a--;
    //Me borra la última muestra insertada
    samples.splice(a, 1);
    console.log(samples);

    var elem = document.getElementById('SamplesHeatMap');
    elem.removeChild(elem.lastChild);

    //Enable or disable Services
    if (samples.length > 1) {
        checkBoxHeatMap.disabled = false;
    } else {
        checkBoxHeatMap.disabled = true;
    }

}

//Elimino las muestra seleccionadas tanto en el array que las contiene como en HTML
function deletesamplesGRN() {
    a--;
    //Me borra la última muestra insertada
    samples.splice(a, 1);
    console.log(samples);

    var elem = document.getElementById('SamplesGRN');
    elem.removeChild(elem.lastChild);

    if (samples.length > 2) {
        checkBoxGRN.disabled = false;
    } else {
        checkBoxGRN.disabled = true;
    }
}

//Elimino las muestra seleccionadas tanto en el array que las contiene como en HTML
function deletesamplesDendrogram() {
    a--;
    //Me borra la última muestra insertada
    samples.splice(a, 1);
    console.log(samples);

    var elem = document.getElementById('SamplesDendrogram');
    elem.removeChild(elem.lastChild);

    if (samples.length > 1) {
        checkBoxDendrogram.disabled = false;
    } else {
        checkBoxGRN.disabled = true;
    }
}

//// Activar # maximum of links of the Gene Regulatory Network

function activeMaxLinks() {

    if (checkBoxGRN.checked == true) {
        document.getElementById("slidelinks").style.display = "inline";
    } else {
        document.getElementById("slidelinks").style.display = "none";

    }
}

function submitservices() {

    var ids = "";
    var etiquetas = "";
    var percentage = percentageSlide.value / 100;
    // Analysis name
    var name_analysis = document.getElementById("name_analysis").value;
    console.log("nombre del análisis");
    console.log(name_analysis);


    services.clusterHeatmap = checkBoxHeatMap.checked;
    var option_label = document.getElementById("optionlabel").value;

    for (i in samples) {
        var sample = samples[i];
        ids += "&id=" + sample.idS;
        for (sl in sample.label) {
            if (sample.label[sl] === option_label) {
                console.log("AQUI ESTAMOS MIRANDO")
                console.log(sample.value[sl])
                etiquetas += "&label=" + i + "-" + sample.value[sl];
            }
        }

    }

    if (checkBoxHeatMap.checked === true) {
        var urlHeatMap = "heatmapResult.jsp?" + "&clusterHeatmap=" + services.clusterHeatmap
            + "&geneRegNetwork=" + services.geneRegNetwork
            + "&percentage1=" + percentage
            + ids + etiquetas + "&nameAnalysis=" + name_analysis;

        console.log(samples);

        if (samples.length > 1) {
            window.location.href = urlHeatMap;
        } else {
            alert("Select at least two samples to do the analysis");
        }

    } else {
        alert("Select at least one service to be executed.");
    }
}

function submitGRN() {
    var ids = "";
    var etiquetas = "";
    var percentage = percentageSlide.value / 100;
    var maxlinks = maxlinksSlide.value / 100;
    var conf = configurationGRN.value;
    // Analysis name
    var name_analysis = document.getElementById("name_analysis").value;
    console.log("nombre del análisis");
    console.log(name_analysis);


    services.geneRegNetwork = checkBoxGRN.checked;

    for (i in samples) {
        var sample = samples[i];
        ids += "&id=" + sample.idS;
        etiquetas += "&label=" + i + "-" + sample.label;
    }

    if (checkBoxGRN.checked == true) {
        var urlGRN = "resultGRN.jsp?" + "&clusterHeatmap=" + services.clusterHeatmap
            + "&geneRegNetwork=" + services.geneRegNetwork
            + "&max_links=" + maxlinks
            + "&percentage1=" + percentage
            + ids + etiquetas + "&configuration=" + conf + "&nameAnalysis=" + name_analysis;

        console.log(samples);

        if (samples.length > 2) {
            window.location.href = urlGRN;
        } else {
            alert("Select at least three samples to do the analysis");
        }

    } else {
        alert("Select at least one service to be executed.");
    }
}

function submitDendrogram() {
    var ids = "";
    var etiquetas = "";
    var percentage = percentageSlide.value / 100;
    // Analysis name
    var name_analysis = document.getElementById("name_analysis").value;
    console.log("nombre del análisis");
    console.log(name_analysis);

    services.dendrogramHeatmap = checkBoxDendrogram.checked;

    for (i in samples) {
        var sample = samples[i];
        ids += "&id=" + sample.idS;
        etiquetas += "&label=" + i + "-" + sample.label;
    }

    if (checkBoxDendrogram.checked == true) {
        var urlDendrogram = "resultDendrogram.jsp?" + "&dengrogramHeatmap=" + services.dendrogramHeatmap
            + "&percentage1=" + percentage
            + ids + etiquetas + "&nameAnalysis=" + name_analysis;

        console.log(samples);

        if (samples.length > 1) {
            window.location.href = urlDendrogram;
        } else {
            alert("Select at least two samples to do the analysis");
        }

    } else {
        alert("Select at least one service to be executed.");
    }
}

function viewMoreSample(idSample) {

    $(document).ready(function () {
        $("#" + idSample).on("hide.bs.collapse", function () {
            $(".btnview" + idSample).html('<span class="glyphicon glyphicon-collapse-down"></span> View more');
        });
        $("#" + idSample).on("show.bs.collapse", function () {
            $(".btnview" + idSample).html('<span class="glyphicon glyphicon-collapse-up"></span> Close');
        });
    });

}



