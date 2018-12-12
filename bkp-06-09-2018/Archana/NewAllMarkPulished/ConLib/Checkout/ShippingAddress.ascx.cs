namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.ComponentModel;
    using System.Web.UI;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Users;

    [Description("Displays a shipping address")]
    public partial class ShippingAddress : System.Web.UI.UserControl
    {
        public int ShipmentId
        {
            get
            {
                if (this.Shipment != null) return this.Shipment.Id;
                return 0;
            }
            set
            {
                this.Shipment = BasketShipmentDataSource.Load(value);
            }
        }
        
        private BasketShipment Shipment { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Shipment != null)
            {
                Address address = this.Shipment.Address;
                if (address != null)
                {
                    // try to inject edit link into formatted address
                    AddressData.Text = address.ToString(true);
                    int insertIndex = AddressData.Text.IndexOf("<br />");
                    if (insertIndex > -1)
                    {
                        string editUrl = this.Page.ResolveUrl("~/Checkout/ShipAddress.aspx");
                        string editLink = " <span class=\"editLink\"><a href=\"" + editUrl + "\">Change</a></span>";
                        AddressData.Text = AddressData.Text.Insert(insertIndex, editLink);
                    }
                }
            }
        }
    }
}