﻿using DL;
using Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Koushin_GetsujiBL
{
    public class Koushin_Getsuji_BL
    {
        public string M_Contrl_YearMonth_ExitCheck(Koushin_GetsujiModel kgmodel)
        {
            BaseDL bdl = new BaseDL();
            kgmodel.Sqlprms = new SqlParameter[0];
            return bdl.SelectJson("M_Contrl_YearMonth_ExitCheck");
        }
    }
}
