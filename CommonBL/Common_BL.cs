﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;
using System.Data;
using System.Data.SqlClient;
using Models;
using DL;


namespace CommonBL
{
    public class Common_BL
    {
        public string Date_Checking(string inputdate)
        {
           // return "[{\"result\":\"true\"}]";

            string result, strdate = string.Empty;
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

        public string YearMonth_Checking(string inputdate)
        {
            string result = string.Empty, strdate = string.Empty, date = string.Empty;
            if (inputdate.Contains("/"))
            {
                inputdate = inputdate.Replace("/", "");
            }              
            if(inputdate.Length == 1)
            {
                strdate = DateTime.Now.Year.ToString() + "/" + inputdate.PadLeft(2, '0');
                
            }
            else if (inputdate.Length == 2)
            {
              
                strdate = DateTime.Now.Year.ToString() + "/" + inputdate.PadLeft(2, '0');
                           
            }
            else if (inputdate.Length == 4)
            {
                var yr = inputdate.Substring(0, 4);
                var mn = DateTime.Now.Month.ToString().PadLeft(2,'0');
                strdate = yr + "/" + mn;
            }
            else if(inputdate.Length == 6 )
            {
                var yr = inputdate.Substring(0, 4).ToString();
                var mn = inputdate.Substring(inputdate.Length - 2, 2).ToString().PadLeft(2, '0').ToString();
                strdate = yr + "/" + mn;
            }
            else if (inputdate.Length == 5)
            {
                var yr = inputdate.Substring(0, 4);
                var mn = inputdate.Substring(inputdate.Length - 1, 1).PadLeft(2, '0');
                strdate = yr + "/" + mn;
            }

            date = strdate + "/" + "01";
            if (CheckDate(date))
            {
                result = "[{\"resultdate\" : \"" + strdate + "\", \"flg\" : \"true\"}]";   //"[{"result":"2020/01/01"}]";
                return result;
            }
            else
            {
                result = "[{\"resultdate\" : \"" + inputdate + "\", \"flg\" : \"false\"}]";
                return result;
            }
            //result = "[{\"resultdate\" : \"" + strdate + "\", \"flg\" : \"true\"}]";
            //return result;
             
        }

        public string Year_Checking(string inputdate)
        {
            string result = string.Empty, strdate = string.Empty, date = string.Empty;
            if (inputdate.Contains("/"))
            {
                inputdate = inputdate.Replace("/", "");
            }
            //if (inputdate.Length == 1)
            //{
            //    strdate = DateTime.Now.Year.ToString() + "/" + inputdate.PadLeft(2, '0');

            //}
            //else if (inputdate.Length == 2)
            //{

            //    strdate = DateTime.Now.Year.ToString() + "/" + inputdate.PadLeft(2, '0');

            //}
            if (inputdate.Length == 4)
            {
                //var yr = inputdate.Substring(0, 4);
                //var mn = DateTime.Now.Month.ToString().PadLeft(2, '0');
                //strdate = yr + "/" + mn;

                //else if (inputdate.Length == 6)
                //{
                //    var yr = inputdate.Substring(0, 4).ToString();
                //    var mn = inputdate.Substring(inputdate.Length - 2, 2).ToString().PadLeft(2, '0').ToString();
                //    strdate = yr + "/" + mn;
                //}
                //else if (inputdate.Length == 5)
                //{
                //    var yr = inputdate.Substring(0, 4);
                //    var mn = inputdate.Substring(inputdate.Length - 1, 1).PadLeft(2, '0');
                //    strdate = yr + "/" + mn;
                //}

                date = inputdate + "/01/01";
                if (CheckDate(date))
                {
                    result = "[{\"resultdate\" : \"" + inputdate + "\", \"flg\" : \"true\"}]";   //"[{"result":"2020/01/01"}]";
                    return result;
                }
                else
                {
                    result = "[{\"resultdate\" : \"" + inputdate + "\", \"flg\" : \"false\"}]";
                    return result;
                }
            }
            else
            {
                result = "[{\"resultdate\" : \"" + inputdate + "\", \"flg\" : \"false\"}]";
                return result;
            }
            //result = "[{\"resultdate\" : \"" + strdate + "\", \"flg\" : \"true\"}]";
            //return result;

        }

        public string DateComapre(string startdate, string enddate)
        {
            string ans = string.Empty;
            int result = startdate.CompareTo(enddate);
            if(result >= 0)
            {
                ans = "[{\"resultdate\" : \"" + enddate + "\", \"flg\" : \"false\"}]";
                return ans;
            }
            else
            {
                ans = "[{\"resultdate\" : \"" + enddate + "\", \"flg\" : \"true\"}]";
                return ans;
            }
        }

        public string LessthanZero_Checking(string input)
        {
            string result = string.Empty;
            if (!String.IsNullOrWhiteSpace(input))
            {
                int data = int.Parse(input);
                if (data <= 0)
                {
                    result = "[{\"resultdata\" : \"" + input + "\", \"flg\" : \"false\"}]";
                    return result;
                }
                else
                {
                    result = "[{\"resultdata\" : \"" + input + "\", \"flg\" : \"true\"}]";
                    return result;
                }
            }
            else
            {
                return result;
            }

        }

        public string DoubleByte_Checking(string input)
        {
            string result = string.Empty;
            if (!String.IsNullOrWhiteSpace(input))
            {
                if (ContainsUnicodeCharacter(input))
                {
                    result = "[{\"resultdata\" : \"" + input + "\", \"flg\" : \"false\"}]";
                    return result;
                }
                else
                {
                    result = "[{\"resultdata\" : \"" + input + "\", \"flg\" : \"true\"}]";
                    return result;
                }
            }
            return result;
        }

        public bool ContainsUnicodeCharacter(string input)
        {
            int MaxAnsiCode = 255;

            return input.Any(c => c > MaxAnsiCode);
        }

        public string M_Control_FiscalCheck(BaseModel BModel)
        {
            BaseDL bdl = new BaseDL();
            BModel.Sqlprms = new SqlParameter[1];
            BModel.Sqlprms[0] = new SqlParameter("@CastDate", SqlDbType.Date) { Value = BModel.inputdate };
            return bdl.SelectJson("M_Control_FiscalCheck", BModel.Sqlprms);
        }
    }
}
