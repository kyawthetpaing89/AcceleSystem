﻿function Search(type) {

    if ($('#divSearch').css('display') == 'block') {
        type = 9;
    }

    switch (type) {
        case 1://Brand
            LoadSearchForm(type, $("#BrandCD"), $("#BrandName"));
            break;
        case 9:
            LoadSearchForm(type, $("#BrandCD"), $("#BrandName"));
            break;
        case 2://user
            LoadSearchForm(type, $("#ProjectManager"), $("#ProjectManagerName"));
            break;
        case 3://hinban
            LoadSearchForm(type, $("#HinbanCD"), $("#HinbanName"), $("#proCD1"));
            break;
        case 4:
            LoadSearchForm(type, $("#CastingCD"), $("#CastingName"));
            break;
        case 5:
            LoadSearchForm(type, $("#KeihiCD"), $("#KeihiName"));
            break;
        case 6:
            LoadSearchForm(type, $("#proCD"), $("#proName"));
            break;
        case 7://Casting
            LoadSearchForm(type, $("#HLCastingCD"), $("#HLCastingName"));
            break;
        case 8://KeihiSettie
            LoadSearchForm(type, $("#CostCD"), $("#costname"));
            break;
    }
}
