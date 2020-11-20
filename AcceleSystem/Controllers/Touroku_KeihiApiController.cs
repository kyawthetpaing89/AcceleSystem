using System.Web.Http;
using Models;
using Touroku_KeihiBL;

namespace AcceleSystem.Controllers
{
    public class Touroku_KeihiApiController : ApiController
    {
        // GET: Touroku_KeihiApi
        public string M_Keihi_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_Keihi_ExistsCheck(kgmodel);
        }

        public string M_Cost_Select_List([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.D_Cost_Select_List(kgmodel);
        }

        public string M_Brand_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_Brand_ExistsCheck(kgmodel);
        }

        public string M_Project_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_Project_ExistsCheck(kgmodel);
        }

        public string M_HinBan_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_HinBan_ExistsCheck(kgmodel);
        }

        public string D_Cost_Edit_List([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.D_Cost_Edit_List(kgmodel);
        }

        public string M_Casting_ExistsCheck([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.M_Casting_ExistsCheck(kgmodel);
        }

        //public string M_Control_FiscalCheck([FromBody] BaseModel BModel) //Move to CommonApi
        //{
        //    Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
        //    return kgbl.M_Control_FiscalCheck(BModel);
        //}

        public string D_Cost_CUD([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.D_Cost_CUD(kgmodel);
        }

        public string D_Cost_TKeihiCSV([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.D_Cost_TKeihiCSV(kgmodel);
        }

        public string Fnc_TAXCalculation([FromBody] Touroku_KeihiModel kgmodel)
        {
            Touroku_Keihi_BL kgbl = new Touroku_Keihi_BL();
            return kgbl.Fnc_TAXCalculation(kgmodel);
        }
    }
}