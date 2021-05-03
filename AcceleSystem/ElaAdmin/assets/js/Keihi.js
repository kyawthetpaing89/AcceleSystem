function KeihiList_Load() {
    $("#CostCD").focus();
    ExistsCheck($("#CostCD"), "Keihi", $("#CostCD").data('existcheck-url'), "CostName");
    DoubleByteCheck($("#CostCD"), $("#CostCD").data('doublebytecheck-url') );

    DateCheck($("#CostDate1"), $("#CostDate1").data('datecheck-url'));
    DateCheck($("#CostDate2"), $("#CostDate1").data('datecheck-url'));

    DoubleByteCheck($("#year"), $("#CostCD").data('doublebytecheck-url'));
    YearCheck($("#year"), $("#year").data('yearcheck-url'));

    ExistsCheck($("#BrandCD"), "Brand", $("#BrandCD").data('existcheck-url'), "BrandName");
    DoubleByteCheck($("#BrandCD"), $("#CostCD").data('doublebytecheck-url'));

    ExistsCheck($("#projectCD"), "Project", $("#projectCD").data('existcheck-url'), "projectname");
    DoubleByteCheck($("#projectCD"), $("#CostCD").data('doublebytecheck-url'));

    DoubleByteCheck($("#PartCD"), $("#CostCD").data('doublebytecheck-url'));
}

function ProjectCheck(result) {
    if (result == 'OK') {
        ExistsCheck($("#PartCD"), "Hinban", $("#PartCD").data('existcheck-url'), "PartName", $("#projectCD").val());
    }
}

function DateCompareCheck(result) {
    if (result == 'OK') {
        if (!($('#CostDate1').val().trim() == '' || $('#CostDate2').val().trim() == '')) {
            var model = {
                startDate: $("#CostDate1").val(),
                endDate: $("#CostDate2").val()
            };

            if (model.startDate <= model.endDate) {
                $("#year").focus();
            }
            else {
                $("#CostDate2").focus();
                ShowErrorMessage("E112");
            }
        }
    }
}

function DateCompareCheckOnSave() {
    if (!($('#CostDate1').val().trim() == '' || $('#CostDate2').val().trim() == '')) {
        var model = {
            startDate: $("#CostDate1").val(),
            endDate: $("#CostDate2").val()
        };
        //var data = CalltoApiController('@Url.Action("DateComapre", "api/CommonApi")', model);
        //var dateData = JSON.parse(data);
        //if (dateData[0].flg != 'false') {
        if (model.startDate <= model.endDate) {
            return "0";
        }
        else {
            return "E112";
        }
    }
    else return "0";
}

function CheckboxCheck(result) {
    if (result == 'OK') {
        var allyear = $("#allyear").is(":checked");
        var ss = $("#SS").is(":checked");
        var fw = $("#FW").is(":checked");
        if (!allyear && !ss && !fw) {
            $("#FW").focus();
            ShowErrorMessage("E111");
        }
    }
}

function Get_KeihiData() {
    var kmodel = {
        CostCD: $('#CostCD').val(),
        CostName: $('#CostName').val(),
        CostDateFrom: $('#CostDate1').val(),
        CostDateTo: $('#CostDate2').val(),
        Year: $('#year').val(),
        BrandCD: $('#BrandCD').val(),
        BrandName: $('#BrandName').val(),
        //Season: $('#season').val(),
        ProjectCD: $('#projectCD').val(),
        ProjectName: $('#projectname').val(),
        HinbanCD: $('#PartCD').val(),
        HinbanName: $('#PartName').val(),
    };

    var selected = new Array();
    $("#Seasongp input[type=checkbox]:checked").each(function () {
        selected.push(this.value);
    });
    if (selected.length > 0)
        kmodel.Season = selected.join(",");

    var response = CalltoApiController($("#CostCD").data('costselect-url'), kmodel);
    if (response == "[]") {
        BindKeihiTable(response);
        var data = ShowErrorMessage("E104");
        return data;
    }
    else {
        BindKeihiTable(response);
    }
}

function BindKeihiTable(response) {
    table = $('#tblTouroku_Keihi').DataTable({
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
                    return '<table class="col-md-12"><tr><td class="text-keihi">' + data.CostCD + '  ' + data.CostName + '</td><td style="width: 30%">' + data.CostDate + '</td><td style="width: 13%"></td><td style="width: 13%; text-align: center;"><label><a href="#" onClick="btnEditClick(\'' + data.SEQ + '\')" style="color:blue">編集</a></label></td></tr> ' +
                        '<tr><td class="text-keihi">' + data.BrandCD + '  ' + data.BrandName + '</td><td>' + data.Season + '</td><td>' + data.Year + '</td><td style="text-align: center;"><label><a href="#" onClick="btnDelClick(\'' + data.SEQ + '\')" style="color:red">削除</a></label></td></tr>' +
                        '<tr><td class="text-keihi">' + data.ProjectCD + '  ' + data.ProjectName + '</td><td colspan=2><span class="fixed-keihi">' + data.HinbanCD + '  ' + data.HinbanName + '</span></td><td style="text-align: center;"><label><a href="#" onClick="btnCopyClick(\'' + data.SEQ + '\')" style="color:green">複写</a></label></td></tr></table > ';
                }
            },
        ]
        //"drawCallback": function (settings) {
        //    $("#tblKeihi thead").remove();
        //}

    });
}

