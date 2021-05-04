function ProjectList_Load(){
    $("#divMainList #BrandCD").focus();
    DoubleByteCheck($("#divMainList #BrandCD"), $("#divMainList #BrandCD").data('doublebytecheck-url'));
    ExistsCheck($("#divMainList #BrandCD"), "Brand", $("#divMainList #BrandCD").data('existcheck-url'), "BrandName");

    //@* YearCheck($("#Year"), '@Url.Action("YearMonth_Checking", "api/CommonApi")');*@
    DoubleByteCheck($("#divMainList #Year"), $("#divMainList #BrandCD").data('doublebytecheck-url'));
    YearCheck($("#divMainList #Year"), $("#divMainList #Year").data('yearcheck-url'));

    DoubleByteCheck($("#divMainList #ProjectCD"), $("#divMainList #BrandCD").data('doublebytecheck-url'));
    ExistsCheck($("#divMainList #ProjectCD"), "Project", $("#divMainList #ProjectCD").data('existcheck-url'), "ProjectName");

    YearMonthCheck($("#divMainList #PeriodStart"), $("#divMainList #PeriodStart").data('yearmonthcheck-url'));
    YearMonthCheck($("#divMainList #PeriodEnd"), $("#divMainList #PeriodStart").data('yearmonthcheck-url'));

    DoubleByteCheck($("#divMainList #ProjectManager"), $("#divMainList #BrandCD").data('doublebytecheck-url'));
    ExistsCheck($("#divMainList #ProjectManager"), "User", $("#divMainList #ProjectManager").data('existcheck-url'), "ProjectManagerName");
}

function CheckboxCheck(result) {
    if (result == 'OK') {
        var degreeyear = $("#Degreeyear").is(":checked");
        var ss = $("#divMainList #SS").is(":checked");
        var fw = $("#divMainList #FW").is(":checked");
        if (!degreeyear && !ss && !fw) {
            $("#divMainList #FW").focus();
            ShowErrorMessage("E111");
        }
    }
}

//Date Error check at Enter click
function DateCompare(result) {
    if (result == 'OK') {
        if (!($('#divMainList #PeriodStart').val().trim() == '' || $('#divMainList #PeriodEnd').val().trim() == '')) {
            var model = {
                startDate: $("#divMainList #PeriodStart").val(),
                endDate: $("#PeriodEnd").val()
            };
            if (model.startDate <= model.endDate) {
                $("#divMainList #ProjectManager").focus();
            }
            else {
                $("#divMainList #PeriodEnd").focus();
                ShowErrorMessage("E112");
            }
        }
    }
}

//Date Error check before insert/update
function DateCompareOnSave() {
    if (!($('#divMainList #PeriodStart').val().trim() == '' || $('#divMainList #PeriodEnd').val().trim() == '')) {
        var model = {
            startDate: $("#divMainList #PeriodStart").val(),
            endDate: $("#divMainList #PeriodEnd").val()
        };
        if (model.startDate <= model.endDate) {
            return "0";
        }
        else {
            return "E112";
        }
    }
    else return "0";
}

function btnProjectSearchClick() {
    var degreeyear = $("#divMainList #Degreeyear").is(":checked");
    var ss = $("#divMainList #SS").is(":checked");
    var fw = $("#divMainList #FW").is(":checked");
    if (!degreeyear && !ss && !fw) {
        $("#divMainList #FW").focus();
        var data = ShowErrorMessage("E111");
        return data;
    }
    else {
        var res = ErrorCheckOnSave('divMainList');
        if (res == "0") {
            var res1 = DateCompareOnSave();
            if (res1 == "0") {
                GetProject()
            }
            else {
                $("#divMainList #PeriodEnd").focus();
                ShowErrorMessage(res1);
            }
        }
        else {
            ShowErrorMessage(res);
        }
    }

}

function GetProject() {
    var Tmodel = {
        BrandCD: $('#divMainList #BrandCD').val(),
        BrandName: $('#divMainList #BrandName').val(),
        Year: $('#divMainList #Year').val(),
        ProjectCD: $('#divMainList #ProjectCD').val(),
        ProjectName: $('#divMainList #ProjectName').val(),
        PeriodStart: $('#divMainList #PeriodStart').val(),
        PeriodEnd: $('#divMainList #PeriodEnd').val(),
        ProjectManager: $('#divMainList #ProjectManager').val(),
        ProjectManagerName: $('#divMainList #ProjectManagerName').val(),
    };

    var selected = new Array();
    $("#divMainList #Seasongp input[type=checkbox]:checked").each(function () {
        selected.push(this.value);
    });
    if (selected.length > 0)
        Tmodel.Season = selected.join(",");

    var response = CalltoApiController($("#divMainList #ProjectCD").data('projectselect-url'), Tmodel);
    if (response == "[]") {
        BindProjectTable(response);
        var data = ShowErrorMessage("E104");
        return data;
    }
    else {
        BindProjectTable(response);
    }
}

