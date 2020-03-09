
function validar() {
    var name = document.getElementById("name").value;
    var apellidos = document.getElementById("apellidos").value;
    var username = document.getElementById("username").value;
    var password = document.getElementById("password").value;
    var at = document.getElementById("email").value.indexOf("@");

    if (name.length === 0 || apellidos.length === 0 || username.length === 0 || password.length === 0) {
        alert("Es obligatorio completar los campos");
        return false;
    }

    if (at === -1) {
        alert("Dirección de correo electrónico no válida");
        return false;
    }
}

function hideFields(mapPatientKey) {

    // Get the checkbox
    var checkBox = document.getElementById(mapPatientKey);
    // Get the output text
    var values = document.getElementById("values"+mapPatientKey);
    console.log(values);

    // If the checkbox is checked, display the output text
    if (checkBox.checked == true){
        values.style.display = "none";
    } else {
        values.style.display = "inline"
    }

}

function hidesubFields(mapPatientKey) {
    // Get the checkbox
    var checkBox = document.getElementById(mapPatientKey);
    // Get the output text
    var subvalues = document.getElementById("subsubvalues"+mapPatientKey);
    console.log(subvalues);


    // If the checkbox is checked, display the output text
    if (checkBox.checked == true){
        subvalues.style.display = "none";
    } else {
        subvalues.style.display = "inline"
    }

}

//Función que permite variar el tipo de dato de entrada en el motor de búsqueda de la herramienta
function selectOpciones() {
    var value = document.getElementById('selectParameter').value;
    var type = value.split("#");

    document.getElementById('kparameter').value = type[0];
    document.getElementById('typeparam').value = type[1];
    console.log(type[1]);

    var div = document.createElement('div');

    document.getElementById('vparameter').remove();

    switch (type[1]) {
        case "String":
            div.innerHTML = '<div id="vparameter">'
                + '<input type="text" class="form-control" name="vparameter" placeholder="Ej: Introduce value"></div>';

            break;
        case "Double":
        case "Long":
        case "Integer":
            div.innerHTML = '<div id="vparameter">'
                + '<input type="number" class="form-control" name="vparameter" placeholder="Introduce number"></div>';

            break;
        case "Date":
            div.innerHTML = '<div id="vparameter">'
                + '<input type="date" class="form-control" name="vparameter" placeholder="Introduce date"></div>';

            break;
        case "Boolean":
            div.innerHTML = '<div id="vparameter">'
                +'<select class="form-control"  name="vparameter">'
                +'<option value="Yes">Yes</option>'
                +'<option selected value="No">No</option>'
                +'</select></div>';

            break;
        default:
            div.innerHTML = '<div id="vparameter">'
                + '<input type="text" class="form-control" name="vparameter" placeholder="Ej: Psoriasis"></div>';

    }

    document.getElementById("typeparam").appendChild(div);
}


function pregunta_delete_patient(id_patient) {
    if (confirm('Are you sure to eliminate this patient?')) {
        document.getElementById("deletePatient" + id_patient).submit();
    }
}

function pregunta_delete_analysis(id_analysis) {
    if (confirm('Are you sure to eliminate this analysis?')) {
        document.getElementById(id_analysis).submit();
    }
}




