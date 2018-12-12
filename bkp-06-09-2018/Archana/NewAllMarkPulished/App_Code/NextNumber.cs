using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;

namespace Redi.Utility
{
    public class NextNumber
    {
        /// <summary>
        /// Get the next available number from the NextNumber table and prefix with the prefix defined on the same table.
        /// </summary>
        /// <param name="NextNumberType"></param>
        /// <returns></returns>
        public static string GetNextID(string NextNumberType)
        {
            return GetNextID(NextNumberType, 0);

        }

        /// <summary>
        /// Get the next available number from the NextNumber table and prefix with the prefix defined on the same table.
        /// </summary>
        /// <param name="NextNumberType"></param>
        /// <returns></returns>
        public static string GetNextID(string NextNumberType, Int16 NumberLength)
        {
            string wkIDPrefix = "";
            using (SqlText SelectID = new SqlText(
                "Select IDPrefix " +
                "from [ALL_NextNumber] " +
                "Where NextNumberType = @NextNumberType; ", CrmHelper.crmConnectionStringName))
            {
                SelectID.AddParameter("@NextNumberType", NextNumberType);

                wkIDPrefix = SelectID.ExecuteScalar().ToString();
            }

            return GetNextID(wkIDPrefix, NextNumberType, NumberLength);

        }

        /// <summary>
        /// Get the next available number from the NextNumber table and prefix with the prefix defined on the same table.
        /// </summary>
        /// <param name="NextNumberType"></param>
        /// <returns></returns>
        public static string GetNextID(string prefix, string NextNumberType, Int16 NumberLength)
        {
            Int64 wkNextNumber = GetNextNumber(NextNumberType);
            
            string wkNum = "";

            switch (NumberLength)
            {
                case 0: wkNum = wkNextNumber.ToString();
                    break;
                case 7: wkNum = wkNextNumber.ToString("0000000");
                    break;
                case 6: wkNum = wkNextNumber.ToString("000000");
                    break;
                case 5: wkNum = wkNextNumber.ToString("00000");
                    break;
                case 4: wkNum = wkNextNumber.ToString("0000");
                    break;
                case 3: wkNum = wkNextNumber.ToString("000");
                    break;
                default: wkNum = wkNextNumber.ToString();
                    break;
            }

            return prefix + wkNum;

        }

        /// <summary>
        /// Get the next available number from the NextNumber table and prefix with the prefix defined on the same table and the year
        /// prefix-year-number
        /// </summary>
        /// <param name="NextNumberType"></param>
        /// <returns></returns>
        public static string GetNextYearID(string NextNumberType, Int16 NumberLength)
        {
            string wkIDPrefix = "";
            int wkCurrentYear = 0;
            Int64 wkNextNumber = GetNextNumber(NextNumberType);
            using (SqlText SelectID = new SqlText(
                           "Select IDPrefix, CurrentYear " +
                           "from [ALL_NextNumber] " +
                           "Where NextNumberType = @NextNumberType; ", CrmHelper.crmConnectionStringName))
            {
                SelectID.AddParameter("@NextNumberType", NextNumberType);
                DbDataReader myReader = SelectID.ExecuteReader();
                if (myReader.Read())
                {
                    wkIDPrefix = myReader.GetString(0);
                    if (!myReader.IsDBNull(1))
                        wkCurrentYear = myReader.GetInt32(1);
                }
            }

            if (wkCurrentYear != DateTime.Now.Year)
            {
                wkCurrentYear = DateTime.Now.Year;
                using (SqlText UpdateNext = new SqlText(
                            "Update [ALL_NextNumber] " +
                            "Set NextNumber = 1 " +
                            "   ,CurrentYear = @CurrentYear " +
                            "Where NextNumberType = @NextNumberType; ", CrmHelper.crmConnectionStringName))
                {
                    UpdateNext.AddParameter("@NextNumberType", NextNumberType);
                    UpdateNext.AddParameter("@CurrentYear", wkCurrentYear);
                    UpdateNext.ExecuteNonQuery();
                }
                wkNextNumber = 1;
            }

            string wkNum = "";

            if (wkNextNumber.ToString().Length > NumberLength)
                NumberLength = (Int16)wkNextNumber.ToString().Length;

            switch (NumberLength)
            {
                case 0: wkNum = wkNextNumber.ToString();
                    break;
                case 7: wkNum = wkNextNumber.ToString("0000000");
                    break;
                case 6: wkNum = wkNextNumber.ToString("000000");
                    break;
                case 5: wkNum = wkNextNumber.ToString("00000");
                    break;
                case 4: wkNum = wkNextNumber.ToString("0000");
                    break;
                case 3: wkNum = wkNextNumber.ToString("000");
                    break;
                default: wkNum = wkNextNumber.ToString();
                    break;
            }

            return wkIDPrefix + wkCurrentYear.ToString().Substring(2, 2) + "-" + wkNum;

        }

        /// <summary>
        /// Get the next available number from the NextNumber table.
        /// </summary>
        /// <param name="NextNumberType"></param>
        /// <returns></returns>
        public static Int64 GetNextNumber(string NextNumberType)
        {
            Int64 NextNumber = -1;
            using (SqlText UpdateNext = new SqlText(
                            "Update [ALL_NextNumber] " +
                            "Set NextNumber = NextNumber + 1 " +
                            "Where NextNumberType = @NextNumberType; " +
                            "Select NextNumber from [ALL_NextNumber] Where NextNumberType = @NextNumberType;", CrmHelper.crmConnectionStringName))
            {
                UpdateNext.AddParameter("@NextNumberType", NextNumberType);

                NextNumber = Convert.ToInt64(UpdateNext.ExecuteScalar());
            }

            return NextNumber;
        }
    }

}
