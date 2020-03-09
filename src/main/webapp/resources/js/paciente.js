var cont_field = document.getElementById("cont").value;
var cont_type = 0;
var cont_sub_type = 0;

function add_field() {
    //Cuando se añada un nuevo campo, el selector del anterior será deshabilitado
    var selector = 'selectType';
    disable_selector(selector,cont_type);

    cont_type++;

    var div = document.createElement('div');
    div.setAttribute('class', 'form');
    div.innerHTML = '<div class="col-md-offset-1 col-md-3">'
        + '<input class="keys form-control" id="keys" name="keys" type="text" '
        + 'placeholder="Insert Field" style="width: 266px;" oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required=""/></div>'
        + '<div id="typevalue'+cont_type+'" class="col-md-3"><input class="values form-control" id="values'+cont_type+'" name="values" type="text"'
        + 'placeholder="Insert value" style="width: 266px;" oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required=""/>'
        + '<input type="text" style="display: none" class="form-control" name="keystype" id="keystype'+cont_type+'" value="String"></div>'
        + '<div class="form-group col-md-3">'
        + '<select class="form-control" id="selectType'+cont_type+'"  onchange="select_field_type(cont_type)">'
        + '<option value="String">String</option>'
        + '<option value="Integer">Number</option>'
        + '<option value="Date">Date</option>'
        + '<option value="Boolean">Checkbox</option>'
        + '<option value="Textarea">textarea</option>'
        + '</select></div>';
    document.getElementById('Fields').appendChild(div);
}

function add_compound_field() {

    if (cont_field < 1) {
        cont_field++;
        var div = document.createElement('div');
        div.setAttribute('class', 'form');
        div.innerHTML = '<div class="col-md-offset-1 col-md-3">'
            + '<input class=" form-control" id="keysp" name="subkeys' + cont_field + '" type="text" '
            + 'placeholder="Insert compound field (e.g Address)"'
            + 'oninvalid="setCustomValidity(\'Please fill this field.\')" oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required=""/></div>'
            + '<div class="col-md-3"><input type="button" class="btn btn-primary" id="add_sub_field()" onClick="add_sub_field(cont_field)" value="+" />'
            + '<input type="button" class="btn btn-primary" id="deleteSubfields" onclick="delete_subfields(\'SubFields\'+cont_field+\'\')" value="-"/>'
            +' <input type="text" style="display: none" class="form-control" name="subkeystype" id="subkeystype" value="BasicDBObject"/></div>';
        document.getElementById('SubKeyp' + cont_field + '').appendChild(div);

    } else {
        alert("Only two Subfields can be insert")
    }

}

function add_sub_field(cont_field) {

    //Cuando se añada un nuevo campo, el selector del anterior será deshabilitado
    var selector = 'subselectType'+cont_field;
    disable_selector(selector,cont_sub_type);

    cont_sub_type++;

    var inobj = document.getElementById("keysp");
    var div = document.createElement('div');
    div.setAttribute('class', 'form');

    if (inobj) {

        div.innerHTML = '<div class="col-md-offset-2 col-md-3">'
            + '<input class="form-control" id="subkeys' + cont_field + '" name="subsubkeys' + cont_field + '" type="text" '
            + ' placeholder="Insert subfield (e.g Street)" oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required=""/></div>'
            + '<div id="subtypevalue'+cont_sub_type+'"class="col-md-3">'
            + '<input class="form-control" id="subvalues'+cont_sub_type+'" name="subsubvalues' + cont_field + '" type="text"'
            + ' placeholder="Insert value " oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required=""/>'
            + '<input type="text" style="display: none" class="form-control" name="subsubkeys'+cont_field+'type" id="subkeys'+cont_field+'type'+cont_sub_type+'" value="String"></div>'
            + '<div class="form-group col-md-3">'
            + '<select class="form-control" id="subselectType'+ cont_field+ cont_sub_type+'"  onchange="select_subfield_type(cont_sub_type,cont_field)">'
            + '<option value="String">String</option>'
            + '<option value="Integer">Number</option>'
            + '<option value="Date">Date</option>'
            + '<option value="Boolean">Checkbox</option>'
            + '<option value="Textarea">textarea</option>'
            + '</select></div>';

        document.getElementById('SubFields' + cont_field).appendChild(div);
    }
}

