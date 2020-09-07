

function CalltoApiController(url, model) {
  
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
            //alert("cc");
            result = data;
        },
    });
    return result;
}

function ShowConfirmMessage(msgid, functionname) {
    var Mmodel = {
        MessageID: msgid,
    };

    var data = CalltoApiController($("#MessageURL").val(), Mmodel);
    var msgdata = JSON.parse(data);

    Swal.fire({
        title: msgdata[0].MessageID,
        text: msgdata[0].MessageText1,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'はい。',
        cancelButtonText: 'いいえ。'
    }).then((result) => {
        if (result.value) {
            var fn = window[functionname];
            fn();
        }
    })
}

function ShowErrorMessage(msgid, functionname) {
    var Mmodel = {
        MessageID: msgid,
    };
    var data = CalltoApiController($("#MessageURL").val(), Mmodel)

    var msgdata = JSON.parse(data);

    Swal.fire({
        icon: 'error',
        title: msgdata[0].MessageID,
        text: msgdata[0].MessageText1,
    }).then(function () {
        if (functionname) {
            var fn = window[functionname];
            fn('NG');
        }
    })
}

function ShowSuccessMessage(msgdata, url) {
    var message = JSON.parse(msgdata);
    Swal.fire({
        icon: message[0].status,
        title: message[0].MessageID,
        text: message[0].MessageText1,
    }).then(function () {
        if (message[0].status != "error")
            location.href = url;
    });
}

function RequiredCheck(ctrl) {
    $(ctrl).attr("data-Required", "1");
}

function RemoveRequired(ctrl) {
    $(ctrl).removeAttr("data-Required");
}

function RemoveExistCheck(ctrl) {
    $(ctrl).removeAttr("data-ExistsCheck");
    $(ctrl).removeAttr("data-ExistsApiUrl");
    $(ctrl).removeAttr("data-NameCtrl");
    $(ctrl).removeAttr("data-Param1");
}

function ExistsCheck(ctrl, val, apiURL, ctrlName, param1) {
    $(ctrl).attr("data-ExistsCheck", val);
    $(ctrl).attr("data-ExistsApiUrl", apiURL);
    $(ctrl).attr("data-NameCtrl", ctrlName);
    $(ctrl).attr("data-Param1", param1);
}

function AlreadyExistsCheck(ctrl, val, apiURL, param1) {
    $(ctrl).attr("data-AlreadyExistsCheck", val);
    $(ctrl).attr("data-AlreadyExistsApiUrl", apiURL);
    $(ctrl).attr("data-Param1", param1);
}

function LessthanZeroCheck(ctrl, val, apiURL) {
    $(ctrl).attr("data-LessthanCheck", val);
    $(ctrl).attr("data-LessthanCheck_ApiUrl", apiURL);
}


function ErrorCheckOnSave() {
    var r1 = "0";
    $('#divMain *').filter(':input').each(function () {
        var result = ErrChk(this);
        if (result != "0") {
            $(this).focus();
            r1 = result;
            return false;
        }
    });
    return r1;
}

function DateCheck(ctrl, ApiURL, ctrlName, param1) {
    //$(ctrl).attr("data-DateCheck", "1");
    $(ctrl).attr("data-DateCheckApiUrl", ApiURL);
    $(ctrl).attr("data-NameCtrl", ctrlName);
    $(ctrl).attr("data-Param1", param1);
    $(ctrl).attr("data-DateCheck", "1");
}

function YearMonthCheck(ctrl, val) {
    $(ctrl).attr("data-yearmonth_check", "1");
    $(ctrl).attr("data-yearmonth_DataCheckApiUrl", val);
   
}

function DateComapre(ctrl, val) {
    $(ctrl).attr("data-datecompare", "1");
    $(ctrl).attr("data-datecompare_DataCheckApiUrl", val); 
    $(ctr).attr("data-Param1", val2);
}

