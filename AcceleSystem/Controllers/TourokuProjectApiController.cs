using System.Web.Http;
using System.Web.Http.Results;
using Models;
using TourokuProjectBL;

namespace AcceleSystem.Controllers
{
    public class TourokuProjectApiController : ApiController
    {
        [UserAuthentication]
        [HttpPost]
        public string M_Project_Select_List([FromBody] TourokuProjectModel Tmodel)
        {
            if (Tmodel == null)
            {
                Tmodel = new TourokuProjectModel();
            }
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_Project_Select_List(Tmodel);
        }
        [UserAuthentication]
        [HttpPost]
        public string M_Project_Select_Entry([FromBody] TourokuProjectModel Tmodel)
        {
            if (Tmodel == null)
            {
                Tmodel = new TourokuProjectModel();
            }
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_Project_Select_Entry(Tmodel);
        }
        [UserAuthentication]
        [HttpPost]
        public string Project_CUD([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.Project_CUD(Tmodel);
        }
        public string M_Casting_ExistsCheck([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_Casting_ExistsCheck(Tmodel);
        }

        public string M_Project_ExistsCheck([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_Project_ExistsCheck(Tmodel);
        }

        public string M_Hinban_ProjectExistCheck([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_Hinban_ProjectExistCheck(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string Hinban_CUD([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.Hinban_CUD(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_Hinban_DCost_Check([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_HinBan_DCost_Check(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_Hinban_D_Delivery_Check([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_HinBan_D_Delivery_Check(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_HinBan_Check_List([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_Hinban_Check_List(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_HinBan_Select_List([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_HinBan_Select_List(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_HinBan_Select_Edit([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_HinBan_Select_Edit(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_HinBan_Search_List([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_HinBan_Search_List(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string M_HinBan_ExistsCheck([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL Tpbl = new TourokuProject_BL();
            return Tpbl.M_HinBan_ExistsCheck(Tmodel);
        }

        [UserAuthentication]
        [HttpPost]
        public string Production_LessthanCheck([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL tbl = new TourokuProject_BL();
            return tbl.LessthanZero_Checking(Tmodel.Production);

        }

        [UserAuthentication]
        [HttpPost]
        public string SalePrice_LessthanCheck([FromBody] TourokuProjectModel Tmodel)
        {
            TourokuProject_BL tbl = new TourokuProject_BL();
            return tbl.LessthanZero_Checking(Tmodel.SalePrice);

        }
    }
}