function addStaticSubfields(cont_field) {

    //Cuando se añada un nuevo campo, el selector del anterior será deshabilitado
    var selector = 'subselectType'+cont_field;
    disable_selector(selector,cont_sub_type);

    cont_sub_type++;

    var inobj = document.getElementById("subkeys").value;

    var div = document.createElement('div');
    div.setAttribute('class', 'form');

    if (inobj) {
        div.innerHTML = '<div style="clear:both" class="col-md-offset-2 col-md-3">'
            + '<input class="keys form-control" id="subkeys" name="subsubkeys' + cont_field + '" type="text" '
            + ' placeholder="Insert subfield"  oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required=""/></div>'
            + '<div id="subtypevalue'+cont_sub_type+'" class="col-md-3"">'
            + '<input class="keys form-control" id="subvalues'+cont_sub_type+'"name="subsubvalues' + cont_field + '" type="text"'
            + 'placeholder="Insert value"  oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required=""/>'
            + '<input type="text" style="display: none" class="form-control" name="subsubkeys'+cont_field+'type" id="subkeys'+cont_field+'type'+cont_sub_type+'" value="String"></div>'
            + '<div class="form-group col-md-2">'
            + '<select class="form-control" id="subselectType'+ cont_field+ cont_sub_type+'"  onchange="select_subfield_type(cont_sub_type,cont_field)">'
            + '<option value="String">String</option>'
            + '<option value="Integer">Number</option>'
            + '<option value="Date">Date</option>'
            + '<option value="Boolean">Checkbox</option>'
            + '<option value="Textarea">textarea</option>'
            + '</select></div>';

    }

    document.getElementById('StaticSubFields' + cont_field).appendChild(div);


}

function add_metadata_file() {
    var div = document.createElement('div');
    div.setAttribute('class', 'form-inline');
    div.innerHTML = '<div style="clear:both" class="col-md-offset-3 col-sm-1">'
        + '<input class="keys form-control" id="MetadataKey" name="MetadataKey" type="text" '
        + 'placeholder="Insert metadata (e.g: Name)" style="width: 250px;" oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required="" /></div>'
        + '<div class="col-md-offset-2 col-sm-1"">'
        + '<input class="keys form-control" id="Metadatavalue" name="Metadatavalue" type="text" '
        + 'placeholder="Insert value (e.g: File1)" style="width: 250px;"  oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required="" />'
        + '</div>';

    document.getElementById('MetaFields').appendChild(div);
    document.getElementById('MetaFields').appendChild(div);

}

function add_metadata_sample() {

    var div = document.createElement('div');
    div.setAttribute('class', 'form-inline');
    div.innerHTML = '<div style="clear:both" class="col-md-offset-3 col-sm-1">'
        + '<input class="keys form-control" id="MetaSampleKey" name="MetaSampleKey" type="text" '
        + 'placeholder="Insert metadata (e.g Name)" style="width: 250px;" oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required="" /></div>'
        + '<div class="col-md-offset-2 col-sm-1"">'
        + '<input class="keys form-control" id="MetaSamplevalue" name="MetaSamplevalue" type="text" '
        + 'placeholder="Insert value (e.g Sample1)" style="width: 250px;"  oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required="" />'
        + '</div>';

    document.getElementById('MetaSampleFields').appendChild(div);
    document.getElementById('MetaSampleFields').appendChild(div);

}


function deleteFields(ID) {

    var elem = document.getElementById(ID);

    if (elem.lastChild == null)
    {
        alert('There is no more Fields to remove');
    }else {
        cont_type--;
        elem.removeChild(elem.lastChild);

        if(cont_type>0)
        {
            // Habilito el selector
            var enableSelector = document.getElementById('selectType'+cont_type);
            enableSelector.disabled = false;
        }
    }
}

function deleteCompoundFields() {

    var elem = document.getElementById('subkeys'+ cont_field);
    //Si existe compound field, tengo que borrar primero las claves hijas
    if (elem) {
        alert("Please delete all subfields firts");
    } else {

        deleteFields('SubKeyp' + cont_field + '');
        cont_field--;
    }
}

function delete_subfields(id) {
    var elem = document.getElementById(id);
    console.log(id);
    console.log(elem);

    if (elem.lastChild == null)
    {
        alert('There is no more subfields to remove');
    }else {
        cont_sub_type--;
        elem.removeChild(elem.lastChild);

        if(cont_sub_type>0)
        {
            // Habilito el selector
            var enableSelector = document.getElementById('subselectType'+cont_field+cont_sub_type);
            enableSelector.disabled = false;
        }
    }
}

