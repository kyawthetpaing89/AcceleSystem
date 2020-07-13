function GetMessage(MessageID,url) {
    var Mmodel = {
        MessageID: MessageID,
    };
    return $.ajax({
        url: url,
        method: 'Post',
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(Mmodel),
        headers:
        {
            Authorization: 'Basic ' + btoa('Capital_MM' + ':' + 'CKM12345!')
        },
    });
}

