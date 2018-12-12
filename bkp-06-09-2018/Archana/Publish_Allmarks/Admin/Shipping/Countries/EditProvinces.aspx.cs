using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using System.Collections.Generic;
using CommerceBuilder.Shipping;
using System.Web.Services;

namespace AbleCommerce.Admin.Shipping.Countries
{
    public partial class EditProvinces : CommerceBuilder.UI.AbleCommerceAdminPage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            string countryCode = Request.QueryString["CountryCode"];
            if (!Page.IsPostBack)
            {
                Country country = CountryDataSource.Load(countryCode);
                if (country != null) Caption.Text = string.Format(Caption.Text, country.Name);
            }
            AddProvinceDialog1.ItemAdded += new EventHandler(AddProvinceDialog1_ItemAdded);
            ScriptManager.RegisterClientScriptBlock(Page, typeof(Page), "provinceCountryCode", "var countryCode = '" + countryCode + "';", true);
        }

        void AddProvinceDialog1_ItemAdded(object sender, EventArgs e)
        {
            ProvinceGrid.DataBind();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            gridFooter.Visible = ProvinceGrid.Rows.Count > 0;
        }

        [WebMethod()]
        public static bool DeleteProvinces(int[] provinceIds)
        {
            List<string> ids = new List<string>();
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            foreach (int cid in provinceIds)
            {
                ProvinceDataSource.Delete(cid);
            }
            database.CommitTransaction();
            return true;
        }

        [WebMethod()]
        public static bool DeleteAllProvinces(string countryCode)
        {
            Country country = CountryDataSource.Load(countryCode);
            if (country != null)
            {
                IDatabaseSessionManager database = AbleContext.Current.Database;
                database.BeginTransaction();
                country.Provinces.DeleteAll();
                database.CommitTransaction();
                return true;
            }
            else return false;
        }

    }
}
