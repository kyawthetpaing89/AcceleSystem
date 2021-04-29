function HinbanList_Load() {
    $("#HinbanType").val("1");
    $("#proCD").focus();

    $("#proName").attr('disabled', 'disabled');
    $("#HLyear").attr('disabled', 'disabled');
    $("#HLseason").attr('disabled', 'disabled');
    $("#HLBrandCD").attr('disabled', 'disabled');
    $("#HLBrandName").attr('disabled', 'disabled');
    $("#HLStartDate").attr('disabled', 'disabled');
    $("#HLEndDate").attr('disabled', 'disabled');
    $("#tpNo").attr('disabled', 'disabled');
    $("#tAmount").attr('disabled', 'disabled');
    $("#HLCastingName").attr('disabled', 'disabled');

    //RequiredCheck($("#proCD"));

    ExistsCheck($("#proCD"), "Project", $("#proCD").data('existcheck-url'), "proName");
    DoubleByteCheck($("#HLHinbanCD"), $("#HLHinbanCD").data('doublebytecheck-url'));

    ExistsCheck($("#HLCastingCD"), "Casting", $("#HLCastingCD").data('existcheck-url'), "CastingName");
    DoubleByteCheck($("#HLCastingCD"), $("#HLHinbanCD").data('doublebytecheck-url'));
    //GetHinban();
}

function GetHinban() {
    var Tmodel = {
        ProjectCD: $('#proCD').val(),
        ProjectName: $('#proName').val(),
        HinbanCD: $('#HLHinbanCD').val(),
        HinbanName: $('#HLHinbanName').val(),
        CastingCD: $('#HLCastingCD').val(),
        StartPrice: $('#StartPrice').val(),
        EndPrice: $('#EndPrice').val(),
    };

    var selected = new Array();
    $("#CompleteYMgp input[type=checkbox]:checked").each(function () {
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
        var deliveryleft = $('#deliveryleft').is(':checked');
        var payment = $('#payment').is(':checked')
        if (!deliveryleft && !payment) {
            $('#payment').focus();
            var data = ShowErrorMessage("E111");
        }
    }
}

function ProjectCDCheck(result) {
    if (result == 'OK') {
        Check();
        ExistsCheck($("#HLHinbanCD"), "Hinban", $("#HLHinbanCD").data('existcheck-url') , "HinbanName", $("#proCD").val());
    }
}

function Check() {
    if ($("#proCD").val()) {
        var Tmodel = {
            ProjectCD: $('#proCD').val(),
            //HinbanCD: $('#HinbanCD').val(),
        };
        var data = CalltoApiController($("#HLHinbanCD").data('checklist-url'), Tmodel);
        var hbdata = JSON.parse(data);
        $("#proCD").val(hbdata[0].ProjectCD);
        $("#proName").val(hbdata[0].ProjectName);
        $("#HLyear").val(hbdata[0].Year);
        $("#HLseason").val(hbdata[0].Season);
        $("#HLBrandCD").val(hbdata[0].BrandCD);
        $("#HLBrandName").val(hbdata[0].BrandName);
        $("#HLStartDate").val(hbdata[0].PeriodStart);
        $("#HLEndDate").val(hbdata[0].PeriodEnd);
        $("#tpNo").val(hbdata[0].TotalProduction);
        $("#tAmount").val(hbdata[0].TotalSP);
    }
    else {
        $("#proCD").val('');
        $("#proName").val('');
        $("#HLyear").val('');
        $("#HLseason").val('');
        $("#HLBrandCD").val('');
        $("#HLBrandName").val('');
        $("#HLStartDate").val('');
        $("#HLEndDate").val('');
        $("#tpNo").val('');
        $("#tAmount").val('');
    }
}

function CheckPrice(result) {
    if (result == 'OK') {
        if (!($('#StartPrice').val().trim() == '' || $('#EndPrice').val().trim() == '')) {
            var Tmodel = {
                StartPrice: $('#StartPrice').val(),
                EndPrice: $('#EndPrice').val(),
            };
            //@*var data = CalltoApiController('@Url.Action("M_Hinban_Price_Check", "api/TourokuProjectApi")', Tmodel);
            //var SalePriceData = JSON.parse(data);
            //if (SalePriceData[0].flg == "false") {*@
            if (Tmodel.StartPrice <= Tmodel.EndPrice) {
                $("#HLCastingCD").focus();

                //var data = ShowErrorMessage("E124");
                //StartPrice: $('#StartPrice').val("");
                //EndPrice: $('#EndPrice').val("");
                ////$("#StartPrice").focus();
                //return data;
            }
            else {
                $("#EndPrice").focus();
                ShowErrorMessage("E124");
            }
        }
    }
}

function CheckPriceOnSearch() {
    if (!($('#StartPrice').val().trim() == '' || $('#EndPrice').val().trim() == '')) {
        var Tmodel = {
            StartPrice: $('#StartPrice').val(),
            EndPrice: $('#EndPrice').val(),
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
    
    var deliveryleft = $('#deliveryleft').is(':checked');
    var payment = $('#payment').is(':checked')
    if (!deliveryleft && !payment) {
        $('#payment').focus();
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
                $("#EndPrice").focus();
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
        ProjectCD1: $('#proCD').val(),
        ProjectName: $('#proName').val(),
        Year: $('#HLyear').val(),
        BrandCD1: $('#HLBrandCD').val(),
        BrandName: $('#HLBrandName').val(),
        StartDate: $('#HLStartDate').val(),
        EndDate: $('#HLEndDate').val(),
        Production: $('#tpNo').val(),
        TotalAmount: $('#tAmount').val(),
        HinbanCD1: $('#HLHinbanCD').val(),
        HinbanName: $('#HLHinbanName').val(),
        CastingCD: $('#HLCastingCD').val(),
        CastingName: $('#HLCastingName').val(),
        StartPrice: $('#StartPrice').val(),
        EndPrice: $('#EndPrice').val(),
        Season: $('#HLseason').val(),
        flg: "list"
    };

    var selected = new Array();
    $("#CompleteYMgp input[type=checkbox]:checked").each(function () {
        selected.push(this.value);
    });
    if (selected.length > 0)
        Tmodel.CompleteYM = selected.join(",");

    return Tmodel;
}

