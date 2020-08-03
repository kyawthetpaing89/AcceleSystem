using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;
using MessageBL;
using Models;

namespace CommonBL
{
    public class Common_BL
    {
        public string Date_Checking(string inputdate)
        {
            string result = string.Empty;
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
                    string strdate = year + "/" + month + "/" + day;
                    if (CheckDate(strdate))
                    {
                        result = @"{'resultdate' : '" + strdate + "'}";
                        return result;
                    }
                    else
                    {
                        result = @"{'resultdate' : 'false'}";
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
                    result = @"{'resultdate' : 'false'}";
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
                result = @"{'resultdate' : 'true'}";
                return result;
            }
        }

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
