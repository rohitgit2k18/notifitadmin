using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Common;
using CommerceBuilder.Shipping;
using CommerceBuilder.Utility;
using CommerceBuilder.Extensions;

namespace AbleCommerce.Admin.Shipping.Methods
{
    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private IList<ShipGateway> _ShipProviders;
        private string _IconPath = string.Empty;

        protected void Page_Init(object sender, System.EventArgs e)
        {
            _ShipProviders = ShipGatewayDataSource.LoadAll();
            if (_ShipProviders.Count == 0)
            {
                NoShipProviderMessage.Visible = true;
                IntegratedProviderPanel.Visible = false;
            }
            else
            {
                NoShipProviderMessage.Visible = false;
                IntegratedProviderPanel.Visible = true;
                Provider.DataSource = _ShipProviders;
                Provider.DataBind();
            }
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
            AbleCommerce.Code.PageHelper.SetDefaultButton(AddShipMethodName, AddShipMethodButton.ClientID);
        }

        protected string GetWarehouseNames(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if ((method.Warehouses.Count == 0))
            {
                return "All";
            }
            List<string> warehouses = new List<string>();
            foreach (Warehouse warehouseAssn in method.Warehouses)
            {
                warehouses.Add(warehouseAssn.Name);
            }
            string warehouseList = string.Join(", ", warehouses.ToArray());
            if ((warehouseList.Length > 100))
            {
                warehouseList = (warehouseList.Substring(0, 100) + "...");
            }
            return warehouseList;
        }

        protected string GetZoneNames(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if ((method.ShipZones.Count == 0))
            {
                return "All";
            }
            List<string> zones = new List<string>();
            foreach (ShipZone zoneAssn in method.ShipZones)
            {
                zones.Add(zoneAssn.Name);
            }
            string zoneList = string.Join(", ", zones.ToArray());
            if ((zoneList.Length > 100))
            {
                zoneList = (zoneList.Substring(0, 100) + "...");
            }
            return zoneList;
        }

        protected string GetNames(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if ((method.Groups.Count == 0))
            {
                return "All";
            }
            List<string> groups = new List<string>();
            foreach (CommerceBuilder.Users.Group groupAssn in method.Groups)
            {
                groups.Add(groupAssn.Name);
            }
            string groupList = string.Join(", ", groups.ToArray());
            if ((groupList.Length > 100))
            {
                groupList = (groupList.Substring(0, 100) + "...");
            }
            return groupList;
        }

        protected string GetMinPurchase(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if (method.MinPurchase > 0) return method.MinPurchase.LSCurrencyFormat("lc");
            return string.Empty;
        }

        protected string GetMaxPurchase(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if (method.MaxPurchase > 0) return method.MaxPurchase.LSCurrencyFormat("lc");
            return string.Empty;
        }

        protected string GetEditUrl(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if ((method.ShipMethodType == ShipMethodType.FlatRate))
            {
                return ("EditShipMethodFixed.aspx?ShipMethodId=" + method.Id.ToString());
            }
            else if ((method.ShipMethodType == ShipMethodType.IntegratedProvider))
            {
                return ("EditShipMethodProvider.aspx?ShipMethodId=" + method.Id.ToString());
            }
            return ("EditShipMethodMatrix.aspx?ShipMethodId=" + method.Id.ToString());
        }

