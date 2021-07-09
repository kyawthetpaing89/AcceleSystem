function HinbanSearch_Load() {
    //$("#divMainList #proName").removeAttr('disabled');
    //$("#divMainList #HLyear").removeAttr('disabled');
    //$("#divMainList #HLseason").removeAttr('disabled');
    //$("#divMainList #BrandCD").removeAttr('disabled');
    //$("#divMainList #BrandName").removeAttr('disabled');
    //$("#divMainList #HLStartDate").removeAttr('disabled');
    //$("#divMainList #HLEndDate").removeAttr('disabled');

   
    $("#divMainList #proName").removeAttr('placeholder');
    $("#divMainList #HLyear").removeAttr('placeholder');
    $("#divMainList #HLseason").removeAttr('placeholder');
    $("#divMainList #BrandCD").removeAttr('placeholder');
    $("#divMainList #BrandName").removeAttr('placeholder');
    $("#divMainList #HLStartDate").removeAttr('placeholder');
    $("#divMainList #HLEndDate").removeAttr('placeholder');
    $("#divMainList #HLHinbanName").removeAttr('placeholder');
    $("#divMainList #HLCastingCD").removeAttr('placeholder');
    $("#divMainList #HLCastingName").removeAttr('placeholder');
    $("#divMainList #HLStartPrice").removeAttr('placeholder');
    $("#divMainList #HLEndPrice").removeAttr('placeholder');

    DoubleByteCheck($("#divMainList #BrandCD"), $("#divMainList #BrandCD").data('doublebytecheck-url'));
    ExistsCheck($("#divMainList #BrandCD"), "Brand", $("#divMainList #BrandCD").data('existcheck-url'), "divMainList #BrandName");

    DoubleByteCheck($("#divMainList #HLCastingCD"), $("#divMainList #HLCastingCD").data('doublebytecheck-url'));
    ExistsCheck($("#divMainList #HLCastingCD"), "Casting", $("#divMainList #HLCastingCD").data('existcheck-url'), "divMainList #HLCastingName");
    
    YearMonthCheck($("#divMainList  #HLStartDate"), $("#divMainList #HLStartDate").data('yearmonthcheck-url'));
    YearMonthCheck($("#divMainList  #HLEndDate"), $("#divMainList #HLEndDate").data('yearmonthcheck-url'));

    YearCheck($("#divMainList #HLyear"), $("#divMainList #HLyear").data('yearcheck-url'));

    if ($("#divMain #proCD").val()) {
        $("#divMainList #HLHinbanCD").focus();
        var Tmodel = {
            ProjectCD: $('#divMain #proCD').val()
        };
        var data = CalltoApiController($("#divMainList #HLHinbanName").data('checklist-url'), Tmodel)
        if (!(data == "[]")) {
            var hbdata = JSON.parse(data);
            $("#divMainList #proName").val(hbdata[0].ProjectName);
            $("#divMainList #HLyear").val(hbdata[0].Year);
            $("#divMainList #HLseason").val(hbdata[0].Season);
            $("#divMainList #BrandCD").val(hbdata[0].BrandCD);
            $("#divMainList #BrandName").val(hbdata[0].BrandName);
            $("#divMainList #HLStartDate").val(hbdata[0].PeriodStart);
            $("#divMainList #HLEndDate").val(hbdata[0].PeriodEnd);
        }
    }
    else {
        //$("#divMainList #proCD").val('');
        $("#divMainList #proName").val('');
        $("#divMainList #HLyear").val('');
        $("#divMainList #HLseason").val('');
        $("#divMainList #BrandCD").val('');
        $("#divMainList #BrandName").val('');
        $("#divMainList #HLStartDate").val('');
        $("#divMainList #HLEndDate").val('');
    }
}

