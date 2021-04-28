function Search(type) {
    switch (type) {
        case 1://Brand
            LoadSearchForm(type, $("#BrandCD"), $("#BrandName"));
            break;
        case 2://user
            LoadSearchForm(type, $("#ProjectManager"), $("#ProjectManagerName"));
            break;
        case 3://hinban
            LoadSearchForm(type, $("#HinbanCD"), $("#HinbanName"));
            break;
    }

    $("#divSearch").iziModal('open');
}