function btnKeihiSearchClick() {
    
    var allyear = $("#allyear").is(":checked");
    var ss = $("#SS").is(":checked");
    var fw = $("#FW").is(":checked");
    if (!allyear && !ss && !fw) {
        $("#FW").focus();
        var data = ShowErrorMessage("E111");
        return data;
    }
    else {
        var res = ErrorCheckOnSave();
        if (res == "0") {
            var res1 = DateCompareCheckOnSave();
            if (res1 == "0") {
                Get_KeihiData();
            }
            else {
                $("#CostDate2").focus();
                ShowErrorMessage(res1);
            }
        }
        else
            ShowErrorMessage(res);
    }

}

function btnKeihiCSVClick() {
    var allyear = $("#allyear").is(":checked");
    var ss = $("#SS").is(":checked");
    var fw = $("#FW").is(":checked");
    if (!allyear && !ss && !fw) {
        $("#FW").focus();
        var data = ShowErrorMessage("E111");
        return data;
    }
    else {
        var res = ErrorCheckOnSave();
        if (res == "0") {
            var res1 = DateCompareCheckOnSave();
            if (res1 == "0") {
                var kmodel = {
                    CostCD: $('#CostCD').val(),
                    CostName: $('#CostName').val(),
                    CostDateFrom: $('#CostDate1').val(),
                    CostDateTo: $('#CostDate2').val(),
                    Year: $('#year').val(),
                    BrandCD: $('#BrandCD').val(),
                    BrandName: $('#BrandName').val(),
                    //Season: $('#season').val(),
                    ProjectCD: $('#projectCD').val(),
                    ProjectName: $('#projectname').val(),
                    HinbanCD: $('#PartCD').val(),
                    HinbanName: $('#PartName').val(),
                };

                var selected = new Array();
                $("#Seasongp input[type=checkbox]:checked").each(function () {
                    selected.push(this.value);
                });
                if (selected.length > 0)
                    kmodel.Season = selected.join(",");

                var data = CalltoApiController($("#CostCD").data('csv-url'), kmodel);

                var csv = JSON2CSV(data);
                if (!(csv == "E104")) {
                    var downloadLink = document.createElement("a");
                    var blob = new Blob(["\ufeff", csv]);
                    var url = URL.createObjectURL(blob);
                    downloadLink.href = url;
                    downloadLink.download = "経費登録.csv";

                    document.body.appendChild(downloadLink);
                    downloadLink.click();
                    document.body.removeChild(downloadLink);
                }
            }
            else {
                $("#CostDate2").focus();
                ShowErrorMessage(res1);
            }
        }
        else
            ShowErrorMessage(res);
    }
}   

//Convert Jsonstring to csv
function JSON2CSV(objArray) {
    if (!(objArray == "[]")) {
        var array = typeof JSONString != 'object' ? JSON.parse(objArray) : JSONString;
        var fields = Object.keys(array[0]);
        var replacer = function (key, value) { return value === null ? null : value }
        var csv = array.map(function (row) {
            return fields.map(function (fieldName) {
                return JSON.stringify(row[fieldName], replacer)
            }).join(',')
        })
        csv.unshift(fields.join(',')) // add header column
        csv = csv.join('\r\n');
        return csv;
    }
    else {
        return "E104";
    }
}

function GetKeihiData() {
    var kmodel = {
        CostCD: $('#CostCD').val(),
        CostName: $('#CostName').val(),
        CostDateFrom: $('#CostDate1').val(),
        CostDateTo: $('#CostDate2').val(),
        Year: $('#year').val(),
        BrandCD: $('#BrandCD').val(),
        BrandName: $('#BrandName').val(),
        //Season: $('#season').val(),
        ProjectCD: $('#projectCD').val(),
        ProjectName: $('#projectname').val(),
        HinbanCD: $('#PartCD').val(),
        HinbanName: $('#PartName').val(),
        flg: "list"
    };
    var selected = new Array();
    $("#Seasongp input[type=checkbox]:checked").each(function () {
        selected.push(this.value);
    });
    if (selected.length > 0)
        kmodel.Season = selected.join(",");

    return kmodel;
}