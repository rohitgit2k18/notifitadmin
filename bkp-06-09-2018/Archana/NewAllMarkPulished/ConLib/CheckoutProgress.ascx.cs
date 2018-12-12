namespace AbleCommerce.ConLib
{
    using System;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Common;
    using System.ComponentModel;

    [Description("Displays the 4 checkout progress steps dynamically.")]
    public partial class CheckoutProgress : System.Web.UI.UserControl
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            //DETERMINE THE CURRENT PAGE
            string path = Request.Url.AbsolutePath; ;
            int index = path.LastIndexOf("/");
            if (index > -1) path = path.Substring(index + 1);
            path = path.ToLowerInvariant();
            //TURN ON THE APPROPRIATE STAGE
            switch (path)
            {
                case "default.aspx":
                case "createprofile.aspx":
                case "editbilladdress.aspx":
                    Step1.Attributes["class"] = "on";
                    break;
                case "shipaddress.aspx":
                case "shipaddresses.aspx":
                case "shipmethod.aspx":
                    Step2.Attributes["class"] = "on";
                    break;
                case "giftoptions.aspx":
                    Step3.Attributes["class"] = "on";
                    break;
                case "payment.aspx":
                    Step4.Attributes["class"] = "on";
                    break;
            }

            // Gift Wrap LINK ONLY VISIBLE IF THERE IS A PRODUCT IN BASKET HAVING GIFT WRAP OPTIONS AVAILABLE
            bool dislayGiftLink = false;
            Basket basket = AbleContext.Current.User.Basket;
            foreach (BasketItem item in basket.Items)
            {
                if (item.OrderItemType == OrderItemType.Product &&
                    !item.IsChildItem && 
                    item.Shippable != Shippable.No &&
                    item.Product.WrapGroup != null)
                {
                    dislayGiftLink = true;
                    break;
                }
            }
            Step3.Visible = dislayGiftLink;

            // handle guest checkout
            if (AbleContext.Current.User.IsAnonymous)
            {
                Step1Text.NavigateUrl += "?GC=0";
            }

            if (AbleCommerce.Code.PageHelper.IsResponsiveTheme(this.Page))
            {
                PHNavHeader.Visible = true;
                PHNavFooter.Visible = true;
            }
        }
    }
}