function GetHinban() {
    var Tmodel = {
        ProjectCD: $('#divMain #proCD').val(),
        ProjectName: $('#divMainList #proName').val(),
        Year: $('#divMainList #HLyear').val(),
        Season: $('#divMainList #HLseason').val(),
        BrandCD: $('#divMainList #BrandCD').val(),
        BrandName: $('#divMainList #BrandName').val(),
        PeriodStart: $('#divMainList #HLStartDate').val().toString().replace(/\//g, ''),
        PeriodEnd: $('#divMainList #HLEndDate').val().toString().replace(/\//g, ''),
        HinbanName: $('#divMainList #HLHinbanName').val(),
        CastingCD: $('#divMainList #HLCastingCD').val(),
        CastingName: $('#divMainList #HLCastingName').val(),
        StartPrice: $('#divMainList #HLStartPrice').val().toString().replace(/,/g, ""),
        EndPrice: $('#divMainList #HLEndPrice').val().toString().replace(/,/g, ""),
    };
    var selected1 = new Array();
    $("#divMainList #Seasongp input[type=checkbox]:checked").each(function () {
        selected1.push(this.value);
    });
    if (selected1.length > 0)
        Tmodel.Season = selected1.join(",");

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
                        return '<table class="col-md-12">' +
                            '<tr> <td colspan=4><span class="fixed-hinban" > ' + data.ProjectCD + '  ' + data.ProjectName + '</span></td > <td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"></td></tr > ' +
                            '<tr><td colspan=4><span class="fixed-hinban">' + data.HinbanCD + '  ' + data.HinbanName + '</span></td><td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"></td></tr>' +
                            '<tr><td style="width: 33%; max-width: 33%;"><span class="fixed-width">' + data.Casting + '  ' + data.CastingName + '</span></td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.Production + '</td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.SalesPrice + '</td><td style="text-align: center; width: 18%; max-width: 18%;">' + data.TotalSalesPrice + '</td><td style="width: 70px; max-width: 70px; text-align: center; white-space: nowrap;"><label><a href="#" onClick="ReturnSelected(\'' + data.HinbanCD + '\',\'' + data.HinbanName + '\',\'' + data.ProjectCD + '\')" style="color:blue">選択</a></label></td></tr></table>';
                }
            },
        ]
    });
}

//Complete Or Not Complete data flg
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

//Season 
function SeasonCheck(result) {
    if (result == 'OK') {
        var degreeyear = $("#divMainList #Degreeyear").is(":checked");
        var ss = $("#divMainList #chkSS").is(":checked");
        var fw = $("#divMainList #chkFW").is(":checked");
        if (!degreeyear && !ss && !fw) {
            $("#divMainList #chkFW").focus();
            ShowErrorMessage("E111");
        }
    }
}

