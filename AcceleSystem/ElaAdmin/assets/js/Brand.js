function BrandList_Load() {
    $("#BrandType").val("1");
    $("#formtitle").text("ブランド検索");
    GetBrand();
    $("#myInput").focus();
}

function BrandKeyDown(e) {
    var key = e.keyCode || e.which;
    if (key == 13) {
        GetBrand();
        return false;
    }
}

function GetBrand() {
    var bmodel = {
        BrandName: $('#myInput').val(),
    };

    var url = $("#tblBrand").data('request-url');
    var response = CalltoApiController(url, bmodel);
    BindBrandTable(response);
}

function BindBrandTable(response) {
    table = $('#tblBrand').DataTable({

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
                    if ($("#BrandType").val() == "1") {
                        return '<table class="col-md-12"><tr><td style="width:20%">' + data.BrandCD + '</td><td style="width:60%">' + data.BrandName + '</td><td style="width:20%"><label><a href="#" onClick="EditBrand(\'' + data.BrandCD + '\')" style="color:blue">編集</a></label>&nbsp;&nbsp;&nbsp;<label><a href="#" onClick="DelBrand(\'' + data.BrandCD + '\')" style="color:red">削除</a></label></td></tr>'
                    }
                    else {
                        return '<table class="col-md-12"><tr><td style="width:20%">' + data.BrandCD + '</td><td style="width:60%">' + data.BrandName + '</td><td style="width:20%"><label><a href="#" onClick="SelectBrand(\'' + data.BrandCD + '\',\''+ data.BrandName +'\')" style="color:blue">選択</a></label></td></tr>'
                    }
                }
            },

        ]
    });

}