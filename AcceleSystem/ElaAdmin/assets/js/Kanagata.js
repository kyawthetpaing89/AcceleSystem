function KanagataList_Load() {
    $("#KanagataType").val("1");

    $("#formtitle").text("金型検索")
    GetCasting();
    $("#KanagataInput").focus();
}

function KanagataKeyDown(e) {
    var key = e.keyCode || e.which;
    if (key == 13) {
        GetCasting();
        return false;
    }
}

function GetCasting() {
    var kgmodel = {
        CastingName: $('#KanagataInput').val(),
    };

    var url = $("#tblCasting").data('request-url');
    var response = CalltoApiController(url, kgmodel);
    BindCastingTable(response);
}

function BindCastingTable(response) {
    table = $('#tblCasting').DataTable({
        data: JSON.parse(response),
        "bFilter": false,
        "bLengthChange": false,
        "bSort": false,
        "bInfo": false,
        "destroy": true,
        "columns": [
            {
                "data": null,
                className: "Border1",
                render: function (data, type, row) {
                    if ($("#KanagataType").val() == "1") {
                        return '<table class="col-md-12"><tr><td style="width:25%">' + data.CastingCD + '</td><td style="width:45%">' + data.CastingName + '</td><td style="width:20%"><label><a href="#" onClick="btnEditClick(\'' + data.CastingCD + '\')" style="color:blue">編集</a></label>&nbsp;&nbsp;&nbsp;<label><a href="#" onClick="btnDelClick(\'' + data.CastingCD + '\')" style="color:red">削除</a></label></td></tr></table>';
                    }
                    else {
                        return '<table class="col-md-12"><tr><td style="width:25%">' + data.CastingCD + '</td><td style="width:45%">' + data.CastingName + '</td><td style="width:20%"><label><a href="#" onClick="ReturnSelected(\'' + data.CastingCD + '\',\'' + data.CastingName +'\')" style="color:blue">選択</a></label></td></tr></table>';
                    }
                }
            },
        ]

    });
}