//Date Error check at Enter 
function DateCompare(result) {
    if (result == 'OK') {
        if (!($('#divMainList #HLStartDate').val().trim() == '' || $('#divMainList #HLEndDate').val().trim() == '')) {
            var model = {
                startDate: $("#divMainList #HLStartDate").val().toString().replace(/\//g, ''),
                endDate: $("#divMainList #HLEndDate").val().toString().replace(/\//g, '')
            };
            if (model.startDate <= model.endDate) {
                $("#divMainList #HLHinbanName").focus();
            }
            else {
                $("#divMainList #HLEndDate").focus();
                ShowErrorMessage("E112");
            }
        }
    }
}

//Date Error check when search button click
function DateCompareSave() {
    if (!($('#divMainList #HLStartDate').val().trim() == '' || $('#divMainList #HLEndDate').val().trim() == '')) {
        var model = {
            startDate: $("#divMainList #HLStartDate").val().toString().replace(/\//g, ''),
            endDate: $("#divMainList #HLEndDate").val().toString().replace(/\//g, '')
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

//Compare Price Check at Enter
function CheckPrice(result) {
    if (result == 'OK') {
        if (!($('#divMainList #HLStartPrice').val().trim() == '' || $('#divMainList #HLEndPrice').val().trim() == '')) {
            var Tmodel = {
                StartPrice: $('#divMainList #HLStartPrice').val().toString().replace(/,/g, ""),
                EndPrice: $('#divMainList #HLEndPrice').val().toString().replace(/,/g, ""),
            };
            if (parseInt(Tmodel.StartPrice) < parseInt(  Tmodel.EndPrice)) {
                $("#divMainList #HLCastingCD").focus();
            }
            else {
                $("#divMainList #HLEndPrice").focus();
                ShowErrorMessage("E124");
            }
        }
    }
}

//Compare Price Check when search button click
function CheckPriceOnSearch() {
    if (!($('#divMainList #HLStartPrice').val().trim() == '' || $('#divMainList #HLEndPrice').val().trim() == '')) {
        var Tmodel = {
            StartPrice: $('#divMainList #HLStartPrice').val().toString().replace(/,/g, ""),
            EndPrice: $('#divMainList #HLEndPrice').val().toString().replace(/,/g, ""),
        };
        if (parseInt(Tmodel.StartPrice) < parseInt(Tmodel.EndPrice)) {
            return "0";
        }
        else {
            return "E124";
        }
    }
    else return "0";
}

function HinbanSearch() {
    var allyear = $("#divMainList #Degreeyear").is(":checked");
    var ss = $("#divMainList #chkSS").is(":checked");
    var fw = $("#divMainList #chkFW").is(":checked");
    if (!allyear && !ss && !fw) {
        $("#divMainList #chkFW").focus();
        var data = ShowErrorMessage("E111");
        return data;
    }
    else {
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
                var res2 = DateCompareSave();
                if (res2 == "0") {
                    var res1 = CheckPriceOnSearch();
                    if (res1 == "0") {
                        GetHinban();
                    }
                    else {
                        $("#divMainList #HLEndPrice").focus();
                        ShowErrorMessage(res1);
                    }
                }
                else {
                    $("#divMainList #HLEndDate").focus();
                    ShowErrorMessage(res2);
                }
            }
            else {
                ShowErrorMessage(res);
            }
        }
    }
}


function Check() {
    ExistsCheck($("#divMainList #HLHinbanCD"), "Hinban", $("#divMainList #HLHinbanCD").data('existcheck-url'), "HLHinbanName", $("#proCD").val());

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
        $("#divMainList #BrandCD").val(hbdata[0].BrandCD);
        $("#divMainList #BrandName").val(hbdata[0].BrandName);
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
        $("#divMainList #BrandCD").val('');
        $("#divMainList #BrandName").val('');
        $("#divMainList #HLStartDate").val('');
        $("#divMainList #HLEndDate").val('');
        $("#divMainList #tpNo").val('');
        $("#divMainList #tAmount").val('');
    }
}

function KeyUp(e, ctrl) {
    if (e.which >= 37 && e.which <= 40) event.preventDefault();

    // format number
    $(ctrl).val(function (index, value) {
        return value
            .replace(/\D/g, "")
            .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
            ;
    });
}

function GetHinbanData() {
    var Tmodel = {
        ProjectName: $('#divMainList #proName').val(),
        Year: $('#divMainList #HLyear').val(),
        BrandCD1: $('#divMainList #BrandCD').val(),
        BrandName: $('#divMainList #BrandName').val(),
        StartDate: $('#divMainList #HLStartDate').val(),
        EndDate: $('#divMainList #HLEndDate').val(),
        Production: $('#divMainList #tpNo').val(),
        TotalAmount: $('#divMainList #tAmount').val(),
        HinbanCD1: $('#divMainList #HLHinbanCD').val(),
        HinbanName: $('#divMainList #HLHinbanName').val(),
        CastingCD: $('#divMainList #HLCastingCD').val(),
        CastingName: $('#divMainList #HLCastingName').val(),
        StartPrice: $('#divMainList #HLStartPrice').val(),
        EndPrice: $('#divMainList #HLEndPrice').val(),
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

