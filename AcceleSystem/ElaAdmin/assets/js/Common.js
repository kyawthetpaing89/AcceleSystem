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
//AEFlag 0 = nothing,
//1 = UserID
function EnterKeyPress(e, ctrl,isRequired,AEFlag) {
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
                    var Umodel = {
                        UserID: $(ctrl).val(),
                    };
                    $.ajax({
                        url: $("#UserAPIURL").val(),
                        method: 'Post',
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify(Umodel),
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
        else {
            moveNext(ctrl);
        }
    }
}

function moveNext(ctrl) {
    var $next = $('[tabIndex=' + (+$(ctrl).attr("tabIndex") + 1) + ']');
    if (!$next.length) {
        $next = $('[tabIndex=1]');
    }
    $next.focus();
}