//Esta función no permite hacer un selector dinámico para cambiar el tipo de dato en campos sencillos.
function select_field_type(select) {

    console.log('select: '+select);

    //Identifico el tipo  para insertar el input con ese tipo
    var type = document.getElementById('selectType'+select).value;
    //document.getElementById('typevalue'+cont_type).value = type;
    console.log(type);

    //Elimino el antiguo valor del tipo antes de introducir el nuevo
    document.getElementById('keystype'+select).remove();
    document.getElementById('values'+select).remove();

    var id_value = "values"+select;
    var name_value = "values";
    var id_keys_type = "keystype"+select;
    var name_keys_type = "keystype";
    var type_value = "typevalue"+select;

    switch_type(type,id_value,name_value,id_keys_type,name_keys_type,type_value);

}

//Esta función nos permite hacer un selector dinámico para cambiar el tipo de dato en subcampos.
function select_subfield_type(select, cont) {
    console.log('select: '+select);

    //Identifico el tipo  para insertar el input con ese tipo
    var type = document.getElementById('subselectType'+cont+select).value;
    console.log(type);
    console.log('subkeys'+cont+'type'+select);

    //Elimino el antiguo valor del tipo antes de introducir el nuevo
    document.getElementById('subkeys'+cont+'type'+select).remove();
    document.getElementById('subvalues'+select).remove();

    var id_value = "subvalues"+select;
    var name_value = "subsubvalues"+cont;
    var id_keys_type = 'subkeys'+cont+'type'+select;
    var name_keys_type = "subsubkeys"+cont+"type";
    var type_value = "subtypevalue"+select;

    switch_type(type,id_value,name_value,id_keys_type,name_keys_type,type_value);

}

function switch_type(type,id_value,name_value,id_keys_type,name_keys_type,type_value)
{
    var div = document.createElement('div');
    div.setAttribute('class', 'row');

    switch (type) {
        case "String":
            div.innerHTML = '<div id="'+id_value+'" class="col-md-12">'
                + '<input type="text" class="form-control"  name="'+name_value+'" placeholder="Ej: Introduce value">'
                + '<input type="text" style="display: none" class="form-control" name="'+name_keys_type+'" id="'+id_keys_type+'" value="String"></div>';
            break;
        case "Double":
        case "Long":
        case "Integer":
            div.innerHTML = '<div id="'+id_value+'" class="col-md-12">'
                + '<input type="number" class="form-control" name="'+name_value+'" placeholder="Introduce number">'
                + '<input type="text" style="display: none" class="form-control" name="'+name_keys_type+'" id="'+id_keys_type+'" value="Integer"></div>';
            break;
        case "Date":
            div.innerHTML = '<div id="'+id_value+'" class="col-md-12">'
                + '<input type="date" class="form-control" name="'+name_value+'" placeholder="Introduce date">'
                + '<input type="text" style="display: none" class="form-control" name="'+name_keys_type+'" id="'+id_keys_type+'" value="Date"></div>';

            break;
        case "Boolean":
            div.innerHTML = '<div id="'+id_value+'" class="col-md-12">'
                +'<select class="form-control" name="'+name_value+'">'
                +'<option value="true">Yes</option>'
                +'<option selected value="false">No</option>'
                +'</select>'
                + '<input type="text" style="display: none" class="form-control" name="'+name_keys_type+'" id="'+id_keys_type+'" value="Boolean"></div>';

            break;
        default:
            div.innerHTML = '<div id="'+id_value+'" class="col-md-12">'
                +'<textarea name="'+name_value+'" rows="2" cols="31" placeholder="Insert observation"></textarea>'
                + '<input type="text" style="display: none" class="form-control" name="'+name_keys_type+'" id="'+id_keys_type+'" value="String" ></div>';

    }

    document.getElementById(type_value).appendChild(div);

}

// Le pasamos el selector que queremos deshabilitar y el contador
function disable_selector(select,cont){

    if (cont>0)
    {
        console.log(select+cont);
        var disableSelector = document.getElementById(select+cont);
        disableSelector.disabled = true;
    }
}

//Con esta función evitamos que se inserten nuevos metadatos hasta que se seleccione un fichero "file"
function checkIfEmpty() {

    if (!document.getElementById("fichero").value) {
        alert("Please select file to add metadata");
    } else {
        document.onclick = add_metadata_file();
    }
}

//Con esta función evitamos que se inserten nuevos metadatos hasta que se seleccione un fichero "file"
function checkIfEmptySample() {

    if (!document.getElementById("muestra").value) {
        alert("Please select Sample to add metadata");
    } else {
        document.onclick = add_metadata_sample();
    }
}

















