function ShowMessage(MessageID) {

    $.ajax({
        url: '@Url.Action("M_Message_Select", "api/MessageApi")',
        method: 'Post',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(Umodel),
        headers:
        {
            Authorization: 'Basic ' + btoa('Capital_MM' + ':' + 'CKM12345!')
        },
        success: function (data) {
            var userdata = JSON.parse(data);
            $("#UserID").val(userdata[0].ID);
            $("#UserName").val(userdata[0].UserName);
            $("#Password").val(userdata[0].Password);
        }
    });


    Swal.fire({
        icon: message[0].status,
        title: message[0].MessageID,
        text: message[0].MessageText1,
        }).then(function () {
        return "true";
    });
    
}