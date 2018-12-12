namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.ComponentModel;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    [Description("Implements the affiliate tracking using configured affiliate traking url")]
    public partial class AffiliateTracker : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // only proceed if a valid and recent order is presented
            if (this.Order != null && this.Order.OrderDate < LocaleHelper.LocalNow.AddMinutes(10))
            {
                // see whether we have a tracking url to render
                string url = AbleContext.Current.Store.Settings.AffiliateTrackerUrl;
                if (!string.IsNullOrEmpty(url))
                {
                    // UPDATE DYNAMIC VARIABLES IN URL
                    url = url.Replace("[OrderId]", this.Order.Id.ToString());
                    url = url.Replace("[OrderNumber]", this.Order.OrderNumber.ToString());
                    url = url.Replace("[OrderTotal]", this.Order.TotalCharges.ToString("F2"));
                    url = url.Replace("[OrderSubTotal]", this.Order.Items.TotalPrice(OrderItemType.Product, OrderItemType.Discount, OrderItemType.Coupon).ToString("F2"));

                    // CREATE THE IMAGE CONTROL
                    HtmlImage img = new HtmlImage();
                    img.Src = url;
                    img.Border = 0;
                    img.Height = 1;
                    img.Width = 1;

                    // ADD IMAGE CONTROL TO PAGE
                    phAffiliateTracker.Controls.Add(img);
                }
            }
        }
    }
}