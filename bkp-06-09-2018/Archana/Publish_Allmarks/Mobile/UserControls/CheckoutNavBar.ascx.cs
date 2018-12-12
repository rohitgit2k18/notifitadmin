namespace AbleCommerce.Mobile.UserControls
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using AbleCommerce.Code;
    using CommerceBuilder.Utility;
    using System.Web.UI.HtmlControls;
    using System.Web.UI;
    
    public partial class CheckoutNavBar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //
        }

        private void SetCssClass(HtmlGenericControl control, string value)
        {
            control.Attributes.Remove("class");
            control.Attributes.Add("class", value);
        }

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            string billingUrl = Page.ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/Checkout/EditBillAddress.aspx"));
            string shippingUrl = Page.ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/Checkout/ShipMethod.aspx"));

            PageType pageType = GetPageType();
            switch (pageType)
            {
                case PageType.Billing:
                    SetCssClass(BillingNav, "current");
                    SetCssClass(ShippingNav, "next");
                    SetCssClass(PaymentNav, "next last");
                    break;
                case PageType.Shipping:
                    SetCssClass(BillingNav, "previous");                    
                    BillingNav.Controls.Clear();
                    BillingNav.Controls.Add(new LiteralControl(string.Format("<a href=\"{0}\">billing</a>", billingUrl)));
                    SetCssClass(ShippingNav, "current");
                    SetCssClass(PaymentNav, "next last");
                    break;
                case PageType.Payment:
                    SetCssClass(BillingNav, "previous");                    
                    BillingNav.Controls.Clear();
                    BillingNav.Controls.Add(new LiteralControl(string.Format("<a href=\"{0}\">billing</a>", billingUrl)));                    
                    SetCssClass(ShippingNav, "previous");
                    ShippingNav.Controls.Clear();
                    ShippingNav.Controls.Add(new LiteralControl(string.Format("<a href=\"{0}\">shipping</a>", shippingUrl)));
                    SetCssClass(PaymentNav, "current last");
                    break;
                case PageType.Unknown:
                    this.Controls.Clear();
                    break;
            }
        }

        private PageType GetPageType()
        {
            string fileName = System.IO.Path.GetFileName(Request.CurrentExecutionFilePath);
            if (string.IsNullOrEmpty(fileName)) return PageType.Unknown;
            fileName = fileName.ToLowerInvariant().Trim();
            switch (fileName)
            {
                case "editbilladdress.aspx":
                    return PageType.Billing;
                case "editshipaddress.aspx":
                    return PageType.Shipping;
                case "shipaddress.aspx":
                    return PageType.Shipping;
                case "giftoptions.aspx":
                    return PageType.Shipping;
                case "shipmethod.aspx":
                    return PageType.Shipping;
                case "payment.aspx":
                    return PageType.Payment;
                default:
                    return PageType.Unknown;
            }
        }

        private enum PageType
        {
            Billing = 0,
            Shipping = 1,
            Payment = 3,
            Unknown = 4,
        }

    }

}
