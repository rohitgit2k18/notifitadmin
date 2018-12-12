namespace AbleCommerce.Admin.Shipping.Providers
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Shipping;

    public partial class ProviderShipMethods : System.Web.UI.UserControl
    {
        private ShipGateway _ShipGateway;
        public int ShipGatewayId { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            _ShipGateway = ShipGatewayDataSource.Load(this.ShipGatewayId);
            if (!Page.IsPostBack)
            {
                BindShipMethods();
            }
        }

        protected string GetWarehouseNames(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if (method.Warehouses.Count == 0)
            {
                return "All";
            }
            List<string> warehouses = new List<string>();
            foreach (Warehouse warehouse in method.Warehouses)
            {
                warehouses.Add(warehouse.Name);
            }
            string warehouseList = string.Join(", ", warehouses.ToArray());
            if (warehouseList.Length > 100)
            {
                warehouseList = (warehouseList.Substring(0, 100) + "...");
            }
            return warehouseList;
        }

        protected string GetZoneNames(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if (method.ShipZones.Count == 0)
            {
                return "All";
            }
            List<string> zones = new List<string>();
            foreach (ShipZone zone in method.ShipZones)
            {
                zones.Add(zone.Name);
            }
            string zoneList = string.Join(", ", zones.ToArray());
            if (zoneList.Length > 100)
            {
                zoneList = (zoneList.Substring(0, 100) + "...");
            }
            return zoneList;
        }

        protected string GetEditUrl(object dataItem)
        {
            ShipMethod method = (ShipMethod)dataItem;
            if (method.ShipMethodType == ShipMethodType.FlatRate)
            {
                return Page.ResolveUrl("~/Admin/Shipping/Methods/EditShipMethodFixed.aspx?ShipMethodId=" + method.Id.ToString());
            }
            else if (method.ShipMethodType == ShipMethodType.IntegratedProvider)
            {
                return Page.ResolveUrl("~/Admin/Shipping/Methods/EditShipMethodProvider.aspx?ShipMethodId=" + method.Id.ToString());
            }
            return Page.ResolveUrl("~/Admin/Shipping/Methods/EditShipMethodMatrix.aspx?ShipMethodId=" + method.Id.ToString());
        }

        private void BindShipMethods()
        {
            // bind the configured methods
            IList<ShipMethod> configuredMethods = ShipMethodDataSource.LoadForShipGateway(this.ShipGatewayId);
            if (configuredMethods.Count > 0)
            {
                ViewPanel.Visible = true;
                ShipMethodGrid.DataSource = configuredMethods;
                ShipMethodGrid.DataBind();
            }
            else
            {
                ViewPanel.Visible = false;
            }

            // bind the add panel
            ShipMethodList.Items.Clear();
            ListItem[] servicesArray = _ShipGateway.GetProviderInstance().GetServiceListItems();
            foreach (ListItem item in servicesArray)
            {
                bool isConfigured = configuredMethods.Where(x => x.ShipGatewayId == _ShipGateway.Id && x.ServiceCode.Equals(item.Value)).Count() > 0;
                if (!isConfigured)
                {
                    ShipMethodList.Items.Add(item);
                }
            }
            AddPanel.Visible = ShipMethodList.Items.Count > 0;
        }

        protected void AddShipMethodButton_Click(object sender, EventArgs e)
        {
            foreach (ListItem item in ShipMethodList.Items)
            {
                if (item.Selected)
                {
                    ShipMethod method = new ShipMethod();
                    method.ShipMethodType = ShipMethodType.IntegratedProvider;
                    method.ShipGateway = _ShipGateway;
                    method.ServiceCode = item.Value;
                    method.Name = item.Text;
                    method.Save();
                }
            }
            BindShipMethods();
        }

        protected void ShipMethodGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            ShipMethodDataSource.LoadForShipGateway(this.ShipGatewayId).DeleteAt(e.RowIndex);
            BindShipMethods();
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
            BindShipMethods();
        }
    }
}