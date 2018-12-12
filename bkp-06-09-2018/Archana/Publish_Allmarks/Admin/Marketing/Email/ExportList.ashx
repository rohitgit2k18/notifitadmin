<%@ WebHandler Language="C#" Class="AbleCommerce.Admin.Marketing.Email.ExportList" %>

using System;
using System.Web;
using System.Text;
using System.Collections.Generic;
using CommerceBuilder.Marketing;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Marketing.Email
{
    public class ExportList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            int _EmailListId = AlwaysConvert.ToInt(context.Request.QueryString["EmailListId"]);
            EmailList _EmailList = EmailListDataSource.Load(_EmailListId);
            int totalCount = EmailListUserDataSource.CountForEmailList(_EmailListId);
            if (totalCount > 0)
            {
                StringBuilder userData = new StringBuilder();
                userData.Append("Email,FirstName,LastName,Company,Address1,Address2,City,StateProvince,PostalCode,Country,Phone,Fax\r\n");
                
                int maxRecordsToCache = 500;
                for (int index = 0; index < totalCount; index += maxRecordsToCache)
                {
                    IList<EmailListUser> listUsers = EmailListUserDataSource.LoadForEmailList(_EmailListId, maxRecordsToCache, index, string.Empty);

                    foreach (EmailListUser elu in listUsers)
                    {
                        Address address = null;
                        User user = UserDataSource.LoadMostRecentForEmail(elu.Email);
                        if (user != null) address = user.PrimaryAddress;
                        if (address == null) address = new Address();
                        userData.Append(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}\r\n", elu.Email,
                            address.FirstName, address.LastName, address.Company, address.Address1, address.Address2,
                            address.City, address.Province, address.PostalCode, address.Country == null ? "" : address.Country.Name, address.Phone, address.Fax));
                    }
                }
                string outFileName = "users_list.csv";
                AbleCommerce.Code.PageHelper.SendFileDataToClient(userData.ToString(), outFileName);
            }
        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }

    }
}