function BindProjectTable(response) {
    table = $('#tblProject').DataTable({

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
                    if ($("#ProjectType").val() == "1") {
                        return '<table class="col-md-12">' +
                            '<tr><td style="width: 46%; max-width: 46%;"><p class="text-price">' + data.BrandCD + '  ' + data.BrandName + '</p></td><td style="width: 22%; max-width: 22%;text-align:center;">' + data.Season + '</td><td style = "width: 22%; max-width: 22%;text-align:center;" > ' + data.Year + '</td> <td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnEditClick(\'' + data.BrandCD + '\',\'' + data.ProjectCD + '\')" style="color:blue">編集</a></label></td></tr> ' +
                            '<tr><td colspan=3><span class="fixed-project">' + data.ProjectCD + ' ' + data.ProjectName + '</span></td><td style="text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnDelClick(\'' + data.BrandCD + '\',\'' + data.ProjectCD + '\')" style="color:red">削除</a></label></td></tr>' +
                            '<tr><td class="text-price">' + data.PeriodStart + '</td><td style="text-align: right; padding-right: 5%;">' + data.Production + '</td><td style="text-align: right; padding-right: 5%;">' + data.SalesPrice + '</td><td style="text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnCopyClick(\'' + data.BrandCD + '\',\'' + data.ProjectCD + '\')" style="color:green">複写</a></label></td></tr>' +

                            '</table > ';
                    }
                    else {
                        return '<table class="col-md-12">' +
                            '<tr><td style="width: 46%; max-width: 46%;"><p class="text-price">' + data.BrandCD + '  ' + data.BrandName + '</p></td><td style="width: 22%; max-width: 22%;text-align:center;">' + data.Season + '</td><td style = "width: 22%; max-width: 22%;text-align:center;" > ' + data.Year + '</td> <td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"><label><a onClick="ReturnSelected(\'' + data.ProjectCD + '\',\'' + data.ProjectName + '\')" style="color:blue">選択</a></label></td></tr> ' +
                            '<tr><td colspan=3><span class="fixed-project">' + data.ProjectCD + ' ' + data.ProjectName + '</span></td><td style="text-align: center; white-space: nowrap;"></td></tr>' +
                            '<tr><td class="text-price">' + data.PeriodStart + '</td><td style="text-align: right; padding-right: 5%;">' + data.Production + '</td><td style="text-align: right; padding-right: 5%;">' + data.SalesPrice + '</td><td style="text-align: center; white-space: nowrap;"></td></tr>' +

                            '</table > ';
                    }

                   

                    //    return '<table class="col-md-12"><tr><td style="width: 50%; max-width: 50%;"><p class="text-price">' + data.BrandCD + '  ' + data.BrandName + '</p></td><td class="text-center" style="width: 22%; max-width: 22%;">' + data.Season + '</td><td class="text-center" style="width: 22%; max-width: 22%;">' + data.Year + '</td><td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnEditClick(\'' + data.BrandCD + '\',\'' + data.ProjectCD + '\')" style="color:blue">編集</a></label></td></tr>' +
                    //        '<tr><td colspan=3><span class="fixed-project">' + data.ProjectCD + ' ' + data.ProjectName + '</span></td><td style="text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnDelClick(\'' + data.BrandCD + '\',\'' + data.ProjectCD + '\')" style="color:red">削除</a></label></td></tr>' +
                    //        '<tr><td class="text-price" style="width: 210px;">' + data.PeriodStart + '</td><td style="text-align: right; padding-right: 5%;">' + data.Production + '</td><td style="text-align: right; padding-right: 5%;">' + data.SalesPrice + '</td><td style="text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnCopyClick(\'' + data.BrandCD + '\',\'' + data.ProjectCD + '\')" style="color:green">複写</a></label></td></tr></table>'
                }
            },
        ]
    });

}

function btnProjectCSVClick() {
    var degreeyear = $("#divMainList #Degreeyear").is(":checked");
    var ss = $("#divMainList #SS").is(":checked");
    var fw = $("#divMainList #FW").is(":checked");
    if (!degreeyear && !ss && !fw) {
        $("#divMainList #FW").focus();
        var data = ShowErrorMessage("E111");
        return data;
    }
    else {
        var res = ErrorCheckOnSave();
        if (res == "0") {
            var res1 = DateCompareOnSave();
            if (res1 == "0") {
                var Tmodel = {
                    BrandCD: $('#divMainList #BrandCD').val(),
                    BrandName: $('#divMainList #BrandName').val(),
                    Year: $('#divMainList #Year').val(),
                    ProjectCD: $('#divMainList #ProjectCD').val(),
                    ProjectName: $('#divMainList #ProjectName').val(),
                    PeriodStart: $('#divMainList #PeriodStart').val(),
                    PeriodEnd: $('#divMainList #PeriodEnd').val(),
                    ProjectManager: $('#divMainList #ProjectManager').val(),
                    ProjectManagerName: $('#divMainList #ProjectManagerName').val(),
                };

                var selected = new Array();
                $("#divMainList #Seasongp input[type=checkbox]:checked").each(function () {
                    selected.push(this.value);
                });
                if (selected.length > 0)
                    Tmodel.Season = selected.join(",");

                var data = CalltoApiController($("#divMainList #ProjectCD").data('projectcsv-url'), Tmodel);

                var csv = JSON2CSV(data);
                if (!(csv == "E104")) {
                    var downloadLink = document.createElement("a");
                    var blob = new Blob(["\ufeff", csv]);
                    var url = URL.createObjectURL(blob);
                    downloadLink.href = url;
                    downloadLink.download = "プロジェクト登録.csv";

                    document.body.appendChild(downloadLink);
                    downloadLink.click();
                    document.body.removeChild(downloadLink);
                }
            }
            else {
                $("#divMainList #PeriodEnd").focus();
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
        var fields = Object.keys(array[0])
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