function HinbanList_Load() {
    $("#HinbanType").val("1");
    $("#divMainList #proCD").focus();

    $("#divMainList #proName").attr('disabled', 'disabled');
    $("#divMainList #HLyear").attr('disabled', 'disabled');
    $("#divMainList #HLseason").attr('disabled', 'disabled');
    $("#divMainList #HLBrandCD").attr('disabled', 'disabled');
    $("#divMainList #HLBrandName").attr('disabled', 'disabled');
    $("#divMainList #HLStartDate").attr('disabled', 'disabled');
    $("#divMainList #HLEndDate").attr('disabled', 'disabled');
    $("#divMainList #tpNo").attr('disabled', 'disabled');
    $("#divMainList #tAmount").attr('disabled', 'disabled');
    $("#divMainList #HLCastingName").attr('disabled', 'disabled');

    //RequiredCheck($("#proCD"));

    ExistsCheck($("#divMainList #proCD"), "Project", $("#divMainList #proCD").data('existcheck-url'), "divMainList #proName");
    DoubleByteCheck($("#divMainList #HLHinbanCD"), $("#divMainList #HLHinbanCD").data('doublebytecheck-url'));

    ExistsCheck($("#divMainList #HLCastingCD"), "Casting", $("#divMainList #HLCastingCD").data('existcheck-url'), "divMainList #CastingName");
    DoubleByteCheck($("#divMainList #HLCastingCD"), $("#divMainList #HLHinbanCD").data('doublebytecheck-url'));
    //GetHinban();
}

function GetHinban() {
    var Tmodel = {
        ProjectCD: $('#divMainList #proCD').val(),
        ProjectName: $('#divMainList #proName').val(),
        HinbanCD: $('#divMainList #HLHinbanCD').val(),
        HinbanName: $('#divMainList #HLHinbanName').val(),
        CastingCD: $('#divMainList #HLCastingCD').val(),
        StartPrice: $('#divMainList #StartPrice').val(),
        EndPrice: $('#divMainList #EndPrice').val(),
    };

    var selected = new Array();
    $("#divMainList #CompleteYMgp input[type=checkbox]:checked").each(function () {
        selected.push(this.value);
    });
    if (selected.length > 0)
        Tmodel.CompleteYM = selected.join(",");

    var url = $("#tblHinban").data('request-url');
    var response = CalltoApiController(url, Tmodel);
    if (response == "[]") {
        var data = ShowErrorMessage("E104");
        return data;
    }
    BindHinbanTable(response);
}

