using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;
using Models;

namespace CommonBL
{
    public class Common_BL
    {
        string result;
        public string Date_Checking(string inputdate)
        {
            // return "[{\"result\":\"true\"}]";
            result = string.Empty;
            string strdate = string.Empty;
            if (!string.IsNullOrWhiteSpace(inputdate))
            {
                if (IsInteger(inputdate.Replace("/", "").Replace("-", "")))
                {
                    string day = string.Empty, month = string.Empty, year = string.Empty;
                    if (inputdate.Contains("/"))
                    {
                        string[] date = inputdate.Split('/');
                        day = date[date.Length - 1].PadLeft(2, '0');
                        month = date[date.Length - 2].PadLeft(2, '0');

                        if (date.Length > 2)
                            year = date[date.Length - 3];

                        inputdate = year + month + day;
                    }
                    else if (inputdate.Contains("-"))
                    {
                        string[] date = inputdate.Split('-');
                        day = date[date.Length - 1].PadLeft(2, '0');
                        month = date[date.Length - 2].PadLeft(2, '0');

                        if (date.Length > 2)
                            year = date[date.Length - 3];

                        inputdate = year + month + day;
                    }

                    string text = inputdate;
                    text = text.PadLeft(8, '0');
                    day = text.Substring(text.Length - 2);
                    month = text.Substring(text.Length - 4).Substring(0, 2);
                    year = Convert.ToInt32(text.Substring(0, text.Length - 4)).ToString();

                    if (month == "00")
                    {
                        month = string.Empty;
                    }
                    if (year == "0")
                    {
                        year = string.Empty;
                    }

                    if (string.IsNullOrWhiteSpace(month))
                        month = DateTime.Now.Month.ToString().PadLeft(2, '0');//if user doesn't input for month,set current month

                    if (string.IsNullOrWhiteSpace(year))
                    {
                        year = DateTime.Now.Year.ToString();//if user doesn't input for year,set current year
                    }
                    else
                    {
                        if (year.Length == 1)
                            year = "200" + year;
                        else if (year.Length == 2)
                            year = "20" + year;
                    }
                    strdate = year + "/" + month + "/" + day;
                    if (CheckDate(strdate))
                    {
                        result = "[{\"resultdate\" : \"" + strdate + "\", \"flg\" : \"true\"}]";   //"[{"result":"2020/01/01"}]";
                        return result;
                    }
                    else
                    {
                        result = "[{\"resultdate\" : \"" + strdate + "\", \"flg\" : \"false\"}]";
                        return result;
                        //mmodel = new MessageModel()
                        //{
                        //    MessageID = "E103"
                        //};
                        //errmsg = mbl.M_Message_Select(mmodel);
                        //return errmsg;
                    }
                }
                else
                {
                    result = "[{\"resultdate\" : \"" + strdate + "\", \"flg\" : \"false\"}]";
                    return result;
                    //mmodel = new MessageModel()
                    //{
                    //    MessageID = "E103"
                    //};
                    //errmsg = mbl.M_Message_Select(mmodel);
                    //return errmsg;
                }
            }
            else {
                result = "[{\"resultdate\" : \"" + strdate + "\", \"flg\" : \"true\"}]";
                return result;
            }
        }

        //public string YearMonth_Checking(string inputym)
        //{
        //    result = string.Empty;
        //    if (!string.IsNullOrWhiteSpace(inputym))
        //    {
        //        string yr = string.Empty, mth = string.Empty;
        //        if (inputym.Contains("/"))
        //        {
        //        }
        //    }
        //}

        public bool IsInteger(string value)
        {
            value = value.Replace("-", "");
            if (Int64.TryParse(value, out Int64 Num))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool CheckDate(string value)
        {
            return DateTime.TryParseExact(value,
                       "yyyy/MM/dd",
                       System.Globalization.CultureInfo.InvariantCulture,
                       DateTimeStyles.None,
                       out DateTime d);
        }
    }
}
