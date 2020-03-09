var a = document.getElementById("cont").value;

function add_fields() {
    var div = document.createElement('div');
    div.innerHTML = '<div style="clear:both" class="col-md-offset-3 col-md-3">'
        + '<input class="keys form-control" id="keys" name="keys" type="text" '
        + 'placeholder="Insert Field"  oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required/></div>'
        + '<div class="form-group col-md-3">'
        + '<select class="form-control" id="values" name="values">'
        + '<option selected value="String">String</option>'
        + '<option value="Integer">Number</option>'
        + '<option value="Date">Date</option>'
        + '<option value="Boolean">Checkbox</option>'
        + '<option value="Textarea">textarea</option>'
        + '</select></div>';
    document.getElementById('Fields').appendChild(div);
    document.getElementById('Fields').appendChild(div);
}

/* This is Key for compound fields */
function add_compound_key() {
    if (a < 1) {
        a++;
        var div = document.createElement('div');
        div.innerHTML = '<div class="col-md-offset-3 col-md-3">'
            + '<input class="keys form-control" id="keysp" name="subkeys' + a + '" type="text" '
            + 'placeholder="Insert compound field (e.g Address)"'
            + 'oninvalid="setCustomValidity(\'Please fill this field.\')" oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required/>'
            + '</div>'
            + '<div class="col-md-3"><input type="button" class="btn btn-primary" id="add_new_subfield()" onClick="add_subfields('+a+')" value="+" /> '
            + '<input type="button" class="btn btn-primary" id="deleteSubfields" onclick="delete_fields(\'SubFields'+a+'\')" value="-"/></div>';
    } else {
        alert("Only two Subfields can be insert")

    }

    document.getElementById('SubKeyp' + a + '').appendChild(div);
    document.getElementById('SubKeyp' + a + '').appendChild(div);
}

/*Add sub-fields to the compound key */
function add_subfields(a) {

    var inobj = document.getElementById("keysp").value;

    var div = document.createElement('div');

    if (!inobj == "" || !inobj == null) {

        div.innerHTML = '<div class="col-md-offset-4 col-md-3">'
            + '<input class="keys form-control" id="subkeys' + a + '" name="subsubkeys' + a + '" type="text" '
            + ' placeholder="Insert subfield " oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required/></div>'
            + '<div class="form-group col-md-3">'
            + '<select class="form-control" id="subvalues" name="subsubvalues' + a + '">'
            + '<option selected value="String">String</option>'
            + '<option value="Integer">Number</option>'
            + '<option value="Date">Date</option>'
            + '<option value="Boolean">Checkbox</option>'
            + '<option value="Textarea">textarea</option>'
            + '</select></div>';

        document.getElementById('SubFields' + a ).appendChild(div);
        document.getElementById('SubFields' + a ).appendChild(div);

    }else
    {
        alert('Fill compound field before adding subfields');
    }

}

/* We add fields to the compound fields that we previously declared */
function add_static_subfields(a) {

    var inobj = document.getElementById("subkeys").value;

    var div = document.createElement('div');

    if (!inobj == "" || !inobj == null) {

        div.innerHTML = '<div style="clear:both" class="col-md-offset-3 col-md-3">'
            + '<input class="keys form-control" id="subkeys" name="subsubkeys' + a + '" type="text" '
            + ' placeholder="Insert subfield"  oninvalid="setCustomValidity(\'Please fill this field.\')" oninput="setCustomValidity(\'\')" required=""/></div>'
            + '<div class="form-group col-md-3">'
            + '<select class="form-control" id="subvalues" name="subsubvalues' + a + '">'
            + '<option selected value="String">String</option>'
            + '<option value="Integer">Number</option>'
            + '<option value="Date">Date</option>'
            + '<option value="Boolean">Checkbox</option>'
            + '<option value="Textarea">textarea</option>'
            + '</select></div>';
        document.getElementById('StaticSubFields' + a ).appendChild(div);
        document.getElementById('StaticSubFields' + a ).appendChild(div);

    }

}

/* Delete function for simple fields */
function delete_fields(ID) {
    var elem = document.getElementById(ID);
    if (elem.lastChild == null)
    {
        alert('There is no more fields to remove');
    }else {
        elem.removeChild(elem.lastChild);
    }
}

/* Delete function for compound fields */
function delete_subfields() {
    if (document.getElementById('subkeys' + a + '')) {
        alert("Please delete all subfields firts");
    } else {
        delete_fields('SubKeyp' + a + '');
        a--;
    }
}

/* We should ask before complete form */
function form_ask() {
    var valid = true;
    var keys = document.getElementsByClassName('keys');
    for (i = 0; i < keys.length; i++) {
        // If a field is empty...
        if (keys[i].value === "") {
            // add an "invalid" class to the field:
            keys[i].className += " invalid";
            valid = false;
        }
    }

    if(valid)
    {
        if (confirm('Are you sure to create this form?')) {
            document.FormDesign.submit();
        }
    }


}



















