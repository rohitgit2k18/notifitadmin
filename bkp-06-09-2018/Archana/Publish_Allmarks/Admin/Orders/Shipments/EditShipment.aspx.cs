namespace AbleCommerce.Admin.Orders.Shipments
{
    using System;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Utility;

    public partial class EditShipment : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private OrderShipment _OrderShipment;

        protected void Page_Init(object sender, EventArgs e)
        {
            int shipmentId = AlwaysConvert.ToInt(Request.QueryString["OrderShipmentId"]);
            _OrderShipment = OrderShipmentDataSource.Load(shipmentId);
            if (_OrderShipment == null) Response.Redirect(CancelLink.NavigateUrl);

            // BIND THE ADDRESS
            initAddress();

            // BIND ADDITIONAL DETAILS
            ShipFrom.DataSource = AbleContext.Current.Store.Warehouses;
            ShipFrom.DataBind();
            if (!Page.IsPostBack)
            {
                ListItem selectedItem = ShipFrom.Items.FindByValue(_OrderShipment.WarehouseId.ToString());
                if (selectedItem != null) selectedItem.Selected = true;
            }
            ShipMessage.Text = _OrderShipment.ShipMessage;
            Caption.Text = string.Format(Caption.Text, _OrderShipment.Order.OrderNumber);
            EditShipmentCaption.Text = string.Format(EditShipmentCaption.Text, _OrderShipment.ShipmentNumber);
            CancelLink.NavigateUrl += "?OrderNumber=" + _OrderShipment.Order.OrderNumber.ToString();
            TrackingNumbersLabel.Visible = (_OrderShipment.TrackingNumbers != null && _OrderShipment.TrackingNumbers.Count > 0);
            ShipGateway.DataSource = ShipGatewayDataSource.LoadAll();
            ShipGateway.DataBind();
            trAddTrackingNumber.Visible = (_OrderShipment.TrackingNumbers.Count == 0);
        }

        protected void initAddress()
        {
            ShipToFirstName.Text = _OrderShipment.ShipToFirstName;
            ShipToLastName.Text = _OrderShipment.ShipToLastName;
            ShipToAddress1.Text = _OrderShipment.ShipToAddress1;
            ShipToAddress2.Text = _OrderShipment.ShipToAddress2;
            ShipToCity.Text = _OrderShipment.ShipToCity;
            ShipToProvince.Text = _OrderShipment.ShipToProvince;
            ShipToPostalCode.Text = _OrderShipment.ShipToPostalCode;
            ShipToCountryCode.DataSource = AbleContext.Current.Store.Countries;
            ShipToCountryCode.DataTextField = "Name";
            ShipToCountryCode.DataValueField = "CountryCode";
            ShipToCountryCode.DataBind();
            ShipToCountryCode.SelectedValue = _OrderShipment.ShipToCountryCode;
            ShipToPhone.Text = _OrderShipment.ShipToPhone;
            ShipToCompany.Text = _OrderShipment.ShipToCompany;
            ShipToFax.Text = _OrderShipment.ShipToFax;
            ShipToResidence.SelectedIndex = (AlwaysConvert.ToBool(_OrderShipment.ShipToResidence) ? 0 : 1);
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            // UPDATE ADDRESS
            _OrderShipment.ShipToFirstName = ShipToFirstName.Text;
            _OrderShipment.ShipToLastName = ShipToLastName.Text;
            _OrderShipment.ShipToAddress1 = ShipToAddress1.Text;
            _OrderShipment.ShipToAddress2 = ShipToAddress2.Text;
            _OrderShipment.ShipToCity = ShipToCity.Text;
            _OrderShipment.ShipToProvince = ShipToProvince.Text;
            _OrderShipment.ShipToPostalCode = ShipToPostalCode.Text;
            _OrderShipment.ShipToCountryCode = ShipToCountryCode.SelectedValue;
            _OrderShipment.ShipToPhone = ShipToPhone.Text;
            _OrderShipment.ShipToCompany = ShipToCompany.Text;
            _OrderShipment.ShipToFax = StringHelper.StripHtml(ShipToFax.Text);
            _OrderShipment.ShipToResidence = (ShipToResidence.SelectedIndex == 0);

            int shipgwId = AlwaysConvert.ToInt(ShipGateway.SelectedValue);
            string trackingData = TrackingNumber.Text;
            if (!string.IsNullOrEmpty(trackingData))
            {
                TrackingNumber tnum = new TrackingNumber();
                tnum.TrackingNumberData = trackingData;
                tnum.ShipGatewayId = shipgwId;
                tnum.OrderShipmentId = _OrderShipment.Id;
                _OrderShipment.TrackingNumbers.Add(tnum);
            }

            // UPDATE OTHER DETAILS
            _OrderShipment.WarehouseId = AlwaysConvert.ToInt(ShipFrom.SelectedValue);
            _OrderShipment.ShipMessage = ShipMessage.Text;
            _OrderShipment.Save();
            //DELETE ANY ITEMS WITH A ZERO QUANTITY
            for (int i = _OrderShipment.OrderItems.Count - 1; i >= 0; i--)
            {
                if (_OrderShipment.OrderItems[i].Quantity < 1) _OrderShipment.OrderItems.DeleteAt(i);
            }

            foreach (GridViewRow gvr in TrackingGrid.Rows)
            {
                TextBox trackingNumberData = (TextBox)gvr.Cells[0].FindControl("TrackingNumberData");
                int trackingNumberId = AlwaysConvert.ToInt(TrackingGrid.DataKeys[gvr.RowIndex].Value);
                TrackingNumber trackingNumber = TrackingNumberDataSource.Load(trackingNumberId);
                if (trackingNumber != null && trackingNumberData != null)
                {
                    trackingNumber.TrackingNumberData = trackingNumberData.Text;
                    trackingNumber.Save();
                    Response.Write(".");
                }
            }
            //REDIRECT TO SHIPMENT PAGE
            Response.Redirect(CancelLink.NavigateUrl);
        }
    }
}