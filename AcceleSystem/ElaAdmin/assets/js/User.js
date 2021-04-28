function UserList_Load() {
    $("#UserType").val("1");
    $("#formtitle").text("ユーザー検索");
    GetUser();
    $("#UserInput").focus();
}

function UserKeyDown(e) {
    var key = e.keyCode || e.which;
    if (key == 13) {
        GetUser();
        return false;
    }
}

function GetUser() {
    var Umodel = {
        UserName: $('#UserInput').val(),
    };

    var url = $("#tblUser").data('request-url');
    var response = CalltoApiController(url, Umodel);
    BindUserTable(response);
}

function BindUserTable(response) {
    table = $('#tblUser').DataTable({
        data: JSON.parse(response),
        "bFilter": false,
        "bLengthChange": false,
        "bInfo": false,
        "bSort": false,
        destroy: true,
        "columns": [
            {
                "data": null,
                className: "Border1",
                render: function (data, type, row) {
                    if ($("#UserType").val() == "1") {
                        return '<table class="col-md-12"><tr><td style="width:30%">' + data.ID + '</td><td style="width:55%">' + data.UserName + '</td><td style="width:15%"><label><a href="#" onClick="EditUser(\'' + data.ID + '\')" style="color:blue">編集</a></label>&nbsp;&nbsp;&nbsp;<label><a href="#" onClick="DelUser(\'' + data.ID + '\')" style="color:red">削除</a></label></td></tr></table>';
                    }
                    else {
                        return '<table class="col-md-12"><tr><td style="width:30%">' + data.ID + '</td><td style="width:55%">' + data.UserName + '</td><td style="width:15%"><label><a href="#" onClick="ReturnSelected(\'' + data.ID + '\',\'' + data.UserName +'\')" style="color:blue">選択</a></label></td></tr></table>';
                    }
                }
            },

        ]
    });
}