function KeyDown(e, ctrl, functionname) {
    if (e.which == 13) {
        e.preventDefault();
        var result = ErrChk(ctrl);
        if (result == "0") {
            moveNext(ctrl);
            if (functionname) {
                var fn = window[functionname];
                fn('OK');
            }
        }
        else {
            ShowErrorMessage(result, functionname);
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

    if ($(ctrl).val()) {
        var dataExistsCheck = $(ctrl).attr("data-ExistsCheck");
        if (dataExistsCheck) {
            var ApiURL = $(ctrl).attr("data-ExistsApiUrl");
            var param1 = $(ctrl).attr("data-Param1");
            switch (dataExistsCheck) {
                case "User":
                    var model = {
                        UserID: $(ctrl).val()
                    }
                    var data = CalltoApiController(ApiURL, model);
                    var UserData = JSON.parse(data);
                    if (UserData[0].MessageID != "E101") {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val(UserData[0].UserName);
                            $('#' + ctrlName).text(UserData[0].UserName);
                            
                            return "0";
                        }
                    }
                    else {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val("");
                            return UserData[0].MessageID;

                        }
                    }
                    break;

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
                            $('#' + ctrlName).text(BrandData[0].BrandName);
                            return "0";
                        }
                    }
                    else {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val("");
                            return BrandData[0].MessageID;
                        }
                    }
                    break;
                case "Keihi":
                    var model = {
                        CostCD: $(ctrl).val()
                    };
                    alert(CostCD);
                    var data = CalltoApiController(ApiURL, model);
                    var KeihiData = JSON.parse(data);
                    if (KeihiData[0].MessageID != "E101") {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val(KeihiData[0].CostName);
                            $('#' + ctrlName).text(KeihiData[0].CostName);
                            var ctname = $(ctrl).attr("data-Param1");
                            $('#' + ctname).val(KeihiData[0].Accounting);
                            $('#' + ctname).text(KeihiData[0].Accounting);
                            return "0";
                        }
                    }
                    else {
                        alert("aa");
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val("");
                            return KeihiData[0].MessageID;
                        }
                    }
                    break;
                case "Kanjo":
                    var model = {
                        KanjoCD: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var KanjoData = JSON.parse(data);
                    if (KanjoData[0].MessageID != "E101") {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).text(KanjoData[0].KanjoName);
                            $("#TmpVal1").val(KanjoData[0].HojoKBN);
                            return "0";
                        }
                    }
                    else {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val("");
                            return KanjoData[0].MessageID;
                        }
                    }
                    break;
                case "Hojo":
                    var model = {
                        HojoCD: $(ctrl).val(),
                        KanjoCD: param1
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var HojoData = JSON.parse(data);
                    if (HojoData[0].MessageID != "E101") {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).text(HojoData[0].HojoName);
                            return "0";
                        }
                    }
                    else {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val("");
                            return HojoData[0].MessageID;
                        }
                    }
                    break;
                case "Koushiin":
                    var model = {
                        processing_date: $(ctrl).val(),
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var Koushiin = JSON.parse(data);
                    if (Koushiin[0].MessageID == "E101") {
                        return Koushiin[0].MessageID;
                    }
                    break;
                case "Casting":
                    var model = {
                        CastingCD: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var CastingData = JSON.parse(data);
                    if (CastingData[0].MessageID != "E101") {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val(CastingData[0].CastingName);
                            return "0";
                        }
                    }
                    else {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val("");
                            return CastingData[0].MessageID;
                        }
                    }
                    break;
                case "Project":
                    var model = {
                        ProjectCD: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var ProjectData = JSON.parse(data);
                    if (ProjectData[0].MessageID != "E101") {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val(ProjectData[0].ProjectName);
                            $('#' + ctrlName).text(ProjectData[0].ProjectName);
                            return "0";
                        }
                    }
                    else {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val("");
                            return ProjectData[0].MessageID;
                        }
                    }
                    break;
                case "Hinban":
                    var model = {
                        HinbanCD: $(ctrl).val(),
                        ProjectCD: param1
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var HinbanData = JSON.parse(data);
                    if (HinbanData[0].MessageID != "E101") {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val(HinbanData[0].HinbanName);
                            return "0";
                        }
                    }
                    else {
                        if ($(ctrl).attr("data-NameCtrl")) {
                            var ctrlName = $(ctrl).attr("data-NameCtrl");
                            $('#' + ctrlName).val("");
                            return HinbanData[0].MessageID;
                        }
                    }
                    break;
            }
        }

        var dataAlreadyExistsCheck = $(ctrl).attr("data-AlreadyExistsCheck");
        if (dataAlreadyExistsCheck) {
            var ApiURL = $(ctrl).attr("data-AlreadyExistsApiUrl");
            var param1 = $(ctrl).attr("data-Param1");
            switch (dataAlreadyExistsCheck) {
                case "Casting":
                    var model = {
                        CastingCD: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var CastingData = JSON.parse(data);
                    if (CastingData[0].MessageID != "E107") {
                        return "0";
                    }
                    else {
                        return BrandData[0].MessageID;
                    }
                    break;
                case "User":
                    var model = {
                        UserID: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var UserData = JSON.parse(data);
                    if (UserData[0].MessageID != "E107") {
                        return "0";
                    }
                    else {
                        return UserData[0].MessageID;
                    }
                    break;
                case "Brand":
                    var model = {
                        BrandCD: $(ctrl).val()
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
                case "Keihi":
                    var model = {
                        CostCD: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var KeihiData = JSON.parse(data);
                    if (KeihiData[0].MessageID != "E107") {
                        return "0";
                    }
                    else {
                        return KeihiData[0].MessageID;
                    }
                    break;
                case "Kanjo":
                    var model = {
                        KanjoCD: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var KanjoData = JSON.parse(data);
                    if (KanjoData[0].MessageID != "E107") {
                        return "0";
                    }
                    else {
                        return KanjoData[0].MessageID;
                    }
                    break;
                case "Hojo":
                    var model = {
                        HojoCD: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var HojoData = JSON.parse(data);
                    if (HojoData[0].MessageID != "E107") {
                        return "0";
                    }
                    else {
                        return HojoData[0].MessageID;
                    }
                    break;
                case "Project":
                    var model = {
                        ProjectCD: $(ctrl).val()
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var ProjectData = JSON.parse(data);
                    if (ProjectData[0].MessageID != "E107") {
                        return "0";
                    }
                    else {
                        return ProjectData[0].MessageID;
                    }
                    break;
                case "Hinban":
                    var model = {
                        HinbanCD: $(ctrl).val(),
                        ProjectCD: param1
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var HinbanData = JSON.parse(data);
                    if (HinbanData[0].MessageID != "E107") {
                        return "0";
                    }
                    else {
                        return HinbanData[0].MessageID;
                    }
                    break;
            }
        }

        var dateCheck = $(ctrl).attr("data-DateCheck");
        var param1 = $(ctrl).attr("data-NameCtrl");
        var startdate = $(ctrl).attr("data-Param1");
        if (dateCheck == "1") {
            var ApiURL = $(ctrl).attr("data-DateCheckApiUrl");
            var model = {
                inputdate: $(ctrl).val(),
                flg: param1,
                startDate: startdate,

            };
            var data = CalltoApiController(ApiURL, model);
            var dateData = JSON.parse(data);
            if (dateData[0].flg == "false") {
                return "E103";
            }
            else if (dateData[0].flg == "true") {
                var dataresult = dateData[0].resultdate;
                if (param1 == "1") {
                    var ApiURL = "/api/CommonApi/DateComapre";
                    var model = {
                        endDate: dataresult,
                        startDate: startdate,
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var dateData = JSON.parse(data);
                    if (dateData[0].flg == "false") {
                        return "E112";
                    }
                    else if (dateData[0].flg == "true") {
                        $(ctrl).val(dateData[0].resultdate);
                        return "0";
                    }
                }
                else if(param1 == "2") {
                    var ApiURL = "%2Fapi%2FTouroku_KeihiApi%2FM_Control_FiscalCheck";
                    var model = {
                        inputdate: dataresult,
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var dateData = JSON.parse(data);
                    if (dateData[0].MessageID != "E115") {
                        $(ctrl).val(dataresult);
                        return "0";
                    }
                    else {
                        return dateData[0].MessageID;
                    }
                }
                $(ctrl).val(dateData[0].resultdate);
                return "0";
            }
        }

        var dataLessthanCheck = $(ctrl).attr("data-LessthanCheck");
        if (dataLessthanCheck) {
            var ApiURL = $(ctrl).attr("data-LessthanCheck_ApiUrl");
            switch (dataLessthanCheck) {
                case "Production":
                    var model = {
                        Production: $(ctrl).val(),
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var ProductionData = JSON.parse(data);
                    if (ProductionData[0].flg == "false") {
                        return "E109";
                    }
                    else {
                        $(ctrl).val(ProductionData[0].resultdata);
                        return "0";
                    }
                    break;
                case "SalePrice":
                    var model = {
                        SalePrice: $(ctrl).val(),
                    };
                    var data = CalltoApiController(ApiURL, model);
                    var SalePriceData = JSON.parse(data);
                    if (SalePriceData[0].flg == "false") {
                        return "E109";
                    }
                    else {
                        $(ctrl).val(SalePriceData[0].resultdata);
                        return "0";
                    }
                    break;
            }
        }
    }
    else {
        if ($(ctrl).attr("data-NameCtrl")) {
            var ctrlName = $(ctrl).attr("data-NameCtrl");
            $('#' + ctrlName).val("");
            return "0";
        }
    }

    var yearmonthcheck = $(ctrl).attr("data-yearmonth_check");
    if (yearmonthcheck == "1") {
        if ($(ctrl).val()) {
            var ApiURL = $(ctrl).attr("data-yearmonth_DataCheckApiUrl");
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
        else {
            return "1";
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

$(document).ready(function () {

    if ($('.input-numeral1')[0]) {
        var cleaveNumeral1 = new Cleave('.input-numeral1', {
            numeral: true,
            numeralThousandsGroupStyle: 'thousand'
        });
    }

    if ($('.input-numeral2')[0]) {
        var cleaveNumeral2 = new Cleave('.input-numeral2', {
            numeral: true,
            numeralThousandsGroupStyle: 'thousand'
        });
    }

    if ($('.input-numeral3')[0]) {
        var cleaveNumeral3 = new Cleave('.input-numeral3', {
            numeral: true,
            numeralThousandsGroupStyle: 'thousand'
        });
    }

    if ($('.input-numeral4')[0]) {
        var cleaveNumeral4 = new Cleave('.input-numeral4', {
            numeral: true,
            numeralThousandsGroupStyle: 'thousand'
        });
    }

    if ($('.input-numeral5')[0]) {
        var cleaveNumeral5 = new Cleave('.input-numeral5', {
            numeral: true,
            numeralThousandsGroupStyle: 'thousand'
        });
    }

    if ($('.input-numeral6')[0]) {
        var cleaveNumeral2 = new Cleave('.input-numeral6', {
            numeral: true,
            numeralThousandsGroupStyle: 'thousand'
        });
    }

});