function BindHinbanTable(response) {

    table = $('#tblHinban').DataTable({

        data: JSON.parse(response),
        "bFilter": false,
        "bLengthChange": false,
        "bInfo": false,
        "ordering": false,
        "pagingType": "simple_numbers",
        destroy: true,
        "columns": [
            {
                "data": null,
                className: "Border1",
                render: function (data, type, row) {
                    //return '<table class="col-md-12"><tr><td colspan=3 style="width: 85%;display: inline-block;" class="fixed-width"><span style="width: 80%;display: inline-block;" class="fixed-width">' + data.ProjectCD + '  ' + data.ProjectName + '</span></td><td style="width: 10%; text-align: center;"><label><a href="#" onClick="btnEditClick(\'' + data.ProjectCD + '\',\'' + data.HinbanCD + '\')" style="color:blue">編集</a></label></td></tr>' +
                    //    '<tr><td colspan=3 style="width: 85%;display: inline-block;" class="fixed-width"><span style="width: 100%;display: inline-block;" class="fixed-width">' + data.HinbanCD + '  ' + data.HinbanName + '</span></td><td style="text-align: center;"><label><a href="#" onClick="btnDelClick(\'' + data.ProjectCD + '\',\'' + data.HinbanCD + '\')" style="color:red">削除</a></label></td></tr>' +
                    //    '<tr><td style="width: 150px;display: inline-block;" class="fixed-width">' + data.Casting + '  ' + data.CastingName + '</td><td style="width: 20%" class="text-right">' + data.Production + '</td><td style="width: 20%" class="text-right">' + data.SalesPrice + '</td><td style="width: 20%" class="text-right">' + data.TotalSalesPrice + '</td><td style="text-align: center;"><label><a href="#" onClick="btnCopyClick(\'' + data.ProjectCD + '\',\'' + data.HinbanCD + '\')" style="color:green">複写</a></label></td></tr></table>';
                    if ($("#HinbanType").val() == "1") {
                        return '<table class="col-md-12">' +
                            '<tr> <td colspan=4><span class="fixed-hinban" > ' + data.ProjectCD + '  ' + data.ProjectName + '</span></td > <td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnEditClick(\'' + data.ProjectCD + '\',\'' + data.HinbanCD + '\')" style="color:blue">編集</a></label></td></tr > ' +
                            '<tr><td colspan=4><span class="fixed-hinban">' + data.HinbanCD + '  ' + data.HinbanName + '</span></td><td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnDelClick(\'' + data.ProjectCD + '\',\'' + data.HinbanCD + '\')" style="color:red">削除</a></label></td></tr>' +
                            '<tr><td style="width: 33%; max-width: 33%;"><span class="fixed-width">' + data.Casting + '  ' + data.CastingName + '</span></td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.Production + '</td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.SalesPrice + '</td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.TotalSalesPrice + '</td><td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"><label><a href="#" onClick="btnCopyClick(\'' + data.ProjectCD + '\',\'' + data.HinbanCD + '\')" style="color:green">複写</a></label></td></tr></table>';
                    }
                    else {
                        return '<table class="col-md-12">' +
                            '<tr> <td colspan=4><span class="fixed-hinban" > ' + data.ProjectCD + '  ' + data.ProjectName + '</span></td > <td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"></td></tr > ' +
                            '<tr><td colspan=4><span class="fixed-hinban">' + data.HinbanCD + '  ' + data.HinbanName + '</span></td><td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"></td></tr>' +
                            '<tr><td style="width: 33%; max-width: 33%;"><span class="fixed-width">' + data.Casting + '  ' + data.CastingName + '</span></td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.Production + '</td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.SalesPrice + '</td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.TotalSalesPrice + '</td><td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"><label><a href="#" onClick="ReturnSelected(\'' + data.HinbanCD + '\',\'' + data.HinbanName + '\')" style="color:blue">選択</a></label></td></tr></table>';
                    }
                    
                }
            },
        ]
    });
}

function CheckCheckbox(result) {
    if (result == 'OK') {
        var deliveryleft = $('#divMainList #deliveryleft').is(':checked');
        var payment = $('#divMainList #payment').is(':checked')
        if (!deliveryleft && !payment) {
            $('#divMainList #payment').focus();
            var data = ShowErrorMessage("E111");
        }
    }
}

function ProjectCDCheck(result) {
    if (result == 'OK') {
        Check();
        ExistsCheck($("#divMainList #HLHinbanCD"), "Hinban", $("#divMainList #HLHinbanCD").data('existcheck-url') , "HinbanName", $("#proCD").val());
    }
}

function Check() {
    if ($("#divMainList #proCD").val()) {
        var Tmodel = {
            ProjectCD: $('#divMainList #proCD').val(),
            //HinbanCD: $('#HinbanCD').val(),
        };
        var data = CalltoApiController($("#divMainList #HLHinbanCD").data('checklist-url'), Tmodel);
        var hbdata = JSON.parse(data);
        $("#divMainList #proCD").val(hbdata[0].ProjectCD);
        $("#divMainList #proName").val(hbdata[0].ProjectName);
        $("#divMainList #HLyear").val(hbdata[0].Year);
        $("#divMainList #HLseason").val(hbdata[0].Season);
        $("#divMainList #HLBrandCD").val(hbdata[0].BrandCD);
        $("#divMainList #HLBrandName").val(hbdata[0].BrandName);
        $("#divMainList #HLStartDate").val(hbdata[0].PeriodStart);
        $("#divMainList #HLEndDate").val(hbdata[0].PeriodEnd);
        $("#divMainList #tpNo").val(hbdata[0].TotalProduction);
        $("#divMainList #tAmount").val(hbdata[0].TotalSP);
    }
    else {
        $("#divMainList #proCD").val('');
        $("#divMainList #proName").val('');
        $("#divMainList #HLyear").val('');
        $("#divMainList #HLseason").val('');
        $("#divMainList #HLBrandCD").val('');
        $("#divMainList #HLBrandName").val('');
        $("#divMainList #HLStartDate").val('');
        $("#divMainList #HLEndDate").val('');
        $("#divMainList #tpNo").val('');
        $("#divMainList #tAmount").val('');
    }
}

