function KeihiSettieList_Load() {
    $("#KeihiSettieType").val("1");
    $("#formtitle").text("金型検索")
    GetKeihi();
    $("#myInput").focus();
}

function KeihiSettieKeyDown(e) {
    var key = e.keyCode || e.which;
    if (key == 13) {
        GetKeihi();
        return false;
    }
}

function GetKeihi() {
    var Kmodel = {
        CostName: $('#myInput').val(),
    };

    var url = $("#tblKeihi").data('request-url');
    var response = CalltoApiController(url, Kmodel);
    BindKeihiSettieTable(response);
}

function BindKeihiSettieTable(response) {
    table = $('#tblKeihi').DataTable({
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
                    return '<label  class="fixed-keihisetti">' + data.CostCD + '</label>';
                }
            },
            {
                "data": null,
                className: "Border2",
                render: function (data, type, row) {
                    return '<label class="text-keihisetti">' + data.CostName + '</label>';
                }
            },
            {
                "data": null,
                className: "Border3",
                render: function (data, type, row) {
                    return '<label class="fixed-keihisetti">' + data.Accounting + '</label>';
                }
            },
            {
                "data": null,
                className: "Border4",
                render: function (data, type, row) {
                    return '<label  class="fixed-keihisetti">' + data.Allocation + '</label>';
                }
            },
            {
                "data": null,
                className: "Border5",
                render: function (data, type, row) {
                    if ($("#KeihiSettieType").val() == "1") {
                        return '<label><a href="#" onClick="btnEditClick(\'' + data.CostCD + '\')" style="color:blue">編集</a></label>&nbsp;&nbsp;<label><a href="#" onClick="btnDelClick(\'' + data.CostCD + '\')" style="color:red">削除</a></label>';
                    }
                    else {
                        return '<label><a href="#" onClick="ReturnSelected(\'' + data.CostCD + '\',\'' + data.CostName +'\')" style="color:blue">選択</a></label></td></tr></table>';
                    }
                }
            }
        ]
    });
}