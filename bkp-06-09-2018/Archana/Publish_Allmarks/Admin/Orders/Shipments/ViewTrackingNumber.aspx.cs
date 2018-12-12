namespace AbleCommerce.Admin.Orders.Shipments
{
    using System.Web.UI;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Shipping.Providers;
    using CommerceBuilder.Utility;

    public partial class ViewTrackingNumber : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        int _TrackingNumberId = 0;
        TrackingNumber _TrackingNumber;

        int TrackingNumberId
        {
            get
            {
                if (_TrackingNumberId.Equals(0))
                {
                    _TrackingNumberId = AlwaysConvert.ToInt(Request.QueryString["TrackingNumberId"]);
                }
                return _TrackingNumberId;
            }
        }

        TrackingNumber TrackingNumber
        {
            get
            {
                if ((_TrackingNumber == null))
                {
                    _TrackingNumber = TrackingNumberDataSource.Load(TrackingNumberId);
                }
                return _TrackingNumber;
            }
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (TrackingNumber == null)
            {
                Response.Redirect("../Default");
            }
            if (!Page.IsPostBack)
            {
                // ATTEMPT TO GET TRACKING DETAILS
                TrackingNumberData.Text = TrackingNumber.TrackingNumberData;
                if (TrackingNumber.ShipGateway != null)
                {
                    CommerceBuilder.Shipping.Providers.IShippingProvider provider = TrackingNumber.ShipGateway.GetProviderInstance();
                    CommerceBuilder.Shipping.Providers.TrackingSummary summary = provider.GetTrackingSummary(TrackingNumber);
                    if (summary != null)
                    {
                        // TRACKING DETAILS FOUND
                        if (summary.TrackingResultType == TrackingResultType.InlineDetails)
                        {
                            OrderShipment myShipment = TrackingNumber.OrderShipment;
                            Order myOrder = myShipment.Order;
                            int myShipmentNumber = (myOrder.Shipments.IndexOf(myShipment.Id) + 1);
                            Caption.Text = string.Format(Caption.Text, myOrder.Id);
                            ShipmentNumber.Text = string.Format(ShipmentNumber.Text, myShipmentNumber, myOrder.Shipments.Count);
                            ShippingMethod.Text = myShipment.ShipMethodName;
                            PackageCount.Text = summary.PackageCollection.Count.ToString();
                            PackageList.DataSource = summary.PackageCollection;
                            PackageList.DataBind();

                            DetailsPanel.Visible = true;
                            LinkPanel.Visible = false;
                        }
                        else if (summary.TrackingResultType == TrackingResultType.ExternalLink)
                        {
                            TrackingLink.NavigateUrl = summary.TrackingLink;
                            TrackingLink.Text = summary.TrackingLink;

                            DetailsPanel.Visible = false;
                            LinkPanel.Visible = true;
                        }
                    }
                }
            }
        }
    }
}