function CheckPrice(result) {
    if (result == 'OK') {
        if (!($('#divMainList #StartPrice').val().trim() == '' || $('#divMainList #EndPrice').val().trim() == '')) {
            var Tmodel = {
                StartPrice: $('#divMainList #StartPrice').val(),
                EndPrice: $('#divMainList #EndPrice').val(),
            };
            //@*var data = CalltoApiController('@Url.Action("M_Hinban_Price_Check", "api/TourokuProjectApi")', Tmodel);
            //var SalePriceData = JSON.parse(data);
            //if (SalePriceData[0].flg == "false") {*@
            if (Tmodel.StartPrice <= Tmodel.EndPrice) {
                $("#divMainList #HLCastingCD").focus();

                //var data = ShowErrorMessage("E124");
                //StartPrice: $('#StartPrice').val("");
                //EndPrice: $('#EndPrice').val("");
                ////$("#StartPrice").focus();
                //return data;
            }
            else {
                $("#divMainList #EndPrice").focus();
                ShowErrorMessage("E124");
            }
        }
    }
}

function CheckPriceOnSearch() {
    if (!($('#divMainList #StartPrice').val().trim() == '' || $('#EndPrice').val().trim() == '')) {
        var Tmodel = {
            StartPrice: $('#divMainList #StartPrice').val(),
            EndPrice: $('#divMainList #EndPrice').val(),
        };
        //@*var data = CalltoApiController('@Url.Action("M_Hinban_Price_Check", "api/TourokuProjectApi")', Tmodel);
        //var SalePriceData = JSON.parse(data);
        //if (SalePriceData[0].flg == "false") {*@
        if (Tmodel.StartPrice <= Tmodel.EndPrice) {
            return "0";
        }
        else {
            return "E124";
        }
    }
    else return "0";
}

function HinbanSearch() {
    
    var deliveryleft = $('#divMainList #deliveryleft').is(':checked');
    var payment = $('#divMainList #payment').is(':checked')
    if (!deliveryleft && !payment) {
        $('#divMainList #payment').focus();
        var data = ShowErrorMessage("E111");
        return data;
    }
    else {
        var res = ErrorCheckOnSave('divMainList');
        if (res == "0") {
            var res1 = CheckPriceOnSearch();
            if (res1 == "0") {
                GetHinban();
            }
            else {
                $("#divMainList #EndPrice").focus();
                ShowErrorMessage(res1);
            }
        }
        else {
            ShowErrorMessage(res);
        }
    }
}

function GetHinbanData() {
    var Tmodel = {
        ProjectCD1: $('#divMainList #proCD').val(),
        ProjectName: $('#divMainList #proName').val(),
        Year: $('#divMainList #HLyear').val(),
        BrandCD1: $('#divMainList #HLBrandCD').val(),
        BrandName: $('#divMainList #HLBrandName').val(),
        StartDate: $('#divMainList #HLStartDate').val(),
        EndDate: $('#divMainList #HLEndDate').val(),
        Production: $('#divMainList #tpNo').val(),
        TotalAmount: $('#divMainList #tAmount').val(),
        HinbanCD1: $('#divMainList #HLHinbanCD').val(),
        HinbanName: $('#divMainList #HLHinbanName').val(),
        CastingCD: $('#divMainList #HLCastingCD').val(),
        CastingName: $('#divMainList #HLCastingName').val(),
        StartPrice: $('#divMainList #StartPrice').val(),
        EndPrice: $('#divMainList #EndPrice').val(),
        Season: $('#divMainList #HLseason').val(),
        flg: "list"
    };

    var selected = new Array();
    $("#divMainList #CompleteYMgp input[type=checkbox]:checked").each(function () {
        selected.push(this.value);
    });
    if (selected.length > 0)
        Tmodel.CompleteYM = selected.join(",");

    return Tmodel;
}

