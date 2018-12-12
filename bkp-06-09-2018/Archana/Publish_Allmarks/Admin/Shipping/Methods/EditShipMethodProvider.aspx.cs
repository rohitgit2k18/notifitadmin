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
using CommerceBuilder.Taxes;

namespace AbleCommerce.Admin.Shipping.Methods
{
public partial class EditShipMethodProvider : CommerceBuilder.UI.AbleCommerceAdminPage
{

    int _ShipMethodId;
    ShipMethod _ShipMethod;

    protected void Page_Init(object sender, System.EventArgs e)
    {
        _ShipMethodId = AlwaysConvert.ToInt(Request.QueryString["ShipMethodId"]);
        _ShipMethod = ShipMethodDataSource.Load(_ShipMethodId);
        if (_ShipMethod == null) RedirectMe();
        //BIND TAX CODES
        IList<TaxCode> taxCodes = AbleContext.Current.Store.TaxCodes;
        TaxCode.DataSource = taxCodes;
        TaxCode.DataBind();
        int taxCodeId = _ShipMethod.TaxCode != null? _ShipMethod.TaxCode.Id:0;
        ListItem item = TaxCode.Items.FindByValue(taxCodeId.ToString());
        if (item != null) TaxCode.SelectedIndex = TaxCode.Items.IndexOf(item);

        SurchargeTaxCode.DataSource = taxCodes;
        SurchargeTaxCode.DataBind();
        item = SurchargeTaxCode.Items.FindByValue(_ShipMethod.SurchargeTaxCodeId.ToString());
        if (item != null) SurchargeTaxCode.SelectedIndex = SurchargeTaxCode.Items.IndexOf(item);
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        Caption.Text = string.Format(Caption.Text, _ShipMethod.Name);
        if (!Page.IsPostBack) {
            Name.Text = _ShipMethod.Name;
            ShipMethodType.Text = _ShipMethod.ShipGateway.Name;
            ServiceCode.Items.AddRange(_ShipMethod.ShipGateway.GetProviderInstance().GetServiceListItems());
            ListItem selected = ServiceCode.Items.FindByValue(_ShipMethod.ServiceCode);
            if (selected != null) selected.Selected = true;
            if (_ShipMethod.Surcharge > 0) Surcharge.Text = string.Format("{0:F2}", _ShipMethod.Surcharge);
            SurchargeMode.SelectedIndex = _ShipMethod.SurchargeModeId;
            SurchargeIsVisible.SelectedIndex = _ShipMethod.SurchargeIsVisible ? 1 : 0;
            UseWarehouseRestriction.SelectedIndex = (_ShipMethod.Warehouses.Count == 0) ? 0 : 1;
            BindWarehouses();
            UseZoneRestriction.SelectedIndex = (_ShipMethod.ShipZones.Count == 0) ? 0 : 1;
            BindZones();
            UseGroupRestriction.SelectedIndex = (_ShipMethod.Groups.Count == 0) ? 0 : 1;
            BindGroups();
            if (_ShipMethod.MinPurchase > 0) MinPurchase.Text = string.Format("{0:F2}", _ShipMethod.MinPurchase);
            if (_ShipMethod.MaxPurchase > 0) MaxPurchase.Text = string.Format("{0:F2}", _ShipMethod.MaxPurchase);
        }
        trSurchargeTaxCode.Visible = _ShipMethod.SurchargeIsVisible;
    }

    protected void RedirectMe()
    {
        Response.Redirect("Default.aspx");
    }

    protected void UseWarehouseRestriction_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindWarehouses();
    }

    protected void BindWarehouses()
    {
        WarehouseListPanel.Visible = (UseWarehouseRestriction.SelectedIndex > 0);
        if (WarehouseListPanel.Visible)
        {
            WarehouseList.DataSource = WarehouseDataSource.LoadAll("Name");
            WarehouseList.DataBind();
            if (WarehouseList.Items.Count > 4) WarehouseList.Rows = 8;
            foreach (Warehouse item in _ShipMethod.Warehouses)
            {
                ListItem listItem = WarehouseList.Items.FindByValue(item.Id.ToString());
                if (listItem != null) listItem.Selected = true;
            }
        }
    }

