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

namespace AbleCommerce.Admin.People.Manufacturers
{
public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
{
    int _ManufacturerId = 0;
    Manufacturer _Manufacturer;

    protected void AddManufacturerButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            Manufacturer manufacturer = ManufacturerDataSource.LoadForName(AddManufacturerName.Text,false);
            // MANUFACTURER NAME SHOULD BE UNIQUE
            if (manufacturer != null)
            {
                AddManufacturerNameRequired.IsValid = false;
                AddManufacturerNameRequired.ErrorMessage = "The manufacturer with name \"" + AddManufacturerName.Text + "\" already exists.";
                return;
            }
            manufacturer = new Manufacturer();
            manufacturer.Name = AddManufacturerName.Text;
            manufacturer.Save();
            AddManufacturerName.Text = String.Empty;
            AddedMessage.Text = string.Format((string)ViewState["AddedMessage.Text"], manufacturer.Name);
            AddedMessage.Visible = true;
            ManufacturerGrid.DataBind();
            SearchAjax.Update();
        }
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        AbleCommerce.Code.PageHelper.SetDefaultButton(AddManufacturerName, AddManufacturerButton.ClientID);
        AddManufacturerName.Focus();
        if (!Page.IsPostBack) ViewState["AddedMessage.Text"] = AddedMessage.Text;      
    }

    private Dictionary<int, int> _ProductCounts = new Dictionary<int, int>();
    protected int GetProductCount(object dataItem)
    {
        Manufacturer m = (Manufacturer)dataItem;
        if (_ProductCounts.ContainsKey(m.Id)) return _ProductCounts[m.Id];
        int count = ProductDataSource.CountForManufacturer(m.Id);
        _ProductCounts[m.Id] = count;
        return count;
    }
    
    protected bool HasProducts(object dataItem)
    {
        Manufacturer m = (Manufacturer)dataItem;
        return (ProductDataSource.CountForManufacturer(m.Id) > 0);
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        AlphabetRepeater.DataSource = GetAlphabetDS();
        AlphabetRepeater.DataBind();
    }

    protected void AlphabetRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
    {
        if ((e.CommandArgument.ToString().Length == 1))
        {
            SearchText.Text = (e.CommandArgument.ToString());
        }
        else
        {
            SearchText.Text = String.Empty;
        }
        ManufacturerGrid.DataBind();
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        ManufacturerGrid.DataBind();
    }

    protected void ManufacturerGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.Equals("EditManufacturer"))
        {
            string[] data = ((string)e.CommandArgument).Split(':');
            _ManufacturerId = AlwaysConvert.ToInt(data[0]);
            HiddenManufacturerId.Value = _ManufacturerId.ToString();
            _Manufacturer = ManufacturerDataSource.Load(_ManufacturerId);
            Name.Text = _Manufacturer.Name;
            ModalPopupExtender.Show();
            EditAjax.Update();
        }
    }

    protected string[] GetAlphabetDS()
    {
        string[] alphabet = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "All" };
        return alphabet;
    }
    protected void SaveButton_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid)
        {
            SaveManufacturer();
        }

        ModalPopupExtender.Hide();
        EditAjax.Update();
        ManufacturerGrid.DataBind();
        SearchAjax.Update();
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        ModalPopupExtender.Hide();
    }

    private void SaveManufacturer()
    {
        _ManufacturerId = AlwaysConvert.ToInt(HiddenManufacturerId.Value);
        _Manufacturer = ManufacturerDataSource.Load(_ManufacturerId);
        _Manufacturer.Name = Name.Text;
        _Manufacturer.Save();
    }
}
}
