﻿function CalltoApiController(url, model) {
    var result;
    $.ajax({
        url: url.replace("%2F", "/"),
        method: 'POST',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(model),
        async: false,
        headers:
        {
            Authorization: 'Basic ' + btoa('Capital_MM' + ':' + 'CKM12345!')
        },
        success: function (data) {
            result = data;
        },
        //error: function (data) {
        //    ShowMessage('');
        //    return null;
        //}
    });
    return result;
}

function ShowMessage(msgid) {
    var Mmodel = {
        MessageID: msgid,
    };

    var data = CalltoApiController($("#MessageURL").val(), Mmodel)

    var msgdata = JSON.parse(data);

    Swal.fire({
        icon: 'error',
        title: msgdata[0].MessageID,
        text: msgdata[0].MessageText1,
    })
}

function RequiredCheck(ctrl) {
    $(ctrl).attr("data-Required", "1");
}

function ExistsCheck(ctrl,val,apiURL,ctrlName) {
    $(ctrl).attr("data-ExistsCheck", val);
    $(ctrl).attr("data-ExistsApiUrl", apiURL);
    $(ctrl).attr("data-NameCtrl", ctrlName);
}

function AlreadyExistsCheck(ctrl, val, apiURL) {
    $(ctrl).attr("data-AlreadyExistsCheck", val);
    $(ctrl).attr("data-AlreadyExistsApiUrl", apiURL);
}

function DateCheck(ctrl,val) {
    $(ctrl).attr("data-DateCheck", "1");
    $(ctrl).attr("data-DateCheckApiUrl", val);
}

function KeyDown(e, ctrl) {
    if (e.which == 13) { 
        e.preventDefault();
        var result = ErrChk(ctrl);
        if (result == "0") {
            moveNext(ctrl);
        }
        else {
            ShowMessage(result);
        }
    }
}

function ErrChk(ctrl) {
    var req = $(ctrl).attr("data-Required");
    if (req == "1") {
        if (!$(ctrl).val()) {
            return "E102";
        }
    }

    var dataExistsCheck = $(ctrl).attr("data-ExistsCheck");  
    if (dataExistsCheck) {
        var ApiURL = $(ctrl).attr("data-ExistsApiUrl");
        switch (dataExistsCheck) {
            case "Brand":
                var model = {
                    BrandCD: $(ctrl).val()
                };
                var data = CalltoApiController(ApiURL, model);
                var BrandData = JSON.parse(data);
                if (BrandData[0].MessageID != "E101") {
                    if ($(ctrl).attr("data-NameCtrl")) {
                        var ctrlName = $(ctrl).attr("data-NameCtrl");
                        $('#' + ctrlName).val(BrandData[0].BrandName);
                        return "0";
                    }
                }
                else {
                    return BrandData[0].MessageID;
                }
                break;
        }
    }

    var dataAlreadyExistsCheck = $(ctrl).attr("data-AlreadyExistsCheck");
    if (dataAlreadyExistsCheck) {
        var ApiURL = $(ctrl).attr("data-AlreadyExistsApiUrl");
        switch (dataAlreadyExistsCheck) {
            case "Casting":
                var model = {
                    CastingCD: $(ctrl).val()
                };
                var data = CalltoApiController(ApiURL, model);
                var BrandData = JSON.parse(data);
                if (BrandData[0].MessageID != "E107") {
                    return "0";
                }
                else {
                    return BrandData[0].MessageID;
                }
                break;
        }
    }

    var dateCheck = $(ctrl).attr("data-DateCheck");
    if (dateCheck == "1") {
        var ApiURL = $(ctrl).attr("data-DateCheckApiUrl");
        var model = {
            inputdate: $(ctrl).val(),
        };
        var data = CalltoApiController(ApiURL, model);
        var dateData = JSON.parse(data);
        if (dateData[0].flg == "false") {
            return "E103";
        }
        else if (dateData[0].flg == "true") {
            $(ctrl).val(dateData[0].resultdate);
            return "0";
        }
    }

    return "0";
}

function moveNext(ctrl) {
    do {
        ctrl = $('[tabIndex=' + (+$(ctrl).attr("tabIndex") + 1) + ']');
        if (!$(ctrl).length) {
            ctrl = $('[tabIndex=1]');
            break;
        }
    } while ($(ctrl).is('[disabled=disabled]'));
    $(ctrl).select();
    $(ctrl).focus();
}