    protected void UseZoneRestriction_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindZones();
    }

    protected void BindZones()
    {
        ZoneListPanel.Visible = (UseZoneRestriction.SelectedIndex > 0);
        if (ZoneListPanel.Visible)
        {
            ZoneList.DataSource = ShipZoneDataSource.LoadAll("Name");
            ZoneList.DataBind();
            if (ZoneList.Items.Count > 4) ZoneList.Rows = 8;
            foreach (ShipZone item in _ShipMethod.ShipZones)
            {
                ListItem listItem = ZoneList.Items.FindByValue(item.Id.ToString());
                if (listItem != null) listItem.Selected = true;
            }
        }
    }

    protected void UseGroupRestriction_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroups();
    }

    protected void BindGroups()
    {
        GroupListPanel.Visible = (UseGroupRestriction.SelectedIndex > 0);
        if (GroupListPanel.Visible)
        {
            GroupList.DataSource = GroupDataSource.LoadAll("Name");
            GroupList.DataBind();
            foreach (CommerceBuilder.Users.Group item in _ShipMethod.Groups)
            {
                ListItem listItem = GroupList.Items.FindByValue(item.Id.ToString());
                if (listItem != null) listItem.Selected = true;
            }
        }
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        RedirectMe();
    }

    protected void SaveButton_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid) {
            //UPDATE NAME
            _ShipMethod.Name = Name.Text;
            //UPDATE RATE
            _ShipMethod.ServiceCode = ServiceCode.SelectedValue;
            //UPDATE SURCHARGE
            _ShipMethod.Surcharge = AlwaysConvert.ToDecimal(Surcharge.Text);
            if (_ShipMethod.Surcharge < 0) _ShipMethod.Surcharge = 0;
            if (_ShipMethod.Surcharge > 0)
            {
                _ShipMethod.SurchargeMode = (SurchargeMode)AlwaysConvert.ToByte(SurchargeMode.SelectedValue);
                _ShipMethod.SurchargeIsVisible = (SurchargeIsVisible.SelectedIndex > 0);
            }
            else
            {
                _ShipMethod.SurchargeMode = 0;
                _ShipMethod.SurchargeIsVisible = false;
            }
            if (_ShipMethod.SurchargeIsVisible)
            {
                _ShipMethod.SurchargeTaxCodeId = AlwaysConvert.ToInt(SurchargeTaxCode.SelectedValue);
            }
            else _ShipMethod.SurchargeTaxCodeId = 0;

            //UPDATE WAREHOUSES
            _ShipMethod.Warehouses.Clear();
            _ShipMethod.Save();
            if (UseWarehouseRestriction.SelectedIndex > 0)
            {
                foreach (ListItem item in WarehouseList.Items)
                {
                    Warehouse warehouse = WarehouseDataSource.Load(AlwaysConvert.ToInt(item.Value));
                    if (item.Selected) _ShipMethod.Warehouses.Add(warehouse);
                }
            }
            //UPDATE ZONES
            _ShipMethod.ShipZones.Clear();
            _ShipMethod.Save();
            if (UseZoneRestriction.SelectedIndex > 0)
            {
                foreach (ListItem item in ZoneList.Items)
                {
                    ShipZone shipZone = ShipZoneDataSource.Load(AlwaysConvert.ToInt(item.Value));
                    if (item.Selected) _ShipMethod.ShipZones.Add(shipZone);
                }
            }
            //UPDATE ROLES
            _ShipMethod.Groups.Clear();
            if (UseGroupRestriction.SelectedIndex > 0)
            {
                foreach (ListItem item in GroupList.Items)
                {
                    CommerceBuilder.Users.Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                    if (item.Selected) _ShipMethod.Groups.Add(group);
                }
            }
            //UPDATE MIN PURCHASE
            _ShipMethod.MinPurchase = AlwaysConvert.ToDecimal(MinPurchase.Text);
            //UPDATE MIN PURCHASE
            _ShipMethod.MaxPurchase = AlwaysConvert.ToDecimal(MaxPurchase.Text);
            //UPDATE TAX CODES
            _ShipMethod.TaxCode = TaxCodeDataSource.Load(AlwaysConvert.ToInt(TaxCode.SelectedValue));
            //SAVE METHOD AND REDIRECT TO LIST
            _ShipMethod.Save();
            RedirectMe();
        }
    }

    protected void SurchargeIsVisible_SelectedIndexChanged(object sender, EventArgs e)
    {
        trSurchargeTaxCode.Visible = SurchargeIsVisible.SelectedIndex == 1;
    }

}
}
