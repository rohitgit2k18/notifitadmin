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
public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
{

    
    protected void CountryGrid_RowEditing(object sender, GridViewEditEventArgs e)
    {
        string countryCode = CountryGrid.DataKeys[e.NewEditIndex].Value.ToString();
        Country country = CountryDataSource.Load(countryCode);
        if (country != null)
        {
            AddCountryDialog1.Visible = false;
            EditCountryDialog1.Visible = true;
            EditCountryDialog1.LoadDialog(countryCode);
        }
    }

    protected void CountryGrid_RowCancelingEdit(object sender, EventArgs e)
    {
        AddCountryDialog1.Visible = true;
        EditCountryDialog1.Visible = false;
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        AddCountryDialog1.ItemAdded += new EventHandler(AddCountryDialog1_ItemAdded);

        AlphabetRepeater.DataSource = GetAlphabetDS();
        AlphabetRepeater.DataBind();

        string alphabet = Request.QueryString["c"];
        if (string.IsNullOrEmpty(alphabet) || alphabet == "All")
            alphabet = string.Empty;
        ScriptManager.RegisterClientScriptBlock(Page, typeof(Page), "searchQueryAlphabet", "var searchedAlphabet = '" + alphabet + "';", true);
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        gridFooter.Visible = CountryGrid.Rows.Count > 0;
    }

    protected string[] GetAlphabetDS()
    {
        string[] alphabet = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "All" };
        return alphabet;
    }

    void AddCountryDialog1_ItemAdded(object sender, EventArgs e)
    {
        CountryGrid.DataBind();
    }

    protected void EditCountryDialog1_ItemUpdated(object sender, EventArgs e)
    {
        DoneEditing();
    }

    protected void EditCountryDialog1_Cancelled(object sender, EventArgs e)
    {
        DoneEditing();
    }

    protected void DoneEditing()
    {
        AddCountryDialog1.Visible = true;
        EditCountryDialog1.Visible = false;
        CountryGrid.EditIndex = -1;
        CountryGrid.DataBind();
    }

    [WebMethod()]
    public static bool DeleteCountries(string[] countryIds)
    {
        List<string> ids = new List<string>();
        IDatabaseSessionManager database = AbleContext.Current.Database;
        database.BeginTransaction();
        foreach (string cid in countryIds)
        {
            CountryDataSource.Delete(cid);
        }
        database.CommitTransaction();
        return true;
    }

    [WebMethod()]
    public static bool DeleteAllCountries(string alphabet)
    {
        IList<Country> countries = CountryDataSource.SearchByName(alphabet + "%");
        IDatabaseSessionManager database = AbleContext.Current.Database;
        database.BeginTransaction();
        foreach (Country country in countries)
        {
            CountryDataSource.Delete(country);
        }
        database.CommitTransaction();
        return true;
    }

    protected void CountryDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        string alphabet = Request.QueryString["c"];
        if (string.IsNullOrEmpty(alphabet) || alphabet == "All")
            alphabet = string.Empty;
        else
            alphabet = alphabet + "%";
        e.InputParameters["name"] = alphabet;
    }
}
}