        protected void AddShipMethodButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                ShipMethod method = new ShipMethod();
                string selectedMethodType = AddShipMethodType.SelectedValue;
                method.ShipMethodType = ((ShipMethodType)(AlwaysConvert.ToInt16(AddShipMethodType.SelectedValue)));
                method.Name = AddShipMethodName.Text;
                method.Save();
                Response.Redirect(GetEditUrl(method));
            }
        }

        protected ShipGateway GetProvider(int shipGatewayId)
        {
            foreach (ShipGateway provider in _ShipProviders)
            {
                if (provider.Id.Equals(shipGatewayId)) return provider;
            }
            return null;
        }

        protected void Provider_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindServiceCodes();
        }

        private void BindServiceCodes()
        {
            ServiceCode.Items.Clear();
            int shipGatewayId = AlwaysConvert.ToInt(Provider.SelectedValue);
            ShipGateway provider = GetProvider(shipGatewayId);
            if (provider != null)
            {
                IList<ShipMethod> Shipmethods = ShipMethodDataSource.LoadForShipGateway(shipGatewayId);
                ListItem[] servicesArray = provider.GetProviderInstance().GetServiceListItems();
                foreach (ListItem item in servicesArray)
                {
                    ServiceCode.Items.Add(item);
                }
            }
        }

        protected void AddProviderMethod_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                ListItem li = ServiceCode.SelectedItem;
                ShipMethod method = new ShipMethod();
                method.ShipMethodType = ShipMethodType.IntegratedProvider;
                method.ShipGatewayId = AlwaysConvert.ToInt(Provider.SelectedValue);
                method.ServiceCode = li.Value;
                method.Name = li.Text;
                method.Save();
                Response.Redirect("EditShipMethodProvider.aspx?ShipMethodId=" + method.Id.ToString());
            }
        }

        protected string GetConfirmDelete(object obj)
        {
            string name = (string)obj;
            return string.Format("return confirm('Are you sure you want to delete {0}?\')", name.Replace("'", "\\'"));
        }

        protected void MultipleRowDelete_Click(object sender, EventArgs e)
        {
            // Looping through all the rows in the GridView
            foreach (GridViewRow row in ShipMethodGrid.Rows)
            {
                CheckBox checkbox = (CheckBox)row.FindControl("DeleteCheckbox");
                if ((checkbox != null) && (checkbox.Checked))
                {
                    // Retreive the GiftCertificateId
                    int shipMethodId = Convert.ToInt32(ShipMethodGrid.DataKeys[row.RowIndex].Value);
                    ShipMethod sm = ShipMethodDataSource.Load(shipMethodId);
                    if (sm != null) sm.Delete();
                }
            }
            ShipMethodGrid.DataBind();
        }
        protected void ShipMethodGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            IList<ShipMethod> shipMethods = ShipMethodDataSource.LoadAll(ShipMethodGrid.SortExpression);
            if (e.CommandName.StartsWith("Do_"))
            {
                int shipMethodId = AlwaysConvert.ToInt(e.CommandArgument.ToString());
                int index;
                index = shipMethods.IndexOf(shipMethodId);
                switch (e.CommandName)
                {
                    case "Do_Up":
                        ReorderMethod(shipMethods, index, index - 1);
                        ShipMethodGrid.DataBind();
                        break;
                    case "Do_Down":
                        ReorderMethod(shipMethods, index, index + 1);
                        ShipMethodGrid.DataBind();
                        break;
                }
            }
        }

        protected void ReorderMethod(IList<ShipMethod> _ShipMethods, int oldIndex, int newIndex)
        {
            if ((oldIndex < 0) || (oldIndex >= _ShipMethods.Count)) return;
            if ((newIndex < 0) || (newIndex >= _ShipMethods.Count)) return;
            if (oldIndex == newIndex) return;
            //MAKE SURE ITEMS ARE IN CORRECT ORDER
            for (short i = 0; i < _ShipMethods.Count; i++)
                _ShipMethods[i].OrderBy = (short)(i + 1);
            //LOCATE THE DESIRED ITEM
            ShipMethod temp = _ShipMethods[oldIndex];
            _ShipMethods.RemoveAt(oldIndex);
            if (newIndex < _ShipMethods.Count)
                _ShipMethods.Insert(newIndex, temp);
            else
                _ShipMethods.Add(temp);
            //MAKE SURE ITEMS ARE IN CORRECT ORDER
            for (short i = 0; i < _ShipMethods.Count; i++)
                _ShipMethods[i].OrderBy = (short)(i + 1);
            _ShipMethods.Save();
        }
        protected string GetIconUrl(string icon)
        {
            return _IconPath + icon;
        }
    }
}