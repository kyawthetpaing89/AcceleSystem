//Show Message
function GetMessage(msgid) {
    var Mmodel = {
        MessageID: msgid,
    };

    return $.ajax({
        url: $("#MessageURL").val(),
        method: 'Post',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(Mmodel),
        headers:
        {
            Authorization: 'Basic ' + btoa('Capital_MM' + ':' + 'CKM12345!')
        },
        success: function (msg) {
            return msg;
        }
    });
}

//move to next control on enter(keypressevent,action control,Required,AlreadyExistsCheck)
//AEFlag 0 = nothing, 1 = isExist 
//type 1 = UserID, 2 = Brand, 3 = Kanagata, 4 = Keihi
//checktype 1 = datecheck
function EnterKeyPress(e, ctrl,isRequired,AEFlag,type,checktype) {
    if (e.keyCode == 13) {
        e.preventDefault();
        if (isRequired) {
            if (!$(ctrl).val()) {
                $.when(GetMessage("E102")).done(function (data) {
                    var msgdata = JSON.parse(data);

                    Swal.fire({
                        icon: 'error',
                        title: msgdata[0].MessageID,
                        text: msgdata[0].MessageText1,
                    }).then(function () {
                        $(ctrl).focus();
                    });
                })
            }
            else {
                if (AEFlag == 1) {
                    if (type == 1) {
                        var model = {
                            UserID: $(ctrl).val(),
                        };

                    }
                    else if (type == 2) {
                        var model = {
                            BrandCD: $(ctrl).val()
                        };
                    }
                    else if (type == 3) {
                        var model = {
                            CastingCD: $(ctrl).val()
                        };
                    }
                    else if (type == 4) {
                        var model = {
                            CostCD: $(ctrl).val()
                        };
                    }
                    $.ajax({
                        url: $("#APIURL").val(),
                        method: 'Post',
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify(model),
                        headers:
                        {
                            Authorization: 'Basic ' + btoa('Capital_MM' + ':' + 'CKM12345!')
                        },
                        success: function (msg) {
                            var msgdata = JSON.parse(msg);
                            if (msgdata[0].MessageID != "0") {
                                Swal.fire({
                                    icon: 'error',
                                    title: msgdata[0].MessageID,
                                    text: msgdata[0].MessageText1,
                                }).then(function () {
                                    $(ctrl).focus();
                                });
                            }
                            else {
                                moveNext(ctrl);
                            }
                        }
                    });
                }
                else
                    moveNext(ctrl);
            }
        }
        else if (checktype == "1") {
            if (($(ctrl).val())) {
                if (!(Date.parse($(ctrl).val()))) {
                //if (!(validDateCheck(ctrl))) {
                    $.when(GetMessage("E103", '@Url.Action("M_Message_Select", "api/MessageApi")')).done(function (data) {
                        var msgdata = JSON.parse(data);
                        Swal.fire({
                            icon: 'error',
                            title: msgdata[0].MessageID,
                            text: msgdata[0].MessageText1,
                        }).then(function () {
                            $(ctrl).focus();
                        });
                    })
                }
                else
                    moveNext(ctrl);
            }
            else 
                moveNext(ctrl);
        }
        else 
             moveNext(ctrl);
    }
}

function moveNext(ctrl) {
    var $next = $('[tabIndex=' + (+$(ctrl).attr("tabIndex") + 1) + ']');
    if ($($next).is('[disabled=disabled]'))
        $next = $('[tabIndex=' + (+$($next).attr("tabIndex") + 1) + ']');
    if (!$next.length) {
        $next = $('[tabIndex=1]');
    }
    $next.focus();
}

function validDateCheck(ctrl) {    //CheckDate
    var input = $(ctrl).val();
    //var aa = parseInt(input.replace("/", "").replace("-", ""));
    if (Number.isInteger(parseInt(input.replace("/", "").replace("-", "")))) {
        var day;
        var month;
        var year;
        var result;
        var today = new Date();
        if (input.includes("/")) {
            var date = input.split("/");
            day = date[2];
            month = date[1];
            year = date[0];
            if (day == 0 || day == 00) {
                return false;
            }
            else if (day.length == 1)
                day = "0" + day;
            if (month == 0 || month == 00) {
                return false;
            }
            else if (month.length == 1)
                month = "0" + month;

            input = year + month + day;
        }
        else if (input.includes("-")) {
            day = date[2];
            month = date[1];
            year = date[0];
            if (day == 0 || day == 00) {
                return false;
            }
            else if (day.length == 1)
                day = "0" + day;
            if (month == 0 || month == 00) {
                return false;
            }
            else if (month.length = 1)
                month == "0" + month;

            input = year + month + day;
        }
        var q = ('0'.repeat(8) + input).slice(-8);
        day = q.substring(q.length - 2);
        month = q.substring(q.length - 4).substring(0, 2);
        year = parseInt(q.substring(0, q.length - 4)).toString();

        if (month == "00") {
            month = "";
        }
        if (year == "0") {
            year = "";
        }

        if (month == "") {
            month = ('0'.repeat(2) + String(today.getMonth())).slice(-2);
        }
        if (year == "") {
            year = String(today.getFullYear);
        }
        else {
            if (year.length == 1)
                year = "200" + year
            else if (year.length == 2)
                year = "20" + year;
        }
        
        $(ctrl).attr.text = year + "/" + month + "/" + day;
        return true;
    }
    else return false;
}
