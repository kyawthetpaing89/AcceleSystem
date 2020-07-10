using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;
using System;

namespace DL
{
    public class BaseDL
    {
        readonly ReadIni Rini = new ReadIni();
        public string conStr = string.Empty;

        public BaseDL()
        {
            conStr = Rini.GetConnectionString();
        }

        public string SelectJson(string sSQL, params SqlParameter[] para)
        {
            DataTable dt = new DataTable
            {
                TableName = "data"
            };
            var newCon = new SqlConnection(conStr);
            using (var adapt = new SqlDataAdapter(sSQL, newCon))
            {
                newCon.Open();
                adapt.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (para != null)
                    adapt.SelectCommand.Parameters.AddRange(para);
                adapt.Fill(dt);
                newCon.Close();
            }
            return DataTableToJSONWithJSONNet(dt);
        }

        public DataTable SelectDatatable(string sSQL, params SqlParameter[] para)
        {
            DataTable dt = new DataTable();
            var newCon = new SqlConnection(conStr);
            using (var adapt = new SqlDataAdapter(sSQL, newCon))
            {
                newCon.Open();
                adapt.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (para != null)
                    adapt.SelectCommand.Parameters.AddRange(para);
                adapt.Fill(dt);
                newCon.Close();
            }
            return dt;
        }

        public DataSet SelectDataSet(string sSQL, params SqlParameter[] para)
        {
            DataSet ds = new DataSet();
            var newCon = new SqlConnection(conStr);
            using (var adapt = new SqlDataAdapter(sSQL, newCon))
            {
                newCon.Open();
                adapt.SelectCommand.CommandType = CommandType.StoredProcedure;
                if (para != null)
                    adapt.SelectCommand.Parameters.AddRange(para);
                adapt.Fill(ds);
                newCon.Close();
            }
            return ds;
        }

        public string InsertUpdateDeleteData(string sSQL, params SqlParameter[] para)
        {
            try
            {
                var newCon = new SqlConnection(conStr);
                SqlCommand cmd = new SqlCommand(sSQL, newCon)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.AddRange(para);
                cmd.Connection.Open();
                cmd.ExecuteNonQuery();
                cmd.Connection.Close();

                return "true";
            }
            catch (Exception)
            {
                return "false";
            }
        }

        public string DataTableToJSONWithJSONNet(DataTable table)
        {
            string JSONString = string.Empty;
            JSONString = JsonConvert.SerializeObject(table);
            return JSONString;
        }